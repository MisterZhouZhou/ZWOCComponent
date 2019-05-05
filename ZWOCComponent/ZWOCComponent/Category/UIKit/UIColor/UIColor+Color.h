//
//  UIColor+Color.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Color)

/**
 * 十六进制颜色转UIColor
 * @param hexStr 十六进制字符串
 * @return color UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexStr;

/**
 * 十六进制颜色转UIColor
 * @param hexValue 十六进制数字
 * @param alpha 透明度
 * @return color UIColor
 */
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;

@end
