//
//  UIBarButtonItem+Create.h
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/9.
//  Copyright © 2017年 骑兵营. All rights reserved.
//UIBarButtonItem是导航栏的左右按钮 快速创建方法

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Create)

// 快速创建UIBarButtonItem
+ (UIBarButtonItem *)itemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)backItemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title;

+ (UIBarButtonItem *)itemWithimage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;


@end
