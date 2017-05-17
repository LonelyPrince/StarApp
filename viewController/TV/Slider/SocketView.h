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

@property(nonatomic,strong)ServiceModel *socket_ServiceModel;
-(void)socketConnectHost;// socket连接
-(void)heartBeat;
-(void)serviceTouch;
-(void)deliveryPlayExit;
//-(void)passwordCheck;
-(void)passwordCheck :(NSString *)passWordStr  passwordType:(int)passwd_type_int;
-(void)csGetResource;
-(void)csGetRouteIPAddress;

-(int)getCRC : (NSData *)data ;
+ (NSMutableData *)GetNowTimes;
@end
