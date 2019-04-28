//
//  InfoAnnexInfoModel.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoAnnexInfoModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *displayName;      // 标题
@property (nonatomic, assign) BOOL isRequired;          // 是否是必填项

@end
