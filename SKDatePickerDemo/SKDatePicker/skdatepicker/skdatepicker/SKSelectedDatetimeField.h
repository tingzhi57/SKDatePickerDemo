//
//  SKSelectedDatetimeField.h
//  skdatepicker
//
//  Created by xiw on 2021/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SKDatePickerView;
@interface SKSelectedDatetimeField : UIView

@property (nonatomic,retain) NSDate* dateAndTime;
@property (nonatomic,retain) NSDate* endDateAndTime;

-(void)setupUI:(SKDatePickerView*)datepickerView otherContraints:(NSMutableArray<NSLayoutConstraint *>*)otherActiveConstraints;

-(void)notifyTimeChanged:(NSDate*)date;
-(void)notifyPeriodTimeChanged:(NSDate*)date to:(NSDate*)endDate;
-(void)notifyDateChanged:(NSDate*)date;
-(void)notifyPeriodDateChanged:(NSDate*)startDate to:(NSDate*)endDate;
@end

NS_ASSUME_NONNULL_END
