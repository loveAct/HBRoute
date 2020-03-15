//
//  HBPerformSelector.h
//  HBRoute
//
//  Created by 王海波 on 2019/7/11.
//  Copyright © 2019 王海波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBPerformSelector : NSObject

/**
 不定参方法调用
 [self hb_performSelector:@selector(actionWithObj1:obj2:obj3:) withObjects:obj1,obj2,obj3,nil]
 
 @param selector 方法名
 @param target   对象
 @param object1 ,... 不定参数 不支持C基本类型
 @return 返回值
 */
+ (id)hb_performSelector:(SEL)selector target:(NSObject *)target withObjects:(id)object1,...;
/**
 不定参方法调用
 
 @param selector 方法名
 @param target   对象
 @param objects 参数数组 可不传
 @return 返回值 可为nil
 */
+ (id)hb_performSelector:(SEL)selector target:(NSObject *)target objectsArr:(NSArray *)objects;


@end

NS_ASSUME_NONNULL_END
