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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PictureBrowerViewController *pVC = [PictureBrowerViewController new];
    pVC.urlsArray = @[@"https://avatar.csdn.net/5/F/0/3_zww1984774346.jpg", @"https://avatar.csdn.net/5/F/0/3_zww1984774346.jpg",@"http://img.soogif.com/5dThPALQIVEQvUa2QDKqT3ju2X82MIIW.gif"];
    [self.navigationController pushViewController:pVC animated:YES];

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
