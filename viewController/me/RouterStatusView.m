//
//  RouterStatusView.m
//  StarAPP
//
//  Created by xyz on 2017/10/30.
//

#import "RouterStatusView.h"
#import "MEViewController.h"
#import "GGUtil.h"

@interface RouterStatusView ()
{
    NSDictionary * deviceDic;
    NSDictionary * deviceDic2;
    NSString * routeName_seted;
    
    MBProgressHUD * HUD;
    UIView *  netWorkErrorView;
    
    NSString * DMSIP;
    NSString * deviceString;
    
    UIView * lineManufacturerId;
    UIView * lineHardwareVersionLab;
    UIView * lineSortwareVersionLab;
    UIView * lineBuildDataLab;
    UIView * lineSerialNumberLab;
    UIView * lineWANMac;
    UIView * lineLANMAC;
    UIView * lineWIFIMAC;
    UIView * lineSubnetMaskLab;
    UIView * lineIPAddressLab;
}
@property(nonatomic,strong)MEViewController * meViewController;
@property(nonatomic,strong)UIScrollView * scrollView;
@end

@implementation RouterStatusView

@synthesize HardwareVersionLab1;
@synthesize SortwareVersionLab1;
@synthesize BuildDataLab1;
@synthesize SerialNumberLab1;
@synthesize WANMacAddressLab1;
@synthesize LAMacAddressLab1;
@synthesize WIFIMacAddressLab1;
@synthesize SubnetMaskLab1;
@synthesize IPAddressLab1;
@synthesize ManufacturerId1;
//@synthesize connectDevice;
//@synthesize tableView;
//@synthesize onlineDeviceDic;

@synthesize wifiDic;
@synthesize wifiName;
@synthesize wifiIP;
@synthesize wifiPwd;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    deviceString = [GGUtil deviceVersion];
    [self loadNav];
    [self initData];
    self.meViewController = [[MEViewController alloc]init];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"routeNetWorkError" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetWorkErrorView) name:@"routeNetWorkError" object:nil];
    
    
    
    //new
    NSString * MLManufacturerIdLab = NSLocalizedString(@"MLManufacturerIdLab", nil);
    self.ManufacturerIdLab1.text = MLManufacturerIdLab;
    
    //57.Hardware version
    NSString * MLHardwareversion = NSLocalizedString(@"MLHardwareversion", nil);
    self.MHardVersion1.text =   MLHardwareversion;//MLHardwareversion;
    //58.确认新密码
    NSString * MLSoftwareversion = NSLocalizedString(@"MLSoftwareversion", nil);
    self.MSoftwareVersion1.text =  MLSoftwareversion;//MLSoftwareversion;
    //59.确认新密码
    NSString * MLBuilddate = NSLocalizedString(@"MLBuilddate", nil);
    self.MBuildData1.text = MLBuilddate;//MLBuilddate;
    //60.确认新密码
    NSString * MLSerialnumber = NSLocalizedString(@"MLSerialnumber", nil);
    self.MSerialNum1.text = MLSerialnumber;//MLSerialnumber;
    //61.确认新密码
