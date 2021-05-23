//
//  SKSelectedDatetimeField.m
//  skdatepicker
//
//  Created by xiw on 2021/5/23.
//

#import "SKSelectedDatetimeField.h"
#import "SKDatePickerView.h"
#import "SKDatePickerViewDelegate.h"
#import "NSLayoutConstraint+SKConstraint.h"
#import "NSDate+SKDateCategory.h"

@interface SKSelectedDatetimeField()<UITextFieldDelegate>

@property (nonatomic, weak) SKDatePickerView* datePickerView;
@property (nonatomic,strong) UILabel* dateLabel;
@property (nonatomic,strong) UITextField* timeField;

@property (nonatomic,retain) UILabel* startDateLabel;
@property (nonatomic,retain) UILabel* seperatorLabel;
@property (nonatomic,retain) UILabel* endDateLabel;
@property (nonatomic,retain) UITextField* startTimeField;
@property (nonatomic,retain) UITextField* endTimeField;

@property (nonatomic,strong) NSDateFormatter  * datetimeFormatter;

@property (nonatomic,assign) NSUInteger hour;
@property (nonatomic,assign) NSUInteger minute;
@property (nonatomic,assign) NSUInteger second;

@property (nonatomic,assign) NSUInteger endHour;
@property (nonatomic,assign) NSUInteger endMinute;
@property (nonatomic,assign) NSUInteger endSecond;

@end

@implementation SKSelectedDatetimeField

-(void)setupUI:(SKDatePickerView*)datepickerView otherContraints:(NSMutableArray<NSLayoutConstraint *>*)otherActiveConstraints
{
    self.datePickerView = datepickerView;
    UIFont* perfectFont = nil;
    
    if ([self.datePickerView.delegate respondsToSelector:@selector(fontForDayLabel)])
    {
        perfectFont = [self.datePickerView.delegate fontForDayLabel];
    }
    
    if (self.timeField == nil)
    {
        self.timeField = [UITextField new];
//        self.timeField.backgroundColor = [UIColor redColor];
        self.timeField.font = perfectFont;
        self.timeField.delegate = self;
        [self addSubview:self.timeField];
        [NSLayoutConstraint addEqualToConstraints:self.timeField superView:self attributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeRight),@(NSLayoutAttributeBottom)]];
    }
    
    
    if (self.dateLabel == nil)
    {
        self.dateLabel = [UILabel new];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.font = perfectFont;
//        self.dateLabel.backgroundColor = [UIColor blueColor];
        [self addSubview:self.dateLabel];
        
        [NSLayoutConstraint addEqualToConstraints:self.dateLabel superView:self attributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeBottom)]];
    }
    [otherActiveConstraints addObject:[self.timeField.leftAnchor constraintEqualToAnchor:self.dateLabel.rightAnchor constant:10]];
    
    if ([self.datePickerView shouldContinueSelection])
    {
        self.endHour = 23;
        self.endMinute = 59;
        self.endSecond = 59;
        
        self.endDateLabel = self.dateLabel;
        self.endTimeField = self.timeField;
        
        if (self.seperatorLabel == nil)
        {
            self.seperatorLabel = [UILabel new];
            self.seperatorLabel.font = perfectFont;
            self.seperatorLabel.textAlignment = NSTextAlignmentCenter;
            self.seperatorLabel.text = @"~";
            [self addSubview:self.seperatorLabel];
            
            [NSLayoutConstraint addEqualToConstraints:self.seperatorLabel superView:self attributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeBottom)]];
            
            [otherActiveConstraints addObject:[self.seperatorLabel.rightAnchor  constraintEqualToAnchor:self.endDateLabel.leftAnchor constant:-10]];
        }
        
        if (self.startTimeField == nil)
        {
            self.startTimeField = [UITextField new];
            self.startTimeField.font = perfectFont;
            self.startTimeField.delegate = self;
            [self addSubview:self.startTimeField];
            [NSLayoutConstraint addEqualToConstraints:self.startTimeField superView:self attributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeBottom)]];
            
            [otherActiveConstraints addObject:[self.startTimeField.rightAnchor  constraintEqualToAnchor:self.seperatorLabel.leftAnchor constant:-10]];
        }
        
        if (self.startDateLabel == nil)
        {
            self.startDateLabel = [UILabel new];
            self.startDateLabel.textAlignment = NSTextAlignmentRight;
            self.startDateLabel.font = perfectFont;
            [self addSubview:self.startDateLabel];
            
            [NSLayoutConstraint addEqualToConstraints:self.startDateLabel superView:self attributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeBottom)]];
            
            [otherActiveConstraints addObject:[self.startTimeField.leftAnchor constraintEqualToAnchor:self.startDateLabel.rightAnchor constant:10]];
        }
        
        [self.endTimeField setPlaceholder:[self getEndTimeText]];
        [self.startTimeField setPlaceholder:[self getTimeText]];
    }
    else
        [self.timeField setPlaceholder:[self getTimeText]];
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    [self.timeField sizeToFit];
//    [self.dateLabel sizeToFit];
//    
//    CGRect heightFrame = self.timeField.frame;
//    heightFrame.size.height = self.bounds.size.height;
//    self.timeField.frame = heightFrame;
//    
//    heightFrame = self.dateLabel.frame;
//    heightFrame.size.height = self.bounds.size.height;
//    self.dateLabel.frame = heightFrame;
//}

