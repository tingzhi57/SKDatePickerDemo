//
//  SKDatePickerView.m
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import "SKDatePickerView.h"
#import "SKDatePickerDayView.h"
#import "SKDatePickerWeekLabelsView.h"
#import "SKDatePickerMonthView.h"
#import "SKDatePickerManager.h"
#import "NSLayoutConstraint+SKConstraint.h"
#import "SKDatePickerContentControll.h"
#import "NSDate+SKDateCategory.h"
#import "SKSelectedDatetimeField.h"

@interface SKDatePickerView()

@property (nonatomic, strong) SKDatePickerWeekLabelsView* weekdaysView;
@property (nonatomic, strong) SKDatePickerContentControll* contentController;
@property (nonatomic,strong) UIButton* nextYearButton;
@property (nonatomic,strong) UIButton* previousYearButton;
@property (nonatomic,strong) UIButton* nextMonthButton;
@property (nonatomic,strong) UIButton* previousMonthButton;
@property (nonatomic,strong) UILabel* dateLabel;
@property (nonatomic,strong) UIView* topToolBar;
@property (nonatomic,strong) SKSelectedDatetimeField* datetimeField;
@property (nonatomic,strong) NSDateFormatter  * dateFormatter;
@property (nonatomic, strong) NSDate* startDateToPresent;
@property (nonatomic, strong) NSDate* endDateToPresent;

@end

@implementation SKDatePickerView
#pragma mark - Initialization
-(instancetype)init
{
    self = [super init];
    [self basicInit];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    [self basicInit];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self basicInit];
    return self;
}

-(void)setDelegate:(id<SKDatePickerViewDelegate>)delegate
{
    _delegate = delegate;
    [self commonInit];
}

-(void)basicInit
{
    //initialize datePickerManager
    if (_manager == nil)
    {
        _manager = [[SKDatePickerManager alloc] initWithPickerView:self];
    }
}

