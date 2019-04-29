//
//  MultiPhotoPreView.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/29.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * 代理 - 点击按钮回调
 */
@protocol PhotoPreViewProtocol <NSObject>

- (CGRect)keyWindowFrame:(NSInteger)cell_row;
- (UIImage*)keyWindowImage:(NSInteger)cell_row;

@end

@interface MultiPhotoPreView : UIView

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, weak) id<PhotoPreViewProtocol> delegate;

- (void)showIndex:(NSInteger)index;

@end
