//
//  QBYLoginRegisterView.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/11.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYLoginRegisterView.h"

@interface QBYLoginRegisterView ()
@property (weak, nonatomic) IBOutlet UIButton *loginRegisterButton;
@end

@implementation QBYLoginRegisterView

+ (instancetype)loginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

+ (instancetype)registerView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
//    UIImage *image = _loginRegisterButton.currentBackgroundImage;
    
   UIImage *image = [UIImage resizableImageWithLocalImageName:@"loginBtnBg"];
    
    // 让按钮背景图片不要被拉伸
    [_loginRegisterButton setBackgroundImage:image forState:UIControlStateNormal];
}
@end
