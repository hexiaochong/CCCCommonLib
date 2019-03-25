//
//  CCCNativeNetwork.m
//  CCCAddLib
//
//  Created by 财资赢-iOS on 2019/3/16.
//  Copyright © 2019年 hechong. All rights reserved.
//

#import "CCCNativeNetwork.h"

NSString *const kBaseUrl = @"https://www.csiimall.com/mobile";
NSString *const kSessionID = @"kSessionID";

//5.自定义高效率的 NSLog
#ifdef DEBUG
    #define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
    #define DEBUG_LOG(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
    #define NSLog(...)
    #define DEBUG_LOG(...)
#endif



@implementation CCCNativeNetwork


+ (void)nativePostTransName:(NSString *)transName postDict:(NSDictionary *)postDict
                    success:(NetworkSuccessResult)successBlock failed:(NetworkFailedResult)failedBlock{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kBaseUrl,transName];
    NSURL *postUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    
    // 请求方式
    request.HTTPMethod = @"POST";
    // 请求体
    request.HTTPBody = [CCCNativeNetwork parseParams:postDict];
    // 请求头
    NSString *sessionID = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionID];
    NSString *cookieStr = [NSString stringWithFormat:@"JSESSIONID=%@",sessionID];// 可以设置一下session，也可以添加其他的信息
    
    [request setValue:cookieStr forHTTPHeaderField:@"Cookie"];// 将sessionID设置进入cookie
    [request setValue:@"appliction/json;charset=UTF-8;" forHTTPHeaderField:@"Content-Type"];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:queue];
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error){
            if(failedBlock){
                dispatch_async(dispatch_get_main_queue(), ^{
                    failedBlock(error);
                });
                
            }else{
                DEBUG_LOG(@"%@",[error description]);
            }
        }else{
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if(httpResponse.statusCode >=200 && httpResponse.statusCode<300){
                NSDictionary *dic;
                if ([CCCNativeNetworkUtil sharedInstance].decryptResponse) {
                    dic = [self decryptResponse:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                } else {
                    dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                }
                
                if ([[dic[@"ResultCode"] description] isEqualToString:@"999999"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        DEBUG_LOG(@"%@", dic[@"ResultMsg"]);
                        return ;
                    });
                } else {
                    // '888888' 标识为session超时,清空session
                    if ([[dic[@"ResultCode"] description] isEqualToString:@"888888"]) {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSessionID];
                    }
                    
                    // 如果登录成功 设置存储JSESSIONID
                    if ([transName isEqualToString:@"login.do"]) {
                        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kBaseUrl, transName]]];//得到cookie
                        
                        NSString *JSESSIONID=@"";
                        for (NSHTTPCookie*cookie in cookies) {
                            if ([cookie.name isEqualToString:@"JSESSIONID"]) {
                                JSESSIONID=cookie.value;
                            }
                        }
                        
                        [[NSUserDefaults standardUserDefaults] setObject:JSESSIONID forKey:kSessionID];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    successBlock(dic);
                }
            }else{
                if(failedBlock){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failedBlock(error);
                    });
                    
                }else{
                    DEBUG_LOG(@"%@",[error description]);
                }
            }

        }
    }];

    [sessionTask resume];

}

+ (void)nativePostTransFullURL:(NSString *)urlString postDict:(NSDictionary *)postDict
                       success:(NetworkSuccessResult)successBlock failed:(NetworkFailedResult)failedBlock {
    NSURL *postUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl];
    
    // 请求方式
    request.HTTPMethod = @"POST";
    // 请求体
    request.HTTPBody = [CCCNativeNetwork parseParams:postDict];
    // 请求头
    NSString *sessionID = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionID];
    NSString *cookieStr = [NSString stringWithFormat:@"JSESSIONID=%@",sessionID];// 可以设置一下session，也可以添加其他的信息
    
    [request setValue:cookieStr forHTTPHeaderField:@"Cookie"];// 将sessionID设置进入cookie
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8;" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:queue];
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error){
            if(failedBlock){
                dispatch_async(dispatch_get_main_queue(), ^{
                    failedBlock(error);
                });
                
            }else{
                DEBUG_LOG(@"%@",[error description]);
            }
        }else{
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if(httpResponse.statusCode >=200 && httpResponse.statusCode<300){
                NSDictionary *dic;
                if ([CCCNativeNetworkUtil sharedInstance].decryptResponse) {
                    dic = [self decryptResponse:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                } else {
                    dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                }
                
                if ([[dic[@"ResultCode"] description] isEqualToString:@"999999"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        DEBUG_LOG(@"%@", dic[@"ResultMsg"]);
                        return ;
                    });
                } else {
                    // '888888' 标识为session超时,清空session
                    if ([[dic[@"ResultCode"] description] isEqualToString:@"888888"]) {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSessionID];
                    }
                    
                    // 如果登录成功 设置存储JSESSIONID
                    if ([urlString rangeOfString:@"login.do"].location != NSNotFound) {
                        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlString]]];//得到cookie
                        
                        NSString *JSESSIONID=@"";
                        for (NSHTTPCookie*cookie in cookies) {
                            if ([cookie.name isEqualToString:@"JSESSIONID"]) {
                                JSESSIONID=cookie.value;
                            }
                        }
                        
                        [[NSUserDefaults standardUserDefaults] setObject:JSESSIONID forKey:kSessionID];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    successBlock(dic);
                }
            }else{
                if(failedBlock){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failedBlock(error);
                    });
                    
                }else{
                    DEBUG_LOG(@"%@",[error description]);
                }
            }
            
        }
    }];
    
    [sessionTask resume];
}


