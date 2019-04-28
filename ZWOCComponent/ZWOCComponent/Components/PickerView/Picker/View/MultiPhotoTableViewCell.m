//
//  MultiPhotoTableViewCell.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "MultiPhotoTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CommonDefine.h"
#import "MultiPhotoCollectionViewCell.h"
#import "UIColor+Color.h"
#import "ImageMultiPhotoModel.h"
#import "AVNoramlViewController.h"
#import "ImagePhotoBrowerViewController.h"

@interface MultiPhotoTableViewCell()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate, UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout* layout;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) CLLocation *location;           // 定位信息
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;     // 选择的是否为原始图片
@property (nonatomic, assign) CGFloat itemWH;                 // collection itemWidth
@property (nonatomic, assign) CGFloat margin;                 // collection margin
@property (nonatomic, strong) NSMutableArray *selectedPhotos; // 选中的图片

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation MultiPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initSubView];
    }
    return self;
}

#pragma mark- initSubView
#pragma mark-
- (void)initSubView {
    CGFloat marginX = 15;
    // title
    _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(marginX, 10, KScreenWidth-marginX*2, 20)];
    _titleLable.font = SYSTEMFONT(14);
    _titleLable.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_titleLable];
    
    // UICollectionView
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.alwaysBounceVertical = YES;
    //    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_collectionView];
    [_collectionView registerClass:[MultiPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"MultiPhotoCollectionViewCell"];
}

#pragma mark UICollectionView delegate dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= self.imageMaxCount) {
        return _selectedPhotos.count;
    }
    // 选视频视频操作
    //    if (!self.allowPickingMuitlpleVideoSwitch.isOn) {
    //        for (PHAsset *asset in _selectedAssets) {
    //            if (asset.mediaType == PHAssetMediaTypeVideo) {
    //                return _selectedPhotos.count;
    //            }
    //        }
    //    }
    if (self.editing) {//可以编辑 添加加号
        return _selectedPhotos.count + 1;
    }
    return _selectedPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MultiPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MultiPhotoCollectionViewCell" forIndexPath:indexPath];
    //    cell.videoImageView.hidden = YES;
    // 默认显示加号
    if (indexPath.item == _selectedPhotos.count) {
        cell.videoImageView.hidden = YES;
        cell.imageView.image = [UIImage imageNamed:@"But_add_pic"];
    } else {
        ImageMultiPhotoModel *model = _selectedPhotos[indexPath.item];
        if(model.url){
            if(model.isVideo && model.fileId){
                // 获取首帧图;
                if(model.image){
                    cell.imageView.image = model.image;
                }else{
                    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"bitmap"]];
                }
            }else{
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"bitmap"]];
            }
        }else{
            cell.imageView.image = model.image;
        }
        // 视频显示视频icon
        cell.videoImageView.hidden = !model.isVideo;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _selectedPhotos.count) {
        BOOL showSheet = YES;
        if (showSheet) {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"照片选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"去相册选择", nil];
            [sheet showInView:[UIApplication sharedApplication].keyWindow];
        }
    } else { // preview photos or video / 预览照片或者视频
        ImageMultiPhotoModel *model = _selectedPhotos[indexPath.item];
        PHAsset *asset = model.asset;
        BOOL isVideo = NO;
        if(asset){
            isVideo = asset.mediaType == PHAssetMediaTypeVideo;
        }else if(model.isVideo){
            isVideo = YES;
        }
//        if ([[asset valueForKey:@"filename"] containsString:@"GIF"]) {
//            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
//            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
//            vc.model = model;
//            [self.parentViewController presentViewController:vc animated:YES completion:nil];
//        }
        if (isVideo) { // perview video / 预览视频
            AVNoramlViewController *playerVC = [[AVNoramlViewController alloc]init];
            playerVC.coverImage = model.image;
            playerVC.title = self.titleLable.text;
            playerVC.isDelete = self.isEditing;//是否可以编辑
            playerVC.selectedIndex = indexPath.item;
            if(asset){
                playerVC.videoSource = model.asset;
            }else{
                playerVC.videoSource = model.url ? model.url : @"http://";
            }
            __weak typeof(self) weakSelf = self;
            playerVC.callBackBlock = ^(id videoSource, NSInteger selectedIndex){
                if(!videoSource){
                    [weakSelf.selectedPhotos removeObjectAtIndex:selectedIndex];
                }
                if(weakSelf.imageCountChange){
                    weakSelf.imageCountChange(weakSelf.selectedPhotos);
                }
            };
            [self.parentViewController.navigationController pushViewController:playerVC animated:YES];
        } else {
            // 预览图片
            ImagePhotoBrowerViewController *browerVC = [ImagePhotoBrowerViewController new];
            browerVC.isDelete = self.isEditing;//是否可以编辑
            browerVC.photos = _selectedPhotos;
            browerVC.titleString = self.titleLable.text;
            browerVC.selectedIndex = indexPath.item;
            __weak typeof(self) weakSelf = self;
            browerVC.callBackBlock = ^(NSMutableArray *photos){
                weakSelf.selectedPhotos = photos;
                if(weakSelf.imageCountChange){
                    weakSelf.imageCountChange(weakSelf.selectedPhotos);
                }
            };
            [self.parentViewController presentViewController: browerVC animated:YES completion:nil];
        }
    }
}


