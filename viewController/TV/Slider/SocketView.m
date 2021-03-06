//
//  SocketView.m
//  StarAPP
//
//  Created by xyz on 16/9/19.
//
//

#import "SocketView.h"
#import "Singleton.h"
#import <objc/runtime.h>
#import "SocketUtils.h"
#import "sys/utsname.h"
#import "TVViewController.h"

//获取IP
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
// 后面NSString这是运行时能获取到的C语言的类型
NSString * const TYPE_UINT8   = @"TC";// char是1个字节，8位
NSString * const TYPE_UINT16   = @"TS";// short是2个字节，16位
NSString * const TYPE_UINT32   = @"TI";
NSString * const TYPE_UINT64   = @"TQ";
NSString * const TYPE_STRING   = @"T@\"NSString\"";
NSString * const TYPE_ARRAY   = @"T@\"NSArray\"";

@interface SocketView ()

@property (nonatomic,strong)id object;
@property (nonatomic, strong) NSMutableData *beattag;
//beat除了CRC和tag的值
@property (nonatomic, strong) NSMutableData *data_beat;
//beat的所有数据
@property (nonatomic, strong) NSMutableData *beatAllData;
@end

@implementation SocketView
@synthesize  cs_heatbeat;           //1
@synthesize  cs_service;            //2
@synthesize  cs_playExit;           //3
@synthesize  cs_passwordCheck;     //4
@synthesize  cs_updateChannel;      //5
@synthesize  cs_CAMatureLock;       //6
@synthesize  cs_getResource;        //7
@synthesize  cs_getRouteIPAddress;  //8
@synthesize  cs_GetPushDeviceInfo;  //9
@synthesize  cs_MDPushService;       //10
@synthesize  cs_MDPushFile;          //11
@synthesize  socket_ServiceModel;  //给service传值用
@synthesize  cs_serviceREC;
@synthesize  mdPhonePushService;
@synthesize  otherDevicePushService;
@synthesize  otherDevicePushLive;
@synthesize  filePushService;
@synthesize  sc_MDOtherPushService;
@synthesize  sc_MDOtherPushLive;
@synthesize  sc_MDGetCardType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化
    _data = [[NSMutableData alloc]init];
    cs_heatbeat = [[Cs_Hearbeat alloc]init];
    cs_service = [[Cs_Service alloc]init];
    cs_playExit = [[Cs_PlayExit alloc]init];
    cs_passwordCheck = [[Cs_PasswordCheck alloc]init];
    cs_updateChannel = [[Cs_UpdateChannel alloc]init];
    cs_CAMatureLock = [[Cs_CAMatureLock alloc]init];
    cs_getResource = [[Cs_GetResource alloc]init];
    cs_getRouteIPAddress = [[Cs_GetRouteIPAddress alloc]init];
    cs_serviceREC = [[Cs_serviceREC alloc]init];
    cs_GetPushDeviceInfo = [[Cs_GetPushDeviceInfo alloc]init];
    cs_MDPushService = [[Cs_MDPushService alloc]init];
    cs_MDPushFile = [[Cs_MDPushFile alloc]init];
    
    sc_MDOtherPushService = [[Sc_MDOtherPushService alloc]init];
    sc_MDOtherPushLive = [[Sc_MDOtherPushLive alloc]init];
    sc_MDGetCardType = [[Sc_MDGetCardType alloc]init];
    
    _socket=[[AsyncSocket alloc] initWithDelegate:self];
    otherDevicePushService = [[OtherDevicePushService alloc]init];
    otherDevicePushLive = [[OtherDevicePushLive alloc]init];
    NSLog(@"socket.port:%d",[_socket localPort]);
    
    NSError *error;
    int port = 6666;
    // 绑定端口，监听连接消息
    BOOL result = [_socket acceptOnPort:port error:&error];
    
    
    [self heartBeat];
    
    NSString * DMSIP = [USER_DEFAULT objectForKey:@"HMC_DMSIP"];
    //连接
    //    [Singleton sharedInstance].socketHost = @"192.168.1.183"; //host设定
    [Singleton sharedInstance].socketHost =DMSIP; //host设定
    NSLog(@"DMSIP:==--==%@",DMSIP);
    NSLog(@"DMSIP:3333");
    [Singleton sharedInstance].socketPort = 3000; //port设定
    NSLog(@"socket连接了一次 fack");
    //     在连接前先进行手动断开
    [Singleton sharedInstance].socket.userData = SocketOfflineByUser;
    [[Singleton sharedInstance] cutOffSocket];
    
    //     确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
    [Singleton sharedInstance].socket.userData = SocketOfflineByServer;
    [[Singleton sharedInstance] socketConnectHost];
    
    
    
    
}

