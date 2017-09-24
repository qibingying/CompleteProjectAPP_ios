//
//  QBYHTTPSessionManager.m
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/24.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYHTTPSessionManager.h"

@implementation QBYHTTPSessionManager

-(instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        [self.requestSerializer setValue:[UIDevice currentDevice].model forHTTPHeaderField:@"Phone"];
        [self.requestSerializer setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"OS"];
    }
    return self;
}
@end
