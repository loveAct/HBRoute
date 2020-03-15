//
//  NSError+HBError.m
//  HBRoute
//
//  Created by 王海波 on 2019/7/11.
//  Copyright © 2019 王海波. All rights reserved.
//

#import "NSError+HBError.h"

NSString * const HBDomainError = @"com.wlrroute.error";

@implementation NSError (HBError)

+(NSError *)HBNotFoundTargetErrorTargetString:(NSString *)targetString selectorString:(NSString *)selectorString{
    NSDictionary *userInfo = @{@"targetString":targetString,@"selectorString":selectorString,@"errorType":@"NotFoundTargetError"};
    return [self HBErrorWithCode:HBErrorNotFoundTarget userInfo:userInfo];
}

+(NSError *)HBNotFoundActionErrorTargetString:(NSString *)targetString selectorString:(NSString *)selectorString{
    NSDictionary *userInfo = @{@"targetString":targetString,@"selectorString":selectorString,@"errorType":@"NotFoundActionError"};
    return [self HBErrorWithCode:HBErrorNotFoundAction userInfo:userInfo];
}

+(NSError *)HBErrorWithCode:(NSInteger)code msg:(NSString *)msg{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(msg, nil) };
    return [self HBErrorWithCode:code userInfo:userInfo];
}

+(NSError *)HBErrorWithCode:(NSInteger)code userInfo:(NSDictionary*)userInfo{
    return [NSError errorWithDomain:HBDomainError code:code userInfo:userInfo];
}

@end
