//
//  NSString+String.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "NSString+String.h"

@implementation NSString (String)

#pragma mark - 设置字符串指定范围的字体颜色
- (NSMutableAttributedString*)setRangeColorWithstartString:(NSString *)start endString:(NSString *)end andMarkColor:(UIColor *)markColor andMarkFondSize:(float)fontSize fontName: (NSString *)fontname {
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange tempRange = NSMakeRange(0, 0);
    if ([self judgeStringIsNull:start]) {
        tempRange = [self rangeOfString:start];
    }
    NSRange tempRangeOne = NSMakeRange([strAtt length], 0);
    if ([self judgeStringIsNull:end]) {
        tempRangeOne =  [self rangeOfString:end];
    }
    // 更改字符颜色
    NSRange markRange = NSMakeRange(tempRange.location+tempRange.length, tempRangeOne.location-(tempRange.location+tempRange.length));
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
    [strAtt addAttribute:NSFontAttributeName value:[UIFont fontWithName: fontname ? fontname : @"HelveticaNeue" size:fontSize] range:markRange];
    return strAtt;
}


/**
 * 判断字符串是否不全为空
 */
- (BOOL)judgeStringIsNull:(NSString *)string {
    if ([[string class] isSubclassOfClass:[NSNumber class]]) {
        return YES;
    }
    BOOL result = NO;
    if (string != nil && string.length > 0) {
        for (int i = 0; i < string.length; i ++) {
            NSString *subStr = [string substringWithRange:NSMakeRange(i, 1)];
            if (![subStr isEqualToString:@" "] && ![subStr isEqualToString:@""]) {
                result = YES;
            }
        }
    }
    return result;
}


#pragma mark - 中文转拼音
- (NSString *)transform:(NSString *)chinese {
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin uppercaseString];
}

#pragma mark - 是否为网络资源
- (BOOL)isNetWorkSource {
    if([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"]){
        return YES;
    }
    return NO;
}

#pragma mark - 时间戳转时间
- (NSString *) timeStringToDate {
    // timeStampString 是服务器返回的13位时间戳
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[self doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

#pragma mark ======根据身份证识别性别=======
- (NSInteger)genderOfIDNumber:(NSString *)IDNumber
{
    //  记录校验结果：0未知，1男，2女
    NSInteger result = 0;
    NSString *fontNumer = nil;
    
    if (IDNumber.length == 15)
    { // 15位身份证号码：第15位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(14, 1)];
        
    }else if (IDNumber.length == 18)
    { // 18位身份证号码：第17位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(16, 1)];
    }else
    { //  不是15位也不是18位，则不是正常的身份证号码，直接返回
        return result;
    }
    
    NSInteger genderNumber = [fontNumer integerValue];
    
    if(genderNumber % 2 == 1)
        result = 1;
    
    else if (genderNumber % 2 == 0)
        result = 2;
    return result;
}

#pragma mark ======根据身份证识别出生年月=======
-(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr
{
    if (numberStr.length == 15) {
        // 加权因子
        int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
        // 校验码
        unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
        
        NSMutableString *mString = [NSMutableString stringWithString:self];
        if ([self length] == 15) {
            [mString insertString:@"19" atIndex:6];
            long p = 0;
            const char *pid = [mString UTF8String];
            for (int i=0; i<=16; i++) {
                p += (pid[i]-48) * R[i];
            }
            int o = p%11;
            NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
            [mString insertString:string_content atIndex:[mString length]];
        }
        numberStr = (NSString *)mString;
    }
    
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    BOOL isAllNumber = YES;
    NSString *day = nil;
    if([numberStr length]<14)
        return result;
    if (numberStr.length == 18) {
        //**截取前14位
        NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];
        //**检测前14位否全都是数字;
        const char *str = [fontNumer UTF8String];
        const char *p = str;
        while (*p!='\0') {
            if(!(*p>='0'&&*p<='9'))
                isAllNumber = NO;
            p++;
        }
        if(!isAllNumber)
            return result;
        year = [numberStr substringWithRange:NSMakeRange(6, 4)];
        month = [numberStr substringWithRange:NSMakeRange(10, 2)];
        day = [numberStr substringWithRange:NSMakeRange(12,2)];
        [result appendString:year];
        [result appendString:@"-"];
        [result appendString:month];
        [result appendString:@"-"];
        [result appendString:day];
        return result;
    }
    return nil;
    
    //    else{
    //        NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 11)];//**检测前14位否全都是数字;
    //        const char *str = [fontNumer UTF8String];
    //        const char *p = str;
    //        while (*p!='\0') {
    //            if(!(*p>='0'&&*p<='9'))
    //                isAllNumber = NO;
    //            p++;
    //
    //        }
    //        if(!isAllNumber)
    //            return result;
    //        year = [numberStr substringWithRange:NSMakeRange(6, 2)];
    //        month = [numberStr substringWithRange:NSMakeRange(8, 2)];
    //        day = [numberStr substringWithRange:NSMakeRange(10,2)];
    //        [result appendString:year];
    //        [result appendString:@"-"];
    //        [result appendString:month];
    //        [result appendString:@"-"];
    //        [result appendString:day];
    //        NSString* resultAll = result;
    //        return resultAll;
    //    }
}

#pragma mark - 时间戳转 YY-MM-DD HH:MM
-(NSString*)timeStampToDateString {
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[self doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

#pragma mark - UTC时间转字符串 YY-MM-DD HH:MM
-(NSString*)stringToDateString {
    struct tm tm;
    time_t t;
    strptime([self cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%dT%H:%M:%S%z", &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t + [[NSTimeZone localTimeZone] secondsFromGMT]];//东八区
    // 日期格式化类
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    // 设置日期格式 为了转换成功
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    // new date
    NSString *newString = [format stringFromDate:date];
    return newString;
}

//将本地日期字符串转为UTC日期字符串
//本地日期格式:2013-08-03 12:53:51
//可自行指定输入输出格式
+ (NSString *)getUTCFormateLocalDate:(NSString *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

//将本地日期字符串转为UTC日期字符串
//可自行指定输入输出格式
+ (NSString *)getLocalDateFormateUTC:(NSString *)UTCDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *dateFormatted = [dateFormatter dateFromString:UTCDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

@end
