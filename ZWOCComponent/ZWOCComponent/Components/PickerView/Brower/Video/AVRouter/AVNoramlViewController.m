//
//  ZFNoramlViewController.m
//  ZFPlayer
//
//  Created by 紫枫 on 2018/3/21.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "AVNoramlViewController.h"
#import <Photos/Photos.h>
#import "ZFPlayer.h"
#import "ZFUtilities.h"
#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "UIImageView+ZFCache.h"
#import "CommonDefine.h"
#import "PublicAlertViewController.h"
#import "MBProgressHUD+XY.h"

//背景图片
//static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface AVNoramlViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIButton *deleteButton;    // 右上角删除按钮


@end

@implementation AVNoramlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setNavGationItem];
    
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.playBtn];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    [self.player stop];
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    
    /// 播放完成
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player stop];
        // 为下次播放做好准备
        [self.player playerReadyToPlay];
    };
    
    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        NSLog(@"======开始播放了");
    };
    if([self.videoSource isKindOfClass:[PHAsset class]]){
             kWeakSelf(self)
             PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
             options.version = PHImageRequestOptionsVersionCurrent;
             options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
             PHImageManager *manager = [PHImageManager defaultManager];
             [manager requestAVAssetForVideo:self.videoSource
                                     options:options
                               resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                                   // asset 类型为 AVURLAsset  为此资源的fileURL
                                   // <AVURLAsset: 0x283386e60, URL = file:///var/mobile/Media/DCIM/100APPLE/IMG_0049.MOV>
                                   AVURLAsset *urlAsset = (AVURLAsset *)asset;
                                   weakself.player.assetURLs =@[urlAsset.URL];
                               }];
         }else if ([self.videoSource hasPrefix:@"http://"] || [self.videoSource hasPrefix:@"https://"]) {
             self.player.assetURLs = @[[NSURL URLWithString:self.videoSource]];
         }else{
             self.player.assetURLs =@[[NSURL fileURLWithPath:self.videoSource]];
         }
}

#pragma mark navgationIteam
-(void)setNavGationItem{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    //调整按钮位置
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width= -15;
    [items addObject:spaceItem];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:ZFPlayer_Image(@"icon_back") forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    if (CurrentSystemVersion > 11) {
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 10)];
    }
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [items addObject:item];
    self.navigationItem.leftBarButtonItems = items;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 可以删除时才显示删除按钮
    if(self.isDelete){
        // 删除
        UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithCustomView:self.deleteButton];
        self.navigationItem.rightBarButtonItem = editItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.player.viewControllerDisappear = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x = 0;
    CGFloat w = CGRectGetWidth(self.view.frame);
    //    CGFloat h = w*9/16;
    //    CGFloat y = (CGRectGetHeight(self.view.frame)- h)/2;
    // 调整为竖屏全屏幕
    CGFloat h = CGRectGetHeight(self.view.frame)-kTopHeight;
    CGFloat y = kTopHeight;
    self.containerView.frame = CGRectMake(x, y, w, h);
    
    w = 44;
    h = w;
    x = (CGRectGetWidth(self.containerView.frame)-w)/2;
    y = (CGRectGetHeight(self.containerView.frame)-h)/2;
    self.playBtn.frame = CGRectMake(x, y, w, h);
}

- (void)playClick:(UIButton *)sender {
    [self.player playTheIndex:0];
    //    [self.controlView showTitle:nil coverURLString:nil fullScreenMode:ZFFullScreenModeAutomatic];
}

- (void)handleDelete {
    PublicAlertViewController *signAlertViewCon = [PublicAlertViewController new];
    //block
    kWeakSelf(self)
    [signAlertViewCon setPublicAlertSureClickBlock:^{
        kStrongSelf(self)
        self.videoSource = nil;
        // 提示删除成功
        [MBProgressHUD showSuccessMessage:@"删除成功"];
        if (!self.videoSource) {
            [self backAction];
        }
    }];
    [signAlertViewCon setPublicAlertCancelClickBlock:^{
        
    }];
    signAlertViewCon.alertTitle = @"是否要删除此视频？";
    signAlertViewCon.cancelTitle = @"取消";
    signAlertViewCon.sureTitle = @"确认";
    signAlertViewCon.modalTransitionStyle = UIModalPresentationOverFullScreen;
    signAlertViewCon.providesPresentationContextTransitionStyle = YES;
    signAlertViewCon.definesPresentationContext = YES;
    signAlertViewCon.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:signAlertViewCon animated:NO completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    //    self.player.currentPlayerManager.muted = !self.player.currentPlayerManager.muted;
}

- (UIImage *)imageNamed:(NSString *)name fromMyBundle:(NSString *)bundle {
    NSString *image_name = [NSString stringWithFormat:@"%@.png", name];
    // 加载bundle
    NSString *strResourcesBundle = [[NSBundle mainBundle] pathForResource:bundle ofType:@"bundle"];
    NSString *image_path = [strResourcesBundle stringByAppendingPathComponent:image_name];;
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:image_path];
    return image;
}

#pragma mark - action
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
    if(self.callBackBlock){
        self.callBackBlock(_videoSource, self.selectedIndex);
    }
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
    }
    return _controlView;
}

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        if(self.coverImage){
            _containerView.image = self.coverImage;
        }else{
            _containerView.image = [UIImage imageNamed:@"bitmap"];
            //[_containerView setImageWithURLString:kVideoCover placeholder:[ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)]];
        }
    }
    return _containerView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[self imageNamed:@"new_allPlay_44x44_" fromMyBundle:@"CDDMoviePlayerComponentsModules"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(0, 0, 40, 40);
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = SYSTEMFONT(14);
        [_deleteButton setTitleColor:[UIColor colorWithRed:189/255.0 green:8/255.0 blue:28/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [_deleteButton addTarget:self
                          action:@selector(handleDelete)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

@end
