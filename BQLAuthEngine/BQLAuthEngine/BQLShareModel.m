//
//  BQLShareModel.m
//  BQLAuthEngine
//
//  Created by biqinglin on 2017/3/14.
//  Copyright © 2017年 biqinglin. All rights reserved.
//

#import "BQLShareModel.h"
#import <objc/runtime.h>

@implementation BQLShareModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    
    id obj = [[self alloc] init];
    for (NSString *originKey in dictionary.allKeys) {
        if ([[self getAllPropertyNames] containsObject:originKey]) {
            id value = dictionary[originKey];
            
            if ([value isKindOfClass:[NSNull class]]) {
                continue;
            }
            [obj setValue:value forKey:originKey];
        }
        else {
            continue;
        }
    }
    return obj;
}

+ (NSArray *)getAllPropertyNames {

    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++) {
        const char* char_f =property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    free(properties);
    return props;
}

// 预览图如果没有的话就用分享图作为预览图
- (UIImage *)previewImage {
    if(NotNilAndNull(_previewImage)) {
        return _previewImage;
    }
    return _image;
}

- (NSString *)text {
    if(NotNilAndNull(_text)) {
        return _text;
    }
    return @"";
}

- (NSString *)title {
    if(NotNilAndNull(_title)) {
        return _title;
    }
    return @"";
}

- (NSString *)describe {
    if(NotNilAndNull(_describe)) {
        return _describe;
    }
    return @"";
}

- (NSString *)urlString {
    if(NotNilAndNull(_urlString)) {
        return _urlString;
    }
    return @"";
}

- (NSString *)previewUrlString {
    if(NotNilAndNull(_previewUrlString)) {
        return _previewUrlString;
    }
    return @"";
}


@end
