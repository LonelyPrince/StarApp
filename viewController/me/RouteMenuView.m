//
//  RouteMenuView.m
//  StarAPP
//
//  Created by xyz on 2017/10/17.
//

#import "RouteMenuView.h"

#define EDITWIDTH  17
#define ROUTENAME_Y  66
#define reStartTip  @"The router is restarting , the current network will be disconnected,please reconnect StarTimes ONE after restart"

@interface RouteMenuView ()
{

    NSString * deviceString;     //用于判断手机型号
    NSString * DMSIP;
    UIAlertView * rebootAlert;
    NSDictionary * deviceDic;
    MBProgressHUD * HUD;
    UIAlertView *restartingAlert;
}
@end

@implementation RouteMenuView
@synthesize scrollView;
@synthesize routeNameLab;
@synthesize secrityTypeLab;
@synthesize PINProtectionLab;
@synthesize routeImage;
@synthesize colorView;

@synthesize btn1;
@synthesize btn2;
@synthesize btn3;
@synthesize btn4;
@synthesize btn5;
@synthesize btn6;

@synthesize btnImageView1;
@synthesize btnImageView2;
@synthesize btnImageView3;
@synthesize btnImageView4;
@synthesize btnImageView5;
@synthesize btnImageView6;

@synthesize btnLab1;
@synthesize btnLab2;
@synthesize btnLab3;
@synthesize btnLab4;
@synthesize btnLab5;
@synthesize btnLab6;
@synthesize generalSettingLab;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    deviceString = [GGUtil deviceVersion];
    [self loadNav];
    [self initData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"routeNetWorkError" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetWorkErrorView) name:@"routeNetWorkError" object:nil];
}

-(void)loadNav
{
//    self.view.backgroundColor = [UIColor redColor];
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"Router Setting";
}
-(void)viewWillAppear:(BOOL)animated
{
    [self loadScroll];
    [self loadUI];
   
    NSDictionary * tempDic =  [USER_DEFAULT objectForKey:@"WiFiInfo"];
    routeNameLab.text = [tempDic objectForKey:@"name"];
    NSString * pswStr = [tempDic objectForKey:@"password"];
    if (![pswStr isEqualToString:@"none"]) {
        secrityTypeLab.text =[NSString stringWithFormat:@"Security Type: WPA2-PSK"] ;
        PINProtectionLab.text = @"PIN Protection: ON";
    }else
    {
        secrityTypeLab.text = @"Security Type: Open";
        PINProtectionLab.text = @"PIN Protection: OFF";
    }
//    [self getWifi];
    
}
-(void)initData
{
    
    //  [self loadNav];
    self.wLANSettingView = [[WLANSettingView alloc]init];
    self.securityCenterView = [[SecurityCenterView alloc]init];
    self.deviceListView = [[DeviceListView alloc]init];
    self.routerStatusView = [[RouterStatusView alloc]init];
    self.backupRestoreView = [[BackupRestoreView alloc]init];
    
    scrollView = [[UIScrollView alloc]init];
    colorView = [[UIImageView alloc]init];
    routeImage = [[UIImageView alloc]init];
//    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    routeNameLab = [[UILabel alloc]init];
    secrityTypeLab = [[UILabel alloc]init];
    PINProtectionLab = [[UILabel alloc]init];
    
    btn1 = [[UIButton alloc]init];
    btn2 = [[UIButton alloc]init];
    btn3 = [[UIButton alloc]init];
    btn4 = [[UIButton alloc]init];
    btn5 = [[UIButton alloc]init];
    btn6 = [[UIButton alloc]init];
    
    btnImageView1 = [[UIImageView alloc]init];
    btnImageView2 = [[UIImageView alloc]init];
    btnImageView3 = [[UIImageView alloc]init];
    btnImageView4 = [[UIImageView alloc]init];
    btnImageView5 = [[UIImageView alloc]init];
    btnImageView6 = [[UIImageView alloc]init];
    
    btnLab1 = [[UILabel alloc]init];
    btnLab2 = [[UILabel alloc]init];
    btnLab3 = [[UILabel alloc]init];
    btnLab4 = [[UILabel alloc]init];
    btnLab5 = [[UILabel alloc]init];
    btnLab6 = [[UILabel alloc]init];
    
    generalSettingLab = [[UILabel alloc]init];

    rebootAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Do you want to reboot?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
}
-(void)loadScroll
{
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是4s的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+20 );
        
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-60 );
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-100 );
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
       scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-128 );
    }
    
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
    [self.view addSubview:scrollView];
    
    
    scrollView.showsVerticalScrollIndicator=YES;
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.delegate=self;
    scrollView.bounces = NO;
    //    scrollView.backgroundColor = [UIColor redColor];
    NSLog(@"scroll x:%f",scrollView.bounds.origin.x);
    NSLog(@"scroll y:%f",scrollView.bounds.origin.y);
    NSLog(@"scroll w:%f",scrollView.bounds.size.width);
    NSLog(@"scroll h:%f",scrollView.bounds.size.height);
    scrollView.backgroundColor = [UIColor colorWithRed:0xf4/255.0 green:0xf5/255.0 blue:0xf9/255.0 alpha:1];
}
-(void)loadUI
{
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是4s 的大小");
        
        colorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        colorView.image = [UIImage imageNamed:@"背景"];
        [scrollView addSubview:colorView];
        
        routeImage.frame = CGRectMake(30, 60, 90, 90);
        routeImage.image = [UIImage imageNamed:@"顶部"];
        [scrollView addSubview:routeImage];
        [colorView bringSubviewToFront:routeImage];
        
        routeNameLab.frame = CGRectMake(135, 65, 200, 20);
        routeNameLab.font = FONT(18);
        routeNameLab.textColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:1];
//        routeNameLab.text = @"ajsdbajbdbasdbasbsss";
        [scrollView addSubview:routeNameLab];
        [colorView bringSubviewToFront:routeNameLab];
        
        secrityTypeLab.frame = CGRectMake(135, 100, 200, 17);
        secrityTypeLab.font = FONT(14);
        secrityTypeLab.textColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:0.7];
//        secrityTypeLab.text = @"ajsdbajbdbasdbasbsss";
        [scrollView addSubview:secrityTypeLab];
        [colorView bringSubviewToFront:secrityTypeLab];
        
        PINProtectionLab.frame = CGRectMake(135, 130, 200, 17);
        PINProtectionLab.font = FONT(14);
        PINProtectionLab.textColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:0.7];
