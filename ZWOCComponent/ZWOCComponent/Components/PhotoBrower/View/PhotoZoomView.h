//
//  PhotoZoomView.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/26.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PhotoZoomView : UIScrollView

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PHAsset *assetImage;
@property (nonatomic, assign) BOOL doubleTap;      // 是否为双击
@property (nonatomic, copy) dispatch_block_t bgClick; // 点击背景回调
@property (nonatomic, strong) UIImageView * imageView;    // 图片

/**
 * 缩放方法，共外界调用
 */
- (void)pictureZoomWithScale:(CGFloat)zoomScale touchPoint:(CGPoint)point;

@end