#pragma mark - TZImagePickerController
#pragma mark-  相册选择
- (void)pushTZImagePickerController {
    if (self.imageMaxCount <= 0) {
        return;
    }
    // 设置图库每列可展示的图片数
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.imageMaxCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    //    imagePickerVc.navigationBar.translucent = NO;
    // 设置不允许显示原图按钮
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    if (self.imageMaxCount > 1) {
        //        // 1.设置目前已经选中的图片数组
        //        NSMutableArray *selectedAssetsArray = [NSMutableArray array];
        //        for (int i=0; i<_selectedPhotos.count; i++) {
        //            MultiPhotoModel *model = _selectedPhotos[i];
        //            if(model.asset){
        //                [selectedAssetsArray addObject:model.asset];
        //            }
        //        }
        //        imagePickerVc.selectedAssets = selectedAssetsArray; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES;       // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo   = NO;        // 是否允许拍摄视频
    if(self.canSelectVideo){
        imagePickerVc.allowPickingVideo = YES;  // 在内部选取视频
    }else{
        imagePickerVc.allowPickingVideo = NO;   // 在内部选取视频
    }
    //    imagePickerVc.showSelectedIndex = YES;
    // 设置图片质量
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    // 设置imagePickerVc的外观
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    // 此处只能用presentViewController
    [self.parentViewController presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark  TZImagePickerControllerDelegate(图片选择delegate)
#pragma mark 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

#pragma mark 图片获取完毕
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    // 更新新数据
    NSMutableArray *tempSelectedPhotos = [NSMutableArray array];
    for (int i=0; i<photos.count; i++) {
        ImageMultiPhotoModel *model = [ImageMultiPhotoModel new];
        model.image = photos[i];
        model.asset = assets[i];
        model.isVideo = model.asset.mediaType == PHAssetMediaTypeVideo;
        [tempSelectedPhotos addObject:model];
    }
    [_selectedPhotos addObjectsFromArray:tempSelectedPhotos];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    if(self.imageCountChange){
        self.imageCountChange(_selectedPhotos);
    }
}

#pragma mark 如果用户选择了一个视频，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    ImageMultiPhotoModel *model = [ImageMultiPhotoModel new];
    model.image   = coverImage;
    model.asset   = asset;
    model.isVideo = YES;
    [self.selectedPhotos addObject:model];
    [_collectionView reloadData];
    if(self.imageCountChange){
        self.imageCountChange(_selectedPhotos);
    }
    //    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetMediumQuality success:^(NSString *outputPath) {
    //        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    //        [MBProgressHUD hideHUD];
    //        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    //
    //    } failure:^(NSString *errorMessage, NSError *error) {
    //        [MBProgressHUD hideHUD];
    //        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    //    }];
}

#pragma mark 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset {
    //    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    //    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}

#pragma mark 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    /*
     if ([albumName isEqualToString:@"个人收藏"]) {
     return NO;
     }
     if ([albumName isEqualToString:@"视频"]) {
     return NO;
     }*/
    return YES;
}

