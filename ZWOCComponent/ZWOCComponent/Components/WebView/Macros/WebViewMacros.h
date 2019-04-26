//
//  WebViewMacros.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/26.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#ifndef WebViewMacros_h
#define WebViewMacros_h

/*
 * WebView所支持的显示类型
 */
typedef NS_ENUM(NSUInteger, WebViewType) {
    /* 加载URL格式的页面 */
    WebViewType_URL,
    /* 加载PDF文件的URL */
    WebViewType_PDF,
    /* 加载API请求的HTML内容 */
    WebViewType_HTML
};

#endif /* WebViewMacros_h */