-(void)commonInit
{
    //initialize contentController with preferred (or current) date
    if (_dateToPresent == nil)
    {
        if ([self.delegate respondsToSelector:@selector(dateToShow)] && [self.delegate dateToShow])
        {
            NSDate* date = [self shouldDatetimeField] ? [self.delegate dateToShow] : [[self.delegate dateToShow] stripped];
            _dateToPresent = date;
        }
        else if(self.startDateToPresent)
        {
            _dateToPresent = self.startDateToPresent;
        }
        else
            _dateToPresent = [[NSDate date] stripped];
    }
    
    UIView* containerView = [UIView new];
    [self addSubview:containerView];
    
    [NSLayoutConstraint addEqualToConstraints:containerView superView:self attributes:@[@(NSLayoutAttributeCenterX),@(NSLayoutAttributeTop)]];
    
    [NSLayoutConstraint addLessOrEqualToConstraints:containerView superView:self attributes:@[@(NSLayoutAttributeWidth),@(NSLayoutAttributeHeight),@(NSLayoutAttributeBottom)]];
    
    NSMutableArray<NSLayoutConstraint *>* active_constrains = [NSMutableArray array];
    NSLayoutConstraint * l_constrain = [containerView.leftAnchor constraintEqualToAnchor:self.leftAnchor];
    l_constrain.priority = UILayoutPriorityDefaultHigh;
    [active_constrains addObject:l_constrain];

    NSLayoutConstraint * r_constrain = [containerView.rightAnchor constraintEqualToAnchor:self.rightAnchor];
    r_constrain.priority = UILayoutPriorityDefaultHigh;
    [active_constrains addObject:r_constrain];
    /*
     The ratio of height vs width,
     contentController has 1:1 ratio firstly.
     week day labels has rowViewHeightRatio value.
     topbar and datefield has the same value as weekday label view if they need show.
     */
    float totalHeightRatio = 1.0f + [self rowViewHeightRatio];
    if ([self shouldShowTopToolBar])
    {
        totalHeightRatio += [self rowViewHeightRatio];
    }
    float datetimeRatio = [self rowViewHeightRatio];
    if ([self shouldDatetimeField])
    {
        totalHeightRatio += datetimeRatio;
    }
    NSLayoutConstraint * w_constrain = [containerView.heightAnchor constraintEqualToAnchor:containerView.widthAnchor multiplier:totalHeightRatio];
    
//    w_constrain.priority = UILayoutPriorityDefaultHigh;
    [active_constrains addObject:w_constrain];
    
    
    
    if (self.topToolBar == nil)
    {
        self.topToolBar = [UIView new];
        [containerView addSubview:self.topToolBar];
        [NSLayoutConstraint addEqualToConstraints:self.topToolBar superView:containerView attributes:@[@(NSLayoutAttributeLeft),@(NSLayoutAttributeRight),@(NSLayoutAttributeTop)]];
       // [active_constrains addObject:[self.topToolBar.topAnchor constraintEqualToAnchor:self.datetimeField.bottomAnchor]];
    }
    
    if ([self shouldShowTopToolBar])
    {
        [active_constrains addObject:[self.topToolBar.heightAnchor constraintEqualToAnchor:containerView.heightAnchor multiplier:[self rowViewHeightRatio]]];
        
        [self setupTopToolBar:active_constrains];
    }
    else
    {
        [active_constrains addObject:[self.topToolBar.heightAnchor constraintEqualToConstant:0]];
    }
    
    if (self.contentController == nil)
    {
        self.contentController = [[SKDatePickerContentControll alloc] initWithPickerView:self frame:self.bounds presentedDate:self.dateToPresent];
        self.contentController.startDate = self.startDateToPresent;
        self.contentController.endDate = self.endDateToPresent;
        
        //add scrollView
        [containerView addSubview:self.contentController.scrollView];
        
        [NSLayoutConstraint addEqualToConstraints:self.contentController.scrollView superView:containerView attributes:@[@(NSLayoutAttributeLeft),@(NSLayoutAttributeRight)]];
        if (self.startDateToPresent != nil || self.endDateToPresent != nil)
        {
            [self.contentController reSelectPeriodDays];
        }
    }

    
    //create and add weekdayView
    if (self.weekdaysView == nil)
    {
        self.weekdaysView = [[SKDatePickerWeekLabelsView alloc] initWithPickerView:self];
        [containerView addSubview:self.weekdaysView];
        [NSLayoutConstraint addEqualToConstraints:self.weekdaysView superView:containerView attributes:@[@(NSLayoutAttributeLeft),@(NSLayoutAttributeRight)]];
    }
    else
    {
        [self.weekdaysView setNeedsDisplay];
    }
    
//    NSLayoutConstraint * hw_constrain = [self.contentController.scrollView.widthAnchor constraintEqualToAnchor:self.contentController.scrollView.heightAnchor multiplier:1.4f];
//    hw_constrain.priority = UILayoutPriorityDefaultHigh;
//    [active_constrains addObject:hw_constrain];
    
//    [[self.contentController.scrollView.heightAnchor constraintLessThanOrEqualToAnchor:self.weekdaysView.heightAnchor multiplier:6.0f] setActive:YES];
    
    
    
    if(self.datetimeField == nil)
    {
        self.datetimeField = [SKSelectedDatetimeField new];
        [containerView addSubview:self.datetimeField];
        [NSLayoutConstraint addEqualToConstraints:self.datetimeField superView:containerView attributes:@[@(NSLayoutAttributeLeft),@(NSLayoutAttributeRight),@(NSLayoutAttributeBottom)]];
    }
    
    [active_constrains addObject:[self.contentController.scrollView.bottomAnchor constraintEqualToAnchor:self.datetimeField.topAnchor]];
    
    if ([self shouldDatetimeField])
    {
        [active_constrains addObject:[self.datetimeField.heightAnchor constraintEqualToAnchor:containerView.heightAnchor multiplier:datetimeRatio]];
        [active_constrains addObject:[self.datetimeField.widthAnchor constraintEqualToAnchor:containerView.widthAnchor]];
        
        [active_constrains addObject:[self.datetimeField.topAnchor constraintEqualToAnchor:self.contentController.scrollView.bottomAnchor]];
        
        [self.datetimeField setupUI:self otherContraints:active_constrains];
        self.datetimeField.hidden = NO;
        
        if ([self shouldContinueSelection])
            [self presentStartDate:self.startDateToPresent endDate:self.endDateToPresent];
        else
            [self presentDate:self.dateToPresent];
    }
    else
    {
        [active_constrains addObject:[self.datetimeField.heightAnchor constraintEqualToConstant:0]];
        self.datetimeField.hidden = YES;
    }
    
    [active_constrains addObject:[self.weekdaysView.heightAnchor constraintEqualToAnchor:containerView.heightAnchor multiplier:[self rowViewHeightRatio]]];
    
   // [active_constrains addObject:[self.weekdaysView.widthAnchor constraintEqualToAnchor:self.weekdaysView.heightAnchor multiplier:7.0f]];
    
    
    
    [active_constrains addObject:[self.contentController.scrollView.topAnchor constraintEqualToAnchor:self.weekdaysView.bottomAnchor]];
    
    
    [active_constrains addObject:[self.contentController.scrollView.topAnchor constraintEqualToAnchor:self.weekdaysView.bottomAnchor]];
    
    
    [active_constrains addObject:[self.weekdaysView.topAnchor constraintEqualToAnchor:self.topToolBar.bottomAnchor]];
    
    
//    [active_constrains addObject:[self.contentController.scrollView.bottomAnchor constraintLessThanOrEqualToAnchor:containerView.bottomAnchor]];
    [NSLayoutConstraint activateConstraints:active_constrains];
}

