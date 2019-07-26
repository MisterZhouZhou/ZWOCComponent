//
//  LimitTextField.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/7.
//  Copyright © 2019年 zhouwei. All rights reserved.
//  数值行输入，限制输入位数及小数点的位数

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LimitTextFieldType){
    LimitTextFieldType_Text   = 0,   // 文本(不限制，什么都能输入)
    LimitTextFieldType_Number = 1,   // 纯数字(可以输入小数)
    LimitTextFieldType_IdCard = 2,   // 纯数字+字母(可以输入数字和字母)
};

@interface LimitTextField : UIView

@property (nonatomic, assign) LimitTextFieldType textFieldType; // 文本框输入类型
@property (nonatomic, assign) NSUInteger numberCount;            // 限制显示的位数
@property (nonatomic, assign) NSUInteger pointCount;             // 小数点后位数  默认2位小数
@property (nonatomic, assign) NSTextAlignment textAlignment;     // 对齐方式
@property (nonatomic, strong) NSString *placeholder;             // 提示文字  默认请输入

@end
