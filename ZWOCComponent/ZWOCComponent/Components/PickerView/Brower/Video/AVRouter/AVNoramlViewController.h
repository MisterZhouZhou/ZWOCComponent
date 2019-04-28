//
//  ZFNoramlViewController.h
//  ZFPlayer
//
//  Created by 紫枫 on 2018/3/21.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVNoramlViewController : UIViewController
/**
 视频的首帧图
 * param BOOL
 */
@property (nonatomic, strong) UIImage *coverImage;

/**
 视频资源string
 * param videoSource
 */
@property (nonatomic, strong) id videoSource;

/**
 图片是否可删除
 * param BOOL
 */
@property (nonatomic, assign) BOOL isDelete;

/**
 选中图片的下标
 * param NSInteger
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 回调处理后的图片list
 @param photos [MultiPhotoModel]
 */
@property (nonatomic , copy) void (^callBackBlock)(id videoSource, NSInteger selectedIndex);

@end

