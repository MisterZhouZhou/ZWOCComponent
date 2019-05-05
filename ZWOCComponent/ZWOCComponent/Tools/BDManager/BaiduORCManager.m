//
//  BaiduORCManager.m
//  CDDCarSecondLoan
//
//  Created by zhouwei on 2018/12/13.
//  Copyright © 2018年 徐春雨. All rights reserved.
//

#import "BaiduORCManager.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import "CommonDefine.h"

@implementation BaiduORCManager

//单例模式，获取BaiduORCManager
+ (BaiduORCManager *)sharedManager {
    static BaiduORCManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 * 注册百度ocr
 * @param akey 百度ocr ak
 * @param skey 百度ocr sk
 */
-(void)initBaiDuOCRWithAK:(NSString *)akey andSK:(NSString *)skey {
    [[AipOcrService shardService] authWithAK:akey andSK:skey];
}

/**
 * 身份证正面识别
 * @param image 需要识别的图片
 * @param cardtype 识别类型
 * @param successHandler 成功回调
 * @param failHandler 失败回调
 */
- (void)detectedCardInfoFromImage:(UIImage *)image cardType:(SYCardType)cardtype
                    successHandler:(void (^)(id result))successHandler
                       failHandler:(void (^)(NSString *errMsg))failHandler {
    switch (cardtype) {
        case SYCardTypeIdCardFont:   // 身份证正面
            [self cardTypeIdCardFontFromImage:image successHandler:successHandler failHandler:failHandler];
            break;
        case SYCardTypeIdCardBack:       // 身份证反面
            [self cardTypeIdCardBackFromImage:image successHandler:successHandler failHandler:failHandler];
            break;
        case SYCardTypeBankCard:        // 银行卡
            [self cardTypeBankCardFromImage:image successHandler:successHandler failHandler:failHandler];
            break;
        case SYCardTypeDrivingLicense:  // 驾驶证
            [self cardTypeDrivingLicenseFromImage:image successHandler:successHandler failHandler:failHandler];
            break;
        case SYCardTypeVehicleLicense:  // 行驶证
            [self cardTypeVehicleLicenseFromImage:image successHandler:successHandler failHandler:failHandler];
            break;
        case SYCardTypePlateNumber:     // 车牌证
            [self cardTypePlateNumberFromImage:image successHandler:successHandler failHandler:failHandler];
            break;
        case SYCardTypeBusinessLicense: // 营业执照
            [self cardTypeBusinessLicenseFromImage:image successHandler:successHandler failHandler:failHandler];
            break;
        case SYCardTypeReceipt:         // 票据
            [self cardTypeReceiptFromImage:image successHandler:successHandler failHandler:failHandler];
            break;
        case SYCardTypeTextBasic:       // 通用文字识别
            [self cardTypeTextBasicFromImage:image successHandler:successHandler failHandler:failHandler];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark 身份证正面
- (void)cardTypeIdCardFontFromImage:(UIImage *)image
                          successHandler:(void (^)(id result))successHandler
                          failHandler:(void (^)(NSString *errMsg))failHandler {
    [[AipOcrService shardService] detectIdCardFrontFromImage:image withOptions:nil successHandler:^(id result) {
        if(result[@"words_result"] && ValidDict(result[@"words_result"])){
            if(successHandler){
                NSDictionary *resultDict = result[@"words_result"];
                __block SYIdCardFontModel *model = [SYIdCardFontModel new];
                [resultDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if([key isEqualToString:@"姓名"]){
                        model.name = [obj valueForKey:@"words"];
                    }else if([key isEqualToString:@"出生"]){
                        model.birthday = [obj valueForKey:@"words"];
                    }else if([key isEqualToString:@"公民身份号码"]){
                        model.idNumber = [obj valueForKey:@"words"];
                    }else if([key isEqualToString:@"性别"]){
                        model.sex = [obj valueForKey:@"words"];
                    }else if([key isEqualToString:@"住址"]){
                        model.address = [obj valueForKey:@"words"];
                    }else if([key isEqualToString:@"民族"]){
                        model.nation = [obj valueForKey:@"words"];
                    }
                }];
                successHandler(model);
            }
        }
        
    } failHandler:^(NSError *err) {
        if(failHandler){
            NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], [err localizedDescription]];
            failHandler(msg);
        }
    }];
}


#pragma mark 身份证反面
- (void)cardTypeIdCardBackFromImage:(UIImage *)image
                       successHandler:(void (^)(id result))successHandler
                          failHandler:(void (^)(NSString *errMsg))failHandler {
    [[AipOcrService shardService] detectIdCardBackFromImage:image withOptions:nil successHandler:^(id result) {
        if(result[@"words_result"] && ValidDict(result[@"words_result"])){
            if(successHandler){
                NSDictionary *resultDict = result[@"words_result"];
                __block SYIdCardBackModel *model = [SYIdCardBackModel new];
                [resultDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if([key isEqualToString:@"失效日期"]){
                        model.invalidDate = [obj valueForKey:@"words"];
                    }else if([key isEqualToString:@"签发日期"]){
                        model.issueDate = [obj valueForKey:@"words"];
                    }else if([key isEqualToString:@"签发机关"]){
                        model.issueDepartment = [obj valueForKey:@"words"];
                    }
                }];
                successHandler(model);
            }
        }
        
    } failHandler:^(NSError *err) {
        if(failHandler){
            NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], [err localizedDescription]];
            failHandler(msg);
        }
    }];
}


