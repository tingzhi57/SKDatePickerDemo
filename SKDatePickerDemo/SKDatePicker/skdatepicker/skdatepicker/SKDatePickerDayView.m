//
//  SKDatePickerDayView.m
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import "SKDatePickerDayView.h"
#import "SKDatePickerWeekView.h"
#import "SKDatePickerMonthView.h"
#import "SKDatePickerSelectionView.h"
#import "SKDatePickerView.h"
#import "SKDate.h"
#import "NSLayoutConstraint+SKConstraint.h"
#import "NSDate+SKDateCategory.h"

@interface SKDatePickerDayView()
@property (nonatomic, retain) SKDate* dayInfo;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, weak) SKDatePickerWeekView* weekView;
@property (nonatomic, weak) SKDatePickerMonthView* monthView;
@property (nonatomic, weak) SKDatePickerSelectionView* selectionView;

@property (nonatomic, assign) UITapGestureRecognizer* tapGesture;
@property (nonatomic, retain) UILabel* textLabel;
@end

@implementation SKDatePickerDayView
-(instancetype)initWithPickerView:(SKDatePickerView*)pickerView monthView:(SKDatePickerMonthView*)monthView weekView: (SKDatePickerWeekView*)weekView index:(NSUInteger)index dayInfo: (SKDate*)dayInfo
{
    CGSize size = pickerView.dayViewSize;
    CGRect frame = CGRectMake(size.width * index, 0, size.width, size.height);
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.datePickerView = pickerView;
        self.monthView = monthView;
        self.weekView = weekView;
        self.index = index;
        self.dayInfo = dayInfo;
        self.date = dayInfo.date;
        
        
        [self labelSetup];
        [self refreshLabelColor];
        if (![self.datePickerView shouldContinueSelection])
        {
            if ([self.date isEqualToDate: [self.datePickerView.dateToPresent stripped]] && self.dayInfo.isInMonth)
            {
                self.datePickerView.selectedDateView = self;
            }
        }
        else if([self shouldSelectedInPeriod:self.datePickerView.periodStartDate to:self.datePickerView.periodEndDate])
        {
            [self select];
            [self.monthView addSelectDayView:self];
        }
        
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dayViewTapped)];
        
        self.tapGesture = tapGesture;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)dealloc
{
    if (self.tapGesture)
    {
        [self removeGestureRecognizer:self.tapGesture];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
    [self setupLabelFont];
}

-(id<SKDatePickerViewDelegate>)delegate
{
    return self.datePickerView.delegate;
}

#pragma mark - Label setup
-(void)labelSetup
{
    self.textLabel = [UILabel new];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:self.textLabel];
    [NSLayoutConstraint addSKCenterXAndYConstraints:self.textLabel superView:self];
}

-(void)setupLabelFont
{
    //get preferred font
    if ([self.datePickerView.delegate respondsToSelector:@selector(fontForDayLabel)])
    {
        self.textLabel.font = [self.datePickerView.delegate fontForDayLabel];
    }
    self.textLabel.text = [NSString stringWithFormat:@"%ld",self.dayInfo.day];
}

-(void)refreshLabelColor
{
    if (self.dayInfo.isInMonth)
    {
        if (![self.datePickerView dateIsSelectable:self.date])
        {
            self.textLabel.textColor = [self.datePickerView colorForUnavaibleDay];
        }
        else
        {
            self.textLabel.textColor = [self.datePickerView colorForDayLabelInMonth];
        }
        
        if ([self isToday] && [self.datePickerView.delegate respondsToSelector:@selector(colorForToday)])
        {
            self.textLabel.textColor = [self.datePickerView.delegate colorForToday];
        }
        else if ([self isToday])
            self.textLabel.textColor = nil;
    }
    else
    {
        self.userInteractionEnabled = false;
        if ([self.datePickerView.delegate respondsToSelector:@selector(shouldShowMonthOutDates)] && [self.datePickerView.delegate shouldShowMonthOutDates])
        {
            if ([self.datePickerView.delegate respondsToSelector:@selector(colorForDayLabelOutOfMonth)])
            {
                self.textLabel.textColor = [self.datePickerView.delegate colorForDayLabelOutOfMonth];
            }
            else
                self.textLabel.textColor = [self.datePickerView colorForUnavaibleDay];
        }
        else
        {
            [self.textLabel setHidden:true];
        }
    }
    
}

-(BOOL)isToday
{
    return [self.date isEqualToDate:[[NSDate date] stripped]];
}

#pragma mark - Reloading
-(void)reloadContent
{
    self.textLabel.frame = self.bounds;
    [self setupLabelFont];
    
    //reload selectionView
    if (self.selectionView)
    {
        self.selectionView.frame = self.textLabel.frame;
        [self.selectionView setNeedsDisplay];
    }
}


#pragma mark - Selection & Deselection
-(void)deselect
{
    [self.selectionView removeFromSuperview];
    [self refreshLabelColor];
}

-(void)select
{
    SKDatePickerSelectionView* selView = [[SKDatePickerSelectionView alloc] initWithDayView:self frame:self.bounds isSemiSelected:false];
    [self insertSubview:selView atIndex:0];
    
    //pin selectionView horizontally and make it's width equal to the height of the datePickerview. This way it stays centered while rotating the device.
    //pint it to the left and right
    [NSLayoutConstraint addSKCenterXAndYConstraints:selView superView:self];
    [NSLayoutConstraint addLessOrEqualToConstraints:selView superView:self attributes:@[@(NSLayoutAttributeWidth),@(NSLayoutAttributeHeight)]];
    NSMutableArray<NSLayoutConstraint *>* activeConstraints = [NSMutableArray array];
    
    [activeConstraints addObject:[selView.topAnchor constraintEqualToAnchor:self.topAnchor]];
    [activeConstraints addObject:[selView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]];
    [activeConstraints addObject:[selView.leftAnchor constraintEqualToAnchor:self.leftAnchor]];
    [activeConstraints addObject:[selView.rightAnchor constraintEqualToAnchor:self.rightAnchor]];
    for (NSLayoutConstraint * lowConstraint in activeConstraints) {
        lowConstraint.priority = UILayoutPriorityDefaultHigh;
    }
    
    [activeConstraints addObject:[selView.widthAnchor constraintEqualToAnchor:selView.heightAnchor]];
    [NSLayoutConstraint activateConstraints:activeConstraints];
    
    self.selectionView = selView;
    
    //set textcolor to selected state
    if ([self.datePickerView.delegate respondsToSelector:@selector(colorForSelectedDayText)])
    {
        self.textLabel.textColor = [self.datePickerView.delegate colorForSelectedDayText];
    }
}

-(BOOL)shouldSelectedInPeriod:(NSDate*)start to:(NSDate*)end
{
    if (start == nil)
    {
        return NO;
    }
    
    if (![self.datePickerView shouldShowMonthOutDates] && !self.dayInfo.isInMonth)
    {
        return NO;
    }
    
    if (end == nil)
    {
        return [start isEqualToDate:self.date];
    }
    return [self.date laterDate:start] == self.date && [self.date earlierDate:end] == self.date;
}

#pragma mark- Touch handling

-(void)dayViewTapped
{
    [self.window.rootViewController.view endEditing:YES];
    [self.datePickerView didTapDayView:self];
}
@end
