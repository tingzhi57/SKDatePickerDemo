//
//  SKDatePickerMonthView.h
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SKDate;
@class SKDatePickerView;
@class SKDatePickerDayView;
@class SKMonthInfo;

NS_ASSUME_NONNULL_BEGIN

@interface SKDatePickerMonthView : UIStackView

@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) SKMonthInfo* monthInfo;
@property (nonatomic, copy) NSString* monthDescription;
@property (nonatomic, assign) BOOL isPresented;

-(instancetype)initWithPickerView:(SKDatePickerView*)pickerView date:(NSDate*)date isPresented:(BOOL)isPresented;

-(void)reloadSubViewsWithFrame:(CGRect)frame;
-(void)createWeekViews;

-(void)clearAllSelectDays;
-(void)selectDate:(NSDate*)date;
-(void)selectPeriod:(NSDate*)start end:(NSDate*)end;
-(void)addSelectDayView:(SKDatePickerDayView*)dayView;
@end

NS_ASSUME_NONNULL_END
