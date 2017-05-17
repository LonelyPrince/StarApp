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
    NSLog(@"发送一次心跳");
    [self.socket writeData:betaData1 withTimeout:1 tag:1];
    
    
    
}

//播放视频
-(void)Play_ServiceSocket{
    
    // 根据服务器要求发送固定格式的数据
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，这也是一个单例的例子
    NSMutableData * data_service = [[NSMutableData alloc]init];
    
    data_service = [userDef objectForKey:@"data_service"];
    NSLog(@"singleton data_service :%@",data_service);
    
    
    [self.socket writeData:data_service withTimeout:1 tag:2];
    
    NSLog(@"playState---== socket 第一次打开发送播放命令");
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
#pragma mark - 获取IP地址
//获取IP地址
-(void)GetIPAddress_socket{
    
    // 根据服务器要求发送固定格式的数据
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    NSMutableData * data_service = [[NSMutableData alloc]init];
    
    data_service = [userDef objectForKey:@"data_getIPAddress"];
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
    //    NSLog(@"playState---== socket 接收到播放命令");
    NSData * data_ret = [data subdataWithRange:NSMakeRange(12,4)];
    uint32_t data_retTo32int = [SocketUtils uint32FromBytes:data_ret];
    if (data_retTo32int ==1) {    //此处可以多做欧几次判断，判断socket错误原因
        
        [MBProgressHUD showMessag:@"CRC error" toView:nil];
        NSLog(@"CRC error %@",data);
    }
    else{
        
        NSData * data_model_name = [data subdataWithRange:NSMakeRange(8,4)];
        NSString * model_name = [[NSString alloc]initWithData:data_model_name encoding:NSUTF8StringEncoding];
        NSLog(@"打印data_model_name:%@",data_model_name);
        NSLog(@"data1:%@",model_name);
        if([model_name isEqualToString:@"BEAT"])
        {
            //这里进行判断
            int data_length = data.length;
            NSLog(@"data_length %d",data_length);
            
            
            if (data_length > 28) { //如果大于28，则证明里面还存在数据，则需要更加深度的解析
                int nowData_length;
                nowData_length = 28;
                
                while (nowData_length < data_length) {
                    
                    
                    NSData * next_data_ret = [data subdataWithRange:NSMakeRange(nowData_length + 12,4)];  //判断下一个数据段的
                    //判断下一个数据段的返回结果是否为1，如果是1则报错
                    uint32_t data_retTo32int = [SocketUtils uint32FromBytes:next_data_ret];
                    if (data_retTo32int ==1) {    //此处可以多做欧几次判断，判断socket错误原因
                        
                        [MBProgressHUD showMessag:@"CRC error111" toView:nil];
                    }else{
                        
                        NSData * next_data_model_name = [data subdataWithRange:NSMakeRange(nowData_length + 8,4)];
                        NSString * next_model_name = [[NSString alloc]initWithData:next_data_model_name encoding:NSUTF8StringEncoding];
                        
                        if([next_model_name isEqualToString:@"BEAT"])
                        {
                            //此处是心跳命令
                            nowData_length = 28 + nowData_length;
                            continue;
                        }else if([next_model_name isEqualToString:@"MDMM"])
                        {
                            NSData * next_data2_command_type = [data subdataWithRange:NSMakeRange(36 + nowData_length,1)];
                            uint8_t next_command_type = [SocketUtils uint8FromBytes:next_data2_command_type];
                            
                            switch (next_command_type) {
                                    NSLog(@"next_command_type  %d",next_command_type);
                                case 0:
                                {
                                    // 更新了列表
                                    NSLog(@"列表更新了");
                                    //                                    mediaDeliveryUpdateNotific
                                    
                                    //创建通知
                                    NSNotification *updateNotification =[NSNotification notificationWithName:@"mediaDeliveryUpdateNotific" object:nil userInfo:nil];
                                    //通过通知中心发送通知
                                    [[NSNotificationCenter defaultCenter] postNotification:updateNotification];
                                }
                                    break;
                                    
                                case 12:
                                {
                                    NSLog(@"playState---== socket 内部内部内部内部正在播放的命令");
                                    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
                                    
                                    //首先获得第二段数据的长度 （52，4）
                                    //======
                                    
                                    NSData * now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //data.length - nowData_length
                                    [userDef setObject:bigDataReduceSmallData forKey:@"data_service11"];
                                    
                                    [userDef synchronize];//把数据同步到本地
                                    
                                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:bigDataReduceSmallData,@"playdata",nil];
                                    
                                    
                                    
                                    //创建通知
                                    NSNotification *notification =[NSNotification notificationWithName:@"notice" object:nil userInfo:dict];
                                    //通过通知中心发送通知
                                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                                }
                                    break;
                                    
                                case 24:
                                {
                                    NSLog(@"playState---== socket 获取IP地址的消息");
                                    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
                                    
                                    //首先获得第二段数据的长度 （52，4）
                                    //======
                                    
                                    NSData * now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //data.length - nowData_length
                                    [userDef setObject:bigDataReduceSmallData forKey:@"data_socketGetIpAddress"];
                                    
                                    [userDef synchronize];//把数据同步到本地
                                    
                                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:bigDataReduceSmallData,@"socketIPAddress",nil];
                                    
                                    
                                    
                                    //创建通知
                                    NSNotification *notification =[NSNotification notificationWithName:@"getSocketIpInfoNotice" object:nil userInfo:dict];
                                    //通过通知中心发送通知
                                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                                }
                                    break;
                                    
                                case 17:  //此处是获得资源信息
                                {
                                    NSLog(@"akjsdbkabdbaskdbakjsbd");
                                    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
                                    
                                    
                                    //--
                                    
                                    //首先获得第二段数据的长度 （52，4）
                                    //======
                                    
                                    NSData * now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    if (nowData_length +28+now_data_lengthToInt > data.length) {
                                        //错误,不能大于
                                    }else
                                    {
                                        bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //
                                        
                                        [userDef setObject:bigDataReduceSmallData forKey:@"dataResourceInfo"];
                                        
                                        [userDef synchronize];//把数据同步到本地
                                        
                                        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:bigDataReduceSmallData,@"resourceInfoData",nil];
                                        
                                        NSString * viewToViewStr = [USER_DEFAULT objectForKey:@"viewTOview"];
                                        if ([viewToViewStr isEqualToString:@"MonitorView_Now"]) { //如果打开的是Monitor页面，则发送通知
                                            int monitorApperCount ;
                                            NSString * monitorApperCountStr =  [USER_DEFAULT objectForKey:@"monitorApperCountStr"];
                                            monitorApperCount = [monitorApperCountStr intValue];
                                            NSLog(@"monitorApperCount %d",monitorApperCount);
                                            if (monitorApperCount == 0) {
                                                //创建通知
                                                NSNotification *notification =[NSNotification notificationWithName:@"getResourceInfo" object:nil userInfo:dict];
                                                //通过通知中心发送通知
                                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                                                
                                                monitorApperCount = 1;
                                                NSString * monitorApperCountStr1 =  [NSString stringWithFormat:@"%d",monitorApperCount];
                                                [USER_DEFAULT setObject:monitorApperCountStr1 forKey:@"monitorApperCountStr"];
                                            }
                                            else
                                            {
                                                //=====这里有可能报错，因为刚打开应用进入monitor页面的时候，没有创建这个通知
                                                //创建通知
                                                NSNotification *notification1 =[NSNotification notificationWithName:@"getNotificInfoByMySelf" object:nil userInfo:dict];
                                                //通过通知中心发送通知
                                                [[NSNotificationCenter defaultCenter] postNotification:notification1];
                                            }
                                            
                                        }
                                        
                                        //这里给device发送数据
                                        NSString * deviceOpenStr = [USER_DEFAULT objectForKey:@"deviceOpenStr"];
                                        if ([deviceOpenStr isEqualToString:@"deviceOpen"]) {
                                            //创建通知
                                            NSNotification *notification =[NSNotification notificationWithName:@"getResourceInfoToDevice" object:nil userInfo:dict];
                                            //通过通知中心发送通知
                                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                                            NSLog(@"akjsdbkabdbaskdbakjsbd11--");
                                        }
                                        
                                    }
                                    
                                    //--
                                    
                                    
                                    
                                    
                                    
                                }
                                    break;
                                case 16:  //此处是停止视频播放
                                {
                                    NSLog(@"*****停止视频播放");
                                }
                                    break;
                                case 8:  //CA 加扰
                                {
                                    NSLog(@"*****此处是CA加扰验证1");
                                    //这里可以获得CA信息
                                    //第一步：获得必要的CA消息
                                    
                                    
                                    
                                    
                                    //======
                                    //获得数据区的长度
                                    NSData * now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //
                                    //--
                                    
                                    //此处是验证机顶盒密码，将会这个消息传到TV页面
                                    NSData * data_CA_Ret = [bigDataReduceSmallData subdataWithRange:NSMakeRange(37 + nowData_length,6)];
                                    
                                    
                                    //发送弹窗消息
                                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:data_CA_Ret,@"CAThreedata",nil];
                                    //创建通知
                                    NSNotification *notification =[NSNotification notificationWithName:@"CADencryptNotific" object:nil userInfo:dict];
                                    //通过通知中心发送通知
                                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                                    
                                }
                                    break;
                                case 13:  //此处是验证机顶盒密码
                                {
                                    
                                    
                                    //获得数据区的长度
                                    NSData * now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //
                                    //--
                                    
                                    //此处是验证机顶盒密码
                                    NSData * data_STB_Ret = [bigDataReduceSmallData subdataWithRange:NSMakeRange(12 + nowData_length,4)];
                                    uint32_t data_STB_Ret_int = [SocketUtils uint32FromBytes:data_STB_Ret];
                                    
                                    
                                    
                                    if(data_STB_Ret_int == 5) //正确
                                    {
                                        //发送播放命令
                                        //创建通知
                                        NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptVideoTouchNotific" object:nil userInfo:nil];
                                        //通过通知中心发送通知
                                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                                        
                                        //                        STBDencryptVideoTouchNotific
                                        NSLog(@"验证正确");
                                    }else if(data_STB_Ret_int == 6) //验证错误
                                    {
                                        //显示文字：请输入密码
                                        NSLog(@"验证失败");
                                    }
                                    NSLog(@"*****判断机顶盒加锁验证正确与否");
                                }
                                    break;
                                    
                                default:
                                    break;
                            }
                        }
                        
                    }
                    //首先获得第二段数据的长度 （52，4）
                    //                            int now_data_len_place = nowData_length + 24;
                    
                    NSData * now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                    NSLog(@"playstate -==now_data_lengthToInt %d",now_data_lengthToInt);
                    nowData_length = nowData_length + now_data_lengthToInt + 28;
                }
            }
            
            
            
        }
        
        //        }
        else if([model_name isEqualToString:@"MDMM"])
        {
            
            //new 进行判断，防止多个data合在一起
            
            //这里进行判断
            int data_length = data.length;   //总长度
            NSLog(@"data_length %d",data_length);
            
            uint32_t MDMM_Data_Length = [SocketUtils uint32FromBytes:[data subdataWithRange:NSMakeRange( 24,4)]];   //第一段数据区总长度
            
            if (data_length > 28 + MDMM_Data_Length ) {  //如果总数据长度大于第一段数据的长度
                //证明还有其他的信息，MDMM信息和心跳都在一起了
                int nowData_length;
                nowData_length = 28 + MDMM_Data_Length;
                //--先执行第一个命令
                
                NSData * data2_command_type = [data subdataWithRange:NSMakeRange(36,1)];
                uint8_t command_type = [SocketUtils uint8FromBytes:data2_command_type];
                
                NSLog(@"command_type:%hhu",command_type);
                
                switch (command_type) {   //这里代表第一段的MDMM，所以不需要加nowData_length
                        NSLog(@"command_type %d",command_type);
                    case 0:
                    {
                        // 更新了列表
                        NSLog(@"列表更新了");
                        
                        //创建通知
                        NSNotification *updateNotification =[NSNotification notificationWithName:@"mediaDeliveryUpdateNotific" object:nil userInfo:nil];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:updateNotification];
                        
                    }
                        break;
                        
                    case 12:
                    {
                        NSLog(@"playState---== socket 正在播放的命令");
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
                     
                    case 24:
                    {
                        NSLog(@"playState---== socket 获取IP地址的消息");
                       
                        NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
                        [userDef setObject:data forKey:@"data_socketGetIpAddress"];
                        
                        [userDef synchronize];//把数据同步到本地
                        
                        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:data,@"socketIPAddress",nil];
                        
                        
                        
                        //创建通知
                        NSNotification *notification =[NSNotification notificationWithName:@"getSocketIpInfoNotice" object:nil userInfo:dict];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                    }
                        break;
                        
                    case 17:  //此处是获得资源信息
                    {NSLog(@"akjsdbkabdbaskdbakjsbd");
                        NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
                        [userDef setObject:data forKey:@"dataResourceInfo"];
                        
                        [userDef synchronize];//把数据同步到本地
                        
                        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:data,@"resourceInfoData",nil];
                        
                        
                        NSString * viewToViewStr = [USER_DEFAULT objectForKey:@"viewTOview"];
                        if ([viewToViewStr isEqualToString:@"MonitorView_Now"]) { //如果打开的是Monitor页面，则发送通知
                            
                            int monitorApperCount ;
                            NSString * monitorApperCountStr =  [USER_DEFAULT objectForKey:@"monitorApperCountStr"];
                            monitorApperCount = [monitorApperCountStr intValue];
                            NSLog(@"monitorApperCount %d",monitorApperCount);
                            if (monitorApperCount == 0) {
                                //创建通知
                                NSNotification *notification =[NSNotification notificationWithName:@"getResourceInfo" object:nil userInfo:dict];
                                //通过通知中心发送通知
                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                                
                                monitorApperCount = 1;
                                NSString * monitorApperCountStr1 =  [NSString stringWithFormat:@"%d",monitorApperCount];
                                [USER_DEFAULT setObject:monitorApperCountStr1 forKey:@"monitorApperCountStr"];
                            }
                            else
                            {
                                //=====这里有可能报错，因为刚打开应用进入monitor页面的时候，没有创建这个通知
                                //创建通知
                                NSNotification *notification1 =[NSNotification notificationWithName:@"getNotificInfoByMySelf" object:nil userInfo:dict];
                                //通过通知中心发送通知
                                [[NSNotificationCenter defaultCenter] postNotification:notification1];
                            }
                        }
                        //这里给device发送数据
                        NSString * deviceOpenStr = [USER_DEFAULT objectForKey:@"deviceOpenStr"];
                        if ([deviceOpenStr isEqualToString:@"deviceOpen"]) {
                            //创建通知
                            NSNotification *notification =[NSNotification notificationWithName:@"getResourceInfoToDevice" object:nil userInfo:dict];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                            NSLog(@"akjsdbkabdbaskdbakjsbd11--22");
                        }
                        
                        
                        
                    }
                        break;
                    case 16:  //此处是停止视频播放
                    {
                        NSLog(@"*****停止视频播放");
                    }
                        break;
                    case 8:  //CA 加扰
                    {
                        NSLog(@"*****此处是CA加扰验证2");
                        //这里可以获得CA信息
                        //第一步：获得必要的CA消息
                        //此处是验证机顶盒密码，将会这个消息传到TV页面
                        NSData * data_CA_Ret = [data subdataWithRange:NSMakeRange(37 ,6)];
                        
                        
                        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:data_CA_Ret,@"CAThreedata",nil];
                        //创建通知
                        NSNotification *notification =[NSNotification notificationWithName:@"CADencryptNotific" object:nil userInfo:dict];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                        
                    }
                        break;
                    case 13:  //此处是验证机顶盒密码
                    {
                        //此处是验证机顶盒密码
                        NSData * data_STB_Ret = [data subdataWithRange:NSMakeRange(12 ,4)];
                        uint32_t data_STB_Ret_int = [SocketUtils uint32FromBytes:data_STB_Ret];
                        
                        if(data_STB_Ret_int == 5) //正确
                        {
                            //发送播放命令
                            //创建通知
                            NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptVideoTouchNotific" object:nil userInfo:nil];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification1];
                            
                            //                        STBDencryptVideoTouchNotific
                            NSLog(@"验证正确");
                        }else if(data_STB_Ret_int == 6) //验证错误
                        {
                            //显示文字：请输入密码
                            NSLog(@"验证失败");
                        }
                        NSLog(@"*****判断机顶盒加锁验证正确与否");
                    }
                        break;
                        
                    default:
                        break;
                        
                }
                
                
                
                
                //  执行第一个MDMM数据命令后，就开始后面的命令执行
                while (nowData_length < data_length) {
                    
                    
                    NSData * next_data_ret = [data subdataWithRange:NSMakeRange(nowData_length + 12,4)];  //判断下一个数据段的
                    //判断下一个数据段的返回结果是否为1，如果是1则报错
                    uint32_t data_retTo32int = [SocketUtils uint32FromBytes:next_data_ret];
                    if (data_retTo32int ==1) {    //此处可以多做欧几次判断，判断socket错误原因
                        
                        [MBProgressHUD showMessag:@"CRC error222" toView:nil];
                    }else
                    {
                        
                        NSData * next_data_model_name = [data subdataWithRange:NSMakeRange(nowData_length + 8,4)];
                        NSString * next_model_name = [[NSString alloc]initWithData:next_data_model_name encoding:NSUTF8StringEncoding];
                        
                        if([next_model_name isEqualToString:@"BEAT"])
                        {
                            //此处是心跳命令
                            nowData_length = 28 + nowData_length;
                            continue;
                        }else if([next_model_name isEqualToString:@"MDMM"])
                        {
                            NSData * next_data2_command_type = [data subdataWithRange:NSMakeRange(36 + nowData_length,1)];
                            uint8_t next_command_type = [SocketUtils uint8FromBytes:next_data2_command_type];
                            
                            switch (next_command_type) {
                                    NSLog(@"next_command_type %d",next_command_type);
                                case 0:
                                {
                                    // 更新了列表
                                    NSLog(@"列表更新了");
                                    
                                    //创建通知
                                    NSNotification *updateNotification =[NSNotification notificationWithName:@"mediaDeliveryUpdateNotific" object:nil userInfo:nil];
                                    //通过通知中心发送通知
                                    [[NSNotificationCenter defaultCenter] postNotification:updateNotification];
                                    
                                }
                                    break;
                                    
                                case 12:
                                {
                                    NSLog(@"playState---== socket 内部内部内部内部正在播放的命令");
                                    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
                                    
                                    //首先获得第二段数据的长度 （52，4）
                                    //======
                                    
                                    NSData * now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //data.length - nowData_length
                                    [userDef setObject:bigDataReduceSmallData forKey:@"data_service11"];
                                    
                                    [userDef synchronize];//把数据同步到本地
                                    
                                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:bigDataReduceSmallData,@"playdata",nil];
                                    
                                    
                                    
                                    //创建通知
                                    NSNotification *notification =[NSNotification notificationWithName:@"notice" object:nil userInfo:dict];
                                    //通过通知中心发送通知
                                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                                }
                                    break;
                                    
                                case 24:
                                {
                                    NSLog(@"playState---== socket 获取IP地址的消息");
                                    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
                                    
                                    //首先获得第二段数据的长度 （52，4）
                                    //======
                                    
                                    NSData * now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //data.length - nowData_length
                                    [userDef setObject:bigDataReduceSmallData forKey:@"data_socketGetIpAddress"];
                                    
                                    [userDef synchronize];//把数据同步到本地
                                    
                                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:bigDataReduceSmallData,@"socketIPAddress",nil];
                                    
                                    
                                    
                                    //创建通知
                                    NSNotification *notification =[NSNotification notificationWithName:@"getSocketIpInfoNotice" object:nil userInfo:dict];
                                    //通过通知中心发送通知
                                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                                    
                                }
                                    break;
                                    
                                case 17:  //此处是获得资源信息
                                {NSLog(@"akjsdbkabdbaskdbakjsbd");
                                    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
                                    
                                    
                                    //--
                                    
                                    //首先获得第二段数据的长度 （52，4）
                                    //======
                                    
                                    NSData * now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //
                                    //--
                                    
                                    
                                    [userDef setObject:bigDataReduceSmallData forKey:@"dataResourceInfo"];
                                    
                                    [userDef synchronize];//把数据同步到本地
                                    
                                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:bigDataReduceSmallData,@"resourceInfoData",nil];
                                    
                                    
                                    
                                    NSString * viewToViewStr = [USER_DEFAULT objectForKey:@"viewTOview"];
                                    if ([viewToViewStr isEqualToString:@"MonitorView_Now"]) { //如果打开的是Monitor页面，则发送通知
                                        
                                        int monitorApperCount ;
                                        NSString * monitorApperCountStr =  [USER_DEFAULT objectForKey:@"monitorApperCountStr"];
                                        monitorApperCount = [monitorApperCountStr intValue];
                                        NSLog(@"monitorApperCount %d",monitorApperCount);
                                        if (monitorApperCount == 0) {
                                            //创建通知
                                            NSNotification *notification =[NSNotification notificationWithName:@"getResourceInfo" object:nil userInfo:dict];
                                            //通过通知中心发送通知
                                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                                            
                                            monitorApperCount = 1;
                                            NSString * monitorApperCountStr1 =  [NSString stringWithFormat:@"%d",monitorApperCount];
                                            [USER_DEFAULT setObject:monitorApperCountStr1 forKey:@"monitorApperCountStr"];
                                        }
                                        else
                                        {
                                            //=====这里有可能报错，因为刚打开应用进入monitor页面的时候，没有创建这个通知
                                            //创建通知
                                            NSNotification *notification1 =[NSNotification notificationWithName:@"getNotificInfoByMySelf" object:nil userInfo:dict];
                                            //通过通知中心发送通知
                                            [[NSNotificationCenter defaultCenter] postNotification:notification1];
                                        }
                                    }
                                    
                                    //这里给device发送数据
                                    NSString * deviceOpenStr = [USER_DEFAULT objectForKey:@"deviceOpenStr"];
                                    if ([deviceOpenStr isEqualToString:@"deviceOpen"]) {
                                        //创建通知
                                        NSNotification *notification =[NSNotification notificationWithName:@"getResourceInfoToDevice" object:nil userInfo:dict];
                                        //通过通知中心发送通知
                                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                                        NSLog(@"akjsdbkabdbaskdbakjsbd11--33");
                                    }
                                    
                                    
                                }
                                    break;
                                case 16:  //此处是停止视频播放
                                {
                                    NSLog(@"*****停止视频播放");
                                }
                                    break;
                                case 8:  //CA 加扰
                                {
                                    NSLog(@"*****此处是CA加扰验证3");
                                    
                                    
                                    
                                    
                                    NSData * now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //data.length - nowData_length  bigDataReduceSmallData代表第二段CA数据长度
                                    
                                    NSData * data_CA_Ret = [bigDataReduceSmallData subdataWithRange:NSMakeRange(37,6)];
                                    
                                    //发送弹窗消息
                                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:data_CA_Ret,@"CAThreedata",nil];
                                    //创建通知
                                    NSNotification *notification =[NSNotification notificationWithName:@"CADencryptNotific" object:nil userInfo:dict];
                                    //通过通知中心发送通知
                                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                                }
                                    break;
                                    
                                case 13:  //此处是验证机顶盒密码
                                {
                                    
                                    NSData * now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //data.length - nowData_length
                                    
                                    
                                    //此处是验证机顶盒密码
                                    NSData * data_STB_Ret = [bigDataReduceSmallData subdataWithRange:NSMakeRange(12,4)];
                                    uint32_t data_STB_Ret_int = [SocketUtils uint32FromBytes:data_STB_Ret];
                                    
                                    if(data_STB_Ret_int == 5) //正确
                                    {
                                        //发送播放命令
                                        //创建通知
                                        NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptVideoTouchNotific" object:nil userInfo:nil];
                                        //通过通知中心发送通知
                                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                                        
                                        //                        STBDencryptVideoTouchNotific
                                        NSLog(@"验证正确");
                                    }else if(data_STB_Ret_int == 6) //验证错误
                                    {
                                        //显示文字：请输入密码
                                        NSLog(@"验证失败");
                                    }
                                    NSLog(@"*****判断机顶盒加锁验证正确与否");
                                }
                                    break;
                                    
                                default:
                                    break;
                            }
                            
                        }
                        
                    }
                    //首先获得第二段数据的长度 （52，4）
                    //                            int now_data_len_place = nowData_length + 24;
                    
                    NSData * now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                    NSLog(@"playstate -==now_data_lengthToInt %d",now_data_lengthToInt);
                    nowData_length = nowData_length + now_data_lengthToInt + 28;
                    
                    
                    
                    
                    
                }
                
                
            }else  //如果相等，则是正常的命令
            {
                
                NSData * data2_command_type = [data subdataWithRange:NSMakeRange(36,1)];
                uint8_t command_type = [SocketUtils uint8FromBytes:data2_command_type];
                
                NSLog(@"command_type:%hhu",command_type);
                
                switch (command_type) {
                        NSLog(@"command_type %d",command_type);
                    case 0:
                    {
                        // 更新了列表
                        NSLog(@"列表更新了");
                        
                        //                    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
                        //                    [userDef setObject:data forKey:@"mediaDeliveryChange"];
                        //
                        //                    [userDef synchronize];//把数据同步到本地
                        //
                        //                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:data,@"mediaDeliveryChange",nil];
                        //
                        
                        
                        //                    //创建通知
                        //                    NSNotification *notification =[NSNotification notificationWithName:@"mediaDeliveryUpdateNotific" object:nil userInfo:nil];
                        //                    //通过通知中心发送通知
                        //                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                        
                        //创建通知
                        NSNotification *updateNotification =[NSNotification notificationWithName:@"mediaDeliveryUpdateNotific" object:nil userInfo:nil];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:updateNotification];
                    }
                        break;
                        
                    case 12:
                    {
                        NSLog(@"playState---== socket 正在播放的命令");
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
                        
                        
                        
                    case 24:
                    {
                        NSLog(@"playState---== socket 获取IP地址的消息");
                        NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
                        [userDef setObject:data forKey:@"data_socketGetIpAddress"];
                        
                        [userDef synchronize];//把数据同步到本地
                        
                        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:data,@"socketIPAddress",nil];
                        
                        
                        
                        //创建通知
                        NSNotification *notification =[NSNotification notificationWithName:@"getSocketIpInfoNotice" object:nil userInfo:dict];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                    }
                        break;
                        
                        
                    case 17:  //此处是获得资源信息
                    {NSLog(@"akjsdbkabdbaskdbakjsbd");
                        NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
                        [userDef setObject:data forKey:@"dataResourceInfo"];
                        
                        [userDef synchronize];//把数据同步到本地
                        
                        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:data,@"resourceInfoData",nil];
                        
                        
                        
                        NSString * viewToViewStr = [USER_DEFAULT objectForKey:@"viewTOview"];
                        if ([viewToViewStr isEqualToString:@"MonitorView_Now"]) { //如果打开的是Monitor页面，则发送通知
                            int monitorApperCount ;
                            NSString * monitorApperCountStr =  [USER_DEFAULT objectForKey:@"monitorApperCountStr"];
                            monitorApperCount = [monitorApperCountStr intValue];
                            NSLog(@"monitorApperCount %d",monitorApperCount);
                            if (monitorApperCount == 0) {
                                //创建通知
                                NSNotification *notification =[NSNotification notificationWithName:@"getResourceInfo" object:nil userInfo:dict];
                                //通过通知中心发送通知
                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                                
                                monitorApperCount = 1;
                                NSString * monitorApperCountStr1 =  [NSString stringWithFormat:@"%d",monitorApperCount];
                                [USER_DEFAULT setObject:monitorApperCountStr1 forKey:@"monitorApperCountStr"];
                            }
                            else
                            {
                                //=====这里有可能报错，因为刚打开应用进入monitor页面的时候，没有创建这个通知
                                //创建通知
                                NSNotification *notification1 =[NSNotification notificationWithName:@"getNotificInfoByMySelf" object:nil userInfo:dict];
                                //通过通知中心发送通知
                                [[NSNotificationCenter defaultCenter] postNotification:notification1];
                            }
                        }
                        
                        //这里给device发送数据
                        NSString * deviceOpenStr = [USER_DEFAULT objectForKey:@"deviceOpenStr"];
                        if ([deviceOpenStr isEqualToString:@"deviceOpen"]) {
                            //创建通知
                            NSNotification *notification1 =[NSNotification notificationWithName:@"getResourceInfoToDevice" object:nil userInfo:dict];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification1];
                            NSLog(@"akjsdbkabdbaskdbakjsbd11--44");
                        }
                        
                        
                    }
                        break;
                    case 16:  //此处是停止视频播放
                    {
                        NSLog(@"*****停止视频播放");
                    }
                        break;
                    case 8:  //CA 加扰
                    {
                        NSLog(@"*****此处是CA加扰验证4");
                        
                        NSData * data_CA_Ret = [data subdataWithRange:NSMakeRange(37 ,6)];
                        
                        //发送弹窗消息
                        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:data_CA_Ret,@"CAThreedata",nil];
                        //创建通知
                        NSNotification *notification =[NSNotification notificationWithName:@"CADencryptNotific" object:nil userInfo:dict];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                    }
                        break;
                    case 13:  //此处是验证机顶盒密码
                    {
                        //此处是验证机顶盒密码
                        NSData * data_STB_Ret = [data subdataWithRange:NSMakeRange(12,4)];
                        uint32_t data_STB_Ret_int = [SocketUtils uint32FromBytes:data_STB_Ret];
                        NSLog(@"data_STB_Ret_int %d",data_STB_Ret_int);
                        if(data_STB_Ret_int == 5) //正确
                        {
                            //发送播放命令
                            //创建通知
                            NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptVideoTouchNotific" object:nil userInfo:nil];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification1];
                            
                            //                        STBDencryptVideoTouchNotific
                            NSLog(@"验证正确");
                        }else if(data_STB_Ret_int == 6) //验证错误
                        {
                            //显示文字：请输入密码
                            NSLog(@"验证失败");
                        }
                        NSLog(@"*****判断机顶盒加锁验证正确与否");
                    }
                        break;
                        
                    default:
                        break;
                        
                }
                
            }
            
            
            
        }
        
        
        
    }
    [self.socket readDataWithTimeout:30 tag:0];
}

@end
