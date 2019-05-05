//
//  SYIdCardModel.h
//  CDDCarSecondLoan
//
//  Created by zhouwei on 2018/12/13.
//  Copyright © 2018年 徐春雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYIdCardFontModel : NSObject

@property (nonatomic, copy) NSString *name;       // 姓名
@property (nonatomic, copy) NSString *birthday;   // 出生日期
@property (nonatomic, copy) NSString *idNumber;   // 公民身份证号码
@property (nonatomic, copy) NSString *sex;        // 性别
@property (nonatomic, copy) NSString *address;    // 住址
@property (nonatomic, copy) NSString *nation;     // 民族

@end


@interface SYIdCardBackModel : NSObject

@property (nonatomic, copy) NSString *invalidDate;       // 失效日期
@property (nonatomic, copy) NSString *issueDate;         // 签发日期
@property (nonatomic, copy) NSString *issueDepartment;   // 签发部门

@end

//行驶证信息
@interface SYDrivingLicenseInfoBackModel : NSObject

@property (nonatomic, copy) NSString *engineNumber;               // 发动机号
@property (nonatomic, copy) NSString *plateNumber;                // 号牌号码
@property (nonatomic, copy) NSString *owner;                      // 所有人
@property (nonatomic, copy) NSString *usingNature;                // 使用性质
@property (nonatomic, copy) NSString *address;                    // 住址
@property (nonatomic, copy) NSString *registrationDate;           // 注册日期
@property (nonatomic, copy) NSString *vehicleIdentificationCode;  // 车辆识别代号
@property (nonatomic, copy) NSString *brandModels;                // 品牌型号
@property (nonatomic, copy) NSString *vehicleType;                // 车辆类型
@property (nonatomic, copy) NSString *releaseDate;                // 发证日期

@end
