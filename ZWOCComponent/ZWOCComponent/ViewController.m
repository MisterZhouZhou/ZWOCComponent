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
#import "PublicAlertViewController.h"
#import <ZWBaseModulesComponent/WKWebViewViewController.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    AXRatingView *ratingView = [[AXRatingView alloc]initWithFrame:CGRectMake(10, 100, 200, 40)];
    ratingView.numberOfStar = 6;
    ratingView.markImage = [UIImage imageNamed:@"icon_back"];
    ratingView.baseColor = [UIColor redColor];
    ratingView.stepInterval = 1;
    [self.view addSubview:ratingView];
    
//    LimitTextField *tf = [[LimitTextField alloc]initWithFrame:CGRectMake(10, 100, 200, 40)];
//    tf.layer.borderWidth = 1;
//    tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    tf.numberCount = 18;
//    tf.pointCount = 0;
//    tf.placeholder = @"dd";
//    tf.textFieldType = LimitTextFieldType_IdCard;
//    [self.view addSubview:tf];
    
//    PublicAlertViewController *signAlertViewCon = [PublicAlertViewController new];
//    //block
//    [signAlertViewCon setPublicAlertSureClickBlock:^{}];
//    [signAlertViewCon setPublicAlertCancelClickBlock:^{}];
//    signAlertViewCon.alertTitle = @"hhh";
//    signAlertViewCon.cancelTitle = @"";
//    signAlertViewCon.sureTitle = @"确认";
//    signAlertViewCon.modalTransitionStyle = UIModalPresentationOverFullScreen;
//    signAlertViewCon.providesPresentationContextTransitionStyle = YES;
//    signAlertViewCon.definesPresentationContext = YES;
//    signAlertViewCon.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:signAlertViewCon animated:NO completion:nil];
    
    
//    [BRAddressPickerView showAddressPickerWithDefaultSelected:@[@"浙江省", @"杭州市", @"西湖区"] resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
//        NSLog(@"%@-%@-%@", province.name, city.name, area.name);
//    }];
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
////    PickerViewController2 *vc = [PickerViewController2 new];
////    [self.navigationController pushViewController:vc animated:YES];
////
////    BOOL hasName = [self respondsToSelector:@selector(name)];
////    id name = [self performSelector:@selector(name)];
////    NSLog(@"%@==%@", vc, name);
//
//    WKWebViewViewController *vc = [WKWebViewViewController new];
//    vc.webUrl = @"http://www.baidu.com";
//    vc.webViewType = WKWebViewType_URL;
//    vc.title = @"百度";
//    [self.navigationController pushViewController:vc animated:YES];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