//        PINProtectionLab.text = @"ajsdbajbdbasdbasbsss";
        [scrollView addSubview:PINProtectionLab];
        [colorView bringSubviewToFront:PINProtectionLab];
        
        
        generalSettingLab.frame = CGRectMake(20, 490 - 64, 200, 20);
        generalSettingLab.font = FONT(18);
        generalSettingLab.textColor = [UIColor colorWithRed:0x94/255.0 green:0x94/255.0 blue:0x94/255.0 alpha:1];
        generalSettingLab.text = @"General Settings";
        //        [scrollView addSubview:generalSettingLab];
        [scrollView addSubview:generalSettingLab];
        [scrollView bringSubviewToFront:generalSettingLab];
        
        [self addFirstBtn];
        [self addSecondBtn];
        [self addThirdBtn];
        [self addFourBtn];
        [self addFiveBtn];
        [self addSixBtn];
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
        
        
        
        
        
        
        //
        //
        //        routeIPLab.font = FONT(13);
        //        routeIPLab.textColor = RGBA(193, 193, 193, 1);
        //
        //        routeIPLab.frame = CGRectMake(40+ROUTEWIDTH, ROUTENAME_Y+10+15, 200, 13);
        //        [scrollView addSubview:routeNameLab];
        //        [scrollView addSubview:routeIPLab];
        
        
        //        centerGrayView.frame = CGRectMake(0, 298/2, SCREEN_WIDTH, 6);
        //        centerGrayView.backgroundColor  = RGBA(239, 239, 239, 1);
        //        [scrollView addSubview:centerGrayView];
        //
        //
        //
        //        connectDevice.frame = CGRectMake(20, 298/2+6+15, 200, 15);
        //        connectDevice.text = @"Connected devices";
        //        connectDevice.font = FONT(15);
        //        connectDevice.textColor = RGBA(148, 148, 148, 1);
        //        [scrollView addSubview:connectDevice];
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5 的大小");
        
        colorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        colorView.image = [UIImage imageNamed:@"背景"];
        [scrollView addSubview:colorView];
        
        routeImage.frame = CGRectMake(30, 60, 90, 90);
        routeImage.image = [UIImage imageNamed:@"顶部"];
        [scrollView addSubview:routeImage];
        [colorView bringSubviewToFront:routeImage];
        
        routeNameLab.frame = CGRectMake(145, 70, 200, 20);
        routeNameLab.font = FONT(18);
        routeNameLab.textColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:1];
//        routeNameLab.text = @"ajsdbajbdbasdbasbsss";
        [scrollView addSubview:routeNameLab];
        [colorView bringSubviewToFront:routeNameLab];
        
        secrityTypeLab.frame = CGRectMake(145, 100, 200, 17);
        secrityTypeLab.font = FONT(14);
        secrityTypeLab.textColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:0.7];
//        secrityTypeLab.text = @"ajsdbajbdbasdbasbsss";
        [scrollView addSubview:secrityTypeLab];
        [colorView bringSubviewToFront:secrityTypeLab];
        
        PINProtectionLab.frame = CGRectMake(145, 125, 200, 17);
        PINProtectionLab.font = FONT(14);
        PINProtectionLab.textColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:0.7];
//        PINProtectionLab.text = @"ajsdbajbdbasdbasbsss";
        [scrollView addSubview:PINProtectionLab];
        [colorView bringSubviewToFront:PINProtectionLab];
        
        
        generalSettingLab.frame = CGRectMake(20, 490 - 64, 200, 20);
        generalSettingLab.font = FONT(18);
        generalSettingLab.textColor = [UIColor colorWithRed:0x94/255.0 green:0x94/255.0 blue:0x94/255.0 alpha:1];
        generalSettingLab.text = @"General Settings";
        //        [scrollView addSubview:generalSettingLab];
        [scrollView addSubview:generalSettingLab];
        [scrollView bringSubviewToFront:generalSettingLab];
        
        [self addFirstBtn];
        [self addSecondBtn];
        [self addThirdBtn];
        [self addFourBtn];
        [self addFiveBtn];
        [self addSixBtn];
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
        
        
        
        
        
        
        //
        //
        //        routeIPLab.font = FONT(13);
        //        routeIPLab.textColor = RGBA(193, 193, 193, 1);
        //
        //        routeIPLab.frame = CGRectMake(40+ROUTEWIDTH, ROUTENAME_Y+10+15, 200, 13);
        //        [scrollView addSubview:routeNameLab];
        //        [scrollView addSubview:routeIPLab];
        
        
        //        centerGrayView.frame = CGRectMake(0, 298/2, SCREEN_WIDTH, 6);
        //        centerGrayView.backgroundColor  = RGBA(239, 239, 239, 1);
        //        [scrollView addSubview:centerGrayView];
        //
        //
        //
        //        connectDevice.frame = CGRectMake(20, 298/2+6+15, 200, 15);
        //        connectDevice.text = @"Connected devices";
        //        connectDevice.font = FONT(15);
        //        connectDevice.textColor = RGBA(148, 148, 148, 1);
        //        [scrollView addSubview:connectDevice];
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6 的大小");
        
        colorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
        colorView.image = [UIImage imageNamed:@"背景"];
        [scrollView addSubview:colorView];
        
        routeImage.frame = CGRectMake(55, 74, 180/2, 180/2);
        routeImage.image = [UIImage imageNamed:@"顶部"];
        [scrollView addSubview:routeImage];
        [colorView bringSubviewToFront:routeImage];
        
        routeNameLab.frame = CGRectMake(176, 82, 200, 20);
        routeNameLab.font = FONT(18);
        routeNameLab.textColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:1];
//        routeNameLab.text = @"ajsdbajbdbasdbasbsss";
        [scrollView addSubview:routeNameLab];
        [colorView bringSubviewToFront:routeNameLab];
        
        secrityTypeLab.frame = CGRectMake(176, 115, 200, 17);
        secrityTypeLab.font = FONT(14);
        secrityTypeLab.textColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:0.7];
//        secrityTypeLab.text = @"ajsdbajbdbasdbasbsss";
        [scrollView addSubview:secrityTypeLab];
        [colorView bringSubviewToFront:secrityTypeLab];
        
        PINProtectionLab.frame = CGRectMake(176, 140, 200, 17);
        PINProtectionLab.font = FONT(14);
        PINProtectionLab.textColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:0.7];
//        PINProtectionLab.text = @"ajsdbajbdbasdbasbsss";
        [scrollView addSubview:PINProtectionLab];
        [colorView bringSubviewToFront:PINProtectionLab];
        
        
        generalSettingLab.frame = CGRectMake(20, 530 - 64, 200, 20);
        generalSettingLab.font = FONT(18);
        generalSettingLab.textColor = [UIColor colorWithRed:0x94/255.0 green:0x94/255.0 blue:0x94/255.0 alpha:1];
        generalSettingLab.text = @"General Settings";
        //        [scrollView addSubview:generalSettingLab];
        [scrollView addSubview:generalSettingLab];
        [scrollView bringSubviewToFront:generalSettingLab];
        
        [self addFirstBtn];
        [self addSecondBtn];
        [self addThirdBtn];
        [self addFourBtn];
        [self addFiveBtn];
        [self addSixBtn];
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
        
        
        
        
        
        
        //
        //
        //        routeIPLab.font = FONT(13);
        //        routeIPLab.textColor = RGBA(193, 193, 193, 1);
        //
        //        routeIPLab.frame = CGRectMake(40+ROUTEWIDTH, ROUTENAME_Y+10+15, 200, 13);
        //        [scrollView addSubview:routeNameLab];
        //        [scrollView addSubview:routeIPLab];
        
        
        //        centerGrayView.frame = CGRectMake(0, 298/2, SCREEN_WIDTH, 6);
        //        centerGrayView.backgroundColor  = RGBA(239, 239, 239, 1);
        //        [scrollView addSubview:centerGrayView];
        //
        //
        //
        //        connectDevice.frame = CGRectMake(20, 298/2+6+15, 200, 15);
        //        connectDevice.text = @"Connected devices";
        //        connectDevice.font = FONT(15);
        //        connectDevice.textColor = RGBA(148, 148, 148, 1);
        //        [scrollView addSubview:connectDevice];
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        colorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 240);
        colorView.image = [UIImage imageNamed:@"背景"];
        [scrollView addSubview:colorView];
        
        routeImage.frame = CGRectMake(55, 74, 100, 100);
        routeImage.image = [UIImage imageNamed:@"顶部"];
        [scrollView addSubview:routeImage];
        [colorView bringSubviewToFront:routeImage];
        
        routeNameLab.frame = CGRectMake(192, 85, 205, 20);
        routeNameLab.font = FONT(18);
        routeNameLab.textColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:1];
