//
//  ViewController.m
//  TestVPNInIos8
//
//  Created by Qixin on 14/11/26.
//  Copyright (c) 2014年 Qixin. All rights reserved.
//

#import "ViewController.h"
#import "KYVPNManager.h"
#import <NetworkExtension/NetworkExtension.h>



@implementation ViewController

#pragma mark - IBAction
- (IBAction)buttonPressed:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
        {
            [KYVPNManager saveToPreferencesWithCompletionHandler:^{
                ALERT(@"Saved", @"Saved");
            }];
            break;
        }
        case 1:
        {
            [KYVPNManager removeFromPreferencesWithCompletionHandler:^{
                ALERT(@"Remove", @"删除成功");
            }];
            break;
        }
        case 2:
        {
            [KYVPNManager start];
            break;
        }
        case 3:
        {
            [KYVPNManager stop];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - VPN状态切换通知
- (void)VPNStatusDidChangeNotification
{
    switch (KYVPNManager.currentStatue)
    {
        case NEVPNStatusInvalid:
        {
            [self setUpStaueLabelWithState:@"NEVPNStatusInvalid"];
            break;
        }
        case NEVPNStatusDisconnected:
        {
            [self setUpStaueLabelWithState:@"NEVPNStatusDisconnected"];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
        case NEVPNStatusConnecting:
        {
             [self setUpStaueLabelWithState:@"NEVPNStatusConnecting"];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
        case NEVPNStatusConnected:
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             [self setUpStaueLabelWithState:@"NEVPNStatusConnected"];
            break;
        }
        case NEVPNStatusReasserting:
        {
             [self setUpStaueLabelWithState:@"NEVPNStatusReasserting"];
            break;
        }
        case NEVPNStatusDisconnecting:
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [self setUpStaueLabelWithState:@"NEVPNStatusDisconnecting"];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 工具方法
- (void)setUpStaueLabelWithState:(NSString *)state
{
    self.statusLabel.text = state;
    if ([state isEqualToString:@"NEVPNStatusConnected"])
    {
        self.statusLabel.backgroundColor = [UIColor greenColor];
    }else
    {
        self.statusLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    [KYVPNManager loadFromPreferencesWithCompletionHandler:^{
        [self VPNStatusDidChangeNotification];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(VPNStatusDidChangeNotification)
                                                 name:NEVPNStatusDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
