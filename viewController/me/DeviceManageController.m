////
////  DeviceManageController.m
////  StarAPP
////
////  Created by xyz on 2016/11/9.
////
////
//
//#import "DeviceManageController.h"
//#import "DeviceManageCell.h"
//#import "UIButton+EnlargeTouchArea.h"
//@interface DeviceManageController ()
//{
//    NSInteger   tunerNum;
//    NSInteger   livePlayCount;
//    NSInteger   liveRecordCount;
//    NSInteger   liveTimeShiteCount;
//    NSInteger   deliveryCount;
//    NSInteger   pushVodCount;
//    
//    
//    MBProgressHUD * HUD;
//    UIView *  netWorkErrorView;
//    NSTimer *  refreshTimer ;  //定时刷新，暂定时间5秒
////    BOOL tempBool1;
////    BOOL tempBool2;
//    
//}
//
//@property (nonatomic, strong) UITableView *table;
//
//@property (nonatomic, strong) NSArray *dataSource;
//
//@end
//
//@implementation DeviceManageController
//@synthesize avController;
//@synthesize cgUpnpModel;
//@synthesize scrollView;
//@synthesize avCtrl;
//@synthesize isDmsNum;
//
//@synthesize TVLiveVerticalImg;
//@synthesize TimeShiftVerticalImg;
//@synthesize RecoderVerticalImg;
//@synthesize DistributeVerticalImg;
//@synthesize HistogramImage;
//@synthesize nameLab;
//@synthesize isRefreshScroll; //是否需要刷新
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.title = @"Equipment management";
//    
//    [super viewDidLoad];
//    
//    isRefreshScroll = YES;
//    
//    self.dataSource = [NSArray array];
//    avCtrl = [[CGUpnpAvController alloc] init];    ///进行搜索的对象
//    avCtrl.delegate = self;
//    
//    [self loadNav];
//    //    [self loadScroll];
//    self.timer =   [NSTimer scheduledTimerWithTimeInterval:500000 target:self selector:@selector(viewWillAppear:) userInfo:nil repeats:YES];
//    
//    NSLog(@"Device viewDidLoad");
//    
////    [self linkSocket];
//    //    [self newNoticficRefreshDLNA];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tabBarController.tabBar.hidden = YES;
//    [self setIPNoific];  //检测IP改变
//}
//
//-(void)newNoticficRefreshDLNA
//{
//    //////////////////////////// 从socket返回数据
//    //此处销毁通知，防止一个通知被多次调用
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshDlNATable" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDlNATable) name:@"refreshDlNATable" object:nil];
//    
//}
//-(void)refreshDlNATable
//{
//    [self viewWillAppear:YES];
//}
//
////-(void)getCGData
////{
////    //如果有数据则直接展示
////    NSArray * DmsArr = [USER_DEFAULT objectForKey:@"DmsDevice"];
////    if (DmsArr) {
////        self.dataSource = DmsArr;
////    }
////
////    dispatch_async(dispatch_get_global_queue(0, 0), ^{
////        // 处理耗时操作的代码块...
////        //搜索
////
////        [avCtrl search];
////        self.avController = avCtrl;
////        //通知主线程刷新
////        NSLog(@"Device dispatch1");
////        dispatch_async(dispatch_get_main_queue(), ^{
////            //回调或者说是通知主线程刷新，
//////            [self loadScroll];
////
//////            [self loadUI];
////            [self viewWillAppear:YES];
////            NSLog(@"Device dispatch2");
////        });
////
////    });
////}
//
//-(void)getNotificInfo
//{
//    tunerNum = 0; ///******
//    //    [monitorTableArr removeAllObjects];
//    livePlayCount = 0;
//    liveRecordCount = 0;
//    liveTimeShiteCount = 0;
//    deliveryCount = 0;
//    pushVodCount = 0;
//    
//    
//    //    livePlayCount = 9;
//    //    liveRecordCount = 4;
//    //    liveTimeShiteCount = 2;
//    //    deliveryCount = 1;
//    //    pushVodCount = 0;
//    
//    NSLog(@"=======================notific");
//    
//    
//    
//    //////////////////////////// 从socket返回数据
//    //此处销毁通知，防止一个通知被多次调用
////    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getResourceInfo" object:nil];
////    //注册通知
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfo:) name:@"getResourceInfo" object:nil];
//    
//    [USER_DEFAULT  setObject:@"deviceOpen" forKey:@"deviceOpenStr"];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getResourceInfoToDevice" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfoToDevice:) name:@"getResourceInfoToDevice" object:nil];
//    
//    
//    //////////////////////////// 向TV页面发送通知
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    
//    //    [USER_DEFAULT objectForKey:@"CICHUSHIDIC"];
//    //    NSLog(@"此处是返回：%@", [USER_DEFAULT objectForKey:@"CICHUSHIDIC"]);
//    
//   
//    
//}
//-(void)refreshViewByJudgeData    //通过获得一次tuner消息，判断tuner消息是不是发生了变化
//{
//    //1.发送消息
//    //2.判断
//    [self  getNotificInfoByMySelf]; // 发送消息给TV页面，然后通过TV页面传通知发送tuner的socket信息
//    
//}
//-(void)getNotificInfoByMySelf   //随后每隔一段时间或者打开这个页面的时候获取tuner信 BYMYSelf
//{
//    [USER_DEFAULT  setObject:@"deviceOpen" forKey:@"deviceOpenStr"];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getResourceInfoToDevice" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfoToDeviceBySelf:) name:@"getResourceInfoToDevice" object:nil];
//    
//    
//    //////////////////////////// 向TV页面发送通知
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    
//    
//}
//-(void)getResourceInfoToDeviceBySelf:(NSNotification *)text
//{
////对数据做判断，看是不是刷新了数据
//    NSData * retData = [[NSData alloc]init];
//    retData = text.userInfo[@"resourceInfoData"];    //返回的data
//    
//    
//    //获取temp数据的tuner数据
//    NSData * dataTemp = [USER_DEFAULT objectForKey:@"retDataTemp"];
//    NSData * dataTempValue = [self dataToValueData:dataTemp];
//    
//    //获取Now 数据的tuner数据
//    NSData * dataNowValue = [self dataToValueData:retData];
//    
//    if ([dataTempValue isEqualToData:dataNowValue] ) {
//        //次时数据是一样的，则不刷新
//        NSLog(@"此时数据是一样的，则不刷新");
//    }else
//    {
//        [self getNotificInfo];
//    }
//   
//    
//}
//-(NSData*)dataToValueData:(NSData *)olddata
//{
//    //获取数据总长度
//    NSData * dataLenTemp = [[NSData alloc]init];
//    dataLenTemp = [olddata subdataWithRange:NSMakeRange(24, 4)];
//    
//    NSLog(@"dataLenTemp: %@",dataLenTemp);
//    //    int value;
//    //    [dataLen getBytes: &value length: sizeof(value)];   //获取总长度
//    uint8_t valueTemp = [SocketUtils uint32FromBytes:dataLenTemp];   //获取总长度
//    NSLog(@"value: %d",valueTemp);
//    
//    //    [socketUtils uint16FromBytes:]
//    //tuner的有效数据区
//    NSData * effectiveDataTemp = [[NSData alloc]init];
//    effectiveDataTemp = [olddata subdataWithRange:NSMakeRange(38,(valueTemp-10))];
//
//    return effectiveDataTemp;
//}
//-(void)getResourceInfoToDevice:(NSNotification *)text
//{   NSLog(@"他会执行很多次，因为有monitor页面的通知");
//    NSLog(@"akjsdbkabdbaskdbakjsbd11la");
//    NSLog(@"moni:%@",text.userInfo[@"resourceInfoData"]);
//    NSLog(@"此处是socket返回");
//    
//    NSData * retData = [[NSData alloc]init];
//    retData = text.userInfo[@"resourceInfoData"];    //返回的data
//    //        [self getTunerNum:retData];  //获得总的tuner的数量
//    [self getEffectiveData:retData];//获得有效数据的信息，不同tuner的信息
//    [USER_DEFAULT setObject:retData forKey:@"retDataTemp"]; //每次存储上一次获取的信息作比较，如果不同则刷新
//    
//}
////获得有效数据的信息，不同tuner的信息
//-(void)getEffectiveData:(NSData *) allTunerData
//{
//    [self initData];
//    NSLog(@"=======================test gettuner");
//    //获取数据总长度
//    NSData * dataLen = [[NSData alloc]init];
//    dataLen = [allTunerData subdataWithRange:NSMakeRange(24, 4)];
//    
//    NSLog(@"datalen: %@",dataLen);
////    int value;
////    [dataLen getBytes: &value length: sizeof(value)];   //获取总长度
//    uint8_t value = [SocketUtils uint32FromBytes:dataLen];   //获取总长度
//    NSLog(@"value: %d",value);
//    
//    //    [socketUtils uint16FromBytes:]
//    //tuner的有效数据区
//    NSData * effectiveData = [[NSData alloc]init];
//    effectiveData = [allTunerData subdataWithRange:NSMakeRange(38,(value-10))];
//    
//    //定位数据，用于看位于第几个字节，起始位置是在
//    int placeFigure = 3;
//    for (int ai = 0; ai < 11; ai++ ) {  //目前会返回11条数据
//        
//        
//        //       NSMutableData * tunerDataone = [NSMutableData dataWithData:allTunerData];
//        int mutablefigure = placeFigure;
//        NSLog(@"----len placeFigure:%d",placeFigure);
//        NSLog(@"----len mutablefigure:%d",mutablefigure);
//        NSLog(@"----len effectiveData:%@",effectiveData);
//        //        char buffer;
//        //        [effectiveData getBytes:&buffer range:NSMakeRange(mutablefigure, 4)];
//        
//        NSData * databuff = [effectiveData subdataWithRange:NSMakeRange(mutablefigure, 4)];
//        //        Byte *buffer = (Byte *)[databuff bytes];
//        
//        char buffer1;
//        int buffer_int1 =placeFigure;
//        [effectiveData getBytes:&buffer1 range:NSMakeRange(buffer_int1, 1)];
//        char buffer2;
//        int buffer_int2 =placeFigure+1;
//        [effectiveData getBytes:&buffer2 range:NSMakeRange(buffer_int2, 1)];
//        char buffer3;
//        int buffer_int3 =placeFigure+2;
//        [effectiveData getBytes:&buffer3 range:NSMakeRange(buffer_int3, 1)];
//        char buffer4;
//        int buffer_int4 =placeFigure+3;
//        [effectiveData getBytes:&buffer4 range:NSMakeRange(buffer_int4, 1)];
//        
//        if( buffer1 == 0x00 && buffer2 == 0x00&& buffer3 == 0x00 && buffer4 == 0x00)
//        {
//            NSLog(@"11");
//        }
//        else
//        {
//            
//            tunerNum ++;
//            NSLog(@"22");
//            
//            //这里获取service_type类型
//            NSData * serviceTypeData = [[NSData alloc]init];
//            serviceTypeData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+4, 4)];
//            //这里获取network_id
//            NSData * networkIdData = [[NSData alloc]init];
//            networkIdData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+12, 2)];
//            //这里获取ts_id
//            NSData * tsIdData = [[NSData alloc]init];
//            tsIdData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+14, 2)];
//            
//            //这里获取service_id
//            NSData * serviceIdData = [[NSData alloc]init];
//            serviceIdData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+16, 2)];
//            //这里获取name_len
//            NSData * nameLenData = [[NSData alloc]init];
//            nameLenData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+18, 1)];
//            
//            //先看一下长度是不是0
//            char lenBuffer;
//            [nameLenData getBytes: &lenBuffer length: sizeof(lenBuffer)];
//            
//            int clientNameLen = 0;
//            NSData * clientNameData = [[NSData alloc]init];
//            if (lenBuffer == 0x00) {
//                
//                NSString *aString = @"";
//                clientNameData = [aString dataUsingEncoding: NSUTF8StringEncoding];
//            }else
//            {
//                
//                [nameLenData getBytes: &clientNameLen length: sizeof(clientNameLen)];
//                
//                int clienNameLenCopy = clientNameLen;
//                int clienNameLenCopy1 = clientNameLen;
//                
//                //获取client_name
//                
//                clientNameData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+18+1, clienNameLenCopy1)];
//            }
//            
//            
//            
//            
//            
//            
//            //            //此处做判断，看一下属于哪个tuner
//            //            TVhttpDic =  [USER_DEFAULT objectForKey:@"TVHttpAllData"];
//            //            NSArray * category1 = [TVhttpDic objectForKey:@"category"];
//            //            NSArray * service1 = [TVhttpDic objectForKey:@"service"];
//            
//            
//            //            for (int a = 0; a <service1.count ; a++) {
//            //                //原始数据
//            //                NSString * service_network =  [service1[a]objectForKey:@"service_network_id"];
//            //                NSString * service_ts =  [service1[a] objectForKey:@"service_ts_id"];
//            //                NSString * service_service =  [service1[a] objectForKey:@"service_service_id"];
//            //                NSString * service_tuner =  [service1[ai] objectForKey:@"service_tuner_mode"];
//            //
//            //
//            //                //                //新的数据
//            //                NSString * newservice_network = [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: networkIdData]]; //[[NSString alloc]initWithData:networkIdData encoding:NSUTF8StringEncoding];
//            //
//            //
//            //                NSString * newservice_ts =   [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: tsIdData]];//[[NSString alloc]initWithData:tsIdData encoding:NSUTF8StringEncoding];
//            //                NSString * newservice_service = [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: serviceIdData]];
//            //
//            //                if ([service_network isEqualToString:newservice_network] && [service_ts isEqualToString:newservice_ts]  && [service_service isEqualToString:newservice_service]  //&& [service_tuner isEqualToString:newservice_tunertype]
//            //                    ) {
//            //
//            //                    //这种情况下是找到了节目
//            //                    NSArray * arr_threeData =[ [NSArray alloc]initWithObjects:service1[a],serviceTypeData,clientNameData, nil];
//            //
//            //                    [monitorTableArr addObject:arr_threeData];  //把展示节目列表添加到数组中，用于展示
//            //
//            //
//            //                    [self.tableView reloadData];
//            //                }
//            //                else //此处是一种特殊情况，没有找到这个节目
//            //                {
//            //                    [self.tableView reloadData];
//            //                }
//            //
//            //            }
//            
//            
//            
//            //判断service_typedata,判断是不是分发，时移，录制
//            [self judgeTunerClass:serviceTypeData ];//flag:tempBool1];
//            
//            ////
//            placeFigure  = placeFigure + 15+clientNameLen;
//        }
//        
//        //        int mutablefigure = ai;
//        //        mutablefigure = mutablefigure*7;
//        placeFigure =placeFigure +7;  //placeFigure+ mutablefigure ;
//        
//    }
//    
//    //    [self loadNav];
//    //    [self loadUI];
//    
//    //    [self loadCicle];
//    //    [self loadTableview];
//    //    [self loadNumLab];
//    
//    //    if (tableInitNum == 0) {
//    //        [self loadTableview];
//    //        tableInitNum++;
//    //
//    //    }
//    //    else
//    //    {
//    //     [tableView reloadData];
//    //    }
//    
//    //    [tableView reloadData];
//    //    [self loadTableview];
//    [self changeView];
//}
//
//-(void)changeView
//{
//    NSLog(@"livePlayCount %d",livePlayCount);
//    NSLog(@"livePlayCount %d",liveTimeShiteCount);
//    NSLog(@"livePlayCount %d",liveRecordCount);
//    NSLog(@"livePlayCount %d",deliveryCount);
//    NSLog(@"livePlayCount %d",tunerNum);
//    TVLiveVerticalImg.frame = CGRectMake(0.105*HistogramImage.frame.size.width, 84/2+10.5*(9-livePlayCount), 12.5, 10.5*livePlayCount);
//    
//    
//    
//    
//    TimeShiftVerticalImg.frame = CGRectMake(0.248*HistogramImage.frame.size.width, 84/2+10.5*(9-liveTimeShiteCount), 12.5, 10.5*liveTimeShiteCount);
//    
//    
//    
//    RecoderVerticalImg.frame = CGRectMake(0.388*HistogramImage.frame.size.width, 84/2+10.5*(9-liveRecordCount), 12.5, 10.5*liveRecordCount);
//    
//    
//    
//    DistributeVerticalImg.frame = CGRectMake(0.530*HistogramImage.frame.size.width, 84/2+10.5*(9-deliveryCount), 12.5, 10.5*deliveryCount);
//    
//    NSString * dms_name = [USER_DEFAULT objectForKey:@"HMC_DMSID_Name"];
////    nameLab.text =dms_name;
//    nameLab.text =[NSString stringWithFormat:@"%@ %ld/9",dms_name, (long)tunerNum];
//    //    TVLiveVerticalImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)livePlayCount]];
//    //
//    //
//    //
//    //    TimeShiftVerticalImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount]];
//    //
//    //
//    //
//    //    RecoderVerticalImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)liveRecordCount]];
//    //
//    //
//    //
//    //
//    //    DistributeVerticalImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)deliveryCount]];
//    //
//    
//    
//    
//}
//-(void)judgeTunerClass:(NSData * )typeData // flag:(BOOL)flagBool
//{
////        tempBool1 = !tempBool1; //yes
////        tempBool2 = flagBool;
////    if (tempBool2 == tempBool1) {
////        tempBool2 = !tempBool2;   //no
//        int type;
//        //    [typeData getBytes: &type length: sizeof(type)];
//        //    NSLog(@"typedata :%@",typeData);
//        NSLog(@"type:%d",type);
//        type =  [SocketUtils uint16FromBytes: typeData];
//        NSLog(@"typedata :%@",typeData);
//        NSLog(@"type:%d",type);
//        switch (type) {
//            case INVALID_Service:
//                
//                break;
//            case LIVE_PLAY:
//                livePlayCount ++;
//                break;
//            case LIVE_RECORD:
//                liveRecordCount ++;
//                break;
//            case LIVE_TIME_SHIFT:
//                liveTimeShiteCount ++;
//                break;
//            case DELIVERY:
//                deliveryCount ++;
//                break;
//            case PUSH_VOD:
//                pushVodCount ++;
//                break;
//            default:
//                break;
//        }
//
////    }else
////    {   tempBool1 = !tempBool1;   //no
//////        tempBool2 = YES;
////        [self initData];
////        
////        int type;
////        //    [typeData getBytes: &type length: sizeof(type)];
////        //    NSLog(@"typedata :%@",typeData);
////        NSLog(@"type:%d",type);
////        type =  [SocketUtils uint16FromBytes: typeData];
////        NSLog(@"typedata :%@",typeData);
////        NSLog(@"type:%d",type);
////        switch (type) {
////            case INVALID_Service:
////                
////                break;
////            case LIVE_PLAY:
////                livePlayCount ++;
////                break;
////            case LIVE_RECORD:
////                liveRecordCount ++;
////                break;
////            case LIVE_TIME_SHIFT:
////                liveTimeShiteCount ++;
////                break;
////            case DELIVERY:
////                deliveryCount ++;
////                break;
////            case PUSH_VOD:
////                pushVodCount ++;
////                break;
////            default:
////                break;
////        }
////    }
//    
//    
//}
//-(void)initData
//{
//    livePlayCount = 0;
//    liveRecordCount = 0;
//    liveTimeShiteCount = 0;
//    deliveryCount = 0;
//    pushVodCount = 0;
//    tunerNum = 0;
//    
//    
//}
//
////-(void)linkSocket
////{
////    
////    self.socketView  = [[SocketView  alloc]init];
////    [self.socketView viewDidLoad];
////    
////    //    self.videoController.socketView1 = self.socketView;
////    //    [self.socketView  serviceTouch ];
////}
//-(void)loadNav
//{
//    
//    self.navigationController.navigationBarHidden = NO;
////    refreshTimer = [[NSTimer alloc]init];  //每隔5秒自动刷新
//    
//    HUD = [[MBProgressHUD alloc]init];
//    netWorkErrorView = [[UIView alloc]init];
//}
//
////做一次连接，如果可以连接获取到json数据，则表示有网，显示原网页，否则显示无网模式
//-(void)judgeNetWork
//{
//    
//    
////    NSString * serverStr =  [USER_DEFAULT   objectForKey:@"HMCServiceStr"];  //new server
////        NSString * lastStr = @"flag=0";
////        NSString *url = [[NSString stringWithFormat:@"%@%@",serverStr, lastStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString * GdeviceStr = [USER_DEFAULT objectForKey:@"G_deviceStr"];   //获取本地化的GDevice
//    
////    获取数据的链接
//    NSString *url = [NSString stringWithFormat:@"%@",G_device];
////        NSString *url = [NSString stringWithFormat:@"%@",G_device];
//    
//    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
//    [request setNumberOfTimesToRetryOnTimeout:5];
//    [request startAsynchronous ];
//    
//    
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
//        NSLog(@"scroller : %@",scrollView);
//        [self.view addSubview:HUD];
//        
//        
//        NSLog(@"请求开始的时候调用");
//    }];
//    
//    
//    
//    [request setCompletionBlock:^{
//        
//        NSArray *onlineDeviceArr = [request responseData].JSONValue;
//
//        NSArray *  deviceArr = onlineDeviceArr;
//        NSLog(@"deviceArr :%@",deviceArr);
//        if (deviceArr.count == 0|| deviceArr ==NULL ) {
//            
//            NSLog(@"请求失败的时候调用");
//            
//            [HUD removeFromSuperview];
//            HUD = nil;
//            [scrollView removeFromSuperview];
//            if (!netWorkErrorView) {
//                netWorkErrorView = [[UIView alloc]init];
//            }
//            netWorkErrorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            UIImageView * hudImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 616/2)/2, 120, 616/2, 348/2)];
//            hudImage.image = [UIImage imageNamed:@"网络无连接"];
//            
//            CGSize size = [self sizeWithText:@"Network Error" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//            UILabel * hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
//            hudLab.text = @"Network Error";
//            hudLab.font = FONT(15);
//            hudLab.textColor = [UIColor grayColor];
//            
//            //        [scrollView addSubview:netWorkErrorView];
//            [self.view addSubview:netWorkErrorView];
//            [netWorkErrorView addSubview:hudImage];
//            [netWorkErrorView addSubview:hudLab];
//            
//        }else
//        {
//            [HUD removeFromSuperview];
//            HUD = nil;
//            [netWorkErrorView removeFromSuperview];
//            netWorkErrorView = nil;
//            
////            此时添加加载方法
//                        [scrollView removeFromSuperview];
//                        scrollView = nil;
//                        [self loadScroll];
//            
//                        [self initData];  //初始化数据
//            [self loadUI];
//                        [self getNotificInfo];
//            
//            
//                        //    [self getCGData];    //此处是获取数据
//            //每隔5秒刷新一次
//            if (!refreshTimer) {
//                refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshViewByJudgeData) userInfo:nil repeats:YES];
//            }
//            
//                        NSLog(@"Device ViewWillApper");
//                        self.tabBarController.tabBar.hidden = YES;
//          
//        }
//    }];
//    
//    
//    
//    
//    
//    
//    
//}
//
//- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
//{
//    NSDictionary *attrs = @{NSFontAttributeName : font};
//    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//}
//
//-(void) viewWillAppear:(BOOL)animated
//{
////    tempBool1 = NO;
////    tempBool2 = YES;
//    [USER_DEFAULT setObject:@"DeviceView_Now" forKey:@"viewTOview"];
//    int monitorApperCount = 0 ;
//    NSString * monitorApperCountStr = [NSString stringWithFormat:@"%d",monitorApperCount];
//    [USER_DEFAULT setObject:monitorApperCountStr forKey:@"monitorApperCountStr"];
//    
//    [self judgeNetWork];  //每次打开的时候判断一次网络连接状态
//    NSLog(@"nstimer了一次 ");
//    [super viewWillAppear:animated];
//    
//    
////    if (isRefreshScroll) {
//////        tableInitNum = 0;
////        [scrollView removeFromSuperview];
////        scrollView = nil;
////        
////        [self loadUI];  //***
////        [self getNotificInfo]; //通过发送通知给TV页，TV页通过socket获取到tuner消息
////        //    [self initRefresh]; //开始每隔几秒向TV页发送通知，用来收到数据并且刷新数据
////        //    [self loadNav];
////        isRefreshScroll = NO;
////    }else
////    {
////        //1.获取数据，判断数据和原来的是不是一样，如果不一样，准备刷新
////        //2.删除所有的东西，加载所有的东西
////        [self refreshViewByJudgeData];  //通过获得一次tuner消息，判断tuner消息是不是发生了变化
////        
////    }
//    
////    [scrollView removeFromSuperview];
////    scrollView = nil;
////    [self loadScroll];
////    [self initData];  //初始化数据
////    [self getNotificInfo];
////    
////    
////    //    [self getCGData];    //此处是获取数据
////    
////    [self loadUI];
////    NSLog(@"Device ViewWillApper");
////    self.tabBarController.tabBar.hidden = YES;
//}
//-(void)viewWillDisappear:(BOOL)animated
//{
////页面消失时删除nstimer
////    　[self.timer invalidate];
////
////    self.timer = nil;
//    [refreshTimer invalidate];
//    refreshTimer = nil;
//    NSLog(@"将要消失了一次 ");
//}
//
////- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceUpdated:(NSString *)deviceUdn {
////    NSLog(@"%@", deviceUdn);
////    self.avController = (CGUpnpAvController*)controlPoint;
////
////    //此处可能产生僵尸对象
////    self.dataSource =  [((CGUpnpAvController*)controlPoint) servers];
////
////    //    int dmsNum = 0;
////
////
//////    [self loadUI];
////    [self viewWillAppear:YES];
////
////    NSLog(@"Device delegate");
////}
//
//-(void) loadUI{
//    
//    NSString * dms_name = [USER_DEFAULT objectForKey:@"HMC_DMSID_Name"];
//    self.dataSource = [USER_DEFAULT objectForKey:@"DmsDevice"];
//    for (int i = 0 ; i<self.dataSource.count; i++) {
//        
//        NSLog(@"isDmsNum : %d",isDmsNum);
//        NSLog(@"self.dataSource[i] :%@",[self.dataSource[i] objectForKey:@"dmsID"]);
//        NSLog(@"dms_name :%@",dms_name);
//        NSLog(@"i :%d",i);
//        
//        if ([dms_name isEqualToString:[self.dataSource[i] objectForKey:@"dmsID"]]) {
//            isDmsNum = i;
//        }
//    }
//    
////    isDmsNum = 0;   //以后可以根据名字来判断数字中哪一个是咱们的盒子
//    [self loadDmsView];
//    
//    
//    
//}
//-(void)loadDmsView
//{
//    self.dataSource = [USER_DEFAULT objectForKey:@"DmsDevice"];
//    @synchronized (self.dataSource) {
//        NSLog(@"datasource :%@",self.dataSource);
//        if (self.dataSource.count == 0) {   //如果DataSource等于0，代表DLNA搜索速度慢，但是还是进来了，保存有以前的信息
//            NSString * dmsID_Name_Temp  = [USER_DEFAULT objectForKey:@"HMC_DMSID_Name"];
//            
//            HistogramImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20 + 50* 0 , SCREEN_WIDTH - 40, 45+115)];
//            HistogramImage.image = [UIImage imageNamed:@"直方图"];
//            [scrollView addSubview:HistogramImage];
//            
//            
//            nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 200, 14)];
//            nameLab.font = FONT(13);
//            nameLab.textColor = [UIColor whiteColor];
//            //              nameLab.text = [self.dataSource[i] objectForKey:@"dmsID"];
//            NSString * dms_name = [USER_DEFAULT objectForKey:@"HMC_DMSID_Name"];
//            nameLab.text =dms_name;
//            [HistogramImage addSubview:nameLab];
//            
//            
//            
//            
//            //设置绿色切换按钮
//            UIButton * changeBtn = [[UIButton alloc]init];
//            changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [changeBtn setFrame:CGRectMake(HistogramImage.bounds.size.width -15,20 + 50* 0+15 , 18, 18)];
//            [changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//            [changeBtn setBackgroundImage:[UIImage imageNamed:@"组-51-拷贝"] forState:UIControlStateNormal];
//            
//            [changeBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];  //增加点击区域
//            //                [HistogramImage addSubview:changeBtn];
//            [scrollView addSubview:changeBtn];
//            //                UIButton * changeBtn1 = [[UIButton alloc]init];
//            //                changeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//            //                [changeBtn1 setFrame:CGRectMake(HistogramImage.bounds.size.width -30,15+70 , 18, 18)];
//            //                [changeBtn1 addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//            //                [changeBtn1 setBackgroundColor:[UIColor redColor]];
//            //
//            //                [changeBtn1 setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];  //增加点击区域
//            //                [HistogramImage addSubview:changeBtn1];
//            //                [scrollView addSubview:changeBtn1];
//            
//            
//            TVLiveVerticalImg = [[UIImageView alloc]initWithFrame:CGRectMake(0.105*HistogramImage.frame.size.width, 84/2+10.5*(9-livePlayCount), 12.5, 10.5*livePlayCount)];
//            TVLiveVerticalImg.image = [UIImage imageNamed:@"Verticalpic"];
//            [HistogramImage addSubview:TVLiveVerticalImg];
//            NSLog(@"宽度：%f",[UIScreen mainScreen].bounds.size.width);
//            
//            TimeShiftVerticalImg = [[UIImageView alloc]initWithFrame:CGRectMake(0.248*HistogramImage.frame.size.width, 84/2+10.5*(9-liveTimeShiteCount), 12.5, 10.5*liveTimeShiteCount)];
//            TimeShiftVerticalImg.image = [UIImage imageNamed:@"Verticalpic"];
//            [HistogramImage addSubview:TimeShiftVerticalImg];
//            
//            RecoderVerticalImg = [[UIImageView alloc]initWithFrame:CGRectMake(0.388*HistogramImage.frame.size.width, 84/2+10.5*(9-liveRecordCount), 12.5, 10.5*liveRecordCount)];
//            //                RecoderVerticalImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)liveRecordCount]];
//            RecoderVerticalImg.image = [UIImage imageNamed:@"Verticalpic"];
//            [HistogramImage addSubview:RecoderVerticalImg];
//            
//            
//            DistributeVerticalImg = [[UIImageView alloc]initWithFrame:CGRectMake(0.530*HistogramImage.frame.size.width, 84/2+10.5*(9-deliveryCount), 12.5, 10.5*deliveryCount)];
//            
//            DistributeVerticalImg.image = [UIImage imageNamed:@"Verticalpic"];
//            [HistogramImage addSubview:DistributeVerticalImg];
//            
//            
//            UILabel * TVLiveLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 140, 38, 20)];
//            TVLiveLab.text = @"TV Live";
//            TVLiveLab.textColor = [UIColor whiteColor];
//            TVLiveLab.font = FONT(9);
//            [HistogramImage addSubview:TVLiveLab];
//            
//            UILabel * TimeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(66, 140, 48, 20)];
//            TimeShiftLab.text = @"Time Shift";
//            TimeShiftLab.font = FONT(9);
//            TimeShiftLab.textColor = [UIColor whiteColor];
//            [HistogramImage addSubview:TimeShiftLab];
//            
//            UILabel * RecoderLab = [[UILabel alloc]initWithFrame:CGRectMake(118, 140, 38, 20)];
//            RecoderLab.text = @"Recoder";
//            RecoderLab.font = FONT(9);
//            RecoderLab.textColor = [UIColor whiteColor];
//            [HistogramImage addSubview:RecoderLab];
//            
//            UILabel * DistributeLab = [[UILabel alloc]initWithFrame:CGRectMake(162, 140, 44, 20)];
//            DistributeLab.text = @"Distribute";
//            DistributeLab.font = FONT(9);
//            DistributeLab.textColor = [UIColor whiteColor];
//            [HistogramImage addSubview:DistributeLab];
//        }
//        
//        for (int i = 0 ; i<self.dataSource.count; i++) {
//            NSString * dmsID_Name_Temp = [self.dataSource[i] objectForKey:@"dmsID"];
//            NSLog(@"isDmsNum : %d",isDmsNum);
//            NSLog(@"self.dataSource[isDmsNum] :%@",[self.dataSource[isDmsNum] objectForKey:@"dmsID"]);
//            NSLog(@"dmsID_Name_Temp :%@",dmsID_Name_Temp);
//            
//            NSString * dmsID_Name_now = [self.dataSource[isDmsNum] objectForKey:@"dmsID"];
//            if (i != isDmsNum && ![dmsID_Name_Temp isEqualToString:dmsID_Name_now]) {
//                UIView * CGDeviceView = [[UIView alloc]init];
//                if (i < isDmsNum && ![dmsID_Name_Temp isEqualToString:dmsID_Name_now]) {
//                    CGDeviceView.frame = CGRectMake(20, 20 + 50* i , SCREEN_WIDTH - 40, 45);
//                }else //如果是在直方图的下面，则高度增加115
//                {
//                    CGDeviceView.frame = CGRectMake(20, 20 + 50* i +115 , SCREEN_WIDTH - 40, 45);
//                }
//                
//                CGDeviceView.layer.cornerRadius = 5.0;
//                CGDeviceView.tag = i;
//                CGDeviceView.backgroundColor = RGBA(0x60, 0xa3, 0xec, 1);
//                
//                [scrollView addSubview:CGDeviceView];
//                [scrollView bringSubviewToFront:CGDeviceView];
//                
//                
//                UILabel * nameLabOther = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 200, 14)];
//                nameLabOther.font = FONT(13);
//                nameLabOther.textColor = [UIColor whiteColor];
//                nameLabOther.text = [self.dataSource[i] objectForKey:@"dmsID"];
//                [CGDeviceView addSubview:nameLabOther];
//                
//                
//                
//                
//                //设置绿色切换按钮
//                
//                UIButton * changeBtn = [[UIButton alloc]init];
//                 changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [changeBtn setFrame:CGRectMake(CGDeviceView.bounds.size.width -30,15 , 18, 18)];
//                [changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//                [changeBtn setBackgroundImage:[UIImage imageNamed:@"nor"] forState:UIControlStateNormal];
//                
//                [changeBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];  //增加点击区域
//                [CGDeviceView addSubview:changeBtn];
//                
//             
//                
//            }
//            else
//            {
//                //                UIView * CGDeviceView = [[UIView alloc]initWithFrame:CGRectMake(20, 20 + 50* i +115, SCREEN_WIDTH - 40, 45+115)];
//                //                CGDeviceView.layer.cornerRadius = 5.0;
//                //                CGDeviceView.tag = i;
//                //                CGDeviceView.backgroundColor = RGBA(0x60, 0xa3, 0xec, 1);
//                //
//                //                [scrollView addSubview:CGDeviceView];
//                //                [scrollView bringSubviewToFront:CGDeviceView];
//                
//                HistogramImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20 + 50* i , SCREEN_WIDTH - 40, 45+115)];
//                HistogramImage.image = [UIImage imageNamed:@"直方图"];
//                [scrollView addSubview:HistogramImage];
//                
//                
//                nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 200, 14)];
//                nameLab.font = FONT(13);
//                nameLab.textColor = [UIColor whiteColor];
//                //              nameLab.text = [self.dataSource[i] objectForKey:@"dmsID"];
//                NSString * dms_name = [USER_DEFAULT objectForKey:@"HMC_DMSID_Name"];
//                nameLab.text =dms_name;
//                [HistogramImage addSubview:nameLab];
//                
//                
//                
//                
//                //设置绿色切换按钮
//                UIButton * changeBtn = [[UIButton alloc]init];
//                 changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [changeBtn setFrame:CGRectMake(HistogramImage.bounds.size.width -15,20 + 50* i+15 , 18, 18)];
//                [changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//                [changeBtn setBackgroundImage:[UIImage imageNamed:@"组-51-拷贝"] forState:UIControlStateNormal];
//                
//                [changeBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];  //增加点击区域
////                [HistogramImage addSubview:changeBtn];
//                [scrollView addSubview:changeBtn];
////                UIButton * changeBtn1 = [[UIButton alloc]init];
////                changeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
////                [changeBtn1 setFrame:CGRectMake(HistogramImage.bounds.size.width -30,15+70 , 18, 18)];
////                [changeBtn1 addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
////                [changeBtn1 setBackgroundColor:[UIColor redColor]];
////                
////                [changeBtn1 setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];  //增加点击区域
////                [HistogramImage addSubview:changeBtn1];
////                [scrollView addSubview:changeBtn1];
//                
//                
//                TVLiveVerticalImg = [[UIImageView alloc]initWithFrame:CGRectMake(0.105*HistogramImage.frame.size.width, 84/2+10.5*(9-livePlayCount), 12.5, 10.5*livePlayCount)];
//                TVLiveVerticalImg.image = [UIImage imageNamed:@"Verticalpic"];
//                [HistogramImage addSubview:TVLiveVerticalImg];
//                NSLog(@"宽度：%f",[UIScreen mainScreen].bounds.size.width);
//                
//                TimeShiftVerticalImg = [[UIImageView alloc]initWithFrame:CGRectMake(0.248*HistogramImage.frame.size.width, 84/2+10.5*(9-liveTimeShiteCount), 12.5, 10.5*liveTimeShiteCount)];
//                TimeShiftVerticalImg.image = [UIImage imageNamed:@"Verticalpic"];
//                [HistogramImage addSubview:TimeShiftVerticalImg];
//                
//                RecoderVerticalImg = [[UIImageView alloc]initWithFrame:CGRectMake(0.388*HistogramImage.frame.size.width, 84/2+10.5*(9-liveRecordCount), 12.5, 10.5*liveRecordCount)];
//                //                RecoderVerticalImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)liveRecordCount]];
//                RecoderVerticalImg.image = [UIImage imageNamed:@"Verticalpic"];
//                [HistogramImage addSubview:RecoderVerticalImg];
//                
//                
//                DistributeVerticalImg = [[UIImageView alloc]initWithFrame:CGRectMake(0.530*HistogramImage.frame.size.width, 84/2+10.5*(9-deliveryCount), 12.5, 10.5*deliveryCount)];
//                
//                DistributeVerticalImg.image = [UIImage imageNamed:@"Verticalpic"];
//                [HistogramImage addSubview:DistributeVerticalImg];
//                
//                
//                UILabel * TVLiveLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 140, 38, 20)];
//                TVLiveLab.text = @"TV Live";
//                TVLiveLab.textColor = [UIColor whiteColor];
//                TVLiveLab.font = FONT(9);
//                [HistogramImage addSubview:TVLiveLab];
//                
//                UILabel * TimeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(66, 140, 48, 20)];
//                TimeShiftLab.text = @"Time Shift";
//                TimeShiftLab.font = FONT(9);
//                TimeShiftLab.textColor = [UIColor whiteColor];
//                [HistogramImage addSubview:TimeShiftLab];
//                
//                UILabel * RecoderLab = [[UILabel alloc]initWithFrame:CGRectMake(118, 140, 38, 20)];
//                RecoderLab.text = @"Recoder";
//                RecoderLab.font = FONT(9);
//                RecoderLab.textColor = [UIColor whiteColor];
//                [HistogramImage addSubview:RecoderLab];
//                
//                UILabel * DistributeLab = [[UILabel alloc]initWithFrame:CGRectMake(162, 140, 44, 20)];
//                DistributeLab.text = @"Distribute";
//                DistributeLab.font = FONT(9);
//                DistributeLab.textColor = [UIColor whiteColor];
//                [HistogramImage addSubview:DistributeLab];
//                
//            }
//        }
//    }
//}
//-(void)loadScroll
//{
//    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
//    [self.view addSubview:scrollView];
//    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 20+self.dataSource.count*50+115);
//    scrollView.showsVerticalScrollIndicator=NO;
//    scrollView.showsHorizontalScrollIndicator=NO;
//    scrollView.delegate=self;
//    scrollView.bounces = NO;
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    
//}
//
//-(void)changeBtnClick
//{
//    NSLog(@"点击了,进行切换");
//}
//-(void)setIPNoific
//{
//    
//    //新建一个发送IP 改变的消息的通知   //
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IPHasChangedDevice" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IPHasChanged) name:@"IPHasChangedDevice" object:nil];
//    
//}
//-(void)IPHasChanged
//{
//    NSLog(@"列表更新了---IPHasChanged方法");
//    [self viewWillAppear:YES];
////    //    NSString * IPstrNow = [GGUtil getIPAddress];
////    NSString * IPstrNow=  [GGUtil getIPAddress:YES];
////    if ([IPstrNow isEqualToString:self.ipString]) {
////        
////    }else
////    {
////        
////        NSLog(@"IP 网络改变");
////        
//////        [self.dataSource removeAllObjects];
//////        [USER_DEFAULT setObject:[self.dataSource copy]  forKey:@"DmsDevice"];   //此处数据为空
////        
////        self.ipString = IPstrNow;
////        //创建通知
////        NSNotification *notification =[NSNotification notificationWithName:@"IPHasChanged" object:nil userInfo:nil];
////        //通过通知中心发送通知
////        [[NSNotificationCenter defaultCenter] postNotification:notification];
////    }
//    
//    //访问连接，看是否能访问，如果不能访问，则显示“the media center has disconnected”
//    //发送刷新列表的更新
//}
//@end
