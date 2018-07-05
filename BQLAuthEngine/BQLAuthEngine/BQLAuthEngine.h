//
//  BQLAuthEngine.h
//  LLFinance
//
//  Created by biqinglin on 2017/3/9.
//  Copyright © 2017年 biqinglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "BQLShareModel.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

/**说明
 *  写在前面：
 *  这是小弟整理的使用原生SDK进行登录、分享操作的工具；不管好与不好，请尊重我的劳动成果，谢谢！
 *  联系方式：QQ931237936 欢迎指正错误或者交流学习(添加请备注IOS开发)
 
 *  最最开始的工作：当然是你要有申请好的各种秘钥啦（WXAppKey、WXAppSecret、QQAppID、QQAppKey etc）
 
 *  在你的info.plist文件加入以下代码:
 
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>mqqOpensdkSSoLogin</string>
        <string>mqzone</string>
        <string>sinaweibohd</string>
        <string>sinaweibo</string>
        <string>weibosdk</string>
        <string>weibosdk2.5</string>
        <string>alipayauth</string>
        <string>alipay</string>
        <string>safepay</string>
        <string>mqq</string>
        <string>mqqapi</string>
        <string>mqqopensdkapiV3</string>
        <string>mqqopensdkapiV2</string>
        <string>mqqapiwallet</string>
        <string>mqqwpa</string>
        <string>mqqbrowser</string>
        <string>wtloginmqq2</string>
        <string>weixin</string>
        <string>wechat</string>
	</array>
 
 *  下载QQ、微信官方SDK导入你的工程，建议微信也用pod管理，微信区分了有支付和无支付版本的SDK
    通过pod添加微博SDK：pod "WeiboSDK", :git => "https://github.com/sinaweibosdk/weibo_ios_sdk.git"
 
 *  添加依赖库：
        SystemConfiguration.framework
        CoreTelephony.framework
        CoreGraphics.Framework
        libsqlite3.tbd
        libz.tbd
        libstdc++.tbd
        libc++.tbd
        libiconv.tbd
        (注意：较老的版本后缀名为：dylib)
 
 *  在项目配置文件 -> info-URL Types添加相应的key(与在AppDelegate中的重写方法一致)
 
 *  重写AppDelegate方法：
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
 
        if ([url.scheme isEqualToString:[NSString stringWithFormat:@"%@",WECHAT_APPID]]) {
            return  [WXApi handleOpenURL:url delegate:[BQLAuthEngine sharedAuthEngine]];
        }
        else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",QQ_APPID]]) {
            return  [TencentOAuth HandleOpenURL:url];
        }
        else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"wb%@",SINA_APPKEY]]) {
            return [WeiboSDK handleOpenURL:url delegate:[BQLAuthEngine sharedAuthEngine]];
        }
        return YES;
 
    }
 
    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
 
        if ([url.scheme isEqualToString:[NSString stringWithFormat:@"%@",WECHAT_APPID]]) {
            return  [WXApi handleOpenURL:url delegate:[BQLAuthEngine sharedAuthEngine]];
        }
        else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",QQ_APPID]]) {
            return  [TencentOAuth HandleOpenURL:url];
        }
        else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"wb%@",SINA_APPKEY]]) {
            return [WeiboSDK handleOpenURL:url delegate:[BQLAuthEngine sharedAuthEngine]];
        }
        return YES;
    }
 
 *  在集成过程中可能会出现错误，定位到微信SDK中的某些头文件指向UIImage、UIViewController 等
    只需在该文件头加上：#import <UIKit/UIKit.h>即可
 
 *  新浪微博模块：
    注意SINA_REDIRECTURI的地址与你在新浪注册的应用信息-高级信息-QAuth授权信息填写一致，否则会报redirect_url_mismatch的错误
 
 *  这是本人空余时间整理的，难免有瑕疵，功能相较于官方的一定是不完整的，仅保证最常用情况下的功能。
    每一个注释我都很用心的去写
    每一个方法我都亲测无误
    如果demo对你有所帮助，给我个星星吧~~~感谢支持~！
 *  若仍有错请联系我QQ 931237936 备注:iOS开发
 
 **/


/****************************************Key、Id、Secret**********************************/
static NSString *const QQ_APPID = @"";
static NSString *const QQ_APPKEY = @"";

static NSString *const WECHAT_APPID = @"wx17e0268595a70fec";
static NSString *const WECHAT_APPSECRET = @"c6bc948879b51cbc47867236887ba01e";

static NSString *const SINA_APPKEY = @"";
static NSString *const SINA_APPSECRET = @"";
static NSString *const SINA_REDIRECTURI = @""; // 用于授权登录必填参数
static NSString *const SINA_OBJECTID = @""; // 用于多媒体分享时必填参数，为你的应用bundle id

