//
//  QBYSettingViewController.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/9.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYSettingViewController.h"
#import "QBYFileTool.h"
#import "SVProgressHUD/SVProgressHUD.h"

static NSString * const ID = @"cell";
#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface QBYSettingViewController()
@property (nonatomic, assign) NSInteger totalSize;
@end
@implementation QBYSettingViewController

- (void)viewDidLoad{

    [super viewDidLoad];
    self.title = @"设置";
    //设置右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"jump" style:0 target:self action:@selector(jump)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    // 提示用户当前正在加载数据 SVPro
    [SVProgressHUD showWithStatus:@"正在加载ing....."];
    // 获取文件夹尺寸
    // 文件夹非常小,如果我的文件非常大
    [QBYFileTool getFileSize:CachePath completion:^(NSInteger totalSize) {
        _totalSize = totalSize;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 计算缓存数据,计算整个应用程序缓存数据 => 沙盒(Cache) => 获取cache文件夹尺寸
    
    // 获取缓存尺寸字符串
    cell.textLabel.text = [self sizeStr];
    return cell;
    
}

// 点击cell就会调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [QBYFileTool removeDirectoryPath:CachePath];
    _totalSize = 0;
    [self.tableView reloadData];
}

// 获取缓存尺寸字符串
- (NSString *)sizeStr{
    NSInteger totalSize = _totalSize;
    NSString *totalStr = @"清除缓存";
    if (totalSize > 1000.0 * 1000.0) {
        CGFloat sizeFloat = totalSize / 1000.0 /1000.0;
        totalStr = [NSString stringWithFormat:@"%@(%.1fMB)",totalStr,sizeFloat];
    } else if (totalSize > 1000) {
        // KB
        CGFloat sizeFloat = totalSize / 1000.0;
        totalStr = [NSString stringWithFormat:@"%@(%.1fKB)",totalStr,sizeFloat];
    } else if (totalSize > 0) {
        // B
        totalStr = [NSString stringWithFormat:@"%@(%.ldB)",totalStr,totalSize];
    }
    
    return totalStr;

}
- (void)jump{

    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
