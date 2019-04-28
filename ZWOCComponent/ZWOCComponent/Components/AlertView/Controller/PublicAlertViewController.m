//
//  PublicAlertViewController.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "PublicAlertViewController.h"

#import "PublicAlertView.h"//alert view

@interface PublicAlertViewController ()
@property (nonatomic, readwrite, strong) PublicAlertView *alertView;

@end

@implementation PublicAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutAlertCiewControls];
}

/*!
 * 构建提示框页面UI
 */
- (void)layoutAlertCiewControls
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    [backView setBackgroundColor:[UIColor blackColor]];
    [backView setAlpha:0.3];
    [self.view addSubview:backView];
    
    //add alert view
    [self.view addSubview:self.alertView];
}

#pragma mark - - Click Event Area - -
- (void)cancelClickAction:(id)sender
{
    if (self.publicAlertCancelClickBlock) {
        self.publicAlertCancelClickBlock();
    }
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)sureClickAction:(id)sender
{
    if (self.publicAlertSureClickBlock) {
        self.publicAlertSureClickBlock();
    }
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

#pragma mark - - Setter and Getter - -
- (PublicAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[PublicAlertView alloc] initWithFrame:CGRectMake(0, 0, 260, 132) withTitle:self.alertTitle withSureTitle:self.sureTitle withCancelTitle:self.cancelTitle];
        _alertView.center = self.view.center;
        [_alertView.cancelButton addTarget:self action:@selector(cancelClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_alertView.sureButton addTarget:self action:@selector(sureClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alertView;
}
@end
