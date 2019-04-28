//
//  ZWVerifyCodeCursorView.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CodeMode){
    CodeMode_Line,   //  下划线
    CodeMode_Border  //  边框
};

typedef void (^InputEndBlock)(NSString *code);

@interface ZWVerifyCodeCursorView : UIView

@property (nonatomic, copy, readonly) NSString *code;  // 当前输入的内容
@property (nonatomic, strong) UIColor *codeColor;      // 输入框字体的颜色
@property (nonatomic, strong) UIFont *codeFont;        // 输入框字体
@property (nonatomic, strong) UIColor *lineColor;      // 下划线的颜色
@property (nonatomic, assign) NSInteger itemMargin;    // 输入框间隔
@property (nonatomic, assign) CodeMode codeMode;       // 验证码样式
@property (nonatomic, copy) InputEndBlock inputEndBlock; // 输入结束回调
@property (nonatomic, assign) BOOL animated;           // 是否开启下划线/边框动画

- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin;


@end
