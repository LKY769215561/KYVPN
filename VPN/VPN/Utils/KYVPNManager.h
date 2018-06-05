//
//  KYVPNManager.h
//  VPN
//
//  Created by Kerain on 2018/6/5.
//  Copyright © 2018年 不愿透露姓名的洪先生. All rights reserved.
//

#import <UIKit/UIKit.h>



#define ALERT(title,msg) dispatch_async(dispatch_get_main_queue(), ^{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];[alert show];});




@interface KYVPNManager : NSObject

//加载当前VPN描述文件
+ (void)loadFromPreferencesWithCompletionHandler:(void (^)())completionHandler;

//创建VPN描述文件  保存VPN到系统->通用->VPN->个人VPN
+ (void)saveToPreferencesWithCompletionHandler:(void (^)())completionHandler;

//删除VPN描述文件
+ (void)removeFromPreferencesWithCompletionHandler:(void (^)())completionHandler;

//连接VPN(前提是必须有描述文件)
+ (void)start;

//断开VPN
+ (void)stop;

//当前VPN状态
+ (NSInteger)currentStatue;


@end
