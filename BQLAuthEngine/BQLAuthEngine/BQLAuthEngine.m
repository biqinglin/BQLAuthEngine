//
//  BQLAuthEngine.m
//  LLFinance
//
//  Created by biqinglin on 2017/3/9.
//  Copyright © 2017年 biqinglin. All rights reserved.
//

#import "BQLAuthEngine.h"

@interface BQLAuthEngine () <WBHttpRequestDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) BQLAuthSuccessBlock successBlock;
@property (nonatomic, strong) BQLAuthFailureBlock failureBlock;

@end

@implementation BQLAuthEngine


+ (void)initialize {
    
    BQLAuthEngine *engine = [BQLAuthEngine sharedAuthEngine];
    engine.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPID andDelegate:engine];
    // 微信注册授权
    [WXApi registerApp:WECHAT_APPID];
    // 微博注册授权(开启调试模式，可查看打印日志)
#ifdef DEBUG
    [WeiboSDK enableDebugMode:YES];
#else
    [WeiboSDK enableDebugMode:NO];
#endif
    [WeiboSDK registerApp:SINA_APPKEY];
}

+ (instancetype)sharedAuthEngine {
    static BQLAuthEngine *s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        s = [BQLAuthEngine new];
    });
    return s;
}

+ (BOOL)isWXAppInstalled {
    return [WXApi isWXAppInstalled];;
}

+ (BOOL)isQQInstalled {
    
    return [QQApiInterface isQQInstalled];
}

+ (BOOL)isWeiboAppInstalled {
    
    return [WeiboSDK isWeiboAppInstalled];
}

+ (BOOL)isCanShareInWeiboAPP {
    
    return [WeiboSDK isCanShareInWeiboAPP];
}

- (NSString *)qq_open_id {
    if(authReadFromPlist(@"qq_open_id")) {
        return authReadFromPlist(@"qq_open_id");
    }
    return @"";
}

- (NSString *)qq_token {
    if(authReadFromPlist(@"qq_token")) {
        return authReadFromPlist(@"qq_token");
    }
    return @"";
}

- (NSString *)wechat_open_id {
    if(authReadFromPlist(@"wechat_open_id")) {
        return authReadFromPlist(@"wechat_open_id");
    }
    return @"";
}

- (NSString *)wechat_token {
    if(authReadFromPlist(@"wechat_token")) {
        return authReadFromPlist(@"wechat_token");
    }
    return @"";
}

- (NSString *)weibo_open_id {
    if(authReadFromPlist(@"weibo_open_id")) {
        return authReadFromPlist(@"weibo_open_id");
    }
    return @"";
}

- (NSString *)weibo_token {
    if(authReadFromPlist(@"weibo_token")) {
        return authReadFromPlist(@"weibo_token");
    }
    return @"";
}

- (NSString *)weibo_expirationDate {
    if(authReadFromPlist(@"weibo_expirationDate")) {
        return authReadFromPlist(@"weibo_expirationDate");
    }
    return @"";
}

- (void)auth_qq_login:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    self.successBlock = success;
    self.failureBlock = failure;
    [_tencentOAuth authorize:@[@"get_user_info", @"get_simple_userinfo", @"add_t"]];
}

- (void)auth_qq_share_text:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    self.successBlock = success;
    self.failureBlock = failure;
    if(NotNilAndNull(model.text)) {
        QQApiTextObject *textObject = [QQApiTextObject objectWithText:model.text];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:textObject];
        [QQApiInterface sendReq:req];
    }
    else {
        NSString *error = [NSString stringWithFormat:@"%@：分享文本缺失,请填写model.text",stringWithAuthErrorCode(AuthErrorCodeParameterEmpty)];
        self.failureBlock?self.failureBlock(error):nil;
    }
}

- (void)auth_qq_share_image:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    self.successBlock = success;
    self.failureBlock = failure;
    if(NotNilAndNull(model.image)) {
        
        QQApiImageObject *imageObject = [QQApiImageObject objectWithData:UIImagePNGRepresentation(model.image) previewImageData:UIImagePNGRepresentation(model.previewImage) title:model.title description:model.describe];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imageObject];
        [QQApiInterface sendReq:req];
    }
    else {
        NSString *error = [NSString stringWithFormat:@"%@：分享图片缺失,请填写model.image",stringWithAuthErrorCode(AuthErrorCodeParameterEmpty)];
        self.failureBlock?self.failureBlock(error):nil;
    }
}

