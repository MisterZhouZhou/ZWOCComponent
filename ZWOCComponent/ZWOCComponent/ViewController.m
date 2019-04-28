//
//  ViewController.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/26.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "ViewController.h"
#import "WebViewViewController.h"
#import <WebKit/WebKit.h>
#import "PictureBrowerViewController.h"
#import "ZWVerifyCodeCursorView.h"
#import "CommonDefine.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZWVerifyCodeCursorView *code4View = [[ZWVerifyCodeCursorView alloc] initWithCount:4 margin:20];
    code4View.frame = CGRectMake(20, 90, KScreenWidth-40, 40);
    code4View.lineColor = [UIColor greenColor];
    code4View.itemMargin = 10;
    code4View.codeColor  = [UIColor blueColor];
    code4View.codeFont   = [UIFont systemFontOfSize:20];
    code4View.codeMode   = CodeMode_Border;
    code4View.animated   = YES;
    code4View.inputEndBlock = ^(NSString *code){
        NSLog(@"%@", code);
    };
    [self.view addSubview:code4View];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
