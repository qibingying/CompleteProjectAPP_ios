//
//  QBYAllViewController.m
//  BuDeJie
//
//  Created by 古俊兵 on 2017/8/5.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYAllViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "QBYTopic.h"
#import <SVProgressHUD.h>

#import "QBYTopicCell.h"
//#import "QBYVideoCell.h"
//#import "QBYVoiceCell.h"
//#import "QBYPictureCell.h"
//#import "QBYWordCell.h"

@interface QBYAllViewController ()
/** 用来缓存cell的高度（key：模型，value：cell的高度） */
//@property (nonatomic, strong) NSMutableDictionary *cellHeightDict;

/** 当前最后一条帖子数据的描述信息，专门用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;
/** 所有的帖子数据 */
//g这里必须要用到泛型，不然取出来的是id  不能用QBYTopic里面的属性
@property (nonatomic, strong) NSMutableArray <QBYTopic *>*topics;
/** 请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

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
/* cell的重用标识 */
static NSString * const QBYTopicCellId = @"QBYTopicCellId";
/* cell的重用标识 */
//static NSString * const QBYVideoCellId = @"QBYVideoCellId";
//static NSString * const QBYVoiceCellId = @"QBYVoiceCellId";
//static NSString * const QBYPictureCellId = @"QBYPictureCellId";
//static NSString * const QBYWordCellId = @"QBYWordCellId";

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

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
    
    self.view.backgroundColor = QBYGrayColor(206);;
    self.tableView.contentInset = UIEdgeInsetsMake(QBYNavMaxY + QBYTitlesViewH, 0, QBYTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置cell的估算高度（每一行大约都是estimatedRowHeight）
//    self.tableView.estimatedRowHeight = 100;
//    self.tableView.rowHeight = 200;
    
    // 注册cell
//    [self.tableView registerClass:[QBYVideoCell class] forCellReuseIdentifier:QBYVideoCellId];
//    [self.tableView registerClass:[QBYVoiceCell class] forCellReuseIdentifier:QBYVoiceCellId];
//    [self.tableView registerClass:[QBYPictureCell class] forCellReuseIdentifier:QBYPictureCellId];
//    [self.tableView registerClass:[QBYWordCell class] forCellReuseIdentifier:QBYWordCellId];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([QBYTopicCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:QBYTopicCellId];
    
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

#pragma mark - 数据处理
/*
 服务器数据：45，44，43，42，41，40，39，38，37，36，35，34，。。。。。。5，4，3，2，1
 
 下⬇️拉刷新（new-最新）@[45，44，43]
 
 上⬆️拉刷新（more-更多）@[37，36，35]
 
 客户端数据：
 self.topics = @[40，39，38]
 
 请求的回来先后顺序
 1.上⬆️拉刷新（more-更多）-> 下⬇️拉刷新（new-最新）
 self.topics = @[45，44，43]
 
 2.下⬇️拉刷新（new-最新）-> 上⬆️拉刷新（more-更多）
 self.topics = @[45，44，43，37，36，35]
 */

/**
 *  发送请求给服务器，下拉刷新数据
 */
- (void)loadNewTopics
{
    // 1.取消之前的请求
    // 取消所有的请求，并且关闭session（注意：一旦关闭了session，这个manager再也无法发送任何请求）
    //    [self.manager invalidateSessionCancelingTasks:YES];
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    //    [self footerEndRefreshing];
    // 1.创建请求会话管理者
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @"31"; // 这里发送@1也是可行的
//    parameters[@"mintime"] = @"5345345";
    //    parameters[@"mintime"] = @"1440496442";
    
    // 3.发送请求
    [self.manager GET:QBYCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        QBYAFNWriteToPlist(gujunqi)
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        // 字典数组 -> 模型数据
        self.topics = [QBYTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //        NSMutableArray *newTopics = [XMGTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //        if (self.topics) {
        //            [self.topics insertObjects:newTopics atIndexes:[NSIndexSet indexSetWithIndex:0]];
        //        } else {
        //            self.topics = newTopics;
        //        }
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self headerEndRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) { // 并非是取消任务导致的error，其他网络问题导致的error
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        
        // 结束刷新
        [self headerEndRefreshing];
    }];
}

/**
 *  发送请求给服务器，上拉加载更多数据
 */
- (void)loadMoreTopics
{
    // 1.取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    //    [self headerEndRefreshing];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @"31";
    parameters[@"maxtime"] = self.maxtime;
    
    //    parameters[@"last_id"] = @"35";
    //    self.page++;
    //    parameters[@"page"] = @(self.page);
    //    parameters[@"page"] = @(self.page + 1);
    
    // 3.发送请求
    [self.manager GET:QBYCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数据
        NSArray *moreTopics = [QBYTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 累加到旧数组的后面
        [self.topics addObjectsFromArray:moreTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self footerEndRefreshing];
        //        self.page = [parameters[@"page"] integerValue];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) { // 并非是取消任务导致的error，其他网络问题导致的error
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        
        // 结束刷新
        [self footerEndRefreshing];
        //        self.page--;
    }];
}

/*
 // self.topics = @[10, 9, 8]
 // moreTopics = @[7, 6 ,5]
 
 // self.topics = @[10, 9, 8, @[7, 6 ,5]]
 [self.topics addObject:moreTopics];
 
 // self.topics = @[10, 9, 8, 7, 6 ,5]
 [self.topics addObjectsFromArray:moreTopics];
 */

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 根据数据量显示或者隐藏footer
    self.footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *ID = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//        cell.backgroundColor = [UIColor clearColor];
//    }
    
//    QBYTopic *topic = self.topics[indexPath.row];
//    cell.textLabel.text = topic.name;
//    cell.detailTextLabel.text = topic.text;
//    QBYTopicCell *cell = nil;
//    
//    if (topic.type == 10) { // 图片
//        cell = [tableView dequeueReusableCellWithIdentifier:QBYPictureCellId];
//    } else if (topic.type == 29) { // 段子
//        cell = [tableView dequeueReusableCellWithIdentifier:QBYWordCellId];
//    } else if (topic.type == 31) { // 声音
//        cell = [tableView dequeueReusableCellWithIdentifier:QBYVoiceCellId];
//    } else if (topic.type == 41) { // 视频
//        cell = [tableView dequeueReusableCellWithIdentifier:QBYVideoCellId];
//    }
//    
//    cell.topic = topic;
    
    // control + command + 空格 -> 弹出emoji表情键盘
    //    cell.textLabel.text = @"⚠️哈哈";
    
    QBYTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:QBYTopicCellId];
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

