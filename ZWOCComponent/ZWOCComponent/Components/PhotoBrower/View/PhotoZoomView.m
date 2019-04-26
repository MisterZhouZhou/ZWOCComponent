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

@interface PhotoZoomView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView * imageView;  // 图片
@property (nonatomic, assign) CGFloat imageNormalWidth; // 图片未缩放时宽度
@property (nonatomic, assign) CGFloat imageNormalHeight; // 图片未缩放时高度
@property (nonatomic , strong) ProgressView *progressView;

@end

@implementation PhotoZoomView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.delegate = self;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 2.0f;
        _imageNormalHeight = frame.size.height;
        _imageNormalWidth = frame.size.width;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imageNormalWidth, _imageNormalWidth)];
        self.imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        self.progressView.bounds = CGRectMake(0, 0, 100, 100);
        self.progressView.center = self.imageView.center;
        [self.imageView addSubview:self.progressView];
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}

#pragma mark -- Help Methods
- (void)pictureZoomWithScale:(CGFloat)zoomScale {
    // 延中心点缩放
    CGFloat imageScaleWidth = zoomScale * self.imageNormalWidth;
    CGFloat imageScaleHeight = zoomScale * self.imageNormalHeight;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    if (imageScaleWidth < self.frame.size.width) {
        imageX = floorf((self.frame.size.width - imageScaleWidth) / 2.0);
    }
    if (imageScaleHeight < self.frame.size.height) {
        imageY = floorf((self.frame.size.height - imageScaleHeight) / 2.0);
    }
    self.imageView.frame = CGRectMake(imageX, imageY, imageScaleWidth, imageScaleHeight);
    self.contentSize = CGSizeMake(imageScaleWidth,imageScaleHeight);
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    if ([imageUrl hasPrefix:@"http://"] || [imageUrl hasPrefix:@"https://"]) { // 网络图
        // TODO 失败点击重新下载功能
        __weak typeof(self) weakSelf = self;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed| SDWebImageLowPriority| SDWebImageHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if ([strongSelf.imageUrl isEqual:targetURL] && expectedSize > 0) {
                    strongSelf.progressView.progress = (CGFloat)receivedSize / expectedSize ;
                }
            });
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.progressView removeFromSuperview];
            if (error) {
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
    self.imageView.xl_width = self.xl_width;
    self.imageView.xl_height = self.xl_width / imageWidthHeightRatio;
    self.imageView.xl_x = 0;
    if (self.imageView.xl_height > XLScreenH) {
        self.imageView.xl_y = 0;
        self.scrollview.scrollEnabled = YES;
    } else {
        self.imageView.xl_y = (XLScreenH - self.photoImageView.xl_height ) * 0.5;
        self.scrollview.scrollEnabled = NO;
    }
    self.scrollview.maximumZoomScale = MAX(XLScreenH / self.photoImageView.xl_height, 3.0);
    self.scrollview.minimumZoomScale = 1.0;
    self.scrollview.zoomScale = 1.0;
    self.scrollview.contentSize = CGSizeMake(self.photoImageView.xl_width, MAX(self.photoImageView.xl_height, XLScreenH));
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
    CGFloat imageScaleWidth = scrollView.zoomScale * self.imageNormalWidth;
    CGFloat imageScaleHeight = scrollView.zoomScale * self.imageNormalHeight;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    if (imageScaleWidth < self.frame.size.width) {
        imageX = floorf((self.frame.size.width - imageScaleWidth) / 2.0);
    }
    if (imageScaleHeight < self.frame.size.height) {
        imageY = floorf((self.frame.size.height - imageScaleHeight) / 2.0);
    }
    self.imageView.frame = CGRectMake(imageX, imageY, imageScaleWidth, imageScaleHeight);
}

- (ProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[ProgressView alloc] init];
    }
    return _progressView;
}


@end
