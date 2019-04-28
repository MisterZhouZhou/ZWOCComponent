//
//  PictureBrowerViewController.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/26.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "PictureBrowerViewController.h"
#import "PictureBrowseView.h"
#import "CommonDefine.h"

@interface PictureBrowerViewController ()

@property (nonatomic, strong) UIButton *backButton;           // 返回按钮
@property (nonatomic, strong) PictureBrowseView * browseView; // 图片预览view

@end

@implementation PictureBrowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [self.view addSubview:self.browseView];
    self.browseView.urlsArray = self.urlsArray;
}

#pragma mark 自定义导航
- (void)loadNav {
    NSMutableArray * items = [[NSMutableArray alloc] init];
    //调整按钮位置
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width= -15;
    [items addObject:spaceItem];
    if (CurrentSystemVersion > 11) {
        [self.backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
    }
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    [items addObject:item];
    self.navigationItem.leftBarButtonItems = items;
}



#pragma mark - action
- (void)backAction {
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if(self.callBackBlock){
        self.callBackBlock();
    }
}

#pragma mark - getter
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self
                        action:@selector(backAction)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(PictureBrowseView *)browseView {
    if (!_browseView) {
        _browseView = [[PictureBrowseView alloc] initWithFrame:CGRectMake(0, kTopHeight, KScreenWidth, KScreenHeight-kTopHeight)];
        _browseView.backgroundColor = [UIColor blackColor];
        _browseView.viewController = self;
    }
    return _browseView;
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
