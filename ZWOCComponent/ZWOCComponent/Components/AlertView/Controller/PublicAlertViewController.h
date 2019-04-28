//
//  PublicAlertViewController.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * alert 按钮点击的回调
 */
typedef void(^PublicAlertSureClickBlock)(void);
typedef void(^PublicAlertCancelClickBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface PublicAlertViewController : UIViewController
@property (nonatomic, readwrite, copy) PublicAlertSureClickBlock publicAlertSureClickBlock;
@property (nonatomic, readwrite, copy) PublicAlertCancelClickBlock publicAlertCancelClickBlock;

@property (nonatomic, readwrite, strong) NSString *alertTitle;//提示语
@property (nonatomic, readwrite, strong) NSString *cancelTitle;//取消按钮的名称
@property (nonatomic, readwrite, strong) NSString *sureTitle;//确认按钮的名称

@end

NS_ASSUME_NONNULL_END