#pragma mark 决定asset显示与否(可以做类型尺寸过滤)
- (BOOL)isAssetCanSelect:(PHAsset *)asset {
    /*
     switch (asset.mediaType) {
     case PHAssetMediaTypeVideo: {
     // 视频时长
     // NSTimeInterval duration = phAsset.duration;
     return NO;
     } break;
     case PHAssetMediaTypeImage: {
     // 图片尺寸
     if (phAsset.pixelWidth > 3000 || phAsset.pixelHeight > 3000) {
     return NO;
     }
     return YES;
     } break;
     case PHAssetMediaTypeAudio:
     return NO;
     break;
     case PHAssetMediaTypeUnknown:
     return NO;
     break;
     default: break;
     }
     */
    return YES;
}


#pragma mark - UIImagePickerController
#pragma mark -
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限,  已被拒绝，没有相册权限，将无法保存拍的照片
    } else if ([PHPhotoLibrary authorizationStatus] == 2) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

#pragma mark - 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        // [mediaTypes addObject:(NSString *)kUTTypeMovie];
        [mediaTypes addObject:(NSString *)kUTTypeImage];
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        [self.parentViewController presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    tzImagePickerVc.sortAscendingByModificationDate = YES;
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) { // image
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(PHAsset *asset, NSError *error){
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
            }
        }];
    } else if ([type isEqualToString:@"public.movie"]) {  // video
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[TZImageManager manager] saveVideoWithUrl:videoUrl location:self.location completion:^(PHAsset *asset, NSError *error) {
                [tzImagePickerVc hideProgressHUD];
                if (!error) {
                    TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                    [[TZImageManager manager] getPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                        if (!isDegraded && photo) {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:photo];
                        }
                    }];
                }
            }];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UIAlertViewDelegate
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        [self takePhoto];
    }else if(buttonIndex == 1) {
        [self pushTZImagePickerController];
    }
}


#pragma mark - action
#pragma mark -
#pragma mark 点击删除
- (void)deleteBtnClik:(UIButton *)sender {
    // 没有加号的操作
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        //[_selectedAssets removeObjectAtIndex:sender.tag];
        // 重新赋值时进行了刷新，此处无需刷新
        //  [self.collectionView reloadData];
        if(self.imageCountChange){
            self.imageCountChange(_selectedPhotos);
        }
        return;
    }
    // 有加号的操作
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    //[_selectedAssets removeObjectAtIndex:sender.tag];
    typeof(self) __weak weakSelf = self;
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [weakSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        // 重新赋值时进行了刷新，此处无需刷新
        //  [weakSelf.collectionView reloadData];
        if(weakSelf.imageCountChange){
            weakSelf.imageCountChange(weakSelf.selectedPhotos);
        }
    }];
}

#pragma mark 刷新collectionView数据
- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    // 拍照刷新图片列表
    ImageMultiPhotoModel *model = [ImageMultiPhotoModel new];
    model.image = image;
    model.asset = asset;
    [_selectedPhotos addObject:model];
    if(self.imageCountChange){
        self.imageCountChange(_selectedPhotos);
    }
}

#pragma mark - setter & getter
#pragma mark -
- (void)setPhotosArray:(NSMutableArray *)photosArray {
    _photosArray = photosArray;
    if(photosArray){
        self.selectedPhotos = photosArray;
    }else{
        self.selectedPhotos = [NSMutableArray array];
    }
    [self.collectionView reloadData];
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        //  _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        //  _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

#pragma mark - 获取cell
- (id)sourceObjAtIdx:(NSInteger)idx {
    MultiPhotoCollectionViewCell *cell = (MultiPhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
    return cell ? cell.imageView : nil;
}

#pragma mark - 判断是否为网络资源
- (BOOL)isNetWorkSource:(id) source {
    if(![source isKindOfClass:[NSString class]]){
        return NO;
    }
    if([source hasPrefix:@"http://"] || [source hasPrefix:@"https://"]){
        return YES;
    }
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat marginX = 15;
    // 组件布局
    CGFloat cellWidth = CGRectGetWidth(self.contentView.bounds);
    self.margin = 4;
    self.itemWH = (cellWidth - 2 * _margin  - marginX * 2 -2) / 3 -_margin;
    self.layout.itemSize = CGSizeMake(_itemWH, _itemWH/4*3);
    self.layout.minimumInteritemSpacing = _margin;
    self.layout.minimumLineSpacing = 10;
    [self.collectionView setCollectionViewLayout:self.layout];
    self.collectionView.frame = CGRectMake(marginX, CGRectGetMaxY(self.titleLable.frame)+5, cellWidth - marginX*2, CGRectGetHeight(self.contentView.bounds)-36);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

#pragma clang diagnostic pop

