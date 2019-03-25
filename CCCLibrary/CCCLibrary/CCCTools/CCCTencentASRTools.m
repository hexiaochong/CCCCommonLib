//
//  CCCTencentASRTools.m
//  CCCAddLib
//
//  Created by 财资赢-iOS on 2019/3/14.
//  Copyright © 2019年 hechong. All rights reserved.
//

#import "CCCTencentASRTools.h"
#import <AVFoundation/AVFoundation.h>
#import "CCCNativeNetwork.h"
#import "NSString+Common.h"

#import "GTMBase64.h"
#import "Masonry.h"

#define CCCASRScreenWidth [UIScreen mainScreen].bounds.size.width
#define CCCASRScreenHeight [UIScreen mainScreen].bounds.size.height


@interface CCCTencentASRTools (){
    AVAudioRecorder *recorder;
}

@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UILabel *tipLabel;
@property(nonatomic,strong) UIActivityIndicatorView * indicatorView ;

@end

@implementation CCCTencentASRTools


+ (instancetype)sharedInstance {
    static CCCTencentASRTools *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    [_sharedInstance openAuthority];
    
    return _sharedInstance;
}

- (void)openAuthority{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    AVCaptureSession* captureSession = [AVCaptureSession new];
    captureSession.usesApplicationAudioSession = NO;
    
//    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
}

- (void)presentDetectionView{
    self.frame = CGRectMake(0, CCCASRScreenHeight, CCCASRScreenWidth, 260);
    self.backgroundColor = [UIColor whiteColor];
    
    self.bgView  = [[UIView alloc] init];
    self.bgView.userInteractionEnabled = YES;
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.bottom.mas_equalTo(0);
    }];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"X" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
    [self.bgView addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.text = @"按住说话";
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.tipLabel setTextColor:[UIColor colorWithRed:111/255.0 green:172/255.0 blue:255/255.0 alpha:1]];
    [self.bgView addSubview:self.tipLabel];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    
    UIButton *ddcbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ddcbtn setImage:[UIImage imageNamed:@"语音输入按钮"] forState:UIControlStateNormal];
    [ddcbtn setImage:[UIImage imageNamed:@"语音输入按钮2"] forState:UIControlStateSelected];
    ddcbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [ddcbtn addTarget:self action:@selector(createVoiceManager:) forControlEvents:UIControlEventTouchDown];
    [ddcbtn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [ddcbtn addTarget:self action:@selector(dragExit:) forControlEvents:UIControlEventTouchDragExit];
    [self.bgView addSubview:ddcbtn];
    
    [ddcbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.bgView addSubview:self.indicatorView];
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    
    if(keyWindow == nil){
        keyWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
        UIViewController *rooVC = [keyWindow rootViewController];
        [rooVC.view addSubview:self];
    }else{
        [keyWindow addSubview:self];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, CCCASRScreenHeight-260, CCCASRScreenWidth, 260);
    } completion:^(BOOL finished) {
    }];
    
}

- (void)createVoiceManager:(UIButton *)sender{
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"record.wav"];
    NSURL *url = [NSURL URLWithString:path];
    
    NSError *error;
    
    // setting:录音的设置项
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    //设置录音格式 AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）, 采样率必须要设为11025才能使转化成mp3格式后不会失真
    [recordSetting setValue:[NSNumber numberWithFloat:16000] forKey:AVSampleRateKey];
    //录音通道数 1 或 2 ，要转换成mp3格式必须为双通道
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数 8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    // 设置录制音频采用高位优先的记录格式
    [recordSetting setValue:[NSNumber numberWithBool:YES] forKey:AVLinearPCMIsBigEndianKey];
    // 设置采样信号采用浮点数
    [recordSetting setValue:[NSNumber numberWithBool:YES] forKey:AVLinearPCMIsFloatKey];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    [recorder prepareToRecord];
    
    [recorder record];
    
}


/**
 取消操作
 */
- (void)cancelClick{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, CCCASRScreenHeight, CCCASRScreenWidth, 260);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self->recorder stop];

    }];
}



- (void)dragExit:(UIButton *)sender{
    NSLog(@"dragExit----------dragExit");
    [self showActivity];
    [recorder stop];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self queryTencentServer];
    });
    
}


