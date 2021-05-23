//
//  SKDatePickerDemoTests.m
//  SKDatePickerDemoTests
//
//  Created by xiw on 2021/5/6.
//

#import <XCTest/XCTest.h>
#import <vector>

@interface SKDatePickerDemoTests : XCTestCase

@end

@implementation SKDatePickerDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSLog(@"%s,begin",__func__);
    std::vector<char> testlist{'a','c','s','a','i','c','o','a'};
    for (int i = 0; i < testlist.size() ; i++)
    {
        if (testlist[i] == 'a')
        {
            testlist.erase(testlist.begin()+i);
            i--;
            continue;
        }
        printf("%c",testlist[i]);
    }
    printf("\n");
    NSLog(@"%s,end",__func__);
    
    
    NSDateComponents* component = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday  | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    component.month -= 7;
    component.day -= 27;
    
    NSLog(@"component.month:%ld,component.day:%ld",component.month,component.day);
    NSLog(@"component.date:%@", [[NSCalendar currentCalendar] dateFromComponents:component]);
    
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
