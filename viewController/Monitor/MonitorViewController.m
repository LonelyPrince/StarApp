
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
    //    NSMutableArray *  livePlayArr;
    //    NSMutableArray *  liveRecordArr;
    //    NSMutableArray *  liveTimeShiteArr;
    //    NSMutableArray *  deliveryArr;
    //    NSMutableArray *  pushVodArr;
    
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
    
    BOOL viewFirstOpen;   //页面第一次加载，快速完成，不做0.2秒等待
    BOOL networIsConnect; //networIsClose   //1.系统断网了，所以monitor页面的一切信息都不显示,所以用networIsConnect作为判断 2.同时也用于左滑删除时，禁止刷新列表的操作
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
//@synthesize timeShiftLab;
@synthesize distributeLab;
@synthesize liveNum_Lab;
@synthesize recoder_Lab;
//@synthesize timeShift_Lab;
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
    
    viewFirstOpen = YES;
    networIsConnect = YES;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    if (viewFirstOpen == YES) {
        [self viewWillAppearDealyFunction];
        viewFirstOpen = NO;
    }else
    {
        //防止用户快速切换，做延迟处理
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(viewWillAppearDealyFunction) object:nil];
        [self performSelector:@selector(viewWillAppearDealyFunction) withObject:nil afterDelay:0.2];
        
    }
    
    [USER_DEFAULT setObject:@"0" forKey:@"viewISTVView"];  //如果是TV页面，则再用户按home键后再次进入，需要重新播放 , 0 代表不是TV页面， 1 代表是TV页面
    
    //    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 230, 100, 100)];
    //    btn.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:btn];
    //    [scrollView addSubview:btn];
    //    [btn addTarget:self action:@selector(aaaaaa) forControlEvents:UIControlEventTouchUpInside];
    //
    //
    //    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(120, 230, 100, 100)];
    //    btn1.backgroundColor = [UIColor blackColor];
    //    [self.view addSubview:btn1];
    //    [scrollView addSubview:btn1];
    //    [btn1 addTarget:self action:@selector(netWorkIsConnect) forControlEvents:UIControlEventTouchUpInside];
    
}
#define mark - 网络断开时出发此方法
-(void)netWorkIsColse
{
    NSLog(@"Major aaaaaaaaaaaaaaa");
    
    //    [self.tableView reloadData];
    
    [self.tableView removeFromSuperview];
    self.scrollView.scrollEnabled = NO;
    
    lastPosition = 0;
    livePlayCount = 0;
    NSLog(@"livePlayCount livePlayCount ccccc %ld",livePlayCount);
    liveRecordCount = 0;
    liveTimeShiteCount = 0;
    deliveryCount = 0;
    pushVodCount = 0;
    tunerNum = 0;
    
    //    [self  loadNumAnddelete];
    //    [self changeView];
    //    [self getNotificInfo];
    [refreshTimer invalidate];
    refreshTimer = nil;
    [self emptyCircleAndLabel];
    networIsConnect = NO;
    
    
}
-(void)emptyCircleAndLabel
{
    
    cicleBlueImageView.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"New圆环-%ld",(long)tunerNum]];
    
    numImage.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"M%ld",(long)tunerNum]];
    
    
    
    liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
    NSLog(@"livePlayCount livePlayCount 66 %ld",livePlayCount);
    recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
    
    //        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
    
    distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
    
    
    
    if (scrollUp == YES) {
        self.scrollView.frame = CGRectMake(0, -275, SCREEN_WIDTH, SCREEN_HEIGHT + tunerNum*80);
        
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
        
        NSLog(@"阿打算打算房那是你说的安短111  UP");
        
        if (tunerNum == 0) {
            
            [UIView animateWithDuration:0.4
                                  delay:0.02
                                options:UIViewAnimationCurveLinear
                             animations:^{
                                 
                                 self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                                 //                             scrollView.contentOffset = CGPointMake(0, 0);
                                 self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200 + 400);
                                 
                                 
                                 scrollUp = NO;
                                 self.tableView.scrollEnabled = YES;
                                 //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
                             }
                             completion:^(BOOL finished)
             {
                 NSLog(@"animateanimate0000");
                 self.tableView.scrollEnabled = YES;
                 self.scrollView.scrollEnabled = NO;
                 
             } ];
            
        }
        
        
        
    }else
    {
        self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        //                             scrollView.contentOffset = CGPointMake(0, 0);
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200 + 400);
        
        NSLog(@"阿打算打算房那是你说的安短111  down");
        
        self.tableView.editing = NO;
        
        self.scrollView.scrollEnabled = YES;
        if (tunerNum == 0) {
            
            self.scrollView.scrollEnabled = NO;
        }
    }
    
    
    
    
    //    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
    
    self.tableView.frame =  CGRectMake(0, TopViewHeight, SCREEN_WIDTH, tunerNum*80);
    
    [USER_DEFAULT setObject:nil forKey:@"monitorTableArrTemp"];
    
    NSLog(@"monitorTableArrTemp.count ；%d",monitorTableArr.count);
    
}
#define mark - 网络连接后触发此方法
-(void)netWorkIsConnect
{
    NSLog(@"Major ccccccccccccccccc");
    if (refreshTimer == nil && networIsConnect == NO) {
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshViewByJudgeData) userInfo:nil repeats:YES];
    }
    [self.view addSubview:self.tableView];
    [scrollView  addSubview:self.tableView];
    self.scrollView.scrollEnabled = YES;
    networIsConnect = YES;
    
}
-(void) viewWillAppearDealyFunction
{
    
    self.tabBarController.tabBar.hidden = NO;
    
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
    NSLog(@"getNotificInfoByMySelf zhixing le ");
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
    
    //    [monitorTableArr removeAllObjects];
    
    [self getEffectiveData:retDataByMySelf];
    
}

