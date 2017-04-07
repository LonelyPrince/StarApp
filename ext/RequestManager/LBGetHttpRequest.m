////
////  LBGetHttpRequest.m
////  Huangye
////
////  Created by mac on 14-7-30.
////  Copyright (c) 2014年 Super_Fy. All rights reserved.
////
//
//#import "LBGetHttpRequest.h"
//#include <ifaddrs.h>
//#include <sys/socket.h>
//#include <net/if.h>
//#import "AppDelegate.h"
//@implementation LBGetHttpRequest
//
//@synthesize isNeedHideHud;
//@synthesize isNeedShowWaring;
////@synthesize timerGetHMC;
//
//
//- (id) initWithInterfaceName:(NSString *) interfaceName
//{
//    self.isNeedShowWaring = YES;
//    self.isNeedHideHud = YES;
//    [self setRequestMethod:@"GET"];
//
//    [self setDelegate:self];
//    [self setTimeOutSeconds:20];
//    [self setShouldAttemptPersistentConnection:YES];
//
//    NSString * DMSIP = [USER_DEFAULT objectForKey:@"HMC_DMSIP"];
//  __block  NSString * serviceIp;
//    __block NSURL * urlTemp = [[NSURL alloc]init];
////    NSTimer * timerGetHMC;
//    
//    if(DMSIP.length<=3)
//    {
//    
//        timerGetHMC = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(getHmcString) userInfo:nil repeats:YES];
//    }else
//    {
//        [timerGetHMC invalidate];
//    
//        
//        NSString *  subString= [DMSIP substringWithRange:NSMakeRange(0,3)];
//        
//        
//        if (DMSIP != NULL  && [subString isEqualToString:@"HMC"]) {
//           
////            id(^LoadHMCServiceurl)();
//            
//            if (self.LoadHMCServiceurl) {
//               self.LoadHMCServiceurl();
//            }
//            
//            
//           self.LoadHMCServiceurl = ^(){
//            
//                serviceIp = [NSString stringWithFormat:@"http://%@/cgi-bin/cgi_channel_list.cgi?",DMSIP];
//                
//                NSString *urlString = [[NSString stringWithFormat:@"%@%@",serviceIp, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                //    NSString *urlString = [[NSString stringWithFormat:@"%@%@",kSDLB_SYS_SERVER, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                NSLog(@"请求链接 = %@",urlString);
//                NSURL *requestUrl = [[NSURL alloc] initWithString:urlString];
//                urlTemp = requestUrl;
//                return [super initWithURL:urlTemp];
//                
//            };
//            
//            
//        
//        }else
//        {
////            timerGetHMC = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(getHmcString) userInfo:nil repeats:YES];
//            
//        }
//        
//      
//    }
//   
//}
//
//-(void)getHmcString
//{
//    NSString * DMSIP = [USER_DEFAULT objectForKey:@"HMC_DMSIP"];
//    NSString * serviceIp;
//    
//    if(DMSIP.length<=3)
//    {
//        
//    }else
//    {
//        [timerGetHMC invalidate];
//        
//        
//        NSString *  subString= [DMSIP substringWithRange:NSMakeRange(0,3)];
//        
//        
//        if (DMSIP != NULL  && [subString isEqualToString:@"HMC"]) {
////            serviceIp = [NSString stringWithFormat:@"http://%@/cgi-bin/cgi_channel_list.cgi?",DMSIP];
////            
////            NSString *urlString = [[NSString stringWithFormat:@"%@%@",serviceIp, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////            //    NSString *urlString = [[NSString stringWithFormat:@"%@%@",kSDLB_SYS_SERVER, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////            NSLog(@"请求链接 = %@",urlString);
////            NSURL *requestUrl = [[NSURL alloc] initWithString:urlString];
////            return [super initWithURL:requestUrl];
//            self.LoadHMCServiceurl();
//            
//        }else
//        {
//          
//        }
//        
//        
//    }
//
//        //
//}
//// 失败
//- (void) requestFailed:(ASIHTTPRequest *) aRequest
//{
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
//
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
//
//            }
//        }
//    }
//}
//
//@end
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
    
    
    NSString * serverStr =  [USER_DEFAULT   objectForKey:@"HMCServiceStr"];  //new server
    
    NSLog(@"请求链接serverStr = %@",serverStr);
    NSString *urlString = [[NSString stringWithFormat:@"%@%@",serverStr, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //    NSString *urlString = [[NSString stringWithFormat:@"%@%@",kSDLB_SYS_SERVER, interfaceName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

@end

