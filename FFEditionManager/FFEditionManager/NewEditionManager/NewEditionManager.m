//
//  NewEditionManager.m
//  YouJi
//
//  Created by fen9fe1 on 2017/4/28.
//  Copyright © 2017年 fen9fe1. All rights reserved.
//

#import "NewEditionManager.h"
#import "AppStoreInfoModel.h"

@interface NewEditionManager () <UIAlertViewDelegate>

@property (nonatomic, strong) NSDictionary * infoDict;      //本地info文件
@property (nonatomic, strong) AppStoreInfoModel * model;

@end

@implementation NewEditionManager

+ (instancetype)shareManager {
    static NewEditionManager * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (void)checkNewEditionWithAppID:(NSString *)appID
{
    [[self shareManager] checkNewVersion:appID];
}

+ (void)checkNewEditionWithAppID:(NSString *)appID CustomAlert:(CheckVersionBlock)checkVersionBlock
{
    [[self shareManager] getAppStoreVersion:appID sucess:^(AppStoreInfoModel *model) {
        if(checkVersionBlock)checkVersionBlock(model);
    }];
}

- (void)checkNewVersion:(NSString *)appID
{
    [self getAppStoreVersion:appID sucess:^(AppStoreInfoModel *model) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"有新的版本(%@)",model.version] message:model.releaseNotes delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"立即升级", @"忽略", nil];
        [alert show];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self updateRightNow:self.model];
    } else if (buttonIndex == 2) {
        [self ignoreNewVersion:self.model.version];
    }
}

#pragma mark - 立即升级
- (void)updateRightNow:(AppStoreInfoModel *)model {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.trackViewUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.trackViewUrl] options:@{} completionHandler:nil];
    }
}

#pragma mark - 忽略新版本
- (void)ignoreNewVersion:(NSString *)version {
    //保存忽略的版本号
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"ingoreVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取AppStore上的版本信息
- (void)getAppStoreVersion:(NSString *)appID sucess:(void(^)(AppStoreInfoModel *))update {
    
    [self getAppStoreInfo:appID success:^(NSDictionary *respDict) {
        NSInteger resultCount = [respDict[@"resultCount"] integerValue];
        if (resultCount == 1) {
            NSArray *results = respDict[@"results"];
            NSDictionary *appStoreInfo = [results firstObject];
            
            //字典转模型
            AppStoreInfoModel *model = [[AppStoreInfoModel alloc] init];
            [model setValuesForKeysWithDictionary:appStoreInfo];
            [NewEditionManager shareManager].model = model;
            //是否提示更新
            BOOL result = [self isEqualEdition:model.version];
            if (result) {
                if(update)update(model);
            }
        } else {
#ifdef DEBUG
            NSLog(@"AppStore上面没有找到对应id的App");
#endif
        }
    }];
}

#pragma mark - 获取AppStore的info信息
- (void)getAppStoreInfo:(NSString *)appID success:(void(^)(NSDictionary *))success {
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/CN/lookup?id=%@",appID]];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil && data != nil && data.length > 0) {
                NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (success) {
                    success(respDict);
                }
            }
        });
    }] resume];
}

#pragma mark - 返回是否提示更新
- (BOOL)isEqualEdition:(NSString *)newEdition {
    NSString *ignoreVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"ingoreVersion"];
    if([self.infoDict[@"CFBundleShortVersionString"] compare:newEdition] == NSOrderedDescending
       || [self.infoDict[@"CFBundleShortVersionString"] compare:newEdition] == NSOrderedSame
       || [ignoreVersion isEqualToString:newEdition]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark ---- Lazy
- (NSDictionary *)infoDict {
    if (!_infoDict) {
        _infoDict = [NSBundle mainBundle].infoDictionary;
    }
    return _infoDict;
}

@end
