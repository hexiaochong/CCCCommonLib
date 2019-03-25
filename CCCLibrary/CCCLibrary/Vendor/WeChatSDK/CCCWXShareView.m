//
//  CCCWXShareView.m
//  CCCWXShare
//
//  Created by 财资赢-iOS on 2019/3/11.
//  Copyright © 2019年 xujiangfei. All rights reserved.
//

#import "CCCWXShareView.h"
#import "Masonry.h"
#import "CCCAppInfoTools.h"
#import "WXApi.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "WechatAuthSDK.h"
#import "UIAlertView+WX.h"

#define CCCWXShareScreenWidth [UIScreen mainScreen].bounds.size.width
#define CCCWXShareScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CCCWXShareView()<WXApiManagerDelegate>

@property(nonatomic,strong) NSMutableDictionary *shareInfo;


@property(nonatomic,strong) UIView *shareView;
@end

@implementation CCCWXShareView

+ (instancetype)sharedInstance {
    static CCCWXShareView *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}


- (void)presentShareViewWithInfo:(NSDictionary *)shareInfo{
    self.frame = CGRectMake(0, CCCWXShareScreenHeight, CCCWXShareScreenWidth, 170);
    
    __weak typeof(self) weakSelf = self;
    
    self.shareInfo = [[NSMutableDictionary alloc] initWithDictionary:shareInfo];
    
    self.shareView  = [[UIView alloc] init];
    self.shareView.userInteractionEnabled = YES;
    self.shareView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
    [self addSubview:self.shareView];
    
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(170.0);
    }];
    
    UIButton *shareWX = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareWX setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [shareWX setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateHighlighted];
    [shareWX addTarget:self action:@selector(wxShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:shareWX];
    
    [shareWX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(58, 58));
        make.left.offset((self.frame.size.width-58*2)/3);
        make.top.equalTo(weakSelf.shareView.mas_top).with.offset(21);
    }];
    
    UIButton *sharePYQ = [UIButton buttonWithType:UIButtonTypeCustom];
    [sharePYQ setImage:[UIImage imageNamed:@"weixinq"] forState:UIControlStateNormal];
    [sharePYQ setImage:[UIImage imageNamed:@"weixinq"] forState:UIControlStateHighlighted];
    [sharePYQ addTarget:self action:@selector(pyqShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:sharePYQ];
    
    [sharePYQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(58, 58));
        make.right.equalTo(weakSelf.shareView.mas_right).offset(-(self.frame.size.width-58*2)/3);
        make.top.equalTo(weakSelf.shareView.mas_top).with.offset(21);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消分享" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:cancelBtn];
    
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(45.0);
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
        self.frame = CGRectMake(0, CCCWXShareScreenHeight-170, CCCWXShareScreenWidth, 170);
    } completion:^(BOOL finished) {
        
    }];
}


- (void)showCenterShare:(NSDictionary *)shareInfo{
    self.bounds = CGRectMake(0,0,CCCWXShareScreenWidth, 100);
    self.center = CGPointMake(CCCWXShareScreenWidth/2, CCCWXShareScreenHeight/2);
    self.alpha = 0;

    __weak typeof(self) weakSelf = self;
    
    self.shareInfo = [[NSMutableDictionary alloc] initWithDictionary:shareInfo];
    
    self.shareView  = [[UIView alloc] init];
    self.shareView.userInteractionEnabled = YES;
    self.shareView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.3];
    [self addSubview:self.shareView];
    
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(100.0);
    }];
    
    UIButton *shareWX = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareWX setImage:[UIImage imageNamed:@"sns_icon_22"] forState:UIControlStateNormal];
    [shareWX setImage:[UIImage imageNamed:@"sns_icon_22"] forState:UIControlStateHighlighted];
    [shareWX addTarget:self action:@selector(wxShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:shareWX];
    
    [shareWX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(58, 58));
        make.left.offset((self.frame.size.width-58*2)/3);
        make.top.equalTo(weakSelf.shareView.mas_top).with.offset(21);
    }];
    
    UIButton *sharePYQ = [UIButton buttonWithType:UIButtonTypeCustom];
    [sharePYQ setImage:[UIImage imageNamed:@"sns_icon_23"] forState:UIControlStateNormal];
    [sharePYQ setImage:[UIImage imageNamed:@"sns_icon_23"] forState:UIControlStateHighlighted];
    [sharePYQ addTarget:self action:@selector(pyqShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:sharePYQ];
    
    [sharePYQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(58, 58));
        make.right.equalTo(weakSelf.shareView.mas_right).offset(-(self.frame.size.width-58*2)/3);
        make.top.equalTo(weakSelf.shareView.mas_top).with.offset(21);
    }];
    
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelBtn setTitle:@"X" forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [cancelBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.shareView addSubview:cancelBtn];
//
//
//    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.offset(0);
//        make.top.mas_equalTo(100);
//        make.height.mas_equalTo(45.0);
//    }];
    
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if(keyWindow == nil){
        keyWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
        UIViewController *rooVC = [keyWindow rootViewController];
        [rooVC.view addSubview:self];
    }else{
        [keyWindow addSubview:self];
    }
    

    
    [UIView animateWithDuration:0.65 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}




