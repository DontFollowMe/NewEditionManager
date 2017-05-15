//
//  NewEditionManager.h
//  YouJi
//
//  Created by fen9fe1 on 2017/4/28.
//  Copyright © 2017年 fen9fe1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class AppStoreInfoModel;

typedef void(^CheckVersionBlock)(AppStoreInfoModel *appInfo);

@interface NewEditionManager : NSObject

/**
 *  检测新版本   系统样式
 */
+ (void)checkNewEditionWithAppID:(NSString *)appID;

/**
 *  检测新版本   自定义UI
 */
+ (void)checkNewEditionWithAppID:(NSString *)appID CustomAlert:(CheckVersionBlock)checkVersionBlock;

@end