//        routeNameLab.text = @"ajsdbajbdbasdbasbsss";
        [scrollView addSubview:routeNameLab];
        [colorView bringSubviewToFront:routeNameLab];
        
        secrityTypeLab.frame = CGRectMake(192, 117, 200, 17);
        secrityTypeLab.font = FONT(14);
        secrityTypeLab.textColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:0.7];
//        secrityTypeLab.text = @"ajsdbajbdbasdbasbsss";
        [scrollView addSubview:secrityTypeLab];
        [colorView bringSubviewToFront:secrityTypeLab];
        
        PINProtectionLab.frame = CGRectMake(192, 143, 200, 17);
        PINProtectionLab.font = FONT(14);
        PINProtectionLab.textColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:0.7];
//        PINProtectionLab.text = @"ajsdbajbdbasdbasbsss";
        [scrollView addSubview:PINProtectionLab];
        [colorView bringSubviewToFront:PINProtectionLab];
        
        
        generalSettingLab.frame = CGRectMake(20, 570 - 64, 200, 20);
        generalSettingLab.font = FONT(18);
        generalSettingLab.textColor = [UIColor colorWithRed:0x94/255.0 green:0x94/255.0 blue:0x94/255.0 alpha:1];
        generalSettingLab.text = @"General Settings";
//        [scrollView addSubview:generalSettingLab];
        [scrollView addSubview:generalSettingLab];
        [scrollView bringSubviewToFront:generalSettingLab];
        
        [self addFirstBtn];
        [self addSecondBtn];
        [self addThirdBtn];
        [self addFourBtn];
        [self addFiveBtn];
        [self addSixBtn];
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
        
        
        
        
        

//
//
//        routeIPLab.font = FONT(13);
//        routeIPLab.textColor = RGBA(193, 193, 193, 1);
//
//        routeIPLab.frame = CGRectMake(40+ROUTEWIDTH, ROUTENAME_Y+10+15, 200, 13);
//        [scrollView addSubview:routeNameLab];
//        [scrollView addSubview:routeIPLab];
        
        
//        centerGrayView.frame = CGRectMake(0, 298/2, SCREEN_WIDTH, 6);
//        centerGrayView.backgroundColor  = RGBA(239, 239, 239, 1);
//        [scrollView addSubview:centerGrayView];
//        
//        
//        
//        connectDevice.frame = CGRectMake(20, 298/2+6+15, 200, 15);
//        connectDevice.text = @"Connected devices";
//        connectDevice.font = FONT(15);
//        connectDevice.textColor = RGBA(148, 148, 148, 1);
//        [scrollView addSubview:connectDevice];
    }
    
  
    
    
}
-(void)addFirstBtn
{
    
  
    
    
    deviceString = [GGUtil deviceVersion];
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是4s 的大小");
        
        btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setFrame:CGRectMake(0, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn1 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn1.tag = 1;
        [btn1 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn1];
        [scrollView bringSubviewToFront:btn1];
        
        btnImageView1.frame = CGRectMake((btn1.frame.size.width - 25)/2, btn1.frame.origin.y+24, 25, 25);
        btnImageView1.image = [UIImage imageNamed:@"WLAN-Settings"];
        [scrollView addSubview:btnImageView1];
        [btn1 bringSubviewToFront:btnImageView1];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"WLAN Settings" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView1.frame.size.width - size.width)/2);
        btnLab1.frame = CGRectMake((btn1.frame.size.width - size.width)/2, btnImageView1.frame.origin.y+btnImageView1.frame.size.height+ 10, 150, 20);
        btnLab1.text = @"WLAN Settings";
        btnLab1.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab1.font = FONT(15);
        [scrollView addSubview:btnLab1];
        [btn1 bringSubviewToFront:btnLab1];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5 的大小");
        
        btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setFrame:CGRectMake(0, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn1 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn1.tag = 1;
        [btn1 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn1];
        [scrollView bringSubviewToFront:btn1];
        
        btnImageView1.frame = CGRectMake((btn1.frame.size.width - 25)/2, btn1.frame.origin.y+24, 25, 25);
        btnImageView1.image = [UIImage imageNamed:@"WLAN-Settings"];
        [scrollView addSubview:btnImageView1];
        [btn1 bringSubviewToFront:btnImageView1];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"WLAN Settings" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView1.frame.size.width - size.width)/2);
        btnLab1.frame = CGRectMake((btn1.frame.size.width - size.width)/2, btnImageView1.frame.origin.y+btnImageView1.frame.size.height+ 10, 150, 20);
        btnLab1.text = @"WLAN Settings";
        btnLab1.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab1.font = FONT(15);
        [scrollView addSubview:btnLab1];
        [btn1 bringSubviewToFront:btnLab1];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6 的大小");
        
        btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setFrame:CGRectMake(0, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn1 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn1.tag = 1;
        [btn1 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn1];
        [scrollView bringSubviewToFront:btn1];
        
        
        btnImageView1.frame = CGRectMake((btn1.frame.size.width - 40)/2, btn1.frame.origin.y+24, 40, 40);
        btnImageView1.image = [UIImage imageNamed:@"WLAN-Settings"];
        [scrollView addSubview:btnImageView1];
        [btn1 bringSubviewToFront:btnImageView1];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"WLAN Settings" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView1.frame.size.width - size.width)/2);
        btnLab1.frame = CGRectMake((btn1.frame.size.width - size.width)/2, btnImageView1.frame.origin.y+btnImageView1.frame.size.height+ 10, 150, 20);
        btnLab1.text = @"WLAN Settings";
        btnLab1.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab1.font = FONT(15);
        [scrollView addSubview:btnLab1];
        [btn1 bringSubviewToFront:btnLab1];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setFrame:CGRectMake(0, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn1 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn1.tag = 1;
        [btn1 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn1];
        [scrollView bringSubviewToFront:btn1];
        
        btnImageView1.frame = CGRectMake((btn1.frame.size.width - 40)/2, btn1.frame.origin.y+24, 40, 40);
        btnImageView1.image = [UIImage imageNamed:@"WLAN-Settings"];
        [scrollView addSubview:btnImageView1];
        [btn1 bringSubviewToFront:btnImageView1];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"WLAN Settings" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView1.frame.size.width - size.width)/2);
        btnLab1.frame = CGRectMake((btn1.frame.size.width - size.width)/2, btnImageView1.frame.origin.y+btnImageView1.frame.size.height+ 10, 150, 20);
        btnLab1.text = @"WLAN Settings";
        btnLab1.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab1.font = FONT(15);
        [scrollView addSubview:btnLab1];
        [btn1 bringSubviewToFront:btnLab1];
        
