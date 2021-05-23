//
//  SKDatePickerView.h
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import <UIKit/UIKit.h>
#import <skdatepicker/SKDatePickerViewDelegate.h>

NS_ASSUME_NONNULL_BEGIN
@class SKDatePickerDayView;
@class SKDatePickerMonthView;
@class SKDatePickerManager;

@interface SKDatePickerView : UIView
@property (nonatomic, strong, readonly) SKDatePickerManager* manager;
@property (nonatomic, strong, readonly) NSCalendar* calendar;
@property (nonatomic, assign) CGSize weekViewSize;
@property (nonatomic, assign) CGSize dayViewSize;
@property (nonatomic, assign) id<SKDatePickerViewDelegate> delegate;
@property (nonatomic, strong, readonly) NSDate* dateToPresent;
@property (nonatomic, weak) SKDatePickerDayView* selectedDateView;
@property (nonatomic, weak) SKDatePickerMonthView* presentedMonthView;

-(void)presentStartDate:(nonnull NSDate*)startDate endDate:(nonnull NSDate*)endDate;

-(BOOL)dateIsSelectable:(NSDate*)date;
-(void)didTapDayView:(SKDatePickerDayView *)dayView;
-(void)didSelectContinueDayFrom:(NSDate*)start to:(NSDate*)end;

-(NSInteger)firstWeekDay;
-(void)loadNextView;
-(void)loadPreviousView;

-(BOOL)shouldShowMonthOutDates;

-(BOOL)shouldContinueSelection;
-(NSDate*)periodStartDate;
-(NSDate*)periodEndDate;

-(BOOL)shouldShowTopToolBar;

-(UIColor*)colorForDayLabelInMonth;
-(UIColor*)colorForUnavaibleDay;
@end

NS_ASSUME_NONNULL_END
