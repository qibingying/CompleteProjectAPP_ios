//
//  QBYEssenceViewController.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/4.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

// UIBarButtonItem:描述按钮具体的内容
// UINavigationItem:设置导航条上内容(左边,右边,中间)
// tabBarItem: 设置tabBar上按钮内容(tabBarButton)

/*
 名字叫attributes并且是NSDictionary *类型的参数，它的key一般都有以下规律
 1.iOS7开始
 1> 所有的key都来源于： NSAttributedString.h
 2> 格式基本都是：NS***AttributeName
 
 2.iOS7之前
 1> 所有的key都来源于： UIStringDrawing.h
 2> 格式基本都是：UITextAttribute***
 */

#import "QBYEssenceViewController.h"
#import "QBYTitleButton.h"
#import "QBYAllViewController.h"
#import "QBYVideoViewController.h"
#import "QBYVoiceViewController.h"
#import "QBYPictureViewController.h"
#import "QBYWordViewController.h"

@interface QBYEssenceViewController()<UIScrollViewDelegate>
/** 用来存放所有子控制器view的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;
/** 标题下划线 */
@property (nonatomic, weak) UIView *titleUnderline;
/** 上一次点击的标题按钮 */
@property (nonatomic, weak) QBYTitleButton *previousClickedTitleButton;

@end

@implementation QBYEssenceViewController

- (void)viewDidLoad{

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    // 初始化子控制器
    [self setupAllChildVcs];

    [self setUpNavBar];
//    scrollview
    [self setupScrollView];
//    titleViews
    [self setupTitleViews];
    // 添加第0个子控制器的view
    [self addChildVcViewIntoScrollView:0];
}

/**
 *  初始化子控制器
 */
- (void)setupAllChildVcs
{
    [self addChildViewController:[[QBYAllViewController alloc] init]];
    [self addChildViewController:[[QBYVideoViewController alloc] init]];
    [self addChildViewController:[[QBYVoiceViewController alloc] init]];
    [self addChildViewController:[[QBYPictureViewController alloc] init]];
    [self addChildViewController:[[QBYWordViewController alloc] init]];
}


/**
 *  ScrollView
 */
- (void)setupScrollView{
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollsToTop = NO; // 点击状态栏的时候，这个scrollView不会滚动到最顶部
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    /*
     UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
     btn.frame = CGRectMake(0, 0, 100, 50);
     [btn setTitle:@"按钮" forState:UIControlStateNormal];
     //    [btn setBackgroundImage:[UIImage imageNamed:@"mine-my-post"] forState:UIControlStateNormal];
     // 加载bundle里面的图片需要加上bundle的文件名, 格式: bundle文件名/图片名
     //    [btn setImage:[UIImage imageNamed:@"SVProgressHUD.bundle/error"] forState:UIControlStateNormal];
     [scrollView addSubview:btn];
     */
    NSUInteger count = self.childViewControllers.count;
    CGFloat scrollViewW = scrollView.qby_width;
//    CGFloat scrollViewH = scrollView.qby_height;
    
//    for (NSUInteger i = 0; i < count; i++) {
//        // 取出i位置子控制器的view
//        UIView *childVcView = self.childViewControllers[i].view;
//        childVcView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH);
//        [scrollView addSubview:childVcView];
//    }
    
    scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);

}

/**
 *  标题栏
 */
- (void)setupTitleViews{
    UIView *titleViews = [[UIView alloc]init];
    titleViews.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    //    titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    //    titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    // 子控件会继承父控件设置的alpha透明度
    //    titlesView.alpha = 0.5;
    titleViews.frame = CGRectMake(0, QBYNavMaxY, self.view.qby_width, QBYTitlesViewH);
    [self.view addSubview:titleViews];
    self.titlesView = titleViews;
    
    // 标题栏按钮
    [self setupTitleButtons];
    // 标题下划线
    [self setupTitleUnderline];
}

