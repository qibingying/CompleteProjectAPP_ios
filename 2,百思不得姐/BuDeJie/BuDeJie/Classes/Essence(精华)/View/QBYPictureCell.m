//
//  QBYPictureCell.m
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/21.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYPictureCell.h"

@implementation QBYPictureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 增加中间的图片控件，并且设置约束
        // ...
        
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

/*
 - (void)layoutSubviews
 {
 [super layoutSubviews];
 
 // 设置中间图片控件的frame
 }*/

- (void)setTopic:(QBYTopic *)topic
{
    [super setTopic:topic];
    
    // 设置中间图片控件的具体数据（比如文字数据、图片数据）
}

@end
