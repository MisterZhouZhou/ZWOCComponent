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
#import "LimitPointTextField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LimitPointTextField *field = [[LimitPointTextField alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth-20, 40)];
    field.backgroundColor = [UIColor redColor];
    [self.view addSubview:field];
    
    LimitPointTextField *field2 = [[LimitPointTextField alloc]initWithFrame:CGRectMake(10, 60, KScreenWidth-20, 40)];
    field2.limitNumPoint = 3;
    field2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:field2];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    PickerViewController *pvc = [PickerViewController new];
    pvc.isCanEditing = YES;
    [self.navigationController pushViewController:pvc animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
