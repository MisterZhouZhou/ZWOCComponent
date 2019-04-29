//
//  ImagePhotoBrowerViewController.m
//  CDDUIPublicComponentsModules
//
//  Created by zhouwei on 2018/12/20.
//

#import "ImagePhotoBrowerViewController.h"
#import "ImageMultiPhotoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CommonDefine.h"
#import "UIColor+Color.h"
#import "MBProgressHUD+XY.h"
#import "UIImage+Gif.h"
#import "PictureBrowseView.h"
#import "PhotoZoomView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ImagePhotoBrowerViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *backButton; // 返回按钮
@property (nonatomic, strong) UIScrollView *scrollView;  // scrollView
@property (nonatomic, strong) UIButton *deleteButton;    // 右上角删除按钮
@property (nonatomic, strong) UILabel *titleLabel;       // 图片预览器标题

@end

@implementation ImagePhotoBrowerViewController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadNav];
    [self loadPageView];
    [self loadScrollView];
}

- (void)loadNav {
    // 自定义导航
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopHeight)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    CGFloat w = 30;
    CGFloat y = kTopHeight - w - 8;
    
    // 添加返回按钮
    self.backButton.frame = CGRectMake(0, y-5, w+20, w+10);
    [navView addSubview:self.backButton];
    // 添加标题
    self.titleLabel.frame     = CGRectMake((SCREEN_WIDTH-200)/2, y, 200, w);
    self.titleLabel.text = self.titleString;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel setFont:[UIFont fontWithName:@"SimSun" size:22]];
    //    [self.titleLabel setTextColor:[UIColor ]];
    [navView addSubview:self.titleLabel];
    
    // 添加删除按钮
    self.deleteButton.frame = CGRectMake(SCREEN_WIDTH-w-10, y, w, w);
    if (self.isDelete) {//是否可以删除
        [navView addSubview:self.deleteButton];
    }
    
    // 添加分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(navView.frame)-1, KScreenWidth, 1)];
    lineView.backgroundColor  = [UIColor colorWithHexString:@"ededed"];
    [navView addSubview:lineView];
}

#pragma mark - action
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.callBackBlock){
        self.callBackBlock(self.photos);
    }
}

#pragma mark - private methods
- (void)loadPageView {
    CGFloat navHeight = kTopHeight;
    // scrollview
    CGFloat height = KScreenHeight - navHeight;;
    self.scrollView.frame = CGRectMake(0, navHeight, self.view.frame.size.width, height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.photos.count, height);
}

- (void)loadScrollView {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < self.photos.count; i++) {
        ImageMultiPhotoModel *gallery = self.photos[i];
        PhotoZoomView * photoZoomView = [[PhotoZoomView alloc] initWithFrame:CGRectMake(i * KScreenWidth, 0, KScreenWidth, CGRectGetHeight(self.scrollView.bounds))];
        if (StrValid(gallery.url)) {
            photoZoomView.imageUrl = gallery.url;
        }else if(gallery.asset){
            photoZoomView.assetImage = gallery.asset;
        }else{
            photoZoomView.image    = gallery.image;
        }
        [self.scrollView addSubview:photoZoomView];
    }
    if (self.selectedIndex != 0) {
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame) * self.selectedIndex, 0) animated:NO];
    }
    [self changeTitle];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // 删除操作
        [self.photos removeObjectAtIndex:self.selectedIndex];
        if(self.selectedIndex>0){
            self.selectedIndex --;
        }
        // 提示删除成功
        [MBProgressHUD showSuccessMessage:@"删除成功"];
    }
    if (!self.photos.count) {
        [self backAction];
    } else {
        [self loadScrollView];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.selectedIndex = index;
    // 改变标题
    [self changeTitle];
}

#pragma mark - action
- (void)changeTitle {
    if (!self.photos.count) {
        return;
    }
    ImageMultiPhotoModel *gallery = self.photos[self.selectedIndex];
    if (StrValid(gallery.url) || gallery.image) {
        [self.deleteButton setEnabled:YES];
    } else {
        [self.deleteButton setEnabled:NO];
    }
}

- (void)handleDelete {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否要删除此照片？"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"删除", nil];
    [alertView show];
}



#pragma mark - setter & getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
    }
    return _scrollView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = SYSTEMFONT(14);
        [_deleteButton setTitleColor:[UIColor colorWithRed:189/255.0 green:8/255.0 blue:28/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [_deleteButton addTarget:self
                          action:@selector(handleDelete)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

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


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font          = BOLDSYSTEMFONT(15.0);
    }
    return _titleLabel;
}


- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma clang diagnostic pop


@end
