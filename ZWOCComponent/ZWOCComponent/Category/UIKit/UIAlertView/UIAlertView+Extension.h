//
//  UIAlertView+Extension.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CopletionBlock)(NSInteger buttonIndex);

@interface UIAlertView (Extension)

- (void)showWithBlock:(CopletionBlock)block;

@end
