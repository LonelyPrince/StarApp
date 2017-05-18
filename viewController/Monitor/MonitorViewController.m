//////
//////  MonitorViewController.m
//////  StarAPP
//////
//////  Created by xyz on 16/8/29.
//////
//////
////
////#import "MonitorViewController.h"
////#import "sys/utsname.h"
////#define kShadowRadius 20
////#define TopViewHeight 400
////#define TopBottomNameWidth 142/2
////#define CutWidth 30/2
////#define TopBottomNameMarginLeft (SCREEN_WIDTH-4*TopBottomNameWidth-3*CutWidth)/2
////
////@interface MonitorViewController ()
////{
////    NSInteger tunerNum;
////    NSMutableArray *  livePlayArr;
////    NSMutableArray *  liveRecordArr;
////    NSMutableArray *  liveTimeShiteArr;
////    NSMutableArray *  deliveryArr;
////    NSMutableArray *  pushVodArr;
////    
////    NSInteger   livePlayCount;
////    NSInteger   liveRecordCount;
////    NSInteger   liveTimeShiteCount;
////    NSInteger   deliveryCount;
////    NSInteger   pushVodCount;
////    BOOL scrollUp;
////    int lastPosition ;
////    
////    NSInteger tableInitNum;
////    
////    NSTimer *  refreshTimer ;  //定时刷新，暂定时间5秒
////    
////    NSString * deviceString;
////    
////}
////@end
////
////@implementation MonitorViewController
////@synthesize scrollView;
////@synthesize tableView;
////@synthesize colorView;
////@synthesize colorImageView;
////@synthesize TVhttpDic;
////@synthesize monitorTableDic;
////@synthesize monitorTableArr;
////@synthesize socketUtils;
////// loadnum
////@synthesize liveNumLab;
////@synthesize recoderLab;
////@synthesize timeShiftLab;
////@synthesize distributeLab;
////@synthesize liveNum_Lab;
////@synthesize recoder_Lab;
////@synthesize timeShift_Lab;
////@synthesize distribute_Lab;
////
//////loadColor Cicle
////@synthesize cicleClearImageView;
////@synthesize cicleBlueImageView;
////@synthesize nineImage;
////@synthesize numImage;
////@synthesize labImage;
////@synthesize isRefreshScroll;
////- (void)viewDidLoad {
////    [super viewDidLoad];
////    
////    //修改tabbar选中的图片颜色和字体颜色
////    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
////    self.tabBarItem.selectedImage = image;
////    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
////    
////   
////    
////    self.view.backgroundColor = [UIColor whiteColor];
////    
////    isRefreshScroll = YES;
////    
////    int monitorApperCount = 0;
////    NSString * monitorApperCountStr = [NSString stringWithFormat:@"%d",monitorApperCount];
////    [USER_DEFAULT setObject:monitorApperCountStr forKey:@"monitorApperCountStr"];
////    
////  
////    [self initData];
////
////    
////    
////}
////-(void)viewWillAppear:(BOOL)animated
////{
////    [USER_DEFAULT setObject:@"MonitorView_Now" forKey:@"viewTOview"];
////     [USER_DEFAULT setObject:[NSNumber numberWithInt:1] forKey:@"viewDidloadHasRunBool"];     // 此处做一次判断，判断是不是连接状态，如果是的，则执行live页面的时候不执行【socket viewDidload】
////    
////    if (isRefreshScroll) {
////        tableInitNum = 0;
////        [scrollView removeFromSuperview];
////        scrollView = nil;
////        
////        //    UILabel * shadowLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 230, 30)];
////        //    shadowLab.text = @"测试案例";
////        //    shadowLab.shadowColor = RGBA(30, 30, 30, 0.5) ;//设置文本的阴影色彩和透明度。
////        //     shadowLab.shadowOffset = CGSizeMake(2.0f, 2.0f);     //设置阴影的倾斜角度。
////        //    UILabel * shadowLab1 = [[UILabel alloc]initWithFrame:CGRectMake(210, 120, 230, 30)];
////        //    shadowLab1.text = @"123123213123";
////        //
////        //    shadowLab1.shadowColor = RGBA(130, 130, 30, 0.5);    //设置文本的阴影色彩和透明度。
////        //    shadowLab1.shadowOffset = CGSizeMake(2.0f, 2.0f);     //设置阴影的倾斜角度。
////        //
////        //    [self.view addSubview:shadowLab];
////        //    [self.view addSubview:shadowLab1];
////        //    [self getTunerInfo];
//////        [self initData];
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
////
//// 
////}
////-(void)refreshViewByJudgeData    //通过获得一次tuner消息，判断tuner消息是不是发生了变化
////{
////   //1.发送消息
////   //2.判断
////    [self  getNotificInfoByMySelf]; // 发送消息给TV页面，然后通过TV页面传通知发送tuner的socket信息
////    
////}
////-(void)getNotificInfoByMySelf   //随后每隔一段时间或者打开这个页面的时候获取tuner信 BYMYSelf
////{
////    //////////////////////////// 向TV页面发送通知
////    //创建通知
////    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
////    //通过通知中心发送通知
////    [[NSNotificationCenter defaultCenter] postNotification:notification];
////    [USER_DEFAULT  setObject:@"deviceClose" forKey:@"deviceOpenStr"];  //防止device页面接收
////    
////    
////    //////////////////////////// 从socket返回数据
////    //此处销毁通知，防止一个通知被多次调用
////    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getNotificInfoByMySelf" object:nil];
////    //注册通知
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificInfoByMySelf:) name:@"getNotificInfoByMySelf" object:nil];
////
////
////}
////-(void)getNotificInfoByMySelf:(NSNotification *)text
////{
////    
////    
////    NSData * retDataByMySelf = [[NSData alloc]init];
////    retDataByMySelf = text.userInfo[@"resourceInfoData"];    //返回的data
////    
//////    NSData * dataTemp = [[NSData alloc]init];
//////    dataTemp = [USER_DEFAULT objectForKey:@"retDataForMonitor"];
////    NSLog(@"retDataByMySelf: %@",retDataByMySelf);
////    
////    [monitorTableArr removeAllObjects];
////    
////    [self getEffectiveData:retDataByMySelf];
////    
////}
////
////-(void)getNotificInfo //第一次启动时候获取tuner信息
////{
////    tunerNum = 0; ///******
////    [monitorTableArr removeAllObjects];
////    livePlayCount = 0;
////    liveRecordCount = 0;
////    liveTimeShiteCount = 0;
////    deliveryCount = 0;
////    pushVodCount = 0;
////    NSLog(@"=======================notific");
////    
//////    self.blocktest = ^(NSDictionary * dic)
//////    {
//////        //此处是返回值处理方法
//////        NSLog(@"此处是返回 :%@",dic);
//////    };
//////
////    //////////////////////////// 向TV页面发送通知
////    //创建通知
////    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
////    //通过通知中心发送通知
////    [[NSNotificationCenter defaultCenter] postNotification:notification];
////    [USER_DEFAULT  setObject:@"deviceClose" forKey:@"deviceOpenStr"];  //防止device页面接收
////    
////    
////  //////////////////////////// 从socket返回数据
////    //此处销毁通知，防止一个通知被多次调用
////    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getResourceInfo" object:nil];
////    //注册通知
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfo:) name:@"getResourceInfo" object:nil];
////    
////    
//////    [USER_DEFAULT objectForKey:@"CICHUSHIDIC"];
//////    NSLog(@"此处是返回：%@", [USER_DEFAULT objectForKey:@"CICHUSHIDIC"]);
////    
////}
////
////
////-(void)getResourceInfo:(NSNotification *)text
////{
////    
////    NSLog(@"moni:%@",text.userInfo[@"resourceInfoData"]);
////    //    int show = [text.userInfo[@"resourceInfoData"] intValue];
////    NSLog(@"此处是socket返回");
////    
////    NSData * retData = [[NSData alloc]init];
////    retData = text.userInfo[@"resourceInfoData"];    //返回的data
//////        [self getTunerNum:retData];  //获得总的tuner的数量
////        [self getEffectiveData:retData];//获得有效数据的信息，不同tuner的信息
////
////}
////
////-(void)loadNav
////{
////    
////}
////-(void)initData
////{
////    scrollUp = NO;
////    lastPosition = 0;
////    livePlayCount = 0;
////    liveRecordCount = 0;
////    liveTimeShiteCount = 0;
////    deliveryCount = 0;
////    pushVodCount = 0;
////    tunerNum = 0;
////    livePlayArr = [[NSMutableArray alloc]init];
////    liveRecordArr = [[NSMutableArray alloc]init];
////    liveTimeShiteArr = [[NSMutableArray alloc]init];
////    deliveryArr = [[NSMutableArray alloc]init];
////    pushVodArr = [[NSMutableArray alloc]init];
////    monitorTableDic = [[NSMutableDictionary alloc]init];
////    monitorTableArr = [[NSMutableArray alloc]init];
////    
////    refreshTimer = [[NSTimer alloc]init];
////    
////    
////    ///
//////    socketUtils = [[SocketUtils alloc]init];
////}
////
////-(void)initRefresh
////{
////    NSLog(@"=======================notific");
////    
////   
////    //
////    //////////////////////////// 向TV页面发送通知
////    //创建通知
////    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
////    //通过通知中心发送通知
////    [[NSNotificationCenter defaultCenter] postNotification:notification];
////    [USER_DEFAULT  setObject:@"deviceClose" forKey:@"deviceOpenStr"];  //防止device页面接收
////    
////    //////////////////////////// 从socket返回数据
////    //此处销毁通知，防止一个通知被多次调用
////    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getResourceInfo" object:nil];
////    //注册通知
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfo:) name:@"getResourceInfo" object:nil];
////    
////
////
////}
////-(void)loadUI
////{
////    NSLog(@"=======--:%ld",(long)tunerNum);
////    [self loadScroll];
////    [self loadColorView];  // 加载顶部的 多彩color 以及上面的各种图片
////
////   [self loadTableview];
////    
////    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshViewByJudgeData) userInfo:nil repeats:YES];
////    
////}
///////
////// 加载顶部的 多彩color 以及上面的各种图片
///////
////-(void)loadColorView
////{
////
////    colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
////    colorView.backgroundColor = [UIColor purpleColor];
////    [scrollView addSubview:colorView];
////    
////    colorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
////    colorImageView.image = [UIImage  imageNamed:@"监控渐变背景"];
////    [colorView addSubview:colorImageView];
////   
////    [self loadCicle];    //多彩color 图片上的各种图片添加
////    [self loadNumLab];  //底部的各项tuner的数量
////}
////-(void)loadCicle //多彩color 图片上的各种图片添加
////{
//////    tunerNum = 3;
////    
////     cicleClearImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 196)/2, 80 , 196, 195)];
////    cicleClearImageView.image = [UIImage  imageNamed:@"圆环"];
////    [colorImageView addSubview:cicleClearImageView];
////    
////    cicleBlueImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 196)/2, 80,196, 195)];
////    cicleBlueImageView.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"圆环-%ld",(long)tunerNum]];
////    [colorImageView addSubview:cicleBlueImageView];
////    
////    nineImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-5, cicleClearImageView.frame.size.height/2-25,36, 33)];
////    nineImage.image = [UIImage  imageNamed:@"nine"];
////    [cicleClearImageView addSubview:nineImage];
////    
////    
////     numImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-30, cicleClearImageView.frame.size.height/2-35,36, 43)];
////    numImage.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"M%ld",(long)tunerNum]];
////    [cicleClearImageView addSubview:numImage];
////    
////     labImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-30, cicleClearImageView.frame.size.height/2+10,65, 40)];
////    labImage.image = [UIImage  imageNamed:@"Tunermonitor"];
////    [cicleClearImageView addSubview:labImage];
////}
////-(void)loadNumLab  //底部的各项tuner的数量
////{
////    [self loadNumAnddelete];
////    
////    
////    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]    ) {
////        NSLog(@"此刻是5s和4s 的大小");
////        
////        UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8+14, 325, 2, 40)];
////        verticalView1.layer.cornerRadius = 1.0;
////        verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
////        [colorImageView addSubview:verticalView1];
////        
////        UIView * verticalView2 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(1+1)-2 +CutWidth*1 -3, 325, 2, 40)];
////        verticalView2.layer.cornerRadius = 1.0;
////        verticalView2.backgroundColor = RGBA(245, 245, 245, 0.3);
////        [colorImageView addSubview:verticalView2];
////        
////        UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2 - 11, 325, 2, 40)];
////        verticalView3.layer.cornerRadius = 1.0;
////        verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
////        [colorImageView addSubview:verticalView3];
////        
////
////    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]    || [deviceString isEqualToString:@"iPhone Simulator"] ) {
////        NSLog(@"此刻是6的大小");
////        
////        UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8, 325, 2, 40)];
////        verticalView1.layer.cornerRadius = 1.0;
////        verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
////        [colorImageView addSubview:verticalView1];
////        
////        UIView * verticalView2 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(1+1)-2 +CutWidth*1, 325, 2, 40)];
////        verticalView2.layer.cornerRadius = 1.0;
////        verticalView2.backgroundColor = RGBA(245, 245, 245, 0.3);
////        [colorImageView addSubview:verticalView2];
////        
////        UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2, 325, 2, 40)];
////        verticalView3.layer.cornerRadius = 1.0;
////        verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
////        [colorImageView addSubview:verticalView3];
////        
////
////    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
////        NSLog(@"此刻是6 plus的大小");
////        
////        UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8, 325, 2, 40)];
////        verticalView1.layer.cornerRadius = 1.0;
////        verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
////        [colorImageView addSubview:verticalView1];
////        
////        UIView * verticalView2 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(1+1)-2 +CutWidth*1, 325, 2, 40)];
////        verticalView2.layer.cornerRadius = 1.0;
////        verticalView2.backgroundColor = RGBA(245, 245, 245, 0.3);
////        [colorImageView addSubview:verticalView2];
////        
////        UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2, 325, 2, 40)];
////        verticalView3.layer.cornerRadius = 1.0;
////        verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
////        [colorImageView addSubview:verticalView3];
////    }
////    
////    
////    
////    
////  
////}
////-(void)loadNumAnddelete  //加载那些全局的数字，等待刷新并且删除重新加载一遍
////{
////    deviceString = [GGUtil deviceVersion];
////    
////
////    
////    
////    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]   ) {
////        NSLog(@"此刻是5s和4s 的大小");
////       
////        
////        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 360, 142/2, 13)];
////        liveNumLab.text = @"TV Live";
////        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
////        liveNumLab.font = FONT(13);
////        [colorImageView addSubview:liveNumLab];
////        
////        
////        recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(85, 360, 142/2, 13)];
////        recoderLab.text = @"Recoder";
////        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
////        recoderLab.font = FONT(13);
////        [colorImageView addSubview:recoderLab];
////        
////        timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(160, 360, 142/2, 13)];
////        timeShiftLab.text = @"Time Shift";
////        timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
////        timeShiftLab.font = FONT(13);
////        [colorImageView addSubview:timeShiftLab];
////        
////        //    distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 , 360, 142/2, 13)];
////        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(240, 360, 142/2, 13)];
////        distributeLab.text = @"Distribute";
////        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
////        distributeLab.font = FONT(13);
////        [colorImageView addSubview:distributeLab];
////        
////        //     liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20, liveNumLab.frame.origin.y-40, 16, 20)];
////         liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(35, liveNumLab.frame.origin.y-40, 16, 20)];
////        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
////        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
////        liveNum_Lab.font = FONT(24);
////        [colorImageView addSubview:liveNum_Lab];
////        
////        //     recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth +CutWidth, liveNumLab.frame.origin.y-40, 16, 20)];
////          recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(100, liveNumLab.frame.origin.y-40, 16, 20)];
////        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
////        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
////        recoder_Lab.font = FONT(24);
////        [colorImageView addSubview:recoder_Lab];
////        
////        //    timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
////         timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(180, liveNumLab.frame.origin.y-40, 16, 20)];
////        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
////        timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
////        timeShift_Lab.font = FONT(24);
////        [colorImageView addSubview:timeShift_Lab];
////        
////        //    distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*3 +CutWidth*3, liveNumLab.frame.origin.y-40, 16, 20)];
////         distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(260, liveNumLab.frame.origin.y-40, 16, 20)];
////        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
////        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
////        distribute_Lab.font = FONT(24);
////        [colorImageView addSubview:distribute_Lab];
////    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"] || [deviceString isEqualToString:@"iPhone Simulator"]) {
////        NSLog(@"此刻是6的大小");
////        
////        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft, 360, 142/2, 13)];
////        liveNumLab.text = @"TV Live";
////        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
////        liveNumLab.font = FONT(13);
////        [colorImageView addSubview:liveNumLab];
////        
////        recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth +CutWidth , 360, 142/2, 13)];
////        recoderLab.text = @"Recoder";
////        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
////        recoderLab.font = FONT(13);
////        [colorImageView addSubview:recoderLab];
////        
////        timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*2 +CutWidth*2 , 360, 142/2, 13)];
////        timeShiftLab.text = @"Time Shift";
////        timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
////        timeShiftLab.font = FONT(13);
////        [colorImageView addSubview:timeShiftLab];
////        
////        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 , 360, 142/2, 13)];
////        distributeLab.text = @"Distribute";
////        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
////        distributeLab.font = FONT(13);
////        [colorImageView addSubview:distributeLab];
////        
////        liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20, liveNumLab.frame.origin.y-40, 16, 20)];
////        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
////        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
////        liveNum_Lab.font = FONT(24);
////        [colorImageView addSubview:liveNum_Lab];
////        
////        recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth +CutWidth, liveNumLab.frame.origin.y-40, 16, 20)];
////        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
////        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
////        recoder_Lab.font = FONT(24);
////        [colorImageView addSubview:recoder_Lab];
////        
////        timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
////        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
////        timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
////        timeShift_Lab.font = FONT(24);
////        [colorImageView addSubview:timeShift_Lab];
////        
////        distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*3 +CutWidth*3, liveNumLab.frame.origin.y-40, 16, 20)];
////        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
////        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
////        distribute_Lab.font = FONT(24);
////        [colorImageView addSubview:distribute_Lab];
////        
////    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"]     ) {
////        NSLog(@"此刻是6 plus的大小");
////        
////        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft, 360, 142/2, 13)];
////        liveNumLab.text = @"TV Live";
////        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
////        liveNumLab.font = FONT(13);
////        [colorImageView addSubview:liveNumLab];
////        
////        recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth +CutWidth , 360, 142/2, 13)];
////        recoderLab.text = @"Recoder";
////        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
////        recoderLab.font = FONT(13);
////        [colorImageView addSubview:recoderLab];
////        
////        timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*2 +CutWidth*2 , 360, 142/2, 13)];
////        timeShiftLab.text = @"Time Shift";
////        timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
////        timeShiftLab.font = FONT(13);
////        [colorImageView addSubview:timeShiftLab];
////        
////        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 , 360, 142/2, 13)];
////        distributeLab.text = @"Distribute";
////        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
////        distributeLab.font = FONT(13);
////        [colorImageView addSubview:distributeLab];
////        
////        liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20, liveNumLab.frame.origin.y-40, 16, 20)];
////        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
////        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
////        liveNum_Lab.font = FONT(24);
////        [colorImageView addSubview:liveNum_Lab];
////        
////        recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth +CutWidth, liveNumLab.frame.origin.y-40, 16, 20)];
////        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
////        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
////        recoder_Lab.font = FONT(24);
////        [colorImageView addSubview:recoder_Lab];
////        
////        timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
////        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
////        timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
////        timeShift_Lab.font = FONT(24);
////        [colorImageView addSubview:timeShift_Lab];
////        
////        distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*3 +CutWidth*3, liveNumLab.frame.origin.y-40, 16, 20)];
////        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
////        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
////        distribute_Lab.font = FONT(24);
////        [colorImageView addSubview:distribute_Lab];
////        
////    }
////    
////    
////}
////-(void)loadScroll
////{
////    NSLog(@"=======================load scroll");
////    //加一个scrollview
////    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
////    [self.view addSubview:scrollView];
////    
////    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
////    //    scroll.pagingEnabled=YES;
////    scrollView.showsVerticalScrollIndicator=NO;
////    scrollView.showsHorizontalScrollIndicator=NO;
////    scrollView.delegate=self;
////    scrollView.bounces=NO;
////    
////}
////-(void)loadTableview
////{
////    NSLog(@"=======================load tableview");
////    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopViewHeight, SCREEN_WIDTH, tunerNum*80) style:UITableViewStylePlain];
////    self.tableView.delegate = self;
////    self.tableView.dataSource = self;
////    
////    self.tableView.scrollEnabled = NO;
////    [self.view addSubview:self.tableView];
////    [scrollView  addSubview:self.tableView];
////}
/////////////////
////- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
////{
////    
//////    return tunerNum;
////    NSLog(@"monitorTableArr.count %lu",(unsigned long)monitorTableArr.count);
////    return monitorTableArr.count;
////    
////    
////}
////-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    return 80;
////    
////}
////- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
////    
////    
////    MonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorCell"];
////    if (cell == nil){
////        cell = [MonitorCell loadFromNib];
//////        cell.backgroundColor=[UIColor clearColor];
////        
////        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
////        cell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
////        
//////        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
////    }
////    
////    for (int i = 0; i< monitorTableArr.count; i++) {
////        NSLog(@"monitorTableArr %@ :",monitorTableArr[i]);
////    }
////    if (! ISNULL(monitorTableArr)) {
////        NSLog(@"monitorTableArr[indexPath.row]; %@",monitorTableArr[indexPath.row]);
////        cell.dataArr = monitorTableArr[indexPath.row];
////    }else
////    {
////        NSLog(@"kong");
////    }
////    
////    
////   
////    return cell;
////    
////    
////}
////
//////-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//////{
//////    NSLog(@"点击了");
//////}
/////**
//// 获取当前连接tuner的数量
//// */
////-(NSInteger)getTunerNum:(NSData *)tunerAllData
////{
////    NSData * dataLen = [[NSData alloc]init];
////    dataLen = [tunerAllData subdataWithRange:NSMakeRange(27, 1)];
////    
//////    int value;
//////    value = 0;
////    NSLog(@"可能报错1");
//////    [tunerAllData getBytes: &value length: sizeof(value)];   //获取总长度
////      uint8_t value = [SocketUtils uint32FromBytes:tunerAllData];
////    NSLog(@"可能报错2");
////   
////    for (int i = 0; i<11; i++) {
////        if (value == 77+i*15) {
////            tunerNum = i;
////        }else
////        {
////        }
////    }
////    return tunerNum;
////}
////
//////获得有效数据的信息，不同tuner的信息
////-(void)getEffectiveData:(NSData *) allTunerData
////{
////    NSLog(@"=======================test gettuner");
////    //获取数据总长度
////    NSData * dataLen = [[NSData alloc]init];
////    dataLen = [allTunerData subdataWithRange:NSMakeRange(24, 4)];
////    
////    NSLog(@"datalen: %@",dataLen);
//////    int value;
//////    value = 0;
////    NSLog(@"可能报错3");
//////    [dataLen getBytes: &value length: sizeof(value)];   //获取总长度
////      uint8_t value = [SocketUtils uint32FromBytes:dataLen];
////   NSLog(@"可能报错4");
//////    [socketUtils uint16FromBytes:]
////    //tuner的有效数据区
////    NSData * effectiveData = [[NSData alloc]init];
////    effectiveData = [allTunerData subdataWithRange:NSMakeRange(38,(value-10))];
////    
////    //定位数据，用于看位于第几个字节，起始位置是在
////    int placeFigure = 3;
////    for (int ai = 0; ai < 11; ai++ ) {  //目前会返回11条数据
////   
////        
//////       NSMutableData * tunerDataone = [NSMutableData dataWithData:allTunerData];
////        int mutablefigure = placeFigure;
////        NSLog(@"----len placeFigure:%d",placeFigure);
////        NSLog(@"----len mutablefigure:%d",mutablefigure);
////        NSLog(@"----len effectiveData:%@",effectiveData);
//////        char buffer;
//////        [effectiveData getBytes:&buffer range:NSMakeRange(mutablefigure, 4)];
////
////        //判断长度，防止截取字符串的时候长度超过而产生报错。
////        uint8_t effectiveDataLength = [SocketUtils uint32FromBytes:effectiveData];
//////         [effectiveData getBytes: &effectiveDataLength length: sizeof(effectiveDataLength)];
////        
////        NSLog(@"effectiveDataLength :%d",effectiveDataLength);
////        if (effectiveDataLength >= mutablefigure + 4) {
////            
////            NSData * databuff = [effectiveData subdataWithRange:NSMakeRange(mutablefigure, 4)];
////        }
////            
////        
//////        Byte *buffer = (Byte *)[databuff bytes];
////        
////        char buffer1;
////        int buffer_int1 =placeFigure;
////        
////        if (buffer_int1 +1 <= [SocketUtils uint32FromBytes:effectiveData]) {
////        [effectiveData getBytes:&buffer1 range:NSMakeRange(buffer_int1, 1)];
////        }
////        
////        char buffer2;
////        int buffer_int2 =placeFigure+1;
////        
////        if (buffer_int2 +1 <= [SocketUtils uint32FromBytes:effectiveData]) {
////        [effectiveData getBytes:&buffer2 range:NSMakeRange(buffer_int2, 1)];
////        }
////        
////        char buffer3;
////        int buffer_int3 =placeFigure+2;
////        if (buffer_int3 +1 <= [SocketUtils uint32FromBytes:effectiveData]) {
////            [effectiveData getBytes:&buffer3 range:NSMakeRange(buffer_int3, 1)];
////        }
////        
////        char buffer4;
////        int buffer_int4 =placeFigure+3;
////        if (buffer_int4 +1 <= [SocketUtils uint32FromBytes:effectiveData]) {
////            [effectiveData getBytes:&buffer4 range:NSMakeRange(buffer_int4, 1)];
////        }
////        
////
////        if( buffer1 == 0x00 && buffer2 == 0x00&& buffer3 == 0x00 && buffer4 == 0x00)
////        {
////            NSLog(@"11");
////        }
////        else
////        {
////            
////            tunerNum ++;
////            NSLog(@"22");
////            
////            //这里获取service_type类型
////            NSData * serviceTypeData = [[NSData alloc]init];
////            
////            //判断长度，防止截取字符串的时候长度超过而产生报错。
////            uint8_t effectiveDataLength2 = [SocketUtils uint32FromBytes:effectiveData];
////            NSLog(@"effectiveDataLength :%d",effectiveDataLength2);
////            if (effectiveDataLength2 >= placeFigure +4 + 4) {
////                
////            serviceTypeData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+4, 4)];
////            }
////            
////            
////            
//////            int type;
//////            
//////            type =  [SocketUtils uint16FromBytes: serviceTypeData];
//////            if (type == 3) {
//////                NSLog(@"wocaowocaowocaowocao");
//////            }
////            
////            //这里获取network_id
////            NSData * networkIdData = [[NSData alloc]init];
////            networkIdData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+12, 2)];
////            //这里获取ts_id
////            NSData * tsIdData = [[NSData alloc]init];
////            tsIdData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+14, 2)];
////
////            //这里获取service_id
////            NSData * serviceIdData = [[NSData alloc]init];
////            serviceIdData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+16, 2)];
////            //这里获取name_len
////            NSData * nameLenData = [[NSData alloc]init];
////            uint8_t effectiveDataLength4 = [SocketUtils uint32FromBytes:effectiveData];
////            NSLog(@"effectiveDataLength4 :%d",effectiveDataLength4);
////            if (effectiveDataLength4 >= placeFigure+18 + 1) {
////                
////            nameLenData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+18, 1)];
////            }
////            
////            
////            
////          
////            //先看一下长度是不是0
////            char lenBuffer;
////            [nameLenData getBytes: &lenBuffer length: sizeof(lenBuffer)];
////            
////            int clientNameLen = 0;
////            NSData * clientNameData = [[NSData alloc]init];
////            if (lenBuffer == 0x00) {
////                
////                NSString *aString = @"";
////                clientNameData = [aString dataUsingEncoding: NSUTF8StringEncoding];
////            }else
////            {
////                
////                [nameLenData getBytes: &clientNameLen length: sizeof(clientNameLen)];
////                
////                int clienNameLenCopy = clientNameLen;
////                int clienNameLenCopy1 = clientNameLen;
////           
////                //获取client_name
////                
////                clientNameData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+18+1, clienNameLenCopy1)];
////            }
////          
////           
////            
////          
////            
////            
////            //此处做判断，看一下属于哪个tuner
////            TVhttpDic =  [USER_DEFAULT objectForKey:@"TVHttpAllData"];
////            NSArray * category1 = [TVhttpDic objectForKey:@"category"];
////            NSArray * service1 = [TVhttpDic objectForKey:@"service"];
////            
////            NSLog(@"category1 %@",category1);
////            NSLog(@"service1 %@",service1);
////            
////            for (int a = 0; a <service1.count ; a++) {
////                //原始数据
////                NSString * service_network =  [service1[a]objectForKey:@"service_network_id"];
////                NSString * service_ts =  [service1[a] objectForKey:@"service_ts_id"];
////                NSString * service_service =  [service1[a] objectForKey:@"service_service_id"];
//////                NSString * service_tuner =  [service1[ai] objectForKey:@"service_tuner_mode"];
////                
////                
//////                //新的数据
////                NSString * newservice_network = [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: networkIdData]]; //[[NSString alloc]initWithData:networkIdData encoding:NSUTF8StringEncoding];
////                
////                
////                NSString * newservice_ts =   [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: tsIdData]];//[[NSString alloc]initWithData:tsIdData encoding:NSUTF8StringEncoding];
////                NSString * newservice_service = [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: serviceIdData]];// [[NSString alloc]initWithData:serviceIdData encoding:NSUTF8StringEncoding];
//////                NSString * newservice_tunertype =  [[NSString alloc]initWithData:serviceTypeData encoding:NSUTF8StringEncoding];
//////                NSString * newservice_apiservicetype =  [[NSString alloc]initWithData:serviceTypeData encoding:NSUTF8StringEncoding];
////                
////                if ([service_network isEqualToString:newservice_network] && [service_ts isEqualToString:newservice_ts]  && [service_service isEqualToString:newservice_service]  //&& [service_tuner isEqualToString:newservice_tunertype]
////                    ) {
////                   
////                    //这种情况下是找到了节目
////                    NSArray * arr_threeData =[ [NSArray alloc]initWithObjects:service1[a],serviceTypeData,clientNameData, nil];
////                    
////                    [monitorTableArr addObject:arr_threeData];  //把展示节目列表添加到数组中，用于展示
////                    
////             
////                 [self.tableView reloadData];
////                }
////                else //此处是一种特殊情况，没有找到这个节目
////                {
////                    [self.tableView reloadData];
////                }
////                
////            }
////            
////            
////            
////      
////       
////  //***********
////            
////            //            char serviceTypeBuf;
//////
//////            [serviceTypeData getBytes:&buffer range:NSMakeRange(placeFigure, 4)];
////            
////            //            char serviceTypeBuf;
//////            [serviceTypeData getBytes:&buffer range:NSMakeRange(placeFigure, 4)];
////            
////            //判断service_typedata,判断是不是分发，时移，录制
////            [self judgeTunerClass:serviceTypeData];
////            
////            ////
////            placeFigure  = placeFigure + 15+clientNameLen;
////        }
////       
//////        int mutablefigure = ai;
//////        mutablefigure = mutablefigure*7;
////        placeFigure =placeFigure +7;  //placeFigure+ mutablefigure ;
////        
////    }
////    
//////    [self loadNav];
//////    [self loadUI];
////    
//////    [self loadCicle];
//////    [self loadTableview];
//////    [self loadNumLab];
////    
////    if (tableInitNum == 0) {
////         [self loadTableview];
////        tableInitNum++;
////        
////    }
//////    else
//////    {
//////     [tableView reloadData];
//////    }
////    
////    [tableView reloadData];
//////    [self loadTableview];
////    [self changeView];
////}
////
////-(void)changeView
////{
//////    NSLog(@"monitorTableArr :%@,",monitorTableArr);
////   
////    int monitorApperCount ;
////    NSString * monitorApperCountStr =  [USER_DEFAULT objectForKey:@"monitorApperCountStr"];
////    monitorApperCount = [monitorApperCountStr intValue];
////    if (monitorApperCount == 0) {
////    
////        cicleBlueImageView.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"圆环-%ld",(long)tunerNum]];
////        
////        numImage.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"M%ld",(long)tunerNum]];
////        
////        
////        
////        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
////        
////        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
////        
////        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
////        
////        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
////        
////        
////        
////        if (scrollUp == YES) {
////            self.scrollView.frame = CGRectMake(0, -275, SCREEN_WIDTH, SCREEN_HEIGHT);
////            
////            self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
////            
////            
////        }else
////        {
////            self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
////            //                             scrollView.contentOffset = CGPointMake(0, 0);
////            self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
////            
////            self.tableView.editing = NO;
////        }
////        
////        
////        
////        
////        //    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
////        
////        self.tableView.frame =  CGRectMake(0, TopViewHeight, SCREEN_WIDTH, tunerNum*80);
////        
////        //
////        //    self.scrollView.frame = CGRectMake(0, -300, SCREEN_WIDTH, SCREEN_HEIGHT);
////        //    
////        //    TopViewHeight+tunerNum*80+200-93);
////        //    scrollUp = YES;
////        //    self.tableView.scrollEnabled = YES;
////        
////        [USER_DEFAULT setObject:monitorTableArr forKey:@"monitorTableArrTemp"];
////        
////        NSLog(@"monitorTableArrTemp.count ；%d",monitorTableArr.count);
////        
////    }else
////    {
////        NSArray * monitorTableArrTemp = [USER_DEFAULT objectForKey:@"monitorTableArrTemp"];
////     
////        
////        NSLog(@"monitorTableArraaaa :%@,",monitorTableArr);
////        NSLog(@"monitorTableArrTemp :%@,",monitorTableArrTemp);
////        
////        NSLog(@"monitorTableArrTemp.count ；%d",monitorTableArrTemp.count);
////        NSLog(@"monitorTableArr.count ；%d",monitorTableArr.count);
////        if ([monitorTableArr isEqualToArray:monitorTableArrTemp]) {
////            NSLog(@"相等相等相等相等相等相等相等");
////        }else
////        {
////            NSLog(@"不不不不相等相等相等相等相等相等相等");
////            
////            [self performSelector:@selector(willReFresh) withObject:self afterDelay:0.2];
////        }
////    
////    }
////    
////    
////  
////
////}
////
////-(void)judgeTunerClass:(NSData * )typeData
////{
////
////    int type;
//////    [typeData getBytes: &type length: sizeof(type)];
//////    NSLog(@"typedata :%@",typeData);
//////    NSLog(@"type:%d",type);
////    type =  [SocketUtils uint16FromBytes: typeData];
////    NSLog(@"typedata :%@",typeData);
////    NSLog(@"type:%d",type);
////    switch (type) {
////        case INVALID_Service:
////            
////            break;
////        case LIVE_PLAY:
////            livePlayCount ++;
////            break;
////        case LIVE_RECORD:
////            liveRecordCount ++;
////            break;
////        case LIVE_TIME_SHIFT:
////            liveTimeShiteCount ++;
////            break;
////        case DELIVERY:
////            deliveryCount ++;
////            break;
////        case PUSH_VOD:
////            pushVodCount ++;
////            break;
////        default:
////            break;
////    }
////    
////}
////
////
//////// 开始拖拽
//////- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//////{
////////    NSLog(@"++开始拖拽");
//////    if (scrollView.class ==  self.tableView.class) {
//////        NSLog(@"tableview:.y");
//////        int currentPostion = scrollView.contentOffset.y;
//////    NSLog(@"tableview.contentOffset.y:%f",self.scrollView.contentOffset.y);
//////    }
//////    
//////    if (scrollView.class ==  self.scrollView.class) {
//////        NSLog(@"scroll:.y");
//////    }
//////}
////
////
////
////- (void)scrollViewDidScroll:(UIScrollView *)scrollView
////{
////    NSLog(@"scrollView.contentOffset.y:%f",self.scrollView.contentOffset.y);
////    int currentPostion = scrollView.contentOffset.y;
////    if (currentPostion - lastPosition > 30 && self.scrollView.contentOffset.y >50 && scrollUp == NO){
////        CGPoint position = CGPointMake(0, 275);
//////        [scrollView     :position animated:YES];
////        [UIView animateWithDuration:0.5
////                              delay:0.02
////                            options:UIViewAnimationCurveLinear
////                         animations:^{
////
////                            self.scrollView.frame = CGRectMake(0, -275, SCREEN_WIDTH, SCREEN_HEIGHT+tunerNum*80+200);//
////
////                             self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT); //TopViewHeight+tunerNum*80+200-93);
////                             scrollUp = YES;
////                         self.tableView.scrollEnabled = YES;
////                             //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
////                         }
////                         completion:^(BOOL finished)
////         {
////             NSLog(@"animate");
////             self.tableView.scrollEnabled = YES;
////         } ];
////        NSLog(@"scrollView.contentOffset2.y:%f",scrollView.contentOffset.y);
////        self.tableView.scrollEnabled = YES;
////    }
////    
////    
////
////
////    if(scrollView.class == self.tableView.class){
////    if (self.tableView.contentOffset.y<-30&& scrollUp == YES
//////        currentPostion - lastPosition < 20 && scrollView.contentOffset.y <25
////        ){
////        CGPoint position = CGPointMake(0, 275);
////        
////        [UIView animateWithDuration:0.5
////                              delay:0.02
////                            options:UIViewAnimationCurveLinear
////                         animations:^{
////                             //                             [scrollView setContentOffset: position ];
////                             self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
////                             //                             scrollView.contentOffset = CGPointMake(0, 0);
////                             self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);//SCREEN_HEIGHT); //TopViewHeight+tunerNum*80+200);
////                             scrollUp = NO;
////                             //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
////                         self.tableView.scrollEnabled = NO;
////                         }
////                         completion:^(BOOL finished)
////         { NSLog(@"animate");
////             self.tableView.scrollEnabled = NO;
////         } ];
////        NSLog(@"scrollView.contentOffset2.y:%f",scrollView.contentOffset.y);
////        self.tableView.scrollEnabled = NO;
////    }
////    }
////
////}
////
//////***********删除代码
////-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    //>>
////    NSArray * monitorTypeArr = [[NSArray alloc]init];
////    monitorTypeArr =   monitorTableArr[indexPath.row];
////    NSData * tableTypedata = monitorTypeArr[1];
////    
////    NSData * phoneClientName = monitorTypeArr[2];
////    int type;
////    type =  [SocketUtils uint16FromBytes: tableTypedata];  //tuner的类别
////    
////    NSString * clientNameStr = [[NSString alloc]initWithData:phoneClientName encoding:NSUTF8StringEncoding];  //获取的设备名称
////    NSString * phoneModel =  [GGUtil deviceVersion]; //[self deviceVersion];
////    NSLog(@"手机型号:%@",phoneModel);
////    NSString* client_name = [NSString stringWithFormat:@"Phone%@",phoneModel];  //***
////    //实际情况下此处可做修改：
////    if (type == DELIVERY  &&[clientNameStr isEqualToString:phoneModel]){//&&  [clientNameStr isEqualToString:client_name]) {
////        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
////            return UITableViewCellEditingStyleDelete;
////    }
////    return UITableViewCellEditingStyleNone;
////    
////    //>>
////    
////    
//////    return UITableViewCellEditingStyleDelete;
////}
////
/////*改变删除按钮的title*/
////-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    return @" DEL ";
////}
////
/////*删除用到的函数*/
////-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
////{
////     [tableView beginUpdates];
////    if (editingStyle == UITableViewCellEditingStyleDelete)
////    {
////        /*此处处理自己的代码，如删除数据*/
////        
////        //////////////////////////// 向TV页面发送通知
////        //创建通知
////        NSNotification *notification =[NSNotification notificationWithName:@"deleteTuner" object:nil userInfo:nil];
////        //通过通知中心发送通知
////        [[NSNotificationCenter defaultCenter] postNotification:notification];
////        
////        
////        
////        
//////        //////////////////////////// 从socket返回数据
//////        //此处销毁通知，防止一个通知被多次调用
//////        [[NSNotificationCenter defaultCenter] removeObserver:self];
//////        //注册通知
//////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfo:) name:@"getResourceInfo" object:nil];
////
////        
////        
////        
////        ///////******
////        NSLog(@"monitorTableArr:%@",monitorTableArr);
////        [monitorTableArr removeObjectAtIndex:indexPath.row];
////        //这里添加删除的socket
////        /*删除tableView中的一行*/
////        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
////        
////         [tableView reloadData];
////        
////    }
////    
////    
//////   [self viewWillAppear:YES];
////    [tableView endUpdates];
//////  [self getNotificInfo];  
////    [self performSelector:@selector(willReFresh) withObject:self afterDelay:0.2];
////}
////
////-(void)willReFresh
////{
////    int monitorApperCount = 0 ;
////    NSString * monitorApperCountStr = [NSString stringWithFormat:@"%d",monitorApperCount];
////    [USER_DEFAULT setObject:monitorApperCountStr forKey:@"monitorApperCountStr"];
////    
////    [self getNotificInfo];
////}
////
////
////
////
//////************
////- (void)didReceiveMemoryWarning {
////    [super didReceiveMemoryWarning];
////    // Dispose of any resources that can be recreated.
////}
////@end
//
////
////  MonitorViewController.m
////  StarAPP
////
////  Created by xyz on 16/8/29.
////
////
//
//#import "MonitorViewController.h"
//#import "sys/utsname.h"
//#define kShadowRadius 20
//#define TopViewHeight 400
//#define TopBottomNameWidth 142/2
//#define CutWidth 30/2
//#define TopBottomNameMarginLeft (SCREEN_WIDTH-4*TopBottomNameWidth-3*CutWidth)/2
//
//@interface MonitorViewController ()
//{
//    NSInteger tunerNum;
//    NSMutableArray *  livePlayArr;
//    NSMutableArray *  liveRecordArr;
//    NSMutableArray *  liveTimeShiteArr;
//    NSMutableArray *  deliveryArr;
//    NSMutableArray *  pushVodArr;
//    
//    NSInteger   livePlayCount;
//    NSInteger   liveRecordCount;
//    NSInteger   liveTimeShiteCount;
//    NSInteger   deliveryCount;
//    NSInteger   pushVodCount;
//    BOOL scrollUp;
//    int lastPosition ;
//    
//    NSInteger tableInitNum;
//    
//    NSTimer *  refreshTimer ;  //定时刷新，暂定时间5秒
//    
//    NSString * deviceString;
//    
//}
//@end
//
//@implementation MonitorViewController
//@synthesize scrollView;
//@synthesize tableView;
//@synthesize colorView;
//@synthesize colorImageView;
//@synthesize TVhttpDic;
//@synthesize monitorTableDic;
//@synthesize monitorTableArr;
//@synthesize socketUtils;
//// loadnum
//@synthesize liveNumLab;
//@synthesize recoderLab;
//@synthesize timeShiftLab;
//@synthesize distributeLab;
//@synthesize liveNum_Lab;
//@synthesize recoder_Lab;
//@synthesize timeShift_Lab;
//@synthesize distribute_Lab;
//
////loadColor Cicle
//@synthesize cicleClearImageView;
//@synthesize cicleBlueImageView;
//@synthesize nineImage;
//@synthesize numImage;
//@synthesize labImage;
//@synthesize isRefreshScroll;
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    //修改tabbar选中的图片颜色和字体颜色
//    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.tabBarItem.selectedImage = image;
//    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
//    
//    
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    isRefreshScroll = YES;
//    
//    int monitorApperCount = 0;
//    NSString * monitorApperCountStr = [NSString stringWithFormat:@"%d",monitorApperCount];
//    [USER_DEFAULT setObject:monitorApperCountStr forKey:@"monitorApperCountStr"];
//    
//    
//    [self initData];
//    
//    
//    
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [USER_DEFAULT setObject:@"MonitorView_Now" forKey:@"viewTOview"];
//    [USER_DEFAULT setObject:[NSNumber numberWithInt:1] forKey:@"viewDidloadHasRunBool"];     // 此处做一次判断，判断是不是连接状态，如果是的，则执行live页面的时候不执行【socket viewDidload】
//    
//    if (isRefreshScroll) {
//        tableInitNum = 0;
//        [scrollView removeFromSuperview];
//        scrollView = nil;
//        
//        //    UILabel * shadowLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 230, 30)];
//        //    shadowLab.text = @"测试案例";
//        //    shadowLab.shadowColor = RGBA(30, 30, 30, 0.5) ;//设置文本的阴影色彩和透明度。
//        //     shadowLab.shadowOffset = CGSizeMake(2.0f, 2.0f);     //设置阴影的倾斜角度。
//        //    UILabel * shadowLab1 = [[UILabel alloc]initWithFrame:CGRectMake(210, 120, 230, 30)];
//        //    shadowLab1.text = @"123123213123";
//        //
//        //    shadowLab1.shadowColor = RGBA(130, 130, 30, 0.5);    //设置文本的阴影色彩和透明度。
//        //    shadowLab1.shadowOffset = CGSizeMake(2.0f, 2.0f);     //设置阴影的倾斜角度。
//        //
//        //    [self.view addSubview:shadowLab];
//        //    [self.view addSubview:shadowLab1];
//        //    [self getTunerInfo];
//        //        [self initData];
//        [self loadUI];  //***
//        [self getNotificInfo]; //通过发送通知给TV页，TV页通过socket获取到tuner消息
//        //    [self initRefresh]; //开始每隔几秒向TV页发送通知，用来收到数据并且刷新数据
//        //    [self loadNav];
//        isRefreshScroll = NO;
//    }else
//    {
//        //1.获取数据，判断数据和原来的是不是一样，如果不一样，准备刷新
//        //2.删除所有的东西，加载所有的东西
//        [self refreshViewByJudgeData];  //通过获得一次tuner消息，判断tuner消息是不是发生了变化
//        
//    }
//    
//    
//    [self TVViewAppear];
//    
//}
//-(void)TVViewAppear
//{
//    [USER_DEFAULT setObject:@"YES" forKey:@"jumpFormOtherView"];//为TV页面存储方法
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
//    //////////////////////////// 向TV页面发送通知
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    [USER_DEFAULT  setObject:@"deviceClose" forKey:@"deviceOpenStr"];  //防止device页面接收
//    
//    
//    //////////////////////////// 从socket返回数据
//    //此处销毁通知，防止一个通知被多次调用
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getNotificInfoByMySelf" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificInfoByMySelf:) name:@"getNotificInfoByMySelf" object:nil];
//    
//    
//}
//-(void)getNotificInfoByMySelf:(NSNotification *)text
//{
//    
//    
//    NSData * retDataByMySelf = [[NSData alloc]init];
//    retDataByMySelf = text.userInfo[@"resourceInfoData"];    //返回的data
//    
//    //    NSData * dataTemp = [[NSData alloc]init];
//    //    dataTemp = [USER_DEFAULT objectForKey:@"retDataForMonitor"];
//    NSLog(@"retDataByMySelf: %@",retDataByMySelf);
//    
//    [monitorTableArr removeAllObjects];
//    
//    [self getEffectiveData:retDataByMySelf];
//    
//}
//
//-(void)getNotificInfo //第一次启动时候获取tuner信息
//{
//    tunerNum = 0; ///******
//    [monitorTableArr removeAllObjects];
//    livePlayCount = 0;
//    liveRecordCount = 0;
//    liveTimeShiteCount = 0;
//    deliveryCount = 0;
//    pushVodCount = 0;
//    NSLog(@"=======================notific");
//    
//    //    self.blocktest = ^(NSDictionary * dic)
//    //    {
//    //        //此处是返回值处理方法
//    //        NSLog(@"此处是返回 :%@",dic);
//    //    };
//    //
//    //////////////////////////// 向TV页面发送通知
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    [USER_DEFAULT  setObject:@"deviceClose" forKey:@"deviceOpenStr"];  //防止device页面接收
//    
//    
//    //////////////////////////// 从socket返回数据
//    //此处销毁通知，防止一个通知被多次调用
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getResourceInfo" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfo:) name:@"getResourceInfo" object:nil];
//    
//    
//    //    [USER_DEFAULT objectForKey:@"CICHUSHIDIC"];
//    //    NSLog(@"此处是返回：%@", [USER_DEFAULT objectForKey:@"CICHUSHIDIC"]);
//    
//}
//
//
//-(void)getResourceInfo:(NSNotification *)text
//{
//    
//    NSLog(@"moni:%@",text.userInfo[@"resourceInfoData"]);
//    //    int show = [text.userInfo[@"resourceInfoData"] intValue];
//    NSLog(@"此处是socket返回");
//    
//    NSData * retData = [[NSData alloc]init];
//    retData = text.userInfo[@"resourceInfoData"];    //返回的data
//    //        [self getTunerNum:retData];  //获得总的tuner的数量
//    [self getEffectiveData:retData];//获得有效数据的信息，不同tuner的信息
//    
//}
//
//-(void)loadNav
//{
//    
//}
//-(void)initData
//{
//    scrollUp = NO;
//    lastPosition = 0;
//    livePlayCount = 0;
//    liveRecordCount = 0;
//    liveTimeShiteCount = 0;
//    deliveryCount = 0;
//    pushVodCount = 0;
//    tunerNum = 0;
//    livePlayArr = [[NSMutableArray alloc]init];
//    liveRecordArr = [[NSMutableArray alloc]init];
//    liveTimeShiteArr = [[NSMutableArray alloc]init];
//    deliveryArr = [[NSMutableArray alloc]init];
//    pushVodArr = [[NSMutableArray alloc]init];
//    monitorTableDic = [[NSMutableDictionary alloc]init];
//    monitorTableArr = [[NSMutableArray alloc]init];
//    
//    refreshTimer = [[NSTimer alloc]init];
//    
//    
//    ///
//    //    socketUtils = [[SocketUtils alloc]init];
//}
//
//-(void)initRefresh
//{
//    NSLog(@"=======================notific");
//    
//    
//    //
//    //////////////////////////// 向TV页面发送通知
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    [USER_DEFAULT  setObject:@"deviceClose" forKey:@"deviceOpenStr"];  //防止device页面接收
//    
//    //////////////////////////// 从socket返回数据
//    //此处销毁通知，防止一个通知被多次调用
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getResourceInfo" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfo:) name:@"getResourceInfo" object:nil];
//    
//    
//    
//}
//-(void)loadUI
//{
//    NSLog(@"=======--:%ld",(long)tunerNum);
//    [self loadScroll];
//    [self loadColorView];  // 加载顶部的 多彩color 以及上面的各种图片
//    
//    [self loadTableview];
//    
//    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshViewByJudgeData) userInfo:nil repeats:YES];
//    
//}
/////
//// 加载顶部的 多彩color 以及上面的各种图片
/////
//-(void)loadColorView
//{
//    
//    colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
//    colorView.backgroundColor = [UIColor purpleColor];
//    [scrollView addSubview:colorView];
//    
//    colorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
//    colorImageView.image = [UIImage  imageNamed:@"监控渐变背景"];
//    [colorView addSubview:colorImageView];
//    
//    [self loadCicle];    //多彩color 图片上的各种图片添加
//    [self loadNumLab];  //底部的各项tuner的数量
//}
//-(void)loadCicle //多彩color 图片上的各种图片添加
//{
//    //    tunerNum = 3;
//    
//    cicleClearImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 196)/2, 80 , 196, 195)];
//    cicleClearImageView.image = [UIImage  imageNamed:@"圆环"];
//    [colorImageView addSubview:cicleClearImageView];
//    
//    cicleBlueImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 196)/2, 80,196, 195)];
//    cicleBlueImageView.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"圆环-%ld",(long)tunerNum]];
//    [colorImageView addSubview:cicleBlueImageView];
//    
//    nineImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-5, cicleClearImageView.frame.size.height/2-25,36, 33)];
//    nineImage.image = [UIImage  imageNamed:@"nine"];
//    [cicleClearImageView addSubview:nineImage];
//    
//    
//    numImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-30, cicleClearImageView.frame.size.height/2-35,36, 43)];
//    numImage.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"M%ld",(long)tunerNum]];
//    [cicleClearImageView addSubview:numImage];
//    
//    labImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-30, cicleClearImageView.frame.size.height/2+10,65, 40)];
//    labImage.image = [UIImage  imageNamed:@"Tunermonitor"];
//    [cicleClearImageView addSubview:labImage];
//}
//-(void)loadNumLab  //底部的各项tuner的数量
//{
//    [self loadNumAnddelete];
//    
//    
//    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]    ) {
//        NSLog(@"此刻是5s和4s 的大小");
//        
//        UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8+14, 325, 2, 40)];
//        verticalView1.layer.cornerRadius = 1.0;
//        verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView1];
//        
//        UIView * verticalView2 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(1+1)-2 +CutWidth*1 -3, 325, 2, 40)];
//        verticalView2.layer.cornerRadius = 1.0;
//        verticalView2.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView2];
//        
//        UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2 - 11, 325, 2, 40)];
//        verticalView3.layer.cornerRadius = 1.0;
//        verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView3];
//        
//        
//    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]    || [deviceString isEqualToString:@"iPhone Simulator"] ) {
//        NSLog(@"此刻是6的大小");
//        
//        UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8, 325, 2, 40)];
//        verticalView1.layer.cornerRadius = 1.0;
//        verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView1];
//        
//        UIView * verticalView2 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(1+1)-2 +CutWidth*1, 325, 2, 40)];
//        verticalView2.layer.cornerRadius = 1.0;
//        verticalView2.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView2];
//        
//        UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2, 325, 2, 40)];
//        verticalView3.layer.cornerRadius = 1.0;
//        verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView3];
//        
//        
//    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
//        NSLog(@"此刻是6 plus的大小");
//        
//        UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8, 325, 2, 40)];
//        verticalView1.layer.cornerRadius = 1.0;
//        verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView1];
//        
//        UIView * verticalView2 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(1+1)-2 +CutWidth*1, 325, 2, 40)];
//        verticalView2.layer.cornerRadius = 1.0;
//        verticalView2.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView2];
//        
//        UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2, 325, 2, 40)];
//        verticalView3.layer.cornerRadius = 1.0;
//        verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView3];
//    }
//    
//    
//    
//    
//    
//}
//-(void)loadNumAnddelete  //加载那些全局的数字，等待刷新并且删除重新加载一遍
//{
//    deviceString = [GGUtil deviceVersion];
//    
//    
//    
//    
//    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]   ) {
//        NSLog(@"此刻是5s和4s 的大小");
//        
//        
//        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 360, 142/2, 13)];
//        liveNumLab.text = @"TV Live";
//        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
//        liveNumLab.font = FONT(13);
//        [colorImageView addSubview:liveNumLab];
//        
//        
//        recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(85, 360, 142/2, 13)];
//        recoderLab.text = @"Recoder";
//        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
//        recoderLab.font = FONT(13);
//        [colorImageView addSubview:recoderLab];
//        
//        timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(160, 360, 142/2, 13)];
//        timeShiftLab.text = @"Time Shift";
//        timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
//        timeShiftLab.font = FONT(13);
//        [colorImageView addSubview:timeShiftLab];
//        
//        //    distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 , 360, 142/2, 13)];
//        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(240, 360, 142/2, 13)];
//        distributeLab.text = @"Distribute";
//        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
//        distributeLab.font = FONT(13);
//        [colorImageView addSubview:distributeLab];
//        
//        //     liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20, liveNumLab.frame.origin.y-40, 16, 20)];
//        liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(35, liveNumLab.frame.origin.y-40, 16, 20)];
//        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
//        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        liveNum_Lab.font = FONT(24);
//        [colorImageView addSubview:liveNum_Lab];
//        
//        //     recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth +CutWidth, liveNumLab.frame.origin.y-40, 16, 20)];
//        recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(100, liveNumLab.frame.origin.y-40, 16, 20)];
//        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
//        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        recoder_Lab.font = FONT(24);
//        [colorImageView addSubview:recoder_Lab];
//        
//        //    timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
//        timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(180, liveNumLab.frame.origin.y-40, 16, 20)];
//        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
//        timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        timeShift_Lab.font = FONT(24);
//        [colorImageView addSubview:timeShift_Lab];
//        
//        //    distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*3 +CutWidth*3, liveNumLab.frame.origin.y-40, 16, 20)];
//        distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(260, liveNumLab.frame.origin.y-40, 16, 20)];
//        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
//        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        distribute_Lab.font = FONT(24);
//        [colorImageView addSubview:distribute_Lab];
//    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"] || [deviceString isEqualToString:@"iPhone Simulator"]) {
//        NSLog(@"此刻是6的大小");
//        
//        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft, 360, 142/2, 13)];
//        liveNumLab.text = @"TV Live";
//        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
//        liveNumLab.font = FONT(13);
//        [colorImageView addSubview:liveNumLab];
//        
//        recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth +CutWidth , 360, 142/2, 13)];
//        recoderLab.text = @"Recoder";
//        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
//        recoderLab.font = FONT(13);
//        [colorImageView addSubview:recoderLab];
//        
//        timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*2 +CutWidth*2 , 360, 142/2, 13)];
//        timeShiftLab.text = @"Time Shift";
//        timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
//        timeShiftLab.font = FONT(13);
//        [colorImageView addSubview:timeShiftLab];
//        
//        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 , 360, 142/2, 13)];
//        distributeLab.text = @"Distribute";
//        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
//        distributeLab.font = FONT(13);
//        [colorImageView addSubview:distributeLab];
//        
//        liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20, liveNumLab.frame.origin.y-40, 16, 20)];
//        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
//        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        liveNum_Lab.font = FONT(24);
//        [colorImageView addSubview:liveNum_Lab];
//        
//        recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth +CutWidth, liveNumLab.frame.origin.y-40, 16, 20)];
//        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
//        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        recoder_Lab.font = FONT(24);
//        [colorImageView addSubview:recoder_Lab];
//        
//        timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
//        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
//        timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        timeShift_Lab.font = FONT(24);
//        [colorImageView addSubview:timeShift_Lab];
//        
//        distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*3 +CutWidth*3, liveNumLab.frame.origin.y-40, 16, 20)];
//        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
//        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        distribute_Lab.font = FONT(24);
//        [colorImageView addSubview:distribute_Lab];
//        
//    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"]     ) {
//        NSLog(@"此刻是6 plus的大小");
//        
//        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft, 360, 142/2, 13)];
//        liveNumLab.text = @"TV Live";
//        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
//        liveNumLab.font = FONT(13);
//        [colorImageView addSubview:liveNumLab];
//        
//        recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth +CutWidth , 360, 142/2, 13)];
//        recoderLab.text = @"Recoder";
//        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
//        recoderLab.font = FONT(13);
//        [colorImageView addSubview:recoderLab];
//        
//        timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*2 +CutWidth*2 , 360, 142/2, 13)];
//        timeShiftLab.text = @"Time Shift";
//        timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
//        timeShiftLab.font = FONT(13);
//        [colorImageView addSubview:timeShiftLab];
//        
//        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 , 360, 142/2, 13)];
//        distributeLab.text = @"Distribute";
//        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
//        distributeLab.font = FONT(13);
//        [colorImageView addSubview:distributeLab];
//        
//        liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20, liveNumLab.frame.origin.y-40, 16, 20)];
//        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
//        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        liveNum_Lab.font = FONT(24);
//        [colorImageView addSubview:liveNum_Lab];
//        
//        recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth +CutWidth, liveNumLab.frame.origin.y-40, 16, 20)];
//        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
//        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        recoder_Lab.font = FONT(24);
//        [colorImageView addSubview:recoder_Lab];
//        
//        timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
//        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
//        timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        timeShift_Lab.font = FONT(24);
//        [colorImageView addSubview:timeShift_Lab];
//        
//        distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*3 +CutWidth*3, liveNumLab.frame.origin.y-40, 16, 20)];
//        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
//        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        distribute_Lab.font = FONT(24);
//        [colorImageView addSubview:distribute_Lab];
//        
//    }
//    
//    
//}
//-(void)loadScroll
//{
//    NSLog(@"=======================load scroll");
//    //加一个scrollview
//    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [self.view addSubview:scrollView];
//    
//    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
//    //    scroll.pagingEnabled=YES;
//    scrollView.showsVerticalScrollIndicator=NO;
//    scrollView.showsHorizontalScrollIndicator=NO;
//    scrollView.delegate=self;
//    scrollView.bounces=NO;
//    
//}
//-(void)loadTableview
//{
//    NSLog(@"=======================load tableview");
//    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopViewHeight, SCREEN_WIDTH, tunerNum*80) style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    
//    self.tableView.scrollEnabled = NO;
//    [self.view addSubview:self.tableView];
//    [scrollView  addSubview:self.tableView];
//}
///////////////
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
//{
//    
//    //    return tunerNum;
//    return monitorTableArr.count;
//    
//}
//-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//    
//}
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//    MonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorCell"];
//    if (cell == nil){
//        cell = [MonitorCell loadFromNib];
//        //        cell.backgroundColor=[UIColor clearColor];
//        
//        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
//        
//        //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//    
//    if (! ISNULL(monitorTableArr)) {
//        cell.dataArr = monitorTableArr[indexPath.row];
//    }else
//    {
//    }
//    
//    
//    
//    return cell;
//    
//    
//}
//
////-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    NSLog(@"点击了");
////}
///**
// 获取当前连接tuner的数量
// */
//-(NSInteger)getTunerNum:(NSData *)tunerAllData
//{
//    NSData * dataLen = [[NSData alloc]init];
//    dataLen = [tunerAllData subdataWithRange:NSMakeRange(27, 1)];
//    
//    //    int value;
//    //    value = 0;
//    NSLog(@"可能报错1");
//    //    [tunerAllData getBytes: &value length: sizeof(value)];   //获取总长度
//    uint8_t value = [SocketUtils uint32FromBytes:tunerAllData];
//    NSLog(@"可能报错2");
//    
//    for (int i = 0; i<11; i++) {
//        if (value == 77+i*15) {
//            tunerNum = i;
//        }else
//        {
//        }
//    }
//    return tunerNum;
//}
//
////获得有效数据的信息，不同tuner的信息
//-(void)getEffectiveData:(NSData *) allTunerData
//{
//    NSLog(@"=======================test gettuner");
//    //获取数据总长度
//    NSData * dataLen = [[NSData alloc]init];
//    dataLen = [allTunerData subdataWithRange:NSMakeRange(24, 4)];
//    
//    NSLog(@"datalen: %@",dataLen);
//    //    int value;
//    //    value = 0;
//    NSLog(@"可能报错3");
//    //    [dataLen getBytes: &value length: sizeof(value)];   //获取总长度
//    uint8_t value = [SocketUtils uint32FromBytes:dataLen];
//    NSLog(@"可能报错4");
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
//            //此处做判断，看一下属于哪个tuner
//            TVhttpDic =  [USER_DEFAULT objectForKey:@"TVHttpAllData"];
//            NSArray * category1 = [TVhttpDic objectForKey:@"category"];
//            NSArray * service1 = [TVhttpDic objectForKey:@"service"];
//            
//            
//            for (int a = 0; a <service1.count ; a++) {
//                //原始数据
//                NSString * service_network =  [service1[a]objectForKey:@"service_network_id"];
//                NSString * service_ts =  [service1[a] objectForKey:@"service_ts_id"];
//                NSString * service_service =  [service1[a] objectForKey:@"service_service_id"];
//                //                NSString * service_tuner =  [service1[ai] objectForKey:@"service_tuner_mode"];
//                
//                
//                //                //新的数据
//                NSString * newservice_network = [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: networkIdData]]; //[[NSString alloc]initWithData:networkIdData encoding:NSUTF8StringEncoding];
//                
//                
//                NSString * newservice_ts =   [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: tsIdData]];//[[NSString alloc]initWithData:tsIdData encoding:NSUTF8StringEncoding];
//                NSString * newservice_service = [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: serviceIdData]];// [[NSString alloc]initWithData:serviceIdData encoding:NSUTF8StringEncoding];
//                //                NSString * newservice_tunertype =  [[NSString alloc]initWithData:serviceTypeData encoding:NSUTF8StringEncoding];
//                //                NSString * newservice_apiservicetype =  [[NSString alloc]initWithData:serviceTypeData encoding:NSUTF8StringEncoding];
//                
//                if ([service_network isEqualToString:newservice_network] && [service_ts isEqualToString:newservice_ts]  && [service_service isEqualToString:newservice_service]  //&& [service_tuner isEqualToString:newservice_tunertype]
//                    ) {
//                    
//                    //这种情况下是找到了节目
//                    NSArray * arr_threeData =[ [NSArray alloc]initWithObjects:service1[a],serviceTypeData,clientNameData, nil];
//                    
//                    [monitorTableArr addObject:arr_threeData];  //把展示节目列表添加到数组中，用于展示
//                    
//                    
//                    [self.tableView reloadData];
//                }
//                else //此处是一种特殊情况，没有找到这个节目
//                {
//                    [self.tableView reloadData];
//                }
//                
//            }
//            
//            
//            
//            
//            
//            //***********
//            
//            //            char serviceTypeBuf;
//            //
//            //            [serviceTypeData getBytes:&buffer range:NSMakeRange(placeFigure, 4)];
//            
//            //            char serviceTypeBuf;
//            //            [serviceTypeData getBytes:&buffer range:NSMakeRange(placeFigure, 4)];
//            
//            //判断service_typedata,判断是不是分发，时移，录制
//            [self judgeTunerClass:serviceTypeData];
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
//    if (tableInitNum == 0) {
//        [self loadTableview];
//        tableInitNum++;
//        
//    }
//    //    else
//    //    {
//    //     [tableView reloadData];
//    //    }
//    
//    [tableView reloadData];
//    //    [self loadTableview];
//    [self changeView];
//}
//
//-(void)changeView
//{
//    //    NSLog(@"monitorTableArr :%@,",monitorTableArr);
//    
//    int monitorApperCount ;
//    NSString * monitorApperCountStr =  [USER_DEFAULT objectForKey:@"monitorApperCountStr"];
//    monitorApperCount = [monitorApperCountStr intValue];
//    if (monitorApperCount == 0) {
//        
//        cicleBlueImageView.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"圆环-%ld",(long)tunerNum]];
//        
//        numImage.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"M%ld",(long)tunerNum]];
//        
//        
//        
//        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
//        
//        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
//        
//        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
//        
//        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
//        
//        
//        
//        if (scrollUp == YES) {
//            self.scrollView.frame = CGRectMake(0, -275, SCREEN_WIDTH, SCREEN_HEIGHT);
//            
//            self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
//            
//            
//        }else
//        {
//            self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            //                             scrollView.contentOffset = CGPointMake(0, 0);
//            self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
//            
//            self.tableView.editing = NO;
//        }
//        
//        
//        
//        
//        //    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
//        
//        self.tableView.frame =  CGRectMake(0, TopViewHeight, SCREEN_WIDTH, tunerNum*80);
//        
//        //
//        //    self.scrollView.frame = CGRectMake(0, -300, SCREEN_WIDTH, SCREEN_HEIGHT);
//        //
//        //    TopViewHeight+tunerNum*80+200-93);
//        //    scrollUp = YES;
//        //    self.tableView.scrollEnabled = YES;
//        
//        [USER_DEFAULT setObject:monitorTableArr forKey:@"monitorTableArrTemp"];
//        
//        NSLog(@"monitorTableArrTemp.count ；%d",monitorTableArr.count);
//        
//    }else
//    {
//        NSArray * monitorTableArrTemp = [USER_DEFAULT objectForKey:@"monitorTableArrTemp"];
//        
//        
//        NSLog(@"monitorTableArraaaa :%@,",monitorTableArr);
//        NSLog(@"monitorTableArrTemp :%@,",monitorTableArrTemp);
//        
//        NSLog(@"monitorTableArrTemp.count ；%d",monitorTableArrTemp.count);
//        NSLog(@"monitorTableArr.count ；%d",monitorTableArr.count);
//        if ([monitorTableArr isEqualToArray:monitorTableArrTemp]) {
//            NSLog(@"相等相等相等相等相等相等相等");
//        }else
//        {
//            NSLog(@"不不不不相等相等相等相等相等相等相等");
//            
//            [self performSelector:@selector(willReFresh) withObject:self afterDelay:0.2];
//        }
//        
//    }
//    
//    
//    
//    
//}
//
//-(void)judgeTunerClass:(NSData * )typeData
//{
//    
//    int type;
//    //    [typeData getBytes: &type length: sizeof(type)];
//    //    NSLog(@"typedata :%@",typeData);
//    NSLog(@"type:%d",type);
//    type =  [SocketUtils uint16FromBytes: typeData];
//    NSLog(@"typedata :%@",typeData);
//    NSLog(@"type:%d",type);
//    switch (type) {
//        case INVALID_Service:
//            
//            break;
//        case LIVE_PLAY:
//            livePlayCount ++;
//            break;
//        case LIVE_RECORD:
//            liveRecordCount ++;
//            break;
//        case LIVE_TIME_SHIFT:
//            liveTimeShiteCount ++;
//            break;
//        case DELIVERY:
//            deliveryCount ++;
//            break;
//        case PUSH_VOD:
//            pushVodCount ++;
//            break;
//        default:
//            break;
//    }
//    
//}
//
//
////// 开始拖拽
////- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
////{
//////    NSLog(@"++开始拖拽");
////    if (scrollView.class ==  self.tableView.class) {
////        NSLog(@"tableview:.y");
////        int currentPostion = scrollView.contentOffset.y;
////    NSLog(@"tableview.contentOffset.y:%f",self.scrollView.contentOffset.y);
////    }
////
////    if (scrollView.class ==  self.scrollView.class) {
////        NSLog(@"scroll:.y");
////    }
////}
//
//
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollView.contentOffset.y:%f",self.scrollView.contentOffset.y);
//    int currentPostion = scrollView.contentOffset.y;
//    if (currentPostion - lastPosition > 30 && self.scrollView.contentOffset.y >50 && scrollUp == NO){
//        CGPoint position = CGPointMake(0, 275);
//        //        [scrollView     :position animated:YES];
//        [UIView animateWithDuration:0.5
//                              delay:0.02
//                            options:UIViewAnimationCurveLinear
//                         animations:^{
//                             
//                             self.scrollView.frame = CGRectMake(0, -275, SCREEN_WIDTH, SCREEN_HEIGHT+tunerNum*80+200);//
//                             
//                             self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT); //TopViewHeight+tunerNum*80+200-93);
//                             scrollUp = YES;
//                             self.tableView.scrollEnabled = YES;
//                             //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
//                         }
//                         completion:^(BOOL finished)
//         {
//             NSLog(@"animate");
//             self.tableView.scrollEnabled = YES;
//         } ];
//        NSLog(@"scrollView.contentOffset2.y:%f",scrollView.contentOffset.y);
//        self.tableView.scrollEnabled = YES;
//    }
//    
//    
//    
//    
//    if(scrollView.class == self.tableView.class){
//        if (self.tableView.contentOffset.y<-30&& scrollUp == YES
//            //        currentPostion - lastPosition < 20 && scrollView.contentOffset.y <25
//            ){
//            CGPoint position = CGPointMake(0, 275);
//            
//            [UIView animateWithDuration:0.5
//                                  delay:0.02
//                                options:UIViewAnimationCurveLinear
//                             animations:^{
//                                 //                             [scrollView setContentOffset: position ];
//                                 self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//                                 //                             scrollView.contentOffset = CGPointMake(0, 0);
//                                 self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);//SCREEN_HEIGHT); //TopViewHeight+tunerNum*80+200);
//                                 scrollUp = NO;
//                                 //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
//                                 self.tableView.scrollEnabled = NO;
//                             }
//                             completion:^(BOOL finished)
//             { NSLog(@"animate");
//                 self.tableView.scrollEnabled = NO;
//             } ];
//            NSLog(@"scrollView.contentOffset2.y:%f",scrollView.contentOffset.y);
//            self.tableView.scrollEnabled = NO;
//        }
//    }
//    
//}
//
////***********删除代码
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //>>
//    NSArray * monitorTypeArr = [[NSArray alloc]init];
//    monitorTypeArr =   monitorTableArr[indexPath.row];
//    NSData * tableTypedata = monitorTypeArr[1];
//    
//    NSData * phoneClientName = monitorTypeArr[2];
//    int type;
//    type =  [SocketUtils uint16FromBytes: tableTypedata];  //tuner的类别
//    
//    NSString * clientNameStr = [[NSString alloc]initWithData:phoneClientName encoding:NSUTF8StringEncoding];  //获取的设备名称
//    NSString * phoneModel =  [GGUtil deviceVersion]; //[self deviceVersion];
//    NSLog(@"手机型号:%@",phoneModel);
//    NSString* client_name = [NSString stringWithFormat:@"Phone%@",phoneModel];  //***
//    //实际情况下此处可做修改：
//    if (type == DELIVERY  &&[clientNameStr isEqualToString:phoneModel]){//&&  [clientNameStr isEqualToString:client_name]) {
//        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//        return UITableViewCellEditingStyleDelete;
//    }
//    return UITableViewCellEditingStyleNone;
//    
//    //>>
//    
//    
//    //    return UITableViewCellEditingStyleDelete;
//}
//
///*改变删除按钮的title*/
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @" DEL ";
//}
//
///*删除用到的函数*/
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView beginUpdates];
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        /*此处处理自己的代码，如删除数据*/
//        
//        //////////////////////////// 向TV页面发送通知
//        //创建通知
//        NSNotification *notification =[NSNotification notificationWithName:@"deleteTuner" object:nil userInfo:nil];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//        
//        
//        
//        
//        //        //////////////////////////// 从socket返回数据
//        //        //此处销毁通知，防止一个通知被多次调用
//        //        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        //        //注册通知
//        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfo:) name:@"getResourceInfo" object:nil];
//        
//        
//        
//        
//        ///////******
//        NSLog(@"monitorTableArr:%@",monitorTableArr);
//        [monitorTableArr removeObjectAtIndex:indexPath.row];
//        //这里添加删除的socket
//        /*删除tableView中的一行*/
//        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//        [tableView reloadData];
//        
//    }
//    
//    
//    //   [self viewWillAppear:YES];
//    [tableView endUpdates];
//    //  [self getNotificInfo];
//    [self performSelector:@selector(willReFresh) withObject:self afterDelay:0.2];
//}
//
//-(void)willReFresh
//{
//    int monitorApperCount = 0 ;
//    NSString * monitorApperCountStr = [NSString stringWithFormat:@"%d",monitorApperCount];
//    [USER_DEFAULT setObject:monitorApperCountStr forKey:@"monitorApperCountStr"];
//    
//    [self getNotificInfo];
//}
//
//
//
//
////************
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//@end