// 所有cell的高度 -> contentSize.height -> 滚动条长度
// 1000 * 20 -> contentSize.height -> 滚动条长度
// contentSize.height -> 200 * 20 -> 16800
/*
 使用estimatedRowHeight的优缺点
 1.优点
 1> 可以降低tableView:heightForRowAtIndexPath:方法的调用频率
 2> 将【计算cell高度的操作】延迟执行了（相当于cell高度的计算是懒加载的）
 
 2.缺点
 1> 滚动条长度不准确、不稳定，甚至有卡顿效果（如果不使用estimatedRowHeight，滚动条的长度就是准确的）
 */

/**
 这个方法的特点：
 1.默认情况下(没有设置estimatedRowHeight的情况下)
 1> 每次刷新表格时，有多少数据，这个方法就一次性调用多少次（比如有100条数据，每次reloadData时，这个方法就会一次性调用100次）
 2> 只要有cell进入屏幕范围内，就会调用一次这个方法
 2.设置estimatedRowHeight的情况下
 1> 用到了（显示了）哪个cell，才会调用这个方法计算那个cell的高度（方法调用频率降低了）
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    XMGTopic *topic = self.topics[indexPath.row];
    //    return topic.cellHeight;
    
    //    return [self.topics[indexPath.row] cellHeight];
//    QBYFunc
    return self.topics[indexPath.row].cellHeight;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    XMGTopic *topic = self.topics[indexPath.row];
//    // topic -> @"0xff54354354" -> @(cellHeight)
//    // topic -> @"0x4534546546" -> @(cellHeight)
////    NSString *key = [NSString stringWithFormat:@"%p", topic];
//    NSString *key = topic.description;
//
//    CGFloat cellHeight = [self.cellHeightDict[key] doubleValue];
//    if (cellHeight == 0) { // 这个模型对应的cell高度还没有计算过
//
//        // 文字的Y值
//        cellHeight += 55;
//
//        // 文字的高度
//        CGSize textMaxSize = CGSizeMake(XMGScreenW - 2 * XMGMarin, MAXFLOAT);
//        cellHeight += [topic.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + XMGMarin;
//
//        // 工具条
//        cellHeight += 35 + XMGMarin;
//
//        // 存储高度
//        self.cellHeightDict[key] = @(cellHeight);
//        //        [self.cellHeightDict setObject:@(cellHeight) forKey:key];
//
//        XMGLog(@"%zd %f", indexPath.row, cellHeight)
//    }
//
//    return cellHeight;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    QBYTopic *topic = self.topics[indexPath.row];
//    
//    CGFloat cellHeight = 0;
//    
//    // 文字的Y值
//    cellHeight += 55;
//    
//    // 文字的高度
//    CGSize textMaxSize = CGSizeMake(QBYScreenW - 2 * QBYMarin, MAXFLOAT);
//    cellHeight += [topic.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:textMaxSize].height + QBYMarin;
//    
//    // 工具条
//    cellHeight += 35 + QBYMarin;
//    
//    return cellHeight;
//}
// 这2个方法只适合计算单行文字的宽高
//    [topic.text sizeWithFont:[UIFont systemFontOfSize:15]].width;
//    [UIFont systemFontOfSize:15].lineHeight;

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
//- (void)loadNewData
//{
//    QBYLog(@"发送请求给服务器，下拉刷新数据")
//    
//    // 1.创建请求会话管理者
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    
//    // 2.拼接参数
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"a"] = @"list";
//    parameters[@"c"] = @"data";
//    parameters[@"type"] = @"1"; // 这里发送@1也是可行的
//
//    // 3.发送请求
//    [mgr GET:QBYCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
//        QBYAFNWriteToPlist(gujunqi)
//        // 字典数组 -> 模型数据
//        self.topics = [QBYTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
//        
//        // 刷新表格
//        [self.tableView reloadData];
//        
//        // 结束刷新
//        [self headerEndRefreshing];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
//        
//        // 结束刷新
//        [self headerEndRefreshing];
//    }];
//}

/**
 *  发送请求给服务器，上拉加载更多数据
 */
//- (void)loadMoreData
//{
//    QBYLog(@"发送请求给服务器 - 加载更多数据")
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 服务器请求回来了
//        self.dataCount += 5;
//        [self.tableView reloadData];
//        
//        // 结束刷新
//        [self footerEndRefreshing];
//    });
//}

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
    [self loadNewTopics];
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
    [self loadMoreTopics];
}

- (void)footerEndRefreshing
{
    self.footerRefreshing = NO;
    self.footerLabel.text = @"上拉可以加载更多";
    self.footerLabel.backgroundColor = [UIColor redColor];
}

@end
