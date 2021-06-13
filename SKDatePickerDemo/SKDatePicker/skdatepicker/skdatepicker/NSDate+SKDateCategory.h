//
//  NSDate+SKDateCategory.h
//  skdatepicker
//
//  Created by xiw on 2021/5/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (SKDateCategory)
-(NSDate*)stripped;
-(NSDate*)updateHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second;
-(void)getHour:(nonnull NSUInteger*)hour minute:(nonnull NSUInteger*)minute second:(nonnull NSUInteger*)second;
@end

NS_ASSUME_NONNULL_END
