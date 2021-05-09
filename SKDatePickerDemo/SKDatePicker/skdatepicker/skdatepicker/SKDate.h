//
//  SKDate.h
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKDate : NSObject
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) BOOL isInMonth;
@property (nonatomic, readonly) NSDate* date;

-(instancetype)initWithDay:(NSInteger)dayValue monthValue:(NSInteger)monthValue yearValue:(NSInteger)yearValue isInMonth:(BOOL)isInMonth;

@end

@interface SKMonthInfo : NSObject

@property (nonatomic, strong) NSDate* monthStartDay;
@property (nonatomic, strong) NSDate* monthEndDay;
@property (nonatomic, assign) NSInteger numberOfWeeksInMonth;

@property (nonatomic, strong) NSArray<NSDictionary<NSNumber*,SKDate*>*>* weekDayInfo;
-(instancetype)initWithStartDay:(NSDate*)monthStartDay monthEndDay:(NSDate*)monthEndDay numberOfWeeksInMonth:(NSInteger)numberOfWeeksInMonth weekDayInfo:(NSArray<NSDictionary<NSNumber*,SKDate*>*>*)weekDayInfo;
@end

NS_ASSUME_NONNULL_END