-(void)heartBeat
{
    
    //1.tag转data
    NSString * package_Betatag = @"DIGW";
    self.beattag = [[NSMutableData alloc]init];
    self.beattag = (NSMutableData *)[package_Betatag dataUsingEncoding:NSUTF8StringEncoding];
    
    
    cs_heatbeat.module_name= @"BEAT";
    cs_heatbeat.Ret=0;
    cs_heatbeat.Reserved=APDE_Identify;
    //    cs_heatbeat.client_ip= [self getIPArr];
    
    do {
        NSLog(@"IP为空，此处获取一个IP地址");
        cs_heatbeat.client_ip= [self getIPArr];
    } while (ISNULL(cs_heatbeat.client_ip));
    
    cs_heatbeat. data_len= 0;
    
    //2.计算除了CRC和tag之外的值
    self.data_beat = [[NSMutableData alloc]init];
    self.data_beat = [self RequestSpliceAttribute:cs_heatbeat];
    //CRC是除了tag和service
    
    //3.计算CRC
    //4.重置data_service，将tag,CRC,和其他数据加起来
    self.beatAllData = [[NSMutableData alloc]init];
    [self.beatAllData appendData:self.beattag];
    [self.beatAllData appendData:[self dataTOCRCdata:self.data_beat ]];
    [self.beatAllData appendData:self.data_beat];
    
    
    //转换成字节后，存起来
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    [userDef setObject:self.beatAllData forKey:@"beatAllData"];
    
    //    [userDef synchronize];//把数据同步到本地
    
    NSLog(@"self.beatAllData  %@",self.beatAllData);
    
    
    
}
-(void)serviceTouch{
    
    NSLog(@"dispatch_get_global_queue socket==开始拼接");
    cs_service.module_name= @"MDMM";
    cs_service.Ret=0;
    cs_service.Reserved=APDE_Identify;
    //    cs_service.client_ip= [self getIPArr];
    
    NSLog(@"dispatch_get_global_queue socket==开始拼接000");
    do {
        NSLog(@"IP为空，此处获取一个IP地址");
        cs_service.client_ip= [self getIPArr];
        
    } while (ISNULL(cs_service.client_ip));
    NSLog(@"dispatch_get_global_queue socket==开始拼接111");
    
    cs_service.client_port = (uint32_t)[_socket localPort] ;
    
    //    cs_service.unique_id = [SocketView GetNowTimes];
    //获取的时间戳string转int
    
    //    int x = [[SocketView GetNowTimes] intValue];
    //
    //    int tmp2 = CFSwapInt32BigToHost(x);
    //    NSMutableData* data_CRC2 = (NSMutableData *)[NSData dataWithBytes:&tmp2 length:sizeof(tmp2)];
    
    //    NSLog(@"数%@",[SocketView GetNowTimes]);
    //    int x = 1475026288;
    //    int x = 222;
    //    [self hexFromInt:x];
    cs_service.unique_id = [SocketUtils uint32FromBytes:[SocketView GetNowTimes]];
    //    cs_service.unique_id = [SocketUtils uint32FromBytes:[SocketUtils dataFromHexString:[self hexFromInt:x]]];
    cs_service.command_type =DTV_SERVICE_MD_PLAY_SERVICE;// CMD_PLAY_SERVICE;
    //---
    
    cs_service.tuner_type = [socket_ServiceModel.service_tuner_mode intValue];
    cs_service.network_id = [socket_ServiceModel.service_network_id intValue];
    cs_service.ts_id = [socket_ServiceModel.service_ts_id intValue];
    cs_service.service_id = [socket_ServiceModel.service_service_id intValue];
    cs_service.audio_index = [socket_ServiceModel.audio_pid intValue];
    cs_service.subt_index = [socket_ServiceModel.subt_pid intValue];
    NSLog(@"dispatch_get_global_queue socket==开始拼接222");
    NSLog(@"cs_service.audio_index %d",cs_service.audio_index);
    NSLog(@"cs_service.subt_index %d",cs_service.subt_index);
    [USER_DEFAULT setObject:socket_ServiceModel.audio_pid forKey:@"nowPlayChannelAudioIndex"];
    [USER_DEFAULT setObject:socket_ServiceModel.subt_pid forKey:@"nowPlayChannelSubtIndex"];
    
    //---
    
    //   NSString * phoneModel = @"iPhone6s";
    NSString * phoneModel =  [self deviceVersion];
    NSLog(@"手机型号:%@",phoneModel);
    //手机别名： 用户定义的名称
    //    NSString* userPhoneName = [[UIDevice currentDevice] name];
    //    NSString* userPhoneName = @"xyz的MacBook pro";
    //    NSLog(@"手机别名: %@", userPhoneName);
    //    NSString * de = @"的";
    //    NSLog(@"de.length:%d",de.length);
    
    cs_service.client_name = [NSString stringWithFormat:@"%@",phoneModel];  //***
    cs_service.data_len_name =cs_service.client_name.length   ;    //****
    cs_service. data_len= cs_service.client_name.length+25;
    cs_service.data_len_m3u8 = 0;
    //除了CRC和tag其他数据
    NSMutableData * data_service ;
    data_service = [[NSMutableData alloc]init];
    NSLog(@"dispatch_get_global_queue socket==开始拼接333");
    //计算CRC
    NSMutableData * serviceCRCData;
    serviceCRCData = [[NSMutableData alloc]init];
    
    //1.tag转data
    
    //2.除了CRC和tag之外的转data
    data_service = [self RequestSpliceAttribute:cs_service];
    NSLog(@"dispatch_get_global_queue socket==开始拼接444");
    [serviceCRCData appendData:data_service];   //CRC是除了tag和service
    
    NSLog(@"计算CRC：%@",serviceCRCData);
    
    //4.重置data_service，将tag,CRC,和其他数据加起来
    data_service = [[NSMutableData alloc]init];
    [data_service appendData:[self getPackageTagData]];
    //3.计算CRC
    [data_service appendData:[self dataTOCRCdata:serviceCRCData]];
    [data_service appendData:[self RequestSpliceAttribute:cs_service]];
    NSLog(@"finaldata: %@",data_service);
    NSLog(@"finaldata.length: %d",data_service.length);
    NSLog(@"dispatch_get_global_queue socket==开始拼接555");
    //转换成字节后，存起来
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    [userDef setObject:data_service forKey:@"data_service"];
    NSLog(@"dispatch_get_global_queue socket==开始拼接66666666");
    //    [userDef synchronize];//把数据同步到本地
    
    NSLog(@"dispatch_get_global_queue socket==拼接完全0000");
    [[Singleton sharedInstance] Play_ServiceSocket];
    NSLog(@"dispatch_get_global_queue socket==拼接完全");
    
}

//点击准备播放录制文件
-(void)serviceRECTouch{
    
    
    cs_serviceREC.module_name= @"MDMM";
    cs_serviceREC.Ret=0;
    cs_serviceREC.Reserved=APDE_Identify;  //后期做过修改的东西，让机顶盒做区分用的
    do {
        NSLog(@"IP为空，此处获取一个IP地址");
        cs_serviceREC.client_ip= [self getIPArr];
    } while (ISNULL(cs_serviceREC.client_ip));
    
    
    cs_serviceREC.client_port = (uint32_t)[_socket localPort] ;
    
    cs_serviceREC.unique_id = [SocketUtils uint32FromBytes:[SocketView GetNowTimes]];
    cs_serviceREC.command_type =DTV_SERVICE_MD_PLAY_FILE;// 25 ;
    
    NSString * phoneModel =  [self deviceVersion];
    NSLog(@"手机型号:%@",phoneModel);
    
    cs_serviceREC.client_name = [NSString stringWithFormat:@"%@",phoneModel];  //***
    cs_serviceREC.client_name_len =cs_serviceREC.client_name.length   ;    //****
    
    NSLog(@"foleName %@",cs_serviceREC.file_name);
    NSLog(@"foleName %d",cs_serviceREC.file_name_len);
    cs_serviceREC. data_len= 11 + cs_serviceREC.file_name_len + cs_serviceREC.client_name_len ;
    //    cs_serviceREC.data_len_m3u8 = 0;
    //除了CRC和tag其他数据
    NSMutableData * data_service ;
    data_service = [[NSMutableData alloc]init];
    
    //计算CRC
    NSMutableData * serviceCRCData = [[NSMutableData alloc]init];
    
    //1.tag转data
    
    //2.除了CRC和tag之外的转data
    data_service = [self RequestSpliceAttribute:cs_serviceREC];
    
    [serviceCRCData appendData:data_service];   //CRC是除了tag和service
    
    NSLog(@"计算CRC：%@",serviceCRCData);
    
    //4.重置data_service，将tag,CRC,和其他数据加起来
    data_service = [[NSMutableData alloc]init];
    [data_service appendData:[self getPackageTagData]];
    //3.计算CRC
    [data_service appendData:[self dataTOCRCdata:serviceCRCData]];
    [data_service appendData:[self RequestSpliceAttribute:cs_serviceREC]];
    
    NSLog(@"foleName=-= %@",cs_serviceREC.file_name);
    NSLog(@"foleName=-= %d",cs_serviceREC.file_name_len);
    //转换成字节后，存起来
    [USER_DEFAULT setObject:data_service forKey:@"data_serviceREC"];
    NSLog(@"data_service=-= %@",data_service);
    //    [USER_DEFAULT synchronize];//把数据同步到本地
    
    
    [[Singleton sharedInstance] Play_ServiceRECSocket];
    
}


