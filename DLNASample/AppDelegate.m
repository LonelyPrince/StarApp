//
//  AppDelegate.m
//  DLNASample
//
//  Created by 健司 古山 on 12/05/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize avRenderer = _avRenderer;


//**** dms 搜索用

@synthesize avController;
@synthesize cgUpnpModel;
@synthesize avCtrl;
//*******

//- (void)dealloc
//{
//    [_window release];
//    [_navigationController release];
//    [super dealloc];
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    
    //    //master第一个页面
    //    MasterViewController *masterViewController = [[[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil] autorelease];
    //    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    //    self.window.rootViewController = self.navigationController;
    //    [self.window makeKeyAndVisible];
    self.starMainTab = [[StarMainTabController alloc]init];
    self.starMainTab.selectedIndex = 1;
    self.window.rootViewController = self.starMainTab;
    
    [NSThread sleepForTimeInterval:1.0];//设置启动页面时间
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.dataSource = [NSMutableArray array];
    cgUpnpModel = [[CGUpnpDeviceModel alloc]init];
    [self getCGData1];
//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(judgeDmsDevice) userInfo:nil repeats:YES];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    
      [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(checkIPTimer) userInfo:nil repeats:YES];
//    self.ipString =  [GGUtil getIPAddress];
    self.ipString =  [GGUtil getIPAddress:YES];
    [self.window makeKeyAndVisible];
    return YES;
}

//收集崩溃信息
void UncaughtExceptionHandler(NSException *exception) {
        /**
              *  获取异常崩溃信息
              */
        NSArray *callStack = [exception callStackSymbols];  //得到当前调用栈信息
        NSString *reason = [exception reason];  //非常重要，就是崩溃的原因
        NSString *name = [exception name];  //异常类型
        NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
     
        /**
              *  把异常崩溃信息发送至开发者邮件
              */
        NSMutableString *mailUrl = [NSMutableString string];
        [mailUrl appendString:@"mailto:834455724@qq.com"];
        [mailUrl appendString:@"?subject=程序异常崩溃，请配合发送异常报告，谢谢合作！"];
        [mailUrl appendFormat:@"&body=%@", content];
        // 打开地址
        NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
}
+ (AppDelegate *)shareAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
-(void)getCGData1
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        //搜索
        
        avCtrl = [[CGUpnpAvController alloc] init];    ///进行搜索的对象
        avCtrl.delegate = self;
        [avCtrl search];
        self.avController = avCtrl;
       
        //通知主线程刷新
        NSLog(@"Device dispatch1");
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
       
            
            NSLog(@"Device dispatch2");
        });
        
    });
}
- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceUpdated:(NSString *)deviceUdn {
    NSLog(@"%@", deviceUdn);
    self.avController = (CGUpnpAvController*)controlPoint;
    
    NSArray * dmsArr = [[NSArray alloc]init];
    //此处可能产生僵尸对象
    dmsArr = [((CGUpnpAvController*)controlPoint) servers];
   
    [self.dataSource removeAllObjects];
    [USER_DEFAULT setObject:[self.dataSource copy]  forKey:@"DmsDevice"];
    
    for (int i = 0; i<dmsArr.count ; i++) {
      
        CGUpnpDevice *dev = dmsArr[i];
        cgUpnpModel.category_id =[dev friendlyName];
        cgUpnpModel.UUID= [dev udn];
        cgUpnpModel.ipaddress = [dev ipaddress];
    
        
        //字典:

        NSLog(@"cg:%@",  cgUpnpModel.UUID);
        if (cgUpnpModel == NULL) {
            
        }
        else{
            NSDictionary * dmsDic =[NSDictionary dictionaryWithObjectsAndKeys:
                                    cgUpnpModel.category_id, @"dmsID",
                                    cgUpnpModel.UUID, @"dmsUUID",
                                    cgUpnpModel.ipaddress, @"dmsIP",
                                    nil];  ;
        [self.dataSource addObject:dmsDic];
        }
        
        
    }
    
    
    
    
    if (self.dataSource == NULL) {
     
    }
    else
    {
        NSLog(@"datasource:%@",self.dataSource);
    [USER_DEFAULT setObject:[self.dataSource copy]  forKey:@"DmsDevice"];
    NSLog(@"datasource.count %d",self.dataSource.count);
    }
    //    int dmsNum = 0;
        
    //    [self loadUI];

    
    NSLog(@"Device delegate");
}
-(void) judgeDmsDevice  //每五秒刷新一次数据
{

    
}

-(void)checkIPTimer
{
//    NSString * IPstrNow = [GGUtil getIPAddress];
    NSString * IPstrNow=  [GGUtil getIPAddress:YES];
    if ([IPstrNow isEqualToString:self.ipString]) {
        
    }else
    {
    
        NSLog(@"IP 网络改变");
        
        self.ipString = IPstrNow;
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"IPHasChanged" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    
}
@end
