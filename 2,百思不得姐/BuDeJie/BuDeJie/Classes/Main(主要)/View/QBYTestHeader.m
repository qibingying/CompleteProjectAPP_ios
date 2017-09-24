//
//  QBYTestHeader.m
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/24.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYTestHeader.h"

@implementation QBYTestHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置状态文字颜色
        self.stateLabel.textColor = [UIColor orangeColor];
        // 自动切换透明度
        self.automaticallyChangeAlpha = YES;
    }
    return self;
}

@end
