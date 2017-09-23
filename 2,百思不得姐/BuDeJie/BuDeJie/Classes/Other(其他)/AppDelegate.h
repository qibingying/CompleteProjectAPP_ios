//
//  AppDelegate.h
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/4.
//  Copyright © 2017年 骑兵营. All rights reserved.
//
/*
 1.weak
 1> OC对象
 
 2.assign
 1> 基本数据类型
 2> OC对象
 
 3.strong
 1> OC对象
 
 4.copy
 1> NSString *
 2> block
 
 5.使用weak和assign修饰OC对象的区别
 1> 成员变量
 1) weak生成的成员变量是用__weak修饰的，比如XMGCat * __weak _cat;
 2) assign生成的成员变量是用__unsafe_unretained修饰的XMGCat * __unsafe_unretained _cat;
 
 2> __weak和__unsafe_unretained
 1) 都不是强指针（不是强引用），不能保住对象的命
 2) __weak : 所指向的对象销毁后，会自动变成nil指针（空指针），不再指向已经销毁的对象
 3) __unsafe_unretained : 所指向的对象销毁后，仍旧指向已经销毁的对象
 */
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

