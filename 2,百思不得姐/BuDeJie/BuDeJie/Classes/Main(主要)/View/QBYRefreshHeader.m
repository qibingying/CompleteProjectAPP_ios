//
//  QBYRefreshHeader.m
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/24.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYRefreshHeader.h"

@implementation QBYRefreshHeader

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置状态文字颜色
        self.stateLabel.textColor = [UIColor blueColor];
        self.stateLabel.font = [UIFont systemFontOfSize:17];
        [self setTitle:@"赶紧下拉刷新" forState:MJRefreshStateIdle];
        [self setTitle:@"松开🐴上刷新" forState:MJRefreshStatePulling];
        [self setTitle:@"正在拼命刷新..." forState:MJRefreshStateRefreshing];
        // 隐藏时间
        self.lastUpdatedTimeLabel.hidden = YES;
        // 自动切换透明度
        self.automaticallyChangeAlpha = YES;
    }
    return self;
}

@end
