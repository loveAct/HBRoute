//
//  HBMediatorURLRouter.m
//  HBRoute
//
//  Created by 王海波 on 2019/7/12.
//  Copyright © 2019 王海波. All rights reserved.
//

#import "HBMediatorURLRouter.h"

static NSString * const ZYQ_ROUTER_WILDCARD_CHARACTER = @"~";

@interface HBMediatorURLRouter ()
/**
 *  保存了所有已注册的 URL
 *  结构类似 @{@"beauty": @{@":id": {@"_", [block copy]}}}
 */
@property (nonatomic) NSMutableDictionary *routes;

@property (nonatomic) NSMutableDictionary *redirectRoutes;

@property (nonatomic) NSDictionary *unFoundRoutesBlock;

@end


@implementation HBMediatorURLRouter

//+ (void)redirectURLPattern:(NSString *)URLPattern toURLPattern:(NSString*)newURLPattern{
//    [self addRedirectURLPattern:URLPattern toURLPattern:newURLPattern];
//}
//
//+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(ZYQRouterHandler)handler
//{
//    [self addURLPattern:URLPattern andHandler:handler];
//}
//
//+ (void)registerUnFoundURLPatternToObjectHandler:(ZYQRouterObjectHandler)handler{
//    [[self sharedIsntance] setUnFoundRoutesBlock:@{@"block":[handler copy],@"type":@"ZYQRouterObjectHandler"}];
//}
//
//+ (void)registerUnFoundURLPatternToHandler:(ZYQRouterHandler)handler
//{
//    [[self sharedIsntance] setUnFoundRoutesBlock:@{@"block":[handler copy],@"type":@"ZYQRouterHandler"}];
//}
//
//+ (void)deregisterUnFoundURLPatternToHandler{
//    [[self sharedIsntance] setUnFoundRoutesBlock:nil];
//}
//
//+ (void)deregisterURLPattern:(NSString *)URLPattern
//{
//    [[self sharedIsntance] removeURLPattern:URLPattern];
//}
//
//+ (void)openURL:(NSString *)URL
//{
//    [self openURL:URL completion:nil];
//}
//
//+ (void)openURL:(NSString *)URL completion:(void (^)(id result))completion
//{
//    [self openURL:URL withUserInfo:nil completion:completion];
//}
//
//+ (void)openURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo completion:(void (^)(id result))completion
//{
//    NSArray *tmpUrlArr=[[[self sharedIsntance] getRedirectURLPattern:URL] componentsSeparatedByString:@"?"];
//    NSString *redirectURL=tmpUrlArr.count>0?tmpUrlArr[0]:URL;
//    URL = redirectURL?redirectURL:URL;
//    URL = [NSString stringWithFormat:@"%@?%@",URL,tmpUrlArr.count>1?tmpUrlArr[1]:@""];
//    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSMutableDictionary *parameters = [[self sharedIsntance] extractParametersFromURL:URL];
//
//    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop) {
//        if ([obj isKindOfClass:[NSString class]]) {
//            parameters[key] = [obj stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        }
//    }];
//
//    if (parameters) {
//        NSDictionary *handlerDic = parameters[@"block"];
//
//        if (completion) {
//            parameters[ZYQRouterParameterCompletion] = completion;
//        }
//        if (userInfo) {
//            parameters[ZYQRouterParameterUserInfo] = userInfo;
//        }
//
//        if (handlerDic) {
//            if ([handlerDic[@"type"] isEqualToString:@"ZYQRouterHandler"]) {
//                ZYQRouterHandler handler=handlerDic[@"block"];
//                [parameters removeObjectForKey:@"block"];
//                if (handler) {
//                    handler(parameters);
//                }
//            }
//            if ([handlerDic[@"type"] isEqualToString:@"ZYQRouterObjectHandler"]) {
//                ZYQRouterObjectHandler handler=handlerDic[@"block"];
//                if (handler) {
//                    [parameters removeObjectForKey:@"block"];
//                    id result = handler(parameters);
//                    if (completion) {
//                        completion(result);
//                    }
//                }
//            }
//        }
//    }
//}
//
//+ (BOOL)canRedirectURL:(NSString*)URL{
//    return [[self sharedIsntance] getRedirectURLPattern:URL] ? YES : NO;
//}
//
//+ (BOOL)canOpenURL:(NSString *)URL
//{
//    return [[self sharedIsntance] extractParametersFromURL:URL] ? YES : NO;
//}
//
//+ (NSString *)generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters
//{
//    NSInteger startIndexOfColon = 0;
//    NSMutableArray *items = [[NSMutableArray alloc] init];
//    NSInteger parameterIndex = 0;
//
//    for (int i = 0; i < pattern.length; i++) {
//        NSString *character = [NSString stringWithFormat:@"%c", [pattern characterAtIndex:i]];
//        if ([character isEqualToString:@":"]) {
//            startIndexOfColon = i;
//        }
//        if (([@[@"/", @"?", @"&"] containsObject:character] || (i == pattern.length - 1 && startIndexOfColon) ) && startIndexOfColon) {
//            if (i > (startIndexOfColon + 1)) {
//                [items addObject:[NSString stringWithFormat:@"%@%@", [pattern substringWithRange:NSMakeRange(0, startIndexOfColon)], parameters[parameterIndex++]]];
//                pattern = [pattern substringFromIndex:i];
//                i = 0;
//            }
//            startIndexOfColon = 0;
//        }
//    }
//
//    return [items componentsJoinedByString:@""];
//}
//
//+ (id)objectForURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo
//{
//    ZMMediator *router = [ZMMediator sharedIsntance];
//
//    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSMutableDictionary *parameters = [router extractParametersFromURL:URL];
//    NSDictionary *handlerDic = parameters[@"block"];
//
//    if (handlerDic) {
//        if (userInfo) {
//            parameters[ZYQRouterParameterUserInfo] = userInfo;
//        }
//        if ([handlerDic[@"type"] isEqualToString:@"ZYQRouterObjectHandler"]) {
//            ZYQRouterObjectHandler handler=handlerDic[@"block"];
//            [parameters removeObjectForKey:@"block"];
//            return handler(parameters);
//
//        }
//    }
//    return nil;
//}
//
//+ (id)objectForURL:(NSString *)URL
//{
//    return [self objectForURL:URL withUserInfo:nil];
//}
//
//
//+ (void)registerURLPattern:(NSString *)URLPattern toObjectHandler:(ZYQRouterObjectHandler)handler
//{
//    [[self sharedIsntance] addURLPattern:URLPattern andObjectHandler:handler];
//}

