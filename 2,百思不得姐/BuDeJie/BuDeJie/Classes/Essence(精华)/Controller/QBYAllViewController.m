//
//  QBYAllViewController.m
//  BuDeJie
//
//  Created by 古俊兵 on 2017/8/5.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYAllViewController.h"

@interface QBYAllViewController ()
/** 数据量 */
@property (nonatomic, assign) NSInteger dataCount;

/** 下拉刷新控件 */
@property (nonatomic, weak) UIView *header;
/** 下拉刷新控件里面的文字 */
@property (nonatomic, weak) UILabel *headerLabel;
/** 下拉刷新控件是否正在刷新 */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;

/** 上拉刷新控件 */
@property (nonatomic, weak) UIView *footer;
/** 上拉刷新控件里面的文字 */
@property (nonatomic, weak) UILabel *footerLabel;
/** 上拉刷新控件时候正在刷新 */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;

@end

@implementation QBYAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        self.dataCount = 7;
    //        [self.tableView reloadData];
    //
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            self.dataCount = 0;
    //            [self.tableView reloadData];
    //        });
    //    });
    
//    self.dataCount = 5;
    
    self.view.backgroundColor = QBYRandomColor;
    self.tableView.contentInset = UIEdgeInsetsMake(QBYNavMaxY + QBYTitlesViewH, 0, QBYTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:QBYTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:QBYTitleButtonDidRepeatClickNotification object:nil];
    
    [self setupRefresh];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupRefresh
{
    // 广告条
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor blackColor];
    label.frame = CGRectMake(0, 0, 0, 30);
    label.textColor = [UIColor whiteColor];
    label.text = @"广告";
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = label;
    
    // header
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, - 50, self.tableView.qby_width, 50);
    self.header = header;
    [self.tableView addSubview:header];
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = header.bounds;
    headerLabel.backgroundColor = [UIColor redColor];
    headerLabel.text = @"下拉可以刷新";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:headerLabel];
    self.headerLabel = headerLabel;
    
    // 让header自动进入刷新
    [self headerBeginRefreshing];
    
    // footer
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, self.tableView.qby_width, 35);
    self.footer = footer;
    
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.frame = footer.bounds;
    footerLabel.backgroundColor = [UIColor redColor];
    footerLabel.text = @"上拉可以加载更多";
    footerLabel.textColor = [UIColor whiteColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:footerLabel];
    self.footerLabel = footerLabel;
    
    self.tableView.tableFooterView = footer;
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
    
    // 进入下拉刷新
    [self headerBeginRefreshing];
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
    // 根据数据量显示或者隐藏footer
    self.footer.hidden = (self.dataCount == 0);
    return self.dataCount;
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

#pragma mark - 代理方法
/**
 *  用户松开scrollView时调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    // 如果正在下拉刷新，直接返回
    //    if (self.isHeaderRefreshing) return;
    
    CGFloat offsetY = - (self.tableView.contentInset.top + self.header.qby_height);
    if (self.tableView.contentOffset.y <= offsetY) { // header已经完全出现
        [self headerBeginRefreshing];
    }
    
    
    
    // 如果正在下拉刷新，直接返回
//    if (self.isHeaderRefreshing) return;
//    
//    CGFloat offsetY = - (self.tableView.contentInset.top + self.header.qby_height);
//    if (self.tableView.contentOffset.y <= offsetY) { // header已经完全出现
//        // 进入下拉刷新状态
//        self.headerLabel.text = @"正在刷新数据...";
//        self.headerLabel.backgroundColor = [UIColor blueColor];
//        self.headerRefreshing = YES;
//        // 增加内边距
//        [UIView animateWithDuration:0.25 animations:^{
//            UIEdgeInsets inset = self.tableView.contentInset;
//            inset.top += self.header.qby_height;
//            self.tableView.contentInset = inset;
//        }];
//        
//        QBYLog(@"发送请求给服务器，下拉刷新数据")
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 服务器的数据回来了
//            self.dataCount = 20;
//            [self.tableView reloadData];
//            
//            // 结束刷新
//            self.headerRefreshing = NO;
//            // 减小内边距
//            [UIView animateWithDuration:0.25 animations:^{
//                UIEdgeInsets inset = self.tableView.contentInset;
//                inset.top -= self.header.qby_height;
//                self.tableView.contentInset = inset;
//            }];
//        });
//    }
}

#pragma mark - 代理方法
//只要滚动了就会触发
//当scrollView滚动的时候，不停调用（可以监听scrollView的contentOffset）
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 处理header
    [self dealHeader];
    
    // 处理footer
    [self dealFooter];
    
//    // 还没有任何内容的时候，不需要判断
//    if (self.tableView.contentSize.height == 0) return;
//    
//    // 如果正在刷新，直接返回
//    if (self.isFooterRefreshing) return;
//    
//    // 当scrollView的偏移量y值 >= offsetY时，代表footer已经完全出现
//    CGFloat ofsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.qby_height;
//    
//    if (self.tableView.contentOffset.y >= ofsetY) {
//        // 进入刷新状态
//        self.footerRefreshing = YES;
//        self.footerLabel.text = @"正在加载更多数据...";
//        self.footerLabel.backgroundColor = [UIColor blueColor];
//        
//        // 发送请求给服务器
//        QBYLog(@"发送请求给服务器 - 加载更多数据")
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 服务器请求回来了
//            self.dataCount += 5;
//            [self.tableView reloadData];
//            
//            // 结束刷新
//            self.footerRefreshing = NO;
//            self.footerLabel.text = @"上拉可以加载更多";
//            self.footerLabel.backgroundColor = [UIColor redColor];
//        });
//    }
}

/**
 *  处理header
 */
