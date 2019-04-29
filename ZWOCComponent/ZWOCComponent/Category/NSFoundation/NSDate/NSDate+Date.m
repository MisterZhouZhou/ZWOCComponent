//
//  NSDate+Date.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/29.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "NSDate+Date.h"

@implementation NSDate (Date)

#pragma mark date 转 YMD string
+ (NSString *)stringWithDate:(NSDate *)currentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    if (!currentDateString) {
        currentDateString = @"";
    }
    return currentDateString;
}

#pragma mark string 转 YMD date
+ (NSDate *)dateWithString:(NSString *)currentDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSDate *currentDate = [dateFormatter dateFromString:currentDateString];
    return currentDate;
}

@end
