//
//  KYKeychain.h
//  VPN
//
//  Created by Kerain on 2018/6/5.
//  Copyright © 2018年 不愿透露姓名的洪先生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYKeychain : NSObject

+ (NSData *)searchKeychainCopyMatching:(NSString *)identifier;

+ (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier;

@end
