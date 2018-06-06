//
//  KYPingTool.h
//  SimplePingDemo
//
//  Created by Kerain on 2018/6/6.
//  Copyright © 2018年 广州九章信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYPingItem : NSObject

@property(nonatomic, assign) uint16_t sequenceNumber;

@end


@protocol KYPingDelegate <NSObject>

- (void) didPingSucccessWithTime:(float)time withError:(NSError*) error;

@end

@interface KYPingTool : NSObject

// 事件监听器
@property (nonatomic,   weak) id<KYPingDelegate> delegate;

// 超时时间  默认1.5秒
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

// 实例化
- (instancetype) initWithHostName:(NSString*)hostName;

//  开始测速
- (void) start;

//  结束测速
- (void) stop;

@end



