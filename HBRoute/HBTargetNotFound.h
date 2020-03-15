//
//  HBTargetNotFound.h
//  HBRoute
//
//  Created by 王海波 on 2019/7/11.
//  Copyright © 2019 王海波. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HBNotFoundHandlerError){
    HBNotFoundHandlerError_NotFoundTarget,//没有找到对象
    HBNotFoundHandlerError_NotFoundAction //没有找到方法
};
NS_ASSUME_NONNULL_BEGIN

@interface HBTargetNotFound : NSObject

- (void)NoTargetOrActionResponseError:(NSError*)error objectsArr:(NSArray *)objectsArr;

@end

NS_ASSUME_NONNULL_END