- (void)auth_qq_share_link:(BQLShareModel *)model scene:(QQShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    self.successBlock = success;
    self.failureBlock = failure;
    if(NotNilAndNull(model.urlString)) {
        QQApiNewsObject *newsObject = nil;
        if(NotNilAndNull(model.previewUrlString)) {
            newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:model.urlString] title:model.title description:model.describe previewImageURL:[NSURL URLWithString:model.previewUrlString]];
        }
        else {
            if (NotNilAndNull(model.previewImage)) {
                newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:model.urlString] title:model.title description:model.describe previewImageData:UIImagePNGRepresentation(model.previewImage)];
            }
            else {
                newsObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:model.urlString] title:model.title description:model.describe previewImageURL:nil];
            }
        }
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObject];
        QQApiSendResultCode sent;
        switch (scene) {
            case QQShareSceneSession:
                sent = [QQApiInterface sendReq:req];
                break;
            case QQShareSceneZone:
                sent = [QQApiInterface SendReqToQZone:req];
                break;
            default:
                break;
        }
        [QQApiInterface sendReq:req];
    }
    else {
        NSString *error = [NSString stringWithFormat:@"%@：分享链接地址缺失,请填写model.urlString",stringWithAuthErrorCode(AuthErrorCodeParameterEmpty)];
        self.failureBlock?self.failureBlock(error):nil;
    }
}

- (void)handleSendResult:(QQApiSendResultCode )code {
}

#pragma mark - tencentDelegate
- (void)tencentDidLogin {
    
    if(self.tencentOAuth.accessToken && 0 != self.tencentOAuth.accessToken.length) {
        authWriteToPlist(self.tencentOAuth.accessToken, @"qq_token");
        authWriteToPlist(self.tencentOAuth.openId, @"qq_open_id");
        if(![self.tencentOAuth getUserInfo]) {
            self.failureBlock?self.failureBlock(AuthErrorCodeCommon):nil;
        }
    }
    else {
        self.failureBlock?self.failureBlock(stringWithAuthErrorCode(AuthErrorCodeAuthDeny)):nil;
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    self.failureBlock?self.failureBlock(cancelled?stringWithAuthErrorCode(AuthErrorCodeUserCancel):stringWithAuthErrorCode(AuthErrorCodeAuthDeny)):nil;
}

- (void)tencentDidNotNetWork {
    self.failureBlock?self.failureBlock(stringWithAuthErrorCode(AuthErrorCodeNoNetWork)):nil;
}

- (void)getUserInfoResponse:(APIResponse *)response {
    self.successBlock?self.successBlock(response.jsonResponse):nil;
}

- (void)auth_wechat_login:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    self.successBlock = success;
    self.failureBlock = failure;
    SendAuthReq *req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    // 这个字符串你最好使用加密算法得到,这里我是乱写的,功能无影响
    req.state = @"qwertyuioplkjhgfdsazxcvbnm";
    [WXApi sendReq:req];
}

- (void)auth_wechat_share_text:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    self.successBlock = success;
    self.failureBlock = failure;
    if(NotNilAndNull(model.text)) {
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.text = model.text;
        req.bText = YES;
        req.scene = scene;
        [WXApi sendReq:req];
    }
    else {
        NSString *error = [NSString stringWithFormat:@"%@：分享文本缺失,请填写model.text",stringWithAuthErrorCode(AuthErrorCodeParameterEmpty)];
        self.failureBlock?self.failureBlock(error):nil;
    }
}