-(BOOL)endEditing:(BOOL)force
{
    bool result = [super endEditing:force];
    if(!result)
        result = [self.timeField resignFirstResponder];
    if(!result)
        [self.endTimeField resignFirstResponder];
    return result;
}

-(NSDateFormatter *)datetimeFormatter
{
    if (_datetimeFormatter == nil) {
        _datetimeFormatter = [[NSDateFormatter alloc] init];
    }
    return _datetimeFormatter;
}

-(void)notifySelectedDateChanged:(NSDate*)date
{
    [self.datetimeFormatter setDateFormat:[self dateFormatString]];
    [self.dateLabel setText:[self.datetimeFormatter stringFromDate:date]];
    
    self.dateAndTime = [date updateHour:self.hour minute:self.minute second:self.second];
}

-(void)notifySelectedPeriodChanged:(NSDate*)startDate to:(NSDate*)endDate
{
    [self.datetimeFormatter setDateFormat:[self dateFormatString]];
    if (startDate)
    {
        [self.startDateLabel setText:[self.datetimeFormatter stringFromDate:startDate]];
        self.dateAndTime = [startDate updateHour:self.hour minute:self.minute second:self.second];
    }
    else
    {
        self.startDateLabel.text = @"";
    }
    
    if (endDate)
    {
        [self.endDateLabel setText:[self.datetimeFormatter stringFromDate:endDate]];
        self.endDateAndTime = [endDate updateHour:self.endHour minute:self.endMinute second:self.endSecond];
    }
    else
    {
        self.endDateLabel.text = @"";
    }
}

-(NSString*)getTimeText
{
    return [self getTimeTextHour:self.hour min:self.minute second:self.second];
}

-(NSString*)getEndTimeText
{
    return [self getTimeTextHour:self.endHour min:self.endMinute second:self.endSecond];
}

-(NSString*)dateFormatString
{
    return @"yyyy-MM-dd";
}

-(NSString*)timeFormatString
{
    return @"HH:mm:ss";
}


