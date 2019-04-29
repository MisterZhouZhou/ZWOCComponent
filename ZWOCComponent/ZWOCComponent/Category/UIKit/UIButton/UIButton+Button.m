//
//  UIButton+Button.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/29.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "UIButton+Button.h"
#import <objc/runtime.h>

@implementation UIButton (Button)

#pragma mark - 类级创建
+ (instancetype)buttonWithType:(UIButtonType)buttonType andBlock:(ButtonBlock)block {
    UIButton *btn = [UIButton buttonWithType:buttonType];
    [btn addTapBlock:block];
    return btn;
}

#pragma mark - 对象级创建
-(void)addTapBlock:(ButtonBlock)block {
    if(block){
        objc_setAssociatedObject(self,@selector(btnClick:), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    [self addTarget:self action:@selector(btnClick:)forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick:(UIButton*)btn {
    ButtonBlock block = objc_getAssociatedObject(self,@selector(btnClick:));
    if(block) {
        block(btn);
    }
}

@end
