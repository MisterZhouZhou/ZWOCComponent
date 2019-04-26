//
//  ProgressView.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/26.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBrowerConfig.h"

@interface ProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) ZWProgressViewMode mode;

@end
