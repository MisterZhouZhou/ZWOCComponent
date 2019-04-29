//
//  PhotoZoomView.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/26.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "PhotoZoomView.h"
#import <SDWebImage/SDWebImage.h>
#import "ProgressView.h"
#import "CommonDefine.h"
#import "UIImage+Gif.h"
#import <Photos/Photos.h>

@interface PhotoZoomView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView * imageView;    // 图片
@property (nonatomic , strong) ProgressView *progressView;

@end

@implementation PhotoZoomView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.delegate = self;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 2.0f;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        // 进度条
        self.progressView.frame = CGRectMake(0, 0, 60, 60);
        self.progressView.center = CGPointMake(self.imageView.frame.size.width/2, self.imageView.frame.size.height/2);
        [self.imageView addSubview:self.progressView];
        // 添加双击手势
        [self addGestureRecognizer];
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}

#pragma mark 初始化手势
- (void)addGestureRecognizer {
//    self.userInteractionEnabled = YES;
    // 双击手势
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:doubleTap];
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:tap.view];
    if (!_doubleTap) {
        [self pictureZoomWithScale:self.maximumZoomScale touchPoint:point];
        _doubleTap = YES;
    }else{
        [self pictureZoomWithScale:self.minimumZoomScale touchPoint:CGPointZero];
        _doubleTap = NO;
    }
}

#pragma mark -- Help Methods
- (void)pictureZoomWithScale:(CGFloat)zoomScale touchPoint:(CGPoint)point {
    // 延中心点缩放
    if (zoomScale <= self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }else{
        CGFloat touchX = point.x;
        CGFloat touchY = point.y;
        touchX *= 1 / self.zoomScale;
        touchY *= 1 / self.zoomScale;
        touchX += self.contentOffset.x;
        touchY += self.contentOffset.y;
        CGRect zoomRect = [self zoomRectForScale:self.maximumZoomScale withCenter:CGPointMake(touchX, touchY)];
        [self zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGFloat height = self.frame.size.height / scale;
    CGFloat width  = self.frame.size.width / scale;
    CGFloat x = center.x - width * 0.5;
    CGFloat y = center.y - height * 0.5;
    return CGRectMake(x, y, width, height);
}

#pragma mark 设置url
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    if ([imageUrl hasPrefix:@"http://"] || [imageUrl hasPrefix:@"https://"]) { // 网络图
        // TODO 失败点击重新下载功能
        __weak typeof(self) weakSelf = self;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed| SDWebImageLowPriority| SDWebImageHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if ([strongSelf.imageUrl isEqual:targetURL.absoluteString] && expectedSize > 0) {
                    strongSelf.progressView.progress = (CGFloat)receivedSize / expectedSize ;
                }
            });
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.progressView removeFromSuperview];
            if (error) {
                [strongSelf setMaxAndMinZoomScales];
                NSLog(@"加载图片失败 , 图片链接imageURL = %@ , 错误信息: %@ ,检查是否开启允许HTTP请求",imageURL,error);
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    strongSelf.imageView.image = image;
                    strongSelf.progressView.progress = 1.0;
                    [strongSelf setMaxAndMinZoomScales];
                }];
            }
        }];
    }else{ // 本地图片
        NSData *imageData = [NSData dataWithContentsOfFile:imageUrl];
        self.imageView.image = [UIImage imageWithData:imageData];
    }
}

#pragma mark 设置image
-(void)setImage:(UIImage *)image {
    _image = image;
    if (image) {
        [self.progressView removeFromSuperview];
        [self.progressView removeFromSuperview];
        self.imageView.image = image;
    }
}

#pragma mark 设置asset image
-(void)setAssetImage:(PHAsset *)assetImage {
    _assetImage = assetImage;
    [self.progressView removeFromSuperview];
    // 从相册获取gif
    [self getOriginalPhotoDataWithAsset:assetImage completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
        self.imageView.image = [UIImage sd_imageWithGIFData:data];
    }];
}

#pragma mark 从相册获取资源
- (PHImageRequestID)getOriginalPhotoDataWithAsset:(PHAsset *)asset completion:(void (^)(NSData *data,NSDictionary *info,BOOL isDegraded))completion {
    return [self getOriginalPhotoDataWithAsset:asset progressHandler:nil completion:completion];
}

- (PHImageRequestID)getOriginalPhotoDataWithAsset:(PHAsset *)asset progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler completion:(void (^)(NSData *data,NSDictionary *info,BOOL isDegraded))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
        // if version isn't PHImageRequestOptionsVersionOriginal, the gif may cann't play
        option.version = PHImageRequestOptionsVersionOriginal;
    }
    [option setProgressHandler:progressHandler];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    return [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && imageData) {
            if (completion) completion(imageData,info,NO);
        }
    }];
}


/**
 *  根据图片和屏幕比例关系,调整最大和最小伸缩比例
 */
- (void)setMaxAndMinZoomScales {
    // self.photoImageView的初始位置
    UIImage *image = self.imageView.image;
    if (image == nil || image.size.height==0) {
        return;
    }
    CGFloat imageWidthHeightRatio = image.size.width / image.size.height;
    CGFloat imageWidth  = CGRectGetWidth(self.frame);
    CGFloat imageHeight =  imageWidth  / imageWidthHeightRatio;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    if (imageHeight > viewHeight) {
        imageY = 0;
    } else {
        imageY = (viewHeight - imageHeight) * 0.5;
    }
    self.imageView.frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
    self.zoomScale = 1.0;
    self.contentSize = CGSizeMake(imageWidth, MAX(imageHeight, KScreenHeight));
}

#pragma mark -- UIScrollViewDelegate
//返回需要缩放的视图控件 缩放过程中
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

//开始缩放
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    NSLog(@"开始缩放");
}
//结束缩放
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"结束缩放");
}

//缩放中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 延中心点缩放
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
}

#pragma mark - 根据偏移量获取图片的中心点
- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

- (ProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[ProgressView alloc] init];
    }
    return _progressView;
}


@end
