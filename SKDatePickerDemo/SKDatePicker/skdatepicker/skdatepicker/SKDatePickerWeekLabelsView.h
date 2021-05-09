//
//  SKDatePickerWeekLabelsView.h
//  skdatepicker
//
//  Created by xiw on 2021/5/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SKDatePickerView;
@interface SKDatePickerWeekLabelsView : UIStackView
-(instancetype)initWithPickerView:(SKDatePickerView*)pickerView;
@end

NS_ASSUME_NONNULL_END
