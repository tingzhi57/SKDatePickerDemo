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
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents * comps = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    
    
    return [calendar dateFromComponents:comps];
}
@end
