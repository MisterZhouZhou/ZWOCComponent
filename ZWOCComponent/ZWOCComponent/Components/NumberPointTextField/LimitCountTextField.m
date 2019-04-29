//
//  LimitCountTextField.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/29.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "LimitCountTextField.h"
#import "UIColor+Color.h"
#import "CommonDefine.h"

@interface LimitCountTextField()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation LimitCountTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置默认值
        self.isEditing = YES;
        self.limitCount = 9999;
        self.placeholder = @"请输入";
        [self initView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark 默认初始化UI
- (void)initView {
    [self addSubview:self.textField];
}

- (void)textFieldDidChange {
    if (self.textField.text.length > self.limitCount) {
        UITextRange *markedRange = [self.textField markedTextRange];
        if (markedRange) {
            return;
        }
        //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
        //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
        NSRange range = [self.textField.text rangeOfComposedCharacterSequenceAtIndex:self.limitCount];
        self.textField.text = [self.textField.text substringToIndex:range.location];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!ValidStr(textField.text)) {
        textField.text = @"";
        textField.placeholder = nil;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!ValidStr(textField.text)) {
        textField.placeholder = self.placeholder;
    }
    [self textFieldDidChange];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!self.isEditing) {
        return NO;
    }
    return YES;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.textField.keyboardType = keyboardType;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.delegate = self;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textColor = [UIColor colorWithHexString:@"#666666"];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.placeholder = self.placeholder;
        [_textField setValue:[UIColor colorWithHexString:@"#C4C4C4"] forKeyPath:@"_placeholderLabel.textColor"];
        [_textField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    }
    return _textField;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.textField.frame = self.bounds;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

