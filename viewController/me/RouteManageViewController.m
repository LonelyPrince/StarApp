////
////  RouteManageViewController.m
////  StarAPP
////
////  Created by xyz on 2016/11/10.
////
////
//
//#import "RouteManageViewController.h"
//
//#define MARGINLEFT 20
//#define ROUTEMARFINTOP 33
//#define ROUTEWIDTH  85.5
//
//#define EDITWIDTH  17
//#define ROUTENAME_Y  66
//@interface RouteManageViewController ()
//{
//    NSArray * deviceArr;
//    NSString * routeName_seted;
//}
//@end
//
//
//@implementation RouteManageViewController
//@synthesize routeImage;
//@synthesize editImage;   @synthesize editBtn;
//@synthesize routeNameLab;
//@synthesize routeIPLab;
//@synthesize scrollView;
//@synthesize centerGrayView;
//@synthesize connectDevice;
//@synthesize tableView;
//@synthesize onlineDeviceDic;
//
//@synthesize wifiDic;
//@synthesize wifiName;
//@synthesize wifiIP;
//@synthesize wifiPwd;
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [self loadNav];
//    [self loadScroll];
//    [self loadUI];
//    [self loadTableView];
//    [self getOnlineDevice];
//    [self getWifi];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(void)loadNav
//{
//    self.title = @"Route management";
//    self.tabBarController.tabBar.hidden = YES;
//    
//    self.routeSetting = [[RouteSetting alloc]init];
//}
//-(void)loadUI
//{
//    
//    
//    routeImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGINLEFT, ROUTEMARFINTOP, ROUTEWIDTH, ROUTEWIDTH)];
//    routeImage.image = [UIImage imageNamed:@"luyou"];
//    [scrollView addSubview:routeImage];
//    /**/
//    //    editImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - (40+34)/2, 20, EDITWIDTH, EDITWIDTH)];
//    //    editImage.image = [UIImage imageNamed:@"bianji"];
//    //    [scrollView addSubview:editImage];
//    
//    
//    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    editBtn.frame = CGRectMake(SCREEN_WIDTH - (40+34)/2, 20, EDITWIDTH, EDITWIDTH);
//    [editBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
//    [editBtn addTarget:self action:@selector(eidtBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView addSubview:editBtn];
//    
//    
//    
//    
//    routeNameLab = [[UILabel alloc]init];
//    routeIPLab = [[UILabel alloc]init];
//    routeNameLab.frame = CGRectMake(40+ROUTEWIDTH, ROUTENAME_Y, 200, 15);
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
//    centerGrayView = [[UIView alloc]initWithFrame:CGRectMake(0, 298/2, SCREEN_WIDTH, 6)];
//    centerGrayView.backgroundColor  = RGBA(239, 239, 239, 1);
//    [scrollView addSubview:centerGrayView];
//    
//    
//    connectDevice = [[UILabel alloc]init];
//    connectDevice.frame = CGRectMake(20, 298/2+6+15, 200, 15);
//    connectDevice.text = @"Connected devices";
//    connectDevice.font = FONT(15);
//    connectDevice.textColor = RGBA(148, 148, 148, 1);
//    [scrollView addSubview:connectDevice];
//    
//    
//}
//-(void)loadScroll
//{
//    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
//    [self.view addSubview:scrollView];
//    
//    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 128);
//    scrollView.showsVerticalScrollIndicator=YES;
//    scrollView.showsHorizontalScrollIndicator=YES;
//    scrollView.delegate=self;
//    scrollView.bounces = NO;
//    //    scrollView.backgroundColor = [UIColor redColor];
//    NSLog(@"scroll x:%f",scrollView.bounds.origin.x);
//    NSLog(@"scroll y:%f",scrollView.bounds.origin.y);
//    NSLog(@"scroll w:%f",scrollView.bounds.size.width);
//    NSLog(@"scroll h:%f",scrollView.bounds.size.height);
//    //    scrollView.backgroundColor = [UIColor redColor];
//}
//-(void)loadTableView
//{
//    
//    
//    
//    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 190, SCREEN_WIDTH, 240)style:UITableViewStylePlain];
//    //tableview 的高度待定
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.scrollEnabled = NO;
//    [scrollView addSubview:tableView];
//    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
//    
//    [tableView setTableFooterView:v];
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
//{
//    
//    return deviceArr.count;
//    
//}
//-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//    
//}
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RouteCell"];
//    if (cell == nil){
//        cell = [RouteCell loadFromNib];
//        cell.backgroundColor=[UIColor clearColor];
//        
//        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
//        
//        //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//    
//    
//    //    NSArray * arr =
//    
//    for (int i =0; i<deviceArr.count; i++) {
//        onlineDeviceDic = deviceArr[indexPath.row];
//        
//        cell.dataDic = onlineDeviceDic;
//    }
//    
//    //赋值
//    
//    //    cell.deviceImage.image = [UIImage imageNamed:@"routenoKnow"];
//    //
//    //    cell.deviceNameLab.text = @"HMC123123123";
//    //    cell.deviceIPLab.text = @"192.168.1.1";
//    //    cell.deviceMacLab.text = @"01.12.a2.12.12";
//    //
//    //
//    //    cell.deviceNameLab.textColor = RGBA(148, 148, 148, 1);
//    //    cell.deviceIPLab.textColor = RGBA(193, 193, 193, 1);
//    //    cell.deviceMacLab.textColor = RGBA(193, 193, 193, 1);
//    
//    return  cell;
//    
//}
//-(void)getOnlineDevice
//{
//    NSString * DMSIP = [USER_DEFAULT objectForKey:@"HMC_DMSIP"];
//    NSString * serviceIp;
//    if (DMSIP != NULL ) {
//        serviceIp = [NSString stringWithFormat:@"http://%@/test/online_devices",DMSIP];
//    }else
//    {
//        //        serviceIp =@"http://192.168.1.55/cgi-bin/cgi_channel_list.cgi?";   //服务器地址
//    }
//
//    //获取数据的链接
//    NSString *url = [NSString stringWithFormat:@"%@",serviceIp];
////        NSString *url = [NSString stringWithFormat:@"%@",G_device];
//    
//    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
//    
//    [request startSynchronous ];
//    
//    NSError *error = [request error ];
//    assert (!error);
//    // 如果请求成功，返回 Response
//    NSLog ( @"request:%@" ,request);
//    NSArray *onlineDeviceArr = [request responseData].JSONValue;
//    deviceArr = onlineDeviceArr;
//    NSLog ( @"onlineDeviceArr:%@" ,onlineDeviceArr);
//    
//    
//    
//    
//}
//
//-(void)getWifi
//{
//    
//    NSString * DMSIP = [USER_DEFAULT objectForKey:@"HMC_DMSIP"];
//    NSString * serviceIp;
//    if (DMSIP != NULL ) {
//        serviceIp = [NSString stringWithFormat:@"http://%@/lua/settings/wifi",DMSIP];
//    }else
//    {
//        //        serviceIp =@"http://192.168.1.55/cgi-bin/cgi_channel_list.cgi?";   //服务器地址
//    }
//    //获取数据的链接
//    NSString *url = [NSString stringWithFormat:@"%@",serviceIp];
////    NSString *url = [NSString stringWithFormat:@"%@",G_devicepwd];
//    
//    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
//    
//    [request startSynchronous ];
//    
//    NSError *error = [request error ];
//    assert (!error);
//    // 如果请求成功，返回 Response
//    NSLog ( @"request:%@" ,request);
//    NSDictionary *onlineWifi = [request responseData].JSONValue;
//    NSLog ( @"onlineDeviceArr:%@" ,onlineWifi);
//    wifiDic = [[NSDictionary alloc]init];
//    wifiDic = onlineWifi;
//    
//    
//    routeNameLab.text = [wifiDic objectForKey:@"name"];
//    
//    routeIPLab.text =  @"IP:192.168.1.1" ;//[wifiDic objectForKey:@"ip"];
//    
//    
//}
//-(void)eidtBtnClick
//{
//    [self.navigationController pushViewController:self.routeSetting animated:YES];
//    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
//    //    self.routeSetting.nameText = [[UITextField alloc]init];
//    //    self.routeSetting.nameText.text =routeNameLab.text;
//    
//    self.routeSetting.nameString = routeNameLab.text;
//    self.routeSetting.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
//    self.routeSetting.navigationItem.leftBarButtonItem = myButton;
//}
//-(void)clickEvent
//{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    //    self.tabBarController.tabBar.hidden = NO;
//    
//    routeName_seted = [USER_DEFAULT objectForKey:@"routeNameUSER"];
//    
//    
//    routeNameLab.text = routeName_seted;
//    
//    
//}
//@end