////
////  MonitorViewController.m
////  StarAPP
////
////  Created by xyz on 16/8/29.
////
////
//
//#import "MonitorViewController.h"
//#import "sys/utsname.h"
//#define kShadowRadius 20
//#define TopViewHeight 400
//#define TopBottomNameWidth 142/2
//#define CutWidth 30/2
//#define TopBottomNameMarginLeft (SCREEN_WIDTH-4*TopBottomNameWidth-3*CutWidth)/2
//
//@interface MonitorViewController ()
//{
//    NSInteger tunerNum;
//    NSMutableArray *  livePlayArr;
//    NSMutableArray *  liveRecordArr;
//    NSMutableArray *  liveTimeShiteArr;
//    NSMutableArray *  deliveryArr;
//    NSMutableArray *  pushVodArr;
//
//    NSInteger   livePlayCount;
//    NSInteger   liveRecordCount;
//    NSInteger   liveTimeShiteCount;
//    NSInteger   deliveryCount;
//    NSInteger   pushVodCount;
//    BOOL scrollUp;
//    int lastPosition ;
//
//    NSInteger tableInitNum;
//
//    NSTimer *  refreshTimer ;  //定时刷新，暂定时间5秒
//
//    NSString * deviceString;
//
//}
//@end
//
//@implementation MonitorViewController
//@synthesize scrollView;
//@synthesize tableView;
//@synthesize colorView;
//@synthesize colorImageView;
//@synthesize TVhttpDic;
//@synthesize monitorTableDic;
//@synthesize monitorTableArr;
//@synthesize socketUtils;
//// loadnum
//@synthesize liveNumLab;
//@synthesize recoderLab;
//@synthesize timeShiftLab;
//@synthesize distributeLab;
//@synthesize liveNum_Lab;
//@synthesize recoder_Lab;
//@synthesize timeShift_Lab;
//@synthesize distribute_Lab;
//
////loadColor Cicle
//@synthesize cicleClearImageView;
//@synthesize cicleBlueImageView;
//@synthesize nineImage;
//@synthesize numImage;
//@synthesize labImage;
//@synthesize isRefreshScroll;
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    //修改tabbar选中的图片颜色和字体颜色
//    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.tabBarItem.selectedImage = image;
//    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
//
//
//
//    self.view.backgroundColor = [UIColor whiteColor];
//
//    isRefreshScroll = YES;
//
//    int monitorApperCount = 0;
//    NSString * monitorApperCountStr = [NSString stringWithFormat:@"%d",monitorApperCount];
//    [USER_DEFAULT setObject:monitorApperCountStr forKey:@"monitorApperCountStr"];
//
//
//    [self initData];
//
//
//
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [USER_DEFAULT setObject:@"MonitorView_Now" forKey:@"viewTOview"];
//     [USER_DEFAULT setObject:[NSNumber numberWithInt:1] forKey:@"viewDidloadHasRunBool"];     // 此处做一次判断，判断是不是连接状态，如果是的，则执行live页面的时候不执行【socket viewDidload】
//
//    if (isRefreshScroll) {
//        tableInitNum = 0;
//        [scrollView removeFromSuperview];
//        scrollView = nil;
//
//        //    UILabel * shadowLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 230, 30)];
//        //    shadowLab.text = @"测试案例";
//        //    shadowLab.shadowColor = RGBA(30, 30, 30, 0.5) ;//设置文本的阴影色彩和透明度。
//        //     shadowLab.shadowOffset = CGSizeMake(2.0f, 2.0f);     //设置阴影的倾斜角度。
//        //    UILabel * shadowLab1 = [[UILabel alloc]initWithFrame:CGRectMake(210, 120, 230, 30)];
//        //    shadowLab1.text = @"123123213123";
//        //
//        //    shadowLab1.shadowColor = RGBA(130, 130, 30, 0.5);    //设置文本的阴影色彩和透明度。
//        //    shadowLab1.shadowOffset = CGSizeMake(2.0f, 2.0f);     //设置阴影的倾斜角度。
//        //
//        //    [self.view addSubview:shadowLab];
//        //    [self.view addSubview:shadowLab1];
//        //    [self getTunerInfo];
////        [self initData];
//        [self loadUI];  //***
//        [self getNotificInfo]; //通过发送通知给TV页，TV页通过socket获取到tuner消息
//        //    [self initRefresh]; //开始每隔几秒向TV页发送通知，用来收到数据并且刷新数据
//        //    [self loadNav];
//        isRefreshScroll = NO;
//    }else
//    {
//        //1.获取数据，判断数据和原来的是不是一样，如果不一样，准备刷新
//        //2.删除所有的东西，加载所有的东西
//        [self refreshViewByJudgeData];  //通过获得一次tuner消息，判断tuner消息是不是发生了变化
//
//    }
//
//
//}
//-(void)refreshViewByJudgeData    //通过获得一次tuner消息，判断tuner消息是不是发生了变化
//{
//   //1.发送消息
//   //2.判断
//    [self  getNotificInfoByMySelf]; // 发送消息给TV页面，然后通过TV页面传通知发送tuner的socket信息
//
//}
//-(void)getNotificInfoByMySelf   //随后每隔一段时间或者打开这个页面的时候获取tuner信 BYMYSelf
//{
//    //////////////////////////// 向TV页面发送通知
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    [USER_DEFAULT  setObject:@"deviceClose" forKey:@"deviceOpenStr"];  //防止device页面接收
//
//
//    //////////////////////////// 从socket返回数据
//    //此处销毁通知，防止一个通知被多次调用
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getNotificInfoByMySelf" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificInfoByMySelf:) name:@"getNotificInfoByMySelf" object:nil];
//
//
//}
//-(void)getNotificInfoByMySelf:(NSNotification *)text
//{
//
//
//    NSData * retDataByMySelf = [[NSData alloc]init];
//    retDataByMySelf = text.userInfo[@"resourceInfoData"];    //返回的data
//
////    NSData * dataTemp = [[NSData alloc]init];
////    dataTemp = [USER_DEFAULT objectForKey:@"retDataForMonitor"];
//    NSLog(@"retDataByMySelf: %@",retDataByMySelf);
//
//    [monitorTableArr removeAllObjects];
//
//    [self getEffectiveData:retDataByMySelf];
//
//}
//
//-(void)getNotificInfo //第一次启动时候获取tuner信息
//{
//    tunerNum = 0; ///******
//    [monitorTableArr removeAllObjects];
//    livePlayCount = 0;
//    liveRecordCount = 0;
//    liveTimeShiteCount = 0;
//    deliveryCount = 0;
//    pushVodCount = 0;
//    NSLog(@"=======================notific");
//
////    self.blocktest = ^(NSDictionary * dic)
////    {
////        //此处是返回值处理方法
////        NSLog(@"此处是返回 :%@",dic);
////    };
////
//    //////////////////////////// 向TV页面发送通知
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    [USER_DEFAULT  setObject:@"deviceClose" forKey:@"deviceOpenStr"];  //防止device页面接收
//
//
//  //////////////////////////// 从socket返回数据
//    //此处销毁通知，防止一个通知被多次调用
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getResourceInfo" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfo:) name:@"getResourceInfo" object:nil];
//
//
////    [USER_DEFAULT objectForKey:@"CICHUSHIDIC"];
////    NSLog(@"此处是返回：%@", [USER_DEFAULT objectForKey:@"CICHUSHIDIC"]);
//
//}
//
//
//-(void)getResourceInfo:(NSNotification *)text
//{
//
//    NSLog(@"moni:%@",text.userInfo[@"resourceInfoData"]);
//    //    int show = [text.userInfo[@"resourceInfoData"] intValue];
//    NSLog(@"此处是socket返回");
//
//    NSData * retData = [[NSData alloc]init];
//    retData = text.userInfo[@"resourceInfoData"];    //返回的data
////        [self getTunerNum:retData];  //获得总的tuner的数量
//        [self getEffectiveData:retData];//获得有效数据的信息，不同tuner的信息
//
//}
//
//-(void)loadNav
//{
//
//}
//-(void)initData
//{
//    scrollUp = NO;
//    lastPosition = 0;
//    livePlayCount = 0;
//    liveRecordCount = 0;
//    liveTimeShiteCount = 0;
//    deliveryCount = 0;
//    pushVodCount = 0;
//    tunerNum = 0;
//    livePlayArr = [[NSMutableArray alloc]init];
//    liveRecordArr = [[NSMutableArray alloc]init];
//    liveTimeShiteArr = [[NSMutableArray alloc]init];
//    deliveryArr = [[NSMutableArray alloc]init];
//    pushVodArr = [[NSMutableArray alloc]init];
//    monitorTableDic = [[NSMutableDictionary alloc]init];
//    monitorTableArr = [[NSMutableArray alloc]init];
//
//    refreshTimer = [[NSTimer alloc]init];
//
//
//    ///
////    socketUtils = [[SocketUtils alloc]init];
//}
//
//-(void)initRefresh
//{
//    NSLog(@"=======================notific");
//
//
//    //
//    //////////////////////////// 向TV页面发送通知
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    [USER_DEFAULT  setObject:@"deviceClose" forKey:@"deviceOpenStr"];  //防止device页面接收
//
//    //////////////////////////// 从socket返回数据
//    //此处销毁通知，防止一个通知被多次调用
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getResourceInfo" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfo:) name:@"getResourceInfo" object:nil];
//
//
//
//}
//-(void)loadUI
//{
//    NSLog(@"=======--:%ld",(long)tunerNum);
//    [self loadScroll];
//    [self loadColorView];  // 加载顶部的 多彩color 以及上面的各种图片
//
//   [self loadTableview];
//
//    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshViewByJudgeData) userInfo:nil repeats:YES];
//
//}
/////
//// 加载顶部的 多彩color 以及上面的各种图片
/////
//-(void)loadColorView
//{
//
//    colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
//    colorView.backgroundColor = [UIColor purpleColor];
//    [scrollView addSubview:colorView];
//
//    colorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
//    colorImageView.image = [UIImage  imageNamed:@"监控渐变背景"];
//    [colorView addSubview:colorImageView];
//
//    [self loadCicle];    //多彩color 图片上的各种图片添加
//    [self loadNumLab];  //底部的各项tuner的数量
//}
//-(void)loadCicle //多彩color 图片上的各种图片添加
//{
////    tunerNum = 3;
//
//     cicleClearImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 196)/2, 80 , 196, 195)];
//    cicleClearImageView.image = [UIImage  imageNamed:@"圆环"];
//    [colorImageView addSubview:cicleClearImageView];
//
//    cicleBlueImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 196)/2, 80,196, 195)];
//    cicleBlueImageView.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"圆环-%ld",(long)tunerNum]];
//    [colorImageView addSubview:cicleBlueImageView];
//
//    nineImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-5, cicleClearImageView.frame.size.height/2-25,36, 33)];
//    nineImage.image = [UIImage  imageNamed:@"nine"];
//    [cicleClearImageView addSubview:nineImage];
//
//
//     numImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-30, cicleClearImageView.frame.size.height/2-35,36, 43)];
//    numImage.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"M%ld",(long)tunerNum]];
//    [cicleClearImageView addSubview:numImage];
//
//     labImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-30, cicleClearImageView.frame.size.height/2+10,65, 40)];
//    labImage.image = [UIImage  imageNamed:@"Tunermonitor"];
//    [cicleClearImageView addSubview:labImage];
//}
//-(void)loadNumLab  //底部的各项tuner的数量
//{
//    [self loadNumAnddelete];
//
//
//    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]    ) {
//        NSLog(@"此刻是5s和4s 的大小");
//
//        UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8+14, 325, 2, 40)];
//        verticalView1.layer.cornerRadius = 1.0;
//        verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView1];
//
//        UIView * verticalView2 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(1+1)-2 +CutWidth*1 -3, 325, 2, 40)];
//        verticalView2.layer.cornerRadius = 1.0;
//        verticalView2.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView2];
//
//        UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2 - 11, 325, 2, 40)];
//        verticalView3.layer.cornerRadius = 1.0;
//        verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView3];
//
//
//    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]    || [deviceString isEqualToString:@"iPhone Simulator"] ) {
//        NSLog(@"此刻是6的大小");
//
//        UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8, 325, 2, 40)];
//        verticalView1.layer.cornerRadius = 1.0;
//        verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView1];
//
//        UIView * verticalView2 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(1+1)-2 +CutWidth*1, 325, 2, 40)];
//        verticalView2.layer.cornerRadius = 1.0;
//        verticalView2.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView2];
//
//        UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2, 325, 2, 40)];
//        verticalView3.layer.cornerRadius = 1.0;
//        verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView3];
//
//
//    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
//        NSLog(@"此刻是6 plus的大小");
//
//        UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8, 325, 2, 40)];
//        verticalView1.layer.cornerRadius = 1.0;
//        verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView1];
//
//        UIView * verticalView2 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(1+1)-2 +CutWidth*1, 325, 2, 40)];
//        verticalView2.layer.cornerRadius = 1.0;
//        verticalView2.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView2];
//
//        UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2, 325, 2, 40)];
//        verticalView3.layer.cornerRadius = 1.0;
//        verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
//        [colorImageView addSubview:verticalView3];
//    }
//
//
//
//
//
//}
//-(void)loadNumAnddelete  //加载那些全局的数字，等待刷新并且删除重新加载一遍
//{
//    deviceString = [GGUtil deviceVersion];
//
//
//
//
//    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]   ) {
//        NSLog(@"此刻是5s和4s 的大小");
//
//
//        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 360, 142/2, 13)];
//        liveNumLab.text = @"TV Live";
//        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
//        liveNumLab.font = FONT(13);
//        [colorImageView addSubview:liveNumLab];
//
//
//        recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(85, 360, 142/2, 13)];
//        recoderLab.text = @"Recoder";
//        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
//        recoderLab.font = FONT(13);
//        [colorImageView addSubview:recoderLab];
//
//        timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(160, 360, 142/2, 13)];
//        timeShiftLab.text = @"Time Shift";
//        timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
//        timeShiftLab.font = FONT(13);
//        [colorImageView addSubview:timeShiftLab];
//
//        //    distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 , 360, 142/2, 13)];
//        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(240, 360, 142/2, 13)];
//        distributeLab.text = @"Distribute";
//        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
//        distributeLab.font = FONT(13);
//        [colorImageView addSubview:distributeLab];
//
//        //     liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20, liveNumLab.frame.origin.y-40, 16, 20)];
//         liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(35, liveNumLab.frame.origin.y-40, 16, 20)];
//        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
//        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        liveNum_Lab.font = FONT(24);
//        [colorImageView addSubview:liveNum_Lab];
//
//        //     recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth +CutWidth, liveNumLab.frame.origin.y-40, 16, 20)];
//          recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(100, liveNumLab.frame.origin.y-40, 16, 20)];
//        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
//        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        recoder_Lab.font = FONT(24);
//        [colorImageView addSubview:recoder_Lab];
//
//        //    timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
//         timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(180, liveNumLab.frame.origin.y-40, 16, 20)];
//        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
//        timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        timeShift_Lab.font = FONT(24);
//        [colorImageView addSubview:timeShift_Lab];
//
//        //    distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*3 +CutWidth*3, liveNumLab.frame.origin.y-40, 16, 20)];
//         distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(260, liveNumLab.frame.origin.y-40, 16, 20)];
//        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
//        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        distribute_Lab.font = FONT(24);
//        [colorImageView addSubview:distribute_Lab];
//    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"] || [deviceString isEqualToString:@"iPhone Simulator"]) {
//        NSLog(@"此刻是6的大小");
//
//        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft, 360, 142/2, 13)];
//        liveNumLab.text = @"TV Live";
//        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
//        liveNumLab.font = FONT(13);
//        [colorImageView addSubview:liveNumLab];
//
//        recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth +CutWidth , 360, 142/2, 13)];
//        recoderLab.text = @"Recoder";
//        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
//        recoderLab.font = FONT(13);
//        [colorImageView addSubview:recoderLab];
//
//        timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*2 +CutWidth*2 , 360, 142/2, 13)];
//        timeShiftLab.text = @"Time Shift";
//        timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
//        timeShiftLab.font = FONT(13);
//        [colorImageView addSubview:timeShiftLab];
//
//        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 , 360, 142/2, 13)];
//        distributeLab.text = @"Distribute";
//        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
//        distributeLab.font = FONT(13);
//        [colorImageView addSubview:distributeLab];
//
//        liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20, liveNumLab.frame.origin.y-40, 16, 20)];
//        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
//        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        liveNum_Lab.font = FONT(24);
//        [colorImageView addSubview:liveNum_Lab];
//
//        recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth +CutWidth, liveNumLab.frame.origin.y-40, 16, 20)];
//        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
//        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        recoder_Lab.font = FONT(24);
//        [colorImageView addSubview:recoder_Lab];
//
//        timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
//        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
//        timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        timeShift_Lab.font = FONT(24);
//        [colorImageView addSubview:timeShift_Lab];
//
//        distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*3 +CutWidth*3, liveNumLab.frame.origin.y-40, 16, 20)];
//        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
//        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        distribute_Lab.font = FONT(24);
//        [colorImageView addSubview:distribute_Lab];
//
//    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"]     ) {
//        NSLog(@"此刻是6 plus的大小");
//
//        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft, 360, 142/2, 13)];
//        liveNumLab.text = @"TV Live";
//        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
//        liveNumLab.font = FONT(13);
//        [colorImageView addSubview:liveNumLab];
//
//        recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth +CutWidth , 360, 142/2, 13)];
//        recoderLab.text = @"Recoder";
//        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
//        recoderLab.font = FONT(13);
//        [colorImageView addSubview:recoderLab];
//
//        timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*2 +CutWidth*2 , 360, 142/2, 13)];
//        timeShiftLab.text = @"Time Shift";
//        timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
//        timeShiftLab.font = FONT(13);
//        [colorImageView addSubview:timeShiftLab];
//
//        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 , 360, 142/2, 13)];
//        distributeLab.text = @"Distribute";
//        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
//        distributeLab.font = FONT(13);
//        [colorImageView addSubview:distributeLab];
//
//        liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20, liveNumLab.frame.origin.y-40, 16, 20)];
//        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
//        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        liveNum_Lab.font = FONT(24);
//        [colorImageView addSubview:liveNum_Lab];
//
//        recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth +CutWidth, liveNumLab.frame.origin.y-40, 16, 20)];
//        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
//        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        recoder_Lab.font = FONT(24);
//        [colorImageView addSubview:recoder_Lab];
//
//        timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
//        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
//        timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        timeShift_Lab.font = FONT(24);
//        [colorImageView addSubview:timeShift_Lab];
//
//        distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*3 +CutWidth*3, liveNumLab.frame.origin.y-40, 16, 20)];
//        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
//        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
//        distribute_Lab.font = FONT(24);
//        [colorImageView addSubview:distribute_Lab];
//
//    }
//
//
//}
//-(void)loadScroll
//{
//    NSLog(@"=======================load scroll");
//    //加一个scrollview
//    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [self.view addSubview:scrollView];
//
//    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
//    //    scroll.pagingEnabled=YES;
//    scrollView.showsVerticalScrollIndicator=NO;
//    scrollView.showsHorizontalScrollIndicator=NO;
//    scrollView.delegate=self;
//    scrollView.bounces=NO;
//
//}
//-(void)loadTableview
//{
//    NSLog(@"=======================load tableview");
//    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopViewHeight, SCREEN_WIDTH, tunerNum*80) style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//
//    self.tableView.scrollEnabled = NO;
//    [self.view addSubview:self.tableView];
//    [scrollView  addSubview:self.tableView];
//}
///////////////
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
//{
//
////    return tunerNum;
//    NSLog(@"monitorTableArr.count %lu",(unsigned long)monitorTableArr.count);
//    return monitorTableArr.count;
//
//
//}
//-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//
//}
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//    MonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorCell"];
//    if (cell == nil){
//        cell = [MonitorCell loadFromNib];
////        cell.backgroundColor=[UIColor clearColor];
//
//        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
//
////        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//
//    for (int i = 0; i< monitorTableArr.count; i++) {
//        NSLog(@"monitorTableArr %@ :",monitorTableArr[i]);
//    }
//    if (! ISNULL(monitorTableArr)) {
//        NSLog(@"monitorTableArr[indexPath.row]; %@",monitorTableArr[indexPath.row]);
//        cell.dataArr = monitorTableArr[indexPath.row];
//    }else
//    {
//        NSLog(@"kong");
//    }
//
//
//
//    return cell;
//
//
//}
//
////-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    NSLog(@"点击了");
////}
///**
// 获取当前连接tuner的数量
// */
//-(NSInteger)getTunerNum:(NSData *)tunerAllData
//{
//    NSData * dataLen = [[NSData alloc]init];
//    dataLen = [tunerAllData subdataWithRange:NSMakeRange(27, 1)];
//
////    int value;
////    value = 0;
//    NSLog(@"可能报错1");
////    [tunerAllData getBytes: &value length: sizeof(value)];   //获取总长度
//      uint8_t value = [SocketUtils uint32FromBytes:tunerAllData];
//    NSLog(@"可能报错2");
//
//    for (int i = 0; i<11; i++) {
//        if (value == 77+i*15) {
//            tunerNum = i;
//        }else
//        {
//        }
//    }
//    return tunerNum;
//}
//
////获得有效数据的信息，不同tuner的信息
//-(void)getEffectiveData:(NSData *) allTunerData
//{
//    NSLog(@"=======================test gettuner");
//    //获取数据总长度
//    NSData * dataLen = [[NSData alloc]init];
//    dataLen = [allTunerData subdataWithRange:NSMakeRange(24, 4)];
//
//    NSLog(@"datalen: %@",dataLen);
////    int value;
////    value = 0;
//    NSLog(@"可能报错3");
////    [dataLen getBytes: &value length: sizeof(value)];   //获取总长度
//      uint8_t value = [SocketUtils uint32FromBytes:dataLen];
//   NSLog(@"可能报错4");
////    [socketUtils uint16FromBytes:]
//    //tuner的有效数据区
//    NSData * effectiveData = [[NSData alloc]init];
//    effectiveData = [allTunerData subdataWithRange:NSMakeRange(38,(value-10))];
//
//    //定位数据，用于看位于第几个字节，起始位置是在
//    int placeFigure = 3;
//    for (int ai = 0; ai < 11; ai++ ) {  //目前会返回11条数据
//
//
////       NSMutableData * tunerDataone = [NSMutableData dataWithData:allTunerData];
//        int mutablefigure = placeFigure;
//        NSLog(@"----len placeFigure:%d",placeFigure);
//        NSLog(@"----len mutablefigure:%d",mutablefigure);
//        NSLog(@"----len effectiveData:%@",effectiveData);
////        char buffer;
////        [effectiveData getBytes:&buffer range:NSMakeRange(mutablefigure, 4)];
//
//        //判断长度，防止截取字符串的时候长度超过而产生报错。
//        uint8_t effectiveDataLength = [SocketUtils uint32FromBytes:effectiveData];
////         [effectiveData getBytes: &effectiveDataLength length: sizeof(effectiveDataLength)];
//
//        NSLog(@"effectiveDataLength :%d",effectiveDataLength);
//        if (effectiveDataLength >= mutablefigure + 4) {
//
//            NSData * databuff = [effectiveData subdataWithRange:NSMakeRange(mutablefigure, 4)];
//        }
//
//
////        Byte *buffer = (Byte *)[databuff bytes];
//
//        char buffer1;
//        int buffer_int1 =placeFigure;
//
//        if (buffer_int1 +1 <= [SocketUtils uint32FromBytes:effectiveData]) {
//        [effectiveData getBytes:&buffer1 range:NSMakeRange(buffer_int1, 1)];
//        }
//
//        char buffer2;
//        int buffer_int2 =placeFigure+1;
//
//        if (buffer_int2 +1 <= [SocketUtils uint32FromBytes:effectiveData]) {
//        [effectiveData getBytes:&buffer2 range:NSMakeRange(buffer_int2, 1)];
//        }
//
//        char buffer3;
//        int buffer_int3 =placeFigure+2;
//        if (buffer_int3 +1 <= [SocketUtils uint32FromBytes:effectiveData]) {
//            [effectiveData getBytes:&buffer3 range:NSMakeRange(buffer_int3, 1)];
//        }
//
//        char buffer4;
//        int buffer_int4 =placeFigure+3;
//        if (buffer_int4 +1 <= [SocketUtils uint32FromBytes:effectiveData]) {
//            [effectiveData getBytes:&buffer4 range:NSMakeRange(buffer_int4, 1)];
//        }
//
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
//
//            //判断长度，防止截取字符串的时候长度超过而产生报错。
//            uint8_t effectiveDataLength2 = [SocketUtils uint32FromBytes:effectiveData];
//            NSLog(@"effectiveDataLength :%d",effectiveDataLength2);
//            if (effectiveDataLength2 >= placeFigure +4 + 4) {
//
//            serviceTypeData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+4, 4)];
//            }
//
//
//
////            int type;
////
////            type =  [SocketUtils uint16FromBytes: serviceTypeData];
////            if (type == 3) {
////                NSLog(@"wocaowocaowocaowocao");
////            }
//
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
//            uint8_t effectiveDataLength4 = [SocketUtils uint32FromBytes:effectiveData];
//            NSLog(@"effectiveDataLength4 :%d",effectiveDataLength4);
//            if (effectiveDataLength4 >= placeFigure+18 + 1) {
//
//            nameLenData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+18, 1)];
//            }
//
//
//
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
//            //此处做判断，看一下属于哪个tuner
//            TVhttpDic =  [USER_DEFAULT objectForKey:@"TVHttpAllData"];
//            NSArray * category1 = [TVhttpDic objectForKey:@"category"];
//            NSArray * service1 = [TVhttpDic objectForKey:@"service"];
//
//            NSLog(@"category1 %@",category1);
//            NSLog(@"service1 %@",service1);
//
//            for (int a = 0; a <service1.count ; a++) {
//                //原始数据
//                NSString * service_network =  [service1[a]objectForKey:@"service_network_id"];
//                NSString * service_ts =  [service1[a] objectForKey:@"service_ts_id"];
//                NSString * service_service =  [service1[a] objectForKey:@"service_service_id"];
////                NSString * service_tuner =  [service1[ai] objectForKey:@"service_tuner_mode"];
//
//
////                //新的数据
//                NSString * newservice_network = [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: networkIdData]]; //[[NSString alloc]initWithData:networkIdData encoding:NSUTF8StringEncoding];
//
//
//                NSString * newservice_ts =   [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: tsIdData]];//[[NSString alloc]initWithData:tsIdData encoding:NSUTF8StringEncoding];
//                NSString * newservice_service = [NSString stringWithFormat:@"%d",[SocketUtils uint16FromBytes: serviceIdData]];// [[NSString alloc]initWithData:serviceIdData encoding:NSUTF8StringEncoding];
////                NSString * newservice_tunertype =  [[NSString alloc]initWithData:serviceTypeData encoding:NSUTF8StringEncoding];
////                NSString * newservice_apiservicetype =  [[NSString alloc]initWithData:serviceTypeData encoding:NSUTF8StringEncoding];
//
//                if ([service_network isEqualToString:newservice_network] && [service_ts isEqualToString:newservice_ts]  && [service_service isEqualToString:newservice_service]  //&& [service_tuner isEqualToString:newservice_tunertype]
//                    ) {
//
//                    //这种情况下是找到了节目
//                    NSArray * arr_threeData =[ [NSArray alloc]initWithObjects:service1[a],serviceTypeData,clientNameData, nil];
//
//                    [monitorTableArr addObject:arr_threeData];  //把展示节目列表添加到数组中，用于展示
//
//
//                 [self.tableView reloadData];
//                }
//                else //此处是一种特殊情况，没有找到这个节目
//                {
//                    [self.tableView reloadData];
//                }
//
//            }
//
//
//
//
//
//  //***********
//
//            //            char serviceTypeBuf;
////
////            [serviceTypeData getBytes:&buffer range:NSMakeRange(placeFigure, 4)];
//
//            //            char serviceTypeBuf;
////            [serviceTypeData getBytes:&buffer range:NSMakeRange(placeFigure, 4)];
//
//            //判断service_typedata,判断是不是分发，时移，录制
//            [self judgeTunerClass:serviceTypeData];
//
//            ////
//            placeFigure  = placeFigure + 15+clientNameLen;
//        }
//
////        int mutablefigure = ai;
////        mutablefigure = mutablefigure*7;
//        placeFigure =placeFigure +7;  //placeFigure+ mutablefigure ;
//
//    }
//
////    [self loadNav];
////    [self loadUI];
//
////    [self loadCicle];
////    [self loadTableview];
////    [self loadNumLab];
//
//    if (tableInitNum == 0) {
//         [self loadTableview];
//        tableInitNum++;
//
//    }
////    else
////    {
////     [tableView reloadData];
////    }
//
//    [tableView reloadData];
////    [self loadTableview];
//    [self changeView];
//}
//
//-(void)changeView
//{
////    NSLog(@"monitorTableArr :%@,",monitorTableArr);
//
//    int monitorApperCount ;
//    NSString * monitorApperCountStr =  [USER_DEFAULT objectForKey:@"monitorApperCountStr"];
//    monitorApperCount = [monitorApperCountStr intValue];
//    if (monitorApperCount == 0) {
//
//        cicleBlueImageView.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"圆环-%ld",(long)tunerNum]];
//
//        numImage.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"M%ld",(long)tunerNum]];
//
//
//
//        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
//
//        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
//
//        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
//
//        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
//
//
//
//        if (scrollUp == YES) {
//            self.scrollView.frame = CGRectMake(0, -275, SCREEN_WIDTH, SCREEN_HEIGHT);
//
//            self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
//
//
//        }else
//        {
//            self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            //                             scrollView.contentOffset = CGPointMake(0, 0);
//            self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
//
//            self.tableView.editing = NO;
//        }
//
//
//
//
//        //    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
//
//        self.tableView.frame =  CGRectMake(0, TopViewHeight, SCREEN_WIDTH, tunerNum*80);
//
//        //
//        //    self.scrollView.frame = CGRectMake(0, -300, SCREEN_WIDTH, SCREEN_HEIGHT);
//        //
//        //    TopViewHeight+tunerNum*80+200-93);
//        //    scrollUp = YES;
//        //    self.tableView.scrollEnabled = YES;
//
//        [USER_DEFAULT setObject:monitorTableArr forKey:@"monitorTableArrTemp"];
//
//        NSLog(@"monitorTableArrTemp.count ；%d",monitorTableArr.count);
//
//    }else
//    {
//        NSArray * monitorTableArrTemp = [USER_DEFAULT objectForKey:@"monitorTableArrTemp"];
//
//
//        NSLog(@"monitorTableArraaaa :%@,",monitorTableArr);
//        NSLog(@"monitorTableArrTemp :%@,",monitorTableArrTemp);
//
//        NSLog(@"monitorTableArrTemp.count ；%d",monitorTableArrTemp.count);
//        NSLog(@"monitorTableArr.count ；%d",monitorTableArr.count);
//        if ([monitorTableArr isEqualToArray:monitorTableArrTemp]) {
//            NSLog(@"相等相等相等相等相等相等相等");
//        }else
//        {
//            NSLog(@"不不不不相等相等相等相等相等相等相等");
//
//            [self performSelector:@selector(willReFresh) withObject:self afterDelay:0.2];
//        }
//
//    }
//
//
//
//
//}
//
//-(void)judgeTunerClass:(NSData * )typeData
//{
//
//    int type;
////    [typeData getBytes: &type length: sizeof(type)];
////    NSLog(@"typedata :%@",typeData);
////    NSLog(@"type:%d",type);
//    type =  [SocketUtils uint16FromBytes: typeData];
//    NSLog(@"typedata :%@",typeData);
//    NSLog(@"type:%d",type);
//    switch (type) {
//        case INVALID_Service:
//
//            break;
//        case LIVE_PLAY:
//            livePlayCount ++;
//            break;
//        case LIVE_RECORD:
//            liveRecordCount ++;
//            break;
//        case LIVE_TIME_SHIFT:
//            liveTimeShiteCount ++;
//            break;
//        case DELIVERY:
//            deliveryCount ++;
//            break;
//        case PUSH_VOD:
//            pushVodCount ++;
//            break;
//        default:
//            break;
//    }
//
//}
//
//
////// 开始拖拽
////- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
////{
//////    NSLog(@"++开始拖拽");
////    if (scrollView.class ==  self.tableView.class) {
////        NSLog(@"tableview:.y");
////        int currentPostion = scrollView.contentOffset.y;
////    NSLog(@"tableview.contentOffset.y:%f",self.scrollView.contentOffset.y);
////    }
////
////    if (scrollView.class ==  self.scrollView.class) {
////        NSLog(@"scroll:.y");
////    }
////}
//
//
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollView.contentOffset.y:%f",self.scrollView.contentOffset.y);
//    int currentPostion = scrollView.contentOffset.y;
//    if (currentPostion - lastPosition > 30 && self.scrollView.contentOffset.y >50 && scrollUp == NO){
//        CGPoint position = CGPointMake(0, 275);
////        [scrollView     :position animated:YES];
//        [UIView animateWithDuration:0.5
//                              delay:0.02
//                            options:UIViewAnimationCurveLinear
//                         animations:^{
//
//                            self.scrollView.frame = CGRectMake(0, -275, SCREEN_WIDTH, SCREEN_HEIGHT+tunerNum*80+200);//
//
//                             self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT); //TopViewHeight+tunerNum*80+200-93);
//                             scrollUp = YES;
//                         self.tableView.scrollEnabled = YES;
//                             //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
//                         }
//                         completion:^(BOOL finished)
//         {
//             NSLog(@"animate");
//             self.tableView.scrollEnabled = YES;
//         } ];
//        NSLog(@"scrollView.contentOffset2.y:%f",scrollView.contentOffset.y);
//        self.tableView.scrollEnabled = YES;
//    }
//
//
//
//
//    if(scrollView.class == self.tableView.class){
//    if (self.tableView.contentOffset.y<-30&& scrollUp == YES
////        currentPostion - lastPosition < 20 && scrollView.contentOffset.y <25
//        ){
//        CGPoint position = CGPointMake(0, 275);
//
//        [UIView animateWithDuration:0.5
//                              delay:0.02
//                            options:UIViewAnimationCurveLinear
//                         animations:^{
//                             //                             [scrollView setContentOffset: position ];
//                             self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//                             //                             scrollView.contentOffset = CGPointMake(0, 0);
//                             self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);//SCREEN_HEIGHT); //TopViewHeight+tunerNum*80+200);
//                             scrollUp = NO;
//                             //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
//                         self.tableView.scrollEnabled = NO;
//                         }
//                         completion:^(BOOL finished)
//         { NSLog(@"animate");
//             self.tableView.scrollEnabled = NO;
//         } ];
//        NSLog(@"scrollView.contentOffset2.y:%f",scrollView.contentOffset.y);
//        self.tableView.scrollEnabled = NO;
//    }
//    }
//
//}
//
////***********删除代码
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //>>
//    NSArray * monitorTypeArr = [[NSArray alloc]init];
//    monitorTypeArr =   monitorTableArr[indexPath.row];
//    NSData * tableTypedata = monitorTypeArr[1];
//
//    NSData * phoneClientName = monitorTypeArr[2];
//    int type;
//    type =  [SocketUtils uint16FromBytes: tableTypedata];  //tuner的类别
//
//    NSString * clientNameStr = [[NSString alloc]initWithData:phoneClientName encoding:NSUTF8StringEncoding];  //获取的设备名称
//    NSString * phoneModel =  [GGUtil deviceVersion]; //[self deviceVersion];
//    NSLog(@"手机型号:%@",phoneModel);
//    NSString* client_name = [NSString stringWithFormat:@"Phone%@",phoneModel];  //***
//    //实际情况下此处可做修改：
//    if (type == DELIVERY  &&[clientNameStr isEqualToString:phoneModel]){//&&  [clientNameStr isEqualToString:client_name]) {
//        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//            return UITableViewCellEditingStyleDelete;
//    }
//    return UITableViewCellEditingStyleNone;
//
//    //>>
//
//
////    return UITableViewCellEditingStyleDelete;
//}
//
///*改变删除按钮的title*/
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @" DEL ";
//}
//
///*删除用到的函数*/
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//     [tableView beginUpdates];
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        /*此处处理自己的代码，如删除数据*/
//
//        //////////////////////////// 向TV页面发送通知
//        //创建通知
//        NSNotification *notification =[NSNotification notificationWithName:@"deleteTuner" object:nil userInfo:nil];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//
//
//
//
////        //////////////////////////// 从socket返回数据
////        //此处销毁通知，防止一个通知被多次调用
////        [[NSNotificationCenter defaultCenter] removeObserver:self];
////        //注册通知
////        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfo:) name:@"getResourceInfo" object:nil];
//
//
//
//
//        ///////******
//        NSLog(@"monitorTableArr:%@",monitorTableArr);
//        [monitorTableArr removeObjectAtIndex:indexPath.row];
//        //这里添加删除的socket
//        /*删除tableView中的一行*/
//        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//
//         [tableView reloadData];
//
//    }
//
//
////   [self viewWillAppear:YES];
//    [tableView endUpdates];
////  [self getNotificInfo];
//    [self performSelector:@selector(willReFresh) withObject:self afterDelay:0.2];
//}
//
//-(void)willReFresh
//{
//    int monitorApperCount = 0 ;
//    NSString * monitorApperCountStr = [NSString stringWithFormat:@"%d",monitorApperCount];
//    [USER_DEFAULT setObject:monitorApperCountStr forKey:@"monitorApperCountStr"];
//
//    [self getNotificInfo];
//}
//
//
//
//
////************
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//@end