/**
 取消操作
 */
- (void)cancelClick{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, CCCWXShareScreenHeight, CCCWXShareScreenWidth, 170);
    } completion:^(BOOL finished) {
        [self.shareView removeFromSuperview];
    }];
}


/**
 微信对话分享
 */
- (void)wxShare{
    
    NSString * shareLink   = self.shareInfo[@"shareLink"];

    [self.shareInfo setObject:@"0" forKey:@"scene"];

    if(shareLink.length>0){
        [self shareLinkUrl:self.shareInfo];
    }else{
        [self shareImage:self.shareInfo];
    }
    
}

/**
 朋友圈分享
 */
- (void)pyqShare{

    NSString * shareLink   = self.shareInfo[@"shareLink"];
    
    [self.shareInfo setObject:@"1" forKey:@"scene"];

    if(shareLink.length>0){
        [self shareLinkUrl:self.shareInfo];
    }else{
        [self shareImage:self.shareInfo];
    }
}

/**
 分享图片
 */

- (void)shareImage:(NSDictionary *)shareInfo{
    
    NSString * contentBaseStr  = shareInfo[@"shareImg"];//分享的图片
    NSString * thumbBaseStr  = shareInfo[@"thumImg"];//分享缩略图
    int sceneValue = [shareInfo[@"scene"] intValue];//分享场景
    
    NSData  *thumbImageData;//AppIcon
    
    if(thumbBaseStr){
        thumbImageData = [[NSData alloc] initWithBase64EncodedString:thumbBaseStr options:0];
    }
    
    UIImage *thumbImage;

    if(thumbImageData){
        thumbImage = [UIImage imageWithData:thumbImageData];
    }else{
        thumbImage = [UIImage imageNamed:@"headicon"];
    }
    
    NSData  *contentImageData;
    
    if(contentBaseStr){
        contentImageData = [[NSData alloc] initWithBase64EncodedString:contentBaseStr options:0];
    }else{
        
#ifdef DEBUG
        NSLog(@"分享图片为空");
#endif
        return;
    }
    
    
    [WXApiRequestHandler sendImageData:contentImageData
                               TagName:[CCCAppInfoTools appName]
                            MessageExt:[CCCAppInfoTools appName]
                                Action:@""
                            ThumbImage:nil
                               InScene:sceneValue];
}


/**
 分享链接
 */
- (void)shareLinkUrl:(NSDictionary *)shareInfo{
    
    NSString * title  = shareInfo[@"title"];
    NSString * description  = shareInfo[@"description"];
    NSString * urlLink   = shareInfo[@"shareLink"];
    NSString * thumbBaseStr  = shareInfo[@"thumImg"];
    int sceneValue = [shareInfo[@"scene"] intValue];
    
    if(title.length == 0){
        title = [CCCAppInfoTools appName];
    }
    
    if(description.length == 0){
        description = [CCCAppInfoTools appName];
    }
    
    if(urlLink.length == 0){
#ifdef DEBUG
        NSLog(@"分享链接为空");
#endif
    }
    
    NSData  *thumbImageData;//AppIcon
    
    if(thumbBaseStr){
        thumbImageData = [[NSData alloc] initWithBase64EncodedString:thumbBaseStr options:0];
    }
    
    UIImage *thumbImage;
    
    if(thumbImageData){
        thumbImage = [UIImage imageWithData:thumbImageData];
    }else{
        thumbImage = [UIImage imageNamed:@"headicon"];
    }
    
    
    [WXApiRequestHandler sendLinkURL:urlLink
                             TagName:title
                               Title:title
                         Description:description
                          ThumbImage:thumbImage
                             InScene:sceneValue];
    
}

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
    
    NSLog(@"发送媒体消息结果:%@,errcode:%@",strTitle,strMsg);
    
    if(self.shareResultBlock){
        self.shareResultBlock(response.errStr);
    }
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
