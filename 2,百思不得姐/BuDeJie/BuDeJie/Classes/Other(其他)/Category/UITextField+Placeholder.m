//
//  UITextField+Placeholder.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/13.
//  Copyright © 2017年 骑兵营. All rights reserved.
//g原理就是交换设置占位文字的方法

#import "UITextField+Placeholder.h"
#import <objc/message.h>

@implementation UITextField (Placeholder)

//交换方式是不想用setXmg_Placeholder这个方法设置颜色（不交换也行）
+ (void)load
{
    // setPlaceholder
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setXmg_PlaceholderMethod = class_getInstanceMethod(self, @selector(setXmg_Placeholder:));
    
    method_exchangeImplementations(setPlaceholderMethod, setXmg_PlaceholderMethod);
}
//这个是用runtime来 给自己添加一个属性placeholderColor
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    
    // 给成员属性赋值 runtime给系统的类添加成员属性
    // 添加成员属性
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 获取占位文字label控件
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    
    // 设置占位文字颜色
    placeholderLabel.textColor = placeholderColor;
}

//这个是从这个属性中取值
- (UIColor *)placeholderColor
{
    return objc_getAssociatedObject(self, @"placeholderColor");
}

// 设置占位文字
// 设置占位文字颜色
//g这个是设置占位文字时候，我们从runtime的属性中取属性的值
- (void)setXmg_Placeholder:(NSString *)placeholder
{
    [self setXmg_Placeholder:placeholder];
    
    self.placeholderColor = self.placeholderColor;
}



/**
 //方式一
 - (void)setPlaceholderColor:(UIColor *)placeholderColor
 {
 
 // 设置占位文字颜色
 UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
 placeholderLabel.textColor = placeholderColor;
 }
 
 - (UIColor *)placeholderColor
 {
 return nil;
 }
 */

@end
