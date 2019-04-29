//
//  NSDate+Date.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/29.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Date)

#pragma mark date 转 YMD string
+ (NSString *)stringWithDate:(NSDate *)currentDate;

#pragma mark string 转 YMD date
+ (NSDate *)dateWithString:(NSString *)currentDateString;

@end
