//
//  SocketView.h
//  StarAPP
//
//  Created by xyz on 16/9/19.
//
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"

#import "SocketModel.h"
#import "Cs_serviceREC.h"
#import "MDPhonePushService.h"
#import "FilePushService.h"
#import "OtherDevicePushService.h"
#import "OtherDevicePushLive.h"
extern NSString * const TYPE_UINT8;
extern NSString * const TYPE_UINT16;
extern NSString * const TYPE_UINT32;
extern NSString * const TYPE_UINT64;
extern NSString * const TYPE_STRING;
extern NSString * const TYPE_ARRAY;

@interface SocketView : UIViewController<AsyncSocketDelegate>
@property (nonatomic, strong) NSMutableData *data;
@property(nonatomic,assign )BOOL connectBool;
@property (nonatomic, strong)  AsyncSocket *socket;

@property(nonatomic,strong)Cs_Hearbeat* cs_heatbeat;     //1
@property(nonatomic,strong)Cs_Service* cs_service;  //2
@property(nonatomic,strong)Cs_PlayExit * cs_playExit;   //3

@property(nonatomic,strong)Cs_PasswordCheck * cs_passwordCheck;        //4
@property(nonatomic,strong)Cs_UpdateChannel * cs_updateChannel;     //5
@property(nonatomic,strong)Cs_CAMatureLock * cs_CAMatureLock;       //6

@property(nonatomic,strong)Cs_GetResource * cs_getResource;         //7

@property(nonatomic,strong)Cs_GetRouteIPAddress * cs_getRouteIPAddress;         //8
@property(nonatomic,strong)Cs_GetPushDeviceInfo * cs_GetPushDeviceInfo;         //9
@property(nonatomic,strong)Cs_serviceREC * cs_serviceREC;  //播放录制文件
@property(nonatomic,strong)Cs_MDPushService * cs_MDPushService;  //手机投屏播放直播
@property(nonatomic,strong)Cs_MDPushFile * cs_MDPushFile;         //手机投屏播放录制

@property(nonatomic,strong)Sc_MDOtherPushService * sc_MDOtherPushService;
@property(nonatomic,strong)Sc_MDOtherPushLive * sc_MDOtherPushLive;     

@property(nonatomic,strong)OtherDevicePushService * otherDevicePushService;
@property(nonatomic,strong)OtherDevicePushLive * otherDevicePushLive;

@property(nonatomic,strong)ServiceModel *socket_ServiceModel;
@property(nonatomic,strong)MDPhonePushService * mdPhonePushService;
@property(nonatomic,strong)FilePushService * filePushService;


-(void)socketConnectHost;// socket连接
-(void)heartBeat;
-(void)serviceTouch;
-(void)deliveryPlayExit;
//-(void)passwordCheck;
-(void)passwordCheck :(NSString *)passWordStr  passwordType:(int)passwd_type_int;
-(void)csGetResource;
-(void)csGetRouteIPAddress;
-(void)serviceRECTouch;
-(void)csGetPushInfo;
///手机直播投机顶盒
-(void)SetCSMDPushService;
//手机投机顶盒录制
-(void)SetCSMDPushLive;

-(int)getCRC : (NSData *)data ;
+ (NSMutableData *)GetNowTimes;
@end