//初始状态判断卡级别
-(void)judgeCardType{
    
    
    sc_MDGetCardType.module_name= @"MDMM";
    sc_MDGetCardType.Ret=0;
    sc_MDGetCardType.Reserved=APDE_Identify;  //后期做过修改的东西，让机顶盒做区分用的
    do {
        NSLog(@"IP为空，此处获取一个IP地址");
        sc_MDGetCardType.client_ip= [self getIPArr];
    } while (ISNULL(cs_serviceREC.client_ip));
    
    
    sc_MDGetCardType.client_port = (uint32_t)[_socket localPort] ;
    
    sc_MDGetCardType.unique_id = [SocketUtils uint32FromBytes:[SocketView GetNowTimes]];
    sc_MDGetCardType.command_type =DTV_SERVICE_MD_GET_CARD_RAT;// 35 ;
    
    NSString * phoneModel =  [self deviceVersion];
    NSLog(@"手机型号:%@",phoneModel);
    
    
    NSString * Card_type = @"0";
    
    sc_MDGetCardType.card_type = (uint8_t)Card_type;
    sc_MDGetCardType. data_len= 10 ;
    //    cs_serviceREC.data_len_m3u8 = 0;
    //除了CRC和tag其他数据
    NSMutableData * data_service ;
    data_service = [[NSMutableData alloc]init];
    
    //计算CRC
    NSMutableData * serviceCRCData = [[NSMutableData alloc]init];
    
    //1.tag转data
    
    //2.除了CRC和tag之外的转data
    data_service = [self RequestSpliceAttribute:sc_MDGetCardType];
    
    [serviceCRCData appendData:data_service];   //CRC是除了tag和service
    
    NSLog(@"计算CRC：%@",serviceCRCData);
    
    //4.重置data_service，将tag,CRC,和其他数据加起来
    data_service = [[NSMutableData alloc]init];
    [data_service appendData:[self getPackageTagData]];
    //3.计算CRC
    [data_service appendData:[self dataTOCRCdata:serviceCRCData]];
    [data_service appendData:[self RequestSpliceAttribute:sc_MDGetCardType]];
    
    
    //转换成字节后，存起来
    [USER_DEFAULT setObject:data_service forKey:@"data_CardType"];
    //    [USER_DEFAULT synchronize];//把数据同步到本地
    
    
    [[Singleton sharedInstance] Play_ServiceGetCardType];
    
}


//退出视频分发

-(void)deliveryPlayExit{
    
    cs_playExit.module_name= @"MDMM";
    cs_playExit.Ret=0;
    cs_playExit.Reserved=APDE_Identify;
    //    cs_playExit.client_ip= [self getIPArr];
    do {
        NSLog(@"IP为空，此处获取一个IP地址");
        cs_playExit.client_ip= [self getIPArr];
    } while (ISNULL(cs_playExit.client_ip));
    
    cs_playExit.client_port = (uint32_t)[_socket localPort] ;
    cs_playExit.unique_id = [SocketUtils uint32FromBytes:[SocketView GetNowTimes]];
    cs_playExit.command_type = DTV_SERVICE_MD_PLAY_EXIT;  //CMD_EXIT_PLAY;
    
    cs_playExit. data_len= 9;
    
    //除了CRC和tag其他数据
    NSMutableData * data_service ;
    data_service = [[NSMutableData alloc]init];
    
    //计算CRC
    NSMutableData * serviceCRCData;
    serviceCRCData = [[NSMutableData alloc]init];
    
    //1.tag转data
    
    //2.除了CRC和tag之外的转data
    data_service = [self RequestSpliceAttribute:cs_playExit];
    
    [serviceCRCData appendData:data_service];   //CRC是除了tag和service
    
    NSLog(@"计算CRC：%@",serviceCRCData);
    
    //4.重置data_service，将tag,CRC,和其他数据加起来
    data_service = [[NSMutableData alloc]init];
    [data_service appendData:[self getPackageTagData]];
    //3.计算CRC
    [data_service appendData:[self dataTOCRCdata:serviceCRCData]];
    [data_service appendData:[self RequestSpliceAttribute:cs_playExit]];
    NSLog(@"finaldata: %@",data_service);
    NSLog(@"finaldata.length: %d",data_service.length);
    
    //转换成字节后，存起来
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    [userDef setObject:data_service forKey:@"data_playExit"];
    
    //    [userDef synchronize];//把数据同步到本地
    
    
    [[Singleton sharedInstance] Play_ExitSocket];
    
}
//密码校验
-(void)passwordCheck :(NSString *)passWordStr  passwordType:(int)passwd_type_int
{
    
    cs_passwordCheck.module_name= @"MDMM";
    cs_passwordCheck.Ret=0;
    cs_passwordCheck.Reserved=APDE_Identify;
    //    cs_passwordCheck.client_ip= [self getIPArr];
    do {
        NSLog(@"IP为空，此处获取一个IP地址");
        cs_passwordCheck.client_ip= [self getIPArr];
    } while (ISNULL(cs_passwordCheck.client_ip));
    
    cs_passwordCheck.client_port = (uint32_t)[_socket localPort] ;
    
    cs_passwordCheck.unique_id = [SocketUtils uint32FromBytes:[SocketView GetNowTimes]];
    cs_passwordCheck.command_type = DTV_SERVICE_MD_PASSWD_CHECK;  // CMD_VERIFY_PASSWORD;
    
    int arcx = 2+arc4random() % 1000;  //获取一个2到1000的随机整数
    cs_passwordCheck.passwd_id = arcx;//1;
    
    cs_passwordCheck.passwd_type = passwd_type_int;//1;
    
    if(cs_passwordCheck.passwd_type == 1){
        cs_passwordCheck.passwd_string = passWordStr;//@"000000";
        cs_passwordCheck. data_len= 20;
    }else if(cs_passwordCheck.passwd_type == 0){
        cs_passwordCheck.passwd_string =passWordStr;//@"123a";
        cs_passwordCheck. data_len= 18;
    }
    
    //除了CRC和tag其他数据
    NSMutableData * data_service ;
    data_service = [[NSMutableData alloc]init];
    
    //计算CRC
    NSMutableData * serviceCRCData;
    serviceCRCData = [[NSMutableData alloc]init];
    
    //1.tag转data
    
    //2.除了CRC和tag之外的转data
    data_service = [self RequestSpliceAttribute:cs_passwordCheck];
    
    [serviceCRCData appendData:data_service];   //CRC是除了tag和service
    
    NSLog(@"计算CRC：%@",serviceCRCData);
    
    //4.重置data_service，将tag,CRC,和其他数据加起来
    data_service = [[NSMutableData alloc]init];
    [data_service appendData:[self getPackageTagData]];
    //3.计算CRC
    [data_service appendData:[self dataTOCRCdata:serviceCRCData]];
    [data_service appendData:[self RequestSpliceAttribute:cs_passwordCheck]];
    NSLog(@"finaldata: %@",data_service);
    NSLog(@"finaldata.length: %d",data_service.length);
    
    //转换成字节后，存起来
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    [userDef setObject:data_service forKey:@"data_passwordCheck"];
    
    //    [userDef synchronize];//把数据同步到本地
    
    
    [[Singleton sharedInstance] passwordCheck];
}

