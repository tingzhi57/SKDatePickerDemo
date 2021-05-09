//
//  SKDatePickerWeekView.h
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class SKDatePickerView;
@class SKDatePickerMonthView;
@class SKDatePickerDayView;
@interface SKDatePickerWeekView : UIStackView
-(instancetype)initWithPickerView:(SKDatePickerView*)pickerView monthView:(SKDatePickerMonthView*)monthView index:(NSUInteger)index;

-(NSArray<SKDatePickerDayView*>*)getDaysFrom:(NSDate*)start to:(nullable NSDate*)end;
@end

NS_ASSUME_NONNULL_END
