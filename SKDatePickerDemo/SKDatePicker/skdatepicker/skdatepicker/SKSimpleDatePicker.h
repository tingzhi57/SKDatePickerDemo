//
//  SKSimpleDataPicker.h
//  skdatepicker
//
//  Created by xiw on 2021/6/6.
//

#import <skdatepicker/SKColumnPicker.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DateComponents)
{
    DateComponentYear = 0,
    DateComponentMonth,
    DateComponentDay,
    DateComponentAll
};

@interface SKSimpleDatePicker : SKColumnPicker

@property (nonatomic, retain, nullable) NSDate* date;
@property (nonatomic, assign) DateComponents lastComponent;
@property (nonatomic, copy) NSString* dateFormateString;

-(void)updateDatePlainText;
@end

NS_ASSUME_NONNULL_END
