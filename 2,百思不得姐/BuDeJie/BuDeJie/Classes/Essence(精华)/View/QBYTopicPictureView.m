//
//  QBYPictureCell.m
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/21.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYTopicPictureView.h"
#import "QBYTopic.h"
#import <UIImageView+WebCache.h>

@interface QBYTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;
@end

@implementation QBYTopicPictureView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 控制按钮内部的子控件对齐，不是用contentMode，是用以下2个属性
    //    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    // 控件按钮内部子控件之间的间距
    //    btn.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    //    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    //    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}

- (void)setTopic:(QBYTopic *)topic
{
    _topic = topic;
    
    QBYLog(@"%@ %@", topic.text, topic.image1)
    
    // 设置图片
    self.placeholderView.hidden = NO;
    [self.imageView qby_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        
        self.placeholderView.hidden = YES;
    }];
    
    // gif
    self.gifView.hidden = !topic.is_gif;
    // http://ww2.sinaimg.cn/bmiddle/005yUFpDjw1f297c6vgzig306y04rnpd.GIF
    //    if ([topic.image1.lowercaseString hasSuffix:@"gif"]) {
    //    if ([topic.image1.pathExtension.lowercaseString isEqualToString:@"gif"]) {
    //        self.gifView.hidden = NO;
    //    } else {
    //        self.gifView.hidden = YES;
    //    }
    
    // 点击查看大图
    if (topic.isBigPicture) { // 超长图
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
        
        // 处理超长图片的大小
        if (self.imageView.image) {
            CGFloat imageW = topic.middleFrame.size.width;
            CGFloat imageH = imageW * topic.height / topic.width;
            
            // 开启上下文
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            // 绘制图片到上下文中
            [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭上下文
            UIGraphicsEndImageContext();
        }
    } else {
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
        
    }
}
@end
