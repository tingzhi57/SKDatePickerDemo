//
//  SKDatePickerContentControll.h
//  skdatepicker
//
//  Created by xiw on 2021/5/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SKDatePickerView;
@interface SKDatePickerContentControll : NSObject

@property (nonatomic, retain) NSDate* startDate;
@property (nonatomic, retain) NSDate* endDate;
@property (nonatomic, strong, readonly) UIScrollView* scrollView;
-(instancetype)initWithPickerView:(SKDatePickerView*)pickerView frame:(CGRect)frame presentedDate:(NSDate*)date;

-(void)updateScrollViewFrame:(CGRect)frame;
-(void)presentNextView;
-(void)presentPreviousView;

-(void)reSelectPeriodDays;
-(BOOL)calculateStartDateAndEndDate:(NSDate*)selectDate;
@end

NS_ASSUME_NONNULL_END
