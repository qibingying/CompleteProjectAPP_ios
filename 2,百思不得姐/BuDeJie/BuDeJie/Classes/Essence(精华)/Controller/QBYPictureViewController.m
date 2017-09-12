//
//  QBYPictureViewController.m
//  BuDeJie
//
//  Created by 古俊兵 on 2017/8/5.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYPictureViewController.h"

@interface QBYPictureViewController ()

@end

@implementation QBYPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QBYRandomColor;
    self.tableView.contentInset = UIEdgeInsetsMake(QBYNavMaxY + QBYTitlesViewH, 0, QBYTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:QBYTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:QBYTitleButtonDidRepeatClickNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听
/**
 *  监听tabBarButton重复点击
 */
- (void)tabBarButtonDidRepeatClick
{
    //    if (重复点击的不是精华按钮) return;
    if (self.view.window == nil) return;
    
    //    if (显示在正中间的不是AllViewController) return;
    if (self.tableView.scrollsToTop == NO) return;
    
    QBYLog(@"%@ - 刷新数据", self.class)
}

/**
 *  监听titleButton重复点击
 */
- (void)titleButtonDidRepeatClick
{
    [self tabBarButtonDidRepeatClick];
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%zd", self.class, indexPath.row];
    return cell;
}

@end
