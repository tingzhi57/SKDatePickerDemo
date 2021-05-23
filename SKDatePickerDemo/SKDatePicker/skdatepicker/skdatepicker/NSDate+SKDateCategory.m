//
//  NSDate+SKDateCategory.m
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import "NSDate+SKDateCategory.h"

@implementation NSDate (SKDateCategory)

-(NSDate*)stripped
{
    return [self updateHour:0 minute:0 second:0];
}


-(NSDate*)updateHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * comps = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    
    comps.hour = hour;
    comps.minute = minute;
    comps.second = second;
    
    return [calendar dateFromComponents:comps];
}
@end
