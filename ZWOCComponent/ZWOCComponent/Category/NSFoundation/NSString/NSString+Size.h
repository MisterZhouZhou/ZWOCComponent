//
//  NSString+Size.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Size)

/**
 * 计算字符串size
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 计算文字高度
 
 @param fontSize 字体
 @param width 最大宽度
 @return return value description
 */
- (CGFloat)heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width;

/**
 计算文字宽度
 @param fontSize 字体
 @param maxHeight 最大高度
 @return return value description
 */
- (CGFloat)widthWithFontSize:(CGFloat)fontSize height:(CGFloat)maxHeight;
@end