//
//  MonitorViewController.m
//  StarAPP
//
//  Created by xyz on 16/8/29.
//
//

#import "MonitorViewController.h"
#import "sys/utsname.h"
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
    
    NSInteger tableInitNum;
    
    NSTimer *  refreshTimer ;  //定时刷新，暂定时间5秒
    
    NSString * deviceString;
    
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
// loadnum
@synthesize liveNumLab;
@synthesize recoderLab;
@synthesize timeShiftLab;
@synthesize distributeLab;
@synthesize liveNum_Lab;
@synthesize recoder_Lab;
@synthesize timeShift_Lab;
@synthesize distribute_Lab;

//loadColor Cicle
@synthesize cicleClearImageView;
@synthesize cicleBlueImageView;
@synthesize nineImage;
@synthesize numImage;
@synthesize labImage;
@synthesize isRefreshScroll;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //修改tabbar选中的图片颜色和字体颜色
    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = image;
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    isRefreshScroll = YES;
    
    int monitorApperCount = 0;
    NSString * monitorApperCountStr = [NSString stringWithFormat:@"%d",monitorApperCount];
    [USER_DEFAULT setObject:monitorApperCountStr forKey:@"monitorApperCountStr"];
    
    
    [self initData];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [USER_DEFAULT setObject:@"NO" forKey:@"modeifyTVViewRevolve"];   //防止刚跳转到主页时就旋转到全屏
    [USER_DEFAULT setObject:@"MonitorView_Now" forKey:@"viewTOview"];
    [USER_DEFAULT setObject:[NSNumber numberWithInt:1] forKey:@"viewDidloadHasRunBool"];     // 此处做一次判断，判断是不是连接状态，如果是的，则执行live页面的时候不执行【socket viewDidload】
    
    if (isRefreshScroll) {
        tableInitNum = 0;
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
        //        [self initData];
        [self loadUI];  //***
        [self getNotificInfo]; //通过发送通知给TV页，TV页通过socket获取到tuner消息
        //    [self initRefresh]; //开始每隔几秒向TV页发送通知，用来收到数据并且刷新数据
        //    [self loadNav];
        isRefreshScroll = NO;
    }else
    {
        //1.获取数据，判断数据和原来的是不是一样，如果不一样，准备刷新
        //2.删除所有的东西，加载所有的东西
        [self refreshViewByJudgeData];  //通过获得一次tuner消息，判断tuner消息是不是发生了变化
        
    }
    
    
    [self TVViewAppear];
    
}
-(void)TVViewAppear
{
    [USER_DEFAULT setObject:@"YES" forKey:@"jumpFormOtherView"];//为TV页面存储方法
}
-(void)refreshViewByJudgeData    //通过获得一次tuner消息，判断tuner消息是不是发生了变化
{
    //1.发送消息
    //2.判断
    [self  getNotificInfoByMySelf]; // 发送消息给TV页面，然后通过TV页面传通知发送tuner的socket信息
    
}
-(void)getNotificInfoByMySelf   //随后每隔一段时间或者打开这个页面的时候获取tuner信 BYMYSelf
{
    //////////////////////////// 向TV页面发送通知
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [USER_DEFAULT  setObject:@"deviceClose" forKey:@"deviceOpenStr"];  //防止device页面接收
    
    
    //////////////////////////// 从socket返回数据
    //此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getNotificInfoByMySelf" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificInfoByMySelf:) name:@"getNotificInfoByMySelf" object:nil];
    
    
}
-(void)getNotificInfoByMySelf:(NSNotification *)text
{
    
    
    NSData * retDataByMySelf = [[NSData alloc]init];
    retDataByMySelf = text.userInfo[@"resourceInfoData"];    //返回的data
    
    //    NSData * dataTemp = [[NSData alloc]init];
    //    dataTemp = [USER_DEFAULT objectForKey:@"retDataForMonitor"];
    NSLog(@"retDataByMySelf: %@",retDataByMySelf);
    
    [monitorTableArr removeAllObjects];
    
    [self getEffectiveData:retDataByMySelf];
    
}

