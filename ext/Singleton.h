//
//  Singleton.h
//  StarAPP
//
//  Created by xyz on 16/8/24.
//
//

#import <Foundation/Foundation.h>

// Singleton.h
#import "AsyncSocket.h"
#import "SocketView.h"

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t onceToken = 0; \
__strong static id sharedInstance = nil; \
dispatch_once(&onceToken, ^{ \
sharedInstance = block(); \
}); \
return sharedInstance; \

@interface Singleton : NSObject<AsyncSocketDelegate>
@property (nonatomic, retain) NSTimer        *connectTimer; // 计时器（心跳用）

@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的prot

@property (nonatomic, strong) SocketView    *socketView;       // socketview
//断开时候用
enum{
    SocketOfflineByServer,// 服务器掉线，默认为0
    SocketOfflineByUser,  // 用户主动cut
};

+ (Singleton *)sharedInstance;

-(void)socketConnectHost;// socket连接
-(void)cutOffSocket; // 断开socket连接

-(void)Play_ServiceSocket;
-(void)Play_ExitSocket;
-(void)passwordCheck;
-(void)GetResource_socket;
-(void)GetIPAddress_socket;
@end
