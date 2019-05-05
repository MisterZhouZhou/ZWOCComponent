//
//  NSString+String.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (String)

/**
 * 字符串去除首位空格
 */
- (NSString *)stringByTrim;

/**
 * 计算字符串size
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 * 设置字符串指定范围的字体颜色
 * @param start 开始的字符
 * @param end 结束的字符
 * @param markColor 设置内容的颜色
 * @param fontSize 设置内容的字体
 * @param fontname 字体名称
 * @return mutable array
 */
- (NSMutableAttributedString*)setRangeColorWithstartString:(NSString *)start endString:(NSString *)end andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize fontName: (NSString *)fontname;

/**
 * 中文转拼音
 */
- (NSString *)transform:(NSString *)chinese;

/**
 * 是否为网络资源
 */
- (BOOL)isNetWorkSource;

/**
 * 时间戳转字符串时间格式
 */
- (NSString *) timeStringToDate;

/**
 * 时间戳转 YY-MM-DD HH:MM
 */
-(NSString*)timeStampToDateString;

/**
 * 时间转字符串 YY-MM-DD HH:MM
 */
-(NSString*)stringToDateString;

/**
 * 根据身份证识别性别
 */
- (NSInteger)genderOfIDNumber:(NSString *)IDNumber;

/**
 * 根据身份证识别出生年月
 */
-(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr;

/**
 * 本地时间转UTC
 */
+ (NSString *)getUTCFormateLocalDate:(NSString *)localDate;

/**
 * UTC转本地时间
 */
+ (NSString *)getLocalDateFormateUTC:(NSString *)UTCDate;

@end
