//
//  QBYTopicCell.m
//  BuDeJie
//
//  Created by 瑰丽奇兵 on 2017/9/21.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYTopicCell.h"
#import "QBYTopic.h"
#import <UIImageView+WebCache.h>

#import "QBYTopicPictureView.h"
#import "QBYTopicVideoView.h"
#import "QBYTopicVoiceView.h"
@interface QBYTopicCell()
// 控件的命名 -> 功能 + 控件类型
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;

/* 中间控件 */
/** 图片控件 */
@property (nonatomic, weak) QBYTopicPictureView *pictureView;
/** 声音控件 */
@property (nonatomic, weak) QBYTopicVoiceView *voiceView;
/** 视频控件 */
@property (nonatomic, weak) QBYTopicVideoView *videoView;
@end

@implementation QBYTopicCell
#pragma mark - 懒加载
- (QBYTopicPictureView *)pictureView
{
    if (!_pictureView) {
        QBYTopicPictureView *pictureView = [QBYTopicPictureView qby_viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (QBYTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        QBYTopicVoiceView *voiceView = [QBYTopicVoiceView qby_viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (QBYTopicVideoView *)videoView
{
    if (!_videoView) {
        QBYTopicVideoView *videoView = [QBYTopicVideoView qby_viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

#pragma mark - 初始化
- (void)awakeFromNib
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizableImageWithLocalImageName:@"mainCellBackground"]];
    //    self.selectedBackgroundView
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        // 增加顶部的控件，并且设置约束
//        // ...
//        
//        // 增加底部的控件，并且设置约束
//        // ...
//        
//        [self.contentView addSubview:[[UISwitch alloc] init]];
//        
//        UILabel *label = [[UILabel alloc] init];
//        label.text = NSStringFromClass(self.class);
//        [label sizeToFit];
//        label.tag = 10;
//        [self.contentView addSubview:label];
//    }
//    return self;
//}

/*
 - (void)layoutSubviews
 {
 [super layoutSubviews];
 
 // 设置顶部和底部控件的frame
 }*/

- (void)setTopic:(QBYTopic *)topic
{
    _topic = topic;
    
    // 顶部控件的数据
//    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    UIImage *placeholder = [UIImage qby_circleImageNamed:@"defaultUserIcon"];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 图片下载失败，直接返回，按照它的默认做法
        if (!image) return;
        
        self.profileImageView.image = [image qby_circleImage];
    }];
    
    self.nameLabel.text = topic.name;
    self.passtimeLabel.text = topic.passtime;
    self.text_label.text = topic.text;
    
    // 底部按钮的文字
    [self setupButtonTitle:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repostButton number:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton number:topic.comment placeholder:@"评论"];
    // 最热评论
    if (topic.top_cmt.count) { // 有最热评论
        self.topCmtView.hidden = NO;
        
        NSDictionary *cmt = topic.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) { // 语音评论
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@", username, content];
    } else { // 没有最热评论
        self.topCmtView.hidden = YES;
    }
    
    // 不能用以下条件来判断数组里面是否有存放元素
    //    if (topic.top_cmt) {
    //
    //    }
    //    if (topic.top_cmt != nil) {
    //
    //    }
    
    //    NSString *str = @"";
    //    if (str)
    //    if (str.length)
    
    // 中间的内容
    if (topic.type == QBYTopicTypePicture) { // 图片
        self.pictureView.hidden = NO;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    } else if (topic.type == QBYTopicTypeVoice) { // 声音
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.videoView.hidden = YES;
    } else if (topic.type == QBYTopicTypeVideo) { // 视频
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
    } else if (topic.type == QBYTopicTypeWord) { // 段子
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.topic.type == QBYTopicTypePicture) { // 图片
        self.pictureView.frame = self.topic.middleFrame;
    } else if (self.topic.type == QBYTopicTypeVoice) { // 声音
        self.voiceView.frame = self.topic.middleFrame;
    } else if (self.topic.type == QBYTopicTypeVideo) { // 视频
        self.videoView.frame = self.topic.middleFrame;
    }
}

/*
 [[XMGVideoViewController alloc] init]
 1.XMGVideoViewController.xib
 2.XMGVideoView.xib
 
 报错信息：-[UIViewController _loadViewFromNibNamed:bundle:] loaded the "XMGVideoView" nib but the view outlet was not set.
 错误原因：在使用xib创建控制器view时，并没有通过File's Owner设置控制器的view属性
 解决方案：通过File's Owner设置控制器的view属性为某一个view
 
 报错信息：-[UITableViewController loadView] loaded the "XMGVideoView" nib but didn't get a UITableView.
 错误原因：在使用xib创建UITableViewController的view时，并没有设置控制器的view为一个UITableView
 解决方案：通过File's Owner设置控制器的view属性为一个UITableView
 */

/**
 *  设置按钮文字
 *  @param number      按钮的数字
 *  @param placeholder 数字为0时显示的文字
 */
- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}

- (void)setFrame:(CGRect)frame
{
    //    frame.origin.x += XMGMarin;
    //    frame.size.width -= 2 * XMGMarin;
    frame.size.height -= QBYMarin;
    
    [super setFrame:frame];
}

//- (void)setTopic:(QBYTopic *)topic
//{
//    _topic = topic;
//    
//    UILabel *label = (UILabel *)[self viewWithTag:10];
//    label.text = [NSString stringWithFormat:@"%@ - %zd", self.class, topic.type];
//    [label sizeToFit];
//    
//    // 设置顶部和底部控件的具体数据（比如文字数据、图片数据）
//}

@end
