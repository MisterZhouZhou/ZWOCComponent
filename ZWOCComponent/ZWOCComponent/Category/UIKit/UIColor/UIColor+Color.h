//
//  UIColor+Color.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Color)

+ (UIColor *)colorWithHexString:(NSString *)hexStr;
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;


@end