- (void)touchUpInside:(UIButton *)sender{
    self.tipLabel.text = @"正在识别，请稍后...";
    
    NSLog(@"touchUpInside----------touchUpInside");
    [self showActivity];
    
    [recorder stop];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self queryTencentServer];
    });
    
}


- (void)showActivity{
    [self.indicatorView startAnimating];
}

- (void)stopAtivity{
    [self.indicatorView stopAnimating];
}


- (void)queryTencentServer{
    
    NSString *filePath = @"";// [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"record.wav"];
    filePath = [[NSBundle mainBundle] pathForResource:@"record" ofType:@"wav"];
    
    
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSString * fileBaseData = [GTMBase64 encodeBase64Data:fileData];
    // 文件的Base64码
//    NSString *fileBaseData = [fileData base64EncodedStringWithOptions:0];
//    fileBaseData = [fileBaseData stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//    fileBaseData = [fileBaseData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    fileBaseData = [fileBaseData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    
    // 设置请求数据
    NSString  *appkey = @"gYTAsVNSppMgxF1q";
    NSString  *time_stamp = [self timeStamp];
    NSString  *nonce_str = @"fa577ce340859f9fe";//[self getRandomStr];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"app_id":@"2113118795",
                                                                                  @"time_stamp":time_stamp,
                                                                                  @"nonce_str":nonce_str,
                                                                                  @"sign":@"",
                                                                                  }];
    [params setObject:@"2" forKey:@"format"];
    [params setObject:@"16000" forKey:@"rate"];
    [params setObject:fileBaseData forKey:@"speech"];
    
    NSString *signString = [self getReqSign:params appKey:appkey];

    [params setObject:signString forKey:@"sign"];

    NSLog(@"params:%@",params);
    
    [CCCNativeNetwork nativePostTransFullURL:@"https://api.ai.qq.com/fcgi-bin/aai/aai_asr" postDict:params success:^(NSDictionary * _Nonnull successResult) {
        
        NSLog(@"successResult:%@",successResult);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopAtivity];
            self.tipLabel.text = @"按住说话";

        });
    } failed:^(NSError * _Nonnull failedResult) {
        NSLog(@"failedResult:%@",[failedResult description]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopAtivity];
            self.tipLabel.text = @"按住说话";
        });
        
    }];
}

-(NSString *)getRandomStr{
    NSString *randomStr = @"";
    
    for (int i=0; i<10; i++) {
        NSString *charStr = [NSString stringWithFormat:@"%c",(char)('A' + (arc4random_uniform(26)))];
        randomStr = [NSString stringWithFormat:@"%@%@",randomStr,charStr];
    }
    
    return randomStr;
}


//获取时间戳
-(NSString *)timeStamp{
    UInt64 recordTime = [[NSDate date]timeIntervalSince1970];//*1000;
    return [NSString stringWithFormat:@"%llu",recordTime];
}

- (NSString *)getReqSign:(NSDictionary *)params appKey:(NSString *)appkey{
    
     // 1. 字典升序排序
    [params keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return obj1<obj2;
    }];
    
    // 2. 拼按URL键值对
    NSString *str = @"";
    
    for (int i=0; i<params.allKeys.count; i++) {
        NSString *keyStr = [params.allKeys objectAtIndex:i];
        NSString *valueStr = [params objectForKey:keyStr];
        NSString* valueStrEncodeValue;
        
        if(@available(iOS 9.0, *)) {
            valueStrEncodeValue = [valueStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
            
        }else {
            valueStrEncodeValue = [str stringByAddingPercentEscapesUsingEncoding:
                              NSUTF8StringEncoding];
        }
        
        if(valueStr.length>0 && keyStr.length>0 && i>0){
            str = [NSString stringWithFormat:@"%@&%@=%@",str,keyStr,valueStrEncodeValue];
        }else if(valueStr.length>0 && keyStr.length>0 && i==0){
            str = [NSString stringWithFormat:@"%@=%@",keyStr,valueStrEncodeValue];
        }
    }
    
    str = [NSString stringWithFormat:@"%@&app_key=%@",str,appkey];
    
    NSString *signStr = [[str md5Str] uppercaseString];

    
    return signStr;
}

@end
