//
//  TVViewController.m
//  starApp
//
//  Created by xyz on 16/8/1.
//  Copyright © 2016年 xyz. All rights reserved.
//

#import "TVViewController.h"
#import "TVCell.h"
#import "THProgressView.h"
//#import "HexColors.h"


static const CGSize progressViewSize = {375, 1.5f };
@interface TVViewController ()<YLSlideViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    YLSlideView * _slideView;
    NSArray *colors;
    NSArray *_testArray;
    NSMutableData * urlData;
    
}
@property (nonatomic, strong) ZXVideoPlayerController *videoController;
@property(nonatomic,strong)SearchViewController * searchViewCon;

//new  scroll table
@property (nonatomic, strong) NSMutableArray *dataSource;    //
@property (nonatomic, strong) UITableView *table;   // table表
@property (nonatomic, strong) UIScrollView *topScroller;


@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *categorys;

@property (nonatomic, assign) NSInteger currentIndex;

@property (strong,nonatomic) NSMutableArray *serviceData;
//table的data
@property (strong,nonatomic) NSMutableArray *serviceTableData;

@property (nonatomic, assign) NSInteger category_index;
@property (strong,nonatomic)NSMutableDictionary * dicTemp;

@property (strong,nonatomic)NSString * service_videoindex;     //video的频道索引
@property (strong,nonatomic)NSString * service_videoname;    //video的频道名称
@property (strong,nonatomic)NSString * event_videoname;      //video的节目名称
@property (strong,nonatomic)NSString * event_startTime;      //video的直播节目开始时间
@property (strong,nonatomic)NSString * event_endTime;        //video的节目名称结束时间

//@property (strong,nonatomic) NSMutableArray *arrdata;
//*****progressLineView
@property (nonatomic) CGFloat progress;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *progressViews;
@property (nonatomic, strong)  UIButton * searchBtn;

@end

@implementation TVViewController

@synthesize searchViewCon;
@synthesize avController = _avController;   //搜索dms用
@synthesize  serviceModel;
@synthesize socketView;
//@synthesize videoPlay;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    //打开时开始连接socket并且发送心跳
    self.socketView  = [[SocketView  alloc]init];
    [self.socketView viewDidLoad];

    [self loadNav];
    [self lineView];  //一条0.5pt的线
    //new
    [self initData];    //table表
    //    [self loadUI];              //加载table 和scroll
    //    [self getTopCategory];
    [self getServiceData];    //获取表数据
    [self initProgressLine];
    
    //修改tabbar选中的图片颜色和字体颜色
    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = image;
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
  
    //视频部分
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self playVideo];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars =NO;
    self.modalPresentationCapturesStatusBarAppearance =NO;
    self.navigationController.navigationBar.translucent =NO;
    
    
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
    
    
    [request startAsynchronous];
    
    WEAKGET
    [request setCompletionBlock:^{
        NSDictionary *response = httpRequest.responseString.JSONValue;
        //        NSLog(@"response = %@",response);
        NSArray *data = response[@"category"];
        
        if (!isValidArray(data) || data.count == 0){
            return ;
        }
        self.categorys = (NSMutableArray *)data;
        
        //设置滑动条

        _slideView = [[YLSlideView alloc]initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                                                                  SCREEN_WIDTH,
                                                                  SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)
                                             forTitles:self.categorys];
        
        
        _slideView.backgroundColor = [UIColor whiteColor];
        _slideView.delegate        = self;
        
        [self.view addSubview:_slideView];
        
        
        
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//1.line
-(UIView *) lineView
{
    if (!_lineView){
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.5)];
        _lineView.backgroundColor = lineBlackColor;
        [self.view addSubview:_lineView];
    }
    return _lineView;
}
-(void) initData
{
    self.dicTemp = [[NSMutableDictionary alloc]init];
    self.dataSource = [NSMutableArray array];
}
-(void)initProgressLine
{
    THProgressView *topProgressView = [[THProgressView alloc] initWithFrame:CGRectMake(0  ,
                                                                                       VIDEOHEIGHT+kZXVideoPlayerOriginalHeight ,
                                                                                       SCREEN_WIDTH,
                                                                                       progressViewSize.height)];
    topProgressView.borderTintColor = [UIColor whiteColor];
    topProgressView.progressTintColor = ProgressLineColor;
    [self.view addSubview:topProgressView];
    [self.view bringSubviewToFront:topProgressView];
    
    self.progressViews = @[ topProgressView ];
    
    
    
}


