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
#import "PickerViewController.h"
#import "PickerViewController2.h"
#import "BRAddressPickerView.h"
#import "NSDate+Date.h"
#import <YYKit/YYKit.h>
#import "CDDEmptView.h"
#import "LimitCountTextField.h"
#import "ZWTextView.h"
#import "AXRatingView.h"
#import "CommentView.h"
#import "LimitTextField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    LimitTextField *tf = [[LimitTextField alloc]initWithFrame:CGRectMake(10, 100, 200, 40)];
    tf.layer.borderWidth = 1;
    tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tf.limitCount = 5;
    [self.view addSubview:tf];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
    PickerViewController2 *vc = [PickerViewController2 new];
    [self.navigationController pushViewController:vc animated:YES];
   
//    BOOL hasName = [self respondsToSelector:@selector(name)];
//    id name = [self performSelector:@selector(name)];
//    NSLog(@"%@==%@", vc, name);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
