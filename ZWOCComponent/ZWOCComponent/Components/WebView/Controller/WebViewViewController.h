//
//  WebViewViewController.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/26.
//  Copyright © 2019年 zhouwei. All rights reserved.
//  webview 查看控制器

#import <UIKit/UIKit.h>
#import "WebViewMacros.h"

// webview返回页面回调
typedef void(^WebViewBackBlock)(id response);
// 监听事件传值
typedef void(^WebViewScriptMessageBlock)(void);
// webview收到js消息页面回调
typedef WebViewScriptMessageBlock(^WebViewReceiveScriptMessageBlock)(id response);

@interface WebViewViewController : UIViewController

@property (nonatomic, copy) NSString *webUrl;                  // 网络url
@property (nonatomic, copy) NSString *htmlContent;             // 当类型为WebViewType_HTML时，使用改字段
@property (nonatomic, strong) NSArray *listenKeys;             // js,OC交互监听的key
@property (nonatomic, assign) WebViewType webViewType;         // 网页要加载的类型
@property (nonatomic, copy) WebViewBackBlock goBackBlock;      // 返回block回调
@property (nonatomic, copy) WebViewReceiveScriptMessageBlock scriptMessageBlock; // 收到js消息页面回调

@end
