//
//  KYPingTool.m
//  SimplePingDemo
//
//  Created by Kerain on 2018/6/6.
//  Copyright © 2018年 广州九章信息技术有限公司. All rights reserved.
//


#define ALERT(title,msg) dispatch_async(dispatch_get_main_queue(), ^{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];[alert show];});


#import "KYPingTool.h"
#import "SimplePing.h"

@implementation KYPingItem

@end


@interface KYPingTool ()<SimplePingDelegate>
{
    NSTimer* _timer;
    NSDate* _beginDate;
}
@property(nonatomic, strong) SimplePing* simplePing;

@property(nonatomic, strong) NSMutableArray<KYPingItem*>* pingItems;

@end

@implementation KYPingTool


-(instancetype)initWithHostName:(NSString *)hostName
{
    if (self = [super init])
    {
        self.simplePing = [[SimplePing alloc] initWithHostName:hostName];
        self.simplePing.delegate = self;
        self.simplePing.addressStyle = SimplePingAddressStyleAny;
        self.pingItems = [NSMutableArray array];
        self.timeoutInterval = 1.5;
    }
    return self;
}

-(void)start
{
    [self.simplePing start];
}

-(void)stop
{
    [_timer invalidate];
    _timer = nil;
    [self.simplePing stop];
}




- (void)actionTimer
{
     _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sendPingData) userInfo:nil repeats:YES];
}


- (void) sendPingData
{
    [self.simplePing sendPingWithData:nil];
}


#pragma mark - SimplePingDelegate

//ping 开始
- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address
{
    [self actionTimer];
}


//成功发送一份ping数据
- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    NSLog(@"第%hu次测速",sequenceNumber);
    KYPingItem* item = [[KYPingItem alloc] init];
    item.sequenceNumber = sequenceNumber;
    [self.pingItems addObject:item];
    
    _beginDate = [NSDate date];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeoutInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([self.pingItems containsObject:item])
        {
            NSLog(@"超时---------------------------->");
            [self.pingItems removeObject:item];
            if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didPingSucccessWithTime:withError:)])
            {
                [self.delegate didPingSucccessWithTime:1500 withError:nil];
            }
        }
    });
}

//发送ping数据失败
- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error
{
    ALERT(@"发包失败", error.description);
}

// 收到服务器的反馈包成功
- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    float delayTime = [[NSDate date] timeIntervalSinceDate:_beginDate] * 1000;
    [self.pingItems enumerateObjectsUsingBlock:^(KYPingItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.sequenceNumber == sequenceNumber)
        {
            [self.pingItems removeObject:obj];
        }
    }];
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(didPingSucccessWithTime:withError:)])
    {
        [self.delegate didPingSucccessWithTime:delayTime withError:nil];
    }
}

//收到服务器的反馈包失败
- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error
{
     ALERT(@"ping失败", error.description);
}


//收到未知响应数据
- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{
    ALERT(@"ping失败", @"收到未知响应数据");
}



@end
