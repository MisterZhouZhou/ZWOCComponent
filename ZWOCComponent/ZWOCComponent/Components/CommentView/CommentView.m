//
//  CommentView.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/5/5.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "CommentView.h"
#import "CommonDefine.h"
#import "UIView+HKFrame.h"
/*告警框*/
#define Alert(title,msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]

@interface CommentView()<UITextViewDelegate>{
    CGFloat originHeight_TV;
    CGFloat originHeight;
    CGFloat offSetY;         // 变动
    CGFloat originY;        // 最初的Y
    
    BOOL editable;          // 限制发送时，用户再次编辑事件
}

@property (strong ,nonatomic) UIButton *bgView; // 用于收起键盘
@property (strong ,nonatomic) UIActivityIndicatorView *indicator;   // 加载指示器
@property (copy ,nonatomic) NSString *content;

@end

@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    // 默认可输入
    editable = YES;
    // 输入框
    self.commentTV.layer.cornerRadius = 3;
    self.commentTV.layer.masksToBounds = YES;
    self.commentTV.scrollEnabled = NO;
    
    // 发送事件
    self.senderBtn.layer.cornerRadius = 5;
    self.senderBtn.layer.masksToBounds = YES;
    [self.senderBtn addTarget:self action:@selector(senderBtnAction) forControlEvents:UIControlEventTouchUpInside];
    // 加载指示器
    [self.senderBtn addSubview:self.indicator];
    // 隐藏发送按钮
    [self hideSenderBtn];
    [self changeSenderStyleUnEidit:self.senderBtn];
    
    self.tipLabel.text = @"评论";
  
    // 监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - <************************** TextView的代理协议 **************************>
-(void)textViewDidChange:(UITextView *)textView{
    self.content = textView.text;   // 输入的内容
    if ([textView.text isEqualToString:@""]) {
        self.tipLabel.hidden = NO;
        [self changeSenderStyleUnEidit:self.senderBtn];
    }else{
        self.tipLabel.hidden = YES;
        if ([self.content stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
            [self changeSenderStyleEidit:self.senderBtn];
        }
    }
    [self changeTextViewStyle:textView];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if ([self.content stringByReplacingOccurrencesOfString:@" " withString:@""].length==0) {
            Alert(@"提示", @"请输入内容");
            return NO;
        }else{
            [self senderBtnAction];
        }
        return NO;
    }
    return editable;
}



#pragma mark - <************************** 其他事件 **************************>
#pragma mark 发送操作
-(void)senderBtnAction {
    if ([self.delegate respondsToSelector:@selector(commentView:sendMessage:complete:)]) {
        // 开启指示器
        [self.indicator startAnimating];
        [self.senderBtn setTitle:@"" forState:UIControlStateNormal];
        // 不可交互
        self.senderBtn.userInteractionEnabled = NO;
        // 不可再输入
        editable = NO;
        
        [self.delegate commentView:self sendMessage:self.content complete:^(BOOL success) {
            if (success) {
                // 收起键盘
                self.tipLabel.text = @"评论";
                self.commentTV.text = @" ";
                [self.commentTV deleteBackward];    // 清除内容
                [self.commentTV resignFirstResponder];
                [self changeSenderStyleUnEidit:self.senderBtn];
            }
            else{
                [self changeSenderStyleEidit:self.senderBtn];
            }
            self->editable = YES;
            // 停止加载
            [self.indicator stopAnimating];
            [self.senderBtn setTitle:@"发送" forState:UIControlStateNormal];
            
        }];
    }
}

