//
//  WKWebViewViewController.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/26.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "WKWebViewViewController.h"
#import <WebKit/WebKit.h>
#import "CommonDefine.h"

@interface WKWebViewViewController ()<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) UIProgressView *progressView; // 进度条
@property (nonatomic, strong) WKWebView *wkWebView;         // webview

@end

@implementation WKWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

#pragma mark - 加载数据
#pragma mark -
-(void)loadData {
    //判断是url还是 request
    if (self.webViewType == WKWebViewType_PDF) {
        NSMutableURLRequest *webRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.webUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        [self.wkWebView loadRequest:webRequest];
    }else if (self.webViewType == WKWebViewType_HTML) {
        [self.wkWebView loadHTMLString:self.htmlContent baseURL:nil];
    }else if (self.webViewType == WKWebViewType_URL) {
        NSMutableURLRequest *webRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.webUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        [self.wkWebView loadRequest:webRequest];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    __weak typeof (self) weakSelf = self;
    [self.listenKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.wkWebView.configuration.userContentController addScriptMessageHandler:self name:obj];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.wkWebView) {
        __weak typeof (self) weakSelf = self;
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.listenKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:obj];
        }];
        self.wkWebView.navigationDelegate = nil;
        self.wkWebView.UIDelegate = nil;
    }
    //回调 刷新 - 兼容了手势右滑 返回的情况
    if (self.goBackBlock) {
        self.goBackBlock(nil);
    }
}

#pragma mark - WKWebview Protocol (WKScriptMessageHandler) - -
#pragma mark WKWebView 没有这个,不能播放页内视频
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark WKWebView收到ScriptMessage时回调此方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (self.scriptMessageBlock) {
       WKWebViewScriptMessageBlock reslut = self.scriptMessageBlock(message);
        if (reslut) {
            reslut();
        }
    }
}

// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"http://cdd.close.com"]) {//关闭回调
        //回调 刷新
        if (self.goBackBlock) {
            self.goBackBlock(nil);
        }
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }else if ([navigationAction.request.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

#pragma mark 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
}

#pragma mark 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
}

#pragma mark 页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error {
}

#pragma mark - - Progress - -
#pragma mark 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - - Setter and Getter - -
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        // 创建配置
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 创建UserContentController（提供JavaScript向webView发送消息的方法）
        WKUserContentController *userContent = [[WKUserContentController alloc] init];
        // 将UserConttentController设置到配置文件
        config.userContentController = userContent;
        
        // 允许自动播放音频文件
        if (@available(iOS 10.0, *)) {
            config.mediaTypesRequiringUserActionForPlayback = NO;
        } else {
            // Fallback on earlier versions
        }
        // 允许视频非全屏模式
        config.allowsInlineMediaPlayback = YES;
        
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        
        //禁止滚动条
        for (UIView *_aView in [self.wkWebView subviews]) {
            if ([_aView isKindOfClass:[UIScrollView class]]) {
                [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
                //右侧的滚动条
                [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
                //下侧的滚动条
            }
        }
        
        [self.view addSubview:_wkWebView];
        [self.view addSubview:self.progressView];
    }
    return _wkWebView;
}


/*!
 * 进度条加载
 */
- (UIProgressView *)progressView {
    if (!_progressView) {
        if (self.presentingViewController) {
            _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        }else{
            _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kTopHeight, self.view.frame.size.width, 1)];
        }
        _progressView.tintColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:1.0];
        _progressView.trackTintColor = [UIColor whiteColor];
        [self.view addSubview:_progressView];
        [self.view insertSubview:self.wkWebView belowSubview:_progressView];
    }
    return _progressView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
