//
//  SKDatePickerManager.m
//  skdatepicker
//
//  Created by xiw on 2021/5/4.
//

#import "SKDatePickerManager.h"
#import "SKDate.h"
#import "SKDatePickerView.h"

#define DAYS_OF_WEEK 7

@interface SKDatePickerManager()

@property (nonatomic, weak) SKDatePickerView* datePickerView;

@end

@implementation SKDatePickerManager
#pragma mark - Initialization
-(instancetype)initWithPickerView:(SKDatePickerView*)datePickerView
{
    self = [super init];
    self.datePickerView = datePickerView;
//    self.components = calendar.dateComponents([.month, .day], from: currentDate)
    
    if([datePickerView.delegate respondsToSelector:@selector(firstWeekday)])
    {
        //let user preference prevail about default
        self.calendar.firstWeekday = [datePickerView.delegate firstWeekDay];
    }
    return self;
}

-(NSCalendar *)calendar
{
    if (_calendar == nil) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}
/**
 Gets the startdate and the enddate of the month of a certain date and also the amount of weeks
 for that month and all the days with their weekViewIndex and value
 
 - Parameter date: the Date object of the month that we want the info about
 - Returns: a tuple holding the startdate, the enddate, the number of weeks and
 an array holding dictionaries with the weekDayIndex as key and a JBDay object as value.
 The JBDay object holds the value (like 17) and a bool that determines that the day involved
 is included in the month or not.
 */
