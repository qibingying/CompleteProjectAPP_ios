//
//  QBYFriendThreadViewController.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/4.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYFriendThreadViewController.h"
#import "QBYLoginRegisterViewController.h"
#import "UITextField+Placeholder.h"

@interface QBYFriendThreadViewController()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
@implementation QBYFriendThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 分析:为什么先设置占位文字颜色,就没有效果 => 占位文字label拿不到
    // 1.保存起来
    // 设置占位文字颜色
   

    _textField.placeholderColor = [UIColor greenColor];
    
    // 设置占位文字:每次设置占位文字的后,在拿到之前保存占位文字颜色,重新设置
    //    [_textField setXmg_Placeholder:@"123"];
     _textField.placeholder = @"123";
    
    
    // Do any additional setup after loading the view.
    [self setupNavBar];
}

#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendsRecomment)];
    
    // titleView
    self.navigationItem.title = @"我的关注";
    
}

// 点击登录注册就会调用
- (IBAction)clickLoginRegister:(id)sender {

    // 进入到登录注册界面
    QBYLoginRegisterViewController *loginVc = [[QBYLoginRegisterViewController alloc] init];
    [self presentViewController:loginVc animated:YES completion:nil];
    
}

// 推荐关注
- (void)friendsRecomment
{
    
}
@end