- (void)updateProgress :(NSTimer *)Time
{
    int timeCut;
    NSString *  starttime;
    if(ISNULL([[Time userInfo] objectForKey:@"EndTime"]) || ISNULL([[Time userInfo]objectForKey:@"StarTime"]))
    {
        NSLog(@"结束时间或者开始时间不能为空");
    }
    else
    {
    timeCut= [[[Time userInfo] objectForKey:@"EndTime" ] intValue ] - [[[Time userInfo]objectForKey:@"StarTime"] intValue];
    starttime =[[Time userInfo]objectForKey:@"StarTime"];
    }
    //算出时间间隔
//     = [[[Time userInfo] objectForKey:@"EndTime" ] intValue ] - [[[Time userInfo]objectForKey:@"StarTime"] intValue];
    NSLog(@"timecut %d",timeCut);
//    NSString *  starttime =[[Time userInfo]objectForKey:@"StarTime"];
    //    self.progress += 0.20f;
    //每次移动的距离
    self.progress = timeCut;
    

    
    [self.progressViews enumerateObjectsUsingBlock:^(THProgressView *progressView, NSUInteger idx, BOOL *stop) {
        [USER_DEFAULT setObject:starttime forKey:@"StarTime"];
        [progressView setProgress:self.progress animated:YES ];
    }];
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
//-(void) loadUI
//{
////    [self creatTopScroller];   //创建scroll
//}

//获取table
-(void) getServiceData
{
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
    
    
    [request startAsynchronous];
    
    WEAKGET
    [request setCompletionBlock:^{
        NSDictionary *response = httpRequest.responseString.JSONValue;
        //        NSLog(@"response = %@",response);
        NSArray *data1 = response[@"service"];
        if (!isValidArray(data1) || data1.count == 0){
            return ;
        }
        self.serviceData = (NSMutableArray *)data1;
        
        //        NSLog(@"--------%@",self.serviceData);
        
        [self.table reloadData];
        
    }];
    
}
-(void)loadNav
{
    //顶部搜索条
    self.navigationController.navigationBarHidden = YES;
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -30, SCREEN_WIDTH, topViewHeight)];
    topView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:topView];
    
//    self.navigationController.navigationBar.barTintColor = UIStatusBarStyleDefault;
    
    //搜索按钮
    self.searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight)];
//    [searchBtn setTitle:@"search" forState:UIControlStateNormal];
    [self.searchBtn setBackgroundColor:[UIColor whiteColor]];
//    [searchBtn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
    [self.searchBtn setBackgroundImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal]  ;
    [self.view addSubview:self.searchBtn];
    [topView bringSubviewToFront:self.searchBtn];
    [self.searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //视频播放
    //----直播源
    self.video = [[ZXVideo alloc] init];
    //    video.playUrl = @"http://baobab.wdjcdn.com/1451897812703c.mp4";
    //  http://192.168.1.1/segment_delivery/delivery_0/play_tv2ip_0.m3u8
    
    self.video.title = [self.service_videoindex stringByAppendingString:self.service_videoname];
    NSLog(@"video.title %@",self.video.title);
    NSLog(@"----%@",self.video.playUrl);
    
    
    
}

- (void)playVideo
{
    if (!self.videoController) {
        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, VIDEOHEIGHT, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight)];
        
        __weak typeof(self) weakSelf = self;
        self.videoController.videoPlayerGoBackBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
            [strongSelf.navigationController setNavigationBarHidden:NO animated:YES];
            
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
            
            strongSelf.videoController = nil;
        };
        
        self.videoController.videoPlayerWillChangeToOriginalScreenModeBlock = ^(){
            NSLog(@"切换为竖屏模式");
            
            float noewWidth = [UIScreen mainScreen].bounds.size.width;
           
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",noewWidth],@"noewWidth",nil];
            
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"fixTopBottomImage" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
          self.tabBarController.tabBar.hidden = NO;
            _slideView.frame =CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5);
     
            
            
        };
        self.videoController.videoPlayerWillChangeToFullScreenModeBlock = ^(){
            NSLog(@"切换为全屏模式");
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
            self.navigationController.navigationBar.translucent = NO;
            self.extendedLayoutIncludesOpaqueBars
            = NO;
            
            self.edgesForExtendedLayout =UIRectEdgeNone;
            float noewWidth = [UIScreen mainScreen].bounds.size.width;
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",noewWidth],@"noewWidth",nil];
            
            
            
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"fixTopBottomImage" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            self.tabBarController.tabBar.hidden = YES;

            
            
            self.view.frame = CGRectMake(0, 0, 800, 800);
            _slideView.frame = CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+800,
                                          SCREEN_WIDTH,
                                          SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5);
            
