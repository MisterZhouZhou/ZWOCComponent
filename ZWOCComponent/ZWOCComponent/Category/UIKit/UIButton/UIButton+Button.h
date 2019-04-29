//
//  UIButton+Button.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/29.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(UIButton*button);

@interface UIButton (Button)

-(void)addTapBlock:(ButtonBlock)block;

+ (instancetype)buttonWithType:(UIButtonType)buttonType andBlock:(ButtonBlock)block;

@end
