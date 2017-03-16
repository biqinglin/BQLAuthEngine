//
//  ViewController.m
//  BQLAuthEngine
//
//  Created by biqinglin on 2017/3/14.
//  Copyright © 2017年 biqinglin. All rights reserved.
//

#import "ViewController.h"
#import "BQLAuthEngine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)qqLogin:(id)sender {
    [[BQLAuthEngine sharedAuthEngine] auth_qq_login:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)qqTextShare:(id)sender {
    
    BQLShareModel *model = [BQLShareModel modelWithDictionary:@{@"text":@"这是一个QQ文本分享测试"}];
    [[BQLAuthEngine sharedAuthEngine] auth_qq_share_text:model success:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)qqImgShare:(id)sender {
    
    BQLShareModel *model = [BQLShareModel modelWithDictionary:@{@"image":[UIImage imageNamed:@"qqz"],
                                                                @"title":@"我是分享图片标题",
                                                                @"describe":@"我是分享图片的简介~~~你想让我描述些什么呢?"}];
    [[BQLAuthEngine sharedAuthEngine] auth_qq_share_image:model success:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)qqLinkShare:(id)sender {
    
    
    BQLShareModel *model = [BQLShareModel modelWithDictionary:@{@"urlString":@"https://github.com/biqinglin",
                                                                @"title":@"我是bi",
                                                                @"describe":@"我是一名小开发",
                                                                @"previewImage":[UIImage imageNamed:@"qqf"]}];
    [[BQLAuthEngine sharedAuthEngine] auth_qq_share_link:model scene:QQShareSceneSession success:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)wechatLogin:(id)sender {
    
    [[BQLAuthEngine sharedAuthEngine] auth_wechat_login:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)wechatTextShare:(id)sender {
    
    BQLShareModel *model = [BQLShareModel modelWithDictionary:@{@"text":@"我是一个微信文本分享测试~~~"}];
    [[BQLAuthEngine sharedAuthEngine] auth_wechat_share_text:model scene:WechatShareSceneSession success:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)wechatImgShare:(id)sender {
    
    BQLShareModel *model = [BQLShareModel modelWithDictionary:@{@"image":[UIImage imageNamed:@"qqf"]}];
    [[BQLAuthEngine sharedAuthEngine] auth_wechat_share_image:model scene:WechatShareSceneSession success:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)wechatLinkShare:(id)sender {
    
    BQLShareModel *model = [BQLShareModel modelWithDictionary:@{@"title":@"专访张小龙：产品之上的世界观",
                                                                @"describe":@"微信的平台化发展方向是否真的会让这个原本简洁的产品变得臃肿？在国际化发展方向上，微信面临的问题真的是文化差异壁垒吗？腾讯高级副总裁、微信产品负责人张小龙给出了自己的回复。",
                                                                @"previewImage":[UIImage imageNamed:@"weibo"],
                                                                @"urlString":@"http://tech.qq.com/zt2012/tmtdecode/252.htm"}];
    [[BQLAuthEngine sharedAuthEngine] auth_wechat_share_link:model scene:WechatShareSceneSession success:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)wechatMusicShare:(id)sender {
    // 这个音乐地址无效了~~~你们自己弄个有用的测试
    BQLShareModel *model = [BQLShareModel modelWithDictionary:@{@"title":@"一无所有",
                                                                @"describe":@"崔健",
                                                                @"previewImage":[UIImage imageNamed:@"weibo"],
                                                                @"urlString":@"http://y.qq.com/i/song.html#p=7B22736F6E675F4E616D65223A22E4B880E697A0E68980E69C89222C22736F6E675F5761704C69766555524C223A22687474703A2F2F74736D7573696334382E74632E71712E636F6D2F586B30305156342F4141414130414141414E5430577532394D7A59344D7A63774D4C6735586A4C517747335A50676F47443864704151526643473444442F4E653765776B617A733D2F31303130333334372E6D34613F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D30222C22736F6E675F5769666955524C223A22687474703A2F2F73747265616D31342E71716D757369632E71712E636F6D2F33303130333334372E6D7033222C226E657454797065223A2277696669222C22736F6E675F416C62756D223A22E4B880E697A0E68980E69C89222C22736F6E675F4944223A3130333334372C22736F6E675F54797065223A312C22736F6E675F53696E676572223A22E5B494E581A5222C22736F6E675F576170446F776E4C6F616455524C223A22687474703A2F2F74736D757369633132382E74632E71712E636F6D2F586C464E4D313574414141416A41414141477A4C36445039536A457A525467304E7A38774E446E752B6473483833344843756B5041576B6D48316C4A434E626F4D34394E4E7A754450444A647A7A45304F513D3D2F33303130333334372E6D70333F7569643D3233343734363930373526616D703B63743D3026616D703B636869643D3026616D703B73747265616D5F706F733D35227D"}];
    [[BQLAuthEngine sharedAuthEngine] auth_wechat_share_music:model scene:WechatShareSceneSession success:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)wechatVideoShare:(id)sender {
    
    BQLShareModel *model = [BQLShareModel modelWithDictionary:@{@"title":@"深爱厨房",
                                                                @"describe":@"男人可以没钱，可以不帅，但一定要会做饭",
                                                                @"previewImage":[UIImage imageNamed:@"weibo"],
                                                                @"urlString":@"http://baobab.wdjcdn.com/1455782903700jy.mp4"}];
    [[BQLAuthEngine sharedAuthEngine] auth_wechat_share_video:model scene:WechatShareSceneSession success:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)weiboLogin:(id)sender {
    
    [[BQLAuthEngine sharedAuthEngine] auth_sina_login:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)weiboTextShare:(id)sender {
    
    BQLShareModel *model = [BQLShareModel modelWithDictionary:@{@"text":@"深爱厨房"}];
    [[BQLAuthEngine sharedAuthEngine] auth_sina_share_text:model success:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)weiboImageShare:(id)sender {
    
    BQLShareModel *model = [BQLShareModel modelWithDictionary:@{@"text":@"深爱厨房",
                                                                @"image":[UIImage imageNamed:@"weibo"]}];
    [[BQLAuthEngine sharedAuthEngine] auth_sina_share_image:model success:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)weibolinkShare:(id)sender {
    
    BQLShareModel *model = [BQLShareModel modelWithDictionary:@{@"text":@"深爱厨房",
                                                                @"image":[UIImage imageNamed:@"weibo"],
                                                                @"urlString":@"https://github.com/biqinglin"}];
    [[BQLAuthEngine sharedAuthEngine] auth_sina_share_link:model success:^(id response) {
        
        NSLog(@"%@",response);
    } failure:^(NSString *error) {
        
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
