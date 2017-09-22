//
//  QBYVideoCell.m
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/21.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYTopicVideoView.h"
#import "QBYTopic.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>

@interface QBYTopicVideoView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@end

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

- (void)setTopic:(QBYTopic *)topic
{
    _topic = topic;
    
    // 设置图片
    self.placeholderView.hidden = NO;
    [self.imageView qby_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        
        self.placeholderView.hidden = YES;
    }];
    
    // 播放数量
    if (topic.playcount >= 10000) {
        self.playcountLabel.text = [NSString stringWithFormat:@"%.1f万播放", topic.playcount / 10000.0];
    } else {
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    }
    // %04d : 占据4位，多余的空位用0填补
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.videotime / 60, topic.videotime % 60];
}
@end
