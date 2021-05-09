//
//  NSLayoutConstraint+SKConstraint.h
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (SKConstraint)
+(void)addSKCenterXAndYConstraints:(UIView*)item superView:(UIView*)superView;
+(void)addEqualToConstraints:(UIView*)item superView:(UIView*)superView attributes:(NSArray<NSNumber*>*)attributes;
+(void)addEqualToConstraints:(UIView*)item itemAttributes:(nullable NSArray<NSNumber*>* )itemAttributes superView:(UIView*)superView  superAttributes:(nullable NSArray<NSNumber*>* )superAttributes otherAttributes:(NSArray<NSNumber*>*)antherAttributes;

+(void)addLessOrEqualToConstraints:(UIView*)item superView:(UIView*)superView attributes:(NSArray<NSNumber*>*)attributes;

+(void)addLessOrEqualToConstraints:(UIView*)item itemAttributes:(nullable NSArray<NSNumber*>* )itemAttributes superView:(UIView*)superView  superAttributes:(nullable NSArray<NSNumber*>* )superAttributes otherAttributes:(NSArray<NSNumber*>*)antherAttributes;
@end

NS_ASSUME_NONNULL_END