/***************************************Error Code***************************************/
/*这只是个简单的错误码枚举，更详尽错误信息的请参考各SDK*/
typedef NS_ENUM(NSUInteger, AuthErrorCode) {
    
    AuthErrorCodeCommon = 0,        /**<通用错误>*/
    AuthErrorCodeAuthDeny,          /**<授权失败>*/
    AuthErrorCodeUserCancel,        /**<用户取消>*/
    AuthErrorCodeSendFail,          /**<发送失败>*/
    AuthErrorCodeUnKnow,            /**<未知错误>*/
    AuthErrorCodeNoNetWork,         /**<没有网络>*/
    AuthErrorCodeParameterEmpty,    /**<参数缺失>*/
    AuthErrorCodeNoWeiBoApp         /**<没有微博客户端>*/
};
/*微博错误码参照
 WeiboSDKResponseStatusCodeSuccess               = 0,//成功
 WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
 WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
 WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
 WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
 WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
 WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
 WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
 WeiboSDKResponseStatusCodeUnknown               = -100,
 */

/****************************************QQ分享目标类型*****************************************/
typedef NS_ENUM(NSUInteger, QQShareScene) {
    
    QQShareSceneSession,             /**<分享至好友>*/
    QQShareSceneZone                /**<分享至空间>*/
};

/****************************************微信分享目标类型****************************************/
typedef NS_ENUM(NSUInteger, WechatShareScene) {
    
    WechatShareSceneSession,        /**<分享至会话>*/
    WechatShareSceneTimeline,       /**<分享至朋友圈>*/
    WechatShareSceneFavorite        /**<分享至收藏>*/
};

/****************************************回调block****************************************/
typedef void(^BQLAuthSuccessBlock)(id response);
typedef void(^BQLAuthFailureBlock)(NSString *error);

@interface BQLAuthEngine : NSObject <TencentSessionDelegate,WXApiDelegate,QQApiInterfaceDelegate,WeiboSDKDelegate>

@property (nonatomic, readonly, copy) NSString *qq_open_id;
@property (nonatomic, readonly, copy) NSString *qq_token;
@property (nonatomic, readonly, copy) NSString *wechat_open_id;
@property (nonatomic, readonly, copy) NSString *wechat_token;
@property (nonatomic, readonly, copy) NSString *weibo_open_id;
@property (nonatomic, readonly, copy) NSString *weibo_token;
@property (nonatomic, readonly, copy) NSString *weibo_expirationDate; // 认证过期时间

+ (instancetype)sharedAuthEngine;

/**
 *  检测微信是否已安装
 */
+ (BOOL)isWXAppInstalled;

/**
 *  检测QQ是否已安装
 */
+ (BOOL)isQQInstalled;

/**
 *  检测微博是否已安装
 */
+ (BOOL)isWeiboAppInstalled;

/**
 *  检查用户是否可以通过微博客户端进行分享
 */
+ (BOOL)isCanShareInWeiboAPP;

/*****************************************QQ 模块*****************************************/
/**
 QQ登录
 
 @param success 成功回调(用户信息)
 @param failure 失败回调
 */
- (void)auth_qq_login:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

/**
 QQ分享文本(仅支持分享至好友)
 
 @param model 分享模型(model.text)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)auth_qq_share_text:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

/**
 QQ分享图片(仅支持分享至好友，可接收有效参数：model.title、model.describe)
 
 @param model 分享模型
 @param success 成功回调
 @param failure 失败回调
 */
- (void)auth_qq_share_image:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

/**
 QQ分享链接
 
 @param model 分享模型(model.urlString必填，可接收有效参数：model.title、model.describe、model.previewImage或者model.previewUrlString)
 @param scene 分享目标(好友、空间)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)auth_qq_share_link:(BQLShareModel *)model scene:(QQShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

/*****************************************Wechat 模块*************************************/
/**
 微信登录
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)auth_wechat_login:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

/**
 微信文本分享
 
 @param model 分享模型
 @param scene 分享目标(好友、朋友圈、收藏)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)auth_wechat_share_text:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

/**
 微信图片分享
 
 @param model 分享模型(取model.image注意的是：image不能超过10M，可接收有效参数：model.previewImage)
 @param scene 分享目标(好友、朋友圈、收藏)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)auth_wechat_share_image:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

/**
 微信链接分享
 
 @param model 分享模型(model.urlString，可接收有效参数：model.title、model.describe、model.previewImage)
 @param scene 分享目标(好友、朋友圈、收藏)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)auth_wechat_share_link:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

/**
 微信音乐分享
 
 @param model 分享模型(model.urlString必填，可接收有效参数：model.title、model.describe、model.previewImage)
 @param scene 分享目标(好友、朋友圈、收藏)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)auth_wechat_share_music:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

/**
 微信视频分享
 
 @param model 分享模型(model.urlString必填，可接收有效参数：model.title、model.describe、model.previewImage)
 @param scene 分享目标(好友、朋友圈、收藏)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)auth_wechat_share_video:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

/*****************************************Sina 模块***************************************/
/**
 微博登录
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)auth_sina_login:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

/**
 微博文本分享
 
 @param model 分享模型(model.text)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)auth_sina_share_text:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

/**
 微博链接分享
 
 @param model 分享模型(model.urlString必填，可接收有效参数：model.text、model.image)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)auth_sina_share_link:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

/**
 微博图片分享
 
 @param model 分享模型(model.image必填 不得超过10M)
 @param success 成功回调
 @param failure 失败回调
 */
- (void)auth_sina_share_image:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;

@end






