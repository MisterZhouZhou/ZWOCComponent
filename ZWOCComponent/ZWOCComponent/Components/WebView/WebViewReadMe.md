##  WebView组件说明

### 调用过程
```
   WebViewViewController *vc = [WebViewViewController new];
	//  vc.webUrl = @"http://www.baidu.com";
	//  vc.webViewType = WebViewType_URL;
    
    vc.htmlContent = @"<html>\
    <head></head>\
    <body>\
    <button onclick='clickAction()'>点击</button>\
    <h1>hhhh</h1>\
    </body>\
    <script>\
    function clickAction(){\
        window.webkit.messageHandlers.jsToOc.postMessage('dd');\
    }\
    </script>\
    </html>";
    vc.webViewType = WebViewType_HTML;
    vc.listenKeys = @[@"jsToOc"];
    vc.scriptMessageBlock = ^WebViewScriptMessageBlock(WKScriptMessage *response) {
        if ([response.name isEqualToString:@"jsToOc"]) {
            return ^(){
                UIAlertView *v =  [[UIAlertView alloc]initWithTitle:@"dd" message:@"dd" delegate:nil cancelButtonTitle:@"dd" otherButtonTitles:nil, nil];
                [v show];
            };
        }
        return ^(){
            NSLog(@"ddd");
        };
    };
    vc.title = @"百度";
    [self.navigationController pushViewController:vc animated:YES];
```
