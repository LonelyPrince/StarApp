//
//  AppDelegate.m
//  DLNASample
//
//  Created by 健司 古山 on 12/05/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "StarAPP-Bridging-Header.h"
#import "StarAPP-Swift.h"
@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize avRenderer = _avRenderer;


//**** dms 搜索用

@synthesize avController;
@synthesize cgUpnpModel;
@synthesize avCtrl;
//第一次打开
@synthesize openfirst;
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
    
    
    CTLProtocol * Test = [[CTLProtocol alloc]init];
    [NSURLProtocol registerClass:[Test class]];
    
    // Override point for customization after application launch.
    
    //    //master第一个页面
    //    MasterViewController *masterViewController = [[[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil] autorelease];
    //    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    //    self.window.rootViewController = self.navigationController;
    //    [self.window makeKeyAndVisible];
    self.starMainTab = [[StarMainTabController alloc]init];
    self.starMainTab.selectedIndex = 1;
    self.window.rootViewController = self.starMainTab;
    NSLog(@"00000---");
    self.dataSource = [NSMutableArray array];
    cgUpnpModel = [[CGUpnpDeviceModel alloc]init];
//    [NSThread detachNewThreadSelector:@selector(getCGData1) toTarget:self withObject:nil];
    [self getCGData1];
    NSLog(@"11111---");
    [NSThread sleepForTimeInterval:2.0];//设置启动页面时间
    NSLog(@"22222---");
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    self.dataSource = [NSMutableArray array];
//    cgUpnpModel = [[CGUpnpDeviceModel alloc]init];
//    [self getCGData1];
//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(judgeDmsDevice) userInfo:nil repeats:YES];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    
      [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkIPTimer) userInfo:nil repeats:YES];
//    self.ipString =  [GGUtil getIPAddress];
    self.ipString =  [GGUtil getIPAddress:YES];
//     [USER_DEFAULT setObject:@"aa"  forKey:@"HMC_DMSIP"];   //这个可以删除，此处是做测试，默认的先让IP为aa
//    [USER_DEFAULT setObject:@"aa"  forKey:@"HMCServiceStr"];   //这个可以删除，此处是做测试，默认的先让IP为aa
//    [USER_DEFAULT setObject:@"aa"  forKey:@"G_deviceStr"];   //这个可以删除，此处是做测试，默认的先让IP为aa
//    [USER_DEFAULT setObject:@"aa"  forKey:@"G_deviceStr"];   //这个可以删除，此处是做测试，默认的先让IP为aa
    
    openfirst = 1;
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
//    NSLog(@"--++--");
//    avCtrl = [[CGUpnpAvController alloc] init];    ///进行搜索的对象
//            avCtrl.delegate = self;
//            [avCtrl search];
//            self.avController = avCtrl;
    //
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
    
    NSLog(@"刷新中-----");
    
     NSLog(@"DMSIP:进入");
    NSArray * oldDmsArr =[USER_DEFAULT  objectForKey:@"DmsDevice"]; //用于获取原始的数据，如果原始数据和新数据一样，不刷新
    NSArray * newDmsArr = [[NSArray alloc]init];
    NSLog(@"UUID :%@", deviceUdn);   //这里输出了UUID
    self.avController = (CGUpnpAvController*)controlPoint;
    
    NSArray * dmsArr = [[NSArray alloc]init];
    //此处可能产生僵尸对象
    dmsArr = [((CGUpnpAvController*)controlPoint) servers];
   
    NSLog(@"dmsArr :%@",dmsArr);
    [self.dataSource removeAllObjects];
    [USER_DEFAULT setObject:[self.dataSource copy]  forKey:@"DmsDevice"];   //此处数据为空
    
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
                                    nil];
            
            
            NSString * HMC_DMSIDTemp =cgUpnpModel.category_id;
            NSString *  subStringTemp= [HMC_DMSIDTemp substringWithRange:NSMakeRange(0,3)];
            if ([subStringTemp isEqualToString:@"HMC"]) {
            
            [self.dataSource addObject:dmsDic];//将数据转为字典存起来
            
            }
            else
            {
                NSLog(@"前缀不是HMC");
            }
        }
        
        
    }
    
    
    
    
    if (self.dataSource == NULL) {
     
    }
    else
    {
        NSLog(@"datasource==:%@",self.dataSource);
        //此处可以判断DLNA的数据是不是变化
        [USER_DEFAULT setObject:[self.dataSource copy]  forKey:@"DmsDevice"];
        NSLog(@"datasource.count %d",self.dataSource.count);
       
        
        //此处添加判断方法，如果有前缀是HMC的设备，则自动连接其IP
        for (int i = 0 ; i<self.dataSource.count; i++) {
            NSArray * HMCListArr = [self.dataSource copy];
            NSDictionary * HMCDicList = [[NSDictionary alloc]init];
            HMCDicList = HMCListArr[i];
            NSString * HMC_DMSID = [HMCDicList objectForKey:@"dmsID"];
             NSString *  subString= [HMC_DMSID substringWithRange:NSMakeRange(0,3)];
            if ([subString isEqualToString:@"HMC"]) {
                NSString * oldHMC_DMSIP =[USER_DEFAULT objectForKey:@"HMC_DMSIP"];
                NSString * HMC_DMSIP =[HMCDicList objectForKey:@"dmsIP"];
                 [USER_DEFAULT setObject:HMC_DMSIP  forKey:@"HMC_DMSIP"];
           
                 [USER_DEFAULT setObject:HMC_DMSID  forKey:@"HMC_DMSID_Name"];
                
                NSLog(@"oldHMC_DMSIP:%@",oldHMC_DMSIP);
                 NSLog(@"DMSIP:4444");
                NSLog(@"DMSIP:此时%@",HMC_DMSIP);
                
                //存储当前的DMS信息（是个字典）
                [USER_DEFAULT setObject:HMCDicList forKey:@"NowDMSDataSourceInfo"];
                
                //这里将service 地址本地存储
                NSString * kSDLB_SYS_SERVERStr =[NSString stringWithFormat:@"http://%@/cgi-bin/cgi_channel_list.cgi?",HMC_DMSIP];    //服务器地址
                [USER_DEFAULT setObject:kSDLB_SYS_SERVERStr  forKey:@"HMCServiceStr"];
              
                //这里将G_device 地址本地存储
//                NSString * G_deviceStr =[NSString stringWithFormat:@"http://%@/test/online_devices",HMC_DMSIP];    //G_device地址
//                [USER_DEFAULT setObject:G_deviceStr  forKey:@"G_deviceStr"];
                
//                #define G_device  @"http://192.168.1.55/test/online_devices //@"http://www.tenbre.net/test/online_devices"//
//                #define kSDLB_SYS_SERVER(x) [NSString stringWithFormat:@"http://%@/cgi-bin/cgi_channel_list.cgi?",x]    //服务器地址
//                if (openfirst == 1) {
//                    {
////                    即使相同也运行
//                    }else
//                    {
////                    不运行
//                    }
                
                //第一次打应用，防止oldDMS的IP和DMSIP相同，所以这里先做一次请求
                if (openfirst == 1) {
                    openfirst++;
                    NSLog(@"IP出现一次不同");
                    NSLog(@"DMSIP:5555");
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"IPHasChanged" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
                    //创建通知
                    NSNotification *notification1 =[NSNotification notificationWithName:@"HMCHasChanged" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];                }
                else{
                    if (! [oldHMC_DMSIP isEqualToString: HMC_DMSIP]) {
                        NSLog(@"IP出现一次不同");
                        NSLog(@"DMSIP:5555");
                        //创建通知
                        NSNotification *notification =[NSNotification notificationWithName:@"IPHasChanged" object:nil userInfo:nil];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                        
                        //创建通知
                        NSNotification *notification1 =[NSNotification notificationWithName:@"HMCHasChanged" object:nil userInfo:nil];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                        
                    }
                }

            }
        }
        
    }
    //存储总的DMS的DataSource信息
    [USER_DEFAULT setObject:self.dataSource forKey:@"DMSDataSourceInfo"];
    
