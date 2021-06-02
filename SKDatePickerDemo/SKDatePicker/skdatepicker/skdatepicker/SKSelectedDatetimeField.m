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
#import "SKTimePicker.h"

@interface SKSelectedDatetimeField()<SKTimePickerDelegate>

@property (nonatomic, weak) SKDatePickerView* datePickerView;
@property (nonatomic,strong) SKTimePicker* timeField;
@property (nonatomic,retain) SKTimePicker* startTimeField;
@property (nonatomic,retain) SKTimePicker* endTimeField;

@property (nonatomic,strong) NSDateFormatter  * datetimeFormatter;

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
        self.timeField = [SKTimePicker new];
        self.timeField.timer_delegate = self;
        self.timeField.lastComponent = [self lastTimeComponent];
        self.timeField.timeFormateString = [self timeFormatString];
        self.timeField.plainField.font = perfectFont;
        [self addSubview:self.timeField];
        [NSLayoutConstraint addEqualToConstraints:self.timeField superView:self attributes:@[@(NSLayoutAttributeRight),@(NSLayoutAttributeTop),@(NSLayoutAttributeBottom),@(NSLayoutAttributeHeight)]];
    }
    
    
//    if (self.dateLabel == nil)
//    {
//        self.dateLabel = [UILabel new];
//        self.dateLabel.textAlignment = NSTextAlignmentRight;
//        self.dateLabel.font = perfectFont;
//        [self addSubview:self.dateLabel];
//        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false;
//    }
    float timeRatio = 0.45f;
    
//    [otherActiveConstraints addObject:[self.timeField.leftAnchor constraintEqualToAnchor:self.dateLabel.rightAnchor constant:10]];
    
    [otherActiveConstraints addObject:[self.timeField.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:timeRatio]];
    
    if ([self.datePickerView shouldContinueSelection])
    {
        
        self.endTimeField = self.timeField;
        self.endTimeField.plainField.textAlignment = NSTextAlignmentLeft;
        
        self.endTimeField.hour = 23;
        self.endTimeField.minute = 59;
        self.endTimeField.second = 59;
        
        UILabel* seperatorLabel = [UILabel new];
        seperatorLabel.text = @"~";
        seperatorLabel.font = perfectFont;
        [self addSubview:seperatorLabel];
        
        [NSLayoutConstraint addEqualToConstraints:seperatorLabel superView:self attributes:@[@(NSLayoutAttributeCenterY),@(NSLayoutAttributeCenterX)]];
        
        
        if (self.startTimeField == nil)
        {
            self.startTimeField = [SKTimePicker new];
            self.startTimeField.timer_delegate = self;
            self.startTimeField.lastComponent = [self lastTimeComponent];
            self.startTimeField.timeFormateString = [self timeFormatString];
            self.startTimeField.plainField.font = perfectFont;
            self.startTimeField.plainField.textAlignment = NSTextAlignmentRight;
//            self.startTimeField.delegate = self;
            [self addSubview:self.startTimeField];
            [NSLayoutConstraint addEqualToConstraints:self.startTimeField superView:self attributes:@[@(NSLayoutAttributeLeft),@(NSLayoutAttributeTop),@(NSLayoutAttributeBottom),@(NSLayoutAttributeHeight)]];
            
           // [otherActiveConstraints addObject:[self.startTimeField.rightAnchor  constraintEqualToAnchor:self.seperatorLabel.leftAnchor constant:-10]];
            
            [otherActiveConstraints addObject:[self.startTimeField.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:timeRatio]];
        }
        
        [self.startTimeField updateTimePlainText];
        [self.endTimeField updateTimePlainText];
    }
    else
    {
        self.timeField.plainField.textAlignment = NSTextAlignmentRight;
        [self.timeField updateTimePlainText];
    }
}

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
//    [self.dateLabel setText:[self.datetimeFormatter stringFromDate:date]];
    
    self.dateAndTime = [date updateHour:self.timeField.hour minute:self.timeField.minute second:self.timeField.second];
    self.timeField.date = self.dateAndTime;
    [self.timeField updateTimePlainText];
}

-(void)notifySelectedPeriodChanged:(NSDate*)startDate to:(NSDate*)endDate
{
    [self.datetimeFormatter setDateFormat:[self dateFormatString]];
    if (startDate)
    {
//        [self.startDateLabel setText:[self.datetimeFormatter stringFromDate:startDate]];
        self.dateAndTime = [startDate updateHour:self.startTimeField.hour minute:self.startTimeField.minute second:self.startTimeField.second];
        self.startTimeField.date = self.dateAndTime;
    }
    else
    {
        self.startTimeField.date = nil;
    }
    [self.startTimeField updateTimePlainText];
    
    if (endDate)
    {
//        [self.endDateLabel setText:[self.datetimeFormatter stringFromDate:endDate]];
        self.endDateAndTime = [endDate updateHour:self.endTimeField.hour minute:self.endTimeField.minute second:self.endTimeField.second];
        self.endTimeField.date = self.endDateAndTime;
    }
    else
    {
        self.endTimeField.date = nil;
    }
    [self.endTimeField updateTimePlainText];
}

