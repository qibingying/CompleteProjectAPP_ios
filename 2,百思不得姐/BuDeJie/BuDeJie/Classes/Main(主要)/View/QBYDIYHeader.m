//
//  QBYDIYHeader.m
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/24.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYDIYHeader.h"
@interface QBYDIYHeader()
/** 开关 */
@property (nonatomic, weak) UISwitch *s;
/** logo */
@property (nonatomic, weak) UIImageView *logo;
@end

@implementation QBYDIYHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UISwitch *s = [[UISwitch alloc] init];
        [self addSubview:s];
        self.s = s;
        
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
        [self addSubview:logo];
        self.logo = logo;
        //        self.xmg_height = 70;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.logo.qby_centerX = self.qby_width * 0.5;
    self.logo.qby_y =  -self.logo.qby_height;

    self.s.qby_centerX = self.qby_width * 0.5;
    self.s.qby_centerY = self.qby_height * 0.5;
}

#pragma mark - 重写Header内部的方法
- (void)setState:(MJRefreshState)state
{
    [super setState:state];
    
    if (state == MJRefreshStateIdle) { // 下拉可以刷新
        [self.s setOn:NO animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.s.transform = CGAffineTransformIdentity;
        }];
    } else if (state == MJRefreshStatePulling) { // 松开立即刷新
        [self.s setOn:YES animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.s.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    } else if (state == MJRefreshStateRefreshing) { // 正在刷新
        [self.s setOn:YES animated:YES];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.s.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
    }
}

@end
