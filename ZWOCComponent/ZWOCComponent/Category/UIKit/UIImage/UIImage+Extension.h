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


@end
