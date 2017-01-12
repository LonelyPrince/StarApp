////
////  LBDataManager.m
////  TestDemo
////
////  Created by mac on 14-6-30.
////  Copyright (c) 2014年 mac. All rights reserved.
////
//
//#import "LBPostHttpRequest.h"
//#include <ifaddrs.h>
//#include <sys/socket.h>
//#include <net/if.h>
//#import "AppDelegate.h"
//@implementation LBPostHttpRequest
//@synthesize isNeedHideHud;
//@synthesize isNeedShowWaring;
//
//
//- (id) initWithInterfaceName:(NSString *) interfaceName ApiModule:(NSString *) apimodule
//{
//    self.isNeedShowWaring = YES;
//    self.isNeedHideHud = YES;
//    
//    [self setDelegate:self];
//    [self setRequestMethod:@"POST"];
//    [self setTimeOutSeconds:20];
//    [self setShouldAttemptPersistentConnection:YES];
//
//    NSString * DMSIP = [USER_DEFAULT objectForKey:@"HMC_DMSIP"];
//    NSString * serviceIp;
//    if (DMSIP != NULL ) {
//        serviceIp = [NSString stringWithFormat:@"http://%@/cgi-bin/cgi_channel_list.cgi?",DMSIP];
//    }else
//    {
//        //        serviceIp =@"http://192.168.1.55/cgi-bin/cgi_channel_list.cgi?";   //服务器地址
//    }
//    NSString *urlString = [[NSString stringWithFormat:@"%@%@%@", apimodule,serviceIp, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    //    NSString *urlString = [[NSString stringWithFormat:@"%@%@%@", apimodule,kSDLB_SYS_SERVER, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *requestUrl = [[NSURL alloc] initWithString:urlString];
//    return [super initWithURL:requestUrl];
//}
//
//- (id) initWithInterfaceName:(NSString *) interfaceName ApiModule:(NSString *) apimodule WithOutApiString:(BOOL)apiState
//{
//    self.isNeedShowWaring = YES;
//    self.isNeedHideHud = YES;
//    
//    [self setDelegate:self];
//    [self setRequestMethod:@"POST"];
//    [self setTimeOutSeconds:20];
//    [self setShouldAttemptPersistentConnection:YES];
//    
//    NSString *urlString;
//    
//    NSString * DMSIP = [USER_DEFAULT objectForKey:@"HMC_DMSIP"];
//    NSString * serviceIp;
//    if (DMSIP != NULL ) {
//        serviceIp = [NSString stringWithFormat:@"http://%@/cgi-bin/cgi_channel_list.cgi?",DMSIP];
//    }else
//    {
//        //        serviceIp =@"http://192.168.1.55/cgi-bin/cgi_channel_list.cgi?";   //服务器地址
//    }
//    if (apiState) {
//         urlString = [[NSString stringWithFormat:@"%@%@", apimodule, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }else{
//        urlString = [[NSString stringWithFormat:@"%@%@%@", apimodule,serviceIp, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////          urlString = [[NSString stringWithFormat:@"%@%@%@", apimodule,kSDLB_SYS_SERVER, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }
//    NSURL *requestUrl = [[NSURL alloc] initWithString:urlString];
//    
//    return [super initWithURL:requestUrl];
//}
//
//// 成功
//- (void) requestFinished:(ASIHTTPRequest *) aRequest
//{
//    if (isNeedHideHud)
//    {
//        StopRequest;
//    }
//    
//}
//
//// 失败
//- (void) requestFailed:(ASIHTTPRequest *) aRequest
//{
//    NSLog(@"qingqiu shibai ");
//    if (isNeedHideHud)
//    {
//        StopRequest;
//    }
//    
//    if ([[aRequest error] code] == ASIRequestTimedOutErrorType)
//    {
//        if (isNeedShowWaring)
//        {
////            AddHudFailureNotice(@"网络不给力，请稍后重试");
////            [MBProgressHUD showMessag:@"请求失败" toView:nil];
//        }
//    }
//    else
//    {
//        if (!CheckNetWorkAvailable)
//        {
//            if (isNeedShowWaring)
//            {
////                AddHudFailureNotice(@"网络有问题，请检查网络");
////                [MBProgressHUD showMessag:@"请求失败" toView:nil];
//
//            }
//        }
//        else
//        {
//            if (isNeedShowWaring)
//            {
////                AddHudFailureNotice(@"网络不给力，请稍后重试");
////                [MBProgressHUD showMessag:@"请求失败" toView:nil];
//            }
//        }
//    }
//}
//+ (NSString *)generateURLwithOriginUrl:(NSString *)url withParamters:(NSDictionary *)paramters
//{
//    //    NSDictionary *finalParamters = [self signParamters:paramters];
//    NSMutableString *finalURLString = [NSMutableString stringWithString:url];
//    for (NSString *key in paramters)
//    {
//        [finalURLString appendFormat:@"&%@=%@",key,paramters[key]];
//    }
//    return [finalURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//}
//+ (NSArray *) getDataCounters
//{
//    BOOL   success;
//    struct ifaddrs *addrs;
//    const struct ifaddrs *cursor;
//    const struct if_data *networkStatisc;
//    
//    int WiFiSent = 0;
//    int WiFiReceived = 0;
//    int WWANSent = 0;
//    int WWANReceived = 0;
//    
//    NSString *name=[[NSString alloc]init];
//    
//    success = getifaddrs(&addrs) == 0;
//    if (success)
//    {
//        cursor = addrs;
//        while (cursor != NULL)
//        {
//            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
//            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
//            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
//            if (cursor->ifa_addr->sa_family == AF_LINK)
//            {
//                if ([name hasPrefix:@"en"])
//                {
//                    networkStatisc = (const struct if_data *) cursor->ifa_data;
//                    WiFiSent+=networkStatisc->ifi_obytes;
//                    WiFiReceived+=networkStatisc->ifi_ibytes;
//                    NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
//                    NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
//                }
//                if ([name hasPrefix:@"pdp_ip"])
//                {
//                    networkStatisc = (const struct if_data *) cursor->ifa_data;
//                    WWANSent+=networkStatisc->ifi_obytes;
//                    WWANReceived+=networkStatisc->ifi_ibytes;
//                    NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
//                    NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
//                }
//            }
//            cursor = cursor->ifa_next;
//        }
//        freeifaddrs(addrs);
//    }
//    
//    return [NSArray arrayWithObjects:[self bytesToAvaiUnit:WiFiSent], [self bytesToAvaiUnit:WiFiReceived], [self bytesToAvaiUnit:WWANSent], [self bytesToAvaiUnit:WWANReceived], nil];
//}
//
//+ (NSString *)bytesToAvaiUnit:(int)bytes
//{
//    if(bytes < 1024)                // B
//    {
//        return [NSString stringWithFormat:@"%dB", bytes];
//    }
//    else if(bytes >= 1024 && bytes < 1024 * 1024)        // KB
//    {
//        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
//    }
//    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)        // MB
//    {
//        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
//    }
//    else        // GB
//    {
//        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
//    }
//}
//@end
//
//  LBDataManager.m
//  TestDemo
//
//  Created by mac on 14-6-30.
//  Copyright (c) 2014年 mac. All rights reserved.
//