/**
 *  标题栏按钮
 */
- (void)setupTitleButtons
{
    // 文字
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    NSUInteger count = titles.count;
    
    // 标题按钮的尺寸
    CGFloat titleButtonW = self.titlesView.qby_width / count;
    CGFloat titleButtonH = self.titlesView.qby_height;
    
    // 创建5个标题按钮
    for (NSUInteger i = 0; i < count; i++) {
        QBYTitleButton *titleButton = [[QBYTitleButton alloc] init];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:titleButton];
        // frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        // 文字
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
//        下面代码移植到自定义的UIButton中去了
//        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        //        [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    }
}

/**
 *  标题下划线
 */
- (void)setupTitleUnderline
{
    // 标题按钮
    QBYTitleButton *firstTitleButton = self.titlesView.subviews.firstObject;
    
    // 下划线
    UIView *titleUnderline = [[UIView alloc] init];
    titleUnderline.qby_height = 2;
    titleUnderline.qby_y = self.titlesView.qby_height - titleUnderline.qby_height;
    titleUnderline.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    [self.titlesView addSubview:titleUnderline];
    self.titleUnderline = titleUnderline;
    
    // 切换按钮状态
    firstTitleButton.selected = YES;
    self.previousClickedTitleButton = firstTitleButton;
    
    [firstTitleButton.titleLabel sizeToFit]; // 让label根据文字内容计算尺寸
    self.titleUnderline.qby_width = firstTitleButton.titleLabel.qby_width + QBYMarin;
    self.titleUnderline.qby_centerX = firstTitleButton.qby_centerX;
}

- (void)setUpNavBar{

    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:nil action:nil];
    
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];

}

#pragma mark - 监听
/**
 *  点击标题按钮
 */
- (void)titleButtonClick:(QBYTitleButton *)titleButton
{
    // 重复点击了标题按钮
    if (self.previousClickedTitleButton == titleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:QBYTitleButtonDidRepeatClickNotification object:nil];
    }
    // 处理标题按钮点击
    [self dealTitleButtonClick:titleButton];
}

/**
 *  处理标题按钮点击
 */
- (void)dealTitleButtonClick:(QBYTitleButton *)titleButton
{
    self.previousClickedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.previousClickedTitleButton = titleButton;
    
    NSUInteger index = titleButton.tag;
    [UIView animateWithDuration:0.25 animations:^{
        // 处理下划线
        //        XMGLog(@"%@", [titleButton titleForState:UIControlStateNormal])
        //        self.titleUnderline.xmg_width = [titleButton.currentTitle sizeWithFont:titleButton.titleLabel.font].width;
        
        //        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        //        attributes[NSFontAttributeName] = titleButton.titleLabel.font;
        //        self.titleUnderline.xmg_width = [titleButton.currentTitle sizeWithAttributes:attributes].width;
        
        self.titleUnderline.qby_width = titleButton.titleLabel.qby_width + QBYMarin;
        self.titleUnderline.qby_centerX = titleButton.qby_centerX;
        
        // 滚动scrollView
        //        NSUInteger index = [self.titlesView.subviews indexOfObject:titleButton];
        //        CGFloat offsetX = self.scrollView.xmg_width * index;
        //                                375                        1,视频
        CGFloat offsetX = self.scrollView.qby_width * index;
        //                                                      375            偏移y值保持原来
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        // 添加子控制器的view
        [self addChildVcViewIntoScrollView:index];

    }];
    
//    g只改x，不改y 保持原值 不要写死是0
    //        CGPoint offset = self.scrollView.contentOffset;
    //        offset.x = ;
    //        self.scrollView.contentOffset = offset;
    
    // 设置index位置对应的tableView.scrollsToTop = YES， 其他都设置为NO
    for (NSUInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        // 如果view还没有被创建，就不用去处理
        if (!childVc.isViewLoaded) continue;
        
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        
        //        if (i == index) { // 是标题按钮对应的子控制器
        //            scrollView.scrollsToTop = YES;
        //        } else {
        //            scrollView.scrollsToTop = NO;
        //        }
        scrollView.scrollsToTop = (i == index);
    }


}

