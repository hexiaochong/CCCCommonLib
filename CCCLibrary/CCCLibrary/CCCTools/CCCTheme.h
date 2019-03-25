//
//  CCCTheme.h
//  CCCAddLib
//
//  Created by 财资赢-iOS on 2019/3/22.
//  Copyright © 2019年 hechong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSInteger {
    CCCDefaultTheme,//默认皮肤
    CCCSexyTheme,   //性感皮肤
    CCCGoldenTheme, //白金皮肤
} CCCThemeType;


@interface CCCTheme : NSObject

+ (instancetype)sharedInstance;

+ (void)setTheme:(CCCThemeType)themeType;

/**
 基础文本颜色值
 
 @return 返回基础文本颜色值
 */
+ (UIColor *)baseTextColor;

/**
 input文本颜色值
 
 @return 返回input文本颜色值
 */
+ (UIColor *)inputTextColor;

/**
 inputHolder文本颜色值
 
 @return 返回inputHolder文本颜色值
 */
+ (UIColor *)inputHolderColor;

/**
 提交按钮背景颜色值
 
 @return 返回submitBtnBgColor文本颜色值
 */
+ (UIColor *)submitBtnBgColor;

/**
 提交按钮文字颜色值
 
 @return 返回submitBtnTextColor文本颜色值
 */
+ (UIColor *)submitBtnTextColor;

/**
 导航栏文字颜色值
 
 @return 返回navBarTitleColor文本颜色值
 */
+ (UIColor *)navBarTitleColor;

/**
 导航栏背景颜色值
 
 @return 返回navBarBgColor文本颜色值
 */
+ (UIColor *)navBarBgColor;

/**
 基础字体
 
 @return 返回基础字体
 */
+ (UIFont *)baseFont;

/**
 基础大字体
 
 @return 返回基础大字体
 */
+ (UIFont *)baseBigFont;

/**
 基础小字体
 
 @return 返回基础小字体
 */
+ (UIFont *)baseSmallFont;









@end

NS_ASSUME_NONNULL_END
