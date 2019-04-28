//
//  ImageMultiPhotoModel.h
//  ZWOCComponent
//
//  Created by zhouwei on 2019/4/28.
//  Copyright © 2019年 zhouwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ImageMultiPhotoModel : NSObject

@property(nonatomic, copy) NSString *url;       // 网络图地址
@property(nonatomic, strong) UIImage *image;    // 本地图片对象
@property(nonatomic, strong) PHAsset *asset;    // 本地图片asset对象
@property(nonatomic, assign) BOOL isVideo;      //  是否为视频

@property(nonatomic, copy) NSString *fileId;    // 网络图对应的id(用于图片更新)
@property (nonatomic, copy) NSString *name;     // 文件名称
@property (nonatomic, assign) NSInteger typeId; // 文件类型id(文件字典ID)
@property (nonatomic, retain) NSString *dataId; // 数据ID

@end