-(void)getNotificInfo //第一次启动时候获取tuner信息
{
    tunerNum = 0; ///******
    [monitorTableArr removeAllObjects];
    livePlayCount = 0;
    NSLog(@"livePlayCount livePlayCount bbbb %ld",livePlayCount);
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
    NSLog(@"livePlayCount livePlayCount www %ld",livePlayCount);
    liveRecordCount = 0;
    liveTimeShiteCount = 0;
    deliveryCount = 0;
    pushVodCount = 0;
    tunerNum = 0;
    //    livePlayArr = [[NSMutableArray alloc]init];
    //    liveRecordArr = [[NSMutableArray alloc]init];
    //    liveTimeShiteArr = [[NSMutableArray alloc]init];
    //    deliveryArr = [[NSMutableArray alloc]init];
    //    pushVodArr = [[NSMutableArray alloc]init];
    monitorTableDic = [[NSMutableDictionary alloc]init];
    monitorTableArr = [[NSMutableArray alloc]init];
    
    refreshTimer = [[NSTimer alloc]init];
    
    
    ///
    //    socketUtils = [[SocketUtils alloc]init];
    //    [self initNotific];
}

-(void)initNotific
{
    //断网通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netWorkIsColseNotice" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkIsColse) name:@"netWorkIsColseNotice" object:nil];
    
    //网络回复连接通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netWorkIsConnectNotice" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkIsConnect) name:@"netWorkIsConnectNotice" object:nil];
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
#pragma mark - 加载顶部的 多彩color 以及上面的各种图片
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
#pragma mark - 多彩color 图片上的各种图片添加
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
    NSString * MLRecording = NSLocalizedString(@"MLRecording", nil);
    if (MLRecording.length > 10 ) {
        labImage.image = [UIImage  imageNamed:@"Devicemonitor"];
    }else
    {
        labImage.image = [UIImage  imageNamed:@"Tunermonitor"];
    }
    
    [cicleClearImageView addSubview:labImage];
}
#pragma mark - 底部的各项tuner的数量 和底部竖直的细线
-(void)loadNumLab  //底部的各项tuner的数量
{
    [self loadNumAnddelete];
    
    
    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]    ) {
        NSLog(@"此刻是5s和4s 的大小");
        
        NSString * MLRecording = NSLocalizedString(@"MLRecording", nil);
        
        if (MLRecording > 10) {
            UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8+14+35-3, 325, 2, 50)];
            verticalView1.layer.cornerRadius = 1.0;
            verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
            [colorImageView addSubview:verticalView1];
            
            
            UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2 - 11-22+6, 325, 2, 50)];
            verticalView3.layer.cornerRadius = 1.0;
            verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
            [colorImageView addSubview:verticalView3];
        }else
        {
            UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8+14+38, 325, 2, 50)];
            verticalView1.layer.cornerRadius = 1.0;
            verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
            [colorImageView addSubview:verticalView1];
            
            
            UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2 - 11-22, 325, 2, 50)];
            verticalView3.layer.cornerRadius = 1.0;
            verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
            [colorImageView addSubview:verticalView3];
        }
        
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]  || [deviceString isEqualToString:@"iPhone8"] || [deviceString isEqualToString:@"iPhoneX"]  || [deviceString isEqualToString:@"iPhone Simulator"] ) {
        NSLog(@"此刻是6的大小");
        
        UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth ) + 30, 325, 2, 48)];
        verticalView1.layer.cornerRadius = 1.0;
        verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
        [colorImageView addSubview:verticalView1];
        
        //        UIView * verticalView2 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(1+1)-2 +CutWidth*1, 325, 2, 40)];
        //        verticalView2.layer.cornerRadius = 1.0;
        //        verticalView2.backgroundColor = RGBA(245, 245, 245, 0.3);
        //        [colorImageView addSubview:verticalView2];
        
        UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2 - 20, 325, 2, 48)];
        verticalView3.layer.cornerRadius = 1.0;
        verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
        [colorImageView addSubview:verticalView3];
        
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] || [deviceString isEqualToString:@"iPhone8 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        UIView * verticalView1 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )-8 + 38, 325, 2, 48)];
        verticalView1.layer.cornerRadius = 1.0;
        verticalView1.backgroundColor = RGBA(245, 245, 245, 0.3);
        [colorImageView addSubview:verticalView1];
        
        //        UIView * verticalView2 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(1+1)-2 +CutWidth*1, 325, 2, 40)];
        //        verticalView2.layer.cornerRadius = 1.0;
        //        verticalView2.backgroundColor = RGBA(245, 245, 245, 0.3);
        //        [colorImageView addSubview:verticalView2];
        
        UIView * verticalView3 = [[UIView alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +(TopBottomNameWidth )*(2+1)+3 +CutWidth*2 - 20, 325, 2, 48)];
        verticalView3.layer.cornerRadius = 1.0;
        verticalView3.backgroundColor = RGBA(245, 245, 245, 0.3);
        [colorImageView addSubview:verticalView3];
    }
    
    
    
    
    
}

