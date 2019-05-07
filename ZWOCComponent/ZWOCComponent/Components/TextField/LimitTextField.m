//
//  LimitTextField.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/7.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "LimitTextField.h"
#import "UIColor+Color.h"
#import "NSString+String.h"

@interface LimitTextField()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation LimitTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        self.limitCount = NSIntegerMax;
    }
    return self;
}

- (void)initSubViews {
    self.textField.placeholder = @"请输入";
    [self.textField setValue:[UIColor colorWithHexString:@"#C4C4C4"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    //实时监听textView值得改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }else if ([string isEqualToString:@" "]) {
        return NO;
    }else if ([string isEqualToString:@"."]) {
        if (textField.text.length == 0) {
            return NO;
        }
        if([textField.text rangeOfString:@"."].location !=NSNotFound)//_roaldSearchText
        {
            return NO;
        }else{
            if ([NSString checkIsChinese:self.textField.text]) { // 是否包含中文，有中文禁止输入小数点
                return NO;
            }
            return YES;
        }
    }else{
        if([textField.text rangeOfString:@"."].location !=NSNotFound)//_roaldSearchText
        {
            NSArray *array = [textField.text componentsSeparatedByString:@"."]; //字符串按照【分隔成数组
            if ([NSString stringWithFormat:@"%@",array[0]].length >= self.limitCount) {
                if ([NSString stringWithFormat:@"%@",array[1]].length >= 2) {
                    return NO;
                }else{
                    return YES;
                }
            }else{
                if ([NSString stringWithFormat:@"%@",array[1]].length >= 2) {
                    return NO;
                }else{
                    return YES;
                }
            }
        }else{
            if (textField.text.length >= self.limitCount) {
                // 处理中文输入问题
                UITextRange *markedRange = [self.textField markedTextRange];
                if (markedRange) {
                    return YES;
                }
                return NO;
            }else{
                return YES;
            }
        }
    }
}

- (void)textDidChange {
    NSString *lang = [[self.textField textInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *markedRange = [self.textField markedTextRange];
        if (markedRange) {
            return;
        }
        if (self.textField.text.length > self.limitCount) {
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [self.textField.text rangeOfComposedCharacterSequenceAtIndex:self.limitCount];
            self.textField.text = [self.textField.text substringToIndex:range.location];
        }
    }
}

#pragma mark - setter
-(void)setKeyBoardType:(UIKeyboardType)keyBoardType {
    _keyBoardType = keyBoardType;
    self.textField.keyboardType = keyBoardType;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    self.textField.textAlignment = textAlignment;
}

#pragma mark - getter
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _textField.delegate = self;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:_textField];
    }
    return _textField;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
