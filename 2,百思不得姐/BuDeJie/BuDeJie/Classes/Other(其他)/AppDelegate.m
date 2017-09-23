//
//  AppDelegate.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/4.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "AppDelegate.h"
#import "QBYTabBarController.h"
#import "QBYADViewController.h"
#import <AFNetworking.h>

/*
 优先级:LaunchScreen > LaunchImage
 在xcode配置了,不起作用 1.清空xcode缓存 2.直接删掉程序 重新运行
 如果是通过LaunchImage设置启动界面,那么屏幕的可视范围由图片决定
 注意:如果使用LaunchImage,必须让你的美工提供各种尺寸的启动图片
 
 LaunchScreen:Xcode6开始才有
 LaunchScreen好处:1.自动识别当前真机或者模拟器的尺寸 2.只要让美工提供一个可拉伸图片
 3.展示更多东西 可以加一些按钮 switch什么的
 LaunchScreen底层实现:把LaunchScreen截屏,生成一张图片.作为启动界面
 
 */

/*
 项目架构(结构)搭建:主流结构(UITabBarController + 导航控制器)
 -> 项目开发方式 1.storyboard 2.纯代码
 */
@interface AppDelegate () //<UITabBarControllerDelegate>


@end

@implementation AppDelegate
#pragma mark - <UITabBarControllerDelegate>
/**
 *  当tabBarController选中了某个子控制器的时候调用（点击了tabBar里面按钮的时候）
 */
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    QBYLog(@"didSelectViewController - %@", viewController)
//}


#pragma mark - 监听点击
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    if ([touches.anyObject locationInView:nil].y <= 20) {
//        QBYLog(@"点击了状态栏")
//    }
//}

// 自定义类:1.可以管理自己业务
// 封装:谁的事情谁管理 =. 方便以后去维护代码
// 程序启动的时候就会调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    1，创建窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    2，设置窗口根控制器
//    QBYTabBarController * tabBarVc = [[QBYTabBarController alloc]init];
//    self.window.rootViewController = tabBarVc;
    
    // 2.设置窗口根控制器 先进广告页 然后在做其他的事情
    QBYADViewController *adVc = [[QBYADViewController alloc] init];
    // init ->  initWithNibName 1.首先判断有没有指定nibName 2.判断下有没有跟类名同名xib
    self.window.rootViewController = adVc;
//    3,显示主窗口
    [self.window makeKeyAndVisible];
    
    // 4.开始监控网络状况
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 5.每次启动程序，都清除过期的图片
        [[SDImageCache sharedImageCache] cleanDisk];
//    [[SDImageCache sharedImageCache] clearDisk];
    
    // 应用app文件归档所在路径
    NSString *path = NSHomeDirectory();
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