#pragma mark - 加载那些全局的数字，等待刷新并且删除重新加载一遍
-(void)loadNumAnddelete  //加载那些全局的数字，等待刷新并且删除重新加载一遍
{
    deviceString = [GGUtil deviceVersion];
    
    NSString * MLDelivery = NSLocalizedString(@"MLDelivery", nil);
    
    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]   ) {
        NSLog(@"此刻是5s和4s 的大小");
        
        NSString * MLRecording = NSLocalizedString(@"MLRecording", nil);
        NSString * MLLive = NSLocalizedString(@"MLLive", nil);
        
        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(20 + 25 - 22, 360, 142/2 + 15, 15)];
        liveNumLab.text = MLLive;
        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
        liveNumLab.font = FONT(13);
        [colorImageView addSubview:liveNumLab];
        
        
        
        if (MLRecording.length > 10) {
            recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(85 + 32 - 4, 360, 200/2, 15)];
        }else
        {
            recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(85 + 50 - 4, 360, 142/2, 15)];
        }
        
        recoderLab.text = MLRecording;
        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
        recoderLab.font = FONT(12);
        [colorImageView addSubview:recoderLab];
        
        
        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(240 - 12, 360, 142/2, 15)];
        
        distributeLab.text = MLDelivery;
        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
        distributeLab.font = FONT(13);
        [colorImageView addSubview:distributeLab];
        
        
        liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+27, liveNumLab.frame.origin.y-26, 16, 20)];
        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
        NSLog(@"livePlayCount livePlayCount 11 %ld",livePlayCount);
        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
        liveNum_Lab.font = FONT(24);
        [colorImageView addSubview:liveNum_Lab];
        
        
        
        if (MLRecording.length > 10) {
            recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(recoderLab.frame.origin.x+41, liveNumLab.frame.origin.y-26, 16, 20)];
        }else
        {
            recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(recoderLab.frame.origin.x+21, liveNumLab.frame.origin.y-26, 16, 20)];
        }
        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
        recoder_Lab.font = FONT(24);
        [colorImageView addSubview:recoder_Lab];
        
        distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(distributeLab.frame.origin.x+18, liveNumLab.frame.origin.y-26, 16, 20)];
        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
        distribute_Lab.font = FONT(24);
        [colorImageView addSubview:distribute_Lab];
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]|| [deviceString isEqualToString:@"iPhone8"] || [deviceString isEqualToString:@"iPhoneX"] || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        NSString * MLRecording = NSLocalizedString(@"MLRecording", nil);
        NSString * MLLive = NSLocalizedString(@"MLLive", nil);
        
        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft + 10, 360, 142/2 + 10, 15)];
        
        liveNumLab.text =  MLLive; //@"TV Live";
        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
        liveNumLab.font = FONT(13);
        [colorImageView addSubview:liveNumLab];
        
        
        
        if (MLRecording.length > 10) {
            recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth +CutWidth +32 , 360, 200/2, 15)];
        }else
        {
            recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth +CutWidth +48 , 360, 142/2, 15)];
        }
        
        
        recoderLab.text = MLRecording;
        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
        recoderLab.font = FONT(13);
        [colorImageView addSubview:recoderLab];
        
        
        
        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 -10, 360, 142/2, 15)];
        distributeLab.text = MLDelivery;
        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
        distributeLab.font = FONT(13);
        [colorImageView addSubview:distributeLab];
        
        liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+30 , liveNumLab.frame.origin.y-34, 16, 20)];
        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
        NSLog(@"livePlayCount livePlayCount 22 %ld",livePlayCount);
        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
        liveNum_Lab.font = FONT(24);
        [colorImageView addSubview:liveNum_Lab];
        
        
        if (MLRecording.length > 10) {
            recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(recoderLab.frame.origin.x+40 , liveNumLab.frame.origin.y-30, 16, 20)];
        }else
        {
            recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(recoderLab.frame.origin.x+20 , liveNumLab.frame.origin.y-30, 16, 20)];
        }
        
        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
        recoder_Lab.font = FONT(24);
        [colorImageView addSubview:recoder_Lab];
        
        
        
        distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(distributeLab.frame.origin.x+18 , liveNumLab.frame.origin.y-30, 16, 20)];
        distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
        distribute_Lab.textColor = RGBA(245, 245, 245, 0.65);
        distribute_Lab.font = FONT(24);
        [colorImageView addSubview:distribute_Lab];
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"]  || [deviceString isEqualToString:@"iPhone8 Plus"]
              ) {
        NSLog(@"此刻是6 plus的大小");
        
        NSString * MLRecording = NSLocalizedString(@"MLRecording", nil);
        NSString * MLLive = NSLocalizedString(@"MLLive", nil);
        liveNumLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft , 360, 142/2 + 20, 15)];
        liveNumLab.text = MLLive;
        liveNumLab.textColor = RGBA(245, 245, 245, 0.65);
        liveNumLab.font = FONT(13);
        [colorImageView addSubview:liveNumLab];
        
        
        if (MLRecording.length > 10) {
            recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth +CutWidth + 32 , 360, 200/2, 15)];
        }else
        {
            recoderLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth +CutWidth + 50 , 360, 142/2, 15)];
        }
        recoderLab.text = MLRecording;
        recoderLab.textColor = RGBA(245, 245, 245, 0.65);
        recoderLab.font = FONT(13);
        [colorImageView addSubview:recoderLab];
        
        //        timeShiftLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*2 +CutWidth*2 , 360, 142/2, 13)];
        //        timeShiftLab.text = @"Time Shift";
        //        timeShiftLab.textColor = RGBA(245, 245, 245, 0.65);
        //        timeShiftLab.font = FONT(13);
        //        [colorImageView addSubview:timeShiftLab];
        
        distributeLab = [[UILabel alloc]initWithFrame:CGRectMake(TopBottomNameMarginLeft +TopBottomNameWidth*3 +CutWidth*3 - 0, 360, 142/2, 15)];
        distributeLab.text = MLDelivery;
        distributeLab.textColor = RGBA(245, 245, 245, 0.65);
        distributeLab.font = FONT(13);
        [colorImageView addSubview:distributeLab];
        
        liveNum_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+27, liveNumLab.frame.origin.y-40 + 10, 16, 20)];
        liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
        NSLog(@"livePlayCount livePlayCount 33 %ld",livePlayCount);
        liveNum_Lab.textColor = RGBA(245, 245, 245, 0.65);
        liveNum_Lab.font = FONT(24);
        [colorImageView addSubview:liveNum_Lab];
        
        
        
        if (MLRecording.length > 10) {
            recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(recoderLab.frame.origin.x+40, liveNumLab.frame.origin.y-40 + 10, 16, 20)];
        }else
        {
            recoder_Lab = [[UILabel alloc]initWithFrame:CGRectMake(recoderLab.frame.origin.x+20, liveNumLab.frame.origin.y-40 + 10, 16, 20)];
        }
        recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
        recoder_Lab.textColor = RGBA(245, 245, 245, 0.65);
        recoder_Lab.font = FONT(24);
        [colorImageView addSubview:recoder_Lab];
        
        //        timeShift_Lab = [[UILabel alloc]initWithFrame:CGRectMake(liveNumLab.frame.origin.x+20+TopBottomNameWidth*2 +CutWidth*2, liveNumLab.frame.origin.y-40, 16, 20)];
        //        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
        //        timeShift_Lab.textColor = RGBA(245, 245, 245, 0.65);
        //        timeShift_Lab.font = FONT(24);
        //        [colorImageView addSubview:timeShift_Lab];
        
        distribute_Lab = [[UILabel alloc]initWithFrame:CGRectMake(distributeLab.frame.origin.x+18, liveNumLab.frame.origin.y-40 + 10, 16, 20)];
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
    
    if ([tunerAllData length] >= 27 + 1) {
        dataLen = [tunerAllData subdataWithRange:NSMakeRange(27, 1)];
    }
    
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
    [monitorTableArr removeAllObjects];
    if (networIsConnect == YES) {
        NSLog(@"=======================test gettuner");
        NSLog(@"allTunerData :%@",allTunerData);
        //获取数据总长度
        NSData * dataLen = [[NSData alloc]init];
        if ([allTunerData length] >= 24 + 4) {
            dataLen = [allTunerData subdataWithRange:NSMakeRange(24, 4)];
        }else
        {
            return;
        }
        
        
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
        
        if ([allTunerData length] >= 38 + value-10) {
            effectiveData = [allTunerData subdataWithRange:NSMakeRange(38,(value-10))];
        }else
        {
            return;
        }
        
        
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
            NSData * databuff = [[NSData alloc]init];
            if ([effectiveData length] >= mutablefigure + 4) {
                databuff = [effectiveData subdataWithRange:NSMakeRange(mutablefigure, 4)];
            }else
            {
                return;
            }
            
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
                
                if ([effectiveData length] >= placeFigure+ 4 + 4) {
                    serviceTypeData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+4, 4)];
                }else
                {
                    return;
                }
                
                NSLog(@"serviceTypeData: %@",serviceTypeData);
                //这里获取network_id
                NSData * networkIdData = [[NSData alloc]init];
                if ([effectiveData length] >= placeFigure + 12 + 2) {
                    networkIdData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+12, 2)];
                }else
                {
                    return;
                }
                
                //这里获取ts_id
                NSData * tsIdData = [[NSData alloc]init];
                if ([effectiveData length] >= placeFigure+14 + 2) {
                    tsIdData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+14, 2)];
                }else
                {
                    return;
                }
                
                
                //这里获取service_id
                NSData * serviceIdData = [[NSData alloc]init];
                if ([effectiveData length] >= placeFigure + 16 + 2) {
                    serviceIdData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+16, 2)];
                }else
                {
                    return;
                }
                
                //这里获取name_len
                NSData * nameLenData = [[NSData alloc]init];
                if ([effectiveData length] >= placeFigure + 18 + 1) {
                    nameLenData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+18, 1)];
                }else
                {
                    return;
                }
                
                
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
                    
                    if ([effectiveData length] >= placeFigure + 18 + 1 + clienNameLenCopy1) {
                        clientNameData = [effectiveData subdataWithRange:NSMakeRange(placeFigure+18+1, clienNameLenCopy1)];
                    }else
                    {
                        return;
                    }
                    
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
                        
                        NSLog(@"[self.tableView reloadData]  11111");
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
        
        if (tunerNum == 0) {
            
            self.scrollView.scrollEnabled = NO;
        }
        
        [self changeView];
        NSLog(@"======222-2-2-2-2");
    }
    else
    {}
}

