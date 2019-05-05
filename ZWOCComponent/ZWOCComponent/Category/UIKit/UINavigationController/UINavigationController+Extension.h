//
//  UINavigationController+Extension.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extension)

/**
 * 返回上几级控制器
 * @param previousCount 上级页面数
 * @param controller 当前控制器
 */
- (void)popToPreviousController: (NSInteger)previousCount withCurrentController: (UIViewController *)controller;

@end
