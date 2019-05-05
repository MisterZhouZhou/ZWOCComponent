//
//  MBProgressHUD+XY.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/19.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "MBProgressHUD+XY.h"
#import <YYKit/YYKit.h>
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

const NSInteger hideTime = 1;

@implementation MBProgressHUD (XY)
//获取当前控制器
NS_INLINE UIViewController* GetCurrentViewCon()
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }else {
        result = window.rootViewController;
    }
    return result;
}

//获取当前拥有类型的控制器
NS_INLINE UIViewController* GetCurrentValidViewCon() {
    UIViewController *superVC = GetCurrentViewCon();
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        UIViewController *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else {
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    }
    return superVC;
}

+ (MBProgressHUD*)createMBProgressHUDviewWithMessage:(NSString*)message isWindiw:(BOOL)isWindow
{
    UIView  *view = isWindow? (UIView*)[UIApplication sharedApplication].delegate.window:GetCurrentValidViewCon().view;
    MBProgressHUD * hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud =[MBProgressHUD showHUDAddedTo:view animated:YES];
    }else{
        [hud showAnimated:YES];
    }
//    hud.top = hud.top - 64;
    hud.top = hud.top;
    hud.minSize = CGSizeMake(100, 30);
    hud.label.text=(message&&![message isEqual:[NSNull null]])?message:@"加载中...";
    hud.label.font=[UIFont systemFontOfSize:14];
    hud.label.textColor= [UIColor whiteColor];
    hud.label.numberOfLines = 0;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.9];
    hud.removeFromSuperViewOnHide = YES;
    [hud setContentColor:[UIColor whiteColor]];
//    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    return hud;
}
#pragma mark-------------------- show Tip----------------------------

+ (void)showTipMessageInWindow:(NSString*)message
{
    [self showTipMessage:message isWindow:true timer:[self getTimeIntervalWithMessage:message]];
}
+ (void)showTipMessageInView:(NSString*)message
{
    [self showTipMessage:message isWindow:false timer:[self getTimeIntervalWithMessage:message]];
}
+ (void)showTipMessageInWindow:(NSString*)message timer:(float)aTimer
{
    [self showTipMessage:message isWindow:true timer:aTimer];
}
+ (void)showTipMessageInView:(NSString*)message timer:(float)aTimer
{
    [self showTipMessage:message isWindow:false timer:aTimer];
}
+ (void)showTipMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer
{
    MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:[self getTimeIntervalWithMessage:message]];
}
#pragma mark-------------------- show Activity----------------------------

+ (void)showActivityMessageInWindow:(NSString*)message
{
    [self showActivityMessage:message isWindow:true timer:0];
}
+ (void)showActivityMessageInView:(NSString*)message
{
    [self showActivityMessage:message isWindow:false timer:0];
}
+ (void)showActivityMessageInWindow:(NSString*)message timer:(float)aTimer
{
    [self showActivityMessage:message isWindow:true timer:aTimer];
}
+ (void)showActivityMessageInView:(NSString*)message timer:(float)aTimer
{
    [self showActivityMessage:message isWindow:false timer:aTimer];
}
+ (void)showActivityMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer
{
    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (aTimer>0) {
        [hud hideAnimated:YES afterDelay:aTimer];
    }
}
#pragma mark-------------------- show Image----------------------------

+ (void)showSuccessMessage:(NSString *)Message
{
    [self showCustomIconInWindow:@"MBHUD_Success" message:Message];
}
+ (void)showErrorMessage:(NSString *)Message
{
    [self showCustomIconInWindow:@"MBHUD_Error" message:Message];
}
+ (void)showInfoMessage:(NSString *)Message
{
    [self showCustomIconInWindow:@"MBHUD_Info" message:Message];
}
+ (void)showWarnMessage:(NSString *)Message
{
    [self showCustomIconInWindow:@"MBHUD_Warn" message:Message];
}
+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message
{
    [self showCustomIcon:iconName message:message isWindow:true];
    
}
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message
{
    [self showCustomIcon:iconName message:message isWindow:false];
}
+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow
{
    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    hud.mode = MBProgressHUDModeCustomView;
    [hud hideAnimated:YES afterDelay:[self getTimeIntervalWithMessage:message?message:@"加载中..."]];
}
+ (void)hideHUD
{
    UIView  *winView =(UIView*)[UIApplication sharedApplication].delegate.window;
    [self hideAllHUDsForView:winView animated:YES];
    [self hideAllHUDsForView:GetCurrentValidViewCon().view animated:YES];
}

#pragma mark ————— 顶部tip —————
+ (void)showTopTipMessage:(NSString *)msg {
    [self showTopTipMessage:msg isWindow:NO];
}
+ (void)showTopTipMessage:(NSString *)msg isWindow:(BOOL) isWindow{
    CGFloat padding = 10;
    
    YYLabel *label = [YYLabel new];
    label.text = msg;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.033 green:0.685 blue:0.978 alpha:0.8];
    label.width = kScreenWidth;
    label.textContainerInset = UIEdgeInsetsMake(padding+padding, padding, 0, padding);
    
    if (isWindow) {
        label.height = kTopHeight;
        label.bottom = 0;
        [kAppWindow addSubview:label];
        
        [UIView animateWithDuration:0.3 animations:^{
            label.top = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                label.bottom = 0;
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        }];
        
    }else {
        label.height = [msg heightForFont:label.font width:label.width] + 2 * padding;
        label.bottom = (kiOS7Later ? 64 : 0);
        [GetCurrentValidViewCon().view addSubview:label];
        
        [UIView animateWithDuration:0.3 animations:^{
            label.top = (kiOS7Later ? 64 : 0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                label.bottom = (kiOS7Later ? 64 : 0);
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        }];

    }
    
}

#pragma mark - - Others Action - -
/*!
 * 根据提示文本长度来决定消失的时长
 *
 * @param message 提示文本
 */
+ (NSTimeInterval)getTimeIntervalWithMessage:(NSString *)message {
    NSTimeInterval hideTimeInterval = 1;
    if (message && message.length > 0) {
        //根据message文本的长度来判断提示显示的时间长度
        if (message.length > 15) {
            hideTimeInterval = 3;
        }else if (message.length > 10) {
            hideTimeInterval = 2;
        }else {
            hideTimeInterval = 1;
        }
    }
    return hideTimeInterval;
}
@end