- (void)auth_wechat_share_image:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    self.successBlock = success;
    self.failureBlock = failure;
    if(NotNilAndNull(model.image)) {
        
        WXMediaMessage *message = [WXMediaMessage message];
        if(NotNilAndNull(model.previewImage)) {
            // model.previewImage不得超过32K
            [message setThumbImage:model.previewImage];
        }
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = UIImagePNGRepresentation(model.image);
        message.mediaObject = imageObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.message = message;
        req.bText = NO;
        req.scene = scene;
        [WXApi sendReq:req];
    }
    else {
        NSString *error = [NSString stringWithFormat:@"%@：分享图片缺失,请填写model.image",stringWithAuthErrorCode(AuthErrorCodeParameterEmpty)];
        self.failureBlock?self.failureBlock(error):nil;
    }
}

- (void)auth_wechat_share_link:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    self.successBlock = success;
    self.failureBlock = failure;
    if(NotNilAndNull(model.urlString)) {
        WXMediaMessage *message = [WXMediaMessage message];
        NotNilAndNull(model.title)?message.title = model.title:nil;
        NotNilAndNull(model.describe)?message.description = model.describe:nil;
        NotNilAndNull(model.previewImage)?[message setThumbImage:model.previewImage]:nil;
        WXWebpageObject *linkObject = [WXWebpageObject object];
        linkObject.webpageUrl = model.urlString;
        message.mediaObject = linkObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        [WXApi sendReq:req];
    }
    else {
        NSString *error = [NSString stringWithFormat:@"%@：分享链接缺失,请填写model.urlString",stringWithAuthErrorCode(AuthErrorCodeParameterEmpty)];
        self.failureBlock?self.failureBlock(error):nil;
    }
}

- (void)auth_wechat_share_music:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    self.successBlock = success;
    self.failureBlock = failure;
    if(NotNilAndNull(model.urlString)) {
        WXMediaMessage *message = [WXMediaMessage message];
        NotNilAndNull(model.title)?message.title = model.title:nil;
        NotNilAndNull(model.describe)?message.description = model.describe:nil;
        NotNilAndNull(model.previewImage)?[message setThumbImage:model.previewImage]:nil;
        WXMusicObject *musicObject = [WXMusicObject object];
        musicObject.musicUrl = model.urlString;
        message.mediaObject = musicObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        [WXApi sendReq:req];
    }
    else {
        NSString *error = [NSString stringWithFormat:@"%@：分享链接缺失,请填写model.urlString",stringWithAuthErrorCode(AuthErrorCodeParameterEmpty)];
        self.failureBlock?self.failureBlock(error):nil;
    }
}

- (void)auth_wechat_share_video:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    self.successBlock = success;
    self.failureBlock = failure;
    if(NotNilAndNull(model.urlString)) {
        WXMediaMessage *message = [WXMediaMessage message];
        NotNilAndNull(model.title)?message.title = model.title:nil;
        NotNilAndNull(model.describe)?message.description = model.describe:nil;
        NotNilAndNull(model.previewImage)?[message setThumbImage:model.previewImage]:nil;
        WXVideoObject *videoObject = [WXVideoObject object];
        videoObject.videoUrl = model.urlString;
        message.mediaObject = videoObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        [WXApi sendReq:req];
    }
    else {
        NSString *error = [NSString stringWithFormat:@"%@：分享链接缺失,请填写model.urlString",stringWithAuthErrorCode(AuthErrorCodeParameterEmpty)];
        self.failureBlock?self.failureBlock(error):nil;
    }
}

#pragma mark - wechatDelegate
/*
 在这里接收微信返回的状态（成功或者失败）
 以此进行相应的回应操作如：登陆成功进入APP、提示用户分享成功或者失败etc
 
 当然你可以不做任何操作不会报错（用户体验不敢想象- - ~！）
 */
