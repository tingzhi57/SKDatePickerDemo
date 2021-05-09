//
//  SKDatePickerSelectionView.h
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class SKDatePickerDayView;
@interface SKDatePickerSelectionView : UIView

-(instancetype)initWithDayView:(SKDatePickerDayView*)dayView frame: (CGRect)frame isSemiSelected:(BOOL)isSemiSelected;

@end

NS_ASSUME_NONNULL_END
