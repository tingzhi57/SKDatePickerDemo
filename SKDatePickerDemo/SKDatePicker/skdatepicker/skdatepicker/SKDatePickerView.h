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
@property (nonatomic, assign) CGSize weekViewSize;
@property (nonatomic, assign) CGSize dayViewSize;
@property (nonatomic, assign) id<SKDatePickerViewDelegate> delegate;
@property (nonatomic, strong, readonly) NSDate* dateToPresent;
@property (nonatomic, weak) SKDatePickerDayView* selectedDateView;
@property (nonatomic, weak) SKDatePickerMonthView* presentedMonthView;

-(BOOL)dateIsSelectable:(NSDate*)date;
-(void)didTapDayView:(SKDatePickerDayView *)dayView;

-(NSInteger)firstWeekDay;
-(void)loadNextView;
-(void)loadPreviousView;

-(BOOL)shouldShowMonthOutDates;

-(BOOL)shouldContinueSelection;
-(NSDate*)periodStartDate;
-(NSDate*)periodEndDate;

-(BOOL)shouldShowTopToolBar;
@end

NS_ASSUME_NONNULL_END
