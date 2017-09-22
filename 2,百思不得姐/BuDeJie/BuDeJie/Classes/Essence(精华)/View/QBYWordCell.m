//
//  QBYWordCell.m
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/21.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYWordCell.h"

@implementation QBYWordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // ...
        
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

/*
 - (void)layoutSubviews
 {
 [super layoutSubviews];
 
 }*/

- (void)setTopic:(QBYTopic *)topic
{
    [super setTopic:topic];
    
    
}

@end
