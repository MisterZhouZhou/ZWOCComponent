//
//  BaiduORCManager.h
//  CDDCarSecondLoan
//
//  Created by zhouwei on 2018/12/13.
//  Copyright © 2018年 徐春雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/* model */
#import "SYIdCardModel.h"

typedef NS_ENUM(NSInteger, SYCardType) {
    
    SYCardTypeIdCardFont = 0,        // 身份证正面
    SYCardTypeIdCardBack,            // 身份证反面
    SYCardTypeBankCard,              // 银行卡
    SYCardTypeDrivingLicense,        // 驾驶证
    SYCardTypeVehicleLicense,        // 行驶证
    SYCardTypePlateNumber,           // 车牌证
    SYCardTypeBusinessLicense,       // 营业执照
    SYCardTypeReceipt,               // 票据
    SYCardTypeTextBasic              // 通用文字识别
};


@interface BaiduORCManager : NSObject

+ (BaiduORCManager *)sharedManager;

/**
 * 注册百度ocr
 * @param akey 百度ocr ak
 * @param skey 百度ocr sk
 */
-(void)initBaiDuOCRWithAK:(NSString *)akey andSK:(NSString *)skey;

/**
 * 身份证正面识别
 * @param image 需要识别的图片
 * @param cardtype 识别类型
 * @param successHandler 成功回调
 * @param failHandler 失败回调
 */
- (void)detectedCardInfoFromImage:(UIImage *)image cardType:(SYCardType)cardtype
                   successHandler:(void (^)(id result))successHandler
                      failHandler:(void (^)(NSString *errMsg))failHandler;

@end