-(void)getNotificInfo //第一次启动时候获取tuner信息
{
    tunerNum = 0; ///******
    [monitorTableArr removeAllObjects];
    livePlayCount = 0;
    liveRecordCount = 0;
    liveTimeShiteCount = 0;
    deliveryCount = 0;
    pushVodCount = 0;
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
    [USER_DEFAULT  setObject:@"deviceClose" forKey:@"deviceOpenStr"];  //防止device页面接收
    
    
    //////////////////////////// 从socket返回数据
    //此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getResourceInfo" object:nil];
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
    
    refreshTimer = [[NSTimer alloc]init];
    
    
    ///
    //    socketUtils = [[SocketUtils alloc]init];
}

-(void)initRefresh
{
    NSLog(@"=======================notific");
    
    
    //
    //////////////////////////// 向TV页面发送通知
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tunerRevice" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [USER_DEFAULT  setObject:@"deviceClose" forKey:@"deviceOpenStr"];  //防止device页面接收
    
    //////////////////////////// 从socket返回数据
    //此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getResourceInfo" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfo:) name:@"getResourceInfo" object:nil];
    
    
    
}
-(void)loadUI
{
    NSLog(@"=======--:%ld",(long)tunerNum);
    [self loadScroll];
    [self loadColorView];  // 加载顶部的 多彩color 以及上面的各种图片
    
    [self loadTableview];
    
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshViewByJudgeData) userInfo:nil repeats:YES];
    
}
///
// 加载顶部的 多彩color 以及上面的各种图片
///
-(void)loadColorView
{
    
    colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
    colorView.backgroundColor = [UIColor purpleColor];
    [scrollView addSubview:colorView];
    
    colorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
    colorImageView.image = [UIImage  imageNamed:@"监控渐变背景"];
    [colorView addSubview:colorImageView];
    
    [self loadCicle];    //多彩color 图片上的各种图片添加
    [self loadNumLab];  //底部的各项tuner的数量
}
-(void)loadCicle //多彩color 图片上的各种图片添加
{
    //    tunerNum = 3;
    
    cicleClearImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 196)/2, 80 , 196, 195)];
    cicleClearImageView.image = [UIImage  imageNamed:@"New圆环"];
    [colorImageView addSubview:cicleClearImageView];
    
    cicleBlueImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 196)/2, 80,196, 195)];
    cicleBlueImageView.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"New圆环-%ld",(long)tunerNum]];
    [colorImageView addSubview:cicleBlueImageView];
    
    nineImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-5, cicleClearImageView.frame.size.height/2-25,36, 33)];
    nineImage.image = [UIImage  imageNamed:@"New_Four"];
    [cicleClearImageView addSubview:nineImage];
    
    
    numImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-30, cicleClearImageView.frame.size.height/2-35,36, 43)];
    numImage.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"M%ld",(long)tunerNum]];
    [cicleClearImageView addSubview:numImage];
    
    labImage = [[UIImageView alloc]initWithFrame:CGRectMake(cicleClearImageView.frame.size.width/2-30, cicleClearImageView.frame.size.height/2+10,65, 40)];
    labImage.image = [UIImage  imageNamed:@"Tunermonitor"];
    [cicleClearImageView addSubview:labImage];
}
-(void)loadNumLab  //底部的各项tuner的数量
{
    [self loadNumAnddelete];
    
    
    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]    ) {
        NSLog(@"此刻是5s和4s 的大小");
        
        UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8+14, 325, 2, 40)];
        verticalView1.layer.cornerRadius = 1.0;
        verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
        [colorImageView addSubview:verticalView1];
        
        UIView * verticalView2 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(1+1)-2 +CutWidth*1 -3, 325, 2, 40)];
        verticalView2.layer.cornerRadius = 1.0;
        verticalView2.backgroundColor = RGBA(245, 245, 245, 0.3);
        [colorImageView addSubview:verticalView2];
        
        UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2 - 11, 325, 2, 40)];
        verticalView3.layer.cornerRadius = 1.0;
        verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
        [colorImageView addSubview:verticalView3];
        
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]    || [deviceString isEqualToString:@"iPhone Simulator"] ) {
        NSLog(@"此刻是6的大小");
        
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
        
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
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
    }
    
    
    
    
    
}
-(void)loadNumAnddelete  //加载那些全局的数字，等待刷新并且删除重新加载一遍
{
    deviceString = [GGUtil deviceVersion];
    
    
    
    
    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]   ) {
        NSLog(@"此刻是5s和4s 的大小");
        
        
        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 360, 142/2, 13)];
        liveNumLab.text = @"TV Live";
        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
        liveNumLab.font = FONT(13);
        [colorImageView addSubview:liveNumLab];
        
        
        recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(85, 360, 142/2, 13)];
        recoderLab.text = @"Recoder";
        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
        recoderLab.font = FONT(13);
        [colorImageView addSubview:recoderLab];
        
        timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(160, 360, 142/2, 13)];
        timeShiftLab.text = @"Time Shift";
        timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
        timeShiftLab.font = FONT(13);
        [colorImageView addSubview:timeShiftLab];
        
        //    distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 , 360, 142/2, 13)];
        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(240, 360, 142/2, 13)];
        distributeLab.text = @"Distribute";
        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
        distributeLab.font = FONT(13);
        [colorImageView addSubview:distributeLab];
        
        //     liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20, liveNumLab.frame.origin.y-40, 16, 20)];
        liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(35, liveNumLab.frame.origin.y-40, 16, 20)];
        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
        liveNum_Lab.font = FONT(24);
        [colorImageView addSubview:liveNum_Lab];
        
        //     recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth +CutWidth, liveNumLab.frame.origin.y-40, 16, 20)];
        recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(100, liveNumLab.frame.origin.y-40, 16, 20)];
        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
        recoder_Lab.font = FONT(24);
        [colorImageView addSubview:recoder_Lab];
        
        //    timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
        timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(180, liveNumLab.frame.origin.y-40, 16, 20)];
        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
        timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
        timeShift_Lab.font = FONT(24);
        [colorImageView addSubview:timeShift_Lab];
        
        //    distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*3 +CutWidth*3, liveNumLab.frame.origin.y-40, 16, 20)];
        distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(260, liveNumLab.frame.origin.y-40, 16, 20)];
        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
        distribute_Lab.font = FONT(24);
        [colorImageView addSubview:distribute_Lab];
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"] || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft, 360, 142/2, 13)];
        liveNumLab.text = @"TV Live";
        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
        liveNumLab.font = FONT(13);
        [colorImageView addSubview:liveNumLab];
        
        recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth +CutWidth , 360, 142/2, 13)];
        recoderLab.text = @"Recoder";
        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
        recoderLab.font = FONT(13);
        [colorImageView addSubview:recoderLab];
        
        timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*2 +CutWidth*2 , 360, 142/2, 13)];
        timeShiftLab.text = @"Time Shift";
        timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
        timeShiftLab.font = FONT(13);
        [colorImageView addSubview:timeShiftLab];
        
        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 , 360, 142/2, 13)];
        distributeLab.text = @"Distribute";
        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
        distributeLab.font = FONT(13);
        [colorImageView addSubview:distributeLab];
        
        liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20, liveNumLab.frame.origin.y-40, 16, 20)];
        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
        liveNum_Lab.font = FONT(24);
        [colorImageView addSubview:liveNum_Lab];
        
        recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth +CutWidth, liveNumLab.frame.origin.y-40, 16, 20)];
        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
        recoder_Lab.font = FONT(24);
        [colorImageView addSubview:recoder_Lab];
        
        timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
        timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
        timeShift_Lab.font = FONT(24);
        [colorImageView addSubview:timeShift_Lab];
        
        distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*3 +CutWidth*3, liveNumLab.frame.origin.y-40, 16, 20)];
        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
        distribute_Lab.font = FONT(24);
        [colorImageView addSubview:distribute_Lab];
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"]     ) {
        NSLog(@"此刻是6 plus的大小");
        
        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft, 360, 142/2, 13)];
        liveNumLab.text = @"TV Live";
        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
        liveNumLab.font = FONT(13);
        [colorImageView addSubview:liveNumLab];
        
        recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth +CutWidth , 360, 142/2, 13)];
        recoderLab.text = @"Recoder";
        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
        recoderLab.font = FONT(13);
        [colorImageView addSubview:recoderLab];
        
        timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*2 +CutWidth*2 , 360, 142/2, 13)];
        timeShiftLab.text = @"Time Shift";
        timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
        timeShiftLab.font = FONT(13);
        [colorImageView addSubview:timeShiftLab];
        
        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 , 360, 142/2, 13)];
        distributeLab.text = @"Distribute";
        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
        distributeLab.font = FONT(13);
        [colorImageView addSubview:distributeLab];
        
        liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20, liveNumLab.frame.origin.y-40, 16, 20)];
        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
        liveNum_Lab.font = FONT(24);
        [colorImageView addSubview:liveNum_Lab];
        
        recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth +CutWidth, liveNumLab.frame.origin.y-40, 16, 20)];
        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
        recoder_Lab.font = FONT(24);
        [colorImageView addSubview:recoder_Lab];
        
        timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
        timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
        timeShift_Lab.font = FONT(24);
        [colorImageView addSubview:timeShift_Lab];
        
        distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*3 +CutWidth*3, liveNumLab.frame.origin.y-40, 16, 20)];
        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
        distribute_Lab.font = FONT(24);
        [colorImageView addSubview:distribute_Lab];
        
    }
    
    
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
    
    //    return tunerNum;
    return monitorTableArr.count;
    
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
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
        
        //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
