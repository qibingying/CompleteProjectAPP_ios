//
//  QBYWebViewController.m
//  BuDeJie
//
//  Created by 古俊奇 on 2017/7/13.
//  Copyright © 2017年 骑兵营. All rights reserved.
//

#import "QBYWebViewController.h"
#import "WebKit/WebKit.h"

@interface QBYWebViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic)  WKWebView *webView;

@end

@implementation QBYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加webView
    WKWebView *webView = [[WKWebView alloc] init];
    _webView = webView;
    [self.contentView addSubview:webView];
    
    // 展示网页
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [webView loadRequest:request];
    
    // KVO监听属性改变
    /*
     Observer:观察者
     KeyPath:观察webView哪个属性
     options:NSKeyValueObservingOptionNew:观察新值改变
     
     KVO注意点.一定要记得移除
     */
    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    // 进度条
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

// 只要观察对象属性有新值就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    self.backItem.enabled = self.webView.canGoBack;
    self.forwardItem.enabled = self.webView.canGoForward;
    self.title = self.webView.title;
    self.progressView.progress = self.webView.estimatedProgress;
    self.progressView.hidden = self.webView.estimatedProgress >= 1;
}

#pragma mark - 对象被销毁
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - 生命周期方法  这个方法非常关键 必须要在这个里面重新布局子控件
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _webView.frame = self.contentView.bounds;
}

- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}
- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}
- (IBAction)reload:(id)sender {
    [self.webView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