#pragma mark 银行卡
- (void)cardTypeBankCardFromImage:(UIImage *)image
                     successHandler:(void (^)(id result))successHandler
                        failHandler:(void (^)(NSString *errMsg))failHandler {
    [[AipOcrService shardService] detectBankCardFromImage:image successHandler:^(id result) {
        if(successHandler){
            successHandler(result);
        }
    } failHandler:^(NSError *err) {
        if(failHandler){
            NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], [err localizedDescription]];
            failHandler(msg);
        }
    }];
}


#pragma mark 驾驶证
- (void)cardTypeDrivingLicenseFromImage:(UIImage *)image
                     successHandler:(void (^)(id result))successHandler
                        failHandler:(void (^)(NSString *errMsg))failHandler {
    [[AipOcrService shardService] detectDrivingLicenseFromImage:image withOptions:nil successHandler:^(id result) {
        if(successHandler){
            successHandler(result);
        }
    } failHandler:^(NSError *err) {
        if(failHandler){
            NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], [err localizedDescription]];
            failHandler(msg);
        }
    }];
}

#pragma mark 行驶证
- (void)cardTypeVehicleLicenseFromImage:(UIImage *)image
                           successHandler:(void (^)(id result))successHandler
                              failHandler:(void (^)(NSString *errMsg))failHandler {
    [[AipOcrService shardService] detectVehicleLicenseFromImage:image withOptions:nil successHandler:^(id result) {
        if(successHandler){
            
            NSDictionary *resultDict = result[@"words_result"];
            __block SYDrivingLicenseInfoBackModel *model = [SYDrivingLicenseInfoBackModel new];
            [resultDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if([key isEqualToString:@"发动机号码"]){
                    model.engineNumber = [obj valueForKey:@"words"];
                }else if([key isEqualToString:@"号牌号码"]){
                    model.plateNumber = [obj valueForKey:@"words"];
                }else if([key isEqualToString:@"所有人"]){
                    model.owner = [obj valueForKey:@"words"];
                }else if([key isEqualToString:@"使用性质"]){
                    model.usingNature = [obj valueForKey:@"words"];
                }else if([key isEqualToString:@"住址"]){
                    model.address = [obj valueForKey:@"words"];
                }else if([key isEqualToString:@"注册日期"]){
                    model.registrationDate = [obj valueForKey:@"words"];
                }else if([key isEqualToString:@"车辆识别代号"]){
                    model.vehicleIdentificationCode = [obj valueForKey:@"words"];
                }else if([key isEqualToString:@"品牌型号"]){
                    model.brandModels = [obj valueForKey:@"words"];
                }else if([key isEqualToString:@"车辆类型"]){
                    model.vehicleType = [obj valueForKey:@"words"];
                }else if([key isEqualToString:@"发证日期"]){
                    model.releaseDate = [obj valueForKey:@"words"];
                }
            }];
            successHandler(model);
        }
    } failHandler:^(NSError *err) {
        if(failHandler){
            NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], [err localizedDescription]];
            failHandler(msg);
        }
    }];
}

#pragma mark 车牌证
- (void)cardTypePlateNumberFromImage:(UIImage *)image
                        successHandler:(void (^)(id result))successHandler
                           failHandler:(void (^)(NSString *errMsg))failHandler {
    [[AipOcrService shardService] detectPlateNumberFromImage:image withOptions:nil successHandler:^(id result) {
        if(successHandler){
            successHandler(result);
        }
    } failHandler:^(NSError *err) {
        if(failHandler){
            NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], [err localizedDescription]];
            failHandler(msg);
        }
    }];
}


#pragma mark 营业执照
- (void)cardTypeBusinessLicenseFromImage:(UIImage *)image
                            successHandler:(void (^)(id result))successHandler
                               failHandler:(void (^)(NSString *errMsg))failHandler {
    [[AipOcrService shardService] detectBusinessLicenseFromImage:image withOptions:nil successHandler:^(id result) {
        if(successHandler){
            successHandler(result);
        }
    } failHandler:^(NSError *err) {
        if(failHandler){
            NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], [err localizedDescription]];
            failHandler(msg);
        }
    }];
}

#pragma mark 票据
- (void)cardTypeReceiptFromImage:(UIImage *)image
                    successHandler:(void (^)(id result))successHandler
                       failHandler:(void (^)(NSString *errMsg))failHandler {
    [[AipOcrService shardService] detectReceiptFromImage:image withOptions:nil successHandler:^(id result) {
        if(successHandler){
            successHandler(result);
        }
    } failHandler:^(NSError *err) {
        if(failHandler){
            NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], [err localizedDescription]];
            failHandler(msg);
        }
    }];
}


#pragma mark 通用文字识别
- (void)cardTypeTextBasicFromImage:(UIImage *)image
                    successHandler:(void (^)(id result))successHandler
                       failHandler:(void (^)(NSString *errMsg))failHandler {
    [[AipOcrService shardService] detectTextBasicFromImage:image withOptions:nil successHandler:^(id result) {
        if(successHandler){
            successHandler(result);
        }
    } failHandler:^(NSError *err) {
        if(failHandler){
            NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], [err localizedDescription]];
            failHandler(msg);
        }
    }];
}

@end