//    NSString * MLMACaddress = NSLocalizedString(@"MLMACaddress", nil);
    self.MWANMACAddress1.text = @"WAN MAC Address";//MLMACaddress;
    self.MLANMACAddress1.text = @"LAN MAC Address";//MLMACaddress;
    self.MWIFIMACAddress1.text = @"Wi-Fi MAC Address";//MLMACaddress;
    //62.确认新密码
    NSString * MLSubnetmask = NSLocalizedString(@"MLSubnetmask", nil);
    self.MSubnetMask1.text = MLSubnetmask;//MLSubnetmask;
    //63.确认新密码
    NSString * MLIPaddress = NSLocalizedString(@"MLIPaddress", nil);
    self.MIPAddress1.text = MLIPaddress;//MLIPaddress;

    
    

}
-(void)initData
{
    
    lineManufacturerId = [[UIView alloc]init];
    lineHardwareVersionLab = [[UIView alloc]init];
    lineSortwareVersionLab = [[UIView alloc]init];
    lineBuildDataLab = [[UIView alloc]init];
    lineSerialNumberLab = [[UIView alloc]init];
    lineWANMac = [[UIView alloc]init];
    lineLANMAC = [[UIView alloc]init];
    lineWIFIMAC = [[UIView alloc]init];
    lineSubnetMaskLab = [[UIView alloc]init];
    lineIPAddressLab = [[UIView alloc]init];
    
    
    
    self.MHardVersion1 = [[UILabel alloc]init];
    self.MSoftwareVersion1 = [[UILabel alloc]init];
    self.MBuildData1 = [[UILabel alloc]init];
    self.MSerialNum1 = [[UILabel alloc]init];
    self.MWANMACAddress1 = [[UILabel alloc]init];
    self.MLANMACAddress1 = [[UILabel alloc]init];
    self.MWIFIMACAddress1 = [[UILabel alloc]init];
    self.MSubnetMask1 = [[UILabel alloc]init];
    self.MIPAddress1 = [[UILabel alloc]init];
    self.ManufacturerIdLab1 = [[UILabel alloc]init];
    
    
    
    
     ManufacturerId1            = [[UILabel alloc]init];
     HardwareVersionLab1        = [[UILabel alloc]init];
     SortwareVersionLab1        = [[UILabel alloc]init];
     BuildDataLab1              = [[UILabel alloc]init];
     SerialNumberLab1           = [[UILabel alloc]init];
     WANMacAddressLab1             = [[UILabel alloc]init];

     LAMacAddressLab1           = [[UILabel alloc]init];
     WIFIMacAddressLab1         = [[UILabel alloc]init];
     SubnetMaskLab1             = [[UILabel alloc]init];
     IPAddressLab1              = [[UILabel alloc]init];;
    
    
    
    
    
    
    
    
    
    
    
    [self loadScroll];
}
-(void)loadScroll
{
    //加一个scrollview
    self.scrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.scrollView ];
    
    
    if ([deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"] ) {
        NSLog(@"此刻是4s 的大小");
        //scroll
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 640);
        
        
        lineManufacturerId.frame = CGRectMake(20, 100+20, 300, 1);
        lineManufacturerId.backgroundColor = [UIColor grayColor];
        lineManufacturerId.alpha = 0.4;
        [self.scrollView addSubview:lineManufacturerId];
        
        lineHardwareVersionLab.frame = CGRectMake(20, 150+20, 300, 1);
        lineHardwareVersionLab.backgroundColor = [UIColor grayColor];
        lineHardwareVersionLab.alpha = 0.4;
        [self.scrollView addSubview:lineHardwareVersionLab];
        
        lineSortwareVersionLab.frame = CGRectMake(20, 200+20, 300, 1);
        lineSortwareVersionLab.backgroundColor = [UIColor grayColor];
        lineSortwareVersionLab.alpha = 0.4;
        [self.scrollView addSubview:lineSortwareVersionLab];
        
        lineBuildDataLab.frame = CGRectMake(20, 250+20, 300, 1);
        lineBuildDataLab.backgroundColor = [UIColor grayColor];
        lineBuildDataLab.alpha = 0.4;
        [self.scrollView addSubview:lineBuildDataLab];
        
        lineSerialNumberLab.frame = CGRectMake(20, 300+20, 300, 1);
        lineSerialNumberLab.backgroundColor = [UIColor grayColor];
        lineSerialNumberLab.alpha = 0.4;
        [self.scrollView addSubview:lineSerialNumberLab];
        
        lineWANMac.frame = CGRectMake(20, 350+20, 300, 1);
        lineWANMac.backgroundColor = [UIColor grayColor];
        lineWANMac.alpha = 0.4;
        [self.scrollView addSubview:lineWANMac];
        
        lineLANMAC.frame = CGRectMake(20, 400+20, 300, 1);
        lineLANMAC.backgroundColor = [UIColor grayColor];
        lineLANMAC.alpha = 0.4;
        [self.scrollView addSubview:lineLANMAC];
        
        lineWIFIMAC.frame = CGRectMake(20, 450+20, 300, 1);
        lineWIFIMAC.backgroundColor = [UIColor grayColor];
        lineWIFIMAC.alpha = 0.4;
        [self.scrollView addSubview:lineWIFIMAC];
        
        lineSubnetMaskLab.frame = CGRectMake(20, 500+20, 300, 1);
        lineSubnetMaskLab.backgroundColor = [UIColor grayColor];
        lineSubnetMaskLab.alpha = 0.4;
        [self.scrollView addSubview:lineSubnetMaskLab];
        
        lineIPAddressLab.frame = CGRectMake(20, 550+20, 300, 1);
        lineIPAddressLab.backgroundColor = [UIColor grayColor];
        lineIPAddressLab.alpha = 0.4;
        [self.scrollView addSubview:lineIPAddressLab];
        
        
        //左侧数据
        self.ManufacturerIdLab1.frame =      CGRectMake(20, 55 -10, 150, 100);
        self.MHardVersion1.frame =           CGRectMake(20, 105 -10, 150, 100);
        self.MSoftwareVersion1.frame =       CGRectMake(20, 155 -10, 150, 100);
        self.MBuildData1.frame =             CGRectMake(20, 205 -10, 150, 100);
        
        self.MSerialNum1.frame =             CGRectMake(20, 255 -10, 150, 100);
        self.MWANMACAddress1.frame =         CGRectMake(20, 305 -10, 150, 100);
        self.MLANMACAddress1.frame =         CGRectMake(20, 355 -10, 150, 100);
        self.MWIFIMACAddress1.frame =        CGRectMake(20, 405 -10, 150, 100);
        self.MSubnetMask1.frame =            CGRectMake(20, 455 -10, 150, 100);
        self.MIPAddress1.frame =             CGRectMake(20, 505 -10, 150, 100);
        
        self.ManufacturerIdLab1.font = FONT(15);
        self.MHardVersion1.font = FONT(15);
        self.MSoftwareVersion1.font = FONT(15);
        self.MBuildData1.font = FONT(15);
        self.MSerialNum1.font = FONT(15);
        self.MWANMACAddress1.font = FONT(15);
        self.MLANMACAddress1.font = FONT(15);
        self.MWIFIMACAddress1.font = FONT(15);
        self.MSubnetMask1.font = FONT(15);
        self.MIPAddress1.font = FONT(15);
        
        
        
        [self.scrollView addSubview: self.ManufacturerIdLab1];
        [self.scrollView addSubview: self.MHardVersion1];
        [self.scrollView addSubview: self.MSoftwareVersion1];
        [self.scrollView addSubview: self.MBuildData1];;
        [self.scrollView addSubview: self.MSerialNum1];
        [self.scrollView addSubview: self.MWANMACAddress1];
        [self.scrollView addSubview: self.MLANMACAddress1];
        [self.scrollView addSubview: self.MWIFIMACAddress1];
        [self.scrollView addSubview: self.MSubnetMask1];
        [self.scrollView addSubview: self.MIPAddress1];;
        
        
        //右侧数据
        ManufacturerId1.frame =          CGRectMake(160, 55 -10, 140, 100);
        HardwareVersionLab1.frame =      CGRectMake(160, 105 -10, 140, 100);
        SortwareVersionLab1.frame =      CGRectMake(160, 155 -10, 140, 100);
        BuildDataLab1.frame =            CGRectMake(160, 205 -10, 140, 100);
        SerialNumberLab1.frame =         CGRectMake(160, 255 -10, 140, 100);
        WANMacAddressLab1.frame =        CGRectMake(160, 305 -10, 140, 100);
        LAMacAddressLab1.frame =         CGRectMake(160, 355 -10, 140, 100);
        WIFIMacAddressLab1.frame =       CGRectMake(160, 405 -10, 140, 100);
        SubnetMaskLab1.frame =           CGRectMake(160, 455 -10, 140, 100);
        IPAddressLab1.frame =            CGRectMake(160, 505 -10, 140, 100);
        
        ManufacturerId1.textAlignment = NSTextAlignmentRight;
        HardwareVersionLab1.textAlignment = NSTextAlignmentRight;
        SortwareVersionLab1.textAlignment = NSTextAlignmentRight;
        BuildDataLab1.textAlignment = NSTextAlignmentRight;
        SerialNumberLab1.textAlignment = NSTextAlignmentRight;
        WANMacAddressLab1.textAlignment = NSTextAlignmentRight;
        LAMacAddressLab1.textAlignment = NSTextAlignmentRight;
        WIFIMacAddressLab1.textAlignment = NSTextAlignmentRight;
        SubnetMaskLab1.textAlignment = NSTextAlignmentRight;
        IPAddressLab1.textAlignment = NSTextAlignmentRight;
        
        
        
        self.ManufacturerId1.font = FONT(15);
        self.HardwareVersionLab1.font = FONT(15);
        self.SortwareVersionLab1.font = FONT(15);
        self.BuildDataLab1.font = FONT(15);
        self.SerialNumberLab1.font = FONT(15);
        self.WANMacAddressLab1.font = FONT(15);
        self.LAMacAddressLab1.font = FONT(15);
        self.WIFIMacAddressLab1.font = FONT(15);
        self.SubnetMaskLab1.font = FONT(15);
        self.IPAddressLab1.font = FONT(15);
        
        
        
        
        
        
        
        
        
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] ) {
        NSLog(@"此刻是5s 的大小");
        //scroll
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 640);
        
        
        lineManufacturerId.frame = CGRectMake(20, 100+20, 300, 1);
        lineManufacturerId.backgroundColor = [UIColor grayColor];
        lineManufacturerId.alpha = 0.4;
        [self.scrollView addSubview:lineManufacturerId];
        
        lineHardwareVersionLab.frame = CGRectMake(20, 150+20, 300, 1);
        lineHardwareVersionLab.backgroundColor = [UIColor grayColor];
        lineHardwareVersionLab.alpha = 0.4;
        [self.scrollView addSubview:lineHardwareVersionLab];
        
        lineSortwareVersionLab.frame = CGRectMake(20, 200+20, 300, 1);
        lineSortwareVersionLab.backgroundColor = [UIColor grayColor];
        lineSortwareVersionLab.alpha = 0.4;
        [self.scrollView addSubview:lineSortwareVersionLab];
        
        lineBuildDataLab.frame = CGRectMake(20, 250+20, 300, 1);
        lineBuildDataLab.backgroundColor = [UIColor grayColor];
        lineBuildDataLab.alpha = 0.4;
        [self.scrollView addSubview:lineBuildDataLab];
        
        lineSerialNumberLab.frame = CGRectMake(20, 300+20, 300, 1);
        lineSerialNumberLab.backgroundColor = [UIColor grayColor];
        lineSerialNumberLab.alpha = 0.4;
        [self.scrollView addSubview:lineSerialNumberLab];
        
        lineWANMac.frame = CGRectMake(20, 350+20, 300, 1);
        lineWANMac.backgroundColor = [UIColor grayColor];
        lineWANMac.alpha = 0.4;
        [self.scrollView addSubview:lineWANMac];
        
        lineLANMAC.frame = CGRectMake(20, 400+20, 300, 1);
        lineLANMAC.backgroundColor = [UIColor grayColor];
        lineLANMAC.alpha = 0.4;
        [self.scrollView addSubview:lineLANMAC];
        
        lineWIFIMAC.frame = CGRectMake(20, 450+20, 300, 1);
        lineWIFIMAC.backgroundColor = [UIColor grayColor];
        lineWIFIMAC.alpha = 0.4;
        [self.scrollView addSubview:lineWIFIMAC];
        
        lineSubnetMaskLab.frame = CGRectMake(20, 500+20, 300, 1);
        lineSubnetMaskLab.backgroundColor = [UIColor grayColor];
        lineSubnetMaskLab.alpha = 0.4;
        [self.scrollView addSubview:lineSubnetMaskLab];
        
        lineIPAddressLab.frame = CGRectMake(20, 550+20, 300, 1);
        lineIPAddressLab.backgroundColor = [UIColor grayColor];
        lineIPAddressLab.alpha = 0.4;
        [self.scrollView addSubview:lineIPAddressLab];
        
        
        //左侧数据
        self.ManufacturerIdLab1.frame =      CGRectMake(20, 55 -10, 150, 100);
        self.MHardVersion1.frame =           CGRectMake(20, 105 -10, 150, 100);
        self.MSoftwareVersion1.frame =       CGRectMake(20, 155 -10, 150, 100);
        self.MBuildData1.frame =             CGRectMake(20, 205 -10, 150, 100);
        
        self.MSerialNum1.frame =             CGRectMake(20, 255 -10, 150, 100);
        self.MWANMACAddress1.frame =         CGRectMake(20, 305 -10, 150, 100);
        self.MLANMACAddress1.frame =         CGRectMake(20, 355 -10, 150, 100);
        self.MWIFIMACAddress1.frame =        CGRectMake(20, 405 -10, 150, 100);
        self.MSubnetMask1.frame =            CGRectMake(20, 455 -10, 150, 100);
        self.MIPAddress1.frame =             CGRectMake(20, 505 -10, 150, 100);
        
        self.ManufacturerIdLab1.font = FONT(15);
        self.MHardVersion1.font = FONT(15);
        self.MSoftwareVersion1.font = FONT(15);
        self.MBuildData1.font = FONT(15);
        self.MSerialNum1.font = FONT(15);
        self.MWANMACAddress1.font = FONT(15);
        self.MLANMACAddress1.font = FONT(15);
        self.MWIFIMACAddress1.font = FONT(15);
        self.MSubnetMask1.font = FONT(15);
        self.MIPAddress1.font = FONT(15);
        
        
        
        [self.scrollView addSubview: self.ManufacturerIdLab1];
        [self.scrollView addSubview: self.MHardVersion1];
        [self.scrollView addSubview: self.MSoftwareVersion1];
        [self.scrollView addSubview: self.MBuildData1];;
        [self.scrollView addSubview: self.MSerialNum1];
        [self.scrollView addSubview: self.MWANMACAddress1];
        [self.scrollView addSubview: self.MLANMACAddress1];
        [self.scrollView addSubview: self.MWIFIMACAddress1];
        [self.scrollView addSubview: self.MSubnetMask1];
        [self.scrollView addSubview: self.MIPAddress1];;
        
        
        //右侧数据
        ManufacturerId1.frame =          CGRectMake(160, 55 -10, 140, 100);
        HardwareVersionLab1.frame =      CGRectMake(160, 105 -10, 140, 100);
        SortwareVersionLab1.frame =      CGRectMake(160, 155 -10, 140, 100);
        BuildDataLab1.frame =            CGRectMake(160, 205 -10, 140, 100);
        SerialNumberLab1.frame =         CGRectMake(160, 255 -10, 140, 100);
        WANMacAddressLab1.frame =        CGRectMake(160, 305 -10, 140, 100);
        LAMacAddressLab1.frame =         CGRectMake(160, 355 -10, 140, 100);
        WIFIMacAddressLab1.frame =       CGRectMake(160, 405 -10, 140, 100);
        SubnetMaskLab1.frame =           CGRectMake(160, 455 -10, 140, 100);
        IPAddressLab1.frame =            CGRectMake(160, 505 -10, 140, 100);
        
        ManufacturerId1.textAlignment = NSTextAlignmentRight;
        HardwareVersionLab1.textAlignment = NSTextAlignmentRight;
        SortwareVersionLab1.textAlignment = NSTextAlignmentRight;
        BuildDataLab1.textAlignment = NSTextAlignmentRight;
        SerialNumberLab1.textAlignment = NSTextAlignmentRight;
        WANMacAddressLab1.textAlignment = NSTextAlignmentRight;
        LAMacAddressLab1.textAlignment = NSTextAlignmentRight;
        WIFIMacAddressLab1.textAlignment = NSTextAlignmentRight;
        SubnetMaskLab1.textAlignment = NSTextAlignmentRight;
        IPAddressLab1.textAlignment = NSTextAlignmentRight;
        
        
        
        self.ManufacturerId1.font = FONT(15);
        self.HardwareVersionLab1.font = FONT(15);
        self.SortwareVersionLab1.font = FONT(15);
        self.BuildDataLab1.font = FONT(15);
        self.SerialNumberLab1.font = FONT(15);
        self.WANMacAddressLab1.font = FONT(15);
        self.LAMacAddressLab1.font = FONT(15);
        self.WIFIMacAddressLab1.font = FONT(15);
        self.SubnetMaskLab1.font = FONT(15);
        self.IPAddressLab1.font = FONT(15);
        
        
        
 
        
        
        
        
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]  || [deviceString isEqualToString:@"iPhone8"]  || [deviceString isEqualToString:@"iPhoneX"] || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6s 的大小");
        //scroll
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 640);
        
        
        lineManufacturerId.frame = CGRectMake(20, 100+20, 340, 1);
        lineManufacturerId.backgroundColor = [UIColor grayColor];
        lineManufacturerId.alpha = 0.4;
        [self.scrollView addSubview:lineManufacturerId];
        
        lineHardwareVersionLab.frame = CGRectMake(20, 150+20, 340, 1);
        lineHardwareVersionLab.backgroundColor = [UIColor grayColor];
        lineHardwareVersionLab.alpha = 0.4;
        [self.scrollView addSubview:lineHardwareVersionLab];
        
        lineSortwareVersionLab.frame = CGRectMake(20, 200+20, 340, 1);
        lineSortwareVersionLab.backgroundColor = [UIColor grayColor];
        lineSortwareVersionLab.alpha = 0.4;
        [self.scrollView addSubview:lineSortwareVersionLab];
        
        lineBuildDataLab.frame = CGRectMake(20, 250+20, 340, 1);
        lineBuildDataLab.backgroundColor = [UIColor grayColor];
        lineBuildDataLab.alpha = 0.4;
        [self.scrollView addSubview:lineBuildDataLab];
        
        lineSerialNumberLab.frame = CGRectMake(20, 300+20, 340, 1);
        lineSerialNumberLab.backgroundColor = [UIColor grayColor];
        lineSerialNumberLab.alpha = 0.4;
        [self.scrollView addSubview:lineSerialNumberLab];
        
        lineWANMac.frame = CGRectMake(20, 350+20, 340, 1);
        lineWANMac.backgroundColor = [UIColor grayColor];
        lineWANMac.alpha = 0.4;
        [self.scrollView addSubview:lineWANMac];
        
        lineLANMAC.frame = CGRectMake(20, 400+20, 340, 1);
        lineLANMAC.backgroundColor = [UIColor grayColor];
        lineLANMAC.alpha = 0.4;
        [self.scrollView addSubview:lineLANMAC];
        
        lineWIFIMAC.frame = CGRectMake(20, 450+20, 340, 1);
        lineWIFIMAC.backgroundColor = [UIColor grayColor];
        lineWIFIMAC.alpha = 0.4;
        [self.scrollView addSubview:lineWIFIMAC];
        
        lineSubnetMaskLab.frame = CGRectMake(20, 500+20, 340, 1);
        lineSubnetMaskLab.backgroundColor = [UIColor grayColor];
        lineSubnetMaskLab.alpha = 0.4;
        [self.scrollView addSubview:lineSubnetMaskLab];
        
        lineIPAddressLab.frame = CGRectMake(20, 550+20, 340, 1);
        lineIPAddressLab.backgroundColor = [UIColor grayColor];
        lineIPAddressLab.alpha = 0.4;
        [self.scrollView addSubview:lineIPAddressLab];
        
        
        //左侧数据
        self.ManufacturerIdLab1.frame =      CGRectMake(20, 55 -10, 150, 100);
        self.MHardVersion1.frame =           CGRectMake(20, 105 -10, 150, 100);
        self.MSoftwareVersion1.frame =       CGRectMake(20, 155 -10, 150, 100);
        self.MBuildData1.frame =             CGRectMake(20, 205 -10, 150, 100);
        
        self.MSerialNum1.frame =             CGRectMake(20, 255 -10, 150, 100);
        self.MWANMACAddress1.frame =         CGRectMake(20, 305 -10, 150, 100);
        self.MLANMACAddress1.frame =         CGRectMake(20, 355 -10, 150, 100);
        self.MWIFIMACAddress1.frame =        CGRectMake(20, 405 -10, 150, 100);
        self.MSubnetMask1.frame =            CGRectMake(20, 455 -10, 150, 100);
        self.MIPAddress1.frame =             CGRectMake(20, 505 -10, 150, 100);
        
        self.ManufacturerIdLab1.font = FONT(15);
        self.MHardVersion1.font = FONT(15);
        self.MSoftwareVersion1.font = FONT(15);
        self.MBuildData1.font = FONT(15);
        self.MSerialNum1.font = FONT(15);
        self.MWANMACAddress1.font = FONT(15);
        self.MLANMACAddress1.font = FONT(15);
        self.MWIFIMACAddress1.font = FONT(15);
        self.MSubnetMask1.font = FONT(15);
        self.MIPAddress1.font = FONT(15);
        
        
        
        [self.scrollView addSubview: self.ManufacturerIdLab1];
        [self.scrollView addSubview: self.MHardVersion1];
        [self.scrollView addSubview: self.MSoftwareVersion1];
        [self.scrollView addSubview: self.MBuildData1];;
        [self.scrollView addSubview: self.MSerialNum1];
        [self.scrollView addSubview: self.MWANMACAddress1];
        [self.scrollView addSubview: self.MLANMACAddress1];
        [self.scrollView addSubview: self.MWIFIMACAddress1];
        [self.scrollView addSubview: self.MSubnetMask1];
        [self.scrollView addSubview: self.MIPAddress1];;
        
        
        //右侧数据
        ManufacturerId1.frame =          CGRectMake(160, 55 -10, 185, 100);
        HardwareVersionLab1.frame =      CGRectMake(160, 105 -10, 185, 100);
        SortwareVersionLab1.frame =      CGRectMake(160, 155 -10, 185, 100);
        BuildDataLab1.frame =            CGRectMake(160, 205 -10, 185, 100);
        SerialNumberLab1.frame =         CGRectMake(160, 255 -10, 185, 100);
        WANMacAddressLab1.frame =        CGRectMake(160, 305 -10, 185, 100);
        LAMacAddressLab1.frame =         CGRectMake(160, 355 -10, 185, 100);
        WIFIMacAddressLab1.frame =       CGRectMake(160, 405 -10, 185, 100);
        SubnetMaskLab1.frame =           CGRectMake(160, 455 -10, 185, 100);
        IPAddressLab1.frame =            CGRectMake(160, 505 -10, 185, 100);
        
        ManufacturerId1.textAlignment = NSTextAlignmentRight;
        HardwareVersionLab1.textAlignment = NSTextAlignmentRight;
        SortwareVersionLab1.textAlignment = NSTextAlignmentRight;
        BuildDataLab1.textAlignment = NSTextAlignmentRight;
        SerialNumberLab1.textAlignment = NSTextAlignmentRight;
        WANMacAddressLab1.textAlignment = NSTextAlignmentRight;
        LAMacAddressLab1.textAlignment = NSTextAlignmentRight;
        WIFIMacAddressLab1.textAlignment = NSTextAlignmentRight;
        SubnetMaskLab1.textAlignment = NSTextAlignmentRight;
        IPAddressLab1.textAlignment = NSTextAlignmentRight;
        
        
        
        self.ManufacturerId1.font = FONT(15);
        self.HardwareVersionLab1.font = FONT(15);
        self.SortwareVersionLab1.font = FONT(15);
        self.BuildDataLab1.font = FONT(15);
        self.SerialNumberLab1.font = FONT(15);
        self.WANMacAddressLab1.font = FONT(15);
        self.LAMacAddressLab1.font = FONT(15);
        self.WIFIMacAddressLab1.font = FONT(15);
        self.SubnetMaskLab1.font = FONT(15);
        self.IPAddressLab1.font = FONT(15);
        
        
        
        
        
        
        
        
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] || [deviceString isEqualToString:@"iPhone8 Plus"]) {
        NSLog(@"此刻是6P 的大小");
        //scroll
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 640);
        
        
        lineManufacturerId.frame = CGRectMake(30, 100+20, 360, 1);
        lineManufacturerId.backgroundColor = [UIColor grayColor];
        lineManufacturerId.alpha = 0.4;
        [self.scrollView addSubview:lineManufacturerId];
        
        lineHardwareVersionLab.frame = CGRectMake(30, 150+20, 360, 1);
        lineHardwareVersionLab.backgroundColor = [UIColor grayColor];
        lineHardwareVersionLab.alpha = 0.4;
        [self.scrollView addSubview:lineHardwareVersionLab];
        
        lineSortwareVersionLab.frame = CGRectMake(30, 200+20, 360, 1);
        lineSortwareVersionLab.backgroundColor = [UIColor grayColor];
        lineSortwareVersionLab.alpha = 0.4;
        [self.scrollView addSubview:lineSortwareVersionLab];
        
        lineBuildDataLab.frame = CGRectMake(30, 250+20, 360, 1);
        lineBuildDataLab.backgroundColor = [UIColor grayColor];
        lineBuildDataLab.alpha = 0.4;
        [self.scrollView addSubview:lineBuildDataLab];
        
        lineSerialNumberLab.frame = CGRectMake(30, 300+20, 360, 1);
        lineSerialNumberLab.backgroundColor = [UIColor grayColor];
        lineSerialNumberLab.alpha = 0.4;
        [self.scrollView addSubview:lineSerialNumberLab];
        
        lineWANMac.frame = CGRectMake(30, 350+20, 360, 1);
        lineWANMac.backgroundColor = [UIColor grayColor];
        lineWANMac.alpha = 0.4;
        [self.scrollView addSubview:lineWANMac];
        
        lineLANMAC.frame = CGRectMake(30, 400+20, 360, 1);
        lineLANMAC.backgroundColor = [UIColor grayColor];
        lineLANMAC.alpha = 0.4;
        [self.scrollView addSubview:lineLANMAC];
        
        lineWIFIMAC.frame = CGRectMake(30, 450+20, 360, 1);
        lineWIFIMAC.backgroundColor = [UIColor grayColor];
        lineWIFIMAC.alpha = 0.4;
        [self.scrollView addSubview:lineWIFIMAC];
        
        lineSubnetMaskLab.frame = CGRectMake(30, 500+20, 360, 1);
        lineSubnetMaskLab.backgroundColor = [UIColor grayColor];
        lineSubnetMaskLab.alpha = 0.4;
        [self.scrollView addSubview:lineSubnetMaskLab];
        
        lineIPAddressLab.frame = CGRectMake(30, 550+20, 360, 1);
        lineIPAddressLab.backgroundColor = [UIColor grayColor];
        lineIPAddressLab.alpha = 0.4;
        [self.scrollView addSubview:lineIPAddressLab];
        
        
        //左侧数据
        self.ManufacturerIdLab1.frame =      CGRectMake(35, 55 -10, 190, 100);
        self.MHardVersion1.frame =           CGRectMake(35, 105 -10, 190, 100);
        self.MSoftwareVersion1.frame =       CGRectMake(35, 155 -10, 190, 100);
        self.MBuildData1.frame =             CGRectMake(35, 205 -10, 190, 100);
        
        self.MSerialNum1.frame =             CGRectMake(35, 255 -10, 190, 100);
        self.MWANMACAddress1.frame =         CGRectMake(35, 305 -10, 190, 100);
        self.MLANMACAddress1.frame =         CGRectMake(35, 355 -10, 190, 100);
        self.MWIFIMACAddress1.frame =        CGRectMake(35, 405 -10, 190, 100);
        self.MSubnetMask1.frame =            CGRectMake(35, 455 -10, 190, 100);
        self.MIPAddress1.frame =             CGRectMake(35, 505 -10, 190, 100);
        
        self.ManufacturerIdLab1.font = FONT(16);
        self.MHardVersion1.font = FONT(16);
        self.MSoftwareVersion1.font = FONT(16);
        self.MBuildData1.font = FONT(16);
        self.MSerialNum1.font = FONT(16);
        self.MWANMACAddress1.font = FONT(16);
        self.MLANMACAddress1.font = FONT(16);
        self.MWIFIMACAddress1.font = FONT(16);
        self.MSubnetMask1.font = FONT(16);
        self.MIPAddress1.font = FONT(16);
        
        
        
        [self.scrollView addSubview: self.ManufacturerIdLab1];
        [self.scrollView addSubview: self.MHardVersion1];
        [self.scrollView addSubview: self.MSoftwareVersion1];
        [self.scrollView addSubview: self.MBuildData1];;
        [self.scrollView addSubview: self.MSerialNum1];
        [self.scrollView addSubview: self.MWANMACAddress1];
        [self.scrollView addSubview: self.MLANMACAddress1];
        [self.scrollView addSubview: self.MWIFIMACAddress1];
        [self.scrollView addSubview: self.MSubnetMask1];
        [self.scrollView addSubview: self.MIPAddress1];;
        
        
        //右侧数据
        ManufacturerId1.frame =          CGRectMake(160, 55 -10, 230, 100);
        HardwareVersionLab1.frame =      CGRectMake(160, 105 -10, 230, 100);
        SortwareVersionLab1.frame =      CGRectMake(160, 155 -10, 230, 100);
        BuildDataLab1.frame =            CGRectMake(160, 205 -10, 230, 100);
        SerialNumberLab1.frame =         CGRectMake(160, 255 -10, 230, 100);
        WANMacAddressLab1.frame =        CGRectMake(160, 305 -10, 230, 100);
        LAMacAddressLab1.frame =         CGRectMake(160, 355 -10, 230, 100);
        WIFIMacAddressLab1.frame =       CGRectMake(160, 405 -10, 230, 100);
        SubnetMaskLab1.frame =           CGRectMake(160, 455 -10, 230, 100);
        IPAddressLab1.frame =            CGRectMake(160, 505 -10, 230, 100);
        
        ManufacturerId1.textAlignment = NSTextAlignmentRight;
        HardwareVersionLab1.textAlignment = NSTextAlignmentRight;
        SortwareVersionLab1.textAlignment = NSTextAlignmentRight;
        BuildDataLab1.textAlignment = NSTextAlignmentRight;
        SerialNumberLab1.textAlignment = NSTextAlignmentRight;
        WANMacAddressLab1.textAlignment = NSTextAlignmentRight;
        LAMacAddressLab1.textAlignment = NSTextAlignmentRight;
        WIFIMacAddressLab1.textAlignment = NSTextAlignmentRight;
        SubnetMaskLab1.textAlignment = NSTextAlignmentRight;
        IPAddressLab1.textAlignment = NSTextAlignmentRight;
        
        
        
        self.ManufacturerId1.font = FONT(16);
        self.HardwareVersionLab1.font = FONT(16);
        self.SortwareVersionLab1.font = FONT(16);
        self.BuildDataLab1.font = FONT(16);
        self.SerialNumberLab1.font = FONT(16);
        self.WANMacAddressLab1.font = FONT(16);
        self.LAMacAddressLab1.font = FONT(16);
        self.WIFIMacAddressLab1.font = FONT(16);
        self.SubnetMaskLab1.font = FONT(16);
        self.IPAddressLab1.font = FONT(16);
        
        
        
        
        
        
        
        
        
    }
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.delegate=self;
    self.scrollView.bounces=NO;
    
    [self.view addSubview:_scrollView];
    //    [self loadLinkB，tn];
    
    
    [self.scrollView addSubview: ManufacturerId1];
    [self.scrollView addSubview: HardwareVersionLab1];
    [self.scrollView addSubview: SortwareVersionLab1];
    [self.scrollView addSubview: BuildDataLab1];
    [self.scrollView addSubview: SerialNumberLab1];
    [self.scrollView addSubview: WANMacAddressLab1];
    [self.scrollView addSubview: LAMacAddressLab1];
    [self.scrollView addSubview: WIFIMacAddressLab1];
    [self.scrollView addSubview: SubnetMaskLab1];
    [self.scrollView addSubview: IPAddressLab1];
    
    
    
}
-(void)loadNav
{
    NSString * RouterStatusLabel = NSLocalizedString(@"RouterStatusLabel", nil);
    self.title = RouterStatusLabel;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    DMSIP = [USER_DEFAULT objectForKey:@"RouterPsw"];
    if (DMSIP != nil && DMSIP != NULL && DMSIP.length > 0) {
        //        [self getOnlineDevice];
        [self getID];  //new
        [self getVersionInfo];
        [self getNetworkInfo];
        [self getWifi];
        
    }
    
}
-(void)getID
{
    
    //获取数据的链接
    NSString * url =     [NSString stringWithFormat:@"http://%@/lua/settings/systemRouterInfo",DMSIP];
    
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
            
            
            NSString * MLNetworkError = NSLocalizedString(@"MLNetworkError", nil);
            CGSize size = [GGUtil sizeWithText:MLNetworkError font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            UILabel * hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
            hudLab.text = MLNetworkError;
            hudLab.font = FONT(15);
            hudLab.textColor = [UIColor grayColor];
            
            //        [scrollView addSubview:netWorkErrorView];
            //            [scrollView addSubview:netWorkErrorView];
            [self.scrollView addSubview:netWorkErrorView];
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
            
            //88888
            //            self.ManufacturerId.text = [deviceDic objectForKey:@"oui_group"];
            ManufacturerId1.text = [deviceDic objectForKey:@"oui_group"];
            
        }
    }];
    
    
    
    
    
    
    
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
        [self.scrollView addSubview:HUD];
        
        
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
            
            
            NSString * MLNetworkError = NSLocalizedString(@"MLNetworkError", nil);
            CGSize size = [GGUtil sizeWithText:MLNetworkError font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            UILabel * hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
            hudLab.text = MLNetworkError;
            hudLab.font = FONT(15);
            hudLab.textColor = [UIColor grayColor];
            
            //        [scrollView addSubview:netWorkErrorView];
            //            [scrollView addSubview:netWorkErrorView];
            [self.scrollView addSubview:netWorkErrorView];
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
        
            HardwareVersionLab1.text = [deviceDic objectForKey:@"hardVersion"];
            BuildDataLab1.text = [deviceDic objectForKey:@"releaseVersion"];
            SortwareVersionLab1.text = [deviceDic objectForKey:@"softVersion"];
            SerialNumberLab1.text = [deviceDic objectForKey:@"SNnum"];
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
 
    
    [request setCompletionBlock:^{
        
        NSArray *onlineDeviceDic = [request responseData].JSONValue;
        deviceDic2 = onlineDeviceDic;
        NSLog(@"deviceDic :%@",deviceDic2);
        if (deviceDic2.count == 0|| deviceDic2 ==NULL ) {
            
         
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
         
            ////5555---8
            WANMacAddressLab1.text = [deviceDic2 objectForKey:@"wan_mac"] ;   //[deviceDic2 objectForKey:@"mac"] ;
            LAMacAddressLab1.text = [deviceDic2 objectForKey:@"lan_mac"] ;   //[deviceDic2 objectForKey:@"mac"] ;
            WIFIMacAddressLab1.text = [deviceDic2 objectForKey:@"wifi_mac"] ;   //[deviceDic2 objectForKey:@"mac"] ;
            SubnetMaskLab1.text = [deviceDic2 objectForKey:@"netmask"];
            IPAddressLab1.text = [deviceDic2 objectForKey:@"gateway"] ;
            
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 加载无网络图
-(void)showNetWorkErrorView
{
    NSLog(@"showNetWorkErroshowNetWorkErrorVasdadsads");
   
    
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
    NSString * MLNetworkError = NSLocalizedString(@"MLNetworkError", nil);
    self.NetWorkErrorLab.text = MLNetworkError;
    self.NetWorkErrorLab.font = FONT(15);
    
    
    
    [self.scrollView addSubview:self.NetWorkErrorView];
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
