//
//  HBMediator.h
//  HBRoute
//
//  Created by 王海波 on 2019/7/11.
//  Copyright © 2019 王海波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBTargetNotFound.h"

typedef void (^ZMRouterHandler)(NSDictionary *routerParameters);

/**
 *  没有找到对应方法的回调
 */
typedef id (^HBNotFoundTargetActionHandler)(NSError* error,NSArray *objectsArr);

/**
 用于去除产生的performSelector警告
 */
#define ZM_SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


NS_ASSUME_NONNULL_BEGIN

@interface HBMediator : NSObject


/**
 执行方法

 @param targetName 对象名称
 @param actionName 方法名称
 @param objectsArr 参数
 @param shouldCacheTaget 是否缓存
 @return 返回值
 */
+ (id)performTarget:(NSString*)targetName action:(NSString*)actionName objectsArr:(NSArray*)objectsArr shouldCacheTaget:(BOOL)shouldCacheTaget;
/**
 添加对象  没有找到对应方法和对象的回调

 @param notFoundHandler 没有找到对应方法的回调
 @param targetName 对象名称
 */
+ (void)addNotFoundHandler:(HBNotFoundTargetActionHandler)notFoundHandler targetName:(NSString*)targetName;

+(void)dealNoTargetOrActionResponseWithTarget:(NSString*)target action:(NSString *)action;

@end

NS_ASSUME_NONNULL_END
