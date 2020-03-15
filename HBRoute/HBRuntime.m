//
//  HBRuntime.m
//  HBRoute
//
//  Created by 王海波 on 2019/7/13.
//  Copyright © 2019 王海波. All rights reserved.
//

#import "HBRuntime.h"
#import <objc/runtime.h>

//新生 selector 列表
static NSMutableArray *SelectorList;

@implementation HBRuntime

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (SelectorList == nil) {
        SelectorList = [[NSMutableArray alloc] init];
        [SelectorList addObject:@"methodForAllSelector"];
    }
    
    // 方法存在判断
    for (NSString *selectorString in SelectorList) {
        if ([selectorString isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    // 添加未知 sel
    [SelectorList addObject:NSStringFromSelector(sel)];
    
    SEL originalSelector = @selector(methodForAllSelector);
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    
    // 添加 sel 的实现
    BOOL didAddMethod = class_addMethod([self class], sel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    
    if (didAddMethod) {
        return YES;
    }
    
    return NO;
}

//替代所有未知方法的方法
- (void)methodForAllSelector {
}

@end



@implementation NSObject (HBResolveNoMethod)

#pragma mark - swizzle method
+ (void)swizzleClassMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector {
    [self swizzleInstanceMethod:object_getClass(self) originSelector:originSelector otherSelector:otherSelector];
}

+ (void)swizzleInstanceMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector {
    Method otherMehtod = class_getInstanceMethod(class, otherSelector);
    Method originMehtod = class_getInstanceMethod(class, originSelector);
    
    BOOL didAddMethod = class_addMethod(class, originSelector, method_getImplementation(otherMehtod), method_getTypeEncoding(otherMehtod));
    if (didAddMethod) {
        class_replaceMethod(class, otherSelector, method_getImplementation(originMehtod), method_getTypeEncoding(originMehtod));
    } else {
        // 交换2个方法的实现
        method_exchangeImplementations(otherMehtod, originMehtod);
    }
}

#pragma mark - basic method
+ (void)load {
    if (NSClassFromString(@"NSObject")) {
        SEL originalSelector = @selector(methodSignatureForSelector:);
        SEL swizzledSelector = @selector(swizzled_methodSignatureForSelector:);
        
        [self swizzleInstanceMethod:[NSObject class] originSelector:originalSelector otherSelector:swizzledSelector];
        
        SEL originalSelector1 = @selector(forwardInvocation:);
        SEL swizzledSelector1 = @selector(swizzled_forwardInvocation:);
        
        [self swizzleInstanceMethod:[NSObject class] originSelector:originalSelector1 otherSelector:swizzledSelector1];
    }
}

#pragma mark - 返回方法简介（签名信息）
- (NSMethodSignature *)swizzled_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [self swizzled_methodSignatureForSelector:aSelector];
    if (signature == nil && [NSStringFromClass([self class]) hasPrefix:@"HB"]) {
        if ([HBRuntime instancesRespondToSelector:aSelector]) {
            // 返回一个空的（methodForAllSelector）方法签名
            signature = [HBRuntime instanceMethodSignatureForSelector:aSelector];
        }
    }
    return signature;
}

#pragma mark - 方法传递
- (void)swizzled_forwardInvocation:(NSInvocation *)anInvocation {
    if ([self respondsToSelector:anInvocation.selector]) {
        [self swizzled_forwardInvocation:anInvocation];
    } else if ([NSStringFromClass([self class]) hasPrefix:@"HB"]) {
#ifdef DEBUG
        NSAssert(NO, @"找不到方法：%@:%@", NSStringFromClass([self class]), NSStringFromSelector(anInvocation.selector));
#else
        DDLogWarn(@"there is a serious problem with method name:[%@ %@]",
                  NSStringFromClass([self class]),
                  NSStringFromSelector(anInvocation.selector));
#endif
    } else {
        [self swizzled_forwardInvocation:anInvocation];
    }
}

@end
