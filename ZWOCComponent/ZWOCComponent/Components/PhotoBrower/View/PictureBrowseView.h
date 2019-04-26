//
//  PictureBrowseView.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/26.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoZoomView.h"

@interface PictureBrowseView : UIView

//图片URL
@property (nonatomic, strong)NSArray * urlsArray; // 图片的链接
@property (nonatomic , assign) NSInteger index;   // 当前图片的下标
@property (nonatomic , strong) PhotoZoomView * currentPhotoZoomView; // 当前可缩放的视图
@property (nonatomic, weak) id viewController;

@end