#pragma mark - 对传入的请求参数 进行加密后拼接

+ (NSData *)parseParams:(id)params
{
    NSMutableDictionary *encryptDict = nil;
    if ([CCCNativeNetworkUtil sharedInstance].encryptRequest) {
        encryptDict = [NSMutableDictionary dictionaryWithDictionary:[CCCNativeNetworkUtil sharedInstance].encryptRequest(params)];
        [encryptDict setObject:@"APP" forKey:@"ChannelId"];
        [encryptDict setObject:@"Y" forKey:@"IsEncrypt"];
    } else {
        encryptDict = [NSMutableDictionary dictionaryWithDictionary:params];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:encryptDict options:NSJSONWritingPrettyPrinted error:nil];
    
    return data;
}

#pragma mark - 对返回的加密字符串解密

+ (NSDictionary *)decryptResponse:(id)response{
    NSMutableDictionary *decryptDict = nil;
    if ([CCCNativeNetworkUtil sharedInstance].decryptResponse) {
        decryptDict = [NSMutableDictionary dictionaryWithDictionary:[CCCNativeNetworkUtil sharedInstance].decryptResponse(response)];
    }
    return decryptDict;
}

#pragma mark - 开始加密加密字符串解密

+ (void)useDefaultEncrypt{
    
     [CCCNativeNetworkUtil sharedInstance].encryptRequest = ^NSDictionary *(id  _Nonnull responseData) {
     
//         NSString *paramsStr = [self convertToJsonData:responseData];
//         static dispatch_once_t onceToken;
//         dispatch_once(&onceToken, ^{
//             initialize(0, false);
//         });
//         NSData *JSONData = [paramsStr dataUsingEncoding:NSUTF8StringEncoding];
//         char *text  = (char*)[JSONData bytes];
//         char *key = "BAD455A747F2BAF2E456688BACCC962A63A3266A397CA266050F707D00B2B79A7399E4EF88FF8F4722A8E91B5415929B5E39F71B2ECA130AB1021F5E21D3725CE8DC1D13D03E538ECEF0E9DDCD2B0266A0B68F2B3D9E0CE2FC2E9B1C9A0D755CCED24631163537CE1E1F6001404E3B7FEB3143BF8885F9BD302ED0942CB31A15";
//         char *entery = getValue(text, key);
//
//         NSString *enterStr = [NSString stringWithCString:entery encoding:NSUTF8StringEncoding];
//         NSDictionary *argu = [NSDictionary dictionaryWithObjectsAndKeys:enterStr,@"Attribute", nil];
//         return argu;
//         };
//
//         [CCCNativeNetworkUtil sharedInstance].decryptResponse = ^NSDictionary *(id  _Nonnull responseData) {
//
//         NSString *filterStr = (NSString *)responseData;
//         const char *encrypStr = [filterStr UTF8String];
//         const char *unsign = decrypt_aes(encrypStr);
//         NSString *unsignStr = [NSString stringWithCString:unsign encoding:NSUTF8StringEncoding];
//         return [self dictionaryWithJsonString:unsignStr];
         
         return responseData;
     };
}

#pragma mark - jsonString转json

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - json转jsonString

+ (NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}


@end




@interface  CCCNativeNetworkUtil()

@end

@implementation CCCNativeNetworkUtil

+ (instancetype)sharedInstance{
    
    static CCCNativeNetworkUtil *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}


@end
