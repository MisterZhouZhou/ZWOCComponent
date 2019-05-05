//
//  NSDictionary+Extension.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

/**
 *  字段转成json的字符串
 *  @return json 字符串
 */
- (NSString *)TransToJSONString;

@end