-(NSCalendar *)calendar
{
    return self.manager.calendar;
}

-(void)presentDate:(nonnull NSDate*)date
{
    if (date != nil)
    {
        NSDate* stripDate = [self shouldDatetimeField] ? date : [date stripped];
        if (_dateToPresent == nil)
        {
            _dateToPresent = stripDate;
        }
        
        [self.datetimeField notifyDateChanged:self.dateToPresent];
        [self.datetimeField notifyTimeChanged:self.dateToPresent];
    }
}

-(void)presentStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
{
    if (startDate != nil && endDate != nil)
    {
        NSDate* stripSDate = [self shouldDatetimeField] ? startDate : [startDate stripped];
        NSDate* stripEDate = [self shouldDatetimeField] ? endDate : [endDate stripped];
        self.startDateToPresent = [stripSDate earlierDate:stripEDate];
        self.endDateToPresent = [stripEDate laterDate:stripSDate];
        if (_dateToPresent == nil)
        {
            _dateToPresent = self.startDateToPresent;
        }
        if (self.contentController)
        {
            self.contentController.startDate = self.startDateToPresent;
            self.contentController.endDate = self.endDateToPresent;
            [self.contentController reload:self.startDateToPresent];
            [self setNeedsLayout];
        }
         
        [self.datetimeField notifyPeriodDateChanged:self.startDateToPresent to:self.endDateToPresent];
        [self.datetimeField notifyPeriodTimeChanged:self.startDateToPresent to:self.endDateToPresent];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.superview endEditing:YES];
    if ([self shouldDatetimeField])
    {
        [self.datetimeField endEditing:YES];
    }
}
#pragma mark - Delegate methods
-(CGFloat)rowViewHeightRatio
{
    if ([self.delegate respondsToSelector:@selector(rowViewHeightRatio)])
    {
        return  [self.delegate rowViewHeightRatio];
    }
    return 0.1f;
}

-(BOOL)dateIsSelectable:(NSDate*)date
{
    if ([self.delegate respondsToSelector:@selector(shouldAllowSelectionOfDay:)])
    {
        return [self.delegate shouldAllowSelectionOfDay:date];
    }
    return TRUE;
}

-(void)setSelectedDateView:(SKDatePickerDayView *)selectedDateView
{
    //For single selection or startDate is nil
    if (![self shouldContinueSelection])
    {
        [_selectedDateView deselect];
        _selectedDateView = selectedDateView;
        [_selectedDateView select];
        if ([self shouldDatetimeField])
        {
            NSUInteger hour,minute,second;
            [_dateToPresent getHour:&hour minute:&minute second:&second];
            _dateToPresent = [selectedDateView.date updateHour:hour minute:minute second:second];
        }
        else
            _dateToPresent = selectedDateView.date;
    }
    else
    {
        BOOL result = [self.contentController calculateStartDateAndEndDate:selectedDateView.date];
        if (result)
        {
            [self.contentController reSelectPeriodDays];
        }
        else if([self.delegate respondsToSelector:@selector(warningSelectTooLargeScope)])
        {
            [self.delegate warningSelectTooLargeScope];
        }
    }
}

-(void)didTapReloadDateButton:(UIButton*)button
{
    [self.superview endEditing:YES];
    if (self.nextMonthButton == button)
    {
        [self loadNextMonth];
    }
    else if (self.previousMonthButton == button)
    {
        [self loadPreviousMonth];
    }
    else if (self.nextYearButton == button)
    {
        [self loadNextYear];
    }
    else if (self.previousYearButton == button)
    {
        [self loadPreviousYear];
    }
}

-(void)didTapDayView:(SKDatePickerDayView *)dayView
{
    self.selectedDateView = dayView;
    if (![self shouldContinueSelection])
    {
        if ([self shouldDatetimeField])
        {
            [self.datetimeField notifyDateChanged:dayView.date];
            [self.delegate didSelectDay:self.datetimeField.dateAndTime];
        }
        else
            [self.delegate didSelectDay:dayView.date];
    }
}

