//
//  PhotoBrowerConfig.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/26.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#ifndef PhotoBrowerConfig_h
#define PhotoBrowerConfig_h

// browser背景颜色
#define ZWPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]
// browser 图片间的margin
#define ZWPhotoBrowserImageViewMargin 10
// browser中显示图片动画时长
#define ZWPhotoBrowserShowImageAnimationDuration 0.4f
// browser中显示图片动画时长
#define ZWPhotoBrowserHideImageAnimationDuration 0.4f

// 图片下载进度指示进度显示样式（ZWProgressViewModeLoopDiagram 环形，ZWProgressViewModePieDiagram 饼型）
typedef NS_ENUM(NSUInteger, ZWProgressViewMode){
    /**
     *  圆环形
     */
    ZWProgressViewModeLoopDiagram = 1,
    /**
     *  圆饼型
     */
    ZWProgressViewModePieDiagram = 2
};
// 图片下载进度指示器背景色
#define ZWProgressViewBackgroundColor [UIColor clearColor]
// 图片下载进度指示器圆环/圆饼颜色
#define ZWProgressViewStrokeColor [UIColor whiteColor]
// 图片下载进度指示器内部控件间的间距
#define ZWProgressViewItemMargin 10
// 圆环形图片下载进度指示器 环线宽度
#define ZWProgressViewLoopDiagramLineWidth 8


#endif /* PhotoBrowerConfig_h */
