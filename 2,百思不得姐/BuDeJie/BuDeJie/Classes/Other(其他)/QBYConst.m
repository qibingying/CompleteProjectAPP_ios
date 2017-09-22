//
//  QBYConst.m
//  BuDeJie
//
//  Created by 古俊兵 on 2017/8/6.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYConst.h"

/** UITabBar的高度 */
CGFloat const QBYTabBarH = 49;

/** 导航栏的最大Y值 */
CGFloat const QBYNavMaxY = 64;

/** 标题栏的高度 */
CGFloat const QBYTitlesViewH = 35;

/** 全局统一的间距 */
CGFloat const QBYMarin = 10;

/** TabBarButton被重复点击的通知 */
NSString  * const QBYTabBarButtonDidRepeatClickNotification = @"QBYTabBarButtonDidRepeatClickNotification";

/** TitleButton被重复点击的通知 */
NSString  * const QBYTitleButtonDidRepeatClickNotification = @"QBYTitleButtonDidRepeatClickNotification";

/** 统一的一个请求路径 */
NSString  * const QBYCommonURL = @"http://api.budejie.com/api/api_open.php";