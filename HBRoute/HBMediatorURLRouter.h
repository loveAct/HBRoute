//
//  HBMediatorURLRouter.h
//  HBRoute
//
//  Created by 王海波 on 2019/7/12.
//  Copyright © 2019 王海波. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  routerParameters 里内置的几个参数会用到上面定义的 string
 */
typedef void (^ZYQRouterHandler)(NSDictionary *routerParameters);

/**
 *  需要返回一个 object，配合 objectForURL: 使用
 */
typedef id (^ZYQRouterObjectHandler)(NSDictionary *routerParameters);

NS_ASSUME_NONNULL_BEGIN

@interface HBMediatorURLRouter : NSObject

@end

NS_ASSUME_NONNULL_END
