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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LimitCountTextField *field = [[LimitCountTextField alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth-20, 40)];
    field.layer.borderWidth = 1;
    field.layer.borderColor = [UIColor redColor].CGColor;
    field.limitCount = 11;
    [self.view addSubview:field];
    
    LimitCountTextField *field2 = [[LimitCountTextField alloc]initWithFrame:CGRectMake(10, 60, KScreenWidth-20, 40)];
    field2.backgroundColor = [UIColor whiteColor];
    field2.limitCount = 3;
    field2.layer.borderWidth = 1;
    field2.layer.borderColor = [UIColor blueColor].CGColor;
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
