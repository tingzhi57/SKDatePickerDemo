//
//  SKColumnPicker.h
//  skdatepicker
//
//  Created by xiw on 2021/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SKColumnPicker;

@protocol SKColumnPickerDelegate <NSObject>
@required
//- (NSInteger)numberOfColumnInPickerView:(SKColumnPicker *)pickerView;
- (void)pickerViewDidSelectColumn:(SKColumnPicker *)pickerView;
//@optional
@end

@interface SKColumnPicker : UIView
@property (nonatomic, assign) id<UIPickerViewDataSource> datasource;
@property (nonatomic, assign) id<SKColumnPickerDelegate> delegate;

-(UIPickerView*)columnView;
-(UITextField*)plainField;
@end

NS_ASSUME_NONNULL_END
