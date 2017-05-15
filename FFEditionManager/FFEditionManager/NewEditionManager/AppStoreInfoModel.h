//
//  AppStoreInfoModel.h
//  FFEditionManager
//
//  Created by fen9fe1 on 2017/5/15.
//  Copyright © 2017年 fen9fe1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppStoreInfoModel : NSObject

@property (nonatomic, copy) NSString * version;             // 版本号
@property (nonatomic, copy) NSString * releaseNotes;        // 更新日志
@property (nonatomic, copy) NSString * currentVersionReleaseDate;   // 更新时间
@property (nonatomic, copy) NSString * trackId;             // APPId
@property (nonatomic, copy) NSString * bundleId;            // bundleId
@property (nonatomic, copy) NSString * trackViewUrl;        // AppStore地址
@property (nonatomic, copy) NSString * sellerName;          // 开发商
@property (nonatomic, copy) NSString * fileSizeBytes;       // 文件大小
@property (nonatomic, strong) NSArray * screenshotUrls;     // 展示图

@end