-(void)changeView
{
    if (networIsConnect == YES) {
        //    NSLog(@"monitorTableArr :%@,",monitorTableArr);
        
        int monitorApperCount ;
        NSString * monitorApperCountStr =  [USER_DEFAULT objectForKey:@"monitorApperCountStr"];
        monitorApperCount = [monitorApperCountStr intValue];
        if (monitorApperCount == 0) {
            
            cicleBlueImageView.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"New圆环-%ld",(long)tunerNum]];
            
            numImage.image = [UIImage  imageNamed:[NSString  stringWithFormat:@"M%ld",(long)tunerNum]];
            
            
            
            liveNum_Lab.text = [NSString stringWithFormat:@"%ld",(long)livePlayCount];
            NSLog(@"livePlayCount livePlayCount 44 %ld",livePlayCount);
            
            recoder_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveRecordCount];
            
            //        timeShift_Lab.text = [NSString stringWithFormat:@"%ld",(long)liveTimeShiteCount];
            
            distribute_Lab.text = [NSString stringWithFormat:@"%ld",(long)deliveryCount];
            
            
            
            if (scrollUp == YES) {
                self.scrollView.frame = CGRectMake(0, -275, SCREEN_WIDTH, SCREEN_HEIGHT + tunerNum*80);
                
                self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
                
                NSLog(@"阿打算打算房那是你说的安短  UP");
                
                if (tunerNum == 0) {
                    
                    
                    
                    //                self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                    //                //                             scrollView.contentOffset = CGPointMake(0, 0);
                    //                self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200 + 400);
                    //
                    //                self.scrollView.contentOffset = CGPointMake(0, 275);
                    
                    [UIView animateWithDuration:0.4
                                          delay:0.02
                                        options:UIViewAnimationCurveLinear
                                     animations:^{
                                         
                                         self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                                         //                             scrollView.contentOffset = CGPointMake(0, 0);
                                         self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200 + 400);
                                         
                                         
                                         scrollUp = NO;
                                         self.tableView.scrollEnabled = YES;
                                         //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
                                     }
                                     completion:^(BOOL finished)
                     {
                         NSLog(@"animateanimate0000");
                         self.tableView.scrollEnabled = YES;
                         self.scrollView.scrollEnabled = NO;
                         
                     } ];
                    
                }
                
                
                
            }else
            {
                self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                //                             scrollView.contentOffset = CGPointMake(0, 0);
                self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200 + 400);
                
                NSLog(@"阿打算打算房那是你说的安短  down");
                
                self.tableView.editing = NO;
                
                self.scrollView.scrollEnabled = YES;
                if (tunerNum == 0) {
                    
                    self.scrollView.scrollEnabled = NO;
                }
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
        
    }else
    {
        NSLog(@"getNotificInfoByMySelf 虽然断网了，但是此方法被触发");
        
    }
    
    
    //新加 防止在未进入monitor页面的情况下，触发无网络的通知
    [self initNotific];
    
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
            NSLog(@"livePlayCount livePlayCount 55 %ld",livePlayCount);
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
    NSLog(@"currentPostion:%f",currentPostion - lastPosition);
    
    if (tunerNum == 0) {
        self.scrollView.scrollEnabled = NO;
    }else
    {
        self.scrollView.scrollEnabled = YES;
        
        if (currentPostion - lastPosition > 30  && scrollUp == NO && tunerNum > 0){
            CGPoint position = CGPointMake(0, 275);
            //        [scrollView     :position animated:YES];
            [UIView animateWithDuration:0.4
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
                 NSLog(@"animateanimate0000");
                 self.tableView.scrollEnabled = YES;
             } ];
            NSLog(@"scrollView.contentOffset2.y:%f",scrollView.contentOffset.y);
            self.tableView.scrollEnabled = YES;
        }
        
        
        //    if (tunerNum == 0 &&  scrollUp == YES) {      //从顶部向下滑动，类似于没有数据时，从下往上滑动
        //        NSLog(@"scrollView.contentOffset.y:%f",self.scrollView.contentOffset.y);
        //        if (self.tableView.contentOffset.y<275&& scrollUp == YES
        //            //        currentPostion - lastPosition < 20 && scrollView.contentOffset.y <25
        //            ){
        //            CGPoint position = CGPointMake(0, 275);
        //
        //            [UIView animateWithDuration:0.4
        //                                  delay:0.02
        //                                options:UIViewAnimationCurveLinear
        //                             animations:^{
        //                                 //                             [scrollView setContentOffset: position ];
        //                                 self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        //                                 //                             scrollView.contentOffset = CGPointMake(0, 0);
        //                                 self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200 + 400);//SCREEN_HEIGHT); //TopViewHeight+tunerNum*80+200);
        //
        //                                 scrollUp = NO;
        //                                 //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
        //                                 self.tableView.scrollEnabled = NO;
        //                             }
        //                             completion:^(BOOL finished)
        //             { NSLog(@"animateanimate1111");
        //                 self.tableView.scrollEnabled = NO;
        //             } ];
        //            NSLog(@"scrollView.contentOffset2.y:%f",scrollView.contentOffset.y);
        //            self.tableView.scrollEnabled = NO;
        //        }
        //    }else if (tunerNum == 0 &&  scrollUp == NO)   //从下向上滑动，类似于没有数据时，从下往上滑动
        //    {
        //        CGPoint position = CGPointMake(0, 275);
        //        //        [scrollView     :position animated:YES];
        //        [UIView animateWithDuration:0.4
        //                              delay:0.02
        //                            options:UIViewAnimationCurveLinear
        //                         animations:^{
        //
        //                             //效果：最终到达顶端
        //                             self.scrollView.frame = CGRectMake(0, -275, SCREEN_WIDTH, SCREEN_HEIGHT+tunerNum*80+200);//
        //
        //                             self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT); //TopViewHeight+tunerNum*80+200-93);
        //
        //                             scrollUp = YES;
        //                             self.tableView.scrollEnabled = YES;
        //                             self.scrollView.bounces=NO;
        //                             //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
        //                         }
        //                         completion:^(BOOL finished)
        //         {
        //             NSLog(@"animateanimate2222");
        //             self.tableView.scrollEnabled = YES;
        //
        //             self.scrollView.bounces=NO;
        ////             self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        ////             //                             scrollView.contentOffset = CGPointMake(0, 0);
        ////             self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200 + 400);
        ////
        ////             self.scrollView.contentOffset = CGPointMake(0, 275);
        //
        //         } ];
        //        NSLog(@"scrollView.contentOffset2.y:%f",scrollView.contentOffset.y);
        //        self.tableView.scrollEnabled = YES;
        //
        //    }
        //    else{
        if(scrollView.class == self.tableView.class){
            if (self.tableView.contentOffset.y<-30&& scrollUp == YES
                //        currentPostion - lastPosition < 20 && scrollView.contentOffset.y <25
                ){
                CGPoint position = CGPointMake(0, 275);
                
                [UIView animateWithDuration:0.4
                                      delay:0.02
                                    options:UIViewAnimationCurveLinear
                                 animations:^{
                                     //                             [scrollView setContentOffset: position ];
                                     self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                                     //                             scrollView.contentOffset = CGPointMake(0, 0);
                                     self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200 + 400);//SCREEN_HEIGHT); //TopViewHeight+tunerNum*80+200);
                                     scrollUp = NO;
                                     //                             scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,TopViewHeight+tunerNum*80+200);
                                     self.tableView.scrollEnabled = NO;
                                 }
                                 completion:^(BOOL finished)
                 { NSLog(@"animateanimate3333");
                     self.tableView.scrollEnabled = NO;
                 } ];
                NSLog(@"scrollView.contentOffset2.y:%f",scrollView.contentOffset.y);
                self.tableView.scrollEnabled = NO;
            }
        }
        //    }
        
        
    }
    
    
    
}

