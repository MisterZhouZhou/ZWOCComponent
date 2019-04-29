//
//  MultiPhotoPreView.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/29.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "MultiPhotoPreView.h"
#import "PhotoZoomView.h"
#import "CommonDefine.h"

@interface MultiPhotoPreView()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentIndex;    // 当前下标
@end

@implementation MultiPhotoPreView

- (void)setCount:(NSInteger)count {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addSubview:self.scrollView];
    
    _count = count;
    CGFloat scrollViewW = CGRectGetWidth(self.scrollView.bounds);
    CGFloat scrollViewH = CGRectGetHeight(self.scrollView.bounds);
    for (int i=0; i<count; i++) {
        PhotoZoomView * photoZoomView = [[PhotoZoomView alloc] initWithFrame:CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH)];
        photoZoomView.image = [self.delegate keyWindowImage:i];
        kWeakSelf(self)
        photoZoomView.bgClick = ^(){
            [weakself hide];
        };
        [self.scrollView addSubview:photoZoomView];
    }
    self.scrollView.contentSize = CGSizeMake(count * scrollViewW , scrollViewH);
}

#pragma mark 显示全屏预览
- (void)showIndex:(NSInteger)index {
    self.frame = self.scrollView.frame;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.currentIndex = index;
    CGFloat scrollViewW = CGRectGetWidth(self.scrollView.bounds);
    CGFloat scrollViewH = CGRectGetHeight(self.scrollView.bounds);

    // 设置scrollView偏移
    [self.scrollView setContentOffset:CGPointMake(index * scrollViewW, 0)];
    // 动画展示大图
    CGRect frame  = [self.delegate keyWindowFrame:index];
    __block PhotoZoomView * photoZoomView = (PhotoZoomView*)self.scrollView.subviews[index];
    photoZoomView.imageView.frame = frame;
    self.layer.opacity = 0;
    kWeakSelf(self)
    [UIView animateWithDuration:0.5 animations:^{
        weakself.layer.opacity = 1;
        photoZoomView.imageView.frame = CGRectMake(0, (scrollViewH - scrollViewW)/2 , scrollViewW, scrollViewW);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark 隐藏全屏预览
- (void)hide {
    CGRect frame  = [self.delegate keyWindowFrame:self.currentIndex];
    __block PhotoZoomView * photoZoomView = (PhotoZoomView*)self.scrollView.subviews[self.currentIndex];
    kWeakSelf(self)
    [UIView animateWithDuration:0.5 animations:^{
        photoZoomView.imageView.frame = frame;
        weakself.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [weakself removeFromSuperview];
    }];
}

#pragma mark 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.currentIndex = round(scrollView.contentOffset.x / scrollView.frame.size.width);
}

#pragma mark 滚动完毕后就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger scrollIndex = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    if (scrollIndex != self.currentIndex) {
        //重置上一个缩放过的视图
        PhotoZoomView * zoomView  = (PhotoZoomView *)scrollView.subviews[self.currentIndex];
        [zoomView pictureZoomWithScale:1.0 touchPoint:CGPointZero];
        self.currentIndex = scrollIndex;
        PhotoZoomView *currentPhotoZoomView = (PhotoZoomView *)scrollView.subviews[self.currentIndex];
        // 重置缩放状态
        currentPhotoZoomView.doubleTap = NO;
    }
}

#pragma mark -- Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
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


@end
