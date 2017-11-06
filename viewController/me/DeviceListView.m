//
//  DeviceListView.m
//  StarAPP
//
//  Created by xyz on 2017/10/23.
//

#import "DeviceListView.h"
#import "MEViewController.h"
@interface DeviceListView ()
{
    NSArray * deviceArr;
    NSString * routeName_seted;
    
    MBProgressHUD * HUD;
    UIView *  netWorkErrorView;
    
    NSString * DMSIP;
}
@property(nonatomic,strong)MEViewController * meViewController;
@end

@implementation DeviceListView
@synthesize routeImage;
@synthesize editImage;
@synthesize editBtn;
@synthesize routeNameLab;
@synthesize routeIPLab;
@synthesize scrollView;
@synthesize centerGrayView;
//@synthesize connectDevice;
@synthesize tableView;
@synthesize onlineDeviceDic;

@synthesize wifiDic;
@synthesize wifiName;
@synthesize wifiIP;
@synthesize wifiPwd;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNav];
    [self initData];    //初始化数据，new
    [self loadScroll];
    
    
    //////////////////////////// 从socket返回数据
    //此处接收到路由器IP地址的消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getSocketIpInfoNotice" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSocketIpInfo:) name:@"getSocketIpInfoNotice" object:nil];
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"socketGetIPAddressNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"routeNetWorkError" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetWorkErrorView) name:@"routeNetWorkError" object:nil];
    

}
-(void)loadNav
{
    self.title = @"Device List";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.deviceListCell = [[DeviceListCell alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (DMSIP != nil && DMSIP != NULL && DMSIP.length > 0) {
        [self getOnlineDevice];
        [self getWifi];
    }
    
}
-(void)initData
{
    //  [self loadNav];
    self.meViewController = [[MEViewController alloc]init];
    scrollView = [[UIScrollView alloc]init];
    routeImage = [[UIImageView alloc]init];
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    routeNameLab = [[UILabel alloc]init];
    routeIPLab = [[UILabel alloc]init];
    centerGrayView = [[UIView alloc]init];
//    connectDevice = [[UILabel alloc]init];
    
    HUD = [[MBProgressHUD alloc]init];
    netWorkErrorView = [[UIView alloc]init];
    tableView = [[UITableView alloc]init];
}
-(void)loadUI
{
    
    
//    routeImage.frame = CGRectMake(MARGINLEFT, ROUTEMARFINTOP, ROUTEWIDTH, ROUTEWIDTH);
//    routeImage.image = [UIImage imageNamed:@"luyou"];
//    [scrollView addSubview:routeImage];
    /**/
    //    editImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - (40+34)/2, 20, EDITWIDTH, EDITWIDTH)];
    //    editImage.image = [UIImage imageNamed:@"bianji"];
    //    [scrollView addSubview:editImage];
    
    
    
//    editBtn.frame = CGRectMake(SCREEN_WIDTH - (40+34)/2, 20, EDITWIDTH, EDITWIDTH);
//    [editBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
//    [editBtn addTarget:self action:@selector(eidtBtnClick) forControlEvents:UIControlEventTouchUpInside];
//
//    [editBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
//
//    [scrollView addSubview:editBtn];
    
    
    
    
    
//    routeNameLab.frame = CGRectMake(40+ROUTEWIDTH, ROUTENAME_Y, 200, 17);
//
//    routeNameLab.font = FONT(15);
//    routeNameLab.textColor = RGBA(148, 148, 148, 1);
//
//
//    routeIPLab.font = FONT(13);
//    routeIPLab.textColor = RGBA(193, 193, 193, 1);
//
//    routeIPLab.frame = CGRectMake(40+ROUTEWIDTH, ROUTENAME_Y+10+15, 200, 13);
//    [scrollView addSubview:routeNameLab];
//    [scrollView addSubview:routeIPLab];
//
//
//    centerGrayView.frame = CGRectMake(0, 298/2, SCREEN_WIDTH, 6);
//    centerGrayView.backgroundColor  = RGBA(239, 239, 239, 1);
//    [scrollView addSubview:centerGrayView];
//
//
//
//    connectDevice.frame = CGRectMake(20, 298/2+6+15, 200, 15);
//    connectDevice.text = @"Connected devices";
//    connectDevice.font = FONT(15);
//    connectDevice.textColor = RGBA(148, 148, 148, 1);
//    [scrollView addSubview:connectDevice];
    
    
}
-(void)loadScroll
{
    
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
    [self.view addSubview:scrollView];
    
    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-128 );
    NSLog(@"deviceArr.count111 :%d",deviceArr.count);
    scrollView.showsVerticalScrollIndicator=YES;
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.delegate=self;
    scrollView.bounces = NO;
    //    scrollView.backgroundColor = [UIColor redColor];
    NSLog(@"scroll x:%f",scrollView.bounds.origin.x);
    NSLog(@"scroll y:%f",scrollView.bounds.origin.y);
    NSLog(@"scroll w:%f",scrollView.bounds.size.width);
    NSLog(@"scroll h:%f",scrollView.bounds.size.height);
    //    scrollView.backgroundColor = [UIColor redColor];
}
-(void)loadTableView
{
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, deviceArr.count*69);
    
    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, deviceArr.count*69 - 64 + 50);
    //    tableView.style = UITableViewStylePlain;
    //    tableView  UITableViewStylePlain;
    //tableview 的高度待定
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [scrollView addSubview:tableView];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [tableView setTableFooterView:v];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"deviceArr.count: %d",deviceArr.count);
    return  deviceArr.count;
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceListCell"];
    if (cell == nil){
        cell = [DeviceListCell loadFromNib];
        cell.backgroundColor=[UIColor clearColor];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
        
        //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    
    //    NSArray * arr =
    
    for (int i =0; i<deviceArr.count; i++) {
        onlineDeviceDic = deviceArr[indexPath.row];
        
        cell.dataDic = onlineDeviceDic;
    }
    
    //赋值
    
    //    cell.deviceImage.image = [UIImage imageNamed:@"routenoKnow"];
    //
    //    cell.deviceNameLab.text = @"HMC123123123";
    //    cell.deviceIPLab.text = @"192.168.1.1";
    //    cell.deviceMacLab.text = @"01.12.a2.12.12";
    //
    //
    //    cell.deviceNameLab.textColor = RGBA(148, 148, 148, 1);
    //    cell.deviceIPLab.textColor = RGBA(193, 193, 193, 1);
    //    cell.deviceMacLab.textColor = RGBA(193, 193, 193, 1);
    
    return  cell;
    
}
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
        
        
        routeNameLab.text = [wifiDic objectForKey:@"name"];
        
        //        routeIPLab.text =  @"IP:192.168.1.1" ;//[wifiDic objectForKey:@"ip"];
        routeIPLab.text = [NSString stringWithFormat:@"IP:%@",DMSIP];
    }];
    
    
    
    
}
-(void)getOnlineDevice
{
    
    //    NSString * GdeviceStr = [USER_DEFAULT objectForKey:@"G_deviceStr"];   //获取本地化的GDevice
    
    //获取数据的链接
    NSString * url =     [NSString stringWithFormat:@"http://%@/test/online_devices",DMSIP];
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
        NSLog(@"scroller : %@",scrollView);
        NSLog(@"HUD : %@",HUD);
        [self.view addSubview:HUD];
        
        
        NSLog(@"请求开始的时候调用");
    }];
    
    
    
    [request setCompletionBlock:^{
        
        NSArray *onlineDeviceArr = [request responseData].JSONValue;
        deviceArr = onlineDeviceArr;
        NSLog(@"deviceArr :%@",deviceArr);
        if (deviceArr.count == 0|| deviceArr ==NULL ) {
            
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
            [scrollView addSubview:netWorkErrorView];
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
            NSMutableArray * arrOnline = [[NSMutableArray alloc]init];
            NSArray * allDeviceArr = [request responseData].JSONValue;
            for (int i = 0 ; i<allDeviceArr.count ; i++) {
                NSLog(@"abcd %@",[allDeviceArr[i] objectForKey:@"online_flag"]);
                if ([[allDeviceArr[i] objectForKey:@"online_flag"] intValue]== 2) { //online_flag 为2代表在线
                    
                    [arrOnline addObject:allDeviceArr[i]];
                }
            }
            
            
            
            
            //        NSArray *onlineDeviceArr = [request responseData].JSONValue;
            //        deviceArr = onlineDeviceArr;
            deviceArr = [arrOnline copy];
            //        NSLog ( @"onlineDeviceArr:%@" ,onlineDeviceArr);
            NSLog ( @"deviceArr:%@" ,deviceArr);
            
//            [self loadNav];
            //            [self loadScroll];
            [self loadUI];
            //            [self getWifi];
            [self loadTableView];
            [self.tableView reloadData];
        }
    }];
    
    
    
    
    
    
    
}
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
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.Animating = NO;
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    
    [super  viewDidDisappear:animated];
    self.Animating = NO;
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
    self.NetWorkErrorLab.text = @"Network Error";
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