//    //此处可以判断DLNA的数据是不是变化
    newDmsArr = [self.dataSource copy];
//    [self judgeDmsDevice:oldDmsArr newDms:newDmsArr];

    
    //    int dmsNum = 0;
        
    //    [self loadUI];

    
    NSLog(@"Device delegate");
}
//判断新旧数据是否一样，不一样通知刷新DMS列表
-(void) judgeDmsDevice :(NSArray *)oldDmsArr newDms:(NSArray *)newDmsArr
{
   if(oldDmsArr ==NULL && newDmsArr!=NULL)
   {
       //刷新
   }else if (oldDmsArr !=NULL && newDmsArr == NULL)
   {
       //刷新
   }else if (oldDmsArr !=NULL && newDmsArr != NULL)
   {
       if (oldDmsArr.count != newDmsArr.count) {
           //刷新
       }else{
       
       for (int a = 0; a<oldDmsArr.count; a++) {
           //        CGUpnpDevice *oldDev = oldDmsArr[a];
           //        CGUpnpDeviceModel* cgUpnpModel;   //model
           NSDictionary * dicTest = [[NSDictionary alloc]init];
           dicTest = oldDmsArr[a];
           CGUpnpDeviceModel* cgModelTest = [[CGUpnpDeviceModel alloc]init];   //model
           
           cgModelTest.category_id = [dicTest objectForKey:@"dmsID"];
           cgModelTest.UUID = [dicTest objectForKey:@"dmsUUID"];
           cgModelTest.ipaddress = [dicTest objectForKey:@"dmsIP"];
           
           for (int b = 0; b<newDmsArr.count; b++) {
               
               NSDictionary * newDicTest = [[NSDictionary alloc]init];
               newDicTest = newDmsArr[b];
               CGUpnpDeviceModel* newCgModelTest = [[CGUpnpDeviceModel alloc]init];   //model
               
               newCgModelTest.category_id = [newDicTest objectForKey:@"dmsID"];
               newCgModelTest.UUID = [newDicTest objectForKey:@"dmsUUID"];
               newCgModelTest.ipaddress = [newDicTest objectForKey:@"dmsIP"];
               
               if ([cgModelTest.category_id isEqualToString:newCgModelTest.category_id] &&[cgModelTest.UUID isEqualToString:newCgModelTest.UUID]&&[cgModelTest.ipaddress isEqualToString:newCgModelTest.ipaddress] ) {
                   //此时全部相等，不做处理
               }else
               {
                   //刷新
               }
               
           }
       }
       }
   }
    
}

-(void)checkIPTimer
{
//    NSString * IPstrNow = [GGUtil getIPAddress];
    NSString * IPstrNow=  [GGUtil getIPAddress:YES];
    if ([IPstrNow isEqualToString:self.ipString]) {
        
    }else
    {
    
        NSLog(@"IP 网络改变");
        
        [self.dataSource removeAllObjects];
        [USER_DEFAULT setObject:[self.dataSource copy]  forKey:@"DmsDevice"];   //此处数据为空
        
        self.ipString = IPstrNow;
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"IPHasChanged" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        //创建通知
        NSNotification *notificationDevice =[NSNotification notificationWithName:@"IPHasChangedDevice" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notificationDevice];
    }
    
}
@end