//获取资源信息
-(void)csGetResource
{
    
    cs_getResource.module_name= @"MDMM";
    cs_getResource.Ret=0;
    cs_getResource.Reserved=APDE_Identify;
    
    //do - while 循环
    
    //    cs_getResource.client_ip= [self getIPArr];
    
    do {
        NSLog(@"IP为空，此处获取一个IP地址");
        cs_getResource.client_ip= [self getIPArr];
    } while (ISNULL(cs_getResource.client_ip));
    
    
    
    cs_getResource.client_port = (uint32_t)[_socket localPort] ;
    
    cs_getResource.unique_id = [SocketUtils uint32FromBytes:[SocketView GetNowTimes]];
    cs_getResource.command_type = DTV_SERVICE_MD_GET_RESOURCE ; //CMD_GET_RESOURCE_INFO;
    cs_getResource. data_len= 9;
    
    
    
    //除了CRC和tag其他数据
    NSMutableData * data_service ;
    data_service = [[NSMutableData alloc]init];
    
    //计算CRC
    NSMutableData * serviceCRCData;
    serviceCRCData = [[NSMutableData alloc]init];
    
    //1.tag转data
    
    //2.除了CRC和tag之外的转data
    data_service = [self RequestSpliceAttribute:cs_getResource];
    
    [serviceCRCData appendData:data_service];   //CRC是除了tag和service
    
    NSLog(@"计算CRC：%@",serviceCRCData);
    
    //4.重置data_service，将tag,CRC,和其他数据加起来
    data_service = [[NSMutableData alloc]init];
    [data_service appendData:[self getPackageTagData]];
    //3.计算CRC
    [data_service appendData:[self dataTOCRCdata:serviceCRCData]];
    [data_service appendData:[self RequestSpliceAttribute:cs_getResource]];
    NSLog(@"finaldata: %@",data_service);
    NSLog(@"finaldata.length: %d",data_service.length);
    
    //转换成字节后，存起来
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    [userDef setObject:data_service forKey:@"data_getResource"];
    
    //    [userDef synchronize];//把数据同步到本地
    
    
    [[Singleton sharedInstance] GetResource_socket];
}

#pragma mark - 获取路由器IP地址
//获取资源信息
-(void)csGetRouteIPAddress
{
    
    cs_getRouteIPAddress.module_name= @"MDMM";
    cs_getRouteIPAddress.Ret=0;
    cs_getRouteIPAddress.Reserved=APDE_Identify;
    
    //do - while 循环
    
    //    cs_getRouteIPAddress.client_ip= [self getIPArr];
    
    do {
        NSLog(@"IP为空，此处获取一个IP地址");
        cs_getRouteIPAddress.client_ip= [self getIPArr];
    } while (ISNULL(cs_getRouteIPAddress.client_ip));
    
    
    
    cs_getRouteIPAddress.client_port = (uint32_t)[_socket localPort] ;
    
    cs_getRouteIPAddress.unique_id = [SocketUtils uint32FromBytes:[SocketView GetNowTimes]];
    cs_getRouteIPAddress.command_type = DTV_SERVICE_MD_GET_ROUTE_IP ;  //获取IP地址 24
    cs_getRouteIPAddress. data_len= 9;
    
    
    
    //除了CRC和tag其他数据
    NSMutableData * data_service ;
    data_service = [[NSMutableData alloc]init];
    
    //计算CRC
    NSMutableData * serviceCRCData;
    serviceCRCData = [[NSMutableData alloc]init];
    
    //1.tag转data
    
    //2.除了CRC和tag之外的转data
    data_service = [self RequestSpliceAttribute:cs_getRouteIPAddress];
    
    [serviceCRCData appendData:data_service];   //CRC是除了tag和service
    
    NSLog(@"计算CRC：%@",serviceCRCData);
    
    //4.重置data_service，将tag,CRC,和其他数据加起来
    data_service = [[NSMutableData alloc]init];
    [data_service appendData:[self getPackageTagData]];
    //3.计算CRC
    [data_service appendData:[self dataTOCRCdata:serviceCRCData]];
    [data_service appendData:[self RequestSpliceAttribute:cs_getRouteIPAddress]];
    NSLog(@"finaldata: %@",data_service);
    NSLog(@"finaldata.length: %d",data_service.length);
    
    //转换成字节后，存起来
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    [userDef setObject:data_service forKey:@"data_getIPAddress"];
    
    //    [userDef synchronize];//把数据同步到本地
    
    
    [[Singleton sharedInstance] GetIPAddress_socket];
}

//获取投屏节目信息
-(void)csGetPushInfo
{
    NSLog(@"发送投屏信息");
    
    cs_GetPushDeviceInfo.module_name= @"MDMM";
    cs_GetPushDeviceInfo.Ret=0;
    cs_GetPushDeviceInfo.Reserved=APDE_Identify;
    
    //do - while 循环
    
    //    cs_getResource.client_ip= [self getIPArr];
    
    do {
        NSLog(@"IP为空，此处获取一个IP地址");
        cs_GetPushDeviceInfo.client_ip= [self getIPArr];
    } while (ISNULL(cs_GetPushDeviceInfo.client_ip));
    
    
    
    cs_GetPushDeviceInfo.client_port = (uint32_t)[_socket localPort] ;
    
    cs_GetPushDeviceInfo.unique_id = [SocketUtils uint32FromBytes:[SocketView GetNowTimes]];
    cs_GetPushDeviceInfo.command_type = DTV_SERVICE_MD_GET_PLAY_DEVICE ;
    cs_GetPushDeviceInfo. data_len= cs_GetPushDeviceInfo.device_client_name.length+15;;
    
    
    
    //除了CRC和tag其他数据
    NSMutableData * data_service ;
    data_service = [[NSMutableData alloc]init];
    
    //计算CRC
    NSMutableData * serviceCRCData;
    serviceCRCData = [[NSMutableData alloc]init];
    
    //1.tag转data
    
    //2.除了CRC和tag之外的转data
    data_service = [self RequestSpliceAttribute:cs_GetPushDeviceInfo];
    
    [serviceCRCData appendData:data_service];   //CRC是除了tag和service
    
    NSLog(@"计算CRC：%@",serviceCRCData);
    
    //4.重置data_service，将tag,CRC,和其他数据加起来
    data_service = [[NSMutableData alloc]init];
    [data_service appendData:[self getPackageTagData]];
    //3.计算CRC
    [data_service appendData:[self dataTOCRCdata:serviceCRCData]];
    [data_service appendData:[self RequestSpliceAttribute:cs_GetPushDeviceInfo]];
    NSLog(@"finaldata: %@",data_service);
    NSLog(@"finaldata.length: %d",data_service.length);
    
    //转换成字节后，存起来
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    [userDef setObject:data_service forKey:@"data_cs_GetPushDeviceInfo"];
    
    //    [userDef synchronize];//把数据同步到本地
    
    
    [[Singleton sharedInstance] GetPushDeviceInfo_socket];
}

