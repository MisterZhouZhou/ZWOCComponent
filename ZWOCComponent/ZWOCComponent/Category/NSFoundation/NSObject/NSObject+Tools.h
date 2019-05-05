//
//  NSObject+Tools.h
//  CDDCarSecondLoan
//
//  Created by zhouwei on 2018/10/18.
//  Copyright © 2018年 徐春雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Tools)

#pragma mark - 字典转json字符串方法
+(NSString *)convertToJsonData:(NSDictionary *)dict;

#pragma mark - JSON字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
