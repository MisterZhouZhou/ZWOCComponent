//
//  PhotoZoomView.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/26.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoZoomView : UIScrollView

@property (nonatomic, copy) NSString *imageUrl;
// 缩放方法，共外界调用
- (void)pictureZoomWithScale:(CGFloat)zoomScale;

@end