-(NSString*)dateFormatString
{
    return @"yyyy-MM-dd";
}

-(NSString*)timeFormatString
{
    TimeFiledFormat timeformat = [self.datePickerView timeFiledFormat];
    if(timeformat == TimeFormat_HM)
        return @"HH:mm";
    if(timeformat == TimeFormat_H)
        return @"HH";
    return @"HH:mm:ss";
}

-(TimeComponents)lastTimeComponent
{
    TimeFiledFormat timeformat = [self.datePickerView timeFiledFormat];
    if(timeformat == TimeFormat_HM)
        return TimeComponentSecond;
    if(timeformat == TimeFormat_H)
        return TimeComponentMinute;
    return TimeComponentAll;
}

#pragma mark - timer delegate
-(void)timeValueChanged:(SKTimePicker*)timePicker
{
    if (![self.datePickerView shouldContinueSelection])
    {
        self.dateAndTime = [self.dateAndTime updateHour:timePicker.hour minute:timePicker.minute second:timePicker.second];
        [self.datePickerView.delegate didSelectDay:self.dateAndTime];
    }
    else if ([self.datePickerView.delegate respondsToSelector:@selector(didSelectContinueDayFrom:toEnd:)])
    {
        if (timePicker == self.startTimeField)
        {
            self.dateAndTime = [self.dateAndTime updateHour:timePicker.hour minute:timePicker.minute second:timePicker.second];
        }
        else if (timePicker == self.endTimeField)
        {
            self.endDateAndTime = [self.endDateAndTime updateHour:timePicker.hour minute:timePicker.minute second:timePicker.second];
        }
        
        [self.datePickerView.delegate didSelectContinueDayFrom:self.dateAndTime toEnd:self.endDateAndTime];
    }
}

-(bool)validateTimeValue:(SKTimePicker *)timePicker
{
    if (![self.datePickerView shouldContinueSelection]) return true;
    NSDate* startDate = self.dateAndTime;
    NSDate* endDate = self.endDateAndTime;
    if (timePicker == self.startTimeField)
    {
        startDate = [self.dateAndTime updateHour:timePicker.hour minute:timePicker.minute second:timePicker.second];
    }
    else if (timePicker == self.endTimeField)
    {
        endDate = [self.endDateAndTime updateHour:timePicker.hour minute:timePicker.minute second:timePicker.second];
    }
    
    return [[startDate earlierDate:endDate] isEqualToDate:startDate];
}

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
//
//-(void)validateAndUpdateTimeString:(UITextField *)textField
//{
//    bool isSingleOrStartFiled = true;
//    if ([self.datePickerView shouldContinueSelection] && textField == self.endTimeField)
//    {
//        isSingleOrStartFiled = false;
//    }
//    NSUInteger hour,minute,second;
//    if (isSingleOrStartFiled)
//    {
//        hour = self.hour;
//        minute = self.minute;
//        second = self.second;
//        bool updateTimeValue = [self validateTimeString:textField hour:&hour minute:&minute second:&second];
//        if (updateTimeValue)
//        {
//            self.hour = hour;
//            self.minute = minute;
//            self.second = second;
//            [textField setText:[self getTimeText]];
//            self.dateAndTime = [self.dateAndTime updateHour:self.hour minute:self.minute second:self.second];
//            if (![self.datePickerView shouldContinueSelection]) {
//                [self.datePickerView.delegate didSelectDay:self.dateAndTime];
//            }
//            else if ([self.datePickerView.delegate respondsToSelector:@selector(didSelectContinueDayFrom:toEnd:)]) {
//
//                [self.datePickerView.delegate didSelectContinueDayFrom:self.dateAndTime toEnd:self.endDateAndTime];
//            }
//        }
//    }
//    else
//    {
//        hour = self.endHour;
//        minute = self.endMinute;
//        second = self.endSecond;
//        bool updateTimeValue = [self validateTimeString:textField hour:&hour minute:&minute second:&second];
//        if (updateTimeValue)
//        {
//            self.endHour = hour;
//            self.endMinute = minute;
//            self.endSecond = second;
//            [textField setText:[self getEndTimeText]];
//            self.endDateAndTime = [self.endDateAndTime updateHour:self.endHour minute:self.endMinute second:self.endSecond];
//            if ([self.datePickerView.delegate respondsToSelector:@selector(didSelectContinueDayFrom:toEnd:)]) {
//
//                [self.datePickerView.delegate didSelectContinueDayFrom:self.dateAndTime toEnd:self.endDateAndTime];
//            }
//        }
//    }
//}

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
@end
