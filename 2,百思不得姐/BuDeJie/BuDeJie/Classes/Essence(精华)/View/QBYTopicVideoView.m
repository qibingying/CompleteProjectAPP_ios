//
//  QBYVideoCell.m
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/21.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYTopicVideoView.h"

@implementation QBYTopicVideoView
/*
 一般情况下，以下这些view的autoresizingMask默认就是18 子视图随着父视图的宽高变化而变化（UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth）
 1.从xib里面创建出来的默认控件
 2.控制器的view
 
 如果不希望控件拥有autoresizingMask的自动伸缩功能，应该设置为none
 blueView.autoresizingMask = UIViewAutoresizingNone;
 */

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}


@end
