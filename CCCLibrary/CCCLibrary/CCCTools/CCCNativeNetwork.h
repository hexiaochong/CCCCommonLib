//
//  CCCNativeNetwork.h
//  CCCAddLib
//
//  Created by 财资赢-iOS on 2019/3/16.
//  Copyright © 2019年 hechong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^NetworkSuccessResult) (NSDictionary *successResult);
typedef void (^NetworkFailedResult) (NSError *failedResult);

@interface CCCNativeNetwork : NSObject

/**
 发送POST请求

 @param transName 接口名称
 @param postDict  接口参数
 @param successBlock 成功回调函数
 @param failedBlock  失败回调函数
 */
+ (void)nativePostTransName:(NSString *)transName postDict:(NSDictionary *)postDict
                    success:(NetworkSuccessResult)successBlock failed:(NetworkFailedResult)failedBlock;


/**
 发送POST请求
 
 @param urlString 接口完整地址
 @param postDict  接口参数
 @param successBlock 成功回调函数
 @param failedBlock  失败回调函数
 */
+ (void)nativePostTransFullURL:(NSString *)urlString postDict:(NSDictionary *)postDict
                    success:(NetworkSuccessResult)successBlock failed:(NetworkFailedResult)failedBlock;

/**
 @brief 开始加密加密字符串解密
 */
+ (void)useDefaultEncrypt;


@end


typedef NSDictionary * (^CCCEncryptRequest)(id responseData);
typedef NSDictionary * (^CCCDecryptResponse)(id responseData);

@interface CCCNativeNetworkUtil : NSObject

@property (nonatomic, strong) CCCEncryptRequest encryptRequest;
@property (nonatomic, strong) CCCDecryptResponse decryptResponse;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
