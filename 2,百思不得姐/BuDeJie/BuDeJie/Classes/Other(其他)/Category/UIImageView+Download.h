//
//  UIImageView+Download.h
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/22.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@interface UIImageView (Download)

- (void)qby_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbnailImageURL placeholder:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

- (void)qby_setHeader:(NSString *)headerUrl;

@end
