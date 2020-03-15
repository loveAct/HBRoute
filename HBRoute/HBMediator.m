//
//  HBMediator.m
//  HBRoute
//
//  Created by 王海波 on 2019/7/11.
//  Copyright © 2019 王海波. All rights reserved.
//

#import "HBMediator.h"
#import "HBPerformSelector.h"
#import "NSError+HBError.h"

@interface HBMediator ()

@property (nonatomic) NSMutableDictionary *notFoundBlocks;
@property (nonatomic) NSMutableDictionary *targetsCache;

@property (nonatomic, strong) NSString *targetNotFound;
@property (nonatomic, strong) NSString *targetNotFoundAction;

@end

@implementation HBMediator

+ (instancetype)sharedIsntance
{
    static HBMediator *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.targetNotFound = @"HBTargetNotFound";
        self.targetNotFoundAction = @"NoTargetOrActionResponseError:objectsArr:";
    }
    return self;
}

+ (id)performTarget:(NSString*)targetName action:(NSString*)actionName objectsArr:(NSArray*)objectsArr shouldCacheTaget:(BOOL)shouldCacheTaget {
    id target= [HBMediator sharedIsntance].targetsCache[targetName];
    if (target==nil) {
        Class targetClass=NSClassFromString(targetName);
        target=[[targetClass alloc] init];
    }
    
    if (target==nil) {
        [[HBMediator sharedIsntance] NoTargetOrActionResponse:HBNotFoundHandlerError_NotFoundTarget targetString:targetName selectorString:actionName objectsArr:objectsArr];
        return nil;
    }
    
    SEL action=NSSelectorFromString(actionName);
    
    if (shouldCacheTaget) {
        [HBMediator sharedIsntance].targetsCache[targetName]=target;
    }
    
    if ([target respondsToSelector:action]) {
        return [HBPerformSelector hb_performSelector:action target:target objectsArr:objectsArr];
    }
    else{
        [[HBMediator sharedIsntance] NoTargetOrActionResponse:HBNotFoundHandlerError_NotFoundAction targetString:targetName selectorString:actionName objectsArr:objectsArr];
    }
    
    return nil;
}

+ (void)addNotFoundHandler:(HBNotFoundTargetActionHandler)notFoundHandler targetName:(NSString*)targetName{
    if (!notFoundHandler) {
        return;
    }
    if (targetName) {
        [HBMediator sharedIsntance].notFoundBlocks[targetName]=[notFoundHandler copy];
    }
}

+(void)dealNoTargetOrActionResponseWithTarget:(NSString*)target action:(NSString *)action{
    if (target&& [target isKindOfClass:[NSString class]]) {
        [HBMediator sharedIsntance].targetNotFound = target;
    }
    if (action&& [action isKindOfClass:[NSString class]]) {
        [HBMediator sharedIsntance].targetNotFoundAction= action;
    }
}

/**
 没有找到对应的 对象或方法处理

 @param type 未找到的类型
 @param targetString 对象名称
 @param selectorString 对象方法
 @param objectsArr 参数
 */
- (void)NoTargetOrActionResponse:(HBNotFoundHandlerError)type targetString:(NSString *)targetString selectorString:(NSString *)selectorString objectsArr:(NSArray*)objectsArr
{
    
    NSError *error = nil;
    if (type == HBNotFoundHandlerError_NotFoundTarget) {
       error = [NSError HBNotFoundTargetErrorTargetString:targetString selectorString:selectorString];
    }else{
       error = [NSError HBNotFoundActionErrorTargetString:targetString selectorString:selectorString];
    }
    
    HBNotFoundTargetActionHandler notFoundBlock = [HBMediator sharedIsntance].notFoundBlocks[targetString];
    if (notFoundBlock) {
        notFoundBlock(error,objectsArr);
    }

    SEL action = NSSelectorFromString(self.targetNotFoundAction);
    NSObject *target = [[NSClassFromString(self.targetNotFound) alloc] init];
    if ([target respondsToSelector:action]) {
        [HBPerformSelector hb_performSelector:action target:target withObjects:error,objectsArr];
    }else{
        @throw [NSException exceptionWithName:@"HBMediator.NoTargetOrActionResponse.error"
                                       reason:@"pelease sure deal NoTarNoTargetOrActionResponseget target responds:action"
                                     userInfo:nil];
    }
}


#pragma mark - getter

- (NSMutableDictionary *)targetsCache
{
    if (!_targetsCache) {
        _targetsCache = [[NSMutableDictionary alloc] init];
    }
    return _targetsCache;
}

- (NSMutableDictionary *)notFoundBlocks
{
    if (!_notFoundBlocks) {
        _notFoundBlocks = [[NSMutableDictionary alloc] init];
    }
    return _notFoundBlocks;
}

@end
