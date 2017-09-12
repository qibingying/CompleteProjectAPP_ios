//
//  QBYTabBarController.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/4.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYTabBarController.h"
#import "QBYEssenceViewController.h"
#import "QBYFriendThreadViewController.h"
#import "QBYMeViewController.h"
#import "QBYNewViewController.h"
#import "QBYPublishViewController.h"
#import "UIImage+Extension.h"
#import "QBYTabBar.h"
#import "QBYNavigationController.h"

@implementation QBYTabBarController

/*
 问题:
 1.选中按钮的图片被渲染 -> iOS7之后默认tabBar上按钮图片都会被渲染 1.修改图片 2.通过代码 √
 2.选中按钮的标题颜色:黑色 标题字体大 -> 对应子控制器的tabBarItem
 3.发布按钮显示不出来
 */

//只会调用一次
+(void)load{
//    获取哪个类的UITabBarItem
    UITabBarItem *tabItem = [UITabBarItem appearanceWhenContainedIn:self, nil];
    // 设置按钮选中标题的颜色:富文本:描述一个文字颜色,字体,阴影,空心,图文混排
    // 创建一个描述文本属性的字典
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [tabItem setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    // *设置字体尺寸:只有设置正常状态下,才会有效果
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [tabItem setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
    
}

#pragma mark -生命周期的方法
-(void)viewDidLoad{
    [super viewDidLoad];
    // 1 添加子控制器(5个子控制器) -> 自定义控制器 -> 划分项目文件结构
    [self setUpAllChildViewController];
    // 2 设置tabBar上按钮内容 -> 由对应的子控制器的tabBarItem属性
    [self setUpAllTitleButton];
    // 3.自定义tabBar
    [self setUpTabBar];

}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    NSLog(@"%@",self.tabBar.subviews);
//}

-(void)setUpTabBar{
    QBYTabBar * tabBar = [[QBYTabBar alloc]init];
    [self setValue:tabBar forKey:@"tabBar"];
}

/*
 Changing the delegate of a tab bar 【managed by a tab bar controller】 is not allowed.
 被UITabBarController所管理的UITabBar的delegate是不允许修改的
 */

#pragma mark -添加所有自控制器
-(void)setUpAllChildViewController{
    // 精华
    QBYEssenceViewController *essenceVC = [[QBYEssenceViewController alloc]init];
    UINavigationController *nav = [[QBYNavigationController alloc]initWithRootViewController:essenceVC];
    [self addChildViewController:nav];
    
    // 新帖
    QBYNewViewController *newVc = [[QBYNewViewController alloc] init];
    UINavigationController *nav1 = [[QBYNavigationController alloc] initWithRootViewController:newVc];
    [self addChildViewController:nav1];
    
    // 关注
    QBYFriendThreadViewController *ftVc = [[QBYFriendThreadViewController alloc] init];
    UINavigationController *nav3 = [[QBYNavigationController alloc] initWithRootViewController:ftVc];
    [self addChildViewController:nav3];
    
    // 我
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([QBYMeViewController class]) bundle:nil];
    // 加载箭头指向控制器
    QBYMeViewController *meVc = [storyboard instantiateInitialViewController];
    UINavigationController *nav4 = [[QBYNavigationController alloc] initWithRootViewController:meVc];
    [self addChildViewController:nav4];

//    QBYMeViewController *meVc = [[QBYMeViewController alloc] init];
//    UINavigationController *nav4 = [[QBYNavigationController alloc] initWithRootViewController:meVc];
//    [self addChildViewController:nav4];
}

#pragma mark -添加TabBar上的按钮
-(void)setUpAllTitleButton{
    
    // 0:nav
    UINavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"精华";
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    // 快速生成一个没有渲染图片
    nav.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_essence_click_icon"];
    
    // 1:新帖
    UINavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"新帖";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_new_click_icon"];
    
    // 3.关注
    UINavigationController *nav3 = self.childViewControllers[2];
    nav3.tabBarItem.title = @"关注";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_friendTrends_click_icon"];
    
    // 4.我
    UINavigationController *nav4 = self.childViewControllers[3];
    nav4.tabBarItem.title = @"我";
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav4.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_me_click_icon"];
}
@end
