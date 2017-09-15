//
//  QBYFastButton.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/11.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYFastButton.h"

@implementation QBYFastButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片位置 imageView的高度父类已经算出来了
    self.imageView.qby_y = 0;
    self.imageView.qby_centerX = self.qby_width * 0.5;
    
    // 设置标题位置
    self.titleLabel.qby_y = self.qby_height - self.titleLabel.qby_height;
    
    // 计算文字宽度 , 设置label的宽度 g这个一般会忘记
    [self.titleLabel sizeToFit];
    
    self.titleLabel.qby_centerX = self.qby_width * 0.5;
    
}

@end