//            [self setFullScreenView];
            
            NSLog(@"全屏宽 ： %f",[UIScreen mainScreen].bounds.size.width);
            
            
        };
        
       
        [self.videoController showInView:self.view];
        self.navigationController.navigationBar.translucent = NO;
        self.extendedLayoutIncludesOpaqueBars
        = NO;
        
        self.edgesForExtendedLayout =UIRectEdgeNone;

        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    }
    
    
    self.videoController.video = self.video;
    
}

-(void)setFullScreenView
{
    _fullScreenView = [[FullScreenView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self.view addSubview:_fullScreenView];
}

//搜索按钮
-(void)searchBtnClick
{
    searchViewCon = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchViewCon animated:YES];
    //
    //    //停止播放
    //    [self.socketView  deliveryPlayExit];
    
    ////    密码校验
    //     [self.socketView passwordCheck];
    
    //    //获取分发资源信息
    //    [self.socketView csGetResource];
    
    
    
}

//************************************************
//table可以滑动的次数
- (NSInteger)columnNumber{
    //   return colors.count;
    return self.categorys.count;
}

- (TVTable *)slideView:(YLSlideView *)slideView
     cellForRowAtIndex:(NSUInteger)index{
    
    TVTable * cell = [slideView dequeueReusableCell];
    
    if (!cell) {
        cell = [[TVTable alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT -_slideView.frame.origin.y-49.5)
                                       style:UITableViewStylePlain];
        cell.delegate   = self;
        cell.dataSource = self;
    }
    
    //    cell.backgroundColor = colors[index];
    //     NSLog(@"index --------:%@ ",@(index));
    return cell;
}
- (void)slideVisibleView:(TVTable *)cell forIndex:(NSUInteger)index{
    
    NSLog(@"index :%@ ",@(index));
    
    
    //self.categorys[i]                          不同类别
    //self.categoryModel.service_indexArr        类别的索引数组
    //self.categoryModel.service_indexArr.count
    //给不同的table赋值
    //    for (int i = 0 ; i<self.categorys.count; i++) {
    NSDictionary *item = self.categorys[index];   //当前页面类别下的信息
    self.categoryModel = [[CategoryModel alloc]init];
    
    self.categoryModel.service_indexArr = item[@"service_index"];   //当前类别下包含的节目索引  0--9
    
    //获取EPG信息 展示
    //时间戳转换
    
    //获取不同类别下的节目，然后是节目下不同的cell值                10
    for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {
        
        int indexCat ;
        //   NSString * str;
        indexCat =[self.categoryModel.service_indexArr[i] intValue];
        //cell.tabledataDic = self.serviceData[indexCat -1];
        
        [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
        
        
    }
    //        cell.tabledataDic =  self.categorys[index];
    //    }
    
    //    self.a = index;
    //    NSLog(@"index  self.a--------:%@ ",@(index));
    [cell reloadData]; //刷新TableView
    //    NSLog(@"刷新数据");
}

- (void)slideViewInitiatedComplete:(TVTable *)cell forIndex:(NSUInteger)index{
    
    //可以在这里做数据的预加载（缓存数据）
    NSLog(@"缓存数据 %@",@(index));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell reloadData];
        
    });
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)self.serviceData.count);
    
    return self.categoryModel.service_indexArr.count;
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TVCell defaultCellHeight];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TVCell"];
    if (cell == nil){
        cell = [TVCell loadFromNib];
    }
    
    
    //
    //    TVTable * table = [[TVTable alloc]init];
    //    cell.dataDic = table.tabledataDic;
    
    
    //    cell.aa =  self.category_index;
    //    cell.aaa =self.categoryModel.service_indexArr.count;
    //    NSLog(@"index  cell.aaa--------:%d",cell.aaa);
    
    if (!ISEMPTY(self.dicTemp)) {
        cell.dataDic = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    }else{//如果为空，什么都不执行
    }
    
    NSLog(@"cell.dataDic:%@",cell.dataDic);
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    DetailViewController *controller =[[DetailViewController alloc] init];
    //    controller.dataDic = self.dataSource[indexPath.row];
    //    [self.navigationController pushViewController:controller animated:YES];
    
    //先传输数据到socket，然后再播放视频
    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    
    
    //__
    
    NSArray * audio_infoArr = [[NSArray alloc]init];
    NSArray * subt_infoArr = [[NSArray alloc]init];
    
    NSArray * epg_infoArr = [[NSArray alloc]init];
    //****
    
    
    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
    socketView.socket_ServiceModel.subt_pid = [audio_infoArr[0] objectForKey:@"subt_pid"];
    socketView.socket_ServiceModel.service_network_id = [epgDicToSocket objectForKey:@"service_network_id"];
    socketView.socket_ServiceModel.service_ts_id =[epgDicToSocket objectForKey:@"service_ts_id"];
    socketView.socket_ServiceModel.service_tuner_mode = [epgDicToSocket objectForKey:@"service_tuner_mode"];
    socketView.socket_ServiceModel.service_service_id = [epgDicToSocket objectForKey:@"service_service_id"];
    
    //********
    self.service_videoindex = [epgDicToSocket objectForKey:@"service_logic_number"];
    self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
    epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
    
    NSLog(@"eventname :%@",self.event_startTime);
    //*********
    
    
    
    
    if (ISEMPTY(socketView.socket_ServiceModel.audio_pid)) {
        socketView.socket_ServiceModel.audio_pid = @"0";
    }else if (ISEMPTY(socketView.socket_ServiceModel.subt_pid)){
        socketView.socket_ServiceModel.subt_pid = @"0";
    }else if (ISEMPTY(socketView.socket_ServiceModel.service_network_id)){
        socketView.socket_ServiceModel.service_network_id = @"0";
    }else if (ISEMPTY(socketView.socket_ServiceModel.service_ts_id)){
        socketView.socket_ServiceModel.service_ts_id = @"0";
    }else if (ISEMPTY(socketView.socket_ServiceModel.service_tuner_mode)){
        socketView.socket_ServiceModel.service_tuner_mode = @"0";
    }else if (ISEMPTY(socketView.socket_ServiceModel.service_service_id)){
        socketView.socket_ServiceModel.service_service_id = @"0";
    }
    
    NSLog(@"------%@",socketView.socket_ServiceModel);
    
    
    
    //此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
    
    [self.socketView  serviceTouch ];
    
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

