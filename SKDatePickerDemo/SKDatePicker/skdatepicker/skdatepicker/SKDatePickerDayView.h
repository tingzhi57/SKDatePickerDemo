//
//  SKDatePickerDayView.h
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import <UIKit/UIKit.h>
#import "SKDatePickerViewDelegate.h"
@class SKDatePickerView;
@class SKDatePickerMonthView;
@class SKDatePickerWeekView;
@class SKDate;
NS_ASSUME_NONNULL_BEGIN

@interface SKDatePickerDayView : UIView

@property (nonatomic, strong) NSDate* date;
@property (nonatomic, weak) SKDatePickerView* datePickerView;

-(instancetype)initWithPickerView:(SKDatePickerView*)pickerView monthView:(SKDatePickerMonthView*)monthView weekView: (SKDatePickerWeekView*)weekView index:(NSUInteger)index dayInfo: (SKDate*)dayInfo;

-(id<SKDatePickerViewDelegate>)delegate;
-(BOOL)isToday;
-(void)deselect;
-(void)select;
-(void)reloadContent;

-(BOOL)shouldSelectedInPeriod:(NSDate*)start to:(NSDate*)end;
@end

NS_ASSUME_NONNULL_END
