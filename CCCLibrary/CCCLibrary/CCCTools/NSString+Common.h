//
//  NSString+Common.h
//  MADPMainRootMenu
//
//  Created by TZ on 2017/8/16.
//  Copyright © 2017年 CSII. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Common)

/// 把该字符串转换为对应的md5
- (NSString *)md5Str;

/// 把该字符串进行URL编码
- (NSString *)stringByURLEncode;

/// 把该字符串进行URL解码
- (NSString *)stringByURLDecode;

/// 编码: ISO 8859-1
- (NSString *)unicodeISO88591;

- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
