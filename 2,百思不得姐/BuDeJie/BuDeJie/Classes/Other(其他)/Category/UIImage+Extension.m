//
//  UIImage+Extension.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/4.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (instancetype)imageOriginalWithName:(NSString *)imageName{
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

}

+ (instancetype)resizableImageWithLocalImageName:(NSString *)localImageName{
    // 创建图片对象
    UIImage *image = [UIImage imageNamed:localImageName];
    
    // 获取图片的尺寸
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeiht = image.size.height;
    
    // 返回一张拉伸且受保护的图片
    /**
     *方式一 就拉伸中间的一个像素
     *右边需要保护的区域 = 图片的width - leftCapWidth - 1
     *bottom cap =  height - topCapHeight - 1
     */
    return [image stretchableImageWithLeftCapWidth:imageWidth * 0.5 topCapHeight:imageHeiht * 0.5 ];
    // 方式二
    //     UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageHeight * 0.5, imageWidth * 0.5, imageHeight * 0.5 -1, imageWidth * 0.5 - 1)];
    
    //     UIImageResizingModeTile, 平铺
    //     UIImageResizingModeStretch, 拉伸(伸缩)
    //     UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageHeight * 0.5, imageWidth * 0.5, imageHeight * 0.5 -1, imageWidth * 0.5 - 1) resizingMode:UIImageResizingModeTile];
}

- (instancetype)qby_circleImage
{
    // 1.开启图形上下文
    // 比例因素:当前点与像素比例
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 2.描述裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.设置裁剪区域;
    [path addClip];
    // 4.画图片
    [self drawAtPoint:CGPointZero];
    // 5.取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)qby_circleImageNamed:(NSString *)name
{
    return [[self imageNamed:name] qby_circleImage];
}
@end
