//
//  PictureBrowseView.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/26.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "PictureBrowseView.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.3f)

@interface PictureBrowseView()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UILabel * indexLabel;

@end

@implementation PictureBrowseView

- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
//        [self addGestureRecognizer];
        [self addSubview:self.scrollView];
        [self addSubview:self.indexLabel];
    }
    return self;
}

#pragma mark 添加手势
- (void)addGestureRecognizer {
    self.userInteractionEnabled = YES;
    // 长按手势
//    UILongPressGestureRecognizer * longGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGR:)];
//    [self addGestureRecognizer:longGR];
}

#pragma mark -- Event Handle
- (void)longGR:(UILongPressGestureRecognizer *)longGr {
    if (!self.viewController) {
        return;
    }
    NSString *imageUrl = self.urlsArray[self.index];
    NSData *currentImageData;
    if ([imageUrl hasPrefix:@"http://"] || [imageUrl hasPrefix:@"https://"]) { // 网络图
        currentImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    }else{
        currentImageData = [NSData dataWithContentsOfFile:imageUrl];
    }
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * saveAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:currentImageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            NSString * message;
            if ([assetURL path].length > 0) {
                message = @"保存成功";
            }else{
                message = @"保存失败";
            }
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[self contentTypeForImageData:currentImageData] message:message preferredStyle:UIAlertControllerStyleAlert];
            [self.viewController presentViewController:alertController animated:YES completion:nil];
            [UIView animateWithDuration:2.0 animations:^(){} completion:^(BOOL finished) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
        }] ;
        
        
    }];
    [alertController addAction:saveAction];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancleAction];
    if(iOS8Later){
        [saveAction setValue:[UIColor grayColor] forKey:@"titleTextColor"];
        [cancleAction setValue:[UIColor grayColor] forKey:@"titleTextColor"];
    }
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark -- Help Methods
- (void)setupImageView:(NSArray *)array {
    self.count = array.count;
    for (PhotoZoomView *photoZoom in self.scrollView.subviews) {
        [photoZoom removeFromSuperview];
    }
    self.indexLabel.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)array.count];
    self.scrollView.contentSize = CGSizeMake(array.count * self.frame.size.width, self.frame.size.height);
    
    for (int i = 0; i < array.count ; i++) {
        PhotoZoomView * photoZoomView = [[PhotoZoomView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        photoZoomView.imageUrl = array[i];
        photoZoomView.backgroundColor =[UIColor blackColor];
        [self.scrollView addSubview:photoZoomView];
        [self addSubview:self.indexLabel];
    }
    self.currentPhotoZoomView = (PhotoZoomView *)(self.scrollView.subviews.firstObject);
}


#pragma mark 返回图片格式
- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg格式";
        case 0x89:
            return @"png格式";
        case 0x47:
            return @"gif格式";
        case 0x49:
        case 0x4D:
            return @"tiff格式";
        case 0x52:
        default:
            break;
    }
    if ([data length] < 12) {
        return @"";
    }
    return @"";
}

#pragma mark -- Setter
-(void)setUrlsArray:(NSArray *)urlsArray {
    _urlsArray = urlsArray;
    [self setupImageView:urlsArray];
}

#pragma mark -- Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor blackColor];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 25, 30, 40, 40)];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _indexLabel;
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    self.index = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    //    NSLog(@"滑动至第 %d",self.index);
}

//滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

#pragma mark 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.index = round(scrollView.contentOffset.x / scrollView.frame.size.width);
}

#pragma mark 滚动完毕后就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger scrollIndex = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    if (scrollIndex != self.index) {
        //重置上一个缩放过的视图
        PhotoZoomView * zoomView  = (PhotoZoomView *)scrollView.subviews[self.index];
        [zoomView pictureZoomWithScale:1.0 touchPoint:CGPointZero];
        self.index = scrollIndex;
        self.currentPhotoZoomView = (PhotoZoomView *)scrollView.subviews[self.index];
        // 重置缩放状态
        self.currentPhotoZoomView.doubleTap = NO;
    }
    self.indexLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.index + 1,self.count];
}

@end
