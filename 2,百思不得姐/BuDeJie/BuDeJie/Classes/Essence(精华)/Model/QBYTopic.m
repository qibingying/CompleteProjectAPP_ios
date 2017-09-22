//
//  QBYTopic.m
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/21.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYTopic.h"

@implementation QBYTopic
/*
 如果错误信息里面包含了：NaN，一般都是因为除0造成（比如x/0）
 (NaN : Not a number）
 */
- (CGFloat)cellHeight
{
    // 如果已经计算过，就直接返回
    if (_cellHeight) return _cellHeight;
    
//    QBYFunc
    
    // 文字的Y值  cell头部的高度
    _cellHeight += 55;
    
    // 文字的高度
    CGSize textMaxSize = CGSizeMake(QBYScreenW - 2 * QBYMarin, MAXFLOAT);
    _cellHeight += [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + QBYMarin;
    
    // 中间的内容
    if (self.type != QBYTopicTypeWord) { // 中间有内容（图片、声音、视频）
        /*
         self.width     middleW
         ----------- == -------
         self.height    middleH
         
         self.width * middleH == middleW * self.height
         */
        
        CGFloat middleW = textMaxSize.width;
        CGFloat middleH = middleW * self.height / self.width;
        CGFloat middleY = _cellHeight;
        CGFloat middleX = QBYMarin;
        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
        _cellHeight += middleH + QBYMarin;
    }
    // 最热评论
    if (self.top_cmt.count) { // 有最热评论
        // 标题
        _cellHeight += 21;
        
        // 内容
        NSDictionary *cmt = self.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) {
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        NSString *cmtText = [NSString stringWithFormat:@"%@ : %@", username, content];
        _cellHeight += [cmtText boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height + QBYMarin;
    }
    
    // 工具条 cell底部的高度
    _cellHeight += 35 + QBYMarin;
    
    return _cellHeight;
}

@end
