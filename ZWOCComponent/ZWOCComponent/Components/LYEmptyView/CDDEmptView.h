//
//  CDDEmptView.h
//  LYEmptyViewDemo
//
//  Created by zhouwei on 2018/11/1.
//  Copyright © 2018年 徐春雨. All rights reserved.
//

#import "LYEmptyView.h"
#import "UIView+Empty.h"

@interface CDDEmptView : LYEmptyView

+ (instancetype)diyNoDataEmpty;

/**
 icon,detail描述提示
 @param imgStr 图片名称
 @param detail 图片名称
 @return 返回一个emptyView
 */
+ (instancetype)noDataEmptyWithImageString:(NSString *)imgStr detailStr: (NSString *)detail;

/**
 自定义icon，title,button提示
 @param imgStr 图片名称
 @param detail 图片名称
 @return 返回一个emptyView
 */
+ (instancetype)noDataEmptyWithButtonImageString:(NSString *)imgStr detailStr: (NSString *)detail buttonImg:(NSString *)buttonImgStr buttonStr: (NSString *)btnStr buttonBlock:(void(^)(void))blockClick;

+ (instancetype)diyNoNetworkEmptyWithTarget:(id)target action:(SEL)action;

+ (instancetype)diyCustomEmptyViewWithTarget:(id)target action:(SEL)action;

@end
