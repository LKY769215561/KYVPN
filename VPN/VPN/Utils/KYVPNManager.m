//
//  KYVPNManager.m
//  VPN
//
//  Created by Kerain on 2018/6/5.
//  Copyright © 2018年 不愿透露姓名的洪先生. All rights reserved.
//

#import "KYVPNManager.h"
#import <NetworkExtension/NetworkExtension.h>
#import "KYKeychain.h"



/*************************************************/

#define kVPNName @"test"
#define kServerAddress @"18.216.7.251"

//Keychain
#define kPasswordReference @"VPN_PASSWORD"
#define kSharedSecretReference @"PSK"
/*************************************************/


@implementation KYVPNManager

+ (void)loadFromPreferencesWithCompletionHandler:(void (^)())completionHandler
{
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
         [KYVPNManager setupIPSecWithUserName:kVPNName serverAddress:kServerAddress];
         [self setUpError:error type:@"Load" hander:completionHandler];
    }];
}


+ (void)saveToPreferencesWithCompletionHandler:(void (^)())completionHandler
{
    [self loadFromPreferencesWithCompletionHandler:^{
        [[NEVPNManager sharedManager] saveToPreferencesWithCompletionHandler:^(NSError *error){
            [self setUpError:error type:@"Save" hander:completionHandler];
        }];
    }];

}


+ (void)removeFromPreferencesWithCompletionHandler:(void (^)())completionHandler
{
    [self loadFromPreferencesWithCompletionHandler:^{
        [[NEVPNManager sharedManager] removeFromPreferencesWithCompletionHandler:^(NSError *error){
            [self setUpError:error type:@"Remove" hander:completionHandler];
        }];
    }];
}

+ (void)setupIPSecWithUserName:(NSString *)username serverAddress:(NSString *)serverAddress
{
    NEVPNProtocolIPSec *p = [[NEVPNProtocolIPSec alloc] init];
    p.username = kVPNName;
    [KYKeychain createKeychainValue:@"test" forIdentifier:kPasswordReference];
    NSData *passwordReference = [KYKeychain searchKeychainCopyMatching:kPasswordReference];
    p.passwordReference = passwordReference;
    p.serverAddress = kServerAddress;
    p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
    [KYKeychain createKeychainValue:@"test" forIdentifier:kSharedSecretReference];
    NSData *sharedSecretReference = [KYKeychain searchKeychainCopyMatching:kSharedSecretReference];
    p.sharedSecretReference = sharedSecretReference;
    p.disconnectOnSleep = NO;
    
    
    [[NEVPNManager sharedManager] setProtocol:p];
    [[NEVPNManager sharedManager] setOnDemandEnabled:NO];
    [[NEVPNManager sharedManager] setLocalizedDescription:@"个人-VPN测试"];//VPN自定义名字
    [[NEVPNManager sharedManager] setEnabled:YES];
}


+ (void)start
{
    [self loadFromPreferencesWithCompletionHandler:^{
       [[NEVPNManager sharedManager].connection startVPNTunnelAndReturnError:nil];
    }];
    
}

+ (void)stop
{
    [self loadFromPreferencesWithCompletionHandler:^{
         [[NEVPNManager sharedManager].connection stopVPNTunnel];
    }];
}

+(NSInteger)currentStatue
{
    return [NEVPNManager sharedManager].connection.status;
}

#pragma mark - 工具方法
+ (void)setUpError:(NSError *)error
              type:(NSString *)type
            hander:(void (^)())completionHandler
{
    if(error)
    {
        NSLog(@"%@ error: %@",type,error);
        ALERT(type, error.description);
    }else
    {
        completionHandler();
    }
}






@end