-(SKMonthInfo*)getMonthInfoForDate:(NSDate*)date
{
    if (date == nil)
    {
        return nil;
    }
    NSCalendar* calendar = self.calendar;
    
    NSDateComponents * components = [calendar components:(NSCalendarUnitWeekOfMonth | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    
    //first day of the month
    components.day = 1;
    NSInteger monthValue = components.month;
    NSInteger yearValue = components.year;
    NSDate* monthStartDay = [calendar dateFromComponents:components];
    
    //last day of the month
    components.month += 1;
    NSInteger nextMonthValue = components.month;
    NSInteger nextYearValue = components.year;
    
    components.day -= 1;
    NSDate* monthEndDay = [calendar dateFromComponents:components];
    
    components = [calendar components:(NSCalendarUnitWeekOfMonth | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];

    //last day of the previous month. We have to substract two because we went up to get the next month
    components.month -= 1;
    NSDate* previousMonthEndDay = [calendar dateFromComponents:components];
    NSInteger previousMonthValue = components.month;
    NSInteger previousYearValue = components.year;
    
    //count of weeks in month
    NSInteger numberOfWeeksInMonth = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:date].length;
    
    //get dates that fall within the month
    NSRange datesInRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    NSMutableArray<NSNumber*>* monthDatesArray = [NSMutableArray arrayWithCapacity:datesInRange.length];
    for (int i = 1; i <= datesInRange.length; i++)
    {
        [monthDatesArray addObject:@(i)];
    }
    
//    ????
//    for value in 1..<datesInRange!.upperBound {
//        monthDatesArray.append(value)
//    }
    
    
    //find weekday index of first- and lastDay of month in their week.
    NSInteger firstDayIndexInWeekView = [self indexForDate:[calendar components:NSCalendarUnitWeekday fromDate:monthStartDay].weekday];
    
    NSInteger lastDayIndexInWeekView = [self indexForDate:[calendar components:NSCalendarUnitWeekday fromDate:monthEndDay].weekday];
    
    //get dates that fall within next month
    NSMutableArray<NSNumber*>* nextMonthDatesArray = [NSMutableArray arrayWithCapacity:6];
    NSInteger numberOfDaysInNextMonth = 6 - lastDayIndexInWeekView;
    for (int i = 1; i <= numberOfDaysInNextMonth; i++)
    {
        [nextMonthDatesArray addObject:@(i)];
    }
    
    
    //get dates that fall within previous month
    NSMutableArray<NSNumber*>* previousMonthDatesArray = [NSMutableArray arrayWithCapacity:DAYS_OF_WEEK];
    NSRange datesInRangeOfPreviousMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:previousMonthEndDay];
    
    NSInteger numberOfDaysInPreviousMonth = firstDayIndexInWeekView;//

    NSInteger subRangeLowerBound = datesInRangeOfPreviousMonth.length - numberOfDaysInPreviousMonth + datesInRangeOfPreviousMonth.location;

    if (numberOfDaysInPreviousMonth > 0)
    {
        for (NSInteger i = subRangeLowerBound; i <= datesInRangeOfPreviousMonth.length; i++)
        {
            [previousMonthDatesArray addObject:@(i)];
        }
    }

    //if the total amount of dates is larger then the amount of weeks * 7, give an extra week
    if( monthDatesArray.count + previousMonthDatesArray.count + nextMonthDatesArray.count > numberOfWeeksInMonth * DAYS_OF_WEEK)
    {
        numberOfWeeksInMonth += 1;
    }
    
    //create array of dictionaries that we well return in the end
    NSMutableArray<NSDictionary<NSNumber*,SKDate*>*>* weeksInMonthInformationToReturn = [NSMutableArray arrayWithCapacity:numberOfWeeksInMonth];
    
    
    //this value holds 0 to the number of days in a month
    NSInteger dayOfMonthIndex = 0;
    for (int weekIndex = 0; weekIndex < numberOfWeeksInMonth; weekIndex++)
    {
        NSMutableDictionary<NSNumber*,SKDate*>* weekInformationToReturn = [NSMutableDictionary dictionaryWithCapacity:DAYS_OF_WEEK];
        if (weekIndex == 0)
        {
            //first row/week
            //get the last days of the previous month
            for(int i = 0; i < previousMonthDatesArray.count; i++)
                
            {
                NSInteger dayInPreviousMonthValue = previousMonthDatesArray[i].integerValue;
                SKDate* dayInPreviousMonth = [[SKDate alloc] initWithDay:dayInPreviousMonthValue monthValue:previousMonthValue yearValue:previousYearValue isInMonth:false];
                weekInformationToReturn[@(i)] = dayInPreviousMonth;
            }
            
            //get the rest of days in this month
            NSInteger amountOfFirstDays = DAYS_OF_WEEK - firstDayIndexInWeekView;
            //this value holds 0 to 6 (the index of the day in the week)
            NSInteger dayOfWeekIndex = firstDayIndexInWeekView;
            for (int i = 0; i < amountOfFirstDays; i++)
            {
                
                NSInteger dayInFirstWeekOfMonth = [monthDatesArray[dayOfMonthIndex] integerValue];
                SKDate* dayInWeek = [[SKDate alloc] initWithDay:dayInFirstWeekOfMonth monthValue:monthValue yearValue:yearValue isInMonth:true];
                
                weekInformationToReturn[@(dayOfWeekIndex)] = dayInWeek;
                dayOfWeekIndex += 1;
                dayOfMonthIndex += 1;
            }
        }
        else if(weekIndex == numberOfWeeksInMonth - 1)
        {
            if (dayOfMonthIndex >= monthDatesArray.count)
            {
                //remove unnecessary week line
                numberOfWeeksInMonth -= 1;
                break;
            }
            NSInteger dayOfWeekIndex = 0;
            for (NSInteger i = dayOfMonthIndex; i < monthDatesArray.count; i++)
            {
                NSInteger dayInWeekOfMonth = [monthDatesArray[i] integerValue];
                SKDate* dayInWeek = [[SKDate alloc] initWithDay:dayInWeekOfMonth monthValue:monthValue yearValue:yearValue isInMonth:true];
                
                weekInformationToReturn[@(dayOfWeekIndex)] = dayInWeek;
                dayOfWeekIndex += 1;
                dayOfMonthIndex += 1;
            }
            
            
            //get the first days of the next month
            for(int i = 0; i < nextMonthDatesArray.count; i++)
            {
                NSInteger dayInNextMontValue = [nextMonthDatesArray[i] integerValue];
                
                SKDate* dayInNextMonth = [[SKDate alloc] initWithDay:dayInNextMontValue monthValue:nextMonthValue yearValue:nextYearValue isInMonth:false];
                weekInformationToReturn[@(dayOfWeekIndex + i)] = dayInNextMonth;
            }
        }
        else
        {
            //this is the default case (the 'middle weeks')
            NSInteger dayOfWeekIndex = 0;
            for (int i = 0; i < DAYS_OF_WEEK && dayOfMonthIndex < monthDatesArray.count; i++)
            {
                NSInteger dayInWeekOfMonth = [monthDatesArray[dayOfMonthIndex] integerValue];
                SKDate* dayInWeek = [[SKDate alloc] initWithDay:dayInWeekOfMonth monthValue:monthValue yearValue:yearValue isInMonth:true];
                
                weekInformationToReturn[@(dayOfWeekIndex)] = dayInWeek;
                dayOfWeekIndex += 1;
                dayOfMonthIndex += 1;
            }
        }
        [weeksInMonthInformationToReturn addObject:weekInformationToReturn];
    }
    
    
    return [[SKMonthInfo alloc] initWithStartDay:monthStartDay monthEndDay:monthEndDay numberOfWeeksInMonth:numberOfWeeksInMonth weekDayInfo:weeksInMonthInformationToReturn];

}

-(NSInteger)startdayOfWeek
{
    return self.calendar.firstWeekday;
}
/**
 This is a correctionFactor. A day that falls on a thursday will always have weekday 5. Sunday is 1, Saterday is 7. However, in the weekView, this will be indexnumber 4 when week starts at sunday, and indexnumber 3 when week starts on a monday. If the week was to start on a thursday, the correctionfactor will be 5. Because this day will get index 0 in the weekView in that case.
 The function basically returns this dictionary: [-6:1, -5:2, -4:3, -3:4, -2:5, -1:6, 0:0, 1:1, 2:2, 3:3, 4:4, 5:5, 6:6]
 */
-(NSInteger)indexForDate:(NSInteger)weekDay
{
    NSInteger basicIndex = weekDay - self.startdayOfWeek;
    
    if (basicIndex < 0)
    {
        return basicIndex + 7;
    }
    return basicIndex;
}
@end
