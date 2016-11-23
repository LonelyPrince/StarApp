//
//  MonitorViewController.m
//  StarAPP
//
//  Created by xyz on 16/8/29.
//
//

#import "MonitorViewController.h"
#define kShadowRadius 20
#define TopViewHeight 400
#define TopBottomNameWidth 142/2
#define CutWidth 30/2
#define TopBottomNameMarginLeft (SCREEN_WIDTH-4*TopBottomNameWidth-3*CutWidth)/2

@interface MonitorViewController ()
{
    NSInteger tunerNum;
    NSMutableArray *  livePlayArr;
    NSMutableArray *  liveRecordArr;
    NSMutableArray *  liveTimeShiteArr;
    NSMutableArray *  deliveryArr;
    NSMutableArray *  pushVodArr;
    
    NSInteger   livePlayCount;
    NSInteger   liveRecordCount;
    NSInteger   liveTimeShiteCount;
    NSInteger   deliveryCount;
    NSInteger   pushVodCount;
    BOOL scrollUp;
    int lastPosition ;
}
@end

@implementation MonitorViewController
@synthesize scrollView;
@synthesize tableView;
@synthesize colorView;
@synthesize colorImageView;
@synthesize TVhttpDic;
@synthesize monitorTableDic;
@synthesize monitorTableArr;
@synthesize socketUtils;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //修改tabbar选中的图片颜色和字体颜色
    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = image;
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
    
   
    
    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [scrollView removeFromSuperview];
    scrollView = nil;
   
//    UILabel * shadowLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 230, 30)];
//    shadowLab.text = @"测试案例";
//    shadowLab.shadowColor = RGBA(30, 30, 30, 0.5) ;//设置文本的阴影色彩和透明度。
//     shadowLab.shadowOffset = CGSizeMake(2.0f, 2.0f);     //设置阴影的倾斜角度。
//    UILabel * shadowLab1 = [[UILabel alloc]initWithFrame:CGRectMake(210, 120, 230, 30)];
//    shadowLab1.text = @"123123213123";
//    
//    shadowLab1.shadowColor = RGBA(130, 130, 30, 0.5);    //设置文本的阴影色彩和透明度。
//    shadowLab1.shadowOffset = CGSizeMake(2.0f, 2.0f);     //设置阴影的倾斜角度。
//    
//    [self.view addSubview:shadowLab];
//    [self.view addSubview:shadowLab1];
//    [self getTunerInfo];
    [self initData];
    [self getNotificInfo]; //通过发送通知给TV页，TV页通过socket获取到tuner消息
    
//    [self loadNav];
//    [self loadUI];
 
}

-(void)getNotificInfo
{
    NSLog(@"=======================notific");
    
//    self.blocktest = ^(NSDictionary * dic)
//    {
//        //此处是返回值处理方法
//        NSLog(@"此处是返回 :%@",dic);
//    };
//
    //////////////////////////// 向TV页面发送通知
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    
    
  //////////////////////////// 从socket返回数据
    //此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfo:) name:@"getResourceInfo" object:nil];
    
    
//    [USER_DEFAULT objectForKey:@"CICHUSHIDIC"];
//    NSLog(@"此处是返回：%@", [USER_DEFAULT objectForKey:@"CICHUSHIDIC"]);
    
}


-(void)getResourceInfo:(NSNotification *)text
{
    
    NSLog(@"moni:%@",text.userInfo[@"resourceInfoData"]);
    //    int show = [text.userInfo[@"resourceInfoData"] intValue];
    NSLog(@"此处是socket返回");
    
    NSData * retData = [[NSData alloc]init];
    retData = text.userInfo[@"resourceInfoData"];    //返回的data
//        [self getTunerNum:retData];  //获得总的tuner的数量
        [self getEffectiveData:retData];//获得有效数据的信息，不同tuner的信息

}

-(void)loadNav
{
    
}
-(void)initData
{
    scrollUp = NO;
    lastPosition = 0;
    livePlayCount = 0;
    liveRecordCount = 0;
    liveTimeShiteCount = 0;
    deliveryCount = 0;
    pushVodCount = 0;
    tunerNum = 0;
    livePlayArr = [[NSMutableArray alloc]init];
    liveRecordArr = [[NSMutableArray alloc]init];
    liveTimeShiteArr = [[NSMutableArray alloc]init];
    deliveryArr = [[NSMutableArray alloc]init];
    pushVodArr = [[NSMutableArray alloc]init];
    monitorTableDic = [[NSMutableDictionary alloc]init];
    monitorTableArr = [[NSMutableArray alloc]init];
    
    
    ///
//    socketUtils = [[SocketUtils alloc]init];
}


