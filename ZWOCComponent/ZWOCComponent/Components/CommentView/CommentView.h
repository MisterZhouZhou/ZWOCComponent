//
//  CommentView.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentView;
@protocol CommentViewDelegate<NSObject>

@optional
-(void)commentView:(CommentView*)commentView sendMessage:(NSString*)message complete:(void(^)(BOOL success))completeBlock;

@end

@interface CommentView : UIView

@property (nonatomic, strong)UITextView *commentTV; // 输入框
@property (nonatomic, strong)UILabel *tipLabel;     // 提示
@property (nonatomic, strong)UIButton *senderBtn;   // 发送按钮
@property (nonatomic,weak) id <CommentViewDelegate> delegate;

@end



