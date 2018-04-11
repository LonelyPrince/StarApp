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
@synthesize avRenderer = _avRenderer;


//**** dms 搜索用

@synthesize avController;
@synthesize cgUpnpModel;
@synthesize avCtrl;
//第一次打开
//@synthesize openfirst;
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
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkIPTimer) userInfo:nil repeats:YES];
    //    self.ipString =  [GGUtil getIPAddress];
    self.ipString =  [GGUtil getIPAddress:YES];
    
    
    //    openfirst = 1;
    
    /*********************************************************************/
    //当真机连接Mac调试的时候把这些注释掉，否则log只会输入到文件中，而不能从xcode的监视器中看到。
    // 如果是真机就保存到Document目录下的dr.log文件中
    //    UIDevice *device = [UIDevice currentDevice];
    //    if (![[device model]isEqualToString:@"iPad Simulator"]) {
    // 开始保存日志文件
  //    [self redirectNSlogToDocumentFolder];
    //    }
    /*********************************************************************/
    
    [USER_DEFAULT setObject:@"NO" forKey:@"滑动了或者点击了"];     //暂时没用，有用了在删除这个注释
    [USER_DEFAULT setObject:@"0" forKey:@"YLSlideTitleViewButtonTagIndexStr"];
    
    [USER_DEFAULT  setObject:@"NO" forKey:@"viewHasAddOver"];  //第一次进入时，显示页面还没有加载完成
    [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"]; // 值为YES，代表首页的频道列表还没有展示出来，这个时候不允许旋转
    [USER_DEFAULT setObject:@"" forKey:@"NeedShowChannelNameLabV"];
    
    [self getCurrentLanguage];
    [self.window makeKeyAndVisible];
    [USER_DEFAULT setObject:@"" forKey:@"playStateType"];
    [USER_DEFAULT setObject:nil forKey:@"MutableAudioInfo"];
    return YES;
}
- (void)getCurrentLanguage
{
    //    NSArray *languages = [NSLocale preferredLanguages];
    //    NSString *currentLanguage = [languages objectAtIndex:0];
    //    NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    //    NSLog( @"当前的语言%@" , localeLanguageCode);
    //    [USER_DEFAULT setObject:localeLanguageCode forKey:@"systemLocalLanguage"];
    
    NSString* strLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if (strLanguage.length >=2) {
        NSString *str1 = [strLanguage substringToIndex:2];
        [USER_DEFAULT setObject:str1 forKey:@"systemLocalLanguage"];
        NSLog( @"当前的语言00%@" , str1);
    }
    
    NSLog( @"当前的语言11%@" , strLanguage);
    //
    //    NSString* strLanguage2 = [[NSLocale currentLocale] localeIdentifier];
    //    NSLog( @"当前的语言22%@" , strLanguage2);
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
        [mailUrl appendString:@"mailto:zhaoxf@startimes.com.cn"];
        [mailUrl appendString:@"?subject=程序异常崩溃，请配合发送异常报告，谢谢合作！"];
        [mailUrl appendFormat:@"&body=%@", content];
        // 打开地址
        NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
    
}
#pragma mark 输入日志
- (void)redirectNSlogToDocumentFolder
{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"dr.log"];//注意不是NSData!
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    //先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:logFilePath error:nil];
    
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stderr);
}
+ (AppDelegate *)shareAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
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
- (void)applicationWillResignActive:(UIApplication *)application
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"judgeJumpFromOtherViewjudgeJumpFromOtherView");
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
        NSLog(@"取消25秒的等待1");
        
        
    });
    
    
    NSNotification *notification =[NSNotification notificationWithName:@"homeBtnClickNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    printf("按理说是触发home按下\n");
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    double delayInSeconds = 1.5;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, mainQueue, ^{
        
        
        printf("按理说是重新进来后响应\n");
        
        NSString *  viewIsTVView =  [USER_DEFAULT objectForKey:@"viewISTVView"];
        NSString *  viewHasAddOver =  [USER_DEFAULT objectForKey:@"viewHasAddOver"];  //页面已经加载完成
        
        if ([viewIsTVView isEqualToString:@"1"]  && [viewHasAddOver isEqualToString:@"YES"]) {
            //是TV页面，需要重新播放第一个视频
            
            NSNotification *notification =[NSNotification notificationWithName:@"returnFromHomeToTVViewNotific" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        }
        
    });
    
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
            if (HMC_DMSIDTemp.length>= 3) {
                NSString *  subStringTemp= [HMC_DMSIDTemp substringWithRange:NSMakeRange(0,3)];
                if ([subStringTemp isEqualToString:@"HMC"]) {
                    
                    [self.dataSource addObject:dmsDic];//将数据转为字典存起来
                    
                }
                else
                {
                    NSLog(@"前缀不是HMC");
                }
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
                //                if (openfirst == 1) {
                //                    openfirst++;
                //                    NSLog(@"IP出现一次======不同");
                //                    NSLog(@"DMSIP:5555");
                //                    //创建通知
                //                    NSNotification *notification =[NSNotification notificationWithName:@"IPHasChanged" object:nil userInfo:nil];
                //                    //通过通知中心发送通知
                //                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                //
                //                    //创建通知
                //                    NSNotification *notification1 =[NSNotification notificationWithName:@"HMCHasChanged" object:nil userInfo:nil];
                //                    //通过通知中心发送通知
                //                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                //                }
                //                else{
                //                    if (! [oldHMC_DMSIP isEqualToString: HMC_DMSIP]) {
                //                        NSLog(@"IP出现一次不同");
                //                        NSLog(@"DMSIP:5555");
                //                        //创建通知
                //                        NSNotification *notification =[NSNotification notificationWithName:@"IPHasChanged" object:nil userInfo:nil];
                //                        //通过通知中心发送通知
                //                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                //
                //                        //创建通知
                //                        NSNotification *notification1 =[NSNotification notificationWithName:@"HMCHasChanged" object:nil userInfo:nil];
                //                        //通过通知中心发送通知
                //                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                //
                //                    }
                //                }
                
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
//{
//    //    NSString * IPstrNow = [GGUtil getIPAddress];
//
//
//    NSString *  viewHasAddOver =  [USER_DEFAULT objectForKey:@"viewHasAddOver"];  //页面已经加载完成
//
//    if ([viewHasAddOver isEqualToString:@"NO"]) {
//        //是TV页面，需要重新播放第一个视频
//
//        NSLog(@" checkIPTimer IP 1 %@", self.ipString);
//        NSString * IPstrNow=  [GGUtil getIPAddress:YES];
//        if ([IPstrNow isEqualToString:self.ipString]) {
//
//        }else
//        {
//            NSLog(@" checkIPTimer IP 不一样了 2 %@", self.ipString);
//
//            NSLog(@"IP 网络改变");
//            NSLog(@"IP 改变了在 checkIPTimer");
//
//            [self.dataSource removeAllObjects];
//            [USER_DEFAULT setObject:[self.dataSource copy]  forKey:@"DmsDevice"];   //此处数据为空
//
//            self.ipString = IPstrNow;
//            //创建通知
//            NSNotification *notification =[NSNotification notificationWithName:@"IPHasChanged" object:nil userInfo:nil];
//            //通过通知中心发送通知
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//
//
//        }
//    }
//
//
//
//    NSString * IPstrNow=  [GGUtil getIPAddress:YES];
//    if ([IPstrNow isEqualToString:self.ipString]) {
//
//        NSLog(@"网络没问题");
//        self.judgeNetWorkIsError = 0;
//    }else
//    {
//        if (self.judgeNetWorkIsError == 0) {
//            NSURL *url1 = [NSURL URLWithString:[USER_DEFAULT objectForKey:@"HMCServiceStr"]];
//            NSURLRequest *request = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:2];
//            NSHTTPURLResponse *response;
//            NSOperationQueue *queue=[NSOperationQueue mainQueue];
//            [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil];
//            self.judgeNetWorkIsError = 1;
//            if (response == nil) {
//                NSLog(@"网络错误");
//                [USER_DEFAULT setObject:mediaDisConnect forKey:@"playStateType"];
//                [USER_DEFAULT setObject:@"Lab" forKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
//
//                NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
//                //        //通过通知中心发送通知
//                [[NSNotificationCenter defaultCenter] postNotification:notification];
//            }
//            else{
//
//                NSLog(@" IPstrNow 1 %@", IPstrNow);
//                NSLog(@" self.ipString %@", self.ipString);
//                NSLog(@"网络正确");
//            }
//        }
//
//
//
//
////        、、、、
//
////        if (([[Reachability reachabilityWithHostname:[USER_DEFAULT objectForKey:@"HMCServiceStr"]] currentReachabilityStatus] == NotReachable)) {
////
////            NSLog(@" IPstrNow 1 %@", IPstrNow);
////            NSLog(@" self.ipString %@", self.ipString);
////            NSLog(@"网络正确");
////        }else
////        {
////            NSLog(@"网络错误");
////            [USER_DEFAULT setObject:mediaDisConnect forKey:@"playStateType"];
////            [USER_DEFAULT setObject:@"Lab" forKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
////
////            NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
////            //        //通过通知中心发送通知
////            [[NSNotificationCenter defaultCenter] postNotification:notification];
////
////        }
//
//    }
//
//}
{
    //    NSString * IPstrNow = [GGUtil getIPAddress];
    
    NSString *  viewHasAddOver =  [USER_DEFAULT objectForKey:@"viewHasAddOver"];  //页面已经加载完成
    
    if ([viewHasAddOver isEqualToString:@"NO"]) {
        //是TV页面，需要重新播放第一个视频
        
        NSLog(@" checkIPTimer IP 1 %@", self.ipString);
        NSString * IPstrNow=  [GGUtil getIPAddress:YES];
        if ([IPstrNow isEqualToString:self.ipString]) {
            
        }else
        {
            NSLog(@" checkIPTimer IP 不一样了 2 %@", self.ipString);
            
            NSLog(@"IP 网络改变");
            NSLog(@"IP 改变了在 checkIPTimer");
            
            [self.dataSource removeAllObjects];
            [USER_DEFAULT setObject:[self.dataSource copy]  forKey:@"DmsDevice"];   //此处数据为空
            
            self.ipString = IPstrNow;
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"IPHasChanged" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            
        }
    }
}
@end

