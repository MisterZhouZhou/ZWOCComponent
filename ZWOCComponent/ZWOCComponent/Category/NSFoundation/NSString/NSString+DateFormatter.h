//
//  NSString+DateFormatter.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DateFormatter)

/*!
 * 根据时间戳格式化想要的时间
 *
 * @param timeString 时间戳字符串
 * @param format 格式化的格式
 */
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString withFormat:(NSString *)format;

@end
