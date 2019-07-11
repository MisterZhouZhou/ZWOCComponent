//
//  WebViewViewController.m
//  ZWOCComponent
//
//  Created by AHTOH on 2019/7/11.
//  Copyright © 2019 zhouwei. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()<UIWebViewDelegate>

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"JS调用OC";
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-40)];
    webView.delegate = self;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"shouldStartLoadWithRequest");
    NSString *urlstr = request.URL.absoluteString;
    NSRange range = [urlstr rangeOfString:@"ios://zw"];
    if (range.length!=0) {
        [self show];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

-(void)show{
    NSLog(@"JS调用OC");
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
