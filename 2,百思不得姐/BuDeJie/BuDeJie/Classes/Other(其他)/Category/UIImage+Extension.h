//
//  UIImage+Extension.h
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/4.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/** 获取一张不渲染原始的图片*/
+ (UIImage *)imageOriginalWithName:(NSString *)imageName;

/** 获取一张拉伸的图片   也可以平铺方式获取图片*/
+ (instancetype)resizableImageWithLocalImageName:(NSString *)localImageName;
@end