- (void)dealHeader
{
    // 如果正在下拉刷新，直接返回
    if (self.isHeaderRefreshing) return;
    
    // 当scrollView的偏移量y值 <= offsetY时，代表header已经完全出现
    CGFloat offsetY = - (self.tableView.contentInset.top + self.header.qby_height);
    if (self.tableView.contentOffset.y <= offsetY) { // header已经完全出现
        self.headerLabel.text = @"松开立即刷新";
        self.headerLabel.backgroundColor = [UIColor grayColor];
    } else {
        self.headerLabel.text = @"下拉可以刷新";
        self.headerLabel.backgroundColor = [UIColor redColor];
    }
}

/**
 *  处理footer
 */
- (void)dealFooter
{
    // 还没有任何内容的时候，不需要判断
//    g因为一开始应用启动的时候，tableView的内容高度是0
    if (self.tableView.contentSize.height == 0) return;
    
    // 如果正在刷新，直接返回
    if (self.isFooterRefreshing) return;
    
    // 当scrollView的偏移量y值 >= offsetY时，代表footer已经完全出现
    CGFloat ofsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.qby_height;
    
//    g并且tableView的偏移量大于上边缘的内边距，也可以简单的理解为上拉的时候要刷新
//    估计作者想标的意思不能同时进行下拉刷新
    if (self.tableView.contentOffset.y >= ofsetY && self.tableView.contentOffset.y > - (self.tableView.contentInset.top)) {
        // footer完全出现，并且是往上拖拽
        [self footerBeginRefreshing];
    }
}

#pragma mark - 数据处理
/**
 *  发送请求给服务器，下拉刷新数据
 */
- (void)loadNewData
{
    QBYLog(@"发送请求给服务器，下拉刷新数据")
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 服务器的数据回来了
        self.dataCount = 20;
        [self.tableView reloadData];
        
        // 结束刷新
        [self headerEndRefreshing];
    });
}

/**
 *  发送请求给服务器，上拉加载更多数据
 */
- (void)loadMoreData
{
    QBYLog(@"发送请求给服务器 - 加载更多数据")
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 服务器请求回来了
        self.dataCount += 5;
        [self.tableView reloadData];
        
        // 结束刷新
        [self footerEndRefreshing];
    });
}

#pragma mark - header
- (void)headerBeginRefreshing
{
    // 如果正在下拉刷新，直接返回
    if (self.isHeaderRefreshing) return;
    
    // 进入下拉刷新状态
    self.headerLabel.text = @"正在刷新数据...";
    self.headerLabel.backgroundColor = [UIColor blueColor];
    self.headerRefreshing = YES;
    // 增加内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top += self.header.qby_height;
        self.tableView.contentInset = inset;
        
        // 修改偏移量  当点击按钮刷新的时候需要设置偏移量
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x,  - inset.top);
    }];
    
    // 发送请求给服务器，下拉刷新数据
    [self loadNewData];
}

- (void)headerEndRefreshing
{
    self.headerRefreshing = NO;
    // 减小内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top -= self.header.qby_height;
        self.tableView.contentInset = inset;
    }];
}

#pragma mark - footer
- (void)footerBeginRefreshing
{
    // 如果正在上拉刷新，直接返回
    if (self.isFooterRefreshing) return;
    
    // 进入刷新状态
    self.footerRefreshing = YES;
    self.footerLabel.text = @"正在加载更多数据...";
    self.footerLabel.backgroundColor = [UIColor blueColor];
    
    // 发送请求给服务器，上拉加载更多数据
    [self loadMoreData];
}

- (void)footerEndRefreshing
{
    self.footerRefreshing = NO;
    self.footerLabel.text = @"上拉可以加载更多";
    self.footerLabel.backgroundColor = [UIColor redColor];
}

@end
