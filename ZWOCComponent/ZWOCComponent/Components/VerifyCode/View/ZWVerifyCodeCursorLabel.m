//
//  ZWVerifyCodeCursorLabel.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "ZWVerifyCodeCursorLabel.h"

@interface ZWVerifyCodeCursorLabel()

@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation ZWVerifyCodeCursorLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark - 初始化View
- (void)setupView {
    UIView *cursorView = [[UIView alloc] init];
    cursorView.backgroundColor = [UIColor blueColor];
    cursorView.alpha = 0;
    [self addSubview:cursorView];
    _cursorView = cursorView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat h = 30;
    CGFloat w = 2;
    CGFloat x = self.bounds.size.width * 0.5;
    CGFloat y = self.bounds.size.height * 0.5;
    self.cursorView.frame = CGRectMake(0, 0, w, h);
    self.cursorView.center = CGPointMake(x, y);
}

#pragma mark 设置背景色
- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.cursorView.backgroundColor = bgColor;
}

#pragma mark 开始透明度动画
- (void)startAnimating {
    if (self.text.length > 0) return;
    if (self.isAnimating) return;
    CABasicAnimation *oa = [CABasicAnimation animationWithKeyPath:@"opacity"];
    oa.fromValue = [NSNumber numberWithFloat:0];
    oa.toValue = [NSNumber numberWithFloat:1];
    oa.duration = 1;
    oa.repeatCount = MAXFLOAT;
    oa.removedOnCompletion = NO;
    oa.fillMode = kCAFillModeForwards;
    oa.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.cursorView.layer addAnimation:oa forKey:@"opacity"];
    self.isAnimating = YES;
}

#pragma mark 停止透明度动画
- (void)stopAnimating {
    if (!self.isAnimating) return;
    [self.cursorView.layer removeAnimationForKey:@"opacity"];
    self.isAnimating = NO;
}

- (BOOL)isAnimated {
   return self.isAnimating;
}

@end
