//
//  LBGetHttpRequest.m
//  Huangye
//
//  Created by mac on 14-7-30.
//  Copyright (c) 2014年 Super_Fy. All rights reserved.
//

#import "LBGetHttpRequest.h"
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
#import "AppDelegate.h"
@implementation LBGetHttpRequest

@synthesize isNeedHideHud;
@synthesize isNeedShowWaring;

- (id) initWithInterfaceName:(NSString *) interfaceName
{
    self.isNeedShowWaring = YES;
    self.isNeedHideHud = YES;
    [self setRequestMethod:@"GET"];

    [self setDelegate:self];
    [self setTimeOutSeconds:20];
    [self setShouldAttemptPersistentConnection:YES];

    NSString *urlString = [[NSString stringWithFormat:@"%@%@",kSDLB_SYS_SERVER, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"请求链接 = %@",urlString);
    NSURL *requestUrl = [[NSURL alloc] initWithString:urlString];
    return [super initWithURL:requestUrl];
}

// 失败
- (void) requestFailed:(ASIHTTPRequest *) aRequest
{
    if (isNeedHideHud)
    {
        StopRequest;
    }
    
    if ([[aRequest error] code] == ASIRequestTimedOutErrorType)
    {
        if (isNeedShowWaring)
        {
//            AddHudFailureNotice(@"网络不给力，请稍后重试");
            [MBProgressHUD showMessag:@"请求失败" toView:nil];

        }
    }
    else
    {
        if (!CheckNetWorkAvailable)
        {
            if (isNeedShowWaring)
            {
//                AddHudFailureNotice(@"网络有问题，请检查网络");
                [MBProgressHUD showMessag:@"请求失败" toView:nil];

            }
        }
        else
        {
            if (isNeedShowWaring)
            {
//                AddHudFailureNotice(@"网络不给力，请稍后重试");
                [MBProgressHUD showMessag:@"请求失败" toView:nil];

            }
        }
    }
}

@end