-(void)loadUI
{
    NSLog(@"=======--:%d",tunerNum);
    [self loadScroll];
    [self loadColorView];

   [self loadTableview];
    
}
-(void)loadColorView
{

      colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
    colorView.backgroundColor = [UIColor purpleColor];
    [scrollView addSubview:colorView];
    
    colorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
    colorImageView.image = [UIImage  imageNamed:@"监控渐变背景"];
    [colorView addSubview:colorImageView];
   
    [self loadCicle];
    [self loadNumLab];
}
-(void)loadCicle
{
//    tunerNum = 3;
    
    UIImageView * cicleClearImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 196)/2, 80 , 196, 195)];
    cicleClearImageView.image = [UIImage  imageNamed:@"圆环"];
    [colorImageView addSubview:cicleClearImageView];
    
    UIImageView * cicleBlueImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 196)/2, 80,196, 195)];
    cicleBlueImageView.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"圆环-%d",tunerNum]];
    [colorImageView addSubview:cicleBlueImageView];
    
    UIImageView * nineImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-5, cicleClearImageView.frame.size.height/2-25,36, 33)];
    nineImage.image = [UIImage  imageNamed:@"nine"];
    [cicleClearImageView addSubview:nineImage];
    
    
    UIImageView * numImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-30, cicleClearImageView.frame.size.height/2-35,36, 43)];
    numImage.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"M%d",tunerNum]];
    [cicleClearImageView addSubview:numImage];
    
    UIImageView * labImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-30, cicleClearImageView.frame.size.height/2+10,65, 40)];
    labImage.image = [UIImage  imageNamed:@"Tunermonitor"];
    [cicleClearImageView addSubview:labImage];
}
-(void)loadNumLab  //底部的各项tuner的数量
{
    UILabel * liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft, 360, 142/2, 13)];
    liveNumLab.text = @"TV Live";
    liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
    liveNumLab.font = FONT(13);
    [colorImageView addSubview:liveNumLab];
    
    UILabel * recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth +CutWidth , 360, 142/2, 13)];
    recoderLab.text = @"Recoder";
    recoderLab.textColor = RGBA(245, 245, 245, 0.65);
    recoderLab.font = FONT(13);
    [colorImageView addSubview:recoderLab];
    
    UILabel * timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*2 +CutWidth*2 , 360, 142/2, 13)];
    timeShiftLab.text = @"Time Shift";
    timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
    timeShiftLab.font = FONT(13);
    [colorImageView addSubview:timeShiftLab];
    
    UILabel * distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 , 360, 142/2, 13)];
    distributeLab.text = @"Time Shift";
    distributeLab.textColor = RGBA(245, 245, 245, 0.65);
    distributeLab.font = FONT(13);
    [colorImageView addSubview:distributeLab];
    
    
        UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8, 325, 2, 40)];
        verticalView1.layer.cornerRadius = 1.0;
        verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
        [colorImageView addSubview:verticalView1];
    
    UIView * verticalView2 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(1+1)-2 +CutWidth*1, 325, 2, 40)];
    verticalView2.layer.cornerRadius = 1.0;
    verticalView2.backgroundColor = RGBA(245, 245, 245, 0.3);
    [colorImageView addSubview:verticalView2];
    
    UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2, 325, 2, 40)];
    verticalView3.layer.cornerRadius = 1.0;
    verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
    [colorImageView addSubview:verticalView3];
    
    
    UILabel * liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20, liveNumLab.frame.origin.y-40, 16, 20)];
    liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
    liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
    liveNum_Lab.font = FONT(24);
    [colorImageView addSubview:liveNum_Lab];
    
    UILabel * recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth +CutWidth, liveNumLab.frame.origin.y-40, 16, 20)];
    recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
    recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
    recoder_Lab.font = FONT(24);
    [colorImageView addSubview:recoder_Lab];

    UILabel * timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
    timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
    timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
    timeShift_Lab.font = FONT(24);
    [colorImageView addSubview:timeShift_Lab];
    
    UILabel * distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*3 +CutWidth*3, liveNumLab.frame.origin.y-40, 16, 20)];
    distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
    distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
    distribute_Lab.font = FONT(24);
    [colorImageView addSubview:distribute_Lab];
}
-(void)loadScroll
{
    NSLog(@"=======================load scroll");
    //加一个scrollview
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:scrollView];
    
    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
    //    scroll.pagingEnabled=YES;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.delegate=self;
    scrollView.bounces=NO;
    
}
-(void)loadTableview
{
    NSLog(@"=======================load tableview");
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopViewHeight, SCREEN_WIDTH, tunerNum*80) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    [scrollView  addSubview:self.tableView];
}
/////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    
    return tunerNum;
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorCell"];
    if (cell == nil){
        cell = [MonitorCell loadFromNib];
//        cell.backgroundColor=[UIColor clearColor];
        
//        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
        
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    if (! ISNULL(monitorTableArr)) {
        cell.dataArr = monitorTableArr[indexPath.row];
    }else
    {
    }
    
    
   
    return cell;
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了");
}
/**
 获取当前连接tuner的数量
 */
