//
//  MultiPhotoTableViewCell.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiPhotoTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger imageMaxCount;        // 可选图片的最大数量
@property (nonatomic, assign) NSInteger imageRowCount;        // 每列的最大数量
@property (nonatomic, strong) NSMutableArray *photosArray;    // 图片数据(selectedPhotos,selectedAssets)

@property (nonatomic, strong) UILabel *titleLable;            // cell title
@property (nonatomic, strong) UIViewController *parentViewController;   // 父controller

@property (nonatomic, assign) BOOL isEditing;                 // 是否可以编辑 - 添加和删除
@property (nonatomic, assign) BOOL canSelectVideo;            // 是否可以选择视频

@property (nonatomic, copy) void(^imageCountChange)(NSMutableArray *imageArray); // 图片数量发生改变

@end