//手机投机顶盒直播
-(void)SetCSMDPushService
{
    NSLog(@"发送投屏信息");
    
    cs_MDPushService.module_name= @"MDMM";
    cs_MDPushService.Ret=0;
    cs_MDPushService.Reserved=APDE_Identify;
    
    
    do {
        NSLog(@"IP为空，此处获取一个IP地址");
        cs_MDPushService.client_ip= [self getIPArr];
    } while (ISNULL(cs_MDPushService.client_ip));
    
    
    
    cs_MDPushService.client_port = (uint32_t)[_socket localPort] ;
    
    cs_MDPushService.unique_id = [SocketUtils uint32FromBytes:[SocketView GetNowTimes]];
    cs_MDPushService.command_type = DTV_SERVICE_MD_PUSH_SERVICE ;
    
    cs_MDPushService.tuner_type = [mdPhonePushService.service_tuner_type intValue];
    NSLog(@"cs_MDPushService.tuner_type %d",cs_MDPushService.tuner_type);
    cs_MDPushService.network_id = [mdPhonePushService.service_network_id intValue];
    NSLog(@"cs_MDPushService.network_id %d",cs_MDPushService.network_id);
    cs_MDPushService.ts_id = [mdPhonePushService.service_ts_id intValue];
    NSLog(@"cs_MDPushService.ts_id %d",cs_MDPushService.ts_id);
    cs_MDPushService.service_id = [mdPhonePushService.service_service_id intValue];
    NSLog(@"cs_MDPushService.service_id %d",cs_MDPushService.service_id);
    cs_MDPushService.audio_pid =  cs_service.audio_index;
    NSLog(@"cs_MDPushService.audio_pid %d",cs_MDPushService.audio_pid);
    cs_MDPushService.subt_pid = cs_service.subt_index; //[mdPhonePushService.subt_pid intValue];
    cs_MDPushService.client_name_len = mdPhonePushService.client_name_len;;
    cs_MDPushService.client_name = mdPhonePushService.client_name;
    
    NSLog(@" cs_MDPushFile.client_name-直播 %@",cs_MDPushService.client_name);
    cs_MDPushService.push_type = mdPhonePushService.push_type;
    cs_MDPushService.client_count = mdPhonePushService.client_count;
    NSLog(@"cs_MDPushService.client_count %d",cs_MDPushService.client_count);
    
    int dataLen = 26 + cs_MDPushService.client_name_len + cs_MDPushService.client_count*4 ;
    cs_MDPushService.data_len = dataLen;
    
    NSLog(@"cs_MDPushService.client_name_len %d",cs_MDPushService.client_name_len);
    NSLog(@"cs_MDPushService.client_count %d",cs_MDPushService.client_count);
    NSLog(@"cs_MDPushService.data_len %d",cs_MDPushService.data_len);
    
    
    
    
    //除了CRC和tag其他数据
    NSMutableData * data_service ;
    data_service = [[NSMutableData alloc]init];
    
    //计算CRC
    NSMutableData * serviceCRCData;
    serviceCRCData = [[NSMutableData alloc]init];
    
    //1.tag转data
    //2.除了CRC和tag之外的转data
    data_service = [self RequestSpliceAttribute:cs_MDPushService];
    NSLog(@"cs_MDPushServiceaa== %@",cs_MDPushService);
    NSLog(@"data_serviceaa== %@",data_service);
    //    NSLog(@"mdPhonePushService== %@",mdPhonePushService.push_client_ip);
    NSLog(@"mdPhonePushService.push_client_ip %@",mdPhonePushService.push_client_ip);
    for (int y = 0; y < cs_MDPushService.client_count; y++) {
        NSArray * arr = mdPhonePushService.push_client_ip[y];
        for (int i = 0; i<4; i++) {
            NSArray * arrtemp ;
            arrtemp= [[NSArray alloc]init];
            arrtemp =  arr;
            uint8_t arrint = [arrtemp[3-i] intValue];// 8位
            NSLog(@"arrint22: %d",arrint);
            [data_service appendData:[SocketUtils byteFromUInt8:arrint]];
            NSLog(@"[SocketUtils byteFromUInt8:arrint] %@",[SocketUtils byteFromUInt8:arrint]);
        }
    }
    
    
    
    //        [data_service appendData:[self RequestSpliceAttribute:mdPhonePushService.push_client_ip[i]]];
    //    }
    NSLog(@"data_service1122== %@",data_service);
    [serviceCRCData appendData:data_service];   //CRC是除了tag和service
    
    NSLog(@"计算CRC：%@",serviceCRCData);
    
    //4.重置data_service，将tag,CRC,和其他数据加起来
    data_service = [[NSMutableData alloc]init];
    [data_service appendData:[self getPackageTagData]];
    //3.计算CRC
    [data_service appendData:[self dataTOCRCdata:serviceCRCData]];
    [data_service appendData:[self RequestSpliceAttribute:cs_MDPushService]];
    
    for (int y = 0; y < cs_MDPushService.client_count; y++) {
        NSArray * arr = mdPhonePushService.push_client_ip[y];
        for (int i = 0; i<4; i++) {
            NSArray * arrtemp ;
            arrtemp= [[NSArray alloc]init];
            arrtemp =  arr;
            uint8_t arrint = [arrtemp[3-i] intValue];// 8位
            NSLog(@"arrint22: %d",arrint);
            [data_service appendData:[SocketUtils byteFromUInt8:arrint]];
            NSLog(@"[SocketUtils byteFromUInt8:arrint] %@",[SocketUtils byteFromUInt8:arrint]);
        }
    }
    
    NSLog(@"finaldatapush: %@",data_service);
    NSLog(@"finaldata.length: %d",data_service.length);
    
    //转换成字节后，存起来
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    [userDef setObject:data_service forKey:@"data_cs_GetPushDeviceInfo"];
    
    //    [userDef synchronize];//把数据同步到本地
    
    
    [[Singleton sharedInstance] GetPushDeviceInfo_socket];
}


//手机投机顶盒录制
-(void)SetCSMDPushLive
{
    NSLog(@"发送投屏信息");
    
    cs_MDPushFile.module_name= @"MDMM";
    cs_MDPushFile.Ret=0;
    cs_MDPushFile.Reserved=APDE_Identify;
    
    
    do {
        NSLog(@"IP为空，此处获取一个IP地址");
        cs_MDPushFile.client_ip= [self getIPArr];
    } while (ISNULL(cs_MDPushFile.client_ip));
    
    
    
    cs_MDPushFile.client_port = (uint32_t)[_socket localPort] ;
    cs_MDPushFile.unique_id = [SocketUtils uint32FromBytes:[SocketView GetNowTimes]];
    cs_MDPushFile.command_type = DTV_SERVICE_MD_PUSH_FILE ;
    
    
    cs_MDPushFile.file_name_len = filePushService.file_name_len;
    cs_MDPushFile.file_name = filePushService.file_name;
    cs_MDPushFile.client_name_len = filePushService.client_name_len;;
    cs_MDPushFile.client_name = filePushService.client_name;
    
    NSLog(@" cs_MDPushFile.client_name--录制 %@",cs_MDPushFile.client_name);
    
    cs_MDPushFile.push_type = filePushService.push_type;
    NSLog(@"cs_MDPushFile.push_type %hhu",cs_MDPushFile.push_type);
    cs_MDPushFile.client_count = filePushService.client_count;
    NSLog(@"cs_MDPushFile.client_count %hhu",cs_MDPushFile.client_count);
    
    int dataLen = 13 + filePushService.client_name_len +filePushService.file_name_len+ filePushService.client_count*4 ;
    NSLog(@"filePushService.file_name %@",filePushService.file_name);
    NSLog(@"filePushService.client_name %@",filePushService.client_name);
    NSLog(@"filePushService.file_name_len %d",filePushService.file_name_len);
    NSLog(@"filePushService.client_name_len %d",filePushService.client_name_len);
    cs_MDPushFile.data_len = dataLen;
    NSLog(@"dataLendataLendataLen %d",dataLen);
    
    
    //除了CRC和tag其他数据
    NSMutableData * data_service ;
    data_service = [[NSMutableData alloc]init];
    
    //计算CRC
    NSMutableData * serviceCRCData;
    serviceCRCData = [[NSMutableData alloc]init];
    
    //1.tag转data
    //2.除了CRC和tag之外的转data
    data_service = [self RequestSpliceAttribute:cs_MDPushFile];
    NSLog(@"cs_MDPushServiceaa== %@",cs_MDPushFile);
    for (int y = 0; y < filePushService.client_count; y++) {
        NSArray * arr = filePushService.push_client_ip[y];
        for (int i = 0; i<4; i++) {
            NSArray * arrtemp ;
            arrtemp= [[NSArray alloc]init];
            arrtemp =  arr;
            uint8_t arrint = [arrtemp[3-i] intValue];// 8位
            NSLog(@"arrint22: %d",arrint);
            [data_service appendData:[SocketUtils byteFromUInt8:arrint]];
            NSLog(@"[SocketUtils byteFromUInt8:arrint] %@",[SocketUtils byteFromUInt8:arrint]);
        }
    }
    
    
    [serviceCRCData appendData:data_service];   //CRC是除了tag和service
    
    NSLog(@"计算CRC：%@",serviceCRCData);
    
    //4.重置data_service，将tag,CRC,和其他数据加起来
    data_service = [[NSMutableData alloc]init];
    [data_service appendData:[self getPackageTagData]];
    //3.计算CRC
    [data_service appendData:[self dataTOCRCdata:serviceCRCData]];
    [data_service appendData:[self RequestSpliceAttribute:cs_MDPushFile]];
    
    for (int y = 0; y < filePushService.client_count; y++) {
        NSArray * arr = filePushService.push_client_ip[y];
        for (int i = 0; i<4; i++) {
            NSArray * arrtemp ;
            arrtemp= [[NSArray alloc]init];
            arrtemp =  arr;
            uint8_t arrint = [arrtemp[3-i] intValue];// 8位
            NSLog(@"arrint22: %d",arrint);
            [data_service appendData:[SocketUtils byteFromUInt8:arrint]];
            NSLog(@"[SocketUtils byteFromUInt8:arrint] %@",[SocketUtils byteFromUInt8:arrint]);
        }
    }
    
    NSLog(@"finaldatapushfile: %@",data_service);
    NSLog(@"finaldata.length: %d",data_service.length);
    
    //转换成字节后，存起来
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    [userDef setObject:data_service forKey:@"CSMDPushToSTBLive_socketInfo"];
    
    //    [userDef synchronize];//把数据同步到本地
    
    
    [[Singleton sharedInstance] CSMDPushToSTBLive_socket];
}

