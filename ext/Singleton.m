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
        NSLog(@"sorry the connect is 服务器断开");
        
        [USER_DEFAULT setObject:mediaDisConnect forKey:@"playStateType"];
       
        NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
        //        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
//        NSNotification *notification1 =[NSNotification notificationWithName:@"setMonitorNotHaveNetWorkNotific" object:nil userInfo:nil];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification1];

        
    }
    else if (sock.userData == SocketOfflineByUser) {
        // 如果由用户断开，不进行重连
        NSLog(@"sorry the connect is 用户断开");
        return;
    }
    
}

#pragma  mark - 读取机顶盒传来的数据
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    // 对得到的data值进行解析与转换即可
    
    NSLog(@"读--");
    NSLog(@"%ld",tag);
    NSLog(@"readdata:%@",data);
    //    NSLog(@"playState---== socket 接收到播放命令");
    NSData * data_ret = [[NSData alloc]init];
    if ([data length] >= 12 + 4) {
        data_ret = [data subdataWithRange:NSMakeRange(12,4)];
    }else
    {
        return;
    }
    
    uint32_t data_retTo32int = [SocketUtils uint32FromBytes:data_ret];
    if (data_retTo32int ==1) {    //此处可以多做欧几次判断，判断socket错误原因
        
        [MBProgressHUD showMessag:@"CRC error" toView:nil];
        NSLog(@"CRC error %@",data);
    }
    else{
        
        NSData * data_model_name = [[NSData alloc]init];
        if ([data length] >= 8 + 4) {
             data_model_name = [data subdataWithRange:NSMakeRange(8,4)];
        }else
        {
            return;
        }
        
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
                
                
                while (nowData_length <= data_length - 28) {
                    
                    NSData * next_data_ret = [[NSData alloc]init];
                    if ([data length] >= nowData_length + 12 + 4) {
                        next_data_ret = [data subdataWithRange:NSMakeRange(nowData_length + 12,4)];  //判断下一个数据段的
                    }else
                    {
                        return;
                    }
                    
                    //判断下一个数据段的返回结果是否为1，如果是1则报错
                    uint32_t data_retTo32int = [SocketUtils uint32FromBytes:next_data_ret];
                    if (data_retTo32int ==1) {    //此处可以多做欧几次判断，判断socket错误原因
                        
                        [MBProgressHUD showMessag:@"CRC error111" toView:nil];
                    }else{
                        
                        //判断下一个消息的类型
                        NSData * next_data_model_name = [[NSData alloc]init];
                        if ([data length] >= nowData_length + 8 + 4) {
                            next_data_model_name = [data subdataWithRange:NSMakeRange(nowData_length + 8,4)];
                        }else
                        {
                            return;
                        }
                        
                        NSString * next_model_name = [[NSString alloc]initWithData:next_data_model_name encoding:NSUTF8StringEncoding];
                        
                        if([next_model_name isEqualToString:@"BEAT"])
                        {
                            //此处是心跳命令
                            nowData_length = 28 + nowData_length;
                            continue;
                        }else if([next_model_name isEqualToString:@"MDMM"])
                        {
                            NSData * next_data2_command_type = [[NSData alloc]init];
                            if ([data length] >= nowData_length + 36 + 1) {
                                next_data2_command_type = [data subdataWithRange:NSMakeRange(36 + nowData_length,1)];
                            }else
                            {
                                return;
                            }
                            
                            uint8_t next_command_type = [SocketUtils uint8FromBytes:next_data2_command_type];
                            
                            switch (next_command_type) {
                                    NSLog(@"next_command_type  %d",next_command_type);
                                case 0:
                                {
                                    [self readSocketCommandTypeISZero];
                                }
                                    break;
                                    
                                case 12:
                                {
                                    NSLog(@"playState---== socket 内部内部内部内部正在播放的命令");
                                    
                                    //首先获得第二段数据的长度 （52，4）
                                    //======
                                    
                                    NSData * now_data_length = [[NSData alloc]init];
                                    if ([data length] >= nowData_length + 24 + 4) {
                                        now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    if ([data length] >= nowData_length + 28 + now_data_lengthToInt ) {
                                        bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //data.length - nowData_length
                                    }else
                                    {
                                        return;
                                    }
                                    
                                 
                                    [self readSocketCommandTypeISTwelve:bigDataReduceSmallData];
                                }
                                    break;
                                    
                                case 24:
                                {
                                    NSLog(@"playState---== socket 获取IP地址的消息");
                                    
                                    //首先获得第二段数据的长度 （52，4）
                                    //======
                                    
                                    NSData * now_data_length = [[NSData alloc]init];
                                    if ([data length] >= nowData_length + 24 + 4 ) {
                                         now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    if ([data length] >= nowData_length + 28 + now_data_lengthToInt ) {
                                        bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //data.length - nowData_length
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    
                                    [self readSocketCommandTypeISTwentyFour:bigDataReduceSmallData];
                                    
                                }
                                    break;
                                    
                                case 17:  //此处是获得资源信息
                                {
                                    
                                    //--
                                    
                                    //首先获得第二段数据的长度 （52，4）
                                    //======
                                    
                                    NSData * now_data_length = [[NSData alloc]init];
                                    if ([data length] >= nowData_length + 24 + 4 ) {
                                        now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    if (nowData_length +28+now_data_lengthToInt > data.length) {
                                        //错误,不能大于
                                        return;
                                    }else
                                    {
                                        bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //
                                        
                                      
                                        [self readSocketCommandTypeISSeventeen:bigDataReduceSmallData];

                                        
                                    }
                                    
                                    //--
                                    
                                    
                                }
                                    break;
                                case 16:  //此处是停止视频播放
                                {
                                    NSLog(@"*****停止视频播放");
                                    
                                    [self readSocketCommandTypeISSixteen];
                                    
                                    
                                }
                                    break;
                                case 7:  //CA 加扰发送通知，将弹窗取消掉
                                {
                                    NSLog(@"*****此处是CA加扰取消弹窗");
                                    
                                    //======
                                    //获得数据区的长度
                                    NSData * now_data_length = [[NSData alloc]init];
                                    if ([data length] >= nowData_length + 24 + 4 ) {
                                        NSData * now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    if ([data length] >= nowData_length + 28 + now_data_lengthToInt ) {
                                        bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    //--
                                    
                                    
                                    [self readSocketCommandTypeISSeven:bigDataReduceSmallData];
                                    
                                    
                                }
                                    break;

                                case 8:  //CA 加扰
                                {
                                    NSLog(@"*****此处是CA加扰验证1");
                                    //这里可以获得CA信息
                                    //第一步：获得必要的CA消息
                                    
                                    
                                    
                                    
                                    //======
                                    //获得数据区的长度
                                    NSData * now_data_length = [[NSData alloc]init];
                                    if ([data length] >= nowData_length + 24 + 4) {
                                       now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    if ([data length] >= nowData_length + 28 + now_data_lengthToInt) {
                                        bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //
                                    }else
                                    {
                                        return;
                                    }

                                    
                                    //--
                                    
                                    //此处是验证机顶盒密码，将会这个消息传到TV页面
                                    NSData * data_CA_Ret = [[NSData alloc]init];
                                    if ([bigDataReduceSmallData length] >= 37 + 6) {
                                        data_CA_Ret = [bigDataReduceSmallData subdataWithRange:NSMakeRange(37,6)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    
                                    [self readSocketCommandTypeISEight:data_CA_Ret];

                                    
                                }
                                    break;
                                case 13:  //此处是验证机顶盒密码
                                {
                                    
                                    
                                    //获得数据区的长度
                                    NSData * now_data_length = [[NSData alloc]init];
                                    if ([data length] >= nowData_length + 24 + 4) {
                                        now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    if ([data length] >= nowData_length + 28 + now_data_lengthToInt) {
                                        bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    //--
                                    
                                    //此处是验证机顶盒密码
                                    //在验证机顶盒的时候报的错 这里报错一次（40，4）超过37
                                    //删除掉了nowData_length ，这样就可以防止越界
                                  
                                    [self readSocketCommandTypeISThirteenth:bigDataReduceSmallData];
                                }
                                    break;
                                case 22:  //此处是验证节目列表刷新，机顶盒对节目进行了加锁
                                {
                                    
                                    
                                    //获得数据区的长度
                                    NSData * now_data_length = [[NSData alloc]init];
                                    if ([data length] >= nowData_length + 24 + 4) {
                                        now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    if ([data length] >= nowData_length + 28 + now_data_lengthToInt) {
                                       bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    //--
                                    
                                    //此处是验证节目列表刷新，机顶盒对节目进行了加锁
                                    
                                    
                                    [self readSocketCommandTypeISTwentytwo:bigDataReduceSmallData];
                                }
                                    break;
                                    
                                default:
                                    break;
                            }
                        }
                        
                    }
                    //首先获得第二段数据的长度 （52，4）
                    //                            int now_data_len_place = nowData_length + 24;
                    NSData * now_data_length = [[NSData alloc]init];
                    if ([data length] >= nowData_length + 24 + 4) {
                        now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                    }else
                    {
                        return;
                    }
                    
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
            
            uint32_t MDMM_Data_Length;
            if(data.length >= 24 + 4)
            {
             MDMM_Data_Length = [SocketUtils uint32FromBytes:[data subdataWithRange:NSMakeRange( 24,4)]];   //第一段数据区总长度
            }else{
                return;
            }
            
            
            if (data_length > 28 + MDMM_Data_Length ) {  //如果总数据长度大于第一段数据的长度
                //证明还有其他的信息，MDMM信息和心跳都在一起了
                int nowData_length;
                nowData_length = 28 + MDMM_Data_Length;
                //--先执行第一个命令
                NSData * data2_command_type = [[NSData alloc]init];
                if ([data length] >= 36 + 1) {
                   data2_command_type = [data subdataWithRange:NSMakeRange(36,1)];
                }else
                {
                    return;
                }
                
                uint8_t command_type = [SocketUtils uint8FromBytes:data2_command_type];
                
                NSLog(@"command_type:%hhu",command_type);
                
                switch (command_type) {   //这里代表第一段的MDMM，所以不需要加nowData_length
                        NSLog(@"command_type %d",command_type);
                    case 0:
                    {
                        [self readSocketCommandTypeISZero];
                        
                    }
                        break;
                        
                    case 12:
                    {
                        NSLog(@"playState---== socket 正在播放的命令");
                        [self readSocketCommandTypeISTwelve:data];

                    }
                        break;
                        
                    case 24:
                    {
                        NSLog(@"playState---== socket 获取IP地址的消息");
                        
                        [self readSocketCommandTypeISTwentyFour:data];

                    }
                        break;
                        
                    case 17:  //此处是获得资源信息
                    {
                        
                        [self readSocketCommandTypeISSeventeen:data];
                        
                    }
                        break;
                    case 16:  //此处是停止视频播放
                    {
                        NSLog(@"*****停止视频播放");
                        
                        [self readSocketCommandTypeISSixteen];
                    }
                        break;
                    case 7:  //CA 加扰发送通知，将弹窗取消掉
                    {
                       
                        NSLog(@"*****CA 加扰发送通知，将弹窗取消掉");
                        
                        [self readSocketCommandTypeISSeven:data];
                        
                        
                    }
                        break;
                    case 8:  //CA 加扰
                    {
                        NSLog(@"*****此处是CA加扰验证2");
                        //这里可以获得CA信息
                        //第一步：获得必要的CA消息
                        //此处是验证机顶盒密码，将会这个消息传到TV页面
                        NSData * data_CA_Ret = [[NSData alloc]init];
                        if ([data length] >= 37 + 6) {
                        data_CA_Ret = [data subdataWithRange:NSMakeRange(37 ,6)];
                        }else
                        {
                            return;
                        }
                        
                        
                        [self readSocketCommandTypeISEight:data_CA_Ret];
                        
                    }
                        break;
                    case 13:  //此处是验证机顶盒密码
                    {
                        //此处是验证机顶盒密码
                       
                        [self readSocketCommandTypeISThirteenth:data];
                    }
                        break;
                    case 22:  //此处是验证节目列表刷新，机顶盒对节目进行了加锁
                    {
                        NSLog(@" 此处是验证节目列表刷新，机顶盒对节目进行了加锁");
                        
                        NSData * data_channel_service = [[NSData alloc]init];
                        if ([data length] >= 51) {
                            data_channel_service = [data subdataWithRange:NSMakeRange(0 ,51)];
                        }else
                        {
                            return;
                        }
                        
                        [self readSocketCommandTypeISTwentytwo:data_channel_service];
                    }
                        break;
                        
                    default:
                        break;
                        
                }
                
                
                
                
                //  执行第一个MDMM数据命令后，就开始后面的命令执行
                while (nowData_length < data_length) {
                    
                    
                    NSData * next_data_ret = [[NSData alloc]init];
                    if ([data length] >= nowData_length + 12 + 4) {
                         next_data_ret = [data subdataWithRange:NSMakeRange(nowData_length + 12,4)];  //判断下一个数据段的
                    }else
                    {
                        return;
                    }
                    
                    //判断下一个数据段的返回结果是否为1，如果是1则报错
                    uint32_t data_retTo32int = [SocketUtils uint32FromBytes:next_data_ret];
                    if (data_retTo32int ==1) {    //此处可以多做欧几次判断，判断socket错误原因
                        
                        [MBProgressHUD showMessag:@"CRC error222" toView:nil];
                    }else
                    {
                        
                        NSData * next_data_model_name = [[NSData alloc]init];
                        if ([data length] >= nowData_length + 8 + 4) {
                            next_data_model_name = [data subdataWithRange:NSMakeRange(nowData_length + 8,4)];
                        }else
                        {
                            return;
                        }
                        
                        NSString * next_model_name = [[NSString alloc]initWithData:next_data_model_name encoding:NSUTF8StringEncoding];
                        
                        if([next_model_name isEqualToString:@"BEAT"])
                        {
                            //此处是心跳命令
                            nowData_length = 28 + nowData_length;
                            continue;
                        }else if([next_model_name isEqualToString:@"MDMM"])
                        {
                            NSData * next_data2_command_type = [[NSData alloc]init];
                            if ([data length] >= 36 + nowData_length + 1) {
                                next_data2_command_type = [data subdataWithRange:NSMakeRange(36 + nowData_length,1)];
                            }else
                            {
                                return;
                            }
                            
                            uint8_t next_command_type = [SocketUtils uint8FromBytes:next_data2_command_type];
                            
                            switch (next_command_type) {
                                    NSLog(@"next_command_type %d",next_command_type);
                                case 0:
                                {
                                    // 更新了列表
                                    NSLog(@"列表更新了");
                                    
                                    [self readSocketCommandTypeISZero];
                                    
                                }
                                    break;
                                    
                                case 12:
                                {
                                    NSLog(@"playState---== socket 内部内部内部内部正在播放的命令");
                                    
                                    //首先获得第二段数据的长度 （52，4）
                                    //======
                                    
                                    NSData * now_data_length = [[NSData alloc]init];
                                    if ([data length] >=  nowData_length + 28) {
                                         now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    if ([data length] >=  nowData_length + 28 + now_data_lengthToInt) {
                                        bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //data.length - nowData_length
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    [self readSocketCommandTypeISTwelve:bigDataReduceSmallData];

                                }
                                    break;
                                    
                                case 24:
                                {
                                    NSLog(@"playState---== socket 获取IP地址的消息");
                                    
                                    //首先获得第二段数据的长度 （52，4）
                                    //======
                                    
                                    NSData * now_data_length = [[NSData alloc]init];
                                    if ([data length] >=  nowData_length + 28) {
                                        now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    if ([data length] >=  nowData_length + 28 + now_data_lengthToInt) {
                                        bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //data.length - nowData_length
                                    }else
                                    {
                                        return;
                                    }
                                    
                                  
                                    [self readSocketCommandTypeISTwentyFour:bigDataReduceSmallData];
                                    
                                }
                                    break;
                                    
                                case 17:  //此处是获得资源信息
                                {
                                  
                                    //--
                                    
                                    //首先获得第二段数据的长度 （52，4）
                                    //======
                                    
                                    NSData * now_data_length = [[NSData alloc]init];
                                    if ([data length] >=  nowData_length + 28 ) {
                                       now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSLog(@"在这里越界了");
                                    
                                    if (28 + now_data_lengthToInt + nowData_length > data.length) {
                                        NSLog(@"可能scocket数据传输错误了");
                                        return;
                                    }else
                                    {
                                        NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                        if ([data length] >=  nowData_length + 28 + now_data_lengthToInt ) {
                                            bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //
                                            //--
                                        }else
                                        {
                                            return;
                                        }
                                        
                                        
                                        
                                        
                                        [self readSocketCommandTypeISSeventeen:bigDataReduceSmallData];
                                        

                                    }
                                    
                                    
                                }
                                    break;
                                case 16:  //此处是停止视频播放
                                {
                                    NSLog(@"*****停止视频播放");
                                    
                                    [self readSocketCommandTypeISSixteen];
                                }
                                    break;
                                case 7:  //CA 加扰发送通知，将弹窗取消掉
                                {
                                    
                                    NSLog(@"*****CA 加扰发送通知，将弹窗取消掉");
                                    
                                    
                                    
                                    
                                    NSData * now_data_length = [[NSData alloc]init];
                                    if ([data length] >=  nowData_length + 28  ) {
                                       now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                        //--
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    if ([data length] >=  nowData_length + 28 + now_data_lengthToInt) {
                                        bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )];                                     }else
                                    {
                                        return;
                                    }
                                    
                                    
                                    [self readSocketCommandTypeISSeven:bigDataReduceSmallData];
                                    
                                    
                                }
                                    break;
                                case 8:  //CA 加扰
                                {
                                    NSLog(@"*****此处是CA加扰验证3");
                                    
                                    
                                    
                                    
                                    NSData * now_data_length = [[NSData alloc]init];
                                    if ([data length] >=  nowData_length + 28 ) {
                                         now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    
                                    }else
                                    {
                                            return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    
                                    if ([data length] >=  nowData_length + 28 + now_data_lengthToInt ) {
                                      
                                        bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //data.length - nowData_length  bigDataReduceSmallData代表第二段CA数据长度
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    
                                    NSData * data_CA_Ret = [[NSData alloc]init];
                                    
                                    if ([bigDataReduceSmallData length] >=  37 +6 ) {
                                        
                                        data_CA_Ret = [bigDataReduceSmallData subdataWithRange:NSMakeRange(37,6)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    
                                    [self readSocketCommandTypeISEight:data_CA_Ret];
                                }
                                    break;
                                    
                                case 13:  //此处是验证机顶盒密码
                                {
                                    
                                    NSData * now_data_length = [[NSData alloc]init];
                                    
                                    if ([data length] >=  nowData_length + 24 + 4 ) {
                                        
                                        now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    //======
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    
                                    if ([data length] >=  nowData_length + 28 + now_data_lengthToInt  ) {
                                        
                                       bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //data.length - nowData_length
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    
                                    
                                    [self readSocketCommandTypeISThirteenth:bigDataReduceSmallData];
                                }
                                    break;
                                case 22:  //此处是验证节目列表刷新，机顶盒对节目进行了加锁
                                {
                                    
                                    
                                    //获得数据区的长度
                                    NSData * now_data_length = [[NSData alloc]init];
                                    
                                    if ([data length] >=  nowData_length + 28   ) {
                                        
                                        now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                                    
                                    NSData * bigDataReduceSmallData = [[NSData alloc]init];
                                    //获得数据区的长度
                                    
                                    if ([data length] >=  nowData_length + 28 + now_data_lengthToInt) {
                                        
                                        bigDataReduceSmallData =[data subdataWithRange:NSMakeRange(nowData_length , 28 + now_data_lengthToInt )]; //
                                        //--
                                    }else
                                    {
                                        return;
                                    }
                                    
                                    
                                    //此处是验证节目列表刷新，机顶盒对节目进行了加锁
                                    
                                    
                                    [self readSocketCommandTypeISTwentytwo:bigDataReduceSmallData];
                                }
                                    break;
                                default:
                                    break;
                            }
                            
                        }
                        
                    }
                    //首先获得第二段数据的长度 （52，4）
                    //                            int now_data_len_place = nowData_length + 24;
                    
                    NSData * now_data_length = [[NSData alloc]init];
                    //获得数据区的长度
                    
                    if ([data length] >=  nowData_length + 28 ) {
                        
                         now_data_length = [data subdataWithRange:NSMakeRange(nowData_length + 24,4)];
                    }else
                    {
                        return;
                    }
                    
                    uint32_t now_data_lengthToInt = [SocketUtils uint32FromBytes:now_data_length];
                    NSLog(@"playstate -==now_data_lengthToInt %d",now_data_lengthToInt);
                    nowData_length = nowData_length + now_data_lengthToInt + 28;
                    
                    
                    
                    
                    
                }
                
                
            }else  //如果相等，则是正常的命令
            {
                
                NSData * data2_command_type = [[NSData alloc]init];
                //获得数据区的长度
                
                if ([data length] >=  37) {
                    
                     data2_command_type = [data subdataWithRange:NSMakeRange(36,1)];
                }else
                {
                    return;
                }
                
                uint8_t command_type = [SocketUtils uint8FromBytes:data2_command_type];
                
                NSLog(@"command_type:%hhu",command_type);
                
                switch (command_type) {
                        NSLog(@"command_type %d",command_type);
                    case 0:
                    {
                        [self readSocketCommandTypeISZero];
                    }
                        break;
                        
                    case 12:
                    {
                        NSLog(@"playState---== socket 正在播放的命令");
                      
                        [self readSocketCommandTypeISTwelve:data];
                    }
                        break;
                        
                        
                        
                    case 24:
                    {
                        NSLog(@"playState---== socket 获取IP地址的消息");
                     
                        [self readSocketCommandTypeISTwentyFour:data];
                    }
                        break;
                        
                        
                    case 17:  //此处是获得资源信息
                    {
                       
                        [self readSocketCommandTypeISSeventeen:data];
                        
                    }
                        break;
                    case 16:  //此处是停止视频播放
                    {
                        NSLog(@"*****停止视频播放");
                        
                        [self readSocketCommandTypeISSixteen];
                    }
                        break;
                    case 7:  //CA 加扰发送通知，将弹窗取消掉
                    {
                        
                        NSLog(@"*****CA 加扰发送通知，将弹窗取消掉");
                        
                        [self readSocketCommandTypeISSeven:data];
                        
                        
                    }
                        break;
                    case 8:  //CA 加扰
                    {
                        NSLog(@"*****此处是CA加扰验证4");
                        
                        NSData * data_CA_Ret = [[NSData alloc]init];
                        //获得数据区的长度
                        
                        if ([data length] >=  43) {
                            
                            data_CA_Ret = [data subdataWithRange:NSMakeRange(37 ,6)];
                        }else
                        {
                            return;
                        }
                        
                        
                        [self readSocketCommandTypeISEight:data_CA_Ret];
                    }
                        break;
                    case 13:  //此处是验证机顶盒密码
                    {
                        //此处是验证机顶盒密码
                        
                        [self readSocketCommandTypeISThirteenth:data];
                    }
                        break;
                    case 22:  //此处是验证节目列表刷新，机顶盒对节目进行了加锁
                    {
                        //此处是验证机顶盒密码
                        
                        [self readSocketCommandTypeISTwentytwo:data];
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
#pragma  mark -对socket读取文件进行操作
//对socket读取文件进行操作   case = 0
-(void)readSocketCommandTypeISZero
{
    // 更新了列表
    NSLog(@"列表更新了");
    //        mediaDeliveryUpdateNotific
    
    //创建通知
    NSNotification *updateNotification =[NSNotification notificationWithName:@"mediaDeliveryUpdateNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:updateNotification];
}

//对socket读取文件进行操作   case = 12
-(void)readSocketCommandTypeISTwelve :(NSData *)dataToOperate
{
    uint32_t dataLengthForUrl;
    NSData * dataForDataLength;
    if ([dataToOperate length] >=  28) {
        
        dataForDataLength = [dataToOperate subdataWithRange:NSMakeRange(24,4)];
        dataLengthForUrl = [SocketUtils uint32FromBytes:dataForDataLength];
        
        NSLog(@" dataLengthForUrl %d",dataLengthForUrl);
        
        
    }else
    {
        return;
    }
    
    if ([dataToOperate length] >=  dataLengthForUrl) {
        
        dataToOperate = [dataToOperate subdataWithRange:NSMakeRange(0,dataLengthForUrl + 28)];
        
        NSLog(@" dataToOperate ==  %@",dataToOperate);
        
    }else
    {
        return;
    }
    
    
    
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    [userDef setObject:dataToOperate forKey:@"data_service11"];
    
    [userDef synchronize];//把数据同步到本地
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:dataToOperate,@"playdata",nil];
    
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"notice" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//对socket读取文件进行操作   case = 24
-(void)readSocketCommandTypeISTwentyFour :(NSData *)dataToOperate
{
    
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    [userDef setObject:dataToOperate forKey:@"data_socketGetIpAddress"];
    
    [userDef synchronize];//把数据同步到本地
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:dataToOperate,@"socketIPAddress",nil];
    
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"getSocketIpInfoNotice" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//对socket读取文件进行操作   case = 7
-(void)readSocketCommandTypeISSeven :(NSData *)dataToOperate
{
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:dataToOperate,@"CARemovePopThreedata",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"ChangeCALockNotific" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//对socket读取文件进行操作   case = 8
-(void)readSocketCommandTypeISEight :(NSData *)dataToOperate
{
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:dataToOperate,@"CAThreedata",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"CADencryptNotific" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//对socket读取文件进行操作   case = 17
-(void)readSocketCommandTypeISSeventeen :(NSData *)dataToOperate
{
    
    NSUserDefaults *userDef=USER_DEFAULT;//这个对象其实类似字典，着也是一个单例的例子
    
    
    
    [userDef setObject:dataToOperate forKey:@"dataResourceInfo"];
    
    [userDef synchronize];//把数据同步到本地
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:dataToOperate,@"resourceInfoData",nil];
    
    
    
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
    
//    //这里给device发送数据
//    NSString * deviceOpenStr = [USER_DEFAULT objectForKey:@"deviceOpenStr"];
//    if ([deviceOpenStr isEqualToString:@"deviceOpen"]) {
//        //创建通知
//        NSNotification *notification =[NSNotification notificationWithName:@"getResourceInfoToDevice" object:nil userInfo:dict];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//        NSLog(@"akjsdbkabdbaskdbakjsbd11--33");
//    }
//    
    
}


//对socket读取文件进行操作   case = 13
-(void)readSocketCommandTypeISThirteenth :(NSData *)dataToOperate
{
    
    //此处是验证机顶盒密码
    NSData * data_STB_Ret = [[NSData alloc]init];
    //获得数据区的长度
    
    if ([dataToOperate length] >=  16) {
        
        data_STB_Ret = [dataToOperate subdataWithRange:NSMakeRange(12,4)];
    }else
    {
        return;
    }
    
    uint32_t data_STB_Ret_int = [SocketUtils uint32FromBytes:data_STB_Ret];
    
    NSLog(@" dataToOperate %@",dataToOperate);
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
        
        NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptFailedNotific" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
        
        //显示文字：请输入密码
        NSLog(@"验证失败");
    }
    NSLog(@"*****判断机顶盒加锁验证正确与否");
}

//对socket读取文件进行操作   case = 22
-(void)readSocketCommandTypeISTwentytwo :(NSData *)dataToOperate
{
    
//    //此处是验证机顶盒密码
//    NSData * data_STB_Ret = [dataToOperate subdataWithRange:NSMakeRange(12,4)];
//    uint32_t data_STB_Ret_int = [SocketUtils uint32FromBytes:data_STB_Ret];
    
    NSLog(@"输出data：%@",dataToOperate);
    NSLog(@"输出data2222");

    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:dataToOperate,@"changeLockData",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"ChangeSTBLockNotific" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    NSLog(@"*****机顶盒改变节目的加锁状态");
}

//对socket读取文件进行操作   case = 16
-(void)readSocketCommandTypeISSixteen  //停止视频分发
{
    //盒子主动停掉后，需要注意页面跳转会造成视频重新播放从而激活。所以如果视频播放了，我们要禁止跳转界面重新播放
    //发送通知方法，把视频播放停止掉后，禁止加载圈，显示断开分发的提示语
    [USER_DEFAULT setObject:@"stopDelivery" forKey:@"deliveryPlayState"];
    
    //case 19 返回OK
    
    
   
}
@end