//        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
//        hudLab.text = @"Network Error";
//
//        hudLab.textColor = [UIColor grayColor];
    }
    
    
    
    
    
}
-(void)addSecondBtn
{
    
   
    
    
    
    
    
    
    deviceString = [GGUtil deviceVersion];
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是4s 的大小");
        btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setFrame:CGRectMake((SCREEN_WIDTH - 3)/2+3, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn2 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn2.tag = 2;
        [btn2 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn2];
        [scrollView bringSubviewToFront:btn2];
        
        //        historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(19, 70, 100, 13)];
        //        //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        //        historyNameLab1.textColor = [UIColor whiteColor];
        //        historyNameLab1.font = FONT(12);
        //        historyNameLab1.textAlignment = NSTextAlignmentCenter;
        //        [historyBtnPiece1 addSubview:historyNameLab1];
        
        btnImageView2.frame = CGRectMake(btn1.frame.size.width+(btn2.frame.size.width - 25)/2, btn2.frame.origin.y+24, 25, 25);
        btnImageView2.image = [UIImage imageNamed:@"Security-Center"];
        [scrollView addSubview:btnImageView2];
        [btn2 bringSubviewToFront:btnImageView2];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Security Center" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView1.frame.size.width - size.width)/2);
        btnLab2.frame = CGRectMake(btn1.frame.size.width+(btn2.frame.size.width - size.width)/2, btnImageView2.frame.origin.y+btnImageView2.frame.size.height+ 10, 150, 20);
        btnLab2.text = @"Security Center";
        btnLab2.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab2.font = FONT(15);
        [scrollView addSubview:btnLab2];
        [btn2 bringSubviewToFront:btnLab2];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5 的大小");
        btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setFrame:CGRectMake((SCREEN_WIDTH - 3)/2+3, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn2 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn2.tag = 2;
        [btn2 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn2];
        [scrollView bringSubviewToFront:btn2];
        
        //        historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(19, 70, 100, 13)];
        //        //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        //        historyNameLab1.textColor = [UIColor whiteColor];
        //        historyNameLab1.font = FONT(12);
        //        historyNameLab1.textAlignment = NSTextAlignmentCenter;
        //        [historyBtnPiece1 addSubview:historyNameLab1];
        
        btnImageView2.frame = CGRectMake(btn1.frame.size.width+(btn2.frame.size.width - 25)/2, btn2.frame.origin.y+24, 25, 25);
        btnImageView2.image = [UIImage imageNamed:@"Security-Center"];
        [scrollView addSubview:btnImageView2];
        [btn2 bringSubviewToFront:btnImageView2];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Security Center" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView1.frame.size.width - size.width)/2);
        btnLab2.frame = CGRectMake(btn1.frame.size.width+(btn2.frame.size.width - size.width)/2, btnImageView2.frame.origin.y+btnImageView2.frame.size.height+ 10, 150, 20);
        btnLab2.text = @"Security Center";
        btnLab2.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab2.font = FONT(15);
        [scrollView addSubview:btnLab2];
        [btn2 bringSubviewToFront:btnLab2];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6 的大小");
        btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setFrame:CGRectMake((SCREEN_WIDTH - 3)/2+3, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn2 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn2.tag = 2;
        [btn2 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn2];
        [scrollView bringSubviewToFront:btn2];
        
        //        historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(19, 70, 100, 13)];
        //        //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        //        historyNameLab1.textColor = [UIColor whiteColor];
        //        historyNameLab1.font = FONT(12);
        //        historyNameLab1.textAlignment = NSTextAlignmentCenter;
        //        [historyBtnPiece1 addSubview:historyNameLab1];
        
        btnImageView2.frame = CGRectMake(btn1.frame.size.width+(btn2.frame.size.width - 40)/2, btn2.frame.origin.y+24, 40, 40);
        btnImageView2.image = [UIImage imageNamed:@"Security-Center"];
        [scrollView addSubview:btnImageView2];
        [btn2 bringSubviewToFront:btnImageView2];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Security Center" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView1.frame.size.width - size.width)/2);
        btnLab2.frame = CGRectMake(btn1.frame.size.width+(btn2.frame.size.width - size.width)/2, btnImageView2.frame.origin.y+btnImageView2.frame.size.height+ 10, 150, 20);
        btnLab2.text = @"Security Center";
        btnLab2.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab2.font = FONT(15);
        [scrollView addSubview:btnLab2];
        [btn2 bringSubviewToFront:btnLab2];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setFrame:CGRectMake((SCREEN_WIDTH - 3)/2+3, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn2 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn2.tag = 2;
        [btn2 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn2];
        [scrollView bringSubviewToFront:btn2];
        //        historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(19, 70, 100, 13)];
        //        //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        //        historyNameLab1.textColor = [UIColor whiteColor];
        //        historyNameLab1.font = FONT(12);
        //        historyNameLab1.textAlignment = NSTextAlignmentCenter;
        //        [historyBtnPiece1 addSubview:historyNameLab1];
        
        btnImageView2.frame = CGRectMake(btn1.frame.size.width+(btn2.frame.size.width - 40)/2, btn2.frame.origin.y+24, 40, 40);
        btnImageView2.image = [UIImage imageNamed:@"Security-Center"];
        [scrollView addSubview:btnImageView2];
        [btn2 bringSubviewToFront:btnImageView2];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Security Center" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView1.frame.size.width - size.width)/2);
        btnLab2.frame = CGRectMake(btn1.frame.size.width+(btn2.frame.size.width - size.width)/2, btnImageView2.frame.origin.y+btnImageView2.frame.size.height+ 10, 150, 20);
        btnLab2.text = @"Security Center";
        btnLab2.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab2.font = FONT(15);
        [scrollView addSubview:btnLab2];
        [btn2 bringSubviewToFront:btnLab2];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }
    
    
    
    
    
}
#pragma mark - 第三个btn
-(void)addThirdBtn
{
    
    
    
    deviceString = [GGUtil deviceVersion];
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是4s 的大小");
        
        btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn3 setFrame:CGRectMake(0, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 + btn1.frame.size.height+3 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn3 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn3.tag = 3;
        [btn3 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn3];
        [scrollView bringSubviewToFront:btn3];
        
        btnImageView3.frame = CGRectMake((btn3.frame.size.width - 25)/2, btn3.frame.origin.y+24, 25, 25);
        btnImageView3.image = [UIImage imageNamed:@"Devices-List"];
        [scrollView addSubview:btnImageView3];
        [btn3 bringSubviewToFront:btnImageView3];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Devices List" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView3.frame.size.width - size.width)/2);
        btnLab3.frame = CGRectMake((btn3.frame.size.width - size.width)/2, btnImageView3.frame.origin.y+btnImageView3.frame.size.height+ 10, 150, 20);
        btnLab3.text = @"Devices List";
        btnLab3.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab3.font = FONT(15);
        [scrollView addSubview:btnLab3];
        [btn3 bringSubviewToFront:btnLab3];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5 的大小");
        
        btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn3 setFrame:CGRectMake(0, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 + btn1.frame.size.height+3 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn3 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn3.tag = 3;
        [btn3 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn3];
        [scrollView bringSubviewToFront:btn3];
        
        btnImageView3.frame = CGRectMake((btn3.frame.size.width - 25)/2, btn3.frame.origin.y+24, 25, 25);
        btnImageView3.image = [UIImage imageNamed:@"Devices-List"];
        [scrollView addSubview:btnImageView3];
        [btn3 bringSubviewToFront:btnImageView3];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Devices List" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView3.frame.size.width - size.width)/2);
        btnLab3.frame = CGRectMake((btn3.frame.size.width - size.width)/2, btnImageView3.frame.origin.y+btnImageView3.frame.size.height+ 10, 150, 20);
        btnLab3.text = @"Devices List";
        btnLab3.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab3.font = FONT(15);
        [scrollView addSubview:btnLab3];
        [btn3 bringSubviewToFront:btnLab3];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6 的大小");
        
        btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn3 setFrame:CGRectMake(0, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 + btn1.frame.size.height+3 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn3 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn3.tag = 3;
        [btn3 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn3];
        [scrollView bringSubviewToFront:btn3];
        
        
        btnImageView3.frame = CGRectMake((btn3.frame.size.width - 40)/2, btn3.frame.origin.y+24, 40, 40);
        btnImageView3.image = [UIImage imageNamed:@"Devices-List"];
        [scrollView addSubview:btnImageView3];
        [btn3 bringSubviewToFront:btnImageView3];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Devices List" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView3.frame.size.width - size.width)/2);
        btnLab3.frame = CGRectMake((btn3.frame.size.width - size.width)/2, btnImageView3.frame.origin.y+btnImageView3.frame.size.height+ 10, 150, 20);
        btnLab3.text = @"Devices List";
        btnLab3.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab3.font = FONT(15);
        [scrollView addSubview:btnLab3];
        [btn3 bringSubviewToFront:btnLab3];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn3 setFrame:CGRectMake(0, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 + btn1.frame.size.height+3 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn3 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn3.tag = 3;
        [btn3 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn3];
        [scrollView bringSubviewToFront:btn3];
        
        
        btnImageView3.frame = CGRectMake((btn3.frame.size.width - 40)/2, btn3.frame.origin.y+24, 40, 40);
        btnImageView3.image = [UIImage imageNamed:@"Devices-List"];
        [scrollView addSubview:btnImageView3];
        [btn3 bringSubviewToFront:btnImageView3];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Devices List" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView3.frame.size.width - size.width)/2);
        btnLab3.frame = CGRectMake((btn3.frame.size.width - size.width)/2, btnImageView3.frame.origin.y+btnImageView3.frame.size.height+ 10, 150, 20);
        btnLab3.text = @"Devices List";
        btnLab3.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab3.font = FONT(15);
        [scrollView addSubview:btnLab3];
        [btn3 bringSubviewToFront:btnLab3];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }
    
}
#pragma mark - 第四个
-(void)addFourBtn
{
    
  
    deviceString = [GGUtil deviceVersion];
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是4s 的大小");
        
        btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn4 setFrame:CGRectMake((SCREEN_WIDTH - 3)/2+3, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 + btn2.frame.size.height + 3 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn4 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn4.tag = 4;
        [btn4 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn4];
        [scrollView bringSubviewToFront:btn4];
        
        //        historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(19, 70, 100, 13)];
        //        //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        //        historyNameLab1.textColor = [UIColor whiteColor];
        //        historyNameLab1.font = FONT(12);
        //        historyNameLab1.textAlignment = NSTextAlignmentCenter;
        //        [historyBtnPiece1 addSubview:historyNameLab1];
        
        btnImageView4.frame = CGRectMake(btn3.frame.size.width+(btn4.frame.size.width - 25)/2, btn4.frame.origin.y+24, 25, 25);
        btnImageView4.image = [UIImage imageNamed:@"Router-Status"];
        [scrollView addSubview:btnImageView4];
        [btn4 bringSubviewToFront:btnImageView4];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Router Status" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView1.frame.size.width - size.width)/2);
        btnLab4.frame = CGRectMake(btn3.frame.size.width+(btn4.frame.size.width - size.width)/2, btnImageView4.frame.origin.y+btnImageView4.frame.size.height+ 10, 150, 20);
        btnLab4.text = @"Router Status";
        btnLab4.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab4.font = FONT(15);
        [scrollView addSubview:btnLab4];
        [btn4 bringSubviewToFront:btnLab4];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5 的大小");
        
        btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn4 setFrame:CGRectMake((SCREEN_WIDTH - 3)/2+3, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 + btn2.frame.size.height + 3 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn4 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn4.tag = 4;
        [btn4 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn4];
        [scrollView bringSubviewToFront:btn4];
        
        //        historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(19, 70, 100, 13)];
        //        //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        //        historyNameLab1.textColor = [UIColor whiteColor];
        //        historyNameLab1.font = FONT(12);
        //        historyNameLab1.textAlignment = NSTextAlignmentCenter;
        //        [historyBtnPiece1 addSubview:historyNameLab1];
        
        btnImageView4.frame = CGRectMake(btn3.frame.size.width+(btn4.frame.size.width - 25)/2, btn4.frame.origin.y+24, 25, 25);
        btnImageView4.image = [UIImage imageNamed:@"Router-Status"];
        [scrollView addSubview:btnImageView4];
        [btn4 bringSubviewToFront:btnImageView4];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Router Status" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView1.frame.size.width - size.width)/2);
        btnLab4.frame = CGRectMake(btn3.frame.size.width+(btn4.frame.size.width - size.width)/2, btnImageView4.frame.origin.y+btnImageView4.frame.size.height+ 10, 150, 20);
        btnLab4.text = @"Router Status";
        btnLab4.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab4.font = FONT(15);
        [scrollView addSubview:btnLab4];
        [btn4 bringSubviewToFront:btnLab4];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6 的大小");
        
        btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn4 setFrame:CGRectMake((SCREEN_WIDTH - 3)/2+3, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 + btn2.frame.size.height + 3 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn4 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn4.tag = 4;
        [btn4 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn4];
        [scrollView bringSubviewToFront:btn4];
        
        //        historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(19, 70, 100, 13)];
        //        //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        //        historyNameLab1.textColor = [UIColor whiteColor];
        //        historyNameLab1.font = FONT(12);
        //        historyNameLab1.textAlignment = NSTextAlignmentCenter;
        //        [historyBtnPiece1 addSubview:historyNameLab1];
        
        btnImageView4.frame = CGRectMake(btn3.frame.size.width+(btn4.frame.size.width - 40)/2, btn4.frame.origin.y+24, 40, 40);
        btnImageView4.image = [UIImage imageNamed:@"Router-Status"];
        [scrollView addSubview:btnImageView4];
        [btn4 bringSubviewToFront:btnImageView4];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Router Status" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView1.frame.size.width - size.width)/2);
        btnLab4.frame = CGRectMake(btn3.frame.size.width+(btn4.frame.size.width - size.width)/2, btnImageView4.frame.origin.y+btnImageView4.frame.size.height+ 10, 150, 20);
        btnLab4.text = @"Router Status";
        btnLab4.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab4.font = FONT(15);
        [scrollView addSubview:btnLab4];
        [btn4 bringSubviewToFront:btnLab4];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn4 setFrame:CGRectMake((SCREEN_WIDTH - 3)/2+3, colorView.frame.origin.y+colorView.frame.size.height+30 + 44 + btn2.frame.size.height + 3 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn4 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn4.tag = 4;
        [btn4 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn4];
        [scrollView bringSubviewToFront:btn4];
        
        
        btnImageView4.frame = CGRectMake(btn3.frame.size.width+(btn4.frame.size.width - 40)/2, btn4.frame.origin.y+24, 40, 40);
        btnImageView4.image = [UIImage imageNamed:@"Router-Status"];
        [scrollView addSubview:btnImageView4];
        [btn4 bringSubviewToFront:btnImageView4];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Router Status" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView1.frame.size.width - size.width)/2);
        btnLab4.frame = CGRectMake(btn3.frame.size.width+(btn4.frame.size.width - size.width)/2, btnImageView4.frame.origin.y+btnImageView4.frame.size.height+ 10, 150, 20);
        btnLab4.text = @"Router Status";
        btnLab4.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab4.font = FONT(15);
        [scrollView addSubview:btnLab4];
        [btn4 bringSubviewToFront:btnLab4];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }
    
 
}
#pragma mark - 第五个btn
-(void)addFiveBtn
{
    
    
    deviceString = [GGUtil deviceVersion];
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是4s 的大小");
        
        btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn5 setFrame:CGRectMake(0, 480+40 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn5 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn5.tag = 5;
        [btn5 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn5];
        [scrollView bringSubviewToFront:btn5];
        
        //        historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(19, 70, 100, 13)];
        //        //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        //        historyNameLab1.textColor = [UIColor whiteColor];
        //        historyNameLab1.font = FONT(12);
        //        historyNameLab1.textAlignment = NSTextAlignmentCenter;
        //        [historyBtnPiece1 addSubview:historyNameLab1];
        
        btnImageView5.frame = CGRectMake((btn5.frame.size.width - 25)/2, btn5.frame.origin.y+24, 25, 25);
        btnImageView5.image = [UIImage imageNamed:@"Backup-&-Restore@2x"];
        [scrollView addSubview:btnImageView5];
        [btn5 bringSubviewToFront:btnImageView5];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Backup & Restore" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView5.frame.size.width - size.width)/2);
        btnLab5.frame = CGRectMake((btn5.frame.size.width - size.width)/2, btnImageView5.frame.origin.y+btnImageView5.frame.size.height+ 10, 150, 20);
        btnLab5.text = @"Backup & Restore";
        btnLab5.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab5.font = FONT(15);
        [scrollView addSubview:btnLab5];
        [btn5 bringSubviewToFront:btnLab5];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5 的大小");
        
        btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn5 setFrame:CGRectMake(0, 480+40 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn5 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn5.tag = 5;
        [btn5 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn5];
        [scrollView bringSubviewToFront:btn5];
        
        //        historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(19, 70, 100, 13)];
        //        //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        //        historyNameLab1.textColor = [UIColor whiteColor];
        //        historyNameLab1.font = FONT(12);
        //        historyNameLab1.textAlignment = NSTextAlignmentCenter;
        //        [historyBtnPiece1 addSubview:historyNameLab1];
        
        btnImageView5.frame = CGRectMake((btn5.frame.size.width - 25)/2, btn5.frame.origin.y+24, 25, 25);
        btnImageView5.image = [UIImage imageNamed:@"Backup-&-Restore@2x"];
        [scrollView addSubview:btnImageView5];
        [btn5 bringSubviewToFront:btnImageView5];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Backup & Restore" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView5.frame.size.width - size.width)/2);
        btnLab5.frame = CGRectMake((btn5.frame.size.width - size.width)/2, btnImageView5.frame.origin.y+btnImageView5.frame.size.height+ 10, 150, 20);
        btnLab5.text = @"Backup & Restore";
        btnLab5.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab5.font = FONT(15);
        [scrollView addSubview:btnLab5];
        [btn5 bringSubviewToFront:btnLab5];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6 的大小");
        
        btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn5 setFrame:CGRectMake(0, 520+40 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn5 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn5.tag = 5;
        [btn5 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn5];
        [scrollView bringSubviewToFront:btn5];
        
        //        historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(19, 70, 100, 13)];
        //        //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        //        historyNameLab1.textColor = [UIColor whiteColor];
        //        historyNameLab1.font = FONT(12);
        //        historyNameLab1.textAlignment = NSTextAlignmentCenter;
        //        [historyBtnPiece1 addSubview:historyNameLab1];
        
        btnImageView5.frame = CGRectMake((btn5.frame.size.width - 40)/2, btn5.frame.origin.y+24, 40, 40);
        btnImageView5.image = [UIImage imageNamed:@"Backup-&-Restore@2x"];
        [scrollView addSubview:btnImageView5];
        [btn5 bringSubviewToFront:btnImageView5];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Backup & Restore" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView5.frame.size.width - size.width)/2);
        btnLab5.frame = CGRectMake((btn5.frame.size.width - size.width)/2, btnImageView5.frame.origin.y+btnImageView5.frame.size.height+ 10, 150, 20);
        btnLab5.text = @"Backup & Restore";
        btnLab5.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab5.font = FONT(15);
        [scrollView addSubview:btnLab5];
        [btn5 bringSubviewToFront:btnLab5];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn5 setFrame:CGRectMake(0, 570+40 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn5 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn5.tag = 5;
        [btn5 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn5];
        [scrollView bringSubviewToFront:btn5];
        
        
        btnImageView5.frame = CGRectMake((btn5.frame.size.width - 40)/2, btn5.frame.origin.y+24, 40, 40);
        btnImageView5.image = [UIImage imageNamed:@"Backup-&-Restore@2x"];
        [scrollView addSubview:btnImageView5];
        [btn5 bringSubviewToFront:btnImageView5];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Backup & Restore" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView5.frame.size.width - size.width)/2);
        btnLab5.frame = CGRectMake((btn5.frame.size.width - size.width)/2, btnImageView5.frame.origin.y+btnImageView5.frame.size.height+ 10, 150, 20);
        btnLab5.text = @"Backup & Restore";
        btnLab5.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab5.font = FONT(15);
        [scrollView addSubview:btnLab5];
        [btn5 bringSubviewToFront:btnLab5];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }
    
}
#pragma mark - 第六个btn
-(void)addSixBtn
{
    
    
    
    deviceString = [GGUtil deviceVersion];
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是4s 的大小");
        
        btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn6 setFrame:CGRectMake(btn5.frame.size.width+3, 480+40 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn6 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn6.tag = 6;
        [btn6 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn6];
        [scrollView bringSubviewToFront:btn6];
        
        //        historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(19, 70, 100, 13)];
        //        //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        //        historyNameLab1.textColor = [UIColor whiteColor];
        //        historyNameLab1.font = FONT(12);
        //        historyNameLab1.textAlignment = NSTextAlignmentCenter;
        //        [historyBtnPiece1 addSubview:historyNameLab1];
        
        btnImageView6.frame = CGRectMake((btn6.frame.size.width - 25)/2 + btn5.frame.size.width+3, btn6.frame.origin.y+24, 25, 25);
        btnImageView6.image = [UIImage imageNamed:@"Reboot-Device"];
        [scrollView addSubview:btnImageView6];
        [btn6 bringSubviewToFront:btnImageView6];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Reboot" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView6.frame.size.width - size.width)/2);
        btnLab6.frame = CGRectMake((btn6.frame.size.width - size.width)/2+ btn5.frame.size.width+3, btnImageView6.frame.origin.y+btnImageView6.frame.size.height+ 10, 150, 20);
        btnLab6.text = @"Reboot";
        btnLab6.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab6.font = FONT(15);
        [scrollView addSubview:btnLab6];
        [btn6 bringSubviewToFront:btnLab6];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5 的大小");
        
        btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn6 setFrame:CGRectMake(btn5.frame.size.width+3, 480+40 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn6 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn6.tag = 6;
        [btn6 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn6];
        [scrollView bringSubviewToFront:btn6];
        
        //        historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(19, 70, 100, 13)];
        //        //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        //        historyNameLab1.textColor = [UIColor whiteColor];
        //        historyNameLab1.font = FONT(12);
        //        historyNameLab1.textAlignment = NSTextAlignmentCenter;
        //        [historyBtnPiece1 addSubview:historyNameLab1];
        
        btnImageView6.frame = CGRectMake((btn6.frame.size.width - 25)/2 + btn5.frame.size.width+3, btn6.frame.origin.y+24, 25, 25);
        btnImageView6.image = [UIImage imageNamed:@"Reboot-Device"];
        [scrollView addSubview:btnImageView6];
        [btn6 bringSubviewToFront:btnImageView6];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Reboot" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView6.frame.size.width - size.width)/2);
        btnLab6.frame = CGRectMake((btn6.frame.size.width - size.width)/2+ btn5.frame.size.width+3, btnImageView6.frame.origin.y+btnImageView6.frame.size.height+ 10, 150, 20);
        btnLab6.text = @"Reboot";
        btnLab6.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab6.font = FONT(15);
        [scrollView addSubview:btnLab6];
        [btn6 bringSubviewToFront:btnLab6];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6 的大小");
        
        btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn6 setFrame:CGRectMake(btn5.frame.size.width+3, 520+40 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn6 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn6.tag = 6;
        [btn6 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn6];
        [scrollView bringSubviewToFront:btn6];
        
        //        historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(19, 70, 100, 13)];
        //        //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        //        historyNameLab1.textColor = [UIColor whiteColor];
        //        historyNameLab1.font = FONT(12);
        //        historyNameLab1.textAlignment = NSTextAlignmentCenter;
        //        [historyBtnPiece1 addSubview:historyNameLab1];
        
        btnImageView6.frame = CGRectMake((btn6.frame.size.width - 40)/2 + btn5.frame.size.width+3, btn6.frame.origin.y+24, 40, 40);
        btnImageView6.image = [UIImage imageNamed:@"Reboot-Device"];
        [scrollView addSubview:btnImageView6];
        [btn6 bringSubviewToFront:btnImageView6];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Reboot" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView6.frame.size.width - size.width)/2);
        btnLab6.frame = CGRectMake((btn6.frame.size.width - size.width)/2+ btn5.frame.size.width+3, btnImageView6.frame.origin.y+btnImageView6.frame.size.height+ 10, 150, 20);
        btnLab6.text = @"Reboot";
        btnLab6.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab6.font = FONT(15);
        [scrollView addSubview:btnLab6];
        [btn6 bringSubviewToFront:btnLab6];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn6 setFrame:CGRectMake(btn5.frame.size.width+3, 570+40 - 64, (SCREEN_WIDTH - 3)/2, (SCREEN_WIDTH - 3)/2 * 0.55)];
        [btn6 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
        //    [btn1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
        btn6.tag = 6;
        [btn6 setBackgroundColor:[UIColor whiteColor]];
        [scrollView addSubview:btn6];
        [scrollView bringSubviewToFront:btn6];
        
        
        btnImageView6.frame = CGRectMake((btn6.frame.size.width - 40)/2 + btn5.frame.size.width+3, btn6.frame.origin.y+24, 40, 40);
        btnImageView6.image = [UIImage imageNamed:@"Reboot-Device"];
        [scrollView addSubview:btnImageView6];
        [btn6 bringSubviewToFront:btnImageView6];
        
        
        
        CGSize size = [GGUtil sizeWithText: @"Reboot" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        NSLog(@"%f",(btnImageView6.frame.size.width - size.width)/2);
        btnLab6.frame = CGRectMake((btn6.frame.size.width - size.width)/2+ btn5.frame.size.width+3, btnImageView6.frame.origin.y+btnImageView6.frame.size.height+ 10, 150, 20);
        btnLab6.text = @"Reboot";
        btnLab6.textColor = [UIColor colorWithRed:0x21/255.0 green:0x21/255.0 blue:0x21/255.0 alpha:1];
        btnLab6.font = FONT(15);
        [scrollView addSubview:btnLab6];
        [btn6 bringSubviewToFront:btnLab6];
        
        //        hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
        //        hudLab.text = @"Network Error";
        //
        //        hudLab.textColor = [UIColor grayColor];
    }
    
}
-(void)clickEvent
{
    NSNotification *notification =[NSNotification notificationWithName:@"removeUITextFieldEding" object:nil userInfo:nil];
    //        //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = YES;
    
}

//点击观看历史直接播放
-(void)touchToSee :(id)sender   //(NSArray* )touchArr
{
//    //每次播放前，都先把 @"deliveryPlayState" 状态重置，这个状态是用来判断视频断开分发后，除非用户点击
//    [USER_DEFAULT setObject:@"beginDelivery" forKey:@"deliveryPlayState"];
    
    
    NSInteger tagIndex = [sender tag];
    NSLog(@"tatatatatatatatatindex %d",tagIndex);
    if (tagIndex == 1) {

        if(![self.navigationController.topViewController isKindOfClass:[self.wLANSettingView class]]) {
            [self.navigationController pushViewController:self.wLANSettingView animated:YES];
        }else
        {
            NSLog(@"此处可能会由于页面跳转过快报错");
        }
        NSLog(@"self.navigationController %@",self.navigationController );
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
        
        
        self.wLANSettingView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        self.wLANSettingView.navigationItem.leftBarButtonItem = myButton;
        
    }else if (tagIndex == 2){
        if(![self.navigationController.topViewController isKindOfClass:[self.securityCenterView class]]) {
            [self.navigationController pushViewController:self.securityCenterView animated:YES];
        }else
        {
            NSLog(@"此处可能会由于页面跳转过快报错");
        }
        NSLog(@"self.navigationController %@",self.navigationController );
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
        
        
        self.securityCenterView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        self.securityCenterView.navigationItem.leftBarButtonItem = myButton;
        
    }
    else if (tagIndex == 3){
        
        if(![self.navigationController.topViewController isKindOfClass:[self.deviceListView class]]) {
            [self.navigationController pushViewController:self.deviceListView animated:YES];
        }else
        {
            NSLog(@"此处可能会由于页面跳转过快报错");
        }
        NSLog(@"self.navigationController %@",self.navigationController );
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
        
        
        self.deviceListView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        self.deviceListView.navigationItem.leftBarButtonItem = myButton;
    }
    else if (tagIndex == 4){
        
        if(![self.navigationController.topViewController isKindOfClass:[self.routerStatusView class]]) {
            [self.navigationController pushViewController:self.routerStatusView animated:YES];
        }else
        {
            NSLog(@"此处可能会由于页面跳转过快报错");
        }
        NSLog(@"self.navigationController %@",self.navigationController );
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
        
        
        self.routerStatusView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        self.routerStatusView.navigationItem.leftBarButtonItem = myButton;
    }
    else if (tagIndex == 5){
        
        if(![self.navigationController.topViewController isKindOfClass:[self.backupRestoreView class]]) {
            [self.navigationController pushViewController:self.backupRestoreView animated:YES];
        }else
        {
            NSLog(@"此处可能会由于页面跳转过快报错");
        }
        NSLog(@"self.navigationController %@",self.navigationController );
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
        
        
        self.backupRestoreView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        self.backupRestoreView.navigationItem.leftBarButtonItem = myButton;
    }
    else if (tagIndex == 6){
        
        //reboot
        //弹窗
       
        [rebootAlert show];
        
        
    }
//    if (tagIndex == 6) {
//        //进入历史界面
//        //    self.tableView.editing = YES;
//        //跳转到历史界面
//        self.historyView = [[HistoryViewController alloc]init];
//        //        [self presentModalViewController:self.routeView animated:YES];
//        //        [self.navigationController pushViewController:self.historyView animated:YES];
//        if(![self.navigationController.topViewController isKindOfClass:[self.historyView class]]) {
//            [self.navigationController pushViewController:self.historyView animated:YES];
//        }else
//        {
//            NSLog(@"此处可能会由于页面跳转过快报错");
//        }
//
//
//
//        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
//        self.historyView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
//
//        self.historyView.navigationItem.leftBarButtonItem = myButton;
//    }else
//    {
//        NSArray * touchArr = historyArr[historyArr.count - tagIndex];
//        NSLog(@"touchArr：%@",touchArr);
//        //    [self touchToSee :touchArr];
//
//
//        NSInteger row = [touchArr[2] intValue];
//        NSDictionary * dic = touchArr [3];
//
//
//        //    self.tvViewController = [[TVViewController alloc]init];
//        //    [self.tvViewController touchSelectChannel:row diction:dic];
//        ////    NSLog(@"当前点击了 ：%@",self.showData[indexPath.row]  );
//        //将整形转换为number
//        NSNumber * numIndex = [NSNumber numberWithInt:row];
//
//        //添加 字典，将label的值通过key值设置传递
//        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
//
//
//
//        //这里需要进行一次判断，看是不是需要弹出机顶盒加锁密码框
//        NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
//
//        NSString * characterStr = [epgDicToSocket objectForKey:@"service_character"]; //新加了一个service_character
//
//
//        if (characterStr != NULL && characterStr != nil) {
//
//            BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
//            if (judgeIsSTBDecrypt == YES) {
//                // 此处代表需要记性机顶盒加密验证
//                //弹窗
//                //发送通知
//
//                //        [self popSTBAlertView];
//                //        [self popCAAlertView];
//                NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"otherTouch",@"textThree",nil];
//                //创建通知
//                NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
//                //通过通知中心发送通知
//                [[NSNotificationCenter defaultCenter] postNotification:notification1];
//
//                [self.tabBarController setSelectedIndex:1];
//
//            }else //正常播放的步骤
//            {
//                //创建通知
//                NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
//                //通过通知中心发送通知
//                [[NSNotificationCenter defaultCenter] postNotification:notification];
//
//                [self.tabBarController setSelectedIndex:1];
//            }
//
//
//        }else //正常播放的步骤
//        {
//
//
//            //创建通知
//            NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
//            //通过通知中心发送通知
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//            //    [self.navigationController popViewControllerAnimated:YES];
//            //    [self.navigationController popToViewController:_tvViewController animated:YES];
//            //    [self.navigationController pushViewController:_tvViewController animated:YES];
//            [self.tabBarController setSelectedIndex:1];
//        }
//
//    }
    
//    [self TVViewAppearNO];  //点击这六个按钮则跳转到TV页面不会自动播放历史的第一个节目
    
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)getWifi
//{
//
//    //获取数据的链接
//    NSString * url =     [NSString stringWithFormat:@"http://%@/lua/settings/wifi",DMSIP];
//    //    NSString *url = [NSString stringWithFormat:@"%@",G_devicepwd];
//
//    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
//
//    [request startAsynchronous ];
//
//    //    NSError *error = [request error ];
//    //    assert (!error);
//    // 如果请求成功，返回 Response
//
//
//    [request setCompletionBlock:^{
//        NSLog ( @"request:%@" ,request);
//        NSDictionary *onlineWifi = [request responseData].JSONValue;
//        NSLog ( @"onlineDeviceArr333:%@" ,onlineWifi);
//        //        wifiDic = [[NSDictionary alloc]init];
//        //        wifiDic = onlineWifi;
//        //
//        //
//        //        routeNameLab.text = [wifiDic objectForKey:@"name"];
//        //
//        //        //        routeIPLab.text =  @"IP:192.168.1.1" ;//[wifiDic objectForKey:@"ip"];
//        //        routeIPLab.text = [NSString stringWithFormat:@"IP:%@",DMSIP];
//    }];
//
//
//
//
//}
//#pragma mark - 初始化创建不同的通知
//-(void)initNotific
//{
//    //////////////////////////// 从socket返回数据
//    //此处接收到路由器IP地址的消息
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getSocketIpInfoNotice" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSocketIpInfo:) name:@"getSocketIpInfoNotice" object:nil];
//
//    //获取网络链接的通知
//    NSNotification *notification =[NSNotification notificationWithName:@"socketGetIPAddressNotific" object:nil userInfo:nil];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//
//    ///创建通知，用于判断网络是否正常
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"routeNetWorkError" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeNetWorkError) name:@"getSocketIpInfoNotice" object:nil];
//
//}
//- (void)getSocketIpInfo:(NSNotification *)text{
//
//    NSData * socketIPData = text.userInfo[@"socketIPAddress"];
//    NSData * ipStrData ;
//    NSLog(@"socketIPData :%@",socketIPData);
//
//    if (socketIPData != NULL  && socketIPData != nil  &&  socketIPData.length > 0 ) {
//
//        if (socketIPData.length >38) {
//
//            if ([socketIPData length] >= 1 + 37 + socketIPData.length - 38) {
//                ipStrData = [socketIPData subdataWithRange:NSMakeRange(1 + 37,socketIPData.length - 38)];
//            }else
//            {
//                return;
//            }
//
//            NSLog(@"ipStrData %@",ipStrData);
//
//            DMSIP =  [[NSString alloc] initWithData:ipStrData  encoding:NSUTF8StringEncoding];
//            NSLog(@" DMSIP %@",DMSIP);
//
//            //            [self loadNav];
//            [self viewWillAppear:YES];
//        }
//
//    }
//
//
//}
////-(void)getCurrentWifi
////{
////
////    //获取数据的链接
////    NSString * url =     [NSString stringWithFormat:@"http://%@/lua/settings/getLoginPasswd",DMSIP];
////    //    NSString *url = [NSString stringWithFormat:@"%@",G_devicepwd];
////
////    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
////
////    [request startAsynchronous ];
////
////    //    NSError *error = [request error ];
////    //    assert (!error);
////    // 如果请求成功，返回 Response
////
////
////    [request setCompletionBlock:^{
////        NSLog ( @"request:%@" ,request);
////        NSDictionary *pwdDic = [request responseData].JSONValue;
////        NSLog ( @"onlineDeviceArr:%@" ,pwdDic);
////
////        NSString * pwdStr =[pwdDic objectForKey:@"pwd"];
////
////        if ([pwdStr isEqualToString:@"MGadmin"] || [pwdStr isEqualToString:@""] || pwdStr == NULL) {
////            NSLog(@"需要展示修改密码的界面");
////            [self showPwdRegistrView];
////
////        }else
////        {
////            NSLog(@"用户输入PIN 进入");
////            [self showLoginView];
////            //            [self showPwdRegistrView];
////        }
////        //        wifiDic = [[NSDictionary alloc]init];
////        //        wifiDic = onlineWifi;
////        //
////        //
////        //        routeNameLab.text = [wifiDic objectForKey:@"name"];
////        //
////        //        //        routeIPLab.text =  @"IP:192.168.1.1" ;//[wifiDic objectForKey:@"ip"];
////        //        routeIPLab.text = [NSString stringWithFormat:@"IP:%@",DMSIP];
////    }];
////
////
////
////
////}

#pragma mark - 弹窗点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
        if(buttonIndex == 1)
        {
            
        }else{
            
            //验证
            [self rebootOKClick];
            
            
        }
}
-(void)rebootOKClick
{
    NSLog(@"dandkjasdabdas");
    
    DMSIP = [USER_DEFAULT objectForKey:@"RouterPsw"];
    
    if (DMSIP != nil && DMSIP != NULL && DMSIP.length > 0) {
        
    }else
    {
        return;
    }
    
    //获取数据的链接
    NSString * url =[NSString stringWithFormat:@"http://%@/lua/update/reboot",DMSIP];
    
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
    [request setNumberOfTimesToRetryOnTimeout:5];
    request.delegate = self;
    
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
        deviceDic = onlineDeviceDic;
        NSLog(@"deviceDic :%@",deviceDic);
        
        
        if ([deviceDic objectForKey:@"result"] != NULL || [deviceDic objectForKey:@"result"] != nil) {
            if ([[deviceDic objectForKey:@"code"] isEqual:@0] ) {
               //成功，显示图片
                
                
                restartingAlert = [[UIAlertView alloc] initWithTitle:@"Restarting"
                                                    message:reStartTip delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
                
                [restartingAlert show];
                
                //加入断网消息，如果网络断开，则显示没有网络界面
                
            }else
            {
               //重启失败
                
                restartingAlert = [[UIAlertView alloc] initWithTitle:@"Restore Failed"
                                                             message:nil delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles: nil];
                
                [restartingAlert show];
            }

        }
        
    }];
    
    

}

#pragma mark - 加载无网络图
-(void)showNetWorkErrorView
{
    //取消掉弹窗
    [restartingAlert dismissWithClickedButtonIndex:[restartingAlert cancelButtonIndex] animated:NO];
    
    
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
    
    
}
@end
