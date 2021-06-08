//
//  SKSimpleDataPicker.m
//  skdatepicker
//
//  Created by xiw on 2021/6/6.
//

#import "SKSimpleDatePicker.h"
@interface SKSimpleDatePicker()<UIPickerViewDataSource, UIPickerViewDelegate, SKColumnPickerDelegate>
@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, assign) NSInteger maxYear;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic,strong) NSDateFormatter  * dateFormatter;
@property (nonatomic,strong) NSArray<NSString*> * monthStrings;
@end

@implementation SKSimpleDatePicker

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
    self.lastComponent = DateComponentAll;
    self.minYear = 1900;
    self.maxYear = 2200;
    self.date = [NSDate date];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormateString = @"yyyy-MMM-dd";
    
}

-(void)setDate:(NSDate *)date
{
    if (![self.date isEqualToDate:date])
    {
        _date = date;
        NSDateComponents * components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
        self.year = components.year;
        self.month = components.month;
        
        if ([self.columnView numberOfComponents] > DateComponentYear)
            [self.columnView selectRow:self.year - self.minYear inComponent:DateComponentYear animated:NO];
        if ([self.columnView numberOfComponents] > DateComponentMonth)
            [self.columnView selectRow:self.month - 1 inComponent:DateComponentMonth animated:NO];
        if ([self.columnView numberOfComponents] > DateComponentDay)
            [self.columnView selectRow:components.day - 1 inComponent:DateComponentDay animated:NO];
    }
}

-(void)setDateFormateString:(NSString *)dateFormateString
{
    if (dateFormateString)
    {
        _dateFormateString = dateFormateString;
        [self.dateFormatter setDateFormat:_dateFormateString];
        if (self.lastComponent > DateComponentMonth)
        {
            NSUInteger startLoc = [_dateFormateString rangeOfString:@"M"].location;
            NSUInteger endLoc = [_dateFormateString rangeOfString:@"M" options:NSBackwardsSearch].location + 1;
            if (startLoc == NSNotFound)
            {
                self.monthStrings = nil;
                [self.columnView reloadComponent:DateComponentMonth];
                return;
            }
            NSString* monthFormat = [_dateFormateString substringWithRange:NSMakeRange(startLoc, endLoc - startLoc)];
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:monthFormat];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents * components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.date];
            components.month = 1;
            const NSInteger monthCount = 12;
            NSMutableArray<NSString*>* monthLabels = [NSMutableArray arrayWithCapacity:monthCount];
            while (components.month <= monthCount)
            {
                NSDate* tmpDate = [calendar dateFromComponents:components];
                [monthLabels addObject:[formatter stringFromDate:tmpDate]];
                components.month++;
            }
            self.monthStrings = monthLabels;
            [self.columnView reloadComponent:DateComponentMonth];
        }
    }
    
}

- (NSInteger)daysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date].length;
}

-(void)updateDatePlainText
{
    [self pickerViewDidSelectColumn:self notifyDatePickerDelegate:false];
}

- (NSInteger)daysInMonth:(NSInteger)month year:(NSInteger)year
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [components setDay:1];
    [components setMonth:month];
    [components setYear:year];
    
    return [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[calendar dateFromComponents:components]].length;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.lastComponent;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch(component)
    {
        case DateComponentYear:
            return self.maxYear - self.minYear;
        case DateComponentMonth:
            return self.monthStrings.count;
        case DateComponentDay:
        {
            return [self daysInMonth:self.month year:self.year];
        }
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
    if (component == DateComponentMonth)
    {
        rowLabel.text = [self.monthStrings objectAtIndex:row];
    }
    else if(component == DateComponentYear)
    {
        rowLabel.text = [NSString stringWithFormat:@"%ld",row + self.minYear];
    }
    else if (row < 10)
    {
        rowLabel.text = [NSString stringWithFormat:@"0%ld",row + 1];
    }
    else
        rowLabel.text = [NSString stringWithFormat:@"%ld",row + 1];

    return rowLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == DateComponentMonth)
    {
        NSInteger newMonth = row + 1;
        NSInteger oldMonth = self.month;
        self.month = newMonth;
        if ([pickerView numberOfComponents] > DateComponentDay)
        {
            NSInteger currentDaysInMonth = [self daysInMonth:oldMonth year:self.year];
            NSInteger newDaysInMonth = [self daysInMonth:newMonth year:self.year];
            if (currentDaysInMonth != newDaysInMonth)
            {
                [pickerView reloadComponent:DateComponentDay];
                NSInteger selectedDay = [pickerView selectedRowInComponent:DateComponentDay];
                if (selectedDay >= newDaysInMonth)
                {
                    [pickerView selectRow:newDaysInMonth - 1 inComponent:DateComponentDay animated:NO];
                }
            }
        }
        
    }else if (component == DateComponentYear)
    {
        NSInteger oldYear = self.year;
        self.year = row + self.minYear;
        
        if ([pickerView numberOfComponents] > DateComponentDay && self.month == 2)
        {
            NSInteger currentDaysInMonth = [self daysInMonth:self.month year:oldYear];
            NSInteger newDaysInMonth = [self daysInMonth:self.month year:self.year];
            if (currentDaysInMonth != newDaysInMonth)
            {
                [pickerView reloadComponent:DateComponentDay];
                NSInteger selectedDay = [pickerView selectedRowInComponent:DateComponentDay];
                if (selectedDay >= newDaysInMonth)
                {
                    [pickerView selectRow:newDaysInMonth - 1 inComponent:DateComponentDay animated:NO];
                }
            }
        }
    }
}

-(void)pickerViewDidSelectColumn:(SKColumnPicker *)pickerView
{
    [self pickerViewDidSelectColumn:self notifyDatePickerDelegate:true];
}

-(void)pickerViewDidSelectColumn:(SKColumnPicker *)pickerView notifyDatePickerDelegate:(bool)notifyDelegate
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    if ([pickerView.columnView numberOfComponents] > DateComponentDay)
        [components setDay:[pickerView.columnView selectedRowInComponent:DateComponentDay] + 1];
    [components setMonth:self.month];
    [components setYear:self.year];
    self.date = [calendar dateFromComponents:components];
    self.plainField.text = [self.dateFormatter stringFromDate:self.date];
}
@end