-(NSInteger)getTunerNum:(NSData *)tunerAllData
{
    NSData * dataLen = [[NSData alloc]init];
    dataLen = [tunerAllData subdataWithRange:NSMakeRange(27, 1)];
    
    int value;
    [tunerAllData getBytes: &value length: sizeof(value)];   //获取总长度

   
    for (int i = 0; i<11; i++) {
        if (value == 77+i*15) {
            tunerNum = i;
        }else
        {
        }
    }
    return tunerNum;
}

//获得有效数据的信息，不同tuner的信息
-(void)getEffectiveData:(NSData *) allTunerData
{
    NSLog(@"=======================test gettuner");
    //获取数据总长度
    NSData * dataLen = [[NSData alloc]init];
    dataLen = [allTunerData subdataWithRange:NSMakeRange(27, 1)];
    
    NSLog(@"datalen: %@",dataLen);
    int value;
    [dataLen getBytes: &value length: sizeof(value)];   //获取总长度
   
//    [socketUtils uint16FromBytes:]
    //tuner的有效数据区
    NSData * effectiveData = [[NSData alloc]init];
    effectiveData = [allTunerData subdataWithRange:NSMakeRange(38,(value-10))];
    
    //定位数据，用于看位于第几个字节，起始位置是在
    int placeFigure = 3;
    for (int ai = 0; ai < 11; ai++ ) {  //目前会返回11条数据
   
        
//       NSMutableData * tunerDataone = [NSMutableData dataWithData:allTunerData];
        int mutablefigure = placeFigure;
        NSLog(@"----len placeFigure:%d",placeFigure);
        NSLog(@"----len mutablefigure:%d",mutablefigure);
        NSLog(@"----len effectiveData:%@",effectiveData);
//        char buffer;
//        [effectiveData getBytes:&buffer range:NSMakeRange(mutablefigure, 4)];

        NSData * databuff = [effectiveData subdataWithRange:NSMakeRange(mutablefigure, 4)];
//        Byte *buffer = (Byte *)[databuff bytes];
        
        char buffer1;
        int buffer_int1 =placeFigure;
        [effectiveData getBytes:&buffer1 range:NSMakeRange(buffer_int1, 1)];
        char buffer2;
        int buffer_int2 =placeFigure+1;
        [effectiveData getBytes:&buffer2 range:NSMakeRange(buffer_int2, 1)];
        char buffer3;
        int buffer_int3 =placeFigure+2;
        [effectiveData getBytes:&buffer3 range:NSMakeRange(buffer_int3, 1)];
        char buffer4;
        int buffer_int4 =placeFigure+3;
        [effectiveData getBytes:&buffer4 range:NSMakeRange(buffer_int4, 1)];
//        char buffer5;
//        [effectiveData getBytes:&buffer5 range:NSMakeRange(14, 1)];
//        char buffer6;
//        [effectiveData getBytes:&buffer6 range:NSMakeRange(10, 4)];
//
//        NSString * testdatabuff = [[NSString alloc]initWithData:databuff10 encoding:NSUTF8StringEncoding];
//        
//        char buffer7;
//        [effectiveData getBytes:&buffer7 range:NSMakeRange(13, 2)];
//        [effectiveData subdataWithRange:NSMakeRange(13, 2)];
//        NSLog(@"----len dataByte=======:%x",dataByte);
//        NSLog(@"----len testdatabuff=======:%@",testdatabuff);
//        NSLog(@"----len databuff10=======:%@",databuff10);
//        NSLog(@"----len buffer1=======:%x",buffer1);
//        NSLog(@"----len placeFigure=======:%d",placeFigure);
//        NSLog(@"----len mutablefigure=====:%d",mutablefigure);
//        NSLog(@"----len effectiveData=====:%@",effectiveData);
//        NSLog(@"==buffer:%c",buffer);
        if( buffer1 == 0x00 && buffer2 == 0x00&& buffer3 == 0x00 && buffer4 == 0x00)
        {
            NSLog(@"11");
        }
        else
        {
            
            tunerNum ++;
            NSLog(@"22");
            
            //这里获取service_type类型
            NSData * serviceTypeData = [[NSData alloc]init];
            serviceTypeData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+4, 4)];
            //这里获取network_id
            NSData * networkIdData = [[NSData alloc]init];
            networkIdData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+12, 2)];
            //这里获取ts_id
            NSData * tsIdData = [[NSData alloc]init];
            tsIdData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+14, 2)];

            //这里获取service_id
            NSData * serviceIdData = [[NSData alloc]init];
            serviceIdData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+16, 2)];
            //这里获取name_len
            NSData * nameLenData = [[NSData alloc]init];
            nameLenData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+18, 1)];
          
            //先看一下长度是不是0
            char lenBuffer;
            [nameLenData getBytes: &lenBuffer length: sizeof(lenBuffer)];
            
            int clientNameLen = 0;
            NSData * clientNameData = [[NSData alloc]init];
            if (lenBuffer == 0x00) {
                
                NSString *aString = @"";
                clientNameData = [aString dataUsingEncoding: NSUTF8StringEncoding];
            }else
            {
                
                [nameLenData getBytes: &clientNameLen length: sizeof(clientNameLen)];
                
                int clienNameLenCopy = clientNameLen;
                int clienNameLenCopy1 = clientNameLen;
           
                //获取client_name
                
                clientNameData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+18+1, clienNameLenCopy1)];
            }
          
           
            
          
            
            
            //此处做判断，看一下属于哪个tuner
            TVhttpDic =  [USER_DEFAULT objectForKey:@"TVHttpAllData"];
            NSArray * category1 = [TVhttpDic objectForKey:@"category"];
            NSArray * service1 = [TVhttpDic objectForKey:@"service"];
            
            
            for (int a = 0; a <service1.count ; a++) {
                //原始数据
                NSString * service_network =  [service1[a]objectForKey:@"service_network_id"];
                NSString * service_ts =  [service1[a] objectForKey:@"service_ts_id"];
                NSString * service_service =  [service1[a] objectForKey:@"service_service_id"];
                NSString * service_tuner =  [service1[ai] objectForKey:@"service_tuner_mode"];
                
                
//                //新的数据
                NSString * newservice_network = [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: networkIdData]]; //[[NSString alloc]initWithData:networkIdData encoding:NSUTF8StringEncoding];
                
                
                NSString * newservice_ts =   [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: tsIdData]];//[[NSString alloc]initWithData:tsIdData encoding:NSUTF8StringEncoding];
                NSString * newservice_service = [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: serviceIdData]];// [[NSString alloc]initWithData:serviceIdData encoding:NSUTF8StringEncoding];
