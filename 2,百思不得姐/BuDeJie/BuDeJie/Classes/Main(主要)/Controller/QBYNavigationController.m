//
//  QBYNavigationViewController.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/9.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYNavigationController.h"
#import "UIBarButtonItem+Create.h"

@interface QBYNavigationController ()<UIGestureRecognizerDelegate>



@end
@implementation QBYNavigationController

+ (void)load{
    
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    // 只要是通过模型设置,都是通过富文本设置
    // 设置导航条标题 => UINavigationBar
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
//    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:attrs];
    
    // 设置导航条背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma  mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    return self.childViewControllers.count > 1;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) title:@"返回"];
    }
//    正真跳转
    [super pushViewController:viewController animated:animated];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}

@end