//
//  RouteManageViewController.m
//  StarAPP
//
//  Created by xyz on 2016/11/10.
//
//

#import "RouteManageViewController.h"
#import "UIButton+EnlargeTouchArea.h"

#define MARGINLEFT 20
#define ROUTEMARFINTOP 33
#define ROUTEWIDTH  85.5

#define EDITWIDTH  17
#define ROUTENAME_Y  66
@interface RouteManageViewController ()
{
    NSArray * deviceArr;
    NSString * routeName_seted;
}
@end


@implementation RouteManageViewController
@synthesize routeImage;
@synthesize editImage;   @synthesize editBtn;
@synthesize routeNameLab;
@synthesize routeIPLab;
@synthesize scrollView;
@synthesize centerGrayView;
@synthesize connectDevice;
@synthesize tableView;
@synthesize onlineDeviceDic;

@synthesize wifiDic;
@synthesize wifiName;
@synthesize wifiIP;
@synthesize wifiPwd;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];    //初始化数据，new
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getOnlineDevice];
    [self loadNav];
    [self loadScroll];
    [self loadUI];
    [self loadTableView];    
    [self getWifi];
}
-(void)initData
{
//  [self loadNav];
    scrollView = [[UIScrollView alloc]init];
    routeImage = [[UIImageView alloc]init];
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    routeNameLab = [[UILabel alloc]init];
    routeIPLab = [[UILabel alloc]init];
    centerGrayView = [[UIView alloc]init];
    connectDevice = [[UILabel alloc]init];
    
    tableView = [[UITableView alloc]init];
}
-(void)loadNav
{
    self.title = @"Route management";
    self.tabBarController.tabBar.hidden = YES;
    
    self.routeSetting = [[RouteSetting alloc]init];
}
-(void)loadUI
{
    
    
    routeImage.frame = CGRectMake(MARGINLEFT, ROUTEMARFINTOP, ROUTEWIDTH, ROUTEWIDTH);
    routeImage.image = [UIImage imageNamed:@"luyou"];
    [scrollView addSubview:routeImage];
    /**/
    //    editImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - (40+34)/2, 20, EDITWIDTH, EDITWIDTH)];
    //    editImage.image = [UIImage imageNamed:@"bianji"];
    //    [scrollView addSubview:editImage];
    
    
    
    editBtn.frame = CGRectMake(SCREEN_WIDTH - (40+34)/2, 20, EDITWIDTH, EDITWIDTH);
    [editBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(eidtBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [editBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [scrollView addSubview:editBtn];
    
    
    
    
  
    routeNameLab.frame = CGRectMake(40+ROUTEWIDTH, ROUTENAME_Y, 200, 15);
    
    routeNameLab.font = FONT(15);
    routeNameLab.textColor = RGBA(148, 148, 148, 1);
    
    
    routeIPLab.font = FONT(13);
    routeIPLab.textColor = RGBA(193, 193, 193, 1);
    
    routeIPLab.frame = CGRectMake(40+ROUTEWIDTH, ROUTENAME_Y+10+15, 200, 13);
    [scrollView addSubview:routeNameLab];
    [scrollView addSubview:routeIPLab];
    
    
    centerGrayView.frame = CGRectMake(0, 298/2, SCREEN_WIDTH, 6);
    centerGrayView.backgroundColor  = RGBA(239, 239, 239, 1);
    [scrollView addSubview:centerGrayView];
    
    
    
    connectDevice.frame = CGRectMake(20, 298/2+6+15, 200, 15);
    connectDevice.text = @"Connected devices";
    connectDevice.font = FONT(15);
    connectDevice.textColor = RGBA(148, 148, 148, 1);
    [scrollView addSubview:connectDevice];
    
    
}
-(void)loadScroll
{

    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
    [self.view addSubview:scrollView];
    
    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 128);
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
    
    
    
    tableView.frame = CGRectMake(0, 190, SCREEN_WIDTH, 240);
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
    return 80;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RouteCell"];
    if (cell == nil){
        cell = [RouteCell loadFromNib];
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
-(void)getOnlineDevice
{
    NSString * GdeviceStr = [USER_DEFAULT objectForKey:@"G_deviceStr"];   //获取本地化的GDevice
    
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",G_device];
//    NSString *url = [NSString stringWithFormat:@"%@",G_device];
    
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
    
    [request startSynchronous ];
    
    NSError *error = [request error ];
    assert (!error);
    // 如果请求成功，返回 Response
    NSLog ( @"request:%@" ,request);
    NSArray *onlineDeviceArr = [request responseData].JSONValue;
    deviceArr = onlineDeviceArr;
    NSLog ( @"onlineDeviceArr:%@" ,onlineDeviceArr);
    NSLog ( @"deviceArr:%@" ,deviceArr);
    
    
    
    
}

-(void)getWifi
{
    
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",G_devicepwd];
    
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
    
    [request startSynchronous ];
    
    NSError *error = [request error ];
    assert (!error);
    // 如果请求成功，返回 Response
    NSLog ( @"request:%@" ,request);
    NSDictionary *onlineWifi = [request responseData].JSONValue;
    NSLog ( @"onlineDeviceArr:%@" ,onlineWifi);
    wifiDic = [[NSDictionary alloc]init];
    wifiDic = onlineWifi;
    
    
    routeNameLab.text = [wifiDic objectForKey:@"name"];
    
    routeIPLab.text =  @"IP:192.168.1.1" ;//[wifiDic objectForKey:@"ip"];
    
    
}
-(void)eidtBtnClick
{
    [self.navigationController pushViewController:self.routeSetting animated:YES];
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
    //    self.routeSetting.nameText = [[UITextField alloc]init];
    //    self.routeSetting.nameText.text =routeNameLab.text;
    
    self.routeSetting.nameString = routeNameLab.text;
    self.routeSetting.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
    self.routeSetting.navigationItem.leftBarButtonItem = myButton;
}
-(void)clickEvent
{
    
    [self.navigationController popViewControllerAnimated:YES];
    //    self.tabBarController.tabBar.hidden = NO;
    
    routeName_seted = [USER_DEFAULT objectForKey:@"routeNameUSER"];
    
    
    routeNameLab.text = routeName_seted;
    
    
}
@end
