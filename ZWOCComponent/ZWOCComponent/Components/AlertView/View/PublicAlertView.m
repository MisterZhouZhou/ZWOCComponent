//
//  PublicAlertView.m
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import "PublicAlertView.h"

#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>

@implementation PublicAlertView

/*!
 * 初始化alertView
 *
 * @title 提示语标题
 * @param sureTitle 确认按钮的标题 - 将根据取消的title是否有值来决定确定按钮的宽度
 * @param cancelTitle 取消按钮的标题 - 根据取消按钮的title来决定是否显示此按钮
 */
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withSureTitle:(NSString *)sureTitle withCancelTitle:(NSString *)cancelTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:6];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self layoutAlertViewWithTitle:title withSureTitle:sureTitle withCancelTitle:cancelTitle];
    }
    return self;
}

/*!
 * 构建提示框
 *
 * @param title 提示标题
 * @param sureTitle 确认按钮的标题
 * @param cancelTitle 取消按钮的标题 - 根据取消按钮的title来决定是否显示此按钮
 */
- (void)layoutAlertViewWithTitle:(NSString *)title withSureTitle:(NSString *)sureTitle withCancelTitle:(NSString *)cancelTitle
{
    //title
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"#333333"]];
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [titleLabel setNumberOfLines:0];
    [self addSubview:titleLabel];
    
    //cancel
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:_cancelButton];
    
    //sure
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureButton setTitle:sureTitle forState:UIControlStateNormal];
    [_sureButton setTitleColor:[UIColor colorWithHexString:@"#BD081C"] forState:UIControlStateNormal];
    [_sureButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:_sureButton];
    
    //line
    UILabel *hLineLabel = [[UILabel alloc] init];
    [hLineLabel setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E6"]];
    [self addSubview:hLineLabel];
    UILabel *vLineLabel = [[UILabel alloc] init];
    [vLineLabel setBackgroundColor:[UIColor colorWithHexString:@"#E6E6E6"]];
    [self addSubview:vLineLabel];
    [hLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.leading.mas_equalTo(self.frame.size.width/2);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(44);
    }];
    [vLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-44);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    //title
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-44);
        make.leading.mas_equalTo(10);
        make.trailing.mas_equalTo(-10);
    }];
    
    //包含取消按钮
    __block CGFloat cancel_width = self.frame.size.width/2;
    __block CGFloat sure_width = self.frame.size.width/2;
    if (cancelTitle.length == 0) {
        sure_width = self.frame.size.width;
        [hLineLabel setHidden:YES];
    }
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.width.mas_equalTo(cancel_width);
        make.height.mas_equalTo(44);
    }];
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.width.mas_equalTo(sure_width);
        make.height.mas_equalTo(44);
    }];
}

@end
