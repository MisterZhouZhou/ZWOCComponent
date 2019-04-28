//
//  ZWVerifyCodeCursorView.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "ZWVerifyCodeCursorView.h"
#import "ZWVerifyCodeCursorLabel.h"
#import "ZWVerityCodeLineView.h"
#import "CommonDefine.h"

@interface ZWVerifyCodeCursorView()

@property (nonatomic, assign) NSInteger itemCount;   // 字内容个数
@property (nonatomic, weak) UITextField *textField;  // 输入框
@property (nonatomic, weak) UIControl *maskView;     // 遮罩层
@property (nonatomic, strong) NSMutableArray<ZWVerifyCodeCursorLabel *> *labels;  // 光标
@property (nonatomic, strong) NSMutableArray<ZWVerityCodeLineView *> *lines;      // 下划线
@property (nonatomic, weak) ZWVerifyCodeCursorLabel *currentLabel; // 当前闪烁光标
@property (nonatomic, copy) NSString *lastInputText;// 上一次输入的内容

@end

@implementation ZWVerifyCodeCursorView

#pragma mark - 初始化
- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin {
    if (self = [super init]) {
        self.lineColor = [UIColor purpleColor];
        self.itemCount = count;
        self.itemMargin = margin;
        [self configTextField];
    }
    return self;
}

- (void)configTextField {
    self.backgroundColor = [UIColor whiteColor];
    
    self.labels = @[].mutableCopy;
    self.lines = @[].mutableCopy;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:(UIControlEventEditingChanged)];
    
    // 小技巧：这个属性为YES，可以强制使用系统的数字键盘，缺点是重新输入时，会清空之前的内容
    // clearsOnBeginEditing 属性并不适用于 secureTextEntry = YES 时
    // textField.secureTextEntry = YES;
    
    [self addSubview:textField];
    self.textField = textField;
    
    // 小技巧：通过textField上层覆盖一个maskView，可以去掉textField的长按事件
    UIButton *maskView = [UIButton new];
    maskView.backgroundColor = [UIColor whiteColor];
    [maskView addTarget:self action:@selector(clickMaskView) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:maskView];
    self.maskView = maskView;
    
    for (NSInteger i = 0; i < self.itemCount; i++) {
        ZWVerifyCodeCursorLabel *label = [ZWVerifyCodeCursorLabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkTextColor];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:41.5];
        [self addSubview:label];
        [self.labels addObject:label];
    }
    
    for (NSInteger i = 0; i < self.itemCount; i++) {
        ZWVerityCodeLineView *line = [ZWVerityCodeLineView new];
        line.backgroundColor = self.lineColor;
        [self addSubview:line];
        [self.lines addObject:line];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.labels.count != self.itemCount) return;
    CGFloat temp = self.bounds.size.width - (self.itemMargin * (self.itemCount - 1));
    CGFloat w = temp / self.itemCount;
    CGFloat x = 0;
    
    for (NSInteger i = 0; i < self.labels.count; i++) {
        x = i * (w + self.itemMargin);
        // 布局光标
        UILabel *label = self.labels[i];
        label.frame = CGRectMake(x, 0, w, self.bounds.size.height);
        // 布局下划线
        UIView *line = self.lines[i];
        line.frame = CGRectMake(x, self.bounds.size.height - 1, w, 1);
    }
    
    self.textField.frame = self.bounds;
    self.maskView.frame = self.bounds;
}

#pragma mark - setter
#pragma mark 修改输入框字体的颜色
- (void)setCodeColor:(UIColor *)codeColor {
    _codeColor = codeColor;
    __weak UIColor *weakColor = codeColor;
    [self.labels enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = (UILabel*)obj;
        label.textColor = weakColor;
    }];
}

#pragma mark 修改输入框字体
- (void)setCodeFont:(UIFont *)codeFont {
    _codeFont = codeFont;
    __weak UIFont *weakFont = codeFont;
    [self.labels enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = (UILabel*)obj;
        label.font = weakFont;
    }];
}

#pragma mark 修改下划线颜色
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    __weak UIColor *weakColor = lineColor;
    [self.lines enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = weakColor;
    }];
}

#pragma mark 修改验证码间隔
-(void)setItemMargin:(NSInteger)itemMargin {
    _itemMargin = itemMargin;
}

#pragma mark 设置验证码样式
- (void)setCodeMode:(CodeMode)codeMode {
    _codeMode = codeMode;
    if (codeMode == CodeMode_Border) {
        kWeakSelf(self)
        [self.labels enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label = (UILabel*)obj;
            label.layer.borderColor = [weakself.lineColor CGColor];
            label.layer.borderWidth = 1;
        }];
    }
}

#pragma mark - 编辑改变
- (void)tfEditingChanged:(UITextField *)textField {
    if (textField.text.length > self.itemCount) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, self.itemCount)];
    }
    
    for (int i = 0; i < self.itemCount; i++) {
        UILabel *label = [self.labels objectAtIndex:i];
        if (i < textField.text.length) {
            label.text = [textField.text substringWithRange:NSMakeRange(i, 1)];
        } else {
            label.text = nil;
        }
    }
    
    // 获取下一个输入焦点
    [self cursor];
    
    // 边框动画
    [self doAnimationWithCurrentText:textField.text];
    
    // 输入完毕后，自动隐藏键盘
    if (textField.text.length >= self.itemCount) {
        [self.currentLabel stopAnimating];
        [textField resignFirstResponder];
        if(self.inputEndBlock){
            self.inputEndBlock(self.code);
        }
    }
}

#pragma mark 边框/下划线动画
- (void)doAnimationWithCurrentText:(NSString *)text {
    if (self.animated) {
        // 动画效果，这里是删除时，不要动画，输入时显示动画
        if (self.lastInputText.length < text.length) {
            if (text == nil || text.length <= 0) {
                [self.lines.firstObject lineAnimation];
                if (self.codeMode == CodeMode_Border) { // 边框模式做边框动画
                    [self animation:self.labels.firstObject];
                }
            } else if (text.length >= self.itemCount) {
                [self.lines.lastObject lineAnimation];
                if (self.codeMode == CodeMode_Border) { // 边框模式做边框动画
                    [self animation:self.labels.lastObject];
                }
            } else {
                [self.lines[self.textField.text.length - 1] lineAnimation];
                if (self.codeMode == CodeMode_Border) { // 边框模式做边框动画
                    [self animation:self.labels[self.textField.text.length - 1]];
                }
            }
        }
        self.lastInputText = text;
    }
}

#pragma mark 下划线添加动画
- (void)animation:(UILabel *)label {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.15;
    animation.repeatCount = 1;
    animation.fromValue = @(0.1);
    animation.toValue = @(1);
    [label.layer addAnimation:animation forKey:@"zoom"];
}

#pragma mark 点击遮罩层
- (void)clickMaskView {
    [self.textField becomeFirstResponder];
    if (self.currentLabel.isAnimated) return;
    [self cursor];
}

#pragma mark 结束编辑
- (BOOL)endEditing:(BOOL)force {
    [self.textField endEditing:force];
    [self.currentLabel stopAnimating];
    return [super endEditing:force];
}

#pragma mark - 处理光标
- (void)cursor {
    [self.currentLabel stopAnimating];
    NSInteger index = self.code.length;
    if (index < 0) index = 0;
    if (index >= self.labels.count) index = self.labels.count - 1;
    // 开始光标闪动
    ZWVerifyCodeCursorLabel *label = [self.labels objectAtIndex:index];
    [label startAnimating];
    self.currentLabel = label;
}

#pragma mark 获取输入的验证码
- (NSString *)code {
    return self.textField.text;
}

@end
