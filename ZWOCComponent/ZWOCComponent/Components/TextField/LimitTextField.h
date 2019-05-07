//
//  LimitTextField.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/7.
//  Copyright © 2019年 zhouwei. All rights reserved.
//  限制输入位数及小数点的位数

#import <UIKit/UIKit.h>

@interface LimitTextField : UIView

@property (nonatomic, assign) NSUInteger limitCount;         // 限制显示的位数
@property (nonatomic, assign) NSTextAlignment textAlignment; // 对齐方式
@property (nonatomic, assign) UIKeyboardType keyBoardType;   // 键盘类型

@end