//***********删除代码
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //>>
    NSArray * monitorTypeArr = [[NSArray alloc]init];
    NSLog(@"monitorTableArr.count %d",monitorTableArr.count);
    NSLog(@"indexPath.row %d",indexPath.row);
    
    if (monitorTableArr.count > 0 && monitorTableArr.count > indexPath.row ) {
        
        monitorTypeArr =   monitorTableArr[indexPath.row];
    }else
    {
        NSLog(@"卧槽，差点越界出错");
        return UITableViewCellEditingStyleNone ;
    }
    
    
    NSLog(@"monitorTypeArr。count %d",monitorTypeArr.count);
    
    NSData * tableTypedata ;
    
    NSData * phoneClientName;
    
    if (monitorTypeArr.count > 2 ) {
        
        tableTypedata = monitorTypeArr[1];
        
        phoneClientName = monitorTypeArr[2];
    }else
    {
        NSLog(@"卧槽，差点越界出错222");
        return UITableViewCellEditingStyleNone ;
    }
    
    int type;
    type =  [SocketUtils uint16FromBytes: tableTypedata];  //tuner的类别
    
    NSString * clientNameStr = [[NSString alloc]initWithData:phoneClientName encoding:NSUTF8StringEncoding];  //获取的设备名称
    NSString * phoneModel =  [GGUtil deviceVersion]; //[self deviceVersion];
    NSLog(@"手机型号:%@",phoneModel);
    NSString* client_name = [NSString stringWithFormat:@"Phone%@",phoneModel];  //***
    //实际情况下此处可做修改：
    if (type == DELIVERY  &&[clientNameStr isEqualToString:phoneModel]){//&&  [clientNameStr isEqualToString:client_name]) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        networIsConnect = NO;
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
    
    //>>
    
    //    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @" OFF ";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"aaaaabababababababa");
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        [USER_DEFAULT setObject:@"stopDelivery" forKey:@"deliveryPlayState"];   //视频分发终止，节目禁止播放
        
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
        if (monitorTableArr.count == 0 ) {
            return;
        }
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
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didEndEditingRowAtIndexPath");
    networIsConnect = YES;
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

