//
//  UIImage+Extension.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
* data获取gif
* @param data data数据
* @return image UIImage
*/
+ (UIImage *)sd_tz_animatedGIFWithData:(NSData *)data; 

/**
 * 获取视频第一帧
 * @param path  NSURL 视频URL
 * @return image UIImage
 */
+ (UIImage*) getVideoPreViewImage:(NSURL *)path;

//由颜色生成图片
+ (UIImage *) imageWithColor:(UIColor*)color;

//将图片剪裁至目标尺寸
+ (UIImage *) imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;

//图片旋转角度
- (UIImage *) imageRotatedByDegrees:(CGFloat)degrees;

//拉伸图片UIEdgeInsets
- (UIImage *) resizableImage:(UIEdgeInsets)insets;

//拉伸图片CGFloat
- (UIImage *) imageByResizeToScale:(CGFloat)scale;

//放大图片CGSize
- (UIImage *) imageByResizeWithMaxSize:(CGSize)size;

//小样图图片CGSize
- (UIImage *) imageWithThumbnailForSize:(CGSize)size;

//通过Rect剪裁图片
- (UIImage *) imageByCropToRect:(CGRect)rect;

//图片增加圆角
- (UIImage *) imageByRoundCornerRadius:(CGFloat)radius;

//图片增加圆角及边框
- (UIImage *) imageByRoundCornerRadius:(CGFloat)radius
                           borderWidth:(CGFloat)borderWidth
                           borderColor:(UIColor *)borderColor;

//图片向左90度
- (UIImage *)imageByRotateLeft90;

//图片向右90度
- (UIImage *)imageByRotateRight90;

//图片转180度
- (UIImage *)imageByRotate180;

@end
