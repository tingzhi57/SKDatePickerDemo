//
//  SKDatePickerWeekLabelsView.m
//  skdatepicker
//
//  Created by xiw on 2021/5/4.
//

#import "SKDatePickerWeekLabelsView.h"
#import "SKDatePickerView.h"
#import "NSLayoutConstraint+SKConstraint.h"

@interface SKDatePickerWeekLabelsView()
@property (nonatomic, weak) SKDatePickerView* datePickerView;
@property (nonatomic, strong) NSMutableArray<UILabel*>* weekdayLabels;
//private var firstWeekDay: JBWeekDay!
@property (nonatomic, strong) NSArray<NSString*>* weekdayNameSymbols;
//private var weekdayLabels = [UILabel]()
//private var weekdayLabelTextColor: UIColor!
@end

@implementation SKDatePickerWeekLabelsView

-(instancetype)initWithPickerView:(SKDatePickerView*)pickerView
{
    self = [super initWithFrame:CGRectZero];
    self.datePickerView = pickerView;
    [self setup];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

-(void)dealloc
{
    [self.weekdayLabels removeAllObjects];
    self.weekdayLabels = nil;
}

-(UIColor*)weekdayLabelTextColor
{
    if ([self.datePickerView.delegate respondsToSelector:@selector(colorForWeekLabelsText)])
    {
        return [self.datePickerView.delegate colorForWeekLabelsText];
    }
    return nil;
}
#pragma mark - Setup

-(void)setup
{
    self.weekdayLabels = [NSMutableArray arrayWithCapacity:7];
    //stackView setup
    self.axis = UILayoutConstraintAxisHorizontal;
    self.distribution = UIStackViewDistributionFillEqually;
    
    
    //get weekday name symbols
    NSCalendar* cal = [NSCalendar currentCalendar];

    if ([self.datePickerView.delegate respondsToSelector:@selector(preferredLocal)])
    {
        cal.locale = [self.datePickerView.delegate preferredLocal];
    }
        
    NSArray<NSString *>* weekdayNameSymbols = nil;
    if([self.datePickerView.delegate respondsToSelector:@selector(weekdaySymbols:)])
    {
        weekdayNameSymbols = [self.datePickerView.delegate weekdaySymbols:cal];
    }
    else
    {
        weekdayNameSymbols = cal.shortStandaloneWeekdaySymbols;
    }
    
    //get preferences
    NSInteger firstWeekDay = [self.datePickerView firstWeekDay];
    if (firstWeekDay > 1)
    {
        NSMutableArray* newSymbols = [NSMutableArray array];
        //adjust order of weekDayNameSymbols if needed
        NSInteger firstWeekdayIndex = firstWeekDay - 1;
        NSRange firstRange = NSMakeRange(firstWeekdayIndex, weekdayNameSymbols.count - firstWeekdayIndex);
        [newSymbols addObjectsFromArray:[weekdayNameSymbols subarrayWithRange:firstRange]];
        NSRange endRange = NSMakeRange(0, firstWeekdayIndex);
        [newSymbols addObjectsFromArray:[weekdayNameSymbols subarrayWithRange:endRange]];
        weekdayNameSymbols = newSymbols;
    }
    
    self.weekdayNameSymbols = weekdayNameSymbols;
    for (int i = 0; i < weekdayNameSymbols.count; i++)
    {
        //this containerView is used to prevent visible stretching of the weekDaylabel while turning the device
        UIView* labelContainerView = [UIView new];
        
        [self addArrangedSubview:labelContainerView];
        
        UILabel* weekDayLabel = [UILabel new];
        weekDayLabel.textAlignment = NSTextAlignmentCenter;
        weekDayLabel.text = weekdayNameSymbols[i];
        weekDayLabel.textColor = [self weekdayLabelTextColor];
        weekDayLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self.weekdayLabels addObject:weekDayLabel];
        [labelContainerView addSubview:weekDayLabel];
        
        [NSLayoutConstraint addSKCenterXAndYConstraints:weekDayLabel superView:labelContainerView];
    }
    if([self.datePickerView.delegate respondsToSelector:@selector(colorForWeekDaysViewBackground)])
    {
        
        self.backgroundColor = [self.datePickerView.delegate colorForWeekDaysViewBackground];
    }
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [self updateLayout];
}

-(void)updateLayout
{
    if ([self.datePickerView.delegate respondsToSelector:@selector(fontForWeekDaysViewText)])
    {
        //get preferred font
        UIFont* preferredFont = [self.datePickerView.delegate fontForWeekDaysViewText];
        
        for (int i = 0; i < self.weekdayLabels.count; i++)
        {
            NSString* labelText = self.weekdayNameSymbols[i];
            UILabel* label = self.weekdayLabels[i];
            label.attributedText = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSFontAttributeName:preferredFont}];
        }
    }
}
@end
