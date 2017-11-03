//
//  RouterStatusView.m
//  StarAPP
//
//  Created by xyz on 2017/10/30.
//

#import "RouterStatusView.h"
#import "MEViewController.h"
@interface RouterStatusView ()
{
    NSDictionary * deviceDic;
    NSDictionary * deviceDic2;
    NSString * routeName_seted;
    
    MBProgressHUD * HUD;
    UIView *  netWorkErrorView;
    
    NSString * DMSIP;
}
@property(nonatomic,strong)MEViewController * meViewController;
@end

@implementation RouterStatusView

@synthesize HardwareVersionLab;
@synthesize SortwareVersionLab;
@synthesize BuildDataLab;
@synthesize SerialNumberLab;
@synthesize MacAddressLab;
@synthesize SubnetMaskLab;
@synthesize IPAddressLab;
//@synthesize connectDevice;
//@synthesize tableView;
//@synthesize onlineDeviceDic;

@synthesize wifiDic;
@synthesize wifiName;
@synthesize wifiIP;
@synthesize wifiPwd;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    self.meViewController = [[MEViewController alloc]init];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"routeNetWorkError" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetWorkErrorView) name:@"routeNetWorkError" object:nil];
}
-(void)loadNav
{
    self.title = @"Router Status";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillAppear:(BOOL)animated
{
     DMSIP = [USER_DEFAULT objectForKey:@"RouterPsw"];
    if (DMSIP != nil && DMSIP != NULL && DMSIP.length > 0) {
//        [self getOnlineDevice];
        [self getVersionInfo];
        [self getNetworkInfo];
        [self getWifi];
    }
    
}
-(void)getVersionInfo
{
    
    //获取数据的链接
    NSString * url =     [NSString stringWithFormat:@"http://%@/lua/guide/RouterVersion",DMSIP];
    //    NSString *url = [NSString stringWithFormat:@"%@",G_device];
    //    NSString *url = [NSString stringWithFormat:@"%@",G_device];
    
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
    [request setNumberOfTimesToRetryOnTimeout:5];
    [request startAsynchronous ];
    
    
    [request setStartedBlock:^{
        //请求开始的时候调用
        //用转圈代替
        
        
        HUD.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        //如果设置此属性则当前的view置于后台
        
        [HUD showAnimated:YES];
        
        
        //设置对话框文字
        
        HUD.labelText = @"loading";
        //        NSLog(@"scroller : %@",scrollView);
        NSLog(@"HUD : %@",HUD);
        [self.view addSubview:HUD];
        
        
        NSLog(@"请求开始的时候调用");
    }];
    
    
    
    [request setCompletionBlock:^{
        
        NSArray *onlineDeviceDic = [request responseData].JSONValue;
        deviceDic = onlineDeviceDic;
        NSLog(@"deviceDic :%@",deviceDic);
        if (deviceDic.count == 0|| deviceDic ==NULL ) {
            
            NSLog(@"请求失败的时候调用");
            
            [HUD removeFromSuperview];
            HUD = nil;
            
            netWorkErrorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            UIImageView * hudImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 616/2)/2, 120, 616/2, 348/2)];
            hudImage.image = [UIImage imageNamed:@"网络无连接"];
            
            CGSize size = [GGUtil sizeWithText:@"Network Error" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            UILabel * hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
            hudLab.text = @"Network Error";
            hudLab.font = FONT(15);
            hudLab.textColor = [UIColor grayColor];
            
            //        [scrollView addSubview:netWorkErrorView];
            //            [scrollView addSubview:netWorkErrorView];
            [self.view addSubview:netWorkErrorView];
            [netWorkErrorView addSubview:hudImage];
            [netWorkErrorView addSubview:hudLab];
            
        }else
        {
            [HUD removeFromSuperview];
            HUD = nil;
            [netWorkErrorView removeFromSuperview];
            netWorkErrorView = nil;
            
            NSError *error = [request error ];
            assert (!error);
            // 如果请求成功，返回 Response
            NSLog ( @"request:%@" ,request);
//            NSMutableArray * arrOnline = [[NSMutableArray alloc]init];
//            NSArray * allDeviceArr = [request responseData].JSONValue;
//            for (int i = 0 ; i<allDeviceArr.count ; i++) {
//                NSLog(@"abcd %@",[allDeviceArr[i] objectForKey:@"online_flag"]);
//                if ([[allDeviceArr[i] objectForKey:@"online_flag"] intValue]== 2) { //online_flag 为2代表在线
//
//                    [arrOnline addObject:allDeviceArr[i]];
//                }
//            }
            
            
            
            
            //        NSArray *onlineDeviceArr = [request responseData].JSONValue;
            //        deviceArr = onlineDeviceArr;
//            deviceArr = [arrOnline copy];
//            //        NSLog ( @"onlineDeviceArr:%@" ,onlineDeviceArr);
//            NSLog ( @"deviceArr:%@" ,deviceArr);
            
            //            [self loadNav];
            //            [self loadScroll];
//            [self loadUI];
            //            [self getWifi];
            //            [self loadTableView];
          
            HardwareVersionLab.text = [deviceDic objectForKey:@"hardVersion"];
            SortwareVersionLab.text = [deviceDic objectForKey:@"softVersion"];
            SerialNumberLab.text = [deviceDic objectForKey:@"SNnum"];
            BuildDataLab.text = [deviceDic objectForKey:@"releaseVersion"];
          
        }
    }];
    
    
    
    
    
    
    
}
-(void)getNetworkInfo
{
    
    //获取数据的链接
    NSString * url =     [NSString stringWithFormat:@"http://%@/lua/guide/getRouterNetworkInfo",DMSIP];
    //    NSString *url = [NSString stringWithFormat:@"%@",G_device];
    //    NSString *url = [NSString stringWithFormat:@"%@",G_device];
    
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
    [request setNumberOfTimesToRetryOnTimeout:5];
    [request startAsynchronous ];
    
    
//    [request setStartedBlock:^{
//        //请求开始的时候调用
//        //用转圈代替
//
//
//        HUD.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//
//        //如果设置此属性则当前的view置于后台
//
//        [HUD showAnimated:YES];
//
//
//        //设置对话框文字
//
//        HUD.labelText = @"loading";
//        //        NSLog(@"scroller : %@",scrollView);
//        NSLog(@"HUD : %@",HUD);
//        [self.view addSubview:HUD];
//
//
//        NSLog(@"请求开始的时候调用");
//    }];
    
    
    
    [request setCompletionBlock:^{
        
        NSArray *onlineDeviceDic = [request responseData].JSONValue;
        deviceDic2 = onlineDeviceDic;
        NSLog(@"deviceDic :%@",deviceDic2);
        if (deviceDic2.count == 0|| deviceDic2 ==NULL ) {
            
//            NSLog(@"请求失败的时候调用");
//
//            [HUD removeFromSuperview];
//            HUD = nil;
//
//            netWorkErrorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            UIImageView * hudImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 616/2)/2, 120, 616/2, 348/2)];
//            hudImage.image = [UIImage imageNamed:@"网络无连接"];
//
//            CGSize size = [GGUtil sizeWithText:@"Network Error" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//            UILabel * hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
//            hudLab.text = @"Network Error";
//            hudLab.font = FONT(15);
//            hudLab.textColor = [UIColor grayColor];
//
//            //        [scrollView addSubview:netWorkErrorView];
//            //            [scrollView addSubview:netWorkErrorView];
//            [self.view addSubview:netWorkErrorView];
//            [netWorkErrorView addSubview:hudImage];
//            [netWorkErrorView addSubview:hudLab];
            
        }else
        {
            [HUD removeFromSuperview];
            HUD = nil;
            [netWorkErrorView removeFromSuperview];
            netWorkErrorView = nil;
            
            NSError *error = [request error ];
            assert (!error);
            // 如果请求成功，返回 Response
            NSLog ( @"request:%@" ,request);
            //            NSMutableArray * arrOnline = [[NSMutableArray alloc]init];
            //            NSArray * allDeviceArr = [request responseData].JSONValue;
            //            for (int i = 0 ; i<allDeviceArr.count ; i++) {
            //                NSLog(@"abcd %@",[allDeviceArr[i] objectForKey:@"online_flag"]);
            //                if ([[allDeviceArr[i] objectForKey:@"online_flag"] intValue]== 2) { //online_flag 为2代表在线
            //
            //                    [arrOnline addObject:allDeviceArr[i]];
            //                }
            //            }
            
            
            
            
            //        NSArray *onlineDeviceArr = [request responseData].JSONValue;
            //        deviceArr = onlineDeviceArr;
            //            deviceArr = [arrOnline copy];
            //            //        NSLog ( @"onlineDeviceArr:%@" ,onlineDeviceArr);
            //            NSLog ( @"deviceArr:%@" ,deviceArr);
            
            //            [self loadNav];
            //            [self loadScroll];
            //            [self loadUI];
            //            [self getWifi];
            //            [self loadTableView];
            
            MacAddressLab.text = [deviceDic2 objectForKey:@"netmask"];
            SubnetMaskLab.text = [deviceDic2 objectForKey:@"mac"];
            IPAddressLab.text = [deviceDic2 objectForKey:@"gateway"];
            
        }
    }];
    
    
    
    
    
    
    
}
-(void)loadData
{
    
}
//
-(void)getWifi
{

    //获取数据的链接
    NSString * url =     [NSString stringWithFormat:@"http://%@/lua/settings/wifi",DMSIP];
    //    NSString *url = [NSString stringWithFormat:@"%@",G_devicepwd];

    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];

    [request startAsynchronous ];

    //    NSError *error = [request error ];
    //    assert (!error);
    // 如果请求成功，返回 Response


    [request setCompletionBlock:^{
        NSLog ( @"request:%@" ,request);
        NSDictionary *onlineWifi = [request responseData].JSONValue;
        NSLog ( @"onlineDeviceArr:%@" ,onlineWifi);
        wifiDic = [[NSDictionary alloc]init];
        wifiDic = onlineWifi;


//        routeNameLab.text = [wifiDic objectForKey:@"name"];
//
//        //        routeIPLab.text =  @"IP:192.168.1.1" ;//[wifiDic objectForKey:@"ip"];
//        routeIPLab.text = [NSString stringWithFormat:@"IP:%@",DMSIP];
    }];




}
//-(void)getOnlineDevice
//{
//
//    //    NSString * GdeviceStr = [USER_DEFAULT objectForKey:@"G_deviceStr"];   //获取本地化的GDevice
//
//    //获取数据的链接
//    NSString * url =     [NSString stringWithFormat:@"http://%@/test/online_devices",DMSIP];
//    //    NSString *url = [NSString stringWithFormat:@"%@",G_device];
//    //    NSString *url = [NSString stringWithFormat:@"%@",G_device];
//
//    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
//    [request setNumberOfTimesToRetryOnTimeout:5];
//    [request startAsynchronous ];
//
//
//    [request setStartedBlock:^{
//        //请求开始的时候调用
//        //用转圈代替
//
//
//        HUD.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//
//        //如果设置此属性则当前的view置于后台
//
//        [HUD showAnimated:YES];
//
//
//        //设置对话框文字
//
//        HUD.labelText = @"loading";
////        NSLog(@"scroller : %@",scrollView);
//        NSLog(@"HUD : %@",HUD);
//        [self.view addSubview:HUD];
//
//
//        NSLog(@"请求开始的时候调用");
//    }];
//
//
//
//    [request setCompletionBlock:^{
//
//        NSArray *onlineDeviceArr = [request responseData].JSONValue;
//        deviceArr = onlineDeviceArr;
//        NSLog(@"deviceArr :%@",deviceArr);
//        if (deviceArr.count == 0|| deviceArr ==NULL ) {
//
//            NSLog(@"请求失败的时候调用");
//
//            [HUD removeFromSuperview];
//            HUD = nil;
//
//            netWorkErrorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            UIImageView * hudImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 616/2)/2, 120, 616/2, 348/2)];
//            hudImage.image = [UIImage imageNamed:@"网络无连接"];
//
//            CGSize size = [GGUtil sizeWithText:@"Network Error" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//            UILabel * hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
//            hudLab.text = @"Network Error";
//            hudLab.font = FONT(15);
//            hudLab.textColor = [UIColor grayColor];
//
//            //        [scrollView addSubview:netWorkErrorView];
////            [scrollView addSubview:netWorkErrorView];
//            [self.view addSubview:netWorkErrorView];
//            [netWorkErrorView addSubview:hudImage];
//            [netWorkErrorView addSubview:hudLab];
//
//        }else
//        {
//            [HUD removeFromSuperview];
//            HUD = nil;
//            [netWorkErrorView removeFromSuperview];
//            netWorkErrorView = nil;
//
//            NSError *error = [request error ];
//            assert (!error);
//            // 如果请求成功，返回 Response
//            NSLog ( @"request:%@" ,request);
//            NSMutableArray * arrOnline = [[NSMutableArray alloc]init];
//            NSArray * allDeviceArr = [request responseData].JSONValue;
//            for (int i = 0 ; i<allDeviceArr.count ; i++) {
//                NSLog(@"abcd %@",[allDeviceArr[i] objectForKey:@"online_flag"]);
//                if ([[allDeviceArr[i] objectForKey:@"online_flag"] intValue]== 2) { //online_flag 为2代表在线
//
//                    [arrOnline addObject:allDeviceArr[i]];
//                }
//            }
//
//
//
//
//            //        NSArray *onlineDeviceArr = [request responseData].JSONValue;
//            //        deviceArr = onlineDeviceArr;
//            deviceArr = [arrOnline copy];
//            //        NSLog ( @"onlineDeviceArr:%@" ,onlineDeviceArr);
//            NSLog ( @"deviceArr:%@" ,deviceArr);
//
//            //            [self loadNav];
//            //            [self loadScroll];
//            [self loadUI];
//            //            [self getWifi];
////            [self loadTableView];
//        }
//    }];
//
//
//
//
//
//
//
//}
- (void)getSocketIpInfo:(NSNotification *)text{

    NSData * socketIPData = text.userInfo[@"socketIPAddress"];
    NSData * ipStrData ;
    NSLog(@"socketIPData :%@",socketIPData);

    if (socketIPData != NULL  && socketIPData != nil  &&  socketIPData.length > 0 ) {

        if (socketIPData.length >38) {

            if ([socketIPData length] >= 1 + 37 + socketIPData.length - 38) {
                ipStrData = [socketIPData subdataWithRange:NSMakeRange(1 + 37,socketIPData.length - 38)];
            }else
            {
                return;
            }

            NSLog(@"ipStrData %@",ipStrData);

            DMSIP =  [[NSString alloc] initWithData:ipStrData  encoding:NSUTF8StringEncoding];
            NSLog(@" DMSIP %@",DMSIP);

            //            [self loadNav];
            [self viewWillAppear:YES];
        }

    }


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 加载无网络图
-(void)showNetWorkErrorView
{
    NSLog(@"showNetWorkErroshowNetWorkErrorVasdadsads");
    //1.取消掉加载圈
    //    [self hudHidden];
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self.timerForASIHttp invalidate];
    //        self.timerForASIHttp = nil;
    //
    //    });
    
    if (self.NetWorkErrorView == nil) {
        self.NetWorkErrorView = [[UIView alloc]init];
    }
    if (self.NetWorkErrorImageView == nil) {
        self.NetWorkErrorImageView = [[UIImageView alloc]init];
    }
    if (self.NetWorkErrorLab == nil) {
        self.NetWorkErrorLab = [[UILabel alloc]init];
    }
    self.NetWorkErrorView.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.NetWorkErrorView.backgroundColor = [UIColor whiteColor];
    
    
    self.NetWorkErrorImageView.frame =CGRectMake((SCREEN_WIDTH - 139*0.5)/2, (SCREEN_HEIGHT - 90)/2, 139*0.5, 110*0.5);
    self.NetWorkErrorImageView.image = [UIImage imageNamed:@"路由无网络"];
    
    
    self.NetWorkErrorLab.frame = CGRectMake((SCREEN_WIDTH - 90)/2, self.NetWorkErrorImageView.frame.origin.y+60, 150, 50);
    self.NetWorkErrorLab.text = @"NetWork Error";
    self.NetWorkErrorLab.font = FONT(15);
    
    
    
    
    
    [self.view addSubview:self.NetWorkErrorView];
    [self.NetWorkErrorView addSubview:self.NetWorkErrorImageView];
    [self.NetWorkErrorView addSubview:self.NetWorkErrorLab];
    
    
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
    
    
    self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
    self.navigationItem.leftBarButtonItem = myButton;
}

-(void)clickEvent
{
    
    NSLog(@"self.navigationController %@",self.navigationController.viewControllers);
    
    //遍历看是否有MEViewcontroller这个页面
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[self.meViewController class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }
    
    
    self.tabBarController.tabBar.hidden = YES;
    
}
@end