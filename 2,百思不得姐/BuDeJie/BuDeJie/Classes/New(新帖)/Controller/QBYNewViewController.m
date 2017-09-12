//
//  QBYNewViewController.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/4.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYNewViewController.h"
#import "QBYSubTagViewController.h"

@implementation QBYNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
    
    [self setupNavBar];
}

#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(tagClick)];
    
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
}

#pragma mark - 点击订阅标签调用
- (void)tagClick
{
    QBYSubTagViewController * subTagVC = [[QBYSubTagViewController alloc]init];
//    subTagVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:subTagVC animated:YES];
//    subTagVC.hidesBottomBarWhenPushed = NO;
    
}

@end
