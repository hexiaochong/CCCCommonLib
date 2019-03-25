//
//  CCCAppInfoTools.h
//  CCCAddLib
//
//  Created by 财资赢-iOS on 2019/3/12.
//  Copyright © 2019年 hechong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCCAppInfoTools : NSObject

// 当前应用基础信息
+ (NSDictionary *)appBaseInfo;

// 当前应用名称
+ (NSString *)appName;

// 当前应用软件版本  比如：1.0.1
+ (NSString *)appShortVersion;

// 当前应用版本号码   int类型
+ (NSString *)appVersion;

// 当前应用UUID
+ (NSString *)appUUID;

// 手机别名： 用户定义的名称
+ (NSString *)phoneAliasName;

// 设备应用系统名称 ‘iOS’
+ (NSString *)phoneSystemName;

// 手机系统版本号
+ (NSString *)phoneSystemVersion;

// 手机型号 e.g. @"iPhone", @"iPod touch"
+ (NSString *)phoneModleName;

// 地方型号  （国际化区域名称）localized version of model
+ (NSString *)phoneLocalModel;

@end

NS_ASSUME_NONNULL_END
