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
@end

@implementation QBYTopicCell

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
}

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
