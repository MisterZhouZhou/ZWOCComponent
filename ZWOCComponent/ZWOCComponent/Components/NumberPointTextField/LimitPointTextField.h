//
//  LimitPointTextField.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/29.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LimitPointTextField : UIView

@property (nonatomic, assign) BOOL isEditing;    // 是否可以进行编辑
@property (nonatomic, assign) int limitNumInt;   // 限制字符数(整数位)
@property (nonatomic, assign) int limitNumPoint; // 限制字符数(小数位)
@property (nonatomic, copy) NSString *placeholder;// 默认提示文本


@end
