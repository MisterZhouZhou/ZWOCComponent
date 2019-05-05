//
//  ZWTextView.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextHeightChangedBlock)(NSString *text,CGFloat textHeight);

@interface ZWTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/**  占位符字体大小 */
@property (nonatomic,strong) UIFont *placeholderFont;
/**  textView最大行数 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;
/** 设置圆角 */
@property (nonatomic, assign) NSUInteger cornerRadius;
//行间距
@property (nonatomic, assign) CGFloat verticalSpacing;
// 限制字符数
@property (nonatomic, assign) NSInteger limitCount;
@property (nonatomic, copy) TextHeightChangedBlock textHeightChangeBlock;

@end
