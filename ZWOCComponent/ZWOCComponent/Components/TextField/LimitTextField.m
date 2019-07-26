//
//  LimitTextField.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/7.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "LimitTextField.h"
#import "UIColor+Color.h"

@interface LimitTextField()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation LimitTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        // 输入位数默认不显示，输入的小数点默认限制两位小数
        self.numberCount = NSIntegerMax;
        self.pointCount  = 2;
        self.placeholder = @"请输入";
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

#pragma mark - initView
- (void)initSubViews {
    [self.textField setValue:[UIColor colorWithHexString:@"#C4C4C4"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    //实时监听textView值得改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.textFieldType == LimitTextFieldType_Text) {
        return YES;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }else if ([string isEqualToString:@" "]) {
        return NO;
    }else if ([string isEqualToString:@"."]) { // 第一次输入小数点
        if (textField.text.length == 0) {
            return NO;
        }
        if([textField.text rangeOfString:@"."].location !=NSNotFound) { //_roaldSearchText
            return NO;
        }else{
            if (self.textFieldType == LimitTextFieldType_Number) { // 纯数字类型，如果小数点位数为0，不允许输入点
                if(self.pointCount == 0){
                    return NO;
                }
            }else if (self.textFieldType == LimitTextFieldType_IdCard) { // 身份证类型，不允许输入小数点
                return NO;
            }
            return YES;
        }
    }else{
        if([textField.text rangeOfString:@"."].location !=NSNotFound)//_roaldSearchText, 是否包含小数点
        {
            NSArray *array = [textField.text componentsSeparatedByString:@"."]; //字符串按照【分隔成数组
            if ([NSString stringWithFormat:@"%@",array[0]].length >= self.numberCount) {
                if ([NSString stringWithFormat:@"%@",array[1]].length >= self.pointCount) { // 限制小数点位数
                    return NO;
                }else{
                    return YES;
                }
            }else{
                if ([NSString stringWithFormat:@"%@",array[1]].length >= self.pointCount) { // 限制小数点位数
                    return NO;
                }else{
                    return YES;
                }
            }
        }else{
            if (textField.text.length >= self.numberCount) {
                // 处理中文输入问题
                UITextRange *markedRange = [self.textField markedTextRange];
                if (markedRange) {
                    return YES;
                }
                return NO;
            }else{
                // 如果类型是纯数字不允许输入其他的内容
                if (self.textFieldType == LimitTextFieldType_Number) {
                    if ([self judgeTheillegalCharacterNumber:string]) {
                        return YES;
                    }
                    return YES;
                }else if(self.textFieldType == LimitTextFieldType_IdCard){ // 身份证类型
                    if (![self judgeTheillegalCharacterNumberAndLetter:string]) { // 数字+字母
                        return NO;
                    }
                }
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
        if (self.textField.text.length > self.numberCount) {
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [self.textField.text rangeOfComposedCharacterSequenceAtIndex:self.numberCount];
            self.textField.text = [self.textField.text substringToIndex:range.location];
        }
    }
}

#pragma mark 输入数字+.类型校验
- (BOOL)judgeTheillegalCharacterNumber:(NSString *)content {
    //提示 标签不能输入特殊字符
    NSString *str =@"^[0-9.]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return [emailTest evaluateWithObject:content];
}

#pragma mark 输入数字+字母类型校验
- (BOOL)judgeTheillegalCharacterNumberAndLetter:(NSString *)content {
    //提示 标签不能输入特殊字符
    NSString *str =@"^[0-9a-zA-Z]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return [emailTest evaluateWithObject:content];
}

#pragma mark - setter
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    self.textField.textAlignment = textAlignment;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

#pragma mark - getter
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _textField.delegate = self;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.placeholder = self.placeholder;
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
