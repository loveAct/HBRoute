//
//  HBPerformSelector.m
//  HBRoute
//
//  Created by 王海波 on 2019/7/11.
//  Copyright © 2019 王海波. All rights reserved.
//

#import "HBPerformSelector.h"

@implementation HBPerformSelector

/**
 不定参方法调用
 [self hb_performSelector:@selector(actionWithObj1:obj2:obj3:) withObjects:obj1,obj2,obj3,nil]
 
 @param selector 方法名
 @param target   对象
 @param object1 ,... 不定参数 不支持C基本类型
 @return 返回值
 */
+ (id)hb_performSelector:(SEL)selector target:(NSObject *)target withObjects:(id)object1,...
{
    NSMutableArray *objectsArr=[[NSMutableArray alloc] init];
    
    if (object1)
    {
        va_list argsList;
        [objectsArr addObject:object1];
        va_start(argsList, object1);
        id arg;
        while ((arg = va_arg(argsList, id)))
        {
            [objectsArr addObject:arg];
        }
        va_end(argsList);
    }
    
    return [self hb_performSelector:selector target:target objectsArr:objectsArr];
}

/**
 不定参方法调用
 
 @param selector 方法名
 @param objects 参数数组 可不传
 @return 返回值 可为nil
 */
+ (id)hb_performSelector:(SEL)selector target:(NSObject *)target objectsArr:(NSArray *)objects
{
    // 方法签名
    NSMethodSignature* signature = [target methodSignatureForSelector:selector];
    if(signature == nil){
        NSLog(@"target: %@ error %@ 方法找不到",self, NSStringFromSelector(selector));
        //[NSException raise:@"target error" format:@"%@方法找不到",NSStringFromSelector(selector)];
        return nil;
    }
    
    // 利用一个NSInvocation对象包装一次方法调用(方法调用者,方法名,方法参数,方法返回值)
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    
    // 设置参数
    NSInteger paramsCount = signature.numberOfArguments - 2; // 除self/_cmd以外的参数个数
    paramsCount = MIN(paramsCount, objects.count);
    
    
    for( NSInteger i = 0; i<paramsCount; i++) {
        id object = objects[i];
        if([object isKindOfClass:[NSNull class]]) continue;
        
        [invocation setArgument:&object atIndex:i+2];
    }
    //获取返回值类型
    const char* retType = [signature methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    
    // 调用方法
    [invocation invoke];
    // 获取返回值
    id returnValue = nil;
    if(signature.methodReturnLength) {
        // 有返回值类型,才去获得返回值
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}

@end