///机顶盒投手机直播
-(void)SetSc_MDOtherPushService
{
    NSLog(@"发送机顶盒投手机直播信息");
    
    sc_MDOtherPushService.module_name= @"MDMM";
    sc_MDOtherPushService.Ret=0;
    sc_MDOtherPushService.Reserved=APDE_Identify;
    
    
    do {
        NSLog(@"IP为空，此处获取一个IP地址");
        sc_MDOtherPushService.client_ip= [self getIPArr];
    } while (ISNULL(sc_MDOtherPushService.client_ip));
    
    
    
    sc_MDOtherPushService.client_port = (uint32_t)[_socket localPort] ;
    
    sc_MDOtherPushService.unique_id = [SocketUtils uint32FromBytes:[SocketView GetNowTimes]];
    sc_MDOtherPushService.command_type = DTV_SERVICE_MD_PLAY_PUSH_SERVICE ;
    
    
    //    sc_MDOtherPushService.tuner_type = [otherDevicePushService.service_tuner_type intValue];
    //
    //    cs_MDPushService.network_id = [otherDevicePushService.service_network_id intValue];
    //
    //    cs_MDPushService.ts_id = [otherDevicePushService.service_ts_id intValue];
    //
    //    cs_MDPushService.service_id = [otherDevicePushService.service_service_id intValue];
    
    cs_MDPushService.audio_pid =  cs_service.audio_index;
    
    cs_MDPushService.subt_pid = cs_service.subt_index; //[mdPhonePushService.subt_pid intValue];
    cs_MDPushService.client_name_len = mdPhonePushService.client_name_len;;
    cs_MDPushService.client_name = mdPhonePushService.client_name;
    
    NSLog(@" cs_MDPushFile.client_name-直播 %@",cs_MDPushService.client_name);
    cs_MDPushService.push_type = mdPhonePushService.push_type;
    cs_MDPushService.client_count = mdPhonePushService.client_count;
    NSLog(@"cs_MDPushService.client_count %d",cs_MDPushService.client_count);
    
    int dataLen = 26 + cs_MDPushService.client_name_len + cs_MDPushService.client_count*4 ;
    cs_MDPushService.data_len = dataLen;
    
    NSLog(@"cs_MDPushService.client_name_len %d",cs_MDPushService.client_name_len);
    NSLog(@"cs_MDPushService.client_count %d",cs_MDPushService.client_count);
    NSLog(@"cs_MDPushService.data_len %d",cs_MDPushService.data_len);
    
    
    
    
    //除了CRC和tag其他数据
    NSMutableData * data_service ;
    data_service = [[NSMutableData alloc]init];
    
    //计算CRC
    NSMutableData * serviceCRCData;
    serviceCRCData = [[NSMutableData alloc]init];
    
    //1.tag转data
    //2.除了CRC和tag之外的转data
    data_service = [self RequestSpliceAttribute:cs_MDPushService];
    NSLog(@"cs_MDPushServiceaa== %@",cs_MDPushService);
    NSLog(@"data_serviceaa== %@",data_service);
    //    NSLog(@"mdPhonePushService== %@",mdPhonePushService.push_client_ip);
    NSLog(@"mdPhonePushService.push_client_ip %@",mdPhonePushService.push_client_ip);
    for (int y = 0; y < cs_MDPushService.client_count; y++) {
        NSArray * arr = mdPhonePushService.push_client_ip[y];
        for (int i = 0; i<4; i++) {
            NSArray * arrtemp ;
            arrtemp= [[NSArray alloc]init];
            arrtemp =  arr;
            uint8_t arrint = [arrtemp[3-i] intValue];// 8位
            NSLog(@"arrint22: %d",arrint);
            [data_service appendData:[SocketUtils byteFromUInt8:arrint]];
            NSLog(@"[SocketUtils byteFromUInt8:arrint] %@",[SocketUtils byteFromUInt8:arrint]);
        }
    }
    
    
    
    //        [data_service appendData:[self RequestSpliceAttribute:mdPhonePushService.push_client_ip[i]]];
    //    }
    NSLog(@"data_service1122== %@",data_service);
    [serviceCRCData appendData:data_service];   //CRC是除了tag和service
    
    NSLog(@"计算CRC：%@",serviceCRCData);
    
    //4.重置data_service，将tag,CRC,和其他数据加起来
    data_service = [[NSMutableData alloc]init];
    [data_service appendData:[self getPackageTagData]];
    //3.计算CRC
    [data_service appendData:[self dataTOCRCdata:serviceCRCData]];
    [data_service appendData:[self RequestSpliceAttribute:cs_MDPushService]];
    
    for (int y = 0; y < cs_MDPushService.client_count; y++) {
        NSArray * arr = mdPhonePushService.push_client_ip[y];
        for (int i = 0; i<4; i++) {
            NSArray * arrtemp ;
            arrtemp= [[NSArray alloc]init];
            arrtemp =  arr;
            uint8_t arrint = [arrtemp[3-i] intValue];// 8位
            NSLog(@"arrint22: %d",arrint);
            [data_service appendData:[SocketUtils byteFromUInt8:arrint]];
            NSLog(@"[SocketUtils byteFromUInt8:arrint] %@",[SocketUtils byteFromUInt8:arrint]);
        }
    }
    
    NSLog(@"finaldatapush: %@",data_service);
    NSLog(@"finaldata.length: %d",data_service.length);
    
    //转换成字节后，存起来
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    [userDef setObject:data_service forKey:@"data_cs_GetPushDeviceInfo"];
    
    //    [userDef synchronize];//把数据同步到本地
    
    
    [[Singleton sharedInstance] GetPushDeviceInfo_socket];
}

