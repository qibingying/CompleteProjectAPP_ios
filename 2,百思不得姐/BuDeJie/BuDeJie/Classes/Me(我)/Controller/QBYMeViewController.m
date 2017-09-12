//
//  QBYMeViewController.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/4.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYMeViewController.h"
#import "QBYSettingViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "QBYSquareItem.h"
#import <MJExtension/MJExtension.h>
#import "QBYSquareCell.h"
#import "QBYWebViewController.h"

/*
 搭建基本结构 -> 设置底部条 -> 设置顶部条 -> 设置顶部条标题字体 -> 处理导航控制器业务逻辑(跳转)
 */
static NSString * const ID = @"cell";
static NSInteger const cols = 4;
static CGFloat const margin = 1;
#define itemWH (QBYScreenW - (cols - 1) * margin) / cols
@interface QBYMeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *squareItems;
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation QBYMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条
    [self setupNavBar];
    
    // 设置tableView底部视图
    [self setupFootView];
    
    // 展示方块内容 -> 请求数据(查看接口文档)
    [self loadData];
    
    // 处理cell间距,默认tableView分组样式,有额外头部和尾部间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:QBYTabBarButtonDidRepeatClickNotification object:nil];
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
    if (self.view.window == nil) return;
    
    QBYFunc
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"%@",NSStringFromCGRect(self.tableView.tableFooterView.frame));
//    NSLog(@"%@",NSStringFromCGRect(self.collectionView.frame));
    
}
#pragma mark - 请求数据
- (void)loadData
{
    // 1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    
    // 3.发送请求
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        [responseObject writeToFile:@"/Users/gujunqi/Desktop/gujunqi.plist" atomically:YES];
        NSArray *dictArr = responseObject[@"square_list"];
        
        // 字典数组转换成模型数组
        _squareItems = [QBYSquareItem mj_objectArrayWithKeyValuesArray:dictArr];
        
        // 处理数据
        [self resloveData];
        
        // 设置collectionView 计算collectionView高度 = rows * itemWH
        // Rows = (count - 1) / cols + 1  3 cols4
        NSInteger count = _squareItems.count;
        NSInteger rows = (count - 1) / cols + 1;
        
        
        
//        g这个是最关键的部分了  妈蛋巨坑的一个东西   操
        // 设置collectioView高度 其中我加上了中间的线条
        self.collectionView.qby_height = rows * (itemWH + 1) - 1;
        
        // 设置tableView滚动范围:自己计算
        self.tableView.tableFooterView = self.collectionView;
//        下面的方式不可以的 这个是不行的
        //        self.tableView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.collectionView.frame));
        // 刷新表格
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 处理请求完成数据
- (void)resloveData
{
    // 判断下缺几个
    // 3 % 4 = 3 cols - 3 = 1
    // 5 % 4 = 1 cols - 1 = 3
    NSInteger count = self.squareItems.count;
    NSInteger exter = count % cols;
    if (exter) {
        exter = cols - exter;
        for (int i = 0; i < exter; i++) {
            QBYSquareItem *item = [[QBYSquareItem alloc] init];
            [self.squareItems addObject:item];
        }
    }

}

#pragma mark - 设置tableView底部视图
- (void)setupFootView{
    /*
     1.初始化要设置流水布局
     2.cell必须要注册
     3.cell必须自定义
     */
    // 创建布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置cell尺寸
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    
    // 创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    _collectionView = collectionView;
    collectionView.backgroundColor = self.tableView.backgroundColor;
//    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, QBYScreenW, self.collectionView.qby_height + 10)];
//    [footView addSubview:self.collectionView];
    self.tableView.tableFooterView =self.collectionView;
//    self.tableView.tableFooterView.backgroundColor = [UIColor yellowColor];
//    self.collectionView.backgroundColor = [UIColor blueColor];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
//    g设置为不能滚动
    collectionView.scrollEnabled = NO;
    
    // 注册cell
    [collectionView registerNib:[UINib nibWithNibName:@"QBYSquareCell" bundle:nil] forCellWithReuseIdentifier:ID];
}


#pragma mark - UICollectionViewDelegate
//定义每一个cell的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(itemWH, itemWH);
//}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转界面 push 展示网页
    /*
     1.Safari openURL :自带很多功能(进度条,刷新,前进,倒退等等功能),必须要跳出当前应用
     2.UIWebView (没有功能) ,在当前应用打开网页,并且有safari,自己实现,UIWebView不能实现进度条
     3.SFSafariViewController:专门用来展示网页 需求:即想要在当前应用展示网页,又想要safari功能 iOS9才能使用
     3.1 导入#import <SafariServices/SafariServices.h>
     
     4.WKWebView:iOS8 (UIWebView升级版本,添加功能 1.监听进度 2.缓存)
     4.1 导入#import <WebKit/WebKit.h>
     
     */
    // 创建网页控制器
    QBYSquareItem *item = self.squareItems[indexPath.row];
    if (![item.url containsString:@"http"]) return;
    
    QBYWebViewController *webVc = [[QBYWebViewController alloc] init];
    webVc.url = [NSURL URLWithString:item.url];
    [self.navigationController pushViewController:webVc animated:YES];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.squareItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 从缓存池取
    QBYSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.item = self.squareItems[indexPath.row];
    
    return cell;
}

- (void)setupNavBar
{
    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    
    // 设置
    UIBarButtonItem *settingItem =  [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    
    // 夜间模型
    UIBarButtonItem *nightItem =  [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
    
    // titleView
    self.navigationItem.title = @"我的";
    
}

- (void)night:(UIButton *)button
{
    button.selected = !button.selected;
    
}

#pragma mark - 设置就会调用
- (void)setting
{
    // 跳转到设置界面
    QBYSettingViewController *settingVc = [[QBYSettingViewController alloc] init];
    // 必须要在跳转之前设置
    settingVc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:settingVc animated:YES];
    
    /*
     1.底部条没有隐藏
     2.处理返回按钮样式 : 1.去设置控制器里
     */
    
}

@end
