//
//  NSError+HBError.h
//  HBRoute
//
//  Created by 王海波 on 2019/7/11.
//  Copyright © 2019 王海波. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WLRError) {
    HBErrorNotFoundTarget = 45150,
    HBErrorNotFoundAction = 45150,
};

NS_ASSUME_NONNULL_BEGIN

@interface NSError (HBError)

+(NSError *)HBNotFoundTargetErrorTargetString:(NSString *)targetString selectorString:(NSString *)selectorString;

+(NSError *)HBNotFoundActionErrorTargetString:(NSString *)targetString selectorString:(NSString *)selectorString;

@end

NS_ASSUME_NONNULL_END