#pragma mark 键盘显示
-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary *dic =notification.userInfo;
    // 获取键盘的frame
    NSNumber *keyboardFrame= dic[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyboardFrameNew = keyboardFrame.CGRectValue;
    // 动画时间
    float animationTime =   [dic[@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    // 动画速度
    int animationCurve =[dic[@"UIKeyboardAnimationCurveUserInfoKey"]intValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationTime];
    [UIView setAnimationCurve:animationCurve];
    self.y = keyboardFrameNew.origin.y - originHeight - 64;
    offSetY = self.y;
    self.senderBtn.alpha = 1;
    [self showSenderBtn];
    [UIView commitAnimations];
    [self changeTextViewStyle:self.commentTV];
}

#pragma mark 键盘隐藏
-(void)keyboardWillHide:(NSNotification*)notification{
    NSDictionary *dic = notification.userInfo;
    // 获取动画时间
    float animationTime = [dic[@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    // 获取动画的速度
    int animationCurve =[dic[@"UIKeyboardAnimationCurveUserInfoKey"]intValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationTime];
    [UIView setAnimationCurve:animationCurve];
    self.y = originY;
    self.height = originHeight;
    self.commentTV.height = originHeight_TV;
    self.commentTV.centerY = self.height/2.0;
    self.senderBtn.centerY = self.height/2.0;
    self.tipLabel.centerY = self.height/2.0;
    [self hideSenderBtn];
    [UIView commitAnimations];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    // 记录下最初高度
    originHeight_TV = self.commentTV.height;
    originHeight = self.height;
    // 最初的y
    originY = self.y;
    offSetY = self.y;
}

#pragma mark 收起键盘事件
-(void)hideView{
    [self.commentTV resignFirstResponder];
}

#pragma mark 改变TV的样式
-(void)changeTextViewStyle:(UITextView*)textView
{
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.width, MAXFLOAT)];
    // 改变高度
    if(size.height<originHeight_TV){
        size.height = originHeight_TV;
    }
    CGFloat maxHeight = originHeight_TV * 2;
    size.height = MIN(size.height, maxHeight);  // 限制最高高度
    textView.height = size.height;
    self.height = size.height + 10;
    textView.centerY = self.height/2.0;
    self.senderBtn.centerY = self.height/2.0;
    self.tipLabel.centerY = self.height/2.0;
    // 当达到最高时可滚动
    textView.scrollEnabled = maxHeight == size.height ? YES : NO;
    self.y = offSetY - (self.height - originHeight);
}

#pragma mark 改变按钮样式
-(void)changeSenderStyleUnEidit:(UIButton*)sender{
    sender.userInteractionEnabled = NO;
    sender.backgroundColor = [UIColor lightGrayColor];
}

-(void)changeSenderStyleEidit:(UIButton*)sender{
    sender.userInteractionEnabled = YES;
    sender.backgroundColor = [UIColor redColor];
}

#pragma mark 显隐发送按钮
-(void)hideSenderBtn {
    self.senderBtn.hidden = YES;
    self.commentTV.width = self.width - 10*2;
}

#pragma mark 显示发送按钮
-(void)showSenderBtn {
    self.senderBtn.hidden = NO;
    self.commentTV.width = self.width - 10*2 - self.senderBtn.width - 10;
}

#pragma mark 超过父视图的子视图可以点击
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSArray *subViews = self.subviews;
    if ([subViews count] > 1)
    {
        for (UIView *aSubView in subViews)
        {
            if ([aSubView pointInside:[self convertPoint:point toView:aSubView] withEvent:event])
            {
                return YES;
            }
        }
    }
    if (point.x > 0 && point.x < self.frame.size.width && point.y > 0 && point.y < self.frame.size.height)
    {
        return YES;
    }
    return NO;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - getter
-(UIButton *)bgView{
    if (_bgView==nil) {
        _bgView = [[UIButton alloc] initWithFrame:self.bounds];
        [_bgView addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgView;
}

-(UIActivityIndicatorView *)indicator{
    if (_indicator==nil) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicator.frame = self.senderBtn.bounds;
    }
    return _indicator;
}


- (UITextView *)commentTV {
    if (!_commentTV) {
        _commentTV = [[UITextView alloc]initWithFrame:CGRectMake(10, 2, self.width - 20 , self.height-4)];
        _commentTV.delegate = self;
        _commentTV.font = SYSTEMFONT(15);
        _commentTV.backgroundColor = [UIColor greenColor];
        [self addSubview:_commentTV];
    }
    return _commentTV;
}

- (UIButton *)senderBtn {
    if (!_senderBtn) {
        _senderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _senderBtn.frame = CGRectMake(self.width - 40 - 5, 2, 40, self.height-4);
        [_senderBtn setTitle:@"发送" forState:UIControlStateNormal];
        [self addSubview:_senderBtn];
    }
    return _senderBtn;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+5, 2, 40, self.height - 4)];
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.font = SYSTEMFONT(14);
        [self addSubview:_tipLabel];
    }
    return _tipLabel;
}

@end