#import "LBPostHttpRequest.h"
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
#import "AppDelegate.h"
@implementation LBPostHttpRequest
@synthesize isNeedHideHud;
@synthesize isNeedShowWaring;


- (id) initWithInterfaceName:(NSString *) interfaceName ApiModule:(NSString *) apimodule
{
    self.isNeedShowWaring = YES;
    self.isNeedHideHud = YES;
    
    [self setDelegate:self];
    [self setRequestMethod:@"POST"];
    [self setTimeOutSeconds:20];
    [self setShouldAttemptPersistentConnection:YES];
    
    NSString * serverStr =  [USER_DEFAULT   objectForKey:@"HMCServiceStr"];  //new server

    NSString *urlString = [[NSString stringWithFormat:@"%@%@%@", apimodule,serverStr, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSString *urlString = [[NSString stringWithFormat:@"%@%@%@", apimodule,kSDLB_SYS_SERVER, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *requestUrl = [[NSURL alloc] initWithString:urlString];
    return [super initWithURL:requestUrl];
}

- (id) initWithInterfaceName:(NSString *) interfaceName ApiModule:(NSString *) apimodule WithOutApiString:(BOOL)apiState
{
    self.isNeedShowWaring = YES;
    self.isNeedHideHud = YES;
    
    [self setDelegate:self];
    [self setRequestMethod:@"POST"];
    [self setTimeOutSeconds:20];
    [self setShouldAttemptPersistentConnection:YES];
    
    NSString *urlString;
    
    if (apiState) {
        urlString = [[NSString stringWithFormat:@"%@%@", apimodule, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        NSString * serverStr =  [USER_DEFAULT   objectForKey:@"HMCServiceStr"];  //new server
        
        urlString = [[NSString stringWithFormat:@"%@%@%@", apimodule,serverStr, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
//        urlString = [[NSString stringWithFormat:@"%@%@%@", apimodule,kSDLB_SYS_SERVER, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSURL *requestUrl = [[NSURL alloc] initWithString:urlString];
    
    return [super initWithURL:requestUrl];
}

// 成功
- (void) requestFinished:(ASIHTTPRequest *) aRequest
{
    if (isNeedHideHud)
    {
        StopRequest;
    }
    
}

// 失败
- (void) requestFailed:(ASIHTTPRequest *) aRequest
{
    NSLog(@"qingqiu shibai ");
    if (isNeedHideHud)
    {
        StopRequest;
    }
    
    if ([[aRequest error] code] == ASIRequestTimedOutErrorType)
    {
        if (isNeedShowWaring)
        {
            //            AddHudFailureNotice(@"网络不给力，请稍后重试");
            //            [MBProgressHUD showMessag:@"请求失败" toView:nil];
        }
    }
    else
    {
        if (!CheckNetWorkAvailable)
        {
            if (isNeedShowWaring)
            {
                //                AddHudFailureNotice(@"网络有问题，请检查网络");
                //                [MBProgressHUD showMessag:@"请求失败" toView:nil];
                
            }
        }
        else
        {
            if (isNeedShowWaring)
            {
                //                AddHudFailureNotice(@"网络不给力，请稍后重试");
                //                [MBProgressHUD showMessag:@"请求失败" toView:nil];
            }
        }
    }
}
+ (NSString *)generateURLwithOriginUrl:(NSString *)url withParamters:(NSDictionary *)paramters
{
    //    NSDictionary *finalParamters = [self signParamters:paramters];
    NSMutableString *finalURLString = [NSMutableString stringWithString:url];
    for (NSString *key in paramters)
    {
        [finalURLString appendFormat:@"&%@=%@",key,paramters[key]];
    }
    return [finalURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+ (NSArray *) getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    int WiFiSent = 0;
    int WiFiReceived = 0;
    int WWANSent = 0;
    int WWANReceived = 0;
    
    NSString *name=[[NSString alloc]init];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
                    NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
                    NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    
    return [NSArray arrayWithObjects:[self bytesToAvaiUnit:WiFiSent], [self bytesToAvaiUnit:WiFiReceived], [self bytesToAvaiUnit:WWANSent], [self bytesToAvaiUnit:WWANReceived], nil];
}

+ (NSString *)bytesToAvaiUnit:(int)bytes
{
    if(bytes < 1024)                // B
    {
        return [NSString stringWithFormat:@"%dB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024)        // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)        // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else        // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}
@end
