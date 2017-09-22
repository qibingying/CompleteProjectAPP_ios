//
//  QBYTopic.m
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/21.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYTopic.h"

@implementation QBYTopic

- (CGFloat)cellHeight
{
    // 如果已经计算过，就直接返回
    if (_cellHeight) return _cellHeight;
    
    QBYFunc
    
    // 文字的Y值  cell头部的高度
    _cellHeight += 55;
    
    // 文字的高度
    CGSize textMaxSize = CGSizeMake(QBYScreenW - 2 * QBYMarin, MAXFLOAT);
    _cellHeight += [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + QBYMarin;
    
    // 工具条 cell底部的高度
    _cellHeight += 35 + QBYMarin;
    
    return _cellHeight;
}

@end
