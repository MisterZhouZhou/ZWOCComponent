//
//  CDDEmptView.m
//  LYEmptyViewDemo
//
//  Created by zhouwei on 2018/11/1.
//  Copyright © 2018年 徐春雨. All rights reserved.
//

#import "CDDEmptView.h"
#import "CommonDefine.h"
#import "UIColor+Color.h"
#import "UIButton+Button.h"

@implementation CDDEmptView


+ (instancetype)diyNoDataEmpty{
    return [CDDEmptView emptyViewWithImageStr:@"nodata"
                                    titleStr:@"暂无数据"
                                   detailStr:@"请检查您的网络连接是否正确!"];
}

+ (instancetype)noDataEmptyWithImageString:(NSString *)imgStr detailStr: (NSString *)detail {
   CDDEmptView *emptyView  = [CDDEmptView emptyViewWithImageStr:imgStr
                               titleStr:nil
                              detailStr:detail];
    emptyView.detailLabFont = SYSTEMFONT(13);
    emptyView.detailLabTextColor = [UIColor colorWithHexString:@"999999"];
    emptyView.contentViewOffset  = - 50;
    emptyView.subViewMargin      = 12;
    return emptyView;
}

+ (instancetype)noDataEmptyWithButtonImageString:(NSString *)imgStr detailStr: (NSString *)detail buttonImg:(NSString *)buttonImgStr buttonStr: (NSString *)btnStr buttonBlock:(void(^)(void))blockClick {
    CGFloat custW = 200;
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, custW, custW)];
    // iconImage
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((custW-76)/2, 0, 76, 59)];
    iconImageView.image = [UIImage imageNamed:imgStr];
    [customView addSubview:iconImageView];
    // 提示信息
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageView.frame)+10, custW, 20)];
    titleLab.font      = SYSTEMFONT(13);
    titleLab.textColor = [UIColor colorWithHexString:@"999999"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = detail;
    [customView addSubview:titleLab];
    // 按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((custW-120)/2, CGRectGetMaxY(titleLab.frame)+20, 120, 30)];
    button.backgroundColor = [UIColor colorWithHexString:@"BD081C"];
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds= YES;
    [button setImage:[UIImage imageNamed:buttonImgStr] forState:UIControlStateNormal];
    [button setTitle:btnStr forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTapBlock:^(UIButton *button) {
        if(blockClick){
            blockClick();
        }
    }];
    [customView addSubview:button];
    
    CDDEmptView *emptyView = [CDDEmptView emptyViewWithCustomView:customView];
    emptyView.contentViewOffset  = - 60;
    return emptyView;
}

+ (instancetype)diyNoNetworkEmptyWithTarget:(id)target action:(SEL)action{
    
    CDDEmptView *diy = [CDDEmptView emptyActionViewWithImageStr:@"noData"
                                                     titleStr:@"暂无数据"
                                                    detailStr:@"请检查你的网络连接是否正确!"
                                                  btnTitleStr:@"重新加载"
                                                       target:target
                                                       action:action];
    diy.autoShowEmptyView = NO;
    
    diy.imageSize = CGSizeMake(150, 150);
    
    return diy;
}

+ (instancetype)diyCustomEmptyViewWithTarget:(id)target action:(SEL)action{
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"暂无数据，请稍后再试！";
    [customView addSubview:titleLab];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 80, 30)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"重试" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:button];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(120, 50, 80, 30)];
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"加载" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:15];
    [button2 addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:button2];
    
    CDDEmptView *diy = [CDDEmptView emptyViewWithCustomView:customView];
    return diy;
}

- (void)prepare{
    [super prepare];
    
    self.subViewMargin = 20.f;
    
    self.titleLabFont = [UIFont systemFontOfSize:25];
    self.titleLabTextColor = RGB(90, 180, 160);
    
    self.detailLabFont = [UIFont systemFontOfSize:17];
    self.detailLabTextColor = RGB(180, 120, 90);
    self.detailLabMaxLines = 5;
    
    self.actionBtnBackGroundColor = RGB(90, 180, 160);
    self.actionBtnTitleColor = [UIColor whiteColor];
}

@end
