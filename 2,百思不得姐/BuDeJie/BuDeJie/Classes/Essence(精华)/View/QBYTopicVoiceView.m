//
//  QBYVoiceCell.m
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/21.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYTopicVoiceView.h"
#import "QBYTopic.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>

@interface QBYTopicVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@end

@implementation QBYTopicVoiceView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTopic:(QBYTopic *)topic
{
    _topic = topic;
    
    // 设置图片
//    [self.imageView qby_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil];
    self.placeholderView.hidden = NO;
    [self.imageView qby_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        
        self.placeholderView.hidden = YES;
    }];
   /**
    // 占位图片
    UIImage *placeholder = nil;
    // 根据网络状态来加载图片
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 获得原图（SDWebImage的图片缓存是用图片的url字符串作为key）
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:topic.image1];
    if (originImage) { // 原图已经被下载过
        self.imageView.image = originImage;
    } else { // 原图并未下载过
        if (mgr.isReachableViaWiFi) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1] placeholderImage:placeholder];
        } else if (mgr.isReachableViaWWAN) {
#warning downloadOriginImageWhen3GOr4G配置项的值需要从沙盒里面获取
            // 3G\4G网络下时候要下载原图
            BOOL downloadOriginImageWhen3GOr4G = YES;
            if (downloadOriginImageWhen3GOr4G) {
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1] placeholderImage:placeholder];
            } else {
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image0] placeholderImage:placeholder];
            }
        } else { // 没有可用网络
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:topic.image0];
            if (thumbnailImage) { // 缩略图已经被下载过
                self.imageView.image = thumbnailImage;
            } else { // 没有下载过任何图片
                // 占位图片;
                self.imageView.image = placeholder;
            }
        }
    }
    */
    // 播放数量
    if (topic.playcount >= 10000) {
        self.playcountLabel.text = [NSString stringWithFormat:@"%.1f万播放", topic.playcount / 10000.0];
    } else {
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    }
    // %04d : 占据4位，多余的空位用0填补
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.voicetime / 60, topic.voicetime % 60];
}

@end
