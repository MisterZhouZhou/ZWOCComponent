//
//  UITextView+Extension.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)

- (void)setPlaceHolder:(NSString *)placeHolder {
    UILabel *placeHolderStr = [[UILabel alloc] init];
    placeHolderStr.text = placeHolder;
    placeHolderStr.numberOfLines = 0;
    placeHolderStr.textColor = [UIColor lightGrayColor];
    [placeHolderStr sizeToFit];
    [self addSubview:placeHolderStr];
    placeHolderStr.font = self.font;
    [self setValue:placeHolderStr forKey:@"_placeholderLabel"];
}

- (NSString *)placeHolder {
    UILabel *placeHolderStr = [self valueForKey:@"_placeholderLabel"];
    return placeHolderStr.text;
}

@end
