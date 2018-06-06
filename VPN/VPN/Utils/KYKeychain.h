//
//  KYKeychain.h
//  VPN
//
//  Created by Kerain on 2018/6/5.
//  Copyright © 2018年 广州九章信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KYKeychain : NSObject

+ (NSData *)searchKeychainCopyMatching:(NSString *)identifier;

+ (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier;

@end
