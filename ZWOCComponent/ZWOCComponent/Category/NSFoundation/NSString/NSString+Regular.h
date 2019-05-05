//
//  NSString+Regular.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regular)

/*!
 * 邮箱判断
 *
 * @param email 邮箱地址
 */
+ (BOOL)validateEmail:(NSString *)email;


/*!
 * 手机号码验证
 *
 * @param mobile 手机号码
 */
+ (BOOL)validateMobile:(NSString *)mobile;

/*!
 * 联系方式验证
 *
 * @param contact 联系方式
 */
+ (BOOL)validateContact:(NSString *)contact;

/*!
 * 车牌号验证
 *
 * @param carNo 车牌号码
 */
+ (BOOL)validateCarNo:(NSString *)carNo;


/*!
 * 正则匹配17位车架号
 *
 * @param vinNumber 车架号
 */
+ (BOOL)validateVinNumber:(NSString *)vinNumber;


/*!
 * 车型验证
 *
 * @param CarType 车型名称
 */
+ (BOOL)validateCarType:(NSString *)CarType;


/*!
 * 用户名验证
 *
 * @param name 用户名
 */
+ (BOOL)validateUserName:(NSString *)name;


/*!
 * 密码验证
 *
 * @param passWord 密码
 */
+ (BOOL)validatePassword:(NSString *)passWord;


/*!
 * 昵称验证
 *
 * @param nickname 昵称
 */
+ (BOOL)validateNickname:(NSString *)nickname;


/*!
 * 身份证号验证
 *
 * @param identityCard 身份证
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

/*!
 * 港澳台身份证验证
 *
 * @param passIdentityCard 港澳台身份证
 */
+ (BOOL)validatePassIdentityCard:(NSString *)passIdentityCard;

/*!
 * 银行卡号验证
 *
 * @param bankCard 银行卡号
 */
+ (BOOL)validateBankCard:(NSString *)bankCard;

/*!
 * 银行卡号验证(长度)
 *
 * @param bankCard 银行卡号
 */
+ (BOOL)validateBankCardLength:(NSString *)bankCard;

/*!
 * 金额的正则验证
 *
 * @param money 金额值
 */
+ (BOOL)validateMoney:(NSString *)money;

/*!
 * 数字+字母的验证
 *
 * @param content 内容
 */
+ (BOOL)validateNumberAndChar:(NSString *)content;

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
+ (BOOL)validateNumberAndCharAndChinese:(NSString *)content;

/**
 * 字母、数字、中文、英文.正则判断（不包括空格）
 */
+ (BOOL)validateNumberAndCharAndChineseAndPoint:(NSString *)content;

/**
 * 数字
 */
+ (BOOL)validateNumber:(NSString *)content;

//有效的电话号码
- (BOOL) isValidMobileNumber;

//有效的真实姓名
- (BOOL) isValidRealName;

//是否只有中文
- (BOOL) isOnlyChinese;

//有效的验证码(根据自家的验证码位数进行修改)
- (BOOL) isValidVerifyCode;

//有效的银行卡号
- (BOOL) isValidBankCardNumber;

//有效的邮箱
- (BOOL) isValidEmail;

//有效的字母数字密码
- (BOOL) isValidAlphaNumberPassword;

//检测有效身份证
//15位
- (BOOL) isValidIdentifyFifteen;

//18位
- (BOOL) isValidIdentifyEighteen;

//限制只能输入数字
- (BOOL) isOnlyNumber;


@end
