//
//  UIView+Frame.h
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/9.
//  Copyright © 2017年 骑兵营. All rights reserved.
//获取UIView的尺寸 frame 和 size

#import <UIKit/UIKit.h>

/**
 写分类:避免跟其他开发者产生冲突,加前缀
 */
@interface UIView (Frame)

@property CGFloat qby_width;
@property CGFloat qby_height;
@property CGFloat qby_x;
@property CGFloat qby_y;
@property CGFloat qby_centerX;
@property CGFloat qby_centerY;

/**  快速获得一个从xib中加载的一个UIView */
+ (instancetype)qby_viewFromXib;

@end