-(void)setPresentedMonthView:(SKDatePickerMonthView *)presentedMonthView
{
    _presentedMonthView = presentedMonthView;
    if ([self.delegate respondsToSelector:@selector(didPresentOtherMonth:)])
    {
        [self.delegate didPresentOtherMonth:presentedMonthView];
    }
    self.dateLabel.text = [self.dateFormatter stringFromDate:presentedMonthView.date];
    [self layoutIfNeeded];
}

-(NSInteger)firstWeekDay
{
    return [self.manager startdayOfWeek];
}

-(void)didSelectContinueDayFrom:(NSDate*)start to:(NSDate*)end
{
    NSDate* startDate = start;
    NSDate* endDate = end;
    
    if ([self shouldDatetimeField])
    {
        [self.datetimeField notifyPeriodDateChanged:start to:end];
        startDate = self.datetimeField.dateAndTime;
        endDate = self.datetimeField.endDateAndTime;
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectContinueDayFrom:toEnd:)])
    {
        [self.delegate didSelectContinueDayFrom:startDate toEnd:endDate];
    }
}

#pragma mark - Public methods
///scrolls the next month into the visible area and creates an new 'next' month waiting in line.
-(void)loadNextMonth
{
    NSDate* nextMonthDate = [self.dateToPresent nextMonthDate];
    [self.contentController presentNextView];
    _dateToPresent = nextMonthDate;
}

///scrolls the previous month into the visible area and creates an new 'previous' month waiting in line.
-(void)loadPreviousMonth
{
    NSDate* previousMonthDate = [self.dateToPresent previousMonthDate];
    [self.contentController presentPreviousView];
    _dateToPresent = previousMonthDate;
}

-(void)loadNextYear
{
    NSDate* nextYearDate = [self.dateToPresent nextYearDate];
    [self.contentController reload:nextYearDate];
    _dateToPresent = nextYearDate;
}

-(void)loadPreviousYear
{
    NSDate* previousYearDate = [self.dateToPresent previousYearDate];
    [self.contentController reload:previousYearDate];
    _dateToPresent = previousYearDate;
}

-(BOOL)shouldContinueSelection
{
    if ([self.delegate respondsToSelector:@selector(shouldContinueSelection)])
    {
        return [self.delegate shouldContinueSelection];
    }
    return NO;
}

-(BOOL)shouldShowMonthOutDates
{
    if ([self.delegate respondsToSelector:@selector(shouldShowMonthOutDates)])
    {
        return [self.delegate shouldShowMonthOutDates];
    }
    return NO;
}

-(NSDate*)periodStartDate
{
    return self.contentController.startDate;
}

-(NSDate*)periodEndDate
{
    return self.contentController.endDate;
}

#pragma mark - Top tool bar
-(BOOL)shouldShowTopToolBar
{
    if ([self.delegate respondsToSelector:@selector(shouldHideTopToolBar)])
    {
        return ![self.delegate shouldHideTopToolBar];
    }
    return YES;
}

