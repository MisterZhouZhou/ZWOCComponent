//
//  PickerViewController2.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/29.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "PickerViewController2.h"
#import "MultiPhotoAddView.h"
#import "CommonDefine.h"
#import "UIView+HKFrame.h"

@interface PickerViewController2 ()

@end

@implementation PickerViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    MultiPhotoAddView *view = [[MultiPhotoAddView alloc]initWithFrame:CGRectMake(10, kTopHeight, KScreenWidth-20, 100)];
    view.imageMaxCount = 99;
    view.photosArray = @[].mutableCopy;
    view.isEditing = YES;
    view.parentViewController = self;
    __block typeof(view) weakView = view;
    view.imageHeightChange = ^(CGFloat height){
        weakView.height = height;
        NSLog(@"%f", height);
    };
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
