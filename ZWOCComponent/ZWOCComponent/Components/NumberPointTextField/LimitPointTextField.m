//
//  LimitPointTextField.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/29.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "LimitPointTextField.h"
#import "UIColor+Color.h"
#import "CommonDefine.h"

@interface LimitPointTextField()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation LimitPointTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置默认值
        self.isEditing = YES;
        self.limitNumInt = 8;
        self.limitNumPoint = 2;
        self.placeholder = @"请输入";
        [self initView];
    }
    return self;
}

#pragma mark 默认初始化UI
- (void)initView {
    [self addSubview:self.textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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
            return YES;
        }
    }else{
        if([textField.text rangeOfString:@"."].location !=NSNotFound){ //_roaldSearchText
            NSArray *array = [textField.text componentsSeparatedByString:@"."]; //字符串按照.分隔成数组
            if ([NSString stringWithFormat:@"%@",array[0]].length >= self.limitNumInt) {
                if ([NSString stringWithFormat:@"%@",array[1]].length >= self.limitNumPoint) {
                    return NO;
                }else{
                    return YES;
                }
            }else{
                if ([NSString stringWithFormat:@"%@",array[1]].length >= self.limitNumPoint) {
                    return NO;
                }else{
                    return YES;
                }
            }
        }else{
            if (textField.text.length >= self.limitNumInt) {
                return NO;
            }else{
                return YES;
            }
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField.text intValue] <= 0) {
        textField.text = @"";
        textField.placeholder = nil;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!ValidStr(textField.text)) {
        textField.placeholder = self.placeholder;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!self.isEditing) {
        return NO;
    }
    return YES;
}


- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.delegate = self;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textColor = [UIColor colorWithHexString:@"#666666"];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
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

@end