//int 转16进制
- (NSString *)hexFromInt:(NSInteger)val {
    //    NSLog(@"int %d",val);
    //    NSLog(@"int 转16%@",[NSString stringWithFormat:@"%X", val]);
    return [NSString stringWithFormat:@"%X", val];
}
-(NSMutableData *)RequestSpliceAttribute:(id)obj{
    _data = [[NSMutableData alloc]init];
    if (obj == nil) {
        self.object = _data;
    }
    unsigned int numIvars; //成员变量个数
    
    objc_property_t *propertys = class_copyPropertyList(NSClassFromString([NSString stringWithUTF8String:object_getClassName(obj)]), &numIvars);
    
    NSString *type = nil;
    NSString *name = nil;
    
    for (int i = 0; i < numIvars; i++) {
        objc_property_t thisProperty = propertys[i];
        
        name = [NSString stringWithUTF8String:property_getName(thisProperty)];
        //        NSLog(@"%d.name:%@",i,name);
        type = [[[NSString stringWithUTF8String:property_getAttributes(thisProperty)] componentsSeparatedByString:@","] objectAtIndex:0]; //获取成员变量的数据类型
        //        NSLog(@"%d.type:%@",i,type);
        
        id propertyValue = [obj valueForKey:[(NSString *)name substringFromIndex:0]];
        //        NSLog(@"%d.propertyValue:%@",i,propertyValue);
        //
        //        NSLog(@"\n");
        
        if ([type isEqualToString:TYPE_UINT8]) {
            uint8_t i = [propertyValue charValue];// 8位
            [_data appendData:[SocketUtils byteFromUInt8:i]];
            //            NSLog(@"%lu",(unsigned long)[SocketUtils bytesFromUInt32:i].length);
            
        }else if([type isEqualToString:TYPE_UINT16]){
            uint16_t i = [propertyValue shortValue];// 16位
            [_data appendData:[SocketUtils bytesFromUInt16:i]];
            //            NSLog(@"%lu",(unsigned long)[SocketUtils bytesFromUInt32:i].length);
            
        }else if([type isEqualToString:TYPE_UINT32]){
            uint32_t i = [propertyValue intValue];// 32位
            [_data appendData:[SocketUtils bytesFromUInt32:i]];
            
        }else if([type isEqualToString:TYPE_UINT64]){
            uint64_t i = [propertyValue longLongValue];// 64位
            [_data appendData:[SocketUtils bytesFromUInt64:i]];
            //            NSLog(@"%lu",(unsigned long)[SocketUtils bytesFromUInt32:i].length);
            
        }else if([type isEqualToString:TYPE_STRING]){
            NSData *data = [(NSString*)propertyValue \
                            dataUsingEncoding:NSUTF8StringEncoding];// 通过utf-8转为data
            //            NSLog(@"conn:%@",_data);
            // 然后拼接字符串
            [_data appendData:data];
            //            NSLog(@"conn:%@",_data);
            //            NSLog(@"%lu",(unsigned long)[SocketUtils bytesFromUInt32:i].length);
            //            NSLog(@"%lu",(unsigned long)_data.length);
            
            
        }else if ([type isEqualToString: TYPE_ARRAY]){
            
            NSLog(@"数组类型");
            
            
            //防止IPArr为空造成崩溃
            while (propertyValue == NULL || propertyValue == nil ) {
                NSArray * arr =  [[NSArray alloc]init];
                arr = [self getIPArr];
                propertyValue = arr;
            }
            
            for (int i = 0; i<4; i++) {
                NSArray * arrtemp ;
                arrtemp= [[NSArray alloc]init];
                arrtemp =  propertyValue;
                //                uint8_t intstring =[arrtemp[3-i] charValue];
                uint8_t arrint = [arrtemp[3-i] intValue];// 8位
                NSLog(@"arrint: %d",arrint);
                [_data appendData:[SocketUtils byteFromUInt8:arrint]];
            }
            
            
        }else {
            NSLog(@"RequestSpliceAttribute:未知类型");
            NSAssert(YES, @"RequestSpliceAttribute:未知类型");
        }
        
        
    }
    
    //    NSLog(@"-Data1:%@",_data);
    //    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];//这个对象其实类似字典，着也是一个单例的例子
    //    [userDef setObject:_data forKey:@"betaData"];
    //    NSLog(@"-Data2:%@",_data);
    //    [userDef synchronize];//把数据同步到本地
    
    // hy: 记得释放C语言的结构体指针
    free(propertys);
    self.object = _data;
    
    return _data;
    
}

//返回时间戳的string类型转换成data类型
+ (NSMutableData *)GetNowTimes

{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeInterval];
    
    int x = [timeString intValue];
    int tmp2 = CFSwapInt32BigToHost(x);
    NSMutableData* data_CRC2 = (NSMutableData *)[NSData dataWithBytes:&tmp2 length:sizeof(tmp2)];
    
    return data_CRC2;
    
    
}


