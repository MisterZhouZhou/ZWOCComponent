//
//  LimitCountTextField.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/29.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LimitCountTextField : UIView

@property (nonatomic, assign) BOOL isEditing;    // 是否可以进行编辑
@property (nonatomic, assign) int limitCount;    // 限制字符数
@property (nonatomic, copy) NSString *placeholder;// 默认提示文本
@property(nonatomic, assign)UIKeyboardType keyboardType;  //键盘类型

@end
