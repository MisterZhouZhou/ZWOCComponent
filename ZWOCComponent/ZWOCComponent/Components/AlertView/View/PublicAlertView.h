//
//  PublicAlertView.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface PublicAlertView : UIView
@property (nonatomic, readwrite, strong) UIButton *cancelButton;
@property (nonatomic, readwrite, strong) UIButton *sureButton;

/*!
 * 初始化alertView
 *
 * @title 提示语标题
 * @param sureTitle 确认按钮的标题 - 将根据取消的title是否有值来决定确定按钮的宽度
 * @param cancelTitle 取消按钮的标题 - 根据取消按钮的title来决定是否显示此按钮
 */
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withSureTitle:(NSString *)sureTitle withCancelTitle:(NSString *)cancelTitle;
@end

NS_ASSUME_NONNULL_END
