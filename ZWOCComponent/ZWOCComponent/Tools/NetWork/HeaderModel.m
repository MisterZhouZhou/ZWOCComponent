//
//  HeaderModel.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/23.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "HeaderModel.h"
#import "CDDOpenUDID.h"
#import <YYKit/YYKit.h>

@implementation HeaderModel

-(instancetype)init{
    self = [super init];
    if (self) {
//        self.userid = userManager.curUserInfo.userid;
        self.imei = [CDDOpenUDID value].length>32 ? [[CDDOpenUDID value] substringToIndex:32] :[CDDOpenUDID value];
        self.os_type = 2;
        self.version = [UIApplication sharedApplication].appVersion;
//        self.channel = @"App Store";
        self.clientId = self.imei;//[OpenUDID value].length>32 ? [[OpenUDID value] substringToIndex:32] :[OpenUDID value];
//        self.versioncode = KVersionCode;
        self.mobile_model = [UIDevice currentDevice].machineModelName;
        self.mobile_brand = [UIDevice currentDevice].machineModel;
        self.service_name = @"authservice";
    }
    return self;
}
@end
