//
//  SKTimePicker.m
//  skdatepicker
//
//  Created by xiw on 2021/5/24.
//

#import "SKTimePicker.h"
#import "NSDate+SKDateCategory.h"


@interface SKTimePicker()<UIPickerViewDataSource, UIPickerViewDelegate, SKColumnPickerDelegate>

@end

@implementation SKTimePicker

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

-(void)basicInit
{
    self.datasource = self;
    self.columnView.delegate = self;
    self.delegate = self;
    self.dateFormateString = @"yyyy-MM-dd";
    self.timeFormateString = @"HH:mm:ss";
    self.lastComponent = TimeComponentAll;
}

-(void)setHour:(NSUInteger)hour
{
    if (_hour != hour)
    {
        if (hour < [self pickerView:self.columnView numberOfRowsInComponent:TimeComponentHour])
        {
            _hour = hour;
            if (TimeComponentHour < [self numberOfComponentsInPickerView:self.columnView])
            {
                [self.columnView selectRow:_hour inComponent:TimeComponentHour animated:NO];
            }
        }
    }
}

-(void)setMinute:(NSUInteger)minute
{
    if (_minute != minute)
    {
        if (minute < [self pickerView:self.columnView numberOfRowsInComponent:TimeComponentMinute])
        {
            _minute = minute;
            if (TimeComponentMinute < [self numberOfComponentsInPickerView:self.columnView])
            {
                [self.columnView selectRow:_minute inComponent:TimeComponentMinute animated:NO];
            }
        }
    }
}

-(void)setSecond:(NSUInteger)second
{
    if (_second != second)
    {
        if (second < [self pickerView:self.columnView numberOfRowsInComponent:TimeComponentSecond])
        {
            _second = second;
            if (TimeComponentSecond < [self numberOfComponentsInPickerView:self.columnView])
            {
                [self.columnView selectRow:_second inComponent:TimeComponentSecond animated:NO];
            }
        }
    }
}


-(void)updateTimePlainText
{
    [self pickerViewDidSelectColumn:self notifyDatePickerDelegate:false];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.lastComponent;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch(component)
    {
        case TimeComponentHour:
            return 24;
        case TimeComponentMinute:
            return 60;
        case TimeComponentSecond:
            return 60;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UILabel* rowLabel = nil;
    if (view) {
        rowLabel = (UILabel*)view;
    }else
    {
        rowLabel = [UILabel new];
        rowLabel.font = self.plainField.font;
        rowLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (row < 10) {
        rowLabel.text = [NSString stringWithFormat:@"0%ld",row];
    }else
        rowLabel.text = [NSString stringWithFormat:@"%ld",row];

    return rowLabel;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.frame.size.height;
}

-(void)pickerViewDidSelectColumn:(SKColumnPicker *)pickerView
{
    [self pickerViewDidSelectColumn:pickerView notifyDatePickerDelegate:true];
}

-(void)pickerViewDidSelectColumn:(SKColumnPicker *)pickerView notifyDatePickerDelegate:(bool)notifyDelegate
{
    const NSInteger columnCount = [self numberOfComponentsInPickerView:pickerView.columnView];
//    NSMutableString* myPlainLabel = [NSMutableString string];
    NSUInteger oldHour = self.hour;
    NSUInteger oldMinute = self.minute;
    NSUInteger oldSecond = self.second;
    
    for (NSInteger i = 0; i < columnCount; i++)
    {
        NSInteger row = [pickerView.columnView selectedRowInComponent:i];
        switch (i) {
            case TimeComponentHour:
                _hour = row;
                break;
            case TimeComponentMinute:
                _minute = row;
                break;
            case TimeComponentSecond:
                _second = row;
                break;
            default:
                break;
        }
    }
    
    if(![self.timer_delegate validateTimeValue:self])
    {
        //Can't select this time, reset value;
        self.hour = oldHour;
        self.minute = oldMinute;
        self.second = oldSecond;
    }
    
    NSDate* newDate = nil;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    if (self.date)
    {
        NSMutableString* datetimeFormatString = [NSMutableString stringWithString:self.dateFormateString];
        [datetimeFormatString appendFormat:@" %@",self.timeFormateString];
        newDate = [self.date updateHour:self.hour minute:self.minute second:self.second];
        [formatter setDateFormat:datetimeFormatString];
    }else
    {
        newDate = [[NSDate date] updateHour:self.hour minute:self.minute second:self.second];
        [formatter setDateFormat:self.timeFormateString];
    }
    pickerView.plainField.text = [formatter stringFromDate:newDate];
    if (notifyDelegate)
    {
        [self.timer_delegate timeValueChanged:self];
    }
}
@end