-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 对得到的data值进行解析与转换即可
    
    //    NSLog(@"读--");
    //    NSLog(@"%ld",tag);
    //    NSLog(@"data:%@",data);
    
    [self.socket readDataWithTimeout:30 tag:1];
}
- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    //    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone1G";
    //    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone3G";
    //    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone6S Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhoneSE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"] || [deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone8";
    if ([deviceString isEqualToString:@"iPhone10,2"] || [deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"])    return @"iPhoneX";
    　return deviceString;
}

//CRC 的计算
-(int)getCRC : (NSData *)data  {
    
    long crc32_table[] = {
        0x00000000L, 0x77073096L, 0xee0e612cL, 0x990951baL,
        0x076dc419L, 0x706af48fL, 0xe963a535L, 0x9e6495a3L,
        0x0edb8832L, 0x79dcb8a4L, 0xe0d5e91eL, 0x97d2d988L,
        0x09b64c2bL, 0x7eb17cbdL, 0xe7b82d07L, 0x90bf1d91L,
        0x1db71064L, 0x6ab020f2L, 0xf3b97148L, 0x84be41deL,
        0x1adad47dL, 0x6ddde4ebL, 0xf4d4b551L, 0x83d385c7L,
        0x136c9856L, 0x646ba8c0L, 0xfd62f97aL, 0x8a65c9ecL,
        0x14015c4fL, 0x63066cd9L, 0xfa0f3d63L, 0x8d080df5L,
        0x3b6e20c8L, 0x4c69105eL, 0xd56041e4L, 0xa2677172L,
        0x3c03e4d1L, 0x4b04d447L, 0xd20d85fdL, 0xa50ab56bL,
        0x35b5a8faL, 0x42b2986cL, 0xdbbbc9d6L, 0xacbcf940L,
        0x32d86ce3L, 0x45df5c75L, 0xdcd60dcfL, 0xabd13d59L,
        0x26d930acL, 0x51de003aL, 0xc8d75180L, 0xbfd06116L,
        0x21b4f4b5L, 0x56b3c423L, 0xcfba9599L, 0xb8bda50fL,
        0x2802b89eL, 0x5f058808L, 0xc60cd9b2L, 0xb10be924L,
        0x2f6f7c87L, 0x58684c11L, 0xc1611dabL, 0xb6662d3dL,
        0x76dc4190L, 0x01db7106L, 0x98d220bcL, 0xefd5102aL,
        0x71b18589L, 0x06b6b51fL, 0x9fbfe4a5L, 0xe8b8d433L,
        0x7807c9a2L, 0x0f00f934L, 0x9609a88eL, 0xe10e9818L,
        0x7f6a0dbbL, 0x086d3d2dL, 0x91646c97L, 0xe6635c01L,
        0x6b6b51f4L, 0x1c6c6162L, 0x856530d8L, 0xf262004eL,
        0x6c0695edL, 0x1b01a57bL, 0x8208f4c1L, 0xf50fc457L,
        0x65b0d9c6L, 0x12b7e950L, 0x8bbeb8eaL, 0xfcb9887cL,
        0x62dd1ddfL, 0x15da2d49L, 0x8cd37cf3L, 0xfbd44c65L,
        0x4db26158L, 0x3ab551ceL, 0xa3bc0074L, 0xd4bb30e2L,
        0x4adfa541L, 0x3dd895d7L, 0xa4d1c46dL, 0xd3d6f4fbL,
        0x4369e96aL, 0x346ed9fcL, 0xad678846L, 0xda60b8d0L,
        0x44042d73L, 0x33031de5L, 0xaa0a4c5fL, 0xdd0d7cc9L,
        0x5005713cL, 0x270241aaL, 0xbe0b1010L, 0xc90c2086L,
        0x5768b525L, 0x206f85b3L, 0xb966d409L, 0xce61e49fL,
        0x5edef90eL, 0x29d9c998L, 0xb0d09822L, 0xc7d7a8b4L,
        0x59b33d17L, 0x2eb40d81L, 0xb7bd5c3bL, 0xc0ba6cadL,
        0xedb88320L, 0x9abfb3b6L, 0x03b6e20cL, 0x74b1d29aL,
        0xead54739L, 0x9dd277afL, 0x04db2615L, 0x73dc1683L,
        0xe3630b12L, 0x94643b84L, 0x0d6d6a3eL, 0x7a6a5aa8L,
        0xe40ecf0bL, 0x9309ff9dL, 0x0a00ae27L, 0x7d079eb1L,
        0xf00f9344L, 0x8708a3d2L, 0x1e01f268L, 0x6906c2feL,
        0xf762575dL, 0x806567cbL, 0x196c3671L, 0x6e6b06e7L,
        0xfed41b76L, 0x89d32be0L, 0x10da7a5aL, 0x67dd4accL,
        0xf9b9df6fL, 0x8ebeeff9L, 0x17b7be43L, 0x60b08ed5L,
        0xd6d6a3e8L, 0xa1d1937eL, 0x38d8c2c4L, 0x4fdff252L,
        0xd1bb67f1L, 0xa6bc5767L, 0x3fb506ddL, 0x48b2364bL,
        0xd80d2bdaL, 0xaf0a1b4cL, 0x36034af6L, 0x41047a60L,
        0xdf60efc3L, 0xa867df55L, 0x316e8eefL, 0x4669be79L,
        0xcb61b38cL, 0xbc66831aL, 0x256fd2a0L, 0x5268e236L,
        0xcc0c7795L, 0xbb0b4703L, 0x220216b9L, 0x5505262fL,
        0xc5ba3bbeL, 0xb2bd0b28L, 0x2bb45a92L, 0x5cb36a04L,
        0xc2d7ffa7L, 0xb5d0cf31L, 0x2cd99e8bL, 0x5bdeae1dL,
        0x9b64c2b0L, 0xec63f226L, 0x756aa39cL, 0x026d930aL,
        0x9c0906a9L, 0xeb0e363fL, 0x72076785L, 0x05005713L,
        0x95bf4a82L, 0xe2b87a14L, 0x7bb12baeL, 0x0cb61b38L,
        0x92d28e9bL, 0xe5d5be0dL, 0x7cdcefb7L, 0x0bdbdf21L,
        0x86d3d2d4L, 0xf1d4e242L, 0x68ddb3f8L, 0x1fda836eL,
        0x81be16cdL, 0xf6b9265bL, 0x6fb077e1L, 0x18b74777L,
        0x88085ae6L, 0xff0f6a70L, 0x66063bcaL, 0x11010b5cL,
        0x8f659effL, 0xf862ae69L, 0x616bffd3L, 0x166ccf45L,
        0xa00ae278L, 0xd70dd2eeL, 0x4e048354L, 0x3903b3c2L,
        0xa7672661L, 0xd06016f7L, 0x4969474dL, 0x3e6e77dbL,
        0xaed16a4aL, 0xd9d65adcL, 0x40df0b66L, 0x37d83bf0L,
        0xa9bcae53L, 0xdebb9ec5L, 0x47b2cf7fL, 0x30b5ffe9L,
        0xbdbdf21cL, 0xcabac28aL, 0x53b39330L, 0x24b4a3a6L,
        0xbad03605L, 0xcdd70693L, 0x54de5729L, 0x23d967bfL,
        0xb3667a2eL, 0xc4614ab8L, 0x5d681b02L, 0x2a6f2b94L,
        0xb40bbe37L, 0xc30c8ea1L, 0x5a05df1bL, 0x2d02ef8dL
    };
    int crc32 = 0xFFFFFFFF;
    
    uint8_t byteArray[[data length]];
    
    [data getBytes:&byteArray length:[data length]];
    
    for (int i = 0; i < [data length] ; i++ ) {
        Byte byte = byteArray[i];
        //        NSLog(@"--byte%x",byte);
        crc32 = (crc32 >> 8) ^ ((int)crc32_table[((crc32) ^ byte) & 0xFF]);
    }
    NSLog(@"crc32 ^ 0xFFFFFFFF: %u",crc32 ^ 0xFFFFFFFF);
    return (int)(crc32 ^ 0xFFFFFFFF);
    
}

//nsdata------CRC------>data
-(NSMutableData *)dataTOCRCdata: (NSMutableData*)aData
{
    int result= [self getCRC:aData];
    int tmp2 = CFSwapInt32BigToHost(result);
    //     NSMutableData* data_CRC1 = (NSMutableData *)[NSData dataWithBytes:&result length:sizeof(result)];
    NSMutableData* data_CRC2 = (NSMutableData *)[NSData dataWithBytes:&tmp2 length:sizeof(tmp2)];
    //    NSString * CRChexstring = [self hexFromInt:result];
    //    NSLog(@"--获取到的CRC16进制CRC: %@",CRChexstring);
    
    //    NSMutableData * data_CRC = [[NSMutableData alloc]init];
    
    //    data_CRC = (NSMutableData *)[SocketUtils dataFromHexString:CRChexstring];
    
    //    NSLog(@"--CRC: %@",data_CRC);
    //    NSLog(@"--data_CRC1: %@",data_CRC1);
    NSLog(@"--data_CRC2: %@",data_CRC2);
    
    return data_CRC2;
}

//
-(NSArray *)getIPArr
{
    //    NSString * astr = [self getIPAddress];
    bool getIPV4 = YES;
    NSString * astr = [self getIPAddress:getIPV4];
    NSLog(@"astr %@",astr);
    NSArray *array = [astr componentsSeparatedByString:@"."]; //从字符.中分隔成2个元素的数组
    return array;
}
-(NSMutableData * )getPackageTagData
{
    NSMutableData * package_tagData ;
    package_tagData = [[NSMutableData alloc]init];
    NSString * package_tag = @"DIGW";
    package_tagData = (NSMutableData *)[package_tag dataUsingEncoding:NSUTF8StringEncoding];
    return package_tagData;
}
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

#pragma mark - 获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
- (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}
- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
@end

