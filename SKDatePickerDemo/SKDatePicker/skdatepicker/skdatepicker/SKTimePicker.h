//
//  SKTimePicker.h
//  skdatepicker
//
//  Created by xiw on 2021/5/24.
//

#import "SKColumnPicker.h"
#import "SKDatePickerViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TimeComponents)
{
    TimeComponentHour = 0,
    TimeComponentMinute,
    TimeComponentSecond,
    TimeComponentAll
};

@class SKTimePicker;

@protocol SKTimePickerDelegate <NSObject>
@required
-(void)timeValueChanged:(SKTimePicker*)timePicker;
-(bool)validateTimeValue:(SKTimePicker*)timePicker;
@end

@interface SKTimePicker : SKColumnPicker

@property (nonatomic, retain, nullable) NSDate* date;
@property (nonatomic, assign) NSUInteger hour;
@property (nonatomic, assign) NSUInteger minute;
@property (nonatomic, assign) NSUInteger second;

@property (nonatomic, copy) NSString* dateFormateString;
@property (nonatomic, copy) NSString* timeFormateString;

@property (nonatomic, assign) TimeComponents lastComponent;

@property (nonatomic, assign) id<SKTimePickerDelegate> timer_delegate;

-(void)updateTimePlainText;
@end

NS_ASSUME_NONNULL_END
