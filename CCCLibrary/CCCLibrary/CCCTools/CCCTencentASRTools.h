//
//  CCCTencentASRTools.h
//  CCCAddLib
//
//  Created by 财资赢-iOS on 2019/3/14.
//  Copyright © 2019年 hechong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^VoiceResult)(NSString *resultValue);

@interface CCCTencentASRTools : UIView

@property(nonatomic,strong) VoiceResult resultBlock;


+ (instancetype)sharedInstance;

- (void)presentDetectionView;

@end

NS_ASSUME_NONNULL_END
