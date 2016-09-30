//
//  Singleton.m
//  StarAPP
//
//  Created by xyz on 16/8/24.
//
//

#import "Singleton.h"
#import <sys/socket.h>

#import <netinet/in.h>

#import <arpa/inet.h>

#import <unistd.h>

//#import "SocketModel.h"
@implementation Singleton
+(Singleton *) sharedInstance
{
    
    static Singleton *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}



// socket连接
-(void)socketConnectHost{
    
//    self.socketView = [[SocketView alloc]init];
    
    self.socket    = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
    
    [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];
    
}

//心跳
#pragma mark  - 连接成功回调
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString     *)host port:(UInt16)port
{
    NSLog(@"socket连接成功");
    NSLog(@"接下来开始发送心跳");
    // 每隔30s像服务器发送心跳包
    [sock readDataWithTimeout:-1 tag:0];
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];// 在longConnectToSocket方法中进行长连接需要向服务器发送的讯息
    
    [self.connectTimer fire];
    
}

//socket 发送与接收数据
//发送数据我们补充上文心跳连接未完成的方法

// 心跳连接
-(void)longConnectToSocket{
    
    
    // 根据服务器要求发送固定格式的数据
//    [self.socketView heartBeat];
    NSMutableData * betaData1 = [[NSMutableData alloc]init];
    
    betaData1 = [USER_DEFAULT objectForKey:@"beatAllData"];
    NSLog(@"beatAllData:%@",betaData1);
    
    [self.socket writeData:betaData1 withTimeout:1 tag:1];
    
    
    
}

//播放视频
-(void)Play_ServiceSocket{

    // 根据服务器要求发送固定格式的数据
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    NSMutableData * data_service = [[NSMutableData alloc]init];
    
    data_service = [userDef objectForKey:@"data_service"];
//    NSLog(@"singleton data_service :%@",data_service);
    
    [self.socket writeData:data_service withTimeout:1 tag:2];
    
}
//退出播放
-(void)Play_ExitSocket{
    
    // 根据服务器要求发送固定格式的数据
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    NSMutableData * data_service = [[NSMutableData alloc]init];
    
    data_service = [userDef objectForKey:@"data_playExit"];
    //    NSLog(@"singleton data_service :%@",data_service);
    
    [self.socket writeData:data_service withTimeout:1 tag:2];
    
}
//密码校验
-(void)passwordCheck{
    
    // 根据服务器要求发送固定格式的数据
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    NSMutableData * data_service = [[NSMutableData alloc]init];
    
    data_service = [userDef objectForKey:@"data_passwordCheck"];
    //    NSLog(@"singleton data_service :%@",data_service);
    
    [self.socket writeData:data_service withTimeout:1 tag:2];
    
}
//ca控制节目输pin码
-(void)GetResource_socket{
    
    // 根据服务器要求发送固定格式的数据
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    NSMutableData * data_service = [[NSMutableData alloc]init];
    
    data_service = [userDef objectForKey:@"data_getResource"];
    //    NSLog(@"singleton data_service :%@",data_service);
    
    [self.socket writeData:data_service withTimeout:1 tag:2];
    
}
// 切断socket
-(void)cutOffSocket{
    
    self.socket.userData = SocketOfflineByUser;// 声明是由用户主动切断
    
    [self.connectTimer invalidate];
    
    [self.socket disconnect];
}

//实现代理方法
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"sorry the connect is failure %ld",sock.userData);
    
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self socketConnectHost];
    }
    else if (sock.userData == SocketOfflineByUser) {
        // 如果由用户断开，不进行重连
        return;
    }
    
}




-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 对得到的data值进行解析与转换即可
    
    NSLog(@"读--");
    NSLog(@"%ld",tag);
    NSLog(@"readdata:%@",data);

    NSData * data_ret = [data subdataWithRange:NSMakeRange(12,4)];
    uint8_t data_retTo32int = [SocketUtils uint32FromBytes:data_ret];
    if (data_retTo32int ==1) {
    
        [MBProgressHUD showMessag:@"CRC error" toView:nil];
    }
    else{
    
    NSData * data_model_name = [data subdataWithRange:NSMakeRange(8,4)];
    NSString * model_name = [[NSString alloc]initWithData:data_model_name encoding:NSUTF8StringEncoding];
    NSLog(@"data1:%@",model_name);
    if([model_name isEqualToString:@"BEAT"])
    {
    }
    else if([model_name isEqualToString:@"MDMM"])
    {
    NSData * data2_command_type = [data subdataWithRange:NSMakeRange(36,1)];
       uint8_t command_type = [SocketUtils uint8FromBytes:data2_command_type];
        
//        NSLog(@"command_type:%hhu",command_type);
        
        switch (command_type) {
            case 0:
            
            break;
            
            case 12:
                {
                    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
                    [userDef setObject:data forKey:@"data_service11"];
                    
                    [userDef synchronize];//把数据同步到本地
                    
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:data,@"playdata",nil];
                    
                    
                    
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"notice" object:nil userInfo:dict];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
            break;
            
            
            default:
            break;
        }
    }
    
    
}
    
    
    [self.socket readDataWithTimeout:30 tag:0];
}



@end