- (void)addRedirectURLPattern:(NSString *)URLPattern toURLPattern:(NSString*)newURLPattern{
    if (URLPattern) {
        if (newURLPattern) {
            [self.redirectRoutes setObject:newURLPattern forKey:URLPattern];
        }
        else{
            [self.redirectRoutes removeObjectForKey:URLPattern];
        }
    }
}

- (NSString*)getRedirectURLPattern:(NSString *)URLPattern{
    if (URLPattern) {
        NSString *redirectURL=[self getRedirectURLPattern:self.redirectRoutes[URLPattern]];
        if (redirectURL) {
            return redirectURL;
        }
        else{
            return URLPattern;
        }
    }
    return nil;
}

- (void)addURLPattern:(NSString *)URLPattern andHandler:(ZYQRouterHandler)handler
{
    NSMutableDictionary *subRoutes = [self addURLPattern:URLPattern];
    if (handler && subRoutes) {
        subRoutes[@"_"] = @{@"block":[handler copy],@"type":@"ZYQRouterHandler"};
    }
}

- (void)addURLPattern:(NSString *)URLPattern andObjectHandler:(ZYQRouterObjectHandler)handler
{
    NSMutableDictionary *subRoutes = [self addURLPattern:URLPattern];
    if (handler && subRoutes) {
        subRoutes[@"_"] = @{@"block":[handler copy],@"type":@"ZYQRouterObjectHandler"};
    }
}

- (NSMutableDictionary *)addURLPattern:(NSString *)URLPattern
{
    NSArray *pathComponents = [self pathComponentsFromURL:URLPattern];
    
    NSInteger index = 0;
    NSMutableDictionary* subRoutes = self.routes;
    
    while (index < pathComponents.count) {
        NSString* pathComponent = pathComponents[index];
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
        index++;
    }
    return subRoutes;
}


- (NSArray*)pathComponentsFromURL:(NSString*)URL
{
    NSMutableArray *pathComponents = [NSMutableArray array];
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        // 如果 URL 包含协议，那么把协议作为第一个元素放进去
        [pathComponents addObject:pathSegments[0]];
        
        // 如果只有协议，那么放一个占位符
        if ((pathSegments.count >= 2 && ((NSString *)pathSegments[1]).length) || pathSegments.count < 2) {
            [pathComponents addObject:ZYQ_ROUTER_WILDCARD_CHARACTER];
        }
        
        URL = [URL substringFromIndex:[URL rangeOfString:@"://"].location + 3];
    }
    
    for (NSString *pathComponent in [[NSURL URLWithString:URL] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    return [pathComponents copy];
}


@end