- (void)getDataService:(NSNotification *)text{
    NSLog(@"%@",text.userInfo[@"playdata"]);
    NSLog(@"－－－－－接收到通知------");
    
    //NSData --->byte[]-------NSData----->NSString
    
    NSMutableData * byteDatas;
    byteDatas = [[NSMutableData alloc]init];
    
    //调用GGutil的方法
    byteDatas =  [GGUtil convertNSDataToByte:[USER_DEFAULT objectForKey:@"data_service"] bData:[USER_DEFAULT objectForKey:@"data_service11"]];
    
    NSLog(@"---urlData%@",byteDatas);
    self.video.playUrl = [@"h"stringByAppendingString:[[NSString alloc] initWithData:byteDatas encoding:NSUTF8StringEncoding]];
//    self.video.playUrl = [[NSString alloc] initWithData:byteDatas encoding:NSUTF8StringEncoding];

    self.video.title = [self.service_videoindex stringByAppendingString:self.service_videoname];
    
    self.video.playEventName = self.event_videoname;
    
    [self playVideo];
    //** 计算进度条
    if(!ISNULL(self.event_startTime)&&!ISNULL(self.event_endTime))
    {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setObject:self.event_startTime forKey:@"StarTime"];
        [dict setObject:self.event_endTime forKey:@"EndTime"];
        
//        NSLog(@"dict.start :%@",[dict objectForKey:@"StarTime"]);
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress:) userInfo:dict repeats:YES];
    }
    //**
    NSLog(@"---urlData%@",self.video.playUrl);
    
    
    NSString * str = [NSString stringWithFormat:@"%@",self.video.playUrl];
    
    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"data信息"message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertview show];
    
    
}

@end
