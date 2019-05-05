//
//  NSString+Regular.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)

/*!
 * 邮箱判断
 *
 * @param email 邮箱地址
 */
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


/*!
 * 手机号码验证
 *
 * @param mobile 手机号码
 */
+ (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1(\\d{10}$)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/*!
 * 联系方式验证
 *
 * @param contact 联系方式
 */
+ (BOOL)validateContact:(NSString *)contact
{
    //010-222222
    NSString *phoneRegex = @"^[0-9\\-]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:contact];
}


/*!
 * 车牌号验证
 *
 * @param carNo 车牌号码
 */
+ (BOOL)validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

/*!
 * 正则匹配17位车架号
 *
 * @param vinNumber 车架号
 */
+ (BOOL)validateVinNumber:(NSString *)vinNumber
{
    NSString *bankNum=@"^[A-Za-z0-9]{17}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:vinNumber];
    return isMatch;
}

/*!
 * 车型验证
 *
 * @param CarType 车型名称
 */
+ (BOOL)validateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}


/*!
 * 用户名验证
 *
 * @param name 用户名
 */
+ (BOOL)validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}


/*!
 * 密码验证
 *
 * @param passWord 密码
 */
+ (BOOL)validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


/*!
 * 昵称验证
 *
 * @param nickname 昵称
 */
+ (BOOL)validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}


/*!
 * 身份证号验证
 *
 * @param identityCard 身份证
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{2}[0-9Xx]$";
    //    NSString *regex2 = @"^[A-Za-z0-9]+$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [identityCardPredicate evaluateWithObject:identityCard];
    if (!isMatch) {
        
        regex2 = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$";
        identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        isMatch = [identityCardPredicate evaluateWithObject:identityCard];
    }
    return isMatch;
}

/*!
 * 港澳台身份证验证
 *
 * @param passIdentityCard 港澳台身份证
 */
+ (BOOL)validatePassIdentityCard:(NSString *)passIdentityCard
{
    //香港身份证正则表达式
    NSString *gPassWordRegex = @"[A-Z]{1,2}[0-9]{6}([0-9A])";
    NSPredicate *gPassWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",gPassWordRegex];
    BOOL isGMatch = [gPassWordPredicate evaluateWithObject:passIdentityCard];
    //澳门身份证正则表达式
    NSString *aPassWordRegex = @"^[1|5|7][0-9]{6}([0-9Aa])";
    NSPredicate *aPassWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",aPassWordRegex];
    BOOL isAMatch = [aPassWordPredicate evaluateWithObject:passIdentityCard];
    //台湾身份证正则表达式
    NSString *tPassWordRegex = @"[A-Z][0-9]{9}";
    NSPredicate *tPassWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",tPassWordRegex];
    BOOL isTMatch = [tPassWordPredicate evaluateWithObject:passIdentityCard];
    
    if (isGMatch == YES || isAMatch == YES || isTMatch == YES) {
        return YES;
    }
    
    return NO;
}

/*!
 * 银行卡号验证
 *
 * @param bankCard 银行卡号
 */
+ (BOOL)validateBankCard:(NSString *)bankCard
{
    BOOL flag;
    if (bankCard.length <= 0) {
        flag = NO;
        return flag;
    }
    
    //    NSString *regex2 = @"^([1-9]{1})(\\d{14}|\\d{18})$";
    NSString *regex2 = @"^[0-9]+$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [identityCardPredicate evaluateWithObject:bankCard];
    
    return isMatch;
}

/*!
 * 银行卡号验证(长度)
 *
 * @param bankCard 银行卡号
 */
+ (BOOL)validateBankCardLength:(NSString *)bankCard
{
    BOOL flag;
    if (bankCard.length <= 0) {
        flag = NO;
        return flag;
    }
    
    //    NSString *regex2 = @"^([1-9]{1})(\\d{14}|\\d{18})$";
    NSString *regex2 = @"^[0-9]+$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [identityCardPredicate evaluateWithObject:bankCard];
    
    if (bankCard.length > 35 || bankCard.length < 8) {
        isMatch = NO;
    }
    
    return isMatch;
}

/*!
 * 金额的正则验证
 *
 * @param money 金额值
 */
+ (BOOL)validateMoney:(NSString *)money
{
    BOOL flag;
    if (money.length <= 0) {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^([1-9]([0-9]+)?(\\.[0-9]{1,2})?$)|(^(0){1}$)|(^[0-9]\\.[0-9]([0-9])?$)";
    NSPredicate *moneyPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL isMatch = [moneyPredicate evaluateWithObject:money];
    
    return isMatch;
}


/*!
 * 数字+字母的验证
 *
 * @param content 内容
 */
+ (BOOL)validateNumberAndChar:(NSString *)content
{
    NSString *passWordRegex = @"^[A-Za-z0-9]+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:content];
}

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
+ (BOOL)validateNumberAndCharAndChinese:(NSString *)content
{
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:content];
    return isMatch;
}

/**
 * 字母、数字、中文、英文、· 正则判断（不包括空格）
 */
+ (BOOL)validateNumberAndCharAndChineseAndPoint:(NSString *)content
{
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5·\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:content];
    return isMatch;
}

/**
 * 数字
 */
+ (BOOL)validateNumber:(NSString *)content
{
    if (content.length == 0) return NO;
    
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:content];
    return isMatch;
}

- (BOOL) isValidMobileNumber {
    NSString* const MOBILE = @"^1(3|4|5|7|8)\\d{9}$";
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [predicate evaluateWithObject:self];
}

- (BOOL) isValidVerifyCode
{
    NSString *pattern = @"^[0-9]{4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:self];
}

- (BOOL) isValidRealName

{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{2,8}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL) isOnlyChinese
{
    NSString * chineseTest=@"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate*chinesePredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",chineseTest];
    return [chinesePredicate evaluateWithObject:self];
}


- (BOOL) isValidBankCardNumber {
    NSString* const BANKCARD = @"^(\\d{16}|\\d{19})$";
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", BANKCARD];
    return [predicate evaluateWithObject:self];
}


- (BOOL) isValidEmail
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
    
}
- (BOOL) validateNickName
{
    NSString *userNameRegex = @"^[A-Za-z0-9\u4e00-\u9fa5]{1,24}+$";
    
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    
    return [userNamePredicate evaluateWithObject:self];
}
- (BOOL) isValidAlphaNumberPassword
{
    NSString *regex = @"^(?!\\d+$|[a-zA-Z]+$)\\w{6,12}$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [identityCardPredicate evaluateWithObject:self];
}


- (BOOL) isValidIdentifyFifteen
{
    NSString * identifyTest=@"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
    NSPredicate*identifyPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",identifyTest];
    return [identifyPredicate evaluateWithObject:self];
}

- (BOOL) isValidIdentifyEighteen
{
    NSString * identifyTest=@"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    NSPredicate*identifyPredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",identifyTest];
    return [identifyPredicate evaluateWithObject:self];
}


- (BOOL) isOnlyNumber
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < self.length) {
        NSString * string = [self substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    
    return res;
}

@end
