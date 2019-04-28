//
//  ImagePhotoBrowerViewController.h
//  CDDUIPublicComponentsModules
//
//  Created by zhouwei on 2018/12/20.
//

#import <UIKit/UIKit.h>

@interface ImagePhotoBrowerViewController : UIViewController
/**
 显示的图片数据源
 * photos [MultiPhotoModel]
 */
@property (nonatomic, strong) NSMutableArray *photos;
/**
 回调处理后的图片list
 @param photos [MultiPhotoModel]
 */
@property (nonatomic , copy) void (^callBackBlock)(NSMutableArray *photos);
/**
 选中图片的下标
 * param NSInteger
 */
@property (nonatomic, assign) NSInteger selectedIndex;
/**
 图片预览器标题
 * param NSString
 */
@property (nonatomic, copy) NSString  *titleString;

/**
 图片是否可删除
 * param BOOL
 */
@property (nonatomic, assign) BOOL isDelete;

@end
