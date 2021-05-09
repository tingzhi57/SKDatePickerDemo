//
//  SKDatePickerManager.h
//  skdatepicker
//
//  Created by xiw on 2021/5/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SKMonthInfo;
@class SKDatePickerView;

@interface SKDatePickerManager : NSObject
@property (nonatomic, strong) NSCalendar* calendar;
-(instancetype)initWithPickerView:(SKDatePickerView*)datePickerView;
-(SKMonthInfo*)getMonthInfoForDate:(NSDate*)date;

-(NSInteger)startdayOfWeek;
@end

NS_ASSUME_NONNULL_END
