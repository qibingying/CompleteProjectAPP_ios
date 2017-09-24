//
//  QBYSubTagViewController.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/10.
//  Copyright © 2017年 骑兵营. All rights reserved.
//
/*
 D : NSObject
 - (void)run;
 - (void)test;
 
 F : NSObject
 - (void)study;
 
 A : UITableViewController
 [D run]
 [D test]
 [F study]
 - (void)a;
 
 C : UICollectionViewController
 [D run]
 [D test]
 [F study]
 - (void)c;
 
 E : UIViewController
 [D run]
 [D test]
 [F study]
 */

#import "QBYSubTagViewController.h"
#import "AFNetWorking/AFNetWorking.h"
#import "QBYSubTagItem.h"
#import <MJExtension/MJExtension.h>
#import "QBYSubTagCell.h"
#import <SVProgressHUD/SVProgressHUD.h>
//#import <MJRefresh.h>
#import "QBYRefreshHeader.h"
#import "QBYDIYHeader.h"

static NSString * const ID = @"cell";

@interface QBYSubTagViewController ()

@property (nonatomic, strong) NSArray *subTags;
@property (nonatomic, weak) AFHTTPSessionManager *mgr;

@end

@implementation QBYSubTagViewController
// 接口文档: 请求url(基本url+请求参数) 请求方式
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 展示标签数据 -> 请求数据(接口文档) -> 解析数据(写成Plist)(image_list,sub_number,theme_name) -> 设计模型 -> 字典转模型 -> 展示数据
    [self loadData];

    self.title = @"推荐标签";
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"QBYSubTagCell" bundle:nil] forCellReuseIdentifier:ID];
    // 处理cell分割线 1.自定义分割线 2.系统属性(iOS8才支持) 3.万能方式(重写cell的setFrame) 了解tableView底层实现了解 1.取消系统自带分割线 2.把tableView背景色设置为分割线的背景色 3.重写setFrame
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 220 220 221
    self.tableView.backgroundColor = QBYColor(220, 220, 221);
    
    // 提示用户当前正在加载数据 SVPro
    [SVProgressHUD showWithStatus:@"正在加载ing....."];
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    // header
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        QBYFunc
//    }];
    self.tableView.mj_header = [QBYDIYHeader headerWithRefreshingBlock:^{
//        XMGFunc
    }];
    
    // footer
    
}

// 界面即将消失调用
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 销毁指示器
    [SVProgressHUD dismiss];
    // 取消之前的请求
    [_mgr.tasks makeObjectsPerformSelector:@selector(cancel)];

}
#pragma mark - 请求数据
- (void)loadData{
    // 1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    _mgr = mgr;
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";

    // 3.发送请求
    [mgr GET:QBYCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        // 字典数组转换模型数组
        _subTags = [QBYSubTagItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{

     return self.subTags.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 自定义cell
    QBYSubTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 获取模型
    QBYSubTagItem *item = self.subTags[indexPath.row];
    
    cell.item = item;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