//- (void)titleButtonClick:(XMGTitleButton *)titleButton
//{
//    self.previousClickedTitleButton.enabled = YES;
//    titleButton.enabled = NO;
//    self.previousClickedTitleButton = titleButton;
//
//    XMGFunc
//}

//- (void)titleButtonClick:(XMGTitleButton *)titleButton
//{
//    [self.previousClickedTitleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    self.previousClickedTitleButton = titleButton;
//}

- (void)game
{
    QBYFunc
}

#pragma mark - <UIScrollViewDelegate>
/**
 *  当用户松开scrollView并且滑动结束时调用这个代理方法（scrollView停止滚动的时候）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 求出标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.qby_width;
    // index == [0, 4]
    
    // 点击对应的标题按钮
    QBYTitleButton *titleButton = self.titlesView.subviews[index];
//    用tag一定要注意  因为他会遍历自己的tag  当tag=0的时候更要注意
    //    XMGTitleButton *titleButton = [self.titlesView viewWithTag:index];
//    [self titleButtonClick:titleButton];
     [self dealTitleButtonClick:titleButton];
}

#pragma mark - 其他
/**
 *  添加第index个子控制器的view到scrollView中
 */
- (void)addChildVcViewIntoScrollView:(NSUInteger)index
{
    //取出按钮索引对应的控制器
    UIViewController *childVc = self.childViewControllers[index];
    
    // 如果view已经被加载过，就直接返回
    if (childVc.isViewLoaded) return;
    
    // 取出index位置对应的子控制器view   g这段代码必须要放在懒加载后面 不然就直接return
    UIView *childVcView = childVc.view;
//    g下面两种方法也是判断懒加载的  就是防止重复添加
    //    if (childVcView.superview) return;
    //    if (childVcView.window) return;
    
    // 设置子控制器view的frame
    CGFloat scrollViewW = self.scrollView.qby_width;
    childVcView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.scrollView.qby_height);
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childVcView];
}


/**
 *  当用户松开scrollView时调用这个代理方法（结束拖拽的时候）
 */
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    XMGFunc
//}

/*
 -[UIView setSelected:]: unrecognized selector sent to instance 0x7fbcba35ab10
 
 -[XMGPerson length]: unrecognized selector sent to instance 0x7fbcba35ab10
 将XMGPerson当做NSString来使用
 
 - (void)test:(NSString *)string
 {
 string.length;
 }
 id str = [[XMGPerson alloc] init];
 [self test:str];
 
 -[XMGPerson count]: unrecognized selector sent to instance 0x7fbcba35ab10
 将XMGPerson当做NSArray或者NSDictionary来使用
 
 -[XMGPerson setObject:forKeyedSubscript:]: unrecognized selector sent to instance 0x7fbcba35ab10
 名字中带有Subscript的方法，一般都是集合的方法，比如NSMutableDictionary\NSMutableArray的方法
 将XMGPersonNSMutableDictionary来使用
 */

/*
 A
 -D1  0
 -E1 10
 -E2 0
 -D2 10
 -F1 0
 -F2 0
 -D3 0
 
 [A viewWithTag:10]; // 返回E1
 */

/*
 @implementation UIView
 
 - (UIView *)viewWithTag:(NSInteger)tag
 {
 // 如果自己的tag符合要求，就返回自己
 if (self.tag == tag) return self;
 
 // 遍历子控件（也包括子控件的子控件...），直到找到符合条件的子控件为止
 for (UIView *subview in self.subviews) {
 //        if (subview.tag == tag) return subview;
 UIView *resultView = [subview viewWithTag:tag];
 if (resultView) return resultView;
 }
 
 return nil;
 }
 
 @end
 */

@end
