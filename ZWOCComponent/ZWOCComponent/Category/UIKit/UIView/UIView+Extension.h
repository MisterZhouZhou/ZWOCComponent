//
//  UIView+Extension.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

- (void)addClickedBlock:(void(^)(id obj))tapAction;

/**
 * 设置圆角
 */
- (void)rounded:(CGFloat)cornerRadius;

/**
 * 设置圆角和边框
 */
- (void)rounded:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**
 * 设置边框
 */
- (void)border:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**
 * 给哪几个角设置圆角
 */
-(void)round:(CGFloat)cornerRadius RectCorners:(UIRectCorner)rectCorner;

/**
 * 设置阴影
 */
-(void)shadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset;

/**
 * 获取当前view的控制器
 */
- (UIViewController *)viewController;

@end
