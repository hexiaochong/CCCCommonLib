//
//  CCCWXShareView.h
//  CCCWXShare
//
//  Created by 财资赢-iOS on 2019/3/11.
//  Copyright © 2019年 xujiangfei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ShareResultCallback)(NSString * result);

@interface CCCWXShareView : UIView

@property(nonatomic,copy) ShareResultCallback shareResultBlock;

/**
 *  单例模式
 *
 *  @return 单例
 */
+ (instancetype) sharedInstance;


/**
 显示分享view

 @param shareInfo 分享信息包含以下字段
 
  分享链接：
  title 分享标题 默认“蓝橙邦”
  description 分享描述 默认“蓝橙邦”
  shareLink shareInfo中的分享链接
  thumImg   shareInfo中的分享缩略图Base64字符串
 
  分享图片：
  shareImg 分享图片的Base64字符串 必传选项
 
  公共参数：
  sceneValue 分享场景 0:微信对话分享 1:微信朋友圈分享 可选
 */
- (void)presentShareViewWithInfo:(NSDictionary *)shareInfo;

- (void)showCenterShare:(NSDictionary *)shareInfo;


/**
  分享图片 不显示分享选择view

@param shareInfo 分享信息包含以下字段
 
  shareImg 分享图片的Base64字符串 必传选项
  scene 分享场景 0:微信对话分享 1:微信朋友圈分享  默认为0
 
 */
- (void)shareImage:(NSDictionary *)shareInfo;

/**
  分享链接 不显示分享选择view
 
@param shareInfo 分享信息包含以下字段
 
  title 分享标题 默认“蓝橙邦”
  description 分享描述 默认“蓝橙邦”
  shareLink 分享链接 必传选项
  thumImg 分享缩略图（图片base64字符串） 默认不显示
  scene 分享场景 0:微信对话分享 1:微信朋友圈分享 默认为0
 */
- (void)shareLinkUrl:(NSDictionary *)shareInfo;


@end

NS_ASSUME_NONNULL_END
