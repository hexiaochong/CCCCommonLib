//
//  CCCTheme.m
//  CCCAddLib
//
//  Created by 财资赢-iOS on 2019/3/22.
//  Copyright © 2019年 hechong. All rights reserved.
//

#import "CCCTheme.h"


#define CCCCurrentTheme [self currentThemeInfo]

@interface CCCTheme()

@property(nonatomic,copy) NSString * themeName;


@end

@implementation CCCTheme

+ (instancetype)sharedInstance {
    static CCCTheme *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}


/**
 设置主题

 @param themeType 主题类型
 */
+ (void)setTheme:(CCCThemeType)themeType {
    
    switch (themeType) {
        case CCCDefaultTheme:{
            [[NSUserDefaults standardUserDefaults] setObject:@"CCCDefaultTheme" forKey:@"CCCThemeName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            break;
        case CCCSexyTheme:{
            [[NSUserDefaults standardUserDefaults] setObject:@"CCCSexyTheme" forKey:@"CCCThemeName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            break;
        case CCCGoldenTheme:{
            [[NSUserDefaults standardUserDefaults] setObject:@"CCCGoldenTheme" forKey:@"CCCThemeName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            break;
        
        default:{
            NSLog(@"%s未能识别该皮肤，请查看皮肤类型设置",__func__);
            [[NSUserDefaults standardUserDefaults] setObject:@"CCCDefaultTheme" forKey:@"CCCThemeName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
            break;
    }
}


/**
 获取当前主题信息

 @return 返回主题的字典
 */
+ (NSDictionary *)currentThemeInfo{
    NSString *themeName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CCCThemeName"];
    NSString *themePath = [[NSBundle mainBundle] pathForResource:themeName ofType:@"plist"];
    NSDictionary *themeDict = [NSDictionary dictionaryWithContentsOfFile:themePath];
    return themeDict;
}


#pragma mark - 基础颜色
/**
 根据颜色字符串计算颜色

 @param colorStr 颜色RGB字符串 11,12,234,1
 @return 返回颜色值
 */
+ (UIColor *)caculateColor:(NSString *)colorStr{
    
    NSArray *colorArr = [colorStr componentsSeparatedByString:@","];
    
    float redValue   = [colorArr[0] floatValue];
    float greenValue = [colorArr[1] floatValue];
    float blueValue  = [colorArr[2] floatValue];
    float alphaValue = [colorArr[3] floatValue];
    
    UIColor *color = [UIColor colorWithRed:redValue/255.0 green:greenValue/255.0 blue:blueValue/255.0 alpha:alphaValue];
    
    return color;
}


/**
 基础文本颜色值

 @return 返回基础文本颜色值
 */
+ (UIColor *)baseTextColor{
    NSString *colorStr = CCCCurrentTheme[@"BaseProperty"][@"baseTextColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

/**
 input文本颜色值
 
 @return 返回input文本颜色值
 */
+ (UIColor *)inputTextColor{
    NSString *colorStr = CCCCurrentTheme[@"BaseProperty"][@"inputTextColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

/**
 inputHolder文本颜色值
 
 @return 返回inputHolder文本颜色值
 */
+ (UIColor *)inputHolderColor{
    NSString *colorStr = CCCCurrentTheme[@"BaseProperty"][@"inputHolderColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

/**
 提交按钮背景颜色值
 
 @return 返回submitBtnBgColor文本颜色值
 */
+ (UIColor *)submitBtnBgColor{
    NSString *colorStr = CCCCurrentTheme[@"BaseProperty"][@"submitBtnBgColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}


/**
 提交按钮文字颜色值
 
 @return 返回submitBtnTextColor文本颜色值
 */
+ (UIColor *)submitBtnTextColor{
    NSString *colorStr = CCCCurrentTheme[@"BaseProperty"][@"submitBtnTextColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

/**
 导航栏文字颜色值
 
 @return 返回navBarTitleColor文本颜色值
 */
+ (UIColor *)navBarTitleColor{
    NSString *colorStr = CCCCurrentTheme[@"BaseProperty"][@"navBarTitleColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

/**
 导航栏背景颜色值
 
 @return 返回navBarBgColor文本颜色值
 */
+ (UIColor *)navBarBgColor{
    NSString *colorStr = CCCCurrentTheme[@"BaseProperty"][@"navBarBgColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

#pragma mark - 基础字体
/**
 基础字体

 @return 返回基础字体
 */
+ (UIFont *)baseFont{
    NSString *fontStr = CCCCurrentTheme[@"BaseProperty"][@"baseFont"];
    return [UIFont systemFontOfSize:[fontStr floatValue]];
}

/**
 基础大字体
 
 @return 返回基础大字体
 */
+ (UIFont *)baseBigFont{
    NSString *fontStr = CCCCurrentTheme[@"BaseProperty"][@"baseBigFont"];
    return [UIFont systemFontOfSize:[fontStr floatValue]];
}

/**
 基础小字体
 
 @return 返回基础小字体
 */
+ (UIFont *)baseSmallFont{
    NSString *fontStr = CCCCurrentTheme[@"BaseProperty"][@"baseSmallFont"];
    return [UIFont systemFontOfSize:[fontStr floatValue]];
}

#pragma mark - 首页皮肤颜色/图片

/**
 首页左侧logo

 @return 首页左侧logo
 */
+ (UIImage *)homeLeftLogo{
    NSString *imageName = CCCCurrentTheme[@"HomeProperty"][@"leftLogoImage"];
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

/**
 首页右侧logo
 
 @return 首页右侧logo
 */
+ (UIImage *)homeRightLogo{
    NSString *imageName = CCCCurrentTheme[@"HomeProperty"][@"rightLogoImage"];
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

/**
 首页搜索logo
 
 @return 首页搜索logo
 */
+ (UIImage *)homeSearchLogo{
    NSString *imageName = CCCCurrentTheme[@"HomeProperty"][@"searchImage"];
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

/**
 首页账户总览logo
 
 @return 首页账户总览logo
 */
+ (UIImage *)homeAccountOverviewimage{
    NSString *imageName = CCCCurrentTheme[@"HomeProperty"][@"accountOverviewimage"];
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

/**
 首页更多logo
 
 @return 首页更多logo
 */
+ (UIImage *)homeAccountMoreImage{
    NSString *imageName = CCCCurrentTheme[@"HomeProperty"][@"accountMoreImage"];
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}


/**
 首页账户余额logo
 
 @return 首页账户余额logo
 */
+ (UIImage *)homeAccountBalanceImage{
    NSString *imageName = CCCCurrentTheme[@"HomeProperty"][@"accountBalanceImage"];
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

/**
 首页账户总览文本颜色
 
 @return 首页账户总览文本颜色
 */
+ (UIColor *)homeAccountOverviewTxtColor{
    NSString *colorStr = CCCCurrentTheme[@"HomeProperty"][@"accountOverviewTxtColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

/**
 首页更多文字颜色

 @return 首页更多文字颜色
 */
+ (UIColor *)homeAccountMoreColor{
    NSString *colorStr = CCCCurrentTheme[@"HomeProperty"][@"accountMoreColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

/**
 首页账户余额文字颜色
 
 @return 首页账户余额文字颜色
 */
+ (UIColor *)homeAccountBalanceTxtColor{
    NSString *colorStr = CCCCurrentTheme[@"HomeProperty"][@"accountBalanceTxtColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

/**
 首页账户总数文字颜色
 
 @return 首页账户总数文字颜色
 */
+ (UIColor *)homeAccountNumberColor{
    NSString *colorStr = CCCCurrentTheme[@"HomeProperty"][@"accountNumberColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

/**
 首页人民币文字颜色
 
 @return  首页人民币文字颜色
 */
+ (UIColor *)homeCnyTitleColor{
    NSString *colorStr = CCCCurrentTheme[@"HomeProperty"][@"cnyTitleColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

/**
 首页人民币金额颜色
 
 @return  首页人民币金额颜色
 */
+ (UIColor *)homeCnyMoneyColor{
    NSString *colorStr = CCCCurrentTheme[@"HomeProperty"][@"cnyMoneyColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

/**
 首页USD文字颜色
 
 @return  首页USD文字颜色
 */
+ (UIColor *)homeUsdTitleColor{
    NSString *colorStr = CCCCurrentTheme[@"HomeProperty"][@"usdTitleColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

/**
 首页USD金额颜色
 
 @return  首页USD金额颜色
 */
+ (UIColor *)homeUsdMoneyColor{
    NSString *colorStr = CCCCurrentTheme[@"HomeProperty"][@"usdMoneyColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}


/**
 首页分割线颜色

 @return 首页分割线颜色
 */
+ (UIColor *)homeSplitLineColor{
    NSString *colorStr = CCCCurrentTheme[@"HomeProperty"][@"splitLineColor"];
    UIColor * color = [self caculateColor:colorStr];
    return color;
}

#pragma mark -我的页面颜色




@end