//    if (! ISNULL(monitorTableArr)) {
    if (monitorTableArr != NULL && monitorTableArr != nil && monitorTableArr.count > 0) {
        cell.dataArr = monitorTableArr[indexPath.row];
    }else
    {
    }
    
    
    
    return cell;
    
    
}

//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"点击了");
//}
/**
 获取当前连接tuner的数量
 */
-(NSInteger)getTunerNum:(NSData *)tunerAllData
{
    NSData * dataLen = [[NSData alloc]init];
    dataLen = [tunerAllData subdataWithRange:NSMakeRange(27, 1)];
    
    //    int value;
    //    value = 0;
    NSLog(@"可能报错1");
    //    [tunerAllData getBytes: &value length: sizeof(value)];   //获取总长度
    uint32_t value = [SocketUtils uint32FromBytes:tunerAllData];
    NSLog(@"可能报错2");
#pragma mark  将11 改成了4
    for (int i = 0; i<4; i++) {
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
    NSLog(@"allTunerData :%@",allTunerData);
    //获取数据总长度
    NSData * dataLen = [[NSData alloc]init];
    dataLen = [allTunerData subdataWithRange:NSMakeRange(24, 4)];
    
    NSLog(@"datalen: %@",dataLen);
    //    int value;
    //    value = 0;
    NSLog(@"可能报错3");
    //    [dataLen getBytes: &value length: sizeof(value)];   //获取总长度
    uint32_t value = [SocketUtils uint32FromBytes:dataLen];
    NSLog(@"可能报错4");
    //    [socketUtils uint16FromBytes:]
    //tuner的有效数据区
    NSData * effectiveData = [[NSData alloc]init];
    
    effectiveData = [allTunerData subdataWithRange:NSMakeRange(38,(value-10))];
    
    //定位数据，用于看位于第几个字节，起始位置是在
    int placeFigure = 3;
#pragma mark  将11 改成了4
    for (int ai = 0; ai < 4; ai++ ) {  //目前会返回11条数据
        
        
        //       NSMutableData * tunerDataone = [NSMutableData dataWithData:allTunerData];
        int mutablefigure = placeFigure;
        NSLog(@"----len placeFigure:%d",placeFigure);
        NSLog(@"----len mutablefigure:%d",mutablefigure);
        NSLog(@"----len effectiveData:%@",effectiveData);
        //        char buffer;
        //        [effectiveData getBytes:&buffer range:NSMakeRange(mutablefigure, 4)];
        
        NSLog(@"effectiveData: %@",effectiveData);
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
            NSLog(@"effectiveData: %@",effectiveData);
            NSLog(@"placeFigure: %d",placeFigure);
            
            NSLog(@"错误代码在这里");
            serviceTypeData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+4, 4)];
            NSLog(@"serviceTypeData: %@",serviceTypeData);
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
                //                NSString * service_tuner =  [service1[ai] objectForKey:@"service_tuner_mode"];
                
                
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
    
    //    [self loadNav];
    //    [self loadUI];
    
    //    [self loadCicle];
    //    [self loadTableview];
    //    [self loadNumLab];
    
    if (tableInitNum == 0) {
        [self loadTableview];
        tableInitNum++;
        
    }
    //    else
    //    {
    //     [tableView reloadData];
    //    }
    
    [tableView reloadData];
    //    [self loadTableview];
    [self changeView];
}

