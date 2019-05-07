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

/**
 *  @author zhengju, 16-06-29 10:06:05
 *
 *  @brief 检测字符串中是否含有中文，备注：中文代码范围0x4E00~0x9FA5，
 *
 *  @param string 传入检测到中文字符串
 *
 *  @return 是否含有中文，YES：有中文；NO：没有中文
 */
+ (BOOL)checkIsChinese:(NSString *)string;

@end