-(void)onResp:(BaseResp *)resp {
    
    // 回应有2种：1：授权登陆回应 2：分享回应
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        // 授权登陆回应
        [self completeAuth:(SendAuthResp*)resp];
    }
    else if ([resp isKindOfClass:[SendMessageToWXResp class]] || [resp isKindOfClass:[SendMessageToQQResp class]]) {
        // 分享回应
        [self completeShare:resp];
    }
    else {
        // 当做失败处理
        self.failureBlock?self.failureBlock(stringWithAuthErrorCode(AuthErrorCodeCommon)):nil;
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {
}

- (void)onReq:(QQBaseReq *)req {
}

// 授权登陆操作：获取code、access_token、openid、userinfo
- (void)completeAuth:(SendAuthResp *)resp {
    
    // 获取code
    NSString *code = resp.code;
    // 拼接获取token url
    NSURL *getTokenUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WECHAT_APPID,WECHAT_APPSECRET,code]];
    // 获取access_token
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSURLSessionDataTask *access_tokenTask = [session dataTaskWithURL:getTokenUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(!error) {
            
            // 响应状态代码为200，代表请求数据成功，判断成功后我们再进行数据解析
            NSHTTPURLResponse *access_tokenHttpResp = (NSHTTPURLResponse*) response;
            if (access_tokenHttpResp.statusCode == 200) {
                
                NSError *access_tokenError;
                //解析NSData数据
                NSDictionary *access_tokenJSON =
                [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingAllowFragments
                                                  error:&access_tokenError];
                if (!access_tokenError) {
                    
                    // 记录access_token 和 openid
                    NSString *access_token = access_tokenJSON[@"access_token"];
                    NSString *openid = access_tokenJSON[@"openid"];
                    authWriteToPlist(access_token, @"wechat_token");
                    authWriteToPlist(openid, @"wechat_open_id");
                    NSURL *getUserInfoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid]];
                    
                    NSURLSessionDataTask *userInfoTask = [session dataTaskWithURL:getUserInfoUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        
                        NSDictionary *userInfoJSON =
                        [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:nil];
                        self.successBlock?self.successBlock(userInfoJSON):nil;
                    }];
                    [userInfoTask resume];
                }
                else {
                    self.failureBlock?self.failureBlock(error.description):nil;
                }
            }
            else {
                self.failureBlock?self.failureBlock(error.description):nil;
            }
        }
        else {
            self.failureBlock?self.failureBlock(error.description):nil;
        }
    }];
    [access_tokenTask resume];
}

// 完成分享操作(分享成功、分享失败)
- (void)completeShare:(SendMessageToWXResp *)resp {
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *result = (SendMessageToWXResp *)resp;
        if (result.errCode == 0) {
            self.successBlock?self.successBlock(@(resp.errCode)):nil;
        }
        else {
            self.failureBlock?self.failureBlock(stringWithAuthErrorCode(AuthErrorCodeCommon)):nil;
        }
        return;
    }
    else if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        SendMessageToQQResp *result = (SendMessageToQQResp *)resp;
        if ([result.result isEqualToString:@"0"]) {
            self.successBlock?self.successBlock(result.result):nil;
        }
        else {
            self.failureBlock?self.failureBlock(stringWithAuthErrorCode(AuthErrorCodeCommon)):nil;
        }
        return;
    }
    self.failureBlock?self.failureBlock(stringWithAuthErrorCode(AuthErrorCodeCommon)):nil;
}

#pragma weibo delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        
        NSLog(@"1登陆成功返回用户信息:%@",(NSDictionary *)response.requestUserInfo);
        NSLog(@"2登陆成功返回用户信息:%@",(NSDictionary *)response.userInfo);
        // 记录accessToken、userID、expirationDate
        authWriteToPlist([(WBAuthorizeResponse *)response userID], @"weibo_open_id");
        authWriteToPlist([(WBAuthorizeResponse *)response accessToken], @"weibo_token");
        authWriteToPlist([(WBAuthorizeResponse *)response expirationDate], @"weibo_expirationDate");
        [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:@{@"access_token":[(WBAuthorizeResponse *)response accessToken],@"uid":(NSDictionary *)response.userInfo[@"uid"]} delegate:self withTag:@"0318"];
    }
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        if (response.statusCode == 0) {
            
            NSLog(@"分享成功");
            self.successBlock?self.successBlock(@"微博分享成功~"):nil;
        }
        else {
            NSLog(@"分享失败");
            self.failureBlock?self.failureBlock([NSString stringWithFormat:@"请参考有文件中的微博错误码:%ld",response.statusCode]):nil;
        }
    }
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
    
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if(userInfo) {
        self.successBlock?self.successBlock(userInfo):nil;
    }
    else {
        self.failureBlock?self.failureBlock(@"未得到微博回应"):nil;
    }
}