//                NSString * newservice_tunertype =  [[NSString alloc]initWithData:serviceTypeData encoding:NSUTF8StringEncoding];
//                NSString * newservice_apiservicetype =  [[NSString alloc]initWithData:serviceTypeData encoding:NSUTF8StringEncoding];
                
                if ([service_network isEqualToString:newservice_network] && [service_ts isEqualToString:newservice_ts]  && [service_service isEqualToString:newservice_service]  //&& [service_tuner isEqualToString:newservice_tunertype]
                    ) {
                   
                    //这种情况下是找到了节目
                    NSArray * arr_threeData =[ [NSArray alloc]initWithObjects:service1[a],serviceTypeData,clientNameData, nil];
                    
                    [monitorTableArr addObject:arr_threeData];  //把展示节目列表添加到数组中，用于展示
                    
                    
//                    for (int d = 0; d<category1.count; d++) {
//                        NSArray *  service_index = [category1[d] objectForKey:@"service_index"];
//                        for (int y = 0; y<service_index.count; y++) {
//                            if ([service_index[y] intValue] == a+1) {  //// 判断值是否等于行数
//                                
//                                
//                                //                //获取不同类别下的节目，然后是节目下不同的cell值                10
//                                for (int x = 0 ; x<service_index.count; x++) {
//                                    //
//                                    int indexCat ;
//                                    //   NSString * str;
//                                    indexCat =[service_index[x] intValue];
//                                    data2 = self.response[@"service"];
//                                    serviceTouch  = data2[indexCat-1];
//                                    //                    //cell.tabledataDic = self.serviceData[indexCat -1];
//                                    //
//                                    [dicCategory setObject:serviceTouch forKey:[NSString stringWithFormat:@"%d",x]];
//                                    //                    [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
//                                    //
//                                    //
//                                }
//                                
//                                
//                                
//                                
//                            }
//                        }
//                    }
                    
                    
                    
//                    //获取不同类别下的节目，然后是节目下不同的cell值
//                    //                                                      10
//                    
//                    for (int c = 0 ; c<self.categoryModel.service_indexArr.count; c++) {
//                        
//                        int indexCat ;
//                        //   NSString * str;
//                        indexCat =[self.categoryModel.service_indexArr[c] intValue];
//                        //cell.tabledataDic = self.serviceData[indexCat -1];
//                        
//                        [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
//                        
//                        
//                    }
                
                
                 [self.tableView reloadData];
                }
                else //此处是一种特殊情况，没有找到这个节目
                {
                    [self.tableView reloadData];
                }
                
            }
            
            
            
      
       
  //***********
            
            //            char serviceTypeBuf;
