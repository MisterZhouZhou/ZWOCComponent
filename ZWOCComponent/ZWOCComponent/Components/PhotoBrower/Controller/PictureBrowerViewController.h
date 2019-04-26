//
//  PictureBrowerViewController.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/26.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureBrowerViewController : UIViewController

@property (nonatomic, strong) NSArray *urlsArray;         // 图片数组
@property (nonatomic , copy) void (^callBackBlock)(void); // 预览后回调处理

@end