-(void)setupTopToolBar:(NSMutableArray<NSLayoutConstraint *>*)otherActiveConstraints
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    if ([self.delegate respondsToSelector:@selector(monthFormatString)])
    {
        [self.dateFormatter setDateFormat:[self.delegate monthFormatString]];
    }else
        [self.dateFormatter setDateFormat:@"MMM yyyy"];
    if ([self.delegate respondsToSelector:@selector(preferredLocal)])
    {
        self.dateFormatter.locale = [self.delegate preferredLocal];
    }
    // Setup previousMonthButton
    self.previousMonthButton = [UIButton new];
    [self.previousMonthButton setTitle:@" < " forState:UIControlStateNormal];
    
    [self.previousMonthButton addTarget:self action:@selector(didTapReloadDateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.topToolBar addSubview:self.previousMonthButton];
    [NSLayoutConstraint addEqualToConstraints:self.previousMonthButton superView:self.topToolBar attributes:@[@(NSLayoutAttributeBottom),@(NSLayoutAttributeTop)]];

    [otherActiveConstraints addObject:[self.previousMonthButton.widthAnchor constraintEqualToAnchor:self.previousMonthButton.heightAnchor]];
    
    self.previousYearButton = [UIButton new];
    [self.previousYearButton setTitle:@"<<" forState:UIControlStateNormal];
    [self.previousYearButton addTarget:self action:@selector(didTapReloadDateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.topToolBar addSubview:self.previousYearButton];
    [NSLayoutConstraint addEqualToConstraints:self.previousYearButton superView:self.topToolBar attributes:@[@(NSLayoutAttributeBottom),@(NSLayoutAttributeLeft),@(NSLayoutAttributeTop)]];

    [otherActiveConstraints addObject:[self.previousYearButton.widthAnchor constraintEqualToAnchor:self.previousYearButton.heightAnchor]];
    
    [otherActiveConstraints addObject:[self.previousYearButton.rightAnchor constraintEqualToAnchor:self.previousMonthButton.leftAnchor]];

    // Setup nextMonthButton
    self.nextMonthButton = [UIButton new];
    [self.nextMonthButton setTitle:@" > " forState:UIControlStateNormal];
    
    [self.nextMonthButton addTarget:self action:@selector(didTapReloadDateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.topToolBar addSubview:self.nextMonthButton];

    [NSLayoutConstraint addEqualToConstraints:self.nextMonthButton superView:self.topToolBar attributes:@[@(NSLayoutAttributeBottom),@(NSLayoutAttributeTop)]];

    [otherActiveConstraints addObject:[self.nextMonthButton.widthAnchor constraintEqualToAnchor:self.nextMonthButton.heightAnchor]];
    
    // Setup nextYearButton
    self.nextYearButton = [UIButton new];
    [self.nextYearButton setTitle:@">>" forState:UIControlStateNormal];
    [self.nextYearButton addTarget:self action:@selector(didTapReloadDateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.topToolBar addSubview:self.nextYearButton];

    [NSLayoutConstraint addEqualToConstraints:self.nextYearButton superView:self.topToolBar attributes:@[@(NSLayoutAttributeBottom),@(NSLayoutAttributeRight),@(NSLayoutAttributeTop)]];
    [otherActiveConstraints addObject:[self.nextYearButton.widthAnchor constraintEqualToAnchor:self.nextYearButton.heightAnchor]];

    [otherActiveConstraints addObject:[self.nextYearButton.leftAnchor constraintEqualToAnchor:self.nextMonthButton.rightAnchor]];
    
    if ([self.delegate respondsToSelector:@selector(colorForTopbarBackground)])
    {
        self.topToolBar.backgroundColor = [self.delegate colorForTopbarBackground];
    }

    // Setup dateLabel
    self.dateLabel = [UILabel new];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    if ([self.delegate respondsToSelector:@selector(fontForTopbarText)])
    {
        self.dateLabel.font = [self.delegate fontForTopbarText];
    }
    
    if ([self.delegate respondsToSelector:@selector(colorForTopbarText)])
    {
        self.dateLabel.textColor = [self.delegate colorForTopbarText];
    }
    [self.topToolBar addSubview:self.dateLabel];
    
    [NSLayoutConstraint addEqualToConstraints:self.dateLabel superView:self.topToolBar attributes:@[@(NSLayoutAttributeBottom),@(NSLayoutAttributeTop)]];
    
    [otherActiveConstraints addObject:[self.dateLabel.leftAnchor constraintEqualToAnchor:self.previousMonthButton.rightAnchor]];

    [otherActiveConstraints addObject:[self.dateLabel.rightAnchor constraintEqualToAnchor:self.nextMonthButton.leftAnchor]];
    
    [self.previousMonthButton setTitleColor:self.dateLabel.textColor forState:UIControlStateNormal];
    [self.nextMonthButton setTitleColor:self.dateLabel.textColor forState:UIControlStateNormal];
}

#pragma mark - Datetime field
-(BOOL)shouldDatetimeField
{
    if ([self.delegate respondsToSelector:@selector(shouldShowTimeField)])
    {
        return [self.delegate shouldShowTimeField];
    }
    return NO;
}

-(TimeFiledFormat)timeFiledFormat
{
    if ([self.delegate respondsToSelector:@selector(timeFiledFormat)])
    {
        return [self.delegate timeFiledFormat];
    }
    return TimeFormat_HMS;
}

#pragma mark - Colors
-(UIColor*)colorForDayLabelInMonth
{
    if ([self.delegate respondsToSelector:@selector(colorForDayLabelInMonth)])
    {
        return [self.delegate colorForDayLabelInMonth];
    }
    return nil;
}

-(UIColor*)colorForUnavaibleDay
{
    if ([self.delegate respondsToSelector:@selector(colorForUnavaibleDay)])
    {
        return [self.delegate colorForUnavaibleDay];
    }
    
    return [UIColor lightGrayColor];
}
@end
