//
//  ZWVerifyCodeCursorLabel.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWVerifyCodeCursorLabel : UILabel

@property (nonatomic, weak, readonly) UIView *cursorView;
@property (nonatomic, assign, readonly) BOOL isAnimated;  // 是否已开启动画
@property (nonatomic, strong) UIColor *bgColor;           // 光标设置背景色

- (void)startAnimating;

- (void)stopAnimating;

@end
