//
//  SKDate.m
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import "SKDate.h"

@implementation SKDate
-(instancetype)initWithDay:(NSInteger)dayValue monthValue:(NSInteger)monthValue yearValue:(NSInteger)yearValue isInMonth:(BOOL)isInMonth
{
    self = [super init];
    self.day = dayValue;
    self.month = monthValue;
    self.year = yearValue;
    self.isInMonth = isInMonth;
    return self;
}

-(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * comps = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    
    comps.year = self.year;
    comps.month = self.month;
    comps.day = self.day;
    
    
    return [calendar dateFromComponents:comps];
}

-(void)setDay:(NSInteger)day
{
    _day = day;
    if (_day > 10000)
    {
        
    }
}
@end


@implementation SKMonthInfo
-(instancetype)initWithStartDay:(NSDate*)monthStartDay monthEndDay:(NSDate*)monthEndDay numberOfWeeksInMonth:(NSInteger)numberOfWeeksInMonth weekDayInfo:(NSArray<NSDictionary<NSNumber*,SKDate*>*>*)weekDayInfo
{
    self = [super init];
    self.monthStartDay = monthStartDay;
    self.monthEndDay = monthEndDay;
    self.numberOfWeeksInMonth = numberOfWeeksInMonth;
    self.weekDayInfo = weekDayInfo;
    return  self;
}

@end

