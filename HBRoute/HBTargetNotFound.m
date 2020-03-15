//
//  HBTargetNotFound.m
//  HBRoute
//
//  Created by 王海波 on 2019/7/11.
//  Copyright © 2019 王海波. All rights reserved.
//

#import "HBTargetNotFound.h"

@implementation HBTargetNotFound

- (void)NoTargetOrActionResponseError:(NSError*)error objectsArr:(NSArray *)objectsArr{
    NSLog(@"xxxxx--%@ -- originObjects:%@",error.userInfo,objectsArr);

}

@end