- (void)auth_sina_login:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    self.successBlock = success;
    self.failureBlock = failure;
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = SINA_REDIRECTURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

- (void)auth_sina_share_text:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    if([[self class] isCanShareInWeiboAPP]) {
        self.successBlock = success;
        self.failureBlock = failure;
        if(NotNilAndNull(model.text)) {
            WBMessageObject *message = [WBMessageObject message];
            message.text = model.text;
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
            [WeiboSDK sendRequest:request];
        }
        else {
            NSString *error = [NSString stringWithFormat:@"%@：分享文本缺失,请填写model.text",stringWithAuthErrorCode(AuthErrorCodeParameterEmpty)];
            self.failureBlock?self.failureBlock(error):nil;
        }
    }
    else {
        self.failureBlock?self.failureBlock(stringWithAuthErrorCode(AuthErrorCodeNoWeiBoApp)):nil;
    }
}

- (void)auth_sina_share_link:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    if([[self class] isCanShareInWeiboAPP]) {
        self.successBlock = success;
        self.failureBlock = failure;
        if(NotNilAndNull(model.urlString)) {
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
            authRequest.scope = @"all";
            WBMessageObject *message = [WBMessageObject message];
            NotNilAndNull(model.text)?message.text = [NSString stringWithFormat:@"%@ %@",model.text,model.urlString]:(message.text = model.urlString);
            if(NotNilAndNull(model.image)) {
                WBImageObject *imageObject = [WBImageObject object];
                imageObject.imageData = UIImagePNGRepresentation(model.image);
                message.imageObject = imageObject;
            }
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
            [WeiboSDK sendRequest:request];
        }
        else {
            NSString *error = [NSString stringWithFormat:@"%@：分享链接缺失,请填写model.urlString",stringWithAuthErrorCode(AuthErrorCodeParameterEmpty)];
            self.failureBlock?self.failureBlock(error):nil;
        }
    }
    else {
        self.failureBlock?self.failureBlock(stringWithAuthErrorCode(AuthErrorCodeNoWeiBoApp)):nil;
    }
}

- (void)auth_sina_share_image:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure {
    
    if([[self class] isCanShareInWeiboAPP]) {
        self.successBlock = success;
        self.failureBlock = failure;
        if(NotNilAndNull(model.image)) {
            WBMessageObject *message = [WBMessageObject message];
            NotNilAndNull(model.text)?message.text = model.text:nil;
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData = UIImagePNGRepresentation(model.image);
            message.imageObject = imageObject;
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
            [WeiboSDK sendRequest:request];
        }
        else {
            NSString *error = [NSString stringWithFormat:@"%@：分享图片缺失,请填写model.image",stringWithAuthErrorCode(AuthErrorCodeParameterEmpty)];
            self.failureBlock?self.failureBlock(error):nil;
        }
    }
    else {
        self.failureBlock?self.failureBlock(stringWithAuthErrorCode(AuthErrorCodeNoWeiBoApp)):nil;
    }
}

BOOL authWriteToPlist(id value, NSString *key) {
    
    if(value) {
        [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
        return [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return NO;
}

id authReadFromPlist(NSString *key) {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

NSString *stringWithAuthErrorCode(AuthErrorCode code) {
    
    switch (code) {
        case AuthErrorCodeCommon:
            return @"通用错误";
            break;
        case AuthErrorCodeAuthDeny:
            return @"授权失败";
            break;
        case AuthErrorCodeUserCancel:
            return @"用户取消";
            break;
        case AuthErrorCodeSendFail:
            return @"发送失败";
            break;
        case AuthErrorCodeUnKnow:
            return @"未知错误";
            break;
        case AuthErrorCodeNoNetWork:
            return @"没有网络";
            break;
        case AuthErrorCodeParameterEmpty:
            return @"分享某些参数缺失";
            break;
        case AuthErrorCodeNoWeiBoApp:
            return @"没有安装微博客户端，无法进行分享操作";
            break;
            
        default:
            return @"other error";
            break;
    }
}




@end
