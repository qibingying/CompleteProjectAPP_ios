//
//  QBYLoginField.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/13.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYLoginField.h"
#import "UITextField+Placeholder.h"

@implementation QBYLoginField

/*
 1.文本框光标变成白色
 2.文本框开始编辑的时候,占位文字颜色变成白色
 */
/**
//方式一
- (void)awakeFromNib{
    // 设置光标的颜色为白色
    self.tintColor = [UIColor whiteColor];
    // 监听文本框编辑: 1.代理 2.通知 3.target
    // 原则:不要自己成为自己代理
    // 开始编辑
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    // 结束编辑
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
}

- (void)textBegin{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
}

- (void)textEnd{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
}
 
 */

//方式二  创建一个分类来写  封装性更好  可是有bug  必须先设置text  才能设置颜色 不然不起效果。
- (void)awakeFromNib{
    // 设置光标的颜色为白色
    self.tintColor = [UIColor whiteColor];
    // 监听文本框编辑: 1.代理 2.通知 3.target
    // 原则:不要自己成为自己代理
    // 开始编辑
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    // 结束编辑
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    // 获取占位文字控件
    self.placeholderColor = [UIColor redColor];
    // 快速设置占位文字颜色 => 文本框占位文字可能是label => 验证占位文字是label => 拿到label => 查看label属性名(1.runtime 2.断点)
    // self.placeholderColor = [UIColor redColor];

    
}

- (void)textBegin{
    self.placeholderColor = [UIColor whiteColor];

}

- (void)textEnd{
    self.placeholderColor = [UIColor redColor];

}

@end
