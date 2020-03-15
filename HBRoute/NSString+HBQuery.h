//
//  NSString+HBQuery.h
//  HBRoute
//
//  Created by 王海波 on 2019/7/12.
//  Copyright © 2019 王海波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HBQuery)

+ (NSString *)HBQueryStringWithParameters:(NSDictionary *)parameters;

- (NSDictionary *)HBParametersFromQueryString;

#pragma mark - URL Encoding/Decoding
- (NSString *)HBStringByAddingPercentEscapesUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)HBStringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding)encoding;
@end

NS_ASSUME_NONNULL_END
