//
//  UINavigationController+Extension.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "UINavigationController+Extension.h"

@implementation UINavigationController (Extension)

/**
 * 返回上几级控制器
 * @param previousCount 上级页面数
 * @param controller 当前控制器
 */
- (void)popToPreviousController: (NSInteger) previousCount withCurrentController: (UIViewController *)controller {
    if(self.viewControllers.count <= previousCount){
        return;
    }
    NSInteger index = [[self viewControllers] indexOfObject:controller];
    [self popToViewController:[self.viewControllers objectAtIndex: index - previousCount] animated:YES];
}

@end
