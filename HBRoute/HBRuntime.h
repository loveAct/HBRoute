//
//  HBRuntime.h
//  HBRoute
//
//  Created by 王海波 on 2019/7/13.
//  Copyright © 2019 王海波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBRuntime : NSObject

@end

@interface NSObject (HBResolveNoMethod)

#pragma mark - swizzle method

+ (void)swizzleClassMethod:(Class) class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector;

+ (void)swizzleInstanceMethod:(Class) class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector;

@end

