//
//  ZWVerityCodeLineView.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "ZWVerityCodeLineView.h"

@implementation ZWVerityCodeLineView

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
    UIView *colorView = [UIView new];
    [self addSubview:colorView];
    self.colorView = colorView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.colorView.frame = self.bounds;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    self.colorView.backgroundColor = backgroundColor;
}

- (void)animation {
    [self.colorView.layer removeAllAnimations];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animation.duration = 0.18;
    animation.repeatCount = 1;
    animation.fromValue = @(1.0);
    animation.toValue = @(0.1);
    animation.autoreverses = YES;
    
    [self.colorView.layer addAnimation:animation forKey:@"zoom.scale.x"];
}
@end
