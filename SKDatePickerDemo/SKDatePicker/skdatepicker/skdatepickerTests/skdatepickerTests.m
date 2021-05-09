//
//  skdatepickerTests.m
//  skdatepickerTests
//
//  Created by xiw on 2021/5/3.
//

#import <XCTest/XCTest.h>

#import <skdatepicker/SKDatePickerManager.h>
#import <skdatepicker/SKDate.h>


@interface skdatepickerTests : XCTestCase

@end

@implementation skdatepickerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSLog(@"firstDayOfWeek:%ld,%@",calendar.firstWeekday,calendar.shortWeekdaySymbols);
    
    SKDatePickerManager* dateManager = [SKDatePickerManager new];
    XCTAssertTrue([dateManager getMonthInfoForDate:nil] == nil);
    
    NSDateComponents * components = [calendar components:(NSCalendarUnitWeekOfMonth | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate now]];
    
    for (int i = 0; i < 0; i++)
    {
        SKMonthInfo* monthInfo = [dateManager getMonthInfoForDate:[calendar dateFromComponents:components]];
        NSLog(@"%@-%@ has %ld numberOfWeeksInMonth ",monthInfo.monthStartDay,monthInfo.monthEndDay,monthInfo.numberOfWeeksInMonth);
        XCTAssertTrue(monthInfo.numberOfWeeksInMonth == monthInfo.weekDayInfo.count);
        components.month --;
    }
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