-(void)changeView
{
    //    NSLog(@"monitorTableArr :%@,",monitorTableArr);
    
    int monitorApperCount ;
    NSString * monitorApperCountStr =  [USER_DEFAULT objectForKey:@"monitorApperCountStr"];
    monitorApperCount = [monitorApperCountStr intValue];
    if (monitorApperCount == 0) {
        
        cicleBlueImageView.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"New圆环-%ld",(long)tunerNum]];
        
        numImage.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"M%ld",(long)tunerNum]];
        
        
        
        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
        
        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
        
        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
        
        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
        
        
        
        if (scrollUp == YES) {
            self.scrollView.frame = CGRectMake(0, -275, SCREEN_WIDTH, SCREEN_HEIGHT);
            
            self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
            
            
        }else
        {
            self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            //                             scrollView.contentOffset = CGPointMake(0, 0);
            self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
            
            self.tableView.editing = NO;
        }
        
        
        
        
        //    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
        
        self.tableView.frame =  CGRectMake(0, TopViewHeight, SCREEN_WIDTH, tunerNum*80);
        
        //
        //    self.scrollView.frame = CGRectMake(0, -300, SCREEN_WIDTH, SCREEN_HEIGHT);
        //
        //    TopViewHeight+tunerNum*80+200-93);
        //    scrollUp = YES;
        //    self.tableView.scrollEnabled = YES;
        
        [USER_DEFAULT setObject:monitorTableArr forKey:@"monitorTableArrTemp"];
        
        NSLog(@"monitorTableArrTemp.count ；%d",monitorTableArr.count);
        
    }else
    {
        NSArray * monitorTableArrTemp = [USER_DEFAULT objectForKey:@"monitorTableArrTemp"];
        
        
        NSLog(@"monitorTableArraaaa :%@,",monitorTableArr);
        NSLog(@"monitorTableArrTemp :%@,",monitorTableArrTemp);
        
        NSLog(@"monitorTableArrTemp.count ；%d",monitorTableArrTemp.count);
        NSLog(@"monitorTableArr.count ；%d",monitorTableArr.count);
        if ([monitorTableArr isEqualToArray:monitorTableArrTemp]) {
            NSLog(@"相等相等相等相等相等相等相等");
        }else
        {
            NSLog(@"不不不不相等相等相等相等相等相等相等");
            
            [self performSelector:@selector(willReFresh) withObject:self afterDelay:0.2];
        }
        
    }
    
    
    
    
}

