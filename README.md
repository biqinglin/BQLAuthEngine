# BQLAuthEngine
完整版的三方分享工具，包括了QQ、微信、以及微博的登录分享功能

有什么问题可以进群：612756901
```
/**
 QQ登录
 
 @param success 成功回调(用户信息)
 
 @param failure 失败回调
 
 */
 
- (void)auth_qq_login:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
```
/**
 QQ分享文本(仅支持分享至好友)
 
 @param model 分享模型(model.text)
 
 @param success 成功回调
 
 @param failure 失败回调
 
 */
 
 - (void)auth_qq_share_text:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
```
/**
 QQ分享图片(仅支持分享至好友，可接收有效参数：model.title、model.describe)
 
 @param model 分享模型
 
 @param success 成功回调
 
 @param failure 失败回调
 
 */
- (void)auth_qq_share_image:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
```
/**
 QQ分享链接
 
 @param model 分享模型(model.urlString必填，可接收有效参数：model.title、model.describe、model.previewImage或者model.previewUrlString)
 
 @param scene 分享目标(好友、空间)
 
 @param success 成功回调
 
 @param failure 失败回调
 
 */
- (void)auth_qq_share_link:(BQLShareModel *)model scene:(QQShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
```
/**
 微信登录
 
 @param success 成功回调
 
 @param failure 失败回调
 
 */
- (void)auth_wechat_login:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
```
/**
 微信文本分享
 
 @param model 分享模型
 
 @param scene 分享目标(好友、朋友圈、收藏)
 
 @param success 成功回调
 
 @param failure 失败回调
 
 */
- (void)auth_wechat_share_text:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
```
/**
 微信图片分享
 
 @param model 分享模型(取model.image注意的是：image不能超过10M，可接收有效参数：model.previewImage)
 
 @param scene 分享目标(好友、朋友圈、收藏)
 
 @param success 成功回调
 
 @param failure 失败回调
 
 */
- (void)auth_wechat_share_image:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
```
/**
 微信链接分享
 
 @param model 分享模型(model.urlString，可接收有效参数：model.title、model.describe、model.previewImage)
 
 @param scene 分享目标(好友、朋友圈、收藏)
 
 @param success 成功回调
 
 @param failure 失败回调
 
 */
- (void)auth_wechat_share_link:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
```
/**
 微信音乐分享
 
 @param model 分享模型(model.urlString必填，可接收有效参数：model.title、model.describe、model.previewImage)
 
 @param scene 分享目标(好友、朋友圈、收藏)
 
 @param success 成功回调
 
 @param failure 失败回调
 
 */
- (void)auth_wechat_share_music:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
```
/**
 微信视频分享
 
 @param model 分享模型(model.urlString必填，可接收有效参数：model.title、model.describe、model.previewImage)
 
 @param scene 分享目标(好友、朋友圈、收藏)
 
 @param success 成功回调
 
 @param failure 失败回调
 
 */
- (void)auth_wechat_share_video:(BQLShareModel *)model scene:(WechatShareScene )scene success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
```
/**
 微博登录
 
 @param success 成功回调
 
 @param failure 失败回调
 
 */
- (void)auth_sina_login:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
```
/**
 微博文本分享
 
 @param model 分享模型(model.text)
 
 @param success 成功回调
 
 @param failure 失败回调
 
 */
- (void)auth_sina_share_text:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
```
/**
 微博链接分享
 
 @param model 分享模型(model.urlString必填，可接收有效参数：model.text、model.image)
 
 @param success 成功回调
 
 @param failure 失败回调
 
 */
- (void)auth_sina_share_link:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
```
/**
 微博图片分享
 
 @param model 分享模型(model.image必填 不得超过10M)
 
 @param success 成功回调
 
 @param failure 失败回调
 
 */
- (void)auth_sina_share_image:(BQLShareModel *)model success:(BQLAuthSuccessBlock)success failure:(BQLAuthFailureBlock)failure;
```
