//
//  NSLayoutConstraint+SKConstraint.m
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import "NSLayoutConstraint+SKConstraint.h"

@implementation NSLayoutConstraint (SKConstraint)

+(void)addSKCenterXAndYConstraints:(UIView*)item superView:(UIView*)superView
{
    item.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint* centerXConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
    NSLayoutConstraint* centerYConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    [NSLayoutConstraint activateConstraints:@[centerXConstraint, centerYConstraint]];
}

+(void)addEqualToConstraints:(UIView*)item superView:(UIView*)superView attributes:(NSArray<NSNumber*>*)attributes
{
    [NSLayoutConstraint addEqualToConstraints:item itemAttributes:nil superView:superView superAttributes:nil otherAttributes:attributes];
}

+(void)addEqualToConstraints:(UIView*)item itemAttributes:(nullable NSArray<NSNumber*>* )itemAttributes superView:(UIView*)superView  superAttributes:(nullable NSArray<NSNumber*>* )superAttributes otherAttributes:(NSArray<NSNumber*>*)antherAttributes
{
    if ([item isKindOfClass:[UIView class]])
    {
        ((UIView*)item).translatesAutoresizingMaskIntoConstraints = false;
    }
    
    NSMutableArray<NSLayoutConstraint*>* constraints = [NSMutableArray arrayWithCapacity:itemAttributes.count + antherAttributes.count];
    
    if (itemAttributes.count == superAttributes.count)
    {
        for (NSUInteger index = 0; index < itemAttributes.count; index++)
        {
            NSLayoutAttribute itemAttribute = [[itemAttributes objectAtIndex:index] integerValue];
            NSLayoutAttribute superAttribute = [[superAttributes objectAtIndex:index] integerValue];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:item attribute:itemAttribute relatedBy:NSLayoutRelationEqual toItem:superView attribute:superAttribute multiplier:1.0f constant:0]];
        }
         
    }
    
    for (NSNumber* attributeNumber in antherAttributes)
    {
        NSLayoutAttribute attribute = [attributeNumber integerValue];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:item attribute:attribute relatedBy:NSLayoutRelationEqual toItem:superView attribute:attribute multiplier:1.0f constant:0]];
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
}

+(void)addLessOrEqualToConstraints:(UIView*)item superView:(UIView*)superView attributes:(NSArray<NSNumber*>*)attributes
{
    [NSLayoutConstraint addLessOrEqualToConstraints:item itemAttributes:nil superView:superView superAttributes:nil otherAttributes:attributes];
}

+(void)addLessOrEqualToConstraints:(UIView*)item itemAttributes:(nullable NSArray<NSNumber*>* )itemAttributes superView:(UIView*)superView  superAttributes:(nullable NSArray<NSNumber*>* )superAttributes otherAttributes:(NSArray<NSNumber*>*)antherAttributes
{
    item.translatesAutoresizingMaskIntoConstraints = false;
    NSMutableArray<NSLayoutConstraint*>* constraints = [NSMutableArray arrayWithCapacity:itemAttributes.count + antherAttributes.count];
    
    if (itemAttributes.count == superAttributes.count)
    {
        for (NSUInteger index = 0; index < itemAttributes.count; index++)
        {
            NSLayoutAttribute itemAttribute = [[itemAttributes objectAtIndex:index] integerValue];
            NSLayoutAttribute superAttribute = [[superAttributes objectAtIndex:index] integerValue];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:item attribute:itemAttribute relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:superAttribute multiplier:1.0f constant:0]];
        }
         
    }
    
    for (NSNumber* attributeNumber in antherAttributes)
    {
        NSLayoutAttribute attribute = [attributeNumber integerValue];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:item attribute:attribute relatedBy:NSLayoutRelationLessThanOrEqual toItem:superView attribute:attribute multiplier:1.0f constant:0]];
    }
    
    [NSLayoutConstraint activateConstraints:constraints];
}
@end
