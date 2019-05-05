//
//  NSString+DateFormatter.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "NSString+DateFormatter.h"

@implementation NSString (DateFormatter)

/*!
 * 根据时间戳格式化想要的时间
 *
 * @param timeString 时间戳字符串
 * @param format 格式化的格式
 */
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString withFormat:(NSString *)format
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    // 毫秒值转化为秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/1000.0];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