#pragma mark - UITextFieldDelegate methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length <= 1)
    {
        NSString* textNewString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (string.length == 1)
        {
            //Only number or ':', acceptable
            if([string characterAtIndex:0] >= '0' && [string characterAtIndex:0] <= '9') return [self validateTimeString:textNewString];
            if([string characterAtIndex:0] == ':')
            {
                return [self validateTimeString:textNewString];
            }
            return NO;
        }
        //Delete or blank key, acceptable.
        return [self validateTimeString:textNewString];
    }
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self validateAndUpdateTimeString:textField];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self validateAndUpdateTimeString:textField];
    return YES;
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    return NO;
//}
#pragma mark - logic methods
-(BOOL)validateTimeString:(NSString*)timeString
{
    NSArray<NSString*>* components = [timeString componentsSeparatedByString:@":"];
//    NSLog(@"%s, timeString:%@,components:%@",__FUNCTION__,timeString,components);
    
    if (components.count > 0 && components.count <= 3)
    {
        NSString* hourString = [components objectAtIndex:0];
        if ([hourString intValue] >= 24 || hourString.length > 2)
        {
            return NO;
        }
        if (components.count > 1)
        {
            NSString* minString = [components objectAtIndex:1];
            if ([minString intValue] >= 60 || minString.length > 2)
            {
                return NO;
            }
        }
        if (components.count > 2)
        {
            NSString* secString = [components objectAtIndex:2];
            if ([secString intValue] >= 60 || secString.length > 2)
            {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

-(void)validateAndUpdateTimeString:(UITextField *)textField
{
    bool isSingleOrStartFiled = true;
    if ([self.datePickerView shouldContinueSelection] && textField == self.endTimeField)
    {
        isSingleOrStartFiled = false;
    }
    NSUInteger hour,minute,second;
    if (isSingleOrStartFiled)
    {
        hour = self.hour;
        minute = self.minute;
        second = self.second;
        bool updateTimeValue = [self validateTimeString:textField hour:&hour minute:&minute second:&second];
        if (updateTimeValue)
        {
            self.hour = hour;
            self.minute = minute;
            self.second = second;
            [textField setText:[self getTimeText]];
            self.dateAndTime = [self.dateAndTime updateHour:self.hour minute:self.minute second:self.second];
            if (![self.datePickerView shouldContinueSelection]) {
                [self.datePickerView.delegate didSelectDay:self.dateAndTime];
            }
            else if ([self.datePickerView.delegate respondsToSelector:@selector(didSelectContinueDayFrom:toEnd:)]) {
                
                [self.datePickerView.delegate didSelectContinueDayFrom:self.dateAndTime toEnd:self.endDateAndTime];
            }
        }
    }
    else
    {
        hour = self.endHour;
        minute = self.endMinute;
        second = self.endSecond;
        bool updateTimeValue = [self validateTimeString:textField hour:&hour minute:&minute second:&second];
        if (updateTimeValue)
        {
            self.endHour = hour;
            self.endMinute = minute;
            self.endSecond = second;
            [textField setText:[self getEndTimeText]];
            self.endDateAndTime = [self.endDateAndTime updateHour:self.endHour minute:self.endMinute second:self.endSecond];
            if ([self.datePickerView.delegate respondsToSelector:@selector(didSelectContinueDayFrom:toEnd:)]) {
                
                [self.datePickerView.delegate didSelectContinueDayFrom:self.dateAndTime toEnd:self.endDateAndTime];
            }
        }
    }
}

-(BOOL)validateTimeString:(UITextField *)textField hour:(NSUInteger*)hour minute:(NSUInteger*)minute second:(NSUInteger*)second
{
    NSString* timeString = textField.text;
    if (timeString.length == 0)
    {
        timeString = textField.placeholder;
    }
    NSArray<NSString*>* components = [timeString componentsSeparatedByString:@":"];
//    NSLog(@"%s, timeString:%@,components:%@",__FUNCTION__,timeString,components);
    bool updateTimeValue = false;
    if (components.count > 0 && components.count <= 3)
    {
        NSString* hourString = [components objectAtIndex:0];
        int newHour = [hourString intValue];
        if (newHour < 24 && newHour != *hour)
        {
            *hour = newHour;
            updateTimeValue = true;
        }
        if (components.count > 1)
        {
            NSString* minString = [components objectAtIndex:1];
            int newMin = [minString intValue];
            if (newMin < 60 && newMin != *minute)
            {
                *minute = newMin;
                updateTimeValue = true;
            }
        }
        if (components.count > 2)
        {
            NSString* secString = [components objectAtIndex:2];
            int newSec = [secString intValue];
            if (newSec < 60 && newSec != *second)
            {
                *second = newSec;
                updateTimeValue = true;
            }
        }
    }
    

    
    return updateTimeValue;
}

-(NSString*)getTimeTextHour:(NSUInteger)hour min:(NSUInteger)minute second:(NSUInteger)second
{
    [self.datetimeFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [self.datetimeFormatter dateFromString:[NSString stringWithFormat:@"%lu:%lu:%lu",hour,minute,second]];
    
    [self.datetimeFormatter setDateFormat:[self timeFormatString]];
    return [self.datetimeFormatter stringFromDate:date];
}
@end
