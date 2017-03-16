//
//  BQLShareModel.h
//  BQLAuthEngine
//
//  Created by biqinglin on 2017/3/14.
//  Copyright © 2017年 biqinglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]) && ![_ref isEqual: @""] && ![_ref isEqual: @"<null>"])

@interface BQLShareModel : NSObject

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

/**
 分享文本(例如分享纯文本就传这个)
 */
@property (nonatomic, copy) NSString *text;

/**
 分享内容标题
 */
@property (nonatomic, copy) NSString *title;

/**
 分享内容描述
 */
@property (nonatomic, copy) NSString *describe;

/**
 分享目标图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 分享预览图(微信中不得超过32K)
 */
@property (nonatomic, strong) UIImage *previewImage;

/**
 分享目标链接(字符串,统一下就不提供NSURL类型的了)
 */
@property (nonatomic, copy) NSString *urlString;

/**
 分享目标链接的预览图链接地址(字符串,统一下就不提供NSURL类型的了)
 */
@property (nonatomic, copy) NSString *previewUrlString;


@end