//
//            [serviceTypeData getBytes:&buffer range:NSMakeRange(placeFigure, 4)];
            
            //            char serviceTypeBuf;
//            [serviceTypeData getBytes:&buffer range:NSMakeRange(placeFigure, 4)];
            
            //判断service_typedata,判断是不是分发，时移，录制
            [self judgeTunerClass:serviceTypeData];
            
            ////
            placeFigure  = placeFigure + 15+clientNameLen;
        }
       
//        int mutablefigure = ai;
//        mutablefigure = mutablefigure*7;
        placeFigure =placeFigure +7;  //placeFigure+ mutablefigure ;
        
    }
    
    [self loadNav];
    [self loadUI];
}

-(void)judgeTunerClass:(NSData * )typeData
{

    int type;
//    [typeData getBytes: &type length: sizeof(type)];
    NSLog(@"typedata :%@",typeData);
    NSLog(@"type:%d",type);
    type =  [SocketUtils uint16FromBytes: typeData];
    NSLog(@"typedata :%@",typeData);
    NSLog(@"type:%d",type);
    switch (type) {
        case INVALID_Service:
            
            break;
        case LIVE_PLAY:
            livePlayCount ++;
            break;
        case LIVE_RECORD:
            liveRecordCount ++;
            break;
        case LIVE_TIME_SHIFT:
            liveTimeShiteCount ++;
            break;
        case DELIVERY:
            livePlayCount ++;
            break;
        case PUSH_VOD:
            pushVodCount ++;
            break;
        default:
            break;
    }
    
}


//// 开始拖拽
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
////    NSLog(@"++开始拖拽");
//    if (scrollView.class ==  self.tableView.class) {
//        NSLog(@"tableview:.y");
//        int currentPostion = scrollView.contentOffset.y;
//    NSLog(@"tableview.contentOffset.y:%f",self.scrollView.contentOffset.y);
//    }
//    
//    if (scrollView.class ==  self.scrollView.class) {
//        NSLog(@"scroll:.y");
//    }
//}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView.contentOffset.y:%f",self.scrollView.contentOffset.y);
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - lastPosition > 30 && self.scrollView.contentOffset.y >50 && scrollUp == NO){
        CGPoint position = CGPointMake(0, 300);
//        [scrollView     :position animated:YES];
        [UIView animateWithDuration:1
                              delay:0.02
                            options:UIViewAnimationCurveLinear
                         animations:^{

                            self.scrollView.frame = CGRectMake(0, -300, SCREEN_WIDTH, SCREEN_HEIGHT);

                            self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200-93);
                             scrollUp = YES;
                         self.tableView.scrollEnabled = YES;
                             //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
                         }
                         completion:^(BOOL finished)
         { NSLog(@"animate");
             self.tableView.scrollEnabled = YES;
         } ];
        NSLog(@"scrollView.contentOffset2.y:%f",scrollView.contentOffset.y);
        self.tableView.scrollEnabled = YES;
    }
    
    


    if(scrollView.class == self.tableView.class){
    if (self.tableView.contentOffset.y<-30&& scrollUp == YES
//        currentPostion - lastPosition < 20 && scrollView.contentOffset.y <25
        ){
        CGPoint position = CGPointMake(0, 300);
        
        [UIView animateWithDuration:1
                              delay:0.02
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             //                             [scrollView setContentOffset: position ];
                             self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                             //                             scrollView.contentOffset = CGPointMake(0, 0);
                             self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
                             scrollUp = NO;
                             //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
                         self.tableView.scrollEnabled = NO;
                         }
                         completion:^(BOOL finished)
         { NSLog(@"animate");
             self.tableView.scrollEnabled = NO;
         } ];
        NSLog(@"scrollView.contentOffset2.y:%f",scrollView.contentOffset.y);
        self.tableView.scrollEnabled = NO;
    }
    }

    



}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
