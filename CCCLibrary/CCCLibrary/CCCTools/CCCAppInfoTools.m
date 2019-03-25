//
//  CCCAppInfoTools.m
//  CCCAddLib
//
//  Created by 财资赢-iOS on 2019/3/12.
//  Copyright © 2019年 hechong. All rights reserved.
//

#import "CCCAppInfoTools.h"
#import <UIKit/UIKit.h>

#define AppBaseInfo [[NSBundle mainBundle] infoDictionary]

@implementation CCCAppInfoTools

+ (NSDictionary *)appBaseInfo{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    //手机UUID
    NSString* identifierNumber = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"手机App UUID：%@",identifierNumber);

    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    
    return AppBaseInfo;

}

// 当前应用名称
+ (NSString *)appName{
    return AppBaseInfo[@"CFBundleDisplayName"];
}

// 当前应用软件版本  比如：1.0.1
+ (NSString *)appShortVersion{
    return AppBaseInfo[@"CFBundleShortVersionString"];
}

// 当前应用版本号码   int类型
+ (NSString *)appVersion{
    return AppBaseInfo[@"CFBundleVersion"];
}

// 当前应用UUID
+ (NSString *)appUUID{
    NSString* uuidStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uuidStr;
}

// 手机别名： 用户定义的名称
+ (NSString *)phoneAliasName{
    NSString* aliasName = [[UIDevice currentDevice] name];
    return aliasName;
}

// 设备应用系统名称 ‘iOS’
+ (NSString *)phoneSystemName{
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    return deviceName;
}

// 手机系统版本号
+ (NSString *)phoneSystemVersion{
    NSString* phoneSystemVersion = [[UIDevice currentDevice] systemVersion];
    return phoneSystemVersion;
}

// 手机型号 e.g. @"iPhone", @"iPod touch"
+ (NSString *)phoneModleName{
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    return phoneModel;
}

// 地方型号  （国际化区域名称）localized version of model
+ (NSString *)phoneLocalModel{
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    return localPhoneModel;
}

@end