-(void)judgeTunerClass:(NSData * )typeData
{
    
    int type;
    //    [typeData getBytes: &type length: sizeof(type)];
    //    NSLog(@"typedata :%@",typeData);
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
            deliveryCount ++;
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
        CGPoint position = CGPointMake(0, 275);
        //        [scrollView     :position animated:YES];
        [UIView animateWithDuration:0.5
                              delay:0.02
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             
                             self.scrollView.frame = CGRectMake(0, -275, SCREEN_WIDTH, SCREEN_HEIGHT+tunerNum*80+200);//
                             
                             self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT); //TopViewHeight+tunerNum*80+200-93);
                             scrollUp = YES;
                             self.tableView.scrollEnabled = YES;
                             //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
                         }
                         completion:^(BOOL finished)
         {
             NSLog(@"animate");
             self.tableView.scrollEnabled = YES;
         } ];
        NSLog(@"scrollView.contentOffset2.y:%f",scrollView.contentOffset.y);
        self.tableView.scrollEnabled = YES;
    }
    
    
    
    
    if(scrollView.class == self.tableView.class){
        if (self.tableView.contentOffset.y<-30&& scrollUp == YES
            //        currentPostion - lastPosition < 20 && scrollView.contentOffset.y <25
            ){
            CGPoint position = CGPointMake(0, 275);
            
            [UIView animateWithDuration:0.5
                                  delay:0.02
                                options:UIViewAnimationCurveLinear
                             animations:^{
                                 //                             [scrollView setContentOffset: position ];
                                 self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                                 //                             scrollView.contentOffset = CGPointMake(0, 0);
                                 self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);//SCREEN_HEIGHT); //TopViewHeight+tunerNum*80+200);
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

//***********删除代码
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //>>
    NSArray * monitorTypeArr = [[NSArray alloc]init];
    monitorTypeArr =   monitorTableArr[indexPath.row];
    NSData * tableTypedata = monitorTypeArr[1];
    
    NSData * phoneClientName = monitorTypeArr[2];
    int type;
    type =  [SocketUtils uint16FromBytes: tableTypedata];  //tuner的类别
    
    NSString * clientNameStr = [[NSString alloc]initWithData:phoneClientName encoding:NSUTF8StringEncoding];  //获取的设备名称
    NSString * phoneModel =  [GGUtil deviceVersion]; //[self deviceVersion];
    NSLog(@"手机型号:%@",phoneModel);
    NSString* client_name = [NSString stringWithFormat:@"Phone%@",phoneModel];  //***
    //实际情况下此处可做修改：
    if (type == DELIVERY  &&[clientNameStr isEqualToString:phoneModel]){//&&  [clientNameStr isEqualToString:client_name]) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
    
    //>>
    
    
    //    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @" DEL ";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        /*此处处理自己的代码，如删除数据*/
        
        //////////////////////////// 向TV页面发送通知
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"deleteTuner" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
        
        
        //        //////////////////////////// 从socket返回数据
        //        //此处销毁通知，防止一个通知被多次调用
        //        [[NSNotificationCenter defaultCenter] removeObserver:self];
        //        //注册通知
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResourceInfo:) name:@"getResourceInfo" object:nil];
        
        
        
        
        ///////******
        NSLog(@"monitorTableArr:%@",monitorTableArr);
        [monitorTableArr removeObjectAtIndex:indexPath.row];
        //这里添加删除的socket
        /*删除tableView中的一行*/
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView reloadData];
        
    }
    
    
    //   [self viewWillAppear:YES];
    [tableView endUpdates];
    //  [self getNotificInfo];
    [self performSelector:@selector(willReFresh) withObject:self afterDelay:0.2];
}

-(void)willReFresh
{
    int monitorApperCount = 0 ;
    NSString * monitorApperCountStr = [NSString stringWithFormat:@"%d",monitorApperCount];
    [USER_DEFAULT setObject:monitorApperCountStr forKey:@"monitorApperCountStr"];
    
    [self getNotificInfo];
}




//************
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
