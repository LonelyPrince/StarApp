////
////  TVViewController.m
////  starApp
////
////  Created by xyz on 16/8/1.
////  Copyright © 2016年 xyz. All rights reserved.
////
//
//#import "TVViewController.h"
//#import "TVCell.h"
//#import "MEViewController.h"
//#import "KSGuideManager.h"
//
//#define SCREEN_FRAME ([UIScreen mainScreen].bounds)
////#import "HexColors.h"
//
//
//static const CGSize progressViewSize = {375, 1.5f };
//@interface TVViewController ()<YLSlideViewDelegate,UIScrollViewDelegate,
//UITableViewDelegate,UITableViewDataSource>
//{
//    
//    YLSlideView * _slideView;
//    NSArray *colors;
//    NSArray *_testArray;
//    NSMutableData * urlData;
//    
//    //引导页
//    UIPageControl *pageControl; //指示当前处于第几个引导页
//    UIScrollView *scrollView; //用于存放并显示引导页
//    UIImageView *imageViewOne;
//    UIImageView *imageViewTwo;
//    UIImageView *imageViewThree;
//    UIImageView *imageViewFour;
//    
//    BOOL firstShow;
//    BOOL playState;
//    NSTimer * timerState;
//    int tableviewinit;
//    //状态栏显示状态
//    int statusNum;
//    int touchStatusNum; //这个是在点击播放器的时候会改变的数字，用于判断全屏下状态栏的显示
//}
//
//
//@property (nonatomic, strong) ZXVideoPlayerController *videoController;
//@property(nonatomic,strong)SearchViewController * searchViewCon;
//
////new  scroll table
//@property (nonatomic, strong) NSMutableArray *dataSource;    //
//@property (nonatomic, strong) UITableView *table;   // table表
//@property (nonatomic, strong) UIScrollView *topScroller;
//
//
//@property (nonatomic, strong) UIView *lineView;
//
//@property (nonatomic, strong) NSMutableArray *categorys;
//
//@property (nonatomic, assign) NSInteger currentIndex;
//
//@property (strong,nonatomic) NSMutableArray *serviceData;
////table的data
//@property (strong,nonatomic) NSMutableArray *serviceTableData;
//
//@property (nonatomic, assign) NSInteger category_index;
//@property (strong,nonatomic)NSMutableDictionary * dicTemp;
//
//@property (strong,nonatomic)NSString * service_videoindex;     //video的频道索引
//@property (strong,nonatomic)NSString * service_videoname;    //video的频道名称
//@property (strong,nonatomic)NSString * event_videoname;      //video的节目名称
//@property (strong,nonatomic)NSString * event_startTime;      //video的直播节目开始时间
//@property (strong,nonatomic)NSString * event_endTime;        //video的节目名称结束时间
//
//@property (strong,nonatomic)NSDictionary * TVSubAudioDic;        //video的字幕和音轨
//
//@property (strong,nonatomic)NSDictionary * TVChannlDic;        //video的频道列表
//
//@property (strong,nonatomic)NSMutableData * byteDatas;
////@property (strong,nonatomic) NSMutableArray *arrdata;
////*****progressLineView
//@property (nonatomic) CGFloat progress;
//@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic, strong) NSArray *progressViews;
//@property (nonatomic, strong)  UIButton * searchBtn;
//
/////*
//// 字幕 音轨
//// */
////@property (nonatomic, strong) NSMutableArray *subAudioData;
////@property (strong,nonatomic)NSMutableDictionary * dicSubAudio;
//@end
//
//@implementation TVViewController
//
//@synthesize searchViewCon;
//@synthesize avController = _avController;   //搜索dms用
//@synthesize  serviceModel;
//@synthesize socketView;
//@synthesize monitorView;
//
//
//@synthesize activeView;
//@synthesize IPString;
//@synthesize topView;
//@synthesize categoryView;
////@synthesize videoPlay;
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    tableviewinit = 1;
//    IPString = @"";
//    playState = NO;
//    [self initData];    //table表
//    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
//    //打开时开始连接socket并且发送心跳
//    self.socketView  = [[SocketView  alloc]init];
//    [self.socketView viewDidLoad];
//    firstShow =NO;
////    statusNum = 1;
//    
//    
//    activeView = [[UIView alloc]initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
//                                                         SCREEN_WIDTH,
//                                                         SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)];
//    
//    
//    //    activeView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:activeView];    //等待loading的view
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.activeView];
//    
//    
//    //如果设置此属性则当前的view置于后台
//    
//    [HUD showAnimated:YES];
//    
//    
//    //设置对话框文字
//    
//    HUD.labelText = @"loading";
//    [self.activeView addSubview:HUD];
//    
//    //search数据的获取，只能执行一次，所以不能放到viewwillapper中
//    [self getSearchData];
//    
//    //    [self loadNav];
//    //    [self lineView];  //一条0.5pt的线
//    //    //new
//    //    [self initData];    //table表
//    //    //    [self loadUI];              //加载table 和scroll
//    //    //    [self getTopCategory];
//    //    [self getServiceData];    //获取表数据
//    //    [self initProgressLine];
//    //    [self getSearchData];
//    //
//    //
//    //    //修改tabbar选中的图片颜色和字体颜色
//    //    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    //    self.tabBarItem.selectedImage = image;
//    //    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
//    //
//    //    //视频部分
//    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    //
//    //    self.view.backgroundColor = [UIColor whiteColor];
//    //
//    //    [self playVideo];
//    //
//    //
//    //    self.edgesForExtendedLayout = UIRectEdgeNone;
//    //    self.extendedLayoutIncludesOpaqueBars =NO;
//    //    self.modalPresentationCapturesStatusBarAppearance =NO;
//    //    self.navigationController.navigationBar.translucent =NO;
//    //
//    //
//    //    //获取数据的链接
//    //    NSString *url = [NSString stringWithFormat:@"%@",S_category];
//    //
//    //
//    //    LBGetHttpRequest *request = CreateGetHTTP(url);
//    //
//    //
//    //
//    //    [request startAsynchronous];
//    //
//    //    WEAKGET
//    //    [request setCompletionBlock:^{
//    //        NSDictionary *response = httpRequest.responseString.JSONValue;
//    //
//    //
//    //        //        NSLog(@"response = %@",response);
//    //        NSArray *data = response[@"category"];
//    //
//    //        if (!isValidArray(data) || data.count == 0){
//    //            return ;
//    //        }
//    //        self.categorys = (NSMutableArray *)data;
//    //
//    //        //设置滑动条
//    //
//    //        _slideView = [[YLSlideView alloc]initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
//    //                                                                  SCREEN_WIDTH,
//    //                                                                  SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)
//    //                                             forTitles:self.categorys];
//    //
//    //
//    //        _slideView.backgroundColor = [UIColor whiteColor];
//    //        _slideView.delegate        = self;
//    //
//    //        [self.view addSubview:_slideView];
//    //
//    //
//    //
//    //    }];
//    //
//    
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    
//}
//-(void)getSearchData
//{
//    //    searchViewCon = [[SearchViewController alloc]init];
//    //    searchViewCon.tableView = [[UITableView alloc]init];
//    //    searchViewCon.dataList = [[NSMutableArray alloc]init];
//    searchViewCon.dataList =  [searchViewCon getServiceArray ];  //
//    searchViewCon.showData = [NSMutableArray arrayWithArray:searchViewCon.dataList];
//    [USER_DEFAULT setObject: searchViewCon.showData forKey:@"showData"];
//    
//     NSLog(@"searchViewCon.dataList: %@",searchViewCon.dataList);
//}
////1.line
//-(UIView *) lineView
//{
//    if (!_lineView){
//        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.5)];
//        _lineView.backgroundColor = lineBlackColor;
//        [self.view addSubview:_lineView];
//    }
//    return _lineView;
//}
//-(void) initData
//{
//    categoryView = [[CategoryViewController alloc]init];
//    monitorView = [[MonitorViewController alloc]init];
//    self.dicTemp = [[NSMutableDictionary alloc]init];
//    self.dataSource = [NSMutableArray array];
//    self.topProgressView = [[THProgressView alloc] init];
//    
//    //    topView = [[UIView alloc]init];
//    self.searchBtn = [[UIButton alloc]init];
//    //
//    searchViewCon = [[SearchViewController alloc]init];
//    searchViewCon.tableView = [[UITableView alloc]init];
//    searchViewCon.dataList = [[NSMutableArray alloc]init];
//    //
//    //    _slideView = [[YLSlideView alloc]initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
//    //                                                              SCREEN_WIDTH,
//    //                                                              SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)
//    //                                         forTitles:self.categorys];
//    //
//    
//    _slideView = [YLSlideView alloc];
//    
//}
//-(void)initProgressLine
//{
//    self.topProgressView.frame = CGRectMake(0  ,
//                                            VIDEOHEIGHT+kZXVideoPlayerOriginalHeight ,
//                                            SCREEN_WIDTH,
//                                            progressViewSize.height);
//    self.topProgressView.borderTintColor = [UIColor whiteColor];
//    self.topProgressView.progressTintColor = ProgressLineColor;
//    [self.view addSubview:self.topProgressView];
//    [self.view bringSubviewToFront:self.topProgressView];
//    
//    self.progressViews = @[ self.topProgressView ];
//    
//    
//    
//}
//
//
//- (void)updateProgress :(NSTimer *)Time
//{
//    int timeCut;
//    NSString *  starttime;
//    if(ISNULL([[Time userInfo] objectForKey:@"EndTime"]) || ISNULL([[Time userInfo]objectForKey:@"StarTime"]))
//    {
//        NSLog(@"结束时间或者开始时间不能为空");
//    }
//    else
//    {
//        timeCut= [[[Time userInfo] objectForKey:@"EndTime" ] intValue ] - [[[Time userInfo]objectForKey:@"StarTime"] intValue];
//        starttime =[[Time userInfo]objectForKey:@"StarTime"];
//    }
//    //算出时间间隔
//    //     = [[[Time userInfo] objectForKey:@"EndTime" ] intValue ] - [[[Time userInfo]objectForKey:@"StarTime"] intValue];
//    NSLog(@"timecut %d",timeCut);
//    //    NSString *  starttime =[[Time userInfo]objectForKey:@"StarTime"];
//    //    self.progress += 0.20f;
//    //每次移动的距离
//    self.progress = timeCut;
//    
//    
//    
//    [self.progressViews enumerateObjectsUsingBlock:^(THProgressView *progressView, NSUInteger idx, BOOL *stop) {
//        [USER_DEFAULT setObject:starttime forKey:@"StarTime"];
//        [progressView setProgress:self.progress animated:YES ];
//    }];
//}
//
////- (UIStatusBarStyle)preferredStatusBarStyle
////{
////    return UIStatusBarStyleLightContent;
////}
////-(void) loadUI
////{
//////    [self creatTopScroller];   //创建scroll
////}
//
////获取table
//-(void) getServiceData
//{
//    //获取数据的链接
//    NSString *url = [NSString stringWithFormat:@"%@",S_category];
//    
//    LBGetHttpRequest *request = CreateGetHTTP(url);
//    
//    
//    
//    [request startAsynchronous];
//    
//    WEAKGET
//    [request setCompletionBlock:^{
//        
//        
//        
//        NSDictionary *response = httpRequest.responseString.JSONValue;
//        
//        //将数据本地化
//        [USER_DEFAULT setObject:response forKey:@"TVHttpAllData"];
//        
//        //        NSLog(@"response = %@",response);
//        NSArray *data1 = response[@"service"];
//        if (!isValidArray(data1) || data1.count == 0){
//            [self getServiceData];
//            return ;
//        }
//        self.serviceData = (NSMutableArray *)data1;
//        
//        //        NSLog(@"--------%@",self.serviceData);
//        
//        
//        
//        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
//            [self getServiceData];
//        }
//        
//        [self.activeView removeFromSuperview];
//        self.activeView = nil;
//        
//        
//        //////
//        //获取数据的链接
//        NSString *urlCate = [NSString stringWithFormat:@"%@",S_category];
//        
//        
//        LBGetHttpRequest *request = CreateGetHTTP(urlCate);
//        
//        
//        
//        [request startAsynchronous];
//        
//        WEAKGET
//        [request setCompletionBlock:^{
//            NSDictionary *response = httpRequest.responseString.JSONValue;
//            
//            
//            //        NSLog(@"response = %@",response);
//            NSArray *data = response[@"category"];
//            
//            if (!isValidArray(data) || data.count == 0){
//                return ;
//            }
//            self.categorys = (NSMutableArray *)data;
//            
//            if (tableviewinit == 2) {
//                
//            
//            //设置滑动条
//            
//            _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
//                                                              SCREEN_WIDTH,
//                                                              SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
//            
//            NSArray *ArrayTocategory = [NSArray arrayWithArray:self.categorys];
//            [USER_DEFAULT setObject:ArrayTocategory forKey:@"categorysToCategoryView"];
//            
//            //            _slideView.frame =  [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
//            //                                                                    SCREEN_WIDTH,
//            //                                                                     SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
//            //            _slideView = [[YLSlideView alloc]initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
//            //                                                                      SCREEN_WIDTH,
//            //                                                                      SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)
//            //                                                 forTitles:self.categorys];
//            
//            
//            _slideView.backgroundColor = [UIColor whiteColor];
//            _slideView.delegate        = self;
//            
//            [self.view addSubview:_slideView];
//            }
//            else
//            {
//            
//            }
//            
//            
//        }];
//        
//        
//        [self initProgressLine];
////        [self getSearchData];
//        
//        
//        
//        [self.table reloadData];
//        
//    }];
//    
//}
//-(void)loadNav
//{
//    //顶部搜索条
//    self.navigationController.navigationBarHidden = YES;
//    //     topView.frame = CGRectMake(0, -30, SCREEN_WIDTH, topViewHeight);
//    //    topView.backgroundColor = [UIColor redColor];
//    //        [self.view addSubview:topView];
//    
//    //    self.navigationController.navigationBar.barTintColor = UIStatusBarStyleDefault;
//    
//    //搜索按钮
//    self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight);
//    //    [searchBtn setTitle:@"search" forState:UIControlStateNormal];
//    [self.searchBtn setBackgroundColor:[UIColor whiteColor]];
//    //    [searchBtn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
//    [self.searchBtn setBackgroundImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal]  ;
//    [self.view addSubview:self.searchBtn];
//    //    [topView bringSubviewToFront:self.searchBtn];
//    [self.searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//    //视频播放
//    //----直播源
//    self.video = [[ZXVideo alloc] init];
//    //    video.playUrl = @"http://baobab.wdjcdn.com/1451897812703c.mp4";
//    //  http://192.168.1.1/segment_delivery/delivery_0/play_tv2ip_0.m3u8
//    
//    
//    
//    //    self.video.title = [NSString stringWithFormat:@"%@  %@",self.service_videoindex ,self.service_videoname];
//    //    self.video.title = [self.service_videoindex stringByAppendingString:self.service_videoname];
//    
//    self.video.channelId = self.service_videoindex;
//    self.video.channelName = self.service_videoname;
//    
//    
//    
//    
//}
//
//- (void)playVideo
//{
//    if (!self.videoController) {
//        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, VIDEOHEIGHT, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight)];
//        
//        __weak typeof(self) weakSelf = self;
//        self.videoController.videoPlayerGoBackBlock = ^{
//            __strong typeof(self) strongSelf = weakSelf;
//            
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//            
//            [strongSelf.navigationController popViewControllerAnimated:YES];
//            [strongSelf.navigationController setNavigationBarHidden:NO animated:YES];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
//            
//            strongSelf.videoController = nil;
//        };
//        
//        self.videoController.videoPlayerWillChangeToOriginalScreenModeBlock = ^(){
//            NSLog(@"切换为竖屏模式");
//            //            //
//                        firstShow = YES;
//                    statusNum = 2;
//            [self setNeedsStatusBarAppearanceUpdate];
//                        [self prefersStatusBarHidden];
////            [self preferredStatusBarStyle];
//            //                [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
//            //
//            self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight);
//            
//            
//            //
//            self.topProgressView.hidden = NO;
//            float noewWidth = [UIScreen mainScreen].bounds.size.width;
//            
//            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",noewWidth],@"noewWidth",nil];
//            
//            //创建通知
//            NSNotification *notification =[NSNotification notificationWithName:@"fixTopBottomImage" object:nil userInfo:dict];
//            //通过通知中心发送通知
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//            
//            self.tabBarController.tabBar.hidden = NO;
//            _slideView.frame =CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
//                                         SCREEN_WIDTH,
//                                         SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5);
//            
//            self.topProgressView.frame = CGRectMake(0  ,
//                                                    VIDEOHEIGHT+kZXVideoPlayerOriginalHeight ,
//                                                    SCREEN_WIDTH,
//                                                    progressViewSize.height);
//            
//            
//              NSLog(@"return firstShow11:%d",firstShow);
//            
//        };
//        self.videoController.videoPlayerWillChangeToFullScreenModeBlock = ^(){
//            NSLog(@"切换为全屏模式");
//            //            //
////                        firstShow = NO;
////                        [self prefersStatusBarHidden];
//            //            prefersStatusBarHidden
////            firstShow = YES;
////            [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
////            self.tabBarController.tabBar.hidden = NO;
////            
////            
////            [self prefersStatusBarHidden];
//            
//            //
//            NSLog(@"123123123123123123123123----");
//            
//            self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY+1000, searchBtnWidth, searchBtnHeight);
//            
//            //
//            
//            //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//            //            [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
//            self.navigationController.navigationBar.translucent = NO;
//            self.extendedLayoutIncludesOpaqueBars
//            = NO;
//            
//            self.edgesForExtendedLayout =UIRectEdgeNone;
//            float noewWidth = [UIScreen mainScreen].bounds.size.width;
//            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",noewWidth],@"noewWidth",nil];
//            
//            
//            
//            //创建通知
//            NSNotification *notification =[NSNotification notificationWithName:@"fixTopBottomImage" object:nil userInfo:dict];
//            //通过通知中心发送通知
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//            
//            UIViewController * viewNow = [self currentViewController];
//            if ([viewNow isKindOfClass:[TVViewController class]]) {
//            self.tabBarController.tabBar.hidden = YES;
//            }
//            
//            
//            
//            self.view.frame = CGRectMake(0, 0, 800, 800);
//            _slideView.frame = CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
//                                          SCREEN_WIDTH,
//                                          SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5);
//            
//            NSLog(@"目前是全屏");
//            NSLog(@"目前是全屏sliderview:%f",_slideView.frame.origin.y);
//            
//            ////////****************** 进度条
//            //此处销毁通知，防止一个通知被多次调用   //5
//            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fixprogressView" object:nil ];
//            //注册通知
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fixprogressView :) name:@"fixprogressView" object:nil];
//            
//            self.topProgressView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -50 , [UIScreen mainScreen].bounds.size.width, 2);
//            
//            
//            
//            //            //此处销毁通知，*防止一个通知被多次调用
//            //    NSNotificationCenter a = [[NSNotificationCenter defaultCenter] removeObserver:self];
//            //            //注册通知
//            //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
//            
//            
//            
//            [self.view bringSubviewToFront:self.topProgressView];
//            [self.videoController.view bringSubviewToFront:self.topProgressView];
//            
//            //            [self setFullScreenView];
//            
//            NSLog(@"全屏宽 ： %f",[UIScreen mainScreen].bounds.size.width);
//            
//            
//            /////***** 用于设置sub字幕    和audio音轨
//            [self getsubt];
//            /////*****
//            //            /////***** 注册通知，勇于设置sub字幕和audio音轨
//            //            //此处销毁通知，防止一个通知被多次调用
//            //            [[NSNotificationCenter defaultCenter] removeObserver:self];
//            //            //注册通知
//            //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAndSetSubLanguage ) name:@"getAndSetSubLanguage" object:nil];
//            //
//            //            ////******
//        NSLog(@"return firstShow22:%d",firstShow);
//            firstShow = NO;
//            statusNum = 3;
////            [self setNeedsStatusBarAppearanceUpdate];
//            [self prefersStatusBarHidden];
//            [self setNeedsStatusBarAppearanceUpdate];
////            [self preferredStatusBarStyle];
//            NSLog(@"return firstShow22:%d",firstShow);
//        };
//        
//        NSLog(@"return firstShow:%d",firstShow);
//        
//        [self.videoController showInView:self.view];
//        self.navigationController.navigationBar.translucent = NO;
//        self.extendedLayoutIncludesOpaqueBars
//        = NO;
//        
//        self.edgesForExtendedLayout =UIRectEdgeNone;
//        
//        //        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
//    }
//    
//    
//    self.videoController.video = self.video;
//    
//}
////-(void)test
////{
////    [UIView animateWithDuration:0.3 animations:^{
////        self.topProgressView.hidden = YES;
////    }];
////    NSLog(@"teteteteeteteteteteetetetetetetetetetetetetetetetet");
////
////}
//
////-(void)setVideoProgress
////{
////    self.topProgressView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -50 , [UIScreen mainScreen].bounds.size.width, 2);
////
////
////    self.video.redview = [self duplicate:self.topProgressView];
////}
////- (THProgressView*)duplicate:(UIView*)view
////{
////    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
////    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
////}
//-(void)fixprogressView :(NSNotification *)text{
//    int show = [text.userInfo[@"boolBarShow"] intValue];
//    touchStatusNum = show;
//    if (show ==1) {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.topProgressView.hidden = YES;
//        }];
//        
//        [self prefersStatusBarHidden];
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             [self setNeedsStatusBarAppearanceUpdate];
//                         }];
//        
//    }
//    else{
//        [UIView animateWithDuration:0.3 animations:^{
//            self.topProgressView.hidden = NO;
//        }];
//        [self prefersStatusBarHidden];
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             [self setNeedsStatusBarAppearanceUpdate];
//                         }];
//    }
//    
//}
////-(void)setFullScreenView
////{
////    _fullScreenView = [[FullScreenView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
////    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
////    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
////    [self.view addSubview:_fullScreenView];
////}
//
////搜索按钮
//-(void)searchBtnClick
//{
//    //    searchViewCon = [[SearchViewController alloc]init];
//    //    searchViewCon.tableView = [[UITableView alloc]init];
//    //    searchViewCon.dataList = [[NSMutableArray alloc]init];
//    //    searchViewCon.dataList =  [searchViewCon getServiceArray ];
//    //    searchViewCon.showData = [NSMutableArray arrayWithArray:searchViewCon.dataList];
//    //     [USER_DEFAULT setObject: searchViewCon.showData forKey:@"showData"];
//    
//    [self.navigationController pushViewController:searchViewCon animated:YES];
//    searchViewCon.tabBarController.tabBar.hidden = YES;
//    NSLog(@"searchViewCon: %@,",searchViewCon);
//    //
//    //    //停止播放
//    //    [self.socketView  deliveryPlayExit];
//    
//    ////    密码校验
//    //     [self.socketView passwordCheck];
//    
//    //    //获取分发资源信息
//    //    [self.socketView csGetResource];
//    
//    
//    
//}
//
////************************************************
////table可以滑动的次数
//- (NSInteger)columnNumber{
//    //   return colors.count;
//    return self.categorys.count;
//}
//
//- (TVTable *)slideView:(YLSlideView *)slideView
//     cellForRowAtIndex:(NSUInteger)index{
//    
//    
//    TVTable * cell = [slideView dequeueReusableCell];
//    
//    if (!cell) {
//        cell = [[TVTable alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT -_slideView.frame.origin.y-49.5)
//                                       style:UITableViewStylePlain];
//        cell.delegate   = self;
//        cell.dataSource = self;
//    }
//    
//    //    cell.backgroundColor = colors[index];
//    //     NSLog(@"index --------:%@ ",@(index));
//    return cell;
//}
//- (void)slideVisibleView:(TVTable *)cell forIndex:(NSUInteger)index{
//    
//    NSLog(@"index :%@ ",@(index));
//    
//    cell.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    //self.categorys[i]                          不同类别
//    //self.categoryModel.service_indexArr        类别的索引数组
//    //self.categoryModel.service_indexArr.count
//    //给不同的table赋值
//    //    for (int i = 0 ; i<self.categorys.count; i++) {
//    NSDictionary *item = self.categorys[index];   //当前页面类别下的信息
//    self.categoryModel = [[CategoryModel alloc]init];
//    
//    self.categoryModel.service_indexArr = item[@"service_index"];   //当前类别下包含的节目索引  0--9
//    
//    //获取EPG信息 展示
//    //时间戳转换
//    
//    //获取不同类别下的节目，然后是节目下不同的cell值                10
//    for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {
//        
//        int indexCat ;
//        //   NSString * str;
//        indexCat =[self.categoryModel.service_indexArr[i] intValue];
//        //cell.tabledataDic = self.serviceData[indexCat -1];
//        
//        
//        //此处判断是否为空，防止出错
//        if ( ISNULL(self.serviceData)) {
//            
//        }else{
//            [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
//            
//        }
//        
//        
//    }
//    //        cell.tabledataDic =  self.categorys[index];
//    //    }
//    
//    //    self.a = index;
//    //    NSLog(@"index  self.a--------:%@ ",@(index));
//    [cell reloadData]; //刷新TableView
//    //    NSLog(@"刷新数据");
//}
//
//- (void)slideViewInitiatedComplete:(TVTable *)cell forIndex:(NSUInteger)index{
//    
//    //可以在这里做数据的预加载（缓存数据）
//    NSLog(@"缓存数据 %@",@(index));
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [cell reloadData];
//        
//    });
//}
//
//#pragma mark UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"%lu",(unsigned long)self.serviceData.count);
//    
//    return self.categoryModel.service_indexArr.count;
//    
//}
//-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [TVCell defaultCellHeight];
//}
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//     tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    
//    TVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TVCell"];
//    if (cell == nil){
//        cell = [TVCell loadFromNib];
//        
//        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        cell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
//    }
//    
//    
//    //
//    //    TVTable * table = [[TVTable alloc]init];
//    //    cell.dataDic = table.tabledataDic;
//    
//    
//    //    cell.aa =  self.category_index;
//    //    cell.aaa =self.categoryModel.service_indexArr.count;
//    //    NSLog(@"index  cell.aaa--------:%d",cell.aaa);
//    
//    if (!ISEMPTY(self.dicTemp)) {
//        cell.dataDic = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
//    }else{//如果为空，什么都不执行
//    }
//    
//    NSLog(@"cell.dataDic:%@",cell.dataDic);
//    
//    return cell;
//    
//}
//
//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //    DetailViewController *controller =[[DetailViewController alloc] init];
//    //    controller.dataDic = self.dataSource[indexPath.row];
//    //    [self.navigationController pushViewController:controller animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self touchSelectChannel:indexPath.row diction:self.dicTemp];
//    //    //先传输数据到socket，然后再播放视频
//    //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
//    //
//    //
//    //    //__
//    //
//    //    NSArray * audio_infoArr = [[NSArray alloc]init];
//    //    NSArray * subt_infoArr = [[NSArray alloc]init];
//    //
//    //    NSArray * epg_infoArr = [[NSArray alloc]init];
//    //    //****
//    //
//    //
//    //    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
//    //    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
//    //    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
//    //    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
//    //    socketView.socket_ServiceModel.subt_pid = [audio_infoArr[0] objectForKey:@"subt_pid"];
//    //    socketView.socket_ServiceModel.service_network_id = [epgDicToSocket objectForKey:@"service_network_id"];
//    //    socketView.socket_ServiceModel.service_ts_id =[epgDicToSocket objectForKey:@"service_ts_id"];
//    //    socketView.socket_ServiceModel.service_tuner_mode = [epgDicToSocket objectForKey:@"service_tuner_mode"];
//    //    socketView.socket_ServiceModel.service_service_id = [epgDicToSocket objectForKey:@"service_service_id"];
//    //
//    //    //********
//    //    self.service_videoindex = [epgDicToSocket objectForKey:@"service_logic_number"];
//    //    if(self.service_videoindex.length == 1)
//    //    {
//    //        self.service_videoindex = [NSString stringWithFormat:@"00%@",self.service_videoindex];
//    //    }
//    //    else if (self.service_videoindex.length == 2)
//    //    {
//    //        self.service_videoindex = [NSString stringWithFormat:@"0%@",self.service_videoindex];
//    //    }
//    //    else if (self.service_videoindex.length == 3)
//    //    {
//    //        self.service_videoindex = [NSString stringWithFormat:@"%@",self.service_videoindex];
//    //    }
//    //    else if (self.service_videoindex.length > 3)
//    //    {
//    //     self.service_videoindex = [self.service_videoindex substringFromIndex:self.service_videoindex.length - 3];
//    //    }
//    //
//    //    self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
//    //    epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
//    //    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
//    //    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
//    //    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
//    //    self.TVSubAudioDic = [[NSDictionary alloc]init];
//    //    self.TVSubAudioDic = epgDicToSocket;
//    //    self.TVChannlDic = [[NSDictionary alloc]init];
//    //    self.TVChannlDic = self.dicTemp;
//    //    NSLog(@"eventname :%@",self.event_startTime);
//    //    //*********
//    //
//    //
//    //
//    //
//    //    if (ISEMPTY(socketView.socket_ServiceModel.audio_pid)) {
//    //        socketView.socket_ServiceModel.audio_pid = @"0";
//    //    }else if (ISEMPTY(socketView.socket_ServiceModel.subt_pid)){
//    //        socketView.socket_ServiceModel.subt_pid = @"0";
//    //    }else if (ISEMPTY(socketView.socket_ServiceModel.service_network_id)){
//    //        socketView.socket_ServiceModel.service_network_id = @"0";
//    //    }else if (ISEMPTY(socketView.socket_ServiceModel.service_ts_id)){
//    //        socketView.socket_ServiceModel.service_ts_id = @"0";
//    //    }else if (ISEMPTY(socketView.socket_ServiceModel.service_tuner_mode)){
//    //        socketView.socket_ServiceModel.service_tuner_mode = @"0";
//    //    }else if (ISEMPTY(socketView.socket_ServiceModel.service_service_id)){
//    //        socketView.socket_ServiceModel.service_service_id = @"0";
//    //    }
//    //
//    //    NSLog(@"------%@",socketView.socket_ServiceModel);
//    //
//    //
//    //
//    //    //此处销毁通知，防止一个通知被多次调用
//    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    //    //注册通知
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
//    //
//    //    [self.socketView  serviceTouch ];
//    //
//    
//    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//    
//}
//
//- (void)getDataService:(NSNotification *)text{
//    NSLog(@"%@",text.userInfo[@"playdata"]);
//    NSLog(@"－－－－－接收到通知------");
//    
//    //NSData --->byte[]-------NSData----->NSString
//    
//    
//    _byteDatas = [[NSMutableData alloc]init];
//    
//    //此处加入判断语句，判断返回的结果RET是否满足几个报错信息
//    NSData * retData = [[NSData alloc]init];
//    retData = [[USER_DEFAULT objectForKey:@"data_service11"] subdataWithRange:NSMakeRange(12, 4)];
//    NSLog(@"retData : %@",retData);
//    
//    int value = CFSwapInt32BigToHost(*(int*)([retData bytes]));
//    NSLog(@"value : %d",value);
//    //通过获得data数据减去发送的data数据得到播放连接，一下是返回数据的ret，如果ret不等于0则报错
//    [self  getLinkData :value];
//    //    //调用GGutil的方法
//    //    byteDatas =  [GGUtil convertNSDataToByte:[USER_DEFAULT objectForKey:@"data_service"] bData:[USER_DEFAULT objectForKey:@"data_service11"]];
//    //
//    
//    NSLog(@"---urlData%@",_byteDatas);
//    
////    self.video.playUrl = [@"h"stringByAppendingString:[[NSString alloc] initWithData:_byteDatas encoding:NSUTF8StringEncoding]];
//        self.video.playUrl = [[NSString alloc] initWithData:_byteDatas encoding:NSUTF8StringEncoding];
//    
//    //    self.video.title = [self.service_videoindex stringByAppendingString:self.service_videoname];
//    
//    
//    self.video.channelId = self.service_videoindex;
//    self.video.channelName = self.service_videoname;
//    
//    
//    self.video.playEventName = self.event_videoname;
//    self.video.startTime = self.event_startTime;
//    self.video.endTime = self.event_endTime;
//    //    self.video.dicSubAudio = self.TVSubAudioDic;
//    
//    [self setStateNonatic];
//    [self playVideo];
//    
//    playState = NO;
//    if (! playState ) {
//        timerState =   [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playClick) userInfo:nil repeats:YES];
//    }
//    
//    
//    
//    //** 计算进度条
//    if(!ISNULL(self.event_startTime)&&!ISNULL(self.event_endTime))
//    {
//        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
//        if (ISNULL(self.event_startTime) || self.event_startTime == NULL || self.event_startTime == nil) {
//          
//        }else
//        {
//            NSLog(@"此处可能报错，因为StarTime不为空 ");
//        [dict setObject:self.event_startTime forKey:@"StarTime"];
//        }
//        if (ISNULL(self.event_startTime) || self.event_startTime == NULL || self.event_startTime == nil) {
//            
//        }else
//        {
//            NSLog(@"此处可能报错，因为StarTime不为空 ");
//            [dict setObject:self.event_endTime forKey:@"EndTime"];
//        }
//        
//        
//        //        NSLog(@"dict.start :%@",[dict objectForKey:@"StarTime"]);
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress:) userInfo:dict repeats:YES];
//    }
//    //**
//    NSLog(@"---urlData%@",self.video.playUrl);
//    
//    
//    NSString * str = [NSString stringWithFormat:@"%@",self.video.playUrl];
//    
//    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"data信息"message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertview show];
//    
//    
//}
////-(void)getAndSetSubLanguage {
////
////    self.dicSubAudio = [[NSMutableDictionary alloc]init];
////    self.subAudioData = [NSMutableArray array];
////
////    subAudiorightCell * subAudiocell =  [tableView dequeueReusableCellWithIdentifier:@"TVCell"];
////    if (cell == nil){
////        cell = [TVCell loadFromNib];
////    }
////}
//-(void)getsubt
//{
//    //    NSDictionary * epgDictionary = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
//    //
//    //
//    //    //__
//    //
//    //    NSArray * audio_infoArr = [[NSArray alloc]init];
//    //    NSArray * subt_infoArr = [[NSArray alloc]init];
//    //
//    //    NSArray * epg_infoArr = [[NSArray alloc]init];
//    //    //****
//    //
//    //
//    //    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
//    //    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
//    //    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
//    //    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
//    //    socketView.socket_ServiceModel.subt_pid = [audio_infoArr[0] objectForKey:@"subt_pid"];
//    /////****
//    //此处循环给赋值
//    
//    self.video.dicSubAudio = self.TVSubAudioDic;
//    
//    self.video.dicChannl = self.TVChannlDic;
//    
//    self.video.channelCount = self.categoryModel.service_indexArr.count;
//}
//
////row 代表是service的每个类别下的序列是几，dic代表每个类别下的service
//-(void)touchSelectChannel :(NSInteger)row diction :(NSDictionary *)dic
//{
//    NSLog(@"self.socket:%@",self.socketView);
//    
//    //先传输数据到socket，然后再播放视频
//    //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",row]];
//    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
//    
//    NSLog(@"dic: %@",dic);
//    
//    NSLog(@"row: %ld",(long)row);
//    /*此处添加一个加入历史版本的函数*/
//    [self addHistory:row diction:dic];
//    
//    //__
//    
//    NSArray * audio_infoArr = [[NSArray alloc]init];
//    NSArray * subt_infoArr = [[NSArray alloc]init];
//    
//    NSArray * epg_infoArr = [[NSArray alloc]init];
//    //****
//    
//    
//    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
//    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
//    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
//    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
//    socketView.socket_ServiceModel.subt_pid = [audio_infoArr[0] objectForKey:@"subt_pid"];
//    socketView.socket_ServiceModel.service_network_id = [epgDicToSocket objectForKey:@"service_network_id"];
//    socketView.socket_ServiceModel.service_ts_id =[epgDicToSocket objectForKey:@"service_ts_id"];
//    socketView.socket_ServiceModel.service_tuner_mode = [epgDicToSocket objectForKey:@"service_tuner_mode"];
//    socketView.socket_ServiceModel.service_service_id = [epgDicToSocket objectForKey:@"service_service_id"];
//    
//    //********
//    self.service_videoindex = [epgDicToSocket objectForKey:@"service_logic_number"];
//    if(self.service_videoindex.length == 1)
//    {
//        self.service_videoindex = [ NSString stringWithFormat:@"00%@",self.service_videoindex];
//    }
//    else if (self.service_videoindex.length == 2)
//    {
//        self.service_videoindex = [NSString stringWithFormat:@"0%@",self.service_videoindex];
//    }
//    else if (self.service_videoindex.length == 3)
//    {
//        self.service_videoindex = [NSString stringWithFormat:@"%@",self.service_videoindex];
//    }
//    else if (self.service_videoindex.length > 3)
//    {
//        self.service_videoindex = [self.service_videoindex substringFromIndex:self.service_videoindex.length - 3];
//    }
//    
//    self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
//    epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
//    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
//    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
//    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
//    self.TVSubAudioDic = [[NSDictionary alloc]init];
//    self.TVSubAudioDic = epgDicToSocket;
//    self.TVChannlDic = [[NSDictionary alloc]init];
//    self.TVChannlDic = self.dicTemp;
//    NSLog(@"eventname :%@",self.event_startTime);
//    //*********
//    
//    
//    
//    
//    if (ISEMPTY(socketView.socket_ServiceModel.audio_pid)) {
//        socketView.socket_ServiceModel.audio_pid = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.subt_pid)){
//        socketView.socket_ServiceModel.subt_pid = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.service_network_id)){
//        socketView.socket_ServiceModel.service_network_id = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.service_ts_id)){
//        socketView.socket_ServiceModel.service_ts_id = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.service_tuner_mode)){
//        socketView.socket_ServiceModel.service_tuner_mode = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.service_service_id)){
//        socketView.socket_ServiceModel.service_service_id = @"0";
//    }
//    
//    NSLog(@"------%@",socketView.socket_ServiceModel);
//    
//    
//    
//    //此处销毁通知，防止一个通知被多次调用    // 1
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
//    
//    
//    //    self.socketView  = [[SocketView  alloc]init];
//    //    [self.socketView viewDidLoad];
//    
//    NSLog(@"self.socket:%@",self.socketView);
//    
//    self.videoController.socketView1 = self.socketView;
//    [self.socketView  serviceTouch ];
//    
//    
//}
//
////-(void)touchSearchData :(NSInteger)row diction :(NSDictionary *)dic
////{
////    //先传输数据到socket，然后再播放视频
////    //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",row]];
////    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%d",row]];
////
////    //__
////
////    NSArray * audio_infoArr = [[NSArray alloc]init];
////    NSArray * subt_infoArr = [[NSArray alloc]init];
////
////    NSArray * epg_infoArr = [[NSArray alloc]init];
////    //****
////
////
////    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
////    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
////    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
////    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
////    socketView.socket_ServiceModel.subt_pid = [audio_infoArr[0] objectForKey:@"subt_pid"];
////    socketView.socket_ServiceModel.service_network_id = [epgDicToSocket objectForKey:@"service_network_id"];
////    socketView.socket_ServiceModel.service_ts_id =[epgDicToSocket objectForKey:@"service_ts_id"];
////    socketView.socket_ServiceModel.service_tuner_mode = [epgDicToSocket objectForKey:@"service_tuner_mode"];
////    socketView.socket_ServiceModel.service_service_id = [epgDicToSocket objectForKey:@"service_service_id"];
////
////    //********
////    self.service_videoindex = [epgDicToSocket objectForKey:@"service_logic_number"];
////    if(self.service_videoindex.length == 1)
////    {
////        self.service_videoindex = [NSString stringWithFormat:@"00%@",self.service_videoindex];
////    }
////    else if (self.service_videoindex.length == 2)
////    {
////        self.service_videoindex = [NSString stringWithFormat:@"0%@",self.service_videoindex];
////    }
////    else if (self.service_videoindex.length == 3)
////    {
////        self.service_videoindex = [NSString stringWithFormat:@"%@",self.service_videoindex];
////    }
////    else if (self.service_videoindex.length > 3)
////    {
////        self.service_videoindex = [self.service_videoindex substringFromIndex:self.service_videoindex.length - 3];
////    }
////
////    self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
////    epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
////    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
////    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
////    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
////    self.TVSubAudioDic = [[NSDictionary alloc]init];
////    self.TVSubAudioDic = epgDicToSocket;
////    self.TVChannlDic = [[NSDictionary alloc]init];
////    self.TVChannlDic = self.dicTemp;
////    NSLog(@"eventname :%@",self.event_startTime);
////    //*********
////
////
////
////
////    if (ISEMPTY(socketView.socket_ServiceModel.audio_pid)) {
////        socketView.socket_ServiceModel.audio_pid = @"0";
////    }else if (ISEMPTY(socketView.socket_ServiceModel.subt_pid)){
////        socketView.socket_ServiceModel.subt_pid = @"0";
////    }else if (ISEMPTY(socketView.socket_ServiceModel.service_network_id)){
////        socketView.socket_ServiceModel.service_network_id = @"0";
////    }else if (ISEMPTY(socketView.socket_ServiceModel.service_ts_id)){
////        socketView.socket_ServiceModel.service_ts_id = @"0";
////    }else if (ISEMPTY(socketView.socket_ServiceModel.service_tuner_mode)){
////        socketView.socket_ServiceModel.service_tuner_mode = @"0";
////    }else if (ISEMPTY(socketView.socket_ServiceModel.service_service_id)){
////        socketView.socket_ServiceModel.service_service_id = @"0";
////    }
////
////    NSLog(@"------%@",socketView.socket_ServiceModel);
////
////
////
////    //此处销毁通知，防止一个通知被多次调用
////    [[NSNotificationCenter defaultCenter] removeObserver:self];
////    //注册通知
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
////
////
////    self.videoController.socketView1 = self.socketView;
////    [self.socketView  serviceTouch ];
////
////
////}
//-(void)getLinkData : (int )val
//{
//    if (val == 0)  {
//        //调用GGutil的方法
//        NSLog(@"返回数据正常");
//        _byteDatas =  [GGUtil convertNSDataToByte:[USER_DEFAULT objectForKey:@"data_service"] bData:[USER_DEFAULT objectForKey:@"data_service11"]];
//    }
//    else if(val == 1)
//    {
//        NSLog(@"CRC 错误");
//    }
//    else if(val == 2)
//    {
//        NSLog(@"通知事件");
//    }
//    else if(val == 3)
//    {
//        NSLog(@"资源连接");
//    }
//    else if(val == 4)
//    {
//        NSLog(@"播放错误"); //可能没插信号线
//    }
//    else if(val == 5)
//    {
//        NSLog(@"密码正确");
//    }
//    else if(val == 6)
//    {
//        NSLog(@"密码错误");
//    }
//    else if(val == 7)
//    {
//        NSLog(@"停止错误");
//    }
//    else if(val == 8)
//    {
//        NSLog(@"得到资源错误");
//    }
//    else if(val == 9)
//    {
//        NSLog(@"服务器停止分发");
//    }
//    else if(val == 10)
//    {
//        NSLog(@"无效");
//    }
//}
//
//-(void)addHistory:(NSInteger)row diction :(NSDictionary *)dic
//{
//    //将当前观看的节目本地化，以便在其他地方可以取到数据
//    NSNumber * rowNow = [NSNumber numberWithInteger:row];
//    NSArray * arrSedNow = [NSArray arrayWithObjects:rowNow,dic, nil];
//     [USER_DEFAULT setObject:arrSedNow forKey:@"ChannelNow"];
//    
// 
//    
//    // 1.获得点击的视频dictionary数据
//    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%d",row]];
//    // 2. 初始化两个数组存放数据
//    //     NSArray * historyArr = [[NSArray alloc]init];
//    NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
//    //3.获得以前的点击数据
//    mutaArray = [[USER_DEFAULT objectForKey:@"historySeed"]mutableCopy];
//    
//    //4.将点击的数据加入可变数组
//    //此处进行判断看新添加的节目是否曾经添加过
//    BOOL addNewData = YES;
//    //    if (mutaArray.count == 0) {
//    //         [mutaArray addObject:epgDicToSocket];
//    //    }
//    //    else{
//    for (int i = 0; i <mutaArray.count ; i++) {
//        //原始数据
//        NSString * service_network =  [mutaArray[i][0] objectForKey:@"service_network_id"];
//        NSString * service_ts =  [mutaArray[i][0] objectForKey:@"service_ts_id"];
//        NSString * service_service =  [mutaArray[i][0] objectForKey:@"service_service_id"];
//        NSString * service_tuner =  [mutaArray[i][0] objectForKey:@"service_tuner_mode"];
//        
//        //新添加的数据
//        NSString * newservice_network =  [epgDicToSocket objectForKey:@"service_network_id"];
//        NSString * newservice_ts =  [epgDicToSocket objectForKey:@"service_ts_id"];
//        NSString * newservice_service =  [epgDicToSocket objectForKey:@"service_service_id"];
//        NSString * newservice_tuner =  [epgDicToSocket objectForKey:@"service_tuner_mode"];
//        
//        if ([service_network isEqualToString:newservice_network] && [service_ts isEqualToString:newservice_ts] && [service_tuner isEqualToString:newservice_tuner] && [service_service isEqualToString:newservice_service]) {
//            addNewData = NO;
//            
//            NSArray * equalArr = mutaArray[i];
//            
//            [mutaArray removeObjectAtIndex:i];
//            [mutaArray  addObject:equalArr];
//            
//            break;
//        }
//        
//        
//    }
//    //    }
//    if (addNewData == YES) {
//        NSString * seedNowTime = [GGUtil GetNowTimeString];
//        NSNumber *aNumber = [NSNumber numberWithInteger:row];
//        NSArray * seedNowArr = [NSArray arrayWithObjects:epgDicToSocket,seedNowTime,aNumber,dic,nil];
//        
//        
//        if (seedNowArr.count > 0) {
//            [mutaArray addObject:seedNowArr];
//            
//        }else
//        {
//            NSAssert(seedNowArr != NULL, @"提示: 此时seedNowArr.count < 0,证明其为空");
//        }
//        
//        
//        //     [mutaArray addObject:epgDicToSocket];
//    }
//    
//    
//    
//    //5。两个数组相加
//    //    [ mutaArray addObject:historyArr];
//    NSArray *myArray = [NSArray arrayWithArray:mutaArray];
//    [USER_DEFAULT setObject:myArray forKey:@"historySeed"];
//    
//    
//    //    NSLog(@"myarray:%@",myArray[3]);
//    //    NSLog(@"myarray:%@",myArray[2]);
//    //    NSLog(@"myarray:%@",myArray[2][0]);
//    
//    MEViewController * meview = [[MEViewController alloc]init];
//    [meview viewDidAppear:YES];
//    [meview viewDidLoad];
//    
//}
////引导页
//- (void)viewWillAppear:(BOOL)animated{
//    
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
//        NSLog(@"第一次启动");
//        self.tabBarController.tabBar.hidden = YES;
//        firstShow = NO;
//        statusNum = 0;
//        [self prefersStatusBarHidden];
////        [self preferredStatusBarStyle];
//        
//        [self addGuideView]; //添加引导图
//        
//    }else{
//        NSLog(@"不是第一次启动");
//          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
//        
//        tableviewinit  = tableviewinit +1;
//        firstShow = YES;
//        statusNum = 1;
////        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
//        self.tabBarController.tabBar.hidden = NO;
//        
//        
//        [self prefersStatusBarHidden];
////        [self preferredStatusBarStyle];
//        
//        
//        
//        
//        //        [self viewDidLoad];
//        
//        //new
//        //        [self initData];    //table表
//        [self loadNav];
//        [self lineView];  //一条0.5pt的线
//        //    [self loadUI];              //加载table 和scroll
//        //    [self getTopCategory];
//        [self getServiceData];    //获取表数据
//        //        [self initProgressLine];
//        //        [self getSearchData];
//        [self setIPNoific];
//        [self setVideoTouchNoific];
//        [self newTunerNotific]; //新建一个tuner的通知
//        [self deleteTunerInfoNotific]; //新建一个删除tuner的通知
//        [self allCategorysBtnNotific];
//        [self fullScreenStatusNotific];
//        //修改tabbar选中的图片颜色和字体颜色
//        UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        self.tabBarItem.selectedImage = image;
//        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
//        
//        //视频部分
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        
//        self.view.backgroundColor = [UIColor whiteColor];
//        
//        [self playVideo];
//        
//        
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars =NO;
//        self.modalPresentationCapturesStatusBarAppearance =NO;
//        self.navigationController.navigationBar.translucent =NO;
//        
//        
//        
//    }
//    
//    NSLog(@"目前是sliderview:%f",_slideView.frame.origin.y);
//}
//- (void)addGuideView {
//    
//    NSMutableArray *paths = [NSMutableArray new];
//    
//    [paths addObject:[[NSBundle mainBundle] pathForResource:@"引导页1" ofType:@"png"]];
//    [paths addObject:[[NSBundle mainBundle] pathForResource:@"引导页2" ofType:@"png"]];
//    [paths addObject:[[NSBundle mainBundle] pathForResource:@"引导页3" ofType:@"png"]];
//    [paths addObject:[[NSBundle mainBundle] pathForResource:@"引导页4" ofType:@"png"]];
//    
//    [[KSGuideManager shared] showGuideViewWithImages:paths];
//    
//    //2
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"enterTVView" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterTVView) name:@"enterTVView" object:nil];
//    
//    
//}
//
//
////从第一次启动的引导页进入首页
//-(void)enterTVView
//{
//    
//    
//    [self viewWillAppear:YES];
//}
//
//
//-(void)newTunerNotific
//{
//    //新建一个发送tuner请求并且接受返回信息的通知   //3
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tunerRevice" object:nil] ;
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTunerInfo) name:@"tunerRevice" object:nil];
//    
//    
//    
//}
//-(void)deleteTunerInfoNotific
//{
//    //新建一个发送tuner删除直播消息的通知   //4
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteTuner" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delegeTunerInfo) name:@"deleteTuner" object:nil];
//    
//}
//
//
//-(void)allCategorysBtnNotific
//{
//    //新建一个发送tuner删除直播消息的通知   //4
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"allCategorysBtnNotific" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allCategorysBtnClick) name:@"allCategorysBtnNotific" object:nil];
//    
//}
//-(void)allCategorysBtnClick
//{
//    NSLog(@"点击分类了2");
//    
//    categoryView = [[CategoryViewController alloc]init];
//    [self.navigationController pushViewController:categoryView animated:YES];
//    
//    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
//    self.categoryView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
//    self.categoryView.navigationItem.leftBarButtonItem = myButton;
//}
//-(void)clickEvent
//{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    self.tabBarController.tabBar.hidden = NO;
//}
//
//-(void)receiveTunerInfo
//{
//    //获取分发资源信息
//    [self.socketView csGetResource];
//}
//-(void)delegeTunerInfo
//{
//    //停止播放，视频分发
//    [self.socketView  deliveryPlayExit];
//}
//-(void)setIPNoific
//{
//    
//    //新建一个发送IP 改变的消息的通知   //
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IPHasChanged" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IPHasChanged) name:@"IPHasChanged" object:nil];
//    
//}
//-(void)setVideoTouchNoific
//{
//    
//    //新建一个发送IP 改变的消息的通知   //
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VideoTouchNoific" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoTouchNoificClick :) name:@"VideoTouchNoific" object:nil];
//    
//}
//-(void)IPHasChanged
//{
//    NSLog(@"执行方法");
//    [self getServiceData];
//}
//-(void)setStateNonatic
//{
//    //新建一个发送播放通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MPMediaPlaybackIsPreparedToPlayDidChangeNotification" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willplay) name:@"MPMediaPlaybackIsPreparedToPlayDidChangeNotification" object:nil];
//}
//-(void)playClick
//{
//    NSLog(@"playState:%d",playState);
//    NSLog(@"(self.video.playUrl:%@",self.video.playUrl);
//    if ( self.video.playUrl != NULL && ! playState) {
//        [self playVideo];
//        
//        NSLog(@"播放");
//    }
//    else
//    {
//        [timerState invalidate];
//        timerState = nil;
//        
//    }
//}
//-(void)willplay
//{
//    
//    playState = YES;
//}
///////////////其他页面的播放通知事件
////row 代表是service的每个类别下的序列是几，dic代表每个类别下的service
//-(void)VideoTouchNoificClick : (NSNotification *)text//(NSInteger)row diction :(NSDictionary *)dic  //:(NSNotification *)text{
//{
//    
//    NSInteger row = [text.userInfo[@"textOne"]integerValue];
//    NSDictionary * dic = [[NSDictionary alloc]init];
//    dic = text.userInfo[@"textTwo"];
//    
//    NSLog(@"self.socket:%@",self.socketView);
//    
//    //先传输数据到socket，然后再播放视频
//    //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",row]];
//    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
//    
//    NSLog(@"dic: %@",dic);
//    
//    NSLog(@"row: %ld",(long)row);
//    /*此处添加一个加入历史版本的函数*/
//    [self addHistory:row diction:dic];
//    
//    //__
//    
//    NSArray * audio_infoArr = [[NSArray alloc]init];
//    NSArray * subt_infoArr = [[NSArray alloc]init];
//    
//    NSArray * epg_infoArr = [[NSArray alloc]init];
//    //****
//    
//    
//    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
//    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
//    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
//    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
//    socketView.socket_ServiceModel.subt_pid = [audio_infoArr[0] objectForKey:@"subt_pid"];
//    socketView.socket_ServiceModel.service_network_id = [epgDicToSocket objectForKey:@"service_network_id"];
//    socketView.socket_ServiceModel.service_ts_id =[epgDicToSocket objectForKey:@"service_ts_id"];
//    socketView.socket_ServiceModel.service_tuner_mode = [epgDicToSocket objectForKey:@"service_tuner_mode"];
//    socketView.socket_ServiceModel.service_service_id = [epgDicToSocket objectForKey:@"service_service_id"];
//    
//    //********
//    self.service_videoindex = [epgDicToSocket objectForKey:@"service_logic_number"];
//    if(self.service_videoindex.length == 1)
//    {
//        self.service_videoindex = [ NSString stringWithFormat:@"00%@",self.service_videoindex];
//    }
//    else if (self.service_videoindex.length == 2)
//    {
//        self.service_videoindex = [NSString stringWithFormat:@"0%@",self.service_videoindex];
//    }
//    else if (self.service_videoindex.length == 3)
//    {
//        self.service_videoindex = [NSString stringWithFormat:@"%@",self.service_videoindex];
//    }
//    else if (self.service_videoindex.length > 3)
//    {
//        self.service_videoindex = [self.service_videoindex substringFromIndex:self.service_videoindex.length - 3];
//    }
//    
//    self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
//    epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
//    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
//    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
//    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
//    self.TVSubAudioDic = [[NSDictionary alloc]init];
//    self.TVSubAudioDic = epgDicToSocket;
//    self.TVChannlDic = [[NSDictionary alloc]init];
//    self.TVChannlDic = self.dicTemp;
//    NSLog(@"eventname :%@",self.event_startTime);
//    //*********
//    
//    
//    
//    
//    if (ISEMPTY(socketView.socket_ServiceModel.audio_pid)) {
//        socketView.socket_ServiceModel.audio_pid = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.subt_pid)){
//        socketView.socket_ServiceModel.subt_pid = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.service_network_id)){
//        socketView.socket_ServiceModel.service_network_id = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.service_ts_id)){
//        socketView.socket_ServiceModel.service_ts_id = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.service_tuner_mode)){
//        socketView.socket_ServiceModel.service_tuner_mode = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.service_service_id)){
//        socketView.socket_ServiceModel.service_service_id = @"0";
//    }
//    
//    NSLog(@"------%@",socketView.socket_ServiceModel);
//    
//    
//    
//    //此处销毁通知，防止一个通知被多次调用    // 1
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
//    
//    
//    //    self.socketView  = [[SocketView  alloc]init];
//    //    [self.socketView viewDidLoad];
//    
//    NSLog(@"self.socket:%@",self.socketView);
//    
//    self.videoController.socketView1 = self.socketView;
//    [self.socketView  serviceTouch ];
//    
//    
//}
//
//-(UIViewController*) findBestViewController:(UIViewController*)vc {
//    
//    if (vc.presentedViewController) {
//        
//        // Return presented view controller
//        return [self findBestViewController:vc.presentedViewController];
//        
//    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
//        
//        // Return right hand side
//        UISplitViewController* svc = (UISplitViewController*) vc;
//        if (svc.viewControllers.count > 0)
//            return [self findBestViewController:svc.viewControllers.lastObject];
//        else
//            return vc;
//        
//    } else if ([vc isKindOfClass:[UINavigationController class]]) {
//        
//        // Return top view
//        UINavigationController* svc = (UINavigationController*) vc;
//        if (svc.viewControllers.count > 0)
//            return [self findBestViewController:svc.topViewController];
//        else
//            return vc;
//        
//    } else if ([vc isKindOfClass:[UITabBarController class]]) {
//        
//        // Return visible view
//        UITabBarController* svc = (UITabBarController*) vc;
//        if (svc.viewControllers.count > 0)
//            return [self findBestViewController:svc.selectedViewController];
//        else
//            return vc;
//        
//    } else {
//        
//        // Unknown view controller type, return last child view controller
//        return vc;
//        
//    }
//    
//}
//
//-(UIViewController*) currentViewController {
//    
//    // Find best view controller
//    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    return [self findBestViewController:viewController];
//    
//}
////状态栏隐藏于显示
//- (BOOL)prefersStatusBarHidden {
//    //    if (firstShow ==YES) {
//    //        NSLog(@"return 我要显示了");
//    //        return NO;  //显示
//    //
//    //    }else
//    //    {
//    //        NSLog(@"return 我要隐藏了");
//    //        return YES;    //隐藏
//    //    }
//    //    switch (statusNum) {
//    //        case 0:
//    //            return NO
//    //            break;
//    //
//    //        default:
//    //            break;
//    //    }
//    if (touchStatusNum == 0) {
//        if (statusNum == 0) {
//            NSLog(@"statusNum = 0");
//            return YES;
//        }else if(statusNum == 1) { //竖屏
//            NSLog(@"statusNum = 1");
//            return NO;
//        }else if(statusNum == 2) { //竖屏block
//            NSLog(@"statusNum = 2");
//            NSLog(@"statusNum 此时是竖屏");
//            return NO;
//        }else if(statusNum == 3) {  //全屏
//            NSLog(@"statusNum = 3");
//            NSLog(@"statusNum 此时是横");
//            return YES;
//        }
//    }else
//    {
//        if (statusNum == 0) {
//            NSLog(@"statusNum = 0");
//            return YES;
//        }else if(statusNum == 1) { //竖屏
//            NSLog(@"statusNum = 1");
//            return NO;
//        }else if(statusNum == 2) { //竖屏block
//            NSLog(@"statusNum = 2");
//            NSLog(@"statusNum 此时是竖屏");
//            return NO;
//        }else if(statusNum == 3 && touchStatusNum == 1) {  //全屏 显示状态栏
//            NSLog(@"statusNum = 31");
//            NSLog(@"statusNum 此时是横");
//            return YES;
//        }else if(statusNum == 3 && touchStatusNum == 2) {  //全屏 不显示状态栏
//            NSLog(@"statusNum = 32");
//            NSLog(@"statusNum 此时是横");
//            return NO;
//        }
//    }
//    
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
////    [self.navigationController setNavigationBarHidden:YES];
////    [self.navigationController setNavigationBarHidden:NO];
//    NSLog(@"statusNum消失一次");
//}
//-(void)fullScreenStatusNotific
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fullScreenStatusShow" object:nil ];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenStatusShowClick :) name:@"fullScreenStatusShow" object:nil];
//    
////    NSNotification *notification =[NSNotification notificationWithName:@"fullScreenStatusShow" object:nil userInfo:dict];
//    //通过通知中心发送通知
////    [[NSNotificationCenter defaultCenter] postNotification:notification];
//}
//-(void)fullScreenStatusShowClick :(NSNotification *)text{
//    
//     touchStatusNum = [text.userInfo[@"boolBarShow"] intValue];
//    
//    NSLog(@"touchStatusNum :%d",touchStatusNum);
//    [self prefersStatusBarHidden];
////    [self setNeedsStatusBarAppearanceUpdate];
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         [self setNeedsStatusBarAppearanceUpdate];
//                     }];
////    [self preferredStatusBarStyle];
//    
//    
//}
//- (UIStatusBarStyle)preferredStatusBarStyle {
//     if(statusNum == 1) { //竖屏
//        NSLog(@"statusNum = 1");
//         return UIStatusBarStyleDefault;
//    }else if(statusNum == 2) { //竖屏block
//        NSLog(@"statusNum = 2");
//        NSLog(@"statusNum 此时是竖屏");
//        return UIStatusBarStyleDefault;
//    }else if(statusNum == 3) {  //全屏
//        NSLog(@"statusNum = 3");
//        NSLog(@"statusNum 此时是横");
//        return UIStatusBarStyleLightContent;
//    }
//    
//    
//}
//@end
//
//  TVViewController.m
//  starApp
//
//  Created by xyz on 16/8/1.
//  Copyright © 2016年 xyz. All rights reserved.
//

#import "TVViewController.h"
#import "TVCell.h"
#import "MEViewController.h"
#import "KSGuideManager.h"

#define SCREEN_FRAME ([UIScreen mainScreen].bounds)
//#import "HexColors.h"


static const CGSize progressViewSize = {375, 1.5f };
@interface TVViewController ()<YLSlideViewDelegate,UIScrollViewDelegate,
UITableViewDelegate,UITableViewDataSource>
{
    
    YLSlideView * _slideView;
    NSArray *colors;
    NSArray *_testArray;
    NSMutableData * urlData;
    
    //引导页
    UIPageControl *pageControl; //指示当前处于第几个引导页
    UIScrollView *scrollView; //用于存放并显示引导页
    UIImageView *imageViewOne;
    UIImageView *imageViewTwo;
    UIImageView *imageViewThree;
    UIImageView *imageViewFour;
    
    BOOL firstShow;
    BOOL playState;
    NSTimer * timerState;
    int tableviewinit;
    
    //状态栏显示状态
    int statusNum;
    int touchStatusNum; //这个是在点击播放器的时候会改变的数字，用于判断全屏下状态栏的显示
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

@property (strong,nonatomic)NSDictionary * TVSubAudioDic;        //video的字幕和音轨

@property (strong,nonatomic)NSDictionary * TVChannlDic;        //video的频道列表

@property (strong,nonatomic)NSMutableData * byteDatas;
//@property (strong,nonatomic) NSMutableArray *arrdata;
//*****progressLineView
@property (nonatomic) CGFloat progress;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *progressViews;
@property (nonatomic, strong)  UIButton * searchBtn;

///*
// 字幕 音轨
// */
//@property (nonatomic, strong) NSMutableArray *subAudioData;
//@property (strong,nonatomic)NSMutableDictionary * dicSubAudio;
@end

@implementation TVViewController

@synthesize searchViewCon;
@synthesize avController = _avController;   //搜索dms用
@synthesize  serviceModel;
@synthesize socketView;
@synthesize monitorView;


@synthesize activeView;
@synthesize IPString;
@synthesize topView;
@synthesize categoryView;
//@synthesize videoPlay;
- (void)viewDidLoad {
    [super viewDidLoad];
    tableviewinit = 1;
    IPString = @"";
    playState = NO;
    [self initData];    //table表
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    //打开时开始连接socket并且发送心跳
    self.socketView  = [[SocketView  alloc]init];
    [self.socketView viewDidLoad];
    firstShow =NO;
    
    
    activeView = [[UIView alloc]initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                                                         SCREEN_WIDTH,
                                                         SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)];
    
    
    //    activeView.backgroundColor = [UIColor redColor];
    [self.view addSubview:activeView];    //等待loading的view
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.activeView];
    
    
    //如果设置此属性则当前的view置于后台
    
    [HUD showAnimated:YES];
    
    
    //设置对话框文字
    
    HUD.labelText = @"loading";
    [self.activeView addSubview:HUD];
    
    //search数据的获取，只能执行一次，所以不能放到viewwillapper中
    [self getSearchData];
    
    //    [self loadNav];
    //    [self lineView];  //一条0.5pt的线
    //    //new
    //    [self initData];    //table表
    //    //    [self loadUI];              //加载table 和scroll
    //    //    [self getTopCategory];
    //    [self getServiceData];    //获取表数据
    //    [self initProgressLine];
    //    [self getSearchData];
    //
    //
    //    //修改tabbar选中的图片颜色和字体颜色
    //    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.tabBarItem.selectedImage = image;
    //    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
    //
    //    //视频部分
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //
    //    self.view.backgroundColor = [UIColor whiteColor];
    //
    //    [self playVideo];
    //
    //
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    //    self.extendedLayoutIncludesOpaqueBars =NO;
    //    self.modalPresentationCapturesStatusBarAppearance =NO;
    //    self.navigationController.navigationBar.translucent =NO;
    //
    //
    //    //获取数据的链接
    //    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    //
    //
    //    LBGetHttpRequest *request = CreateGetHTTP(url);
    //
    //
    //
    //    [request startAsynchronous];
    //
    //    WEAKGET
    //    [request setCompletionBlock:^{
    //        NSDictionary *response = httpRequest.responseString.JSONValue;
    //
    //
    //        //        NSLog(@"response = %@",response);
    //        NSArray *data = response[@"category"];
    //
    //        if (!isValidArray(data) || data.count == 0){
    //            return ;
    //        }
    //        self.categorys = (NSMutableArray *)data;
    //
    //        //设置滑动条
    //
    //        _slideView = [[YLSlideView alloc]initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
    //                                                                  SCREEN_WIDTH,
    //                                                                  SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)
    //                                             forTitles:self.categorys];
    //
    //
    //        _slideView.backgroundColor = [UIColor whiteColor];
    //        _slideView.delegate        = self;
    //
    //        [self.view addSubview:_slideView];
    //
    //
    //
    //    }];
    //
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)getSearchData
{
    //    searchViewCon = [[SearchViewController alloc]init];
    //    searchViewCon.tableView = [[UITableView alloc]init];
    //    searchViewCon.dataList = [[NSMutableArray alloc]init];
    searchViewCon.dataList =  [searchViewCon getServiceArray ];  //
    searchViewCon.showData = [NSMutableArray arrayWithArray:searchViewCon.dataList];
    [USER_DEFAULT setObject: searchViewCon.showData forKey:@"showData"];
    
    NSLog(@"searchViewCon.dataList: %@",searchViewCon.dataList);
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
    categoryView = [[CategoryViewController alloc]init];
    monitorView = [[MonitorViewController alloc]init];
    self.dicTemp = [[NSMutableDictionary alloc]init];
    self.dataSource = [NSMutableArray array];
    self.topProgressView = [[THProgressView alloc] init];
    
    //    topView = [[UIView alloc]init];
    self.searchBtn = [[UIButton alloc]init];
    //
    searchViewCon = [[SearchViewController alloc]init];
    searchViewCon.tableView = [[UITableView alloc]init];
    searchViewCon.dataList = [[NSMutableArray alloc]init];
    //
    //    _slideView = [[YLSlideView alloc]initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
    //                                                              SCREEN_WIDTH,
    //                                                              SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)
    //                                         forTitles:self.categorys];
    //
    
    _slideView = [YLSlideView alloc];
    
}
-(void)initProgressLine
{
    self.topProgressView.frame = CGRectMake(0  ,
                                            VIDEOHEIGHT+kZXVideoPlayerOriginalHeight ,
                                            SCREEN_WIDTH,
                                            progressViewSize.height);
    self.topProgressView.borderTintColor = [UIColor whiteColor];
    self.topProgressView.progressTintColor = ProgressLineColor;
    [self.view addSubview:self.topProgressView];
    [self.view bringSubviewToFront:self.topProgressView];
    
    self.progressViews = @[ self.topProgressView ];
    
    
    
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
        
        //将数据本地化
        [USER_DEFAULT setObject:response forKey:@"TVHttpAllData"];
        
        //        NSLog(@"response = %@",response);
        NSArray *data1 = response[@"service"];
        if (!isValidArray(data1) || data1.count == 0){
            [self getServiceData];
            return ;
        }
        self.serviceData = (NSMutableArray *)data1;
        
        //        NSLog(@"--------%@",self.serviceData);
        
        
        
        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
            [self getServiceData];
        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        
        
        //////
        //获取数据的链接
        NSString *urlCate = [NSString stringWithFormat:@"%@",S_category];
        
        
        LBGetHttpRequest *request = CreateGetHTTP(urlCate);
        
        
        
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
            
            if (tableviewinit == 2) {
                
                
                //设置滑动条
                
                _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                                                                  SCREEN_WIDTH,
                                                                  SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                
                NSArray *ArrayTocategory = [NSArray arrayWithArray:self.categorys];
                [USER_DEFAULT setObject:ArrayTocategory forKey:@"categorysToCategoryView"];
                
                //            _slideView.frame =  [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                //                                                                    SCREEN_WIDTH,
                //                                                                     SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                //            _slideView = [[YLSlideView alloc]initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                //                                                                      SCREEN_WIDTH,
                //                                                                      SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)
                //                                                 forTitles:self.categorys];
                
                
                _slideView.backgroundColor = [UIColor whiteColor];
                _slideView.delegate        = self;
                
                [self.view addSubview:_slideView];
            }
            else
            {
                
            }
            
            
        }];
        
        
        [self initProgressLine];
        //        [self getSearchData];
        
        
        
        [self.table reloadData];
        
    }];
    
}
-(void)loadNav
{
    //顶部搜索条
    self.navigationController.navigationBarHidden = YES;
    //     topView.frame = CGRectMake(0, -30, SCREEN_WIDTH, topViewHeight);
    //    topView.backgroundColor = [UIColor redColor];
    //        [self.view addSubview:topView];
    
    //    self.navigationController.navigationBar.barTintColor = UIStatusBarStyleDefault;
    
    //搜索按钮
    self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight);
    //    [searchBtn setTitle:@"search" forState:UIControlStateNormal];
    [self.searchBtn setBackgroundColor:[UIColor whiteColor]];
    //    [searchBtn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
    [self.searchBtn setBackgroundImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal]  ;
    [self.view addSubview:self.searchBtn];
    //    [topView bringSubviewToFront:self.searchBtn];
    [self.searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //视频播放
    //----直播源
    self.video = [[ZXVideo alloc] init];
    //    video.playUrl = @"http://baobab.wdjcdn.com/1451897812703c.mp4";
    //  http://192.168.1.1/segment_delivery/delivery_0/play_tv2ip_0.m3u8
    
    
    
    //    self.video.title = [NSString stringWithFormat:@"%@  %@",self.service_videoindex ,self.service_videoname];
    //    self.video.title = [self.service_videoindex stringByAppendingString:self.service_videoname];
    
    self.video.channelId = self.service_videoindex;
    self.video.channelName = self.service_videoname;
    
    
    
    
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
            //            //
            firstShow = YES;
            statusNum = 2;
            [self prefersStatusBarHidden];
            [self setNeedsStatusBarAppearanceUpdate];
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            //                [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
            //
            self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight);
            
            
            //
            self.topProgressView.hidden = NO;
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
            
            self.topProgressView.frame = CGRectMake(0  ,
                                                    VIDEOHEIGHT+kZXVideoPlayerOriginalHeight ,
                                                    SCREEN_WIDTH,
                                                    progressViewSize.height);
            
            
            
            
        };
        self.videoController.videoPlayerWillChangeToFullScreenModeBlock = ^(){
            NSLog(@"切换为全屏模式");
            //            //
            firstShow = NO;
            statusNum = 3;
            [self prefersStatusBarHidden];
            [self setNeedsStatusBarAppearanceUpdate];
            self.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
            //            prefersStatusBarHidden
            
            //
            NSLog(@"123123123123123123123123----");
            
            self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY+1000, searchBtnWidth, searchBtnHeight);
            
            //
            
            //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            //            [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
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
            
            UIViewController * viewNow = [self currentViewController];
            if ([viewNow isKindOfClass:[TVViewController class]]) {
                self.tabBarController.tabBar.hidden = YES;
            }
            
            self.view.frame = CGRectMake(0, 0, 800, 800);
            _slideView.frame = CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                          SCREEN_WIDTH,
                                          SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5);
            
            NSLog(@"目前是全屏");
            NSLog(@"目前是全屏sliderview:%f",_slideView.frame.origin.y);
            
            ////////****************** 进度条
            //此处销毁通知，防止一个通知被多次调用   //5
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fixprogressView" object:nil ];
            //注册通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fixprogressView :) name:@"fixprogressView" object:nil];
            
            self.topProgressView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -50 , [UIScreen mainScreen].bounds.size.width, 2);
            
            
            
            //            //此处销毁通知，*防止一个通知被多次调用
            //    NSNotificationCenter a = [[NSNotificationCenter defaultCenter] removeObserver:self];
            //            //注册通知
            //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
            
            
            
            [self.view bringSubviewToFront:self.topProgressView];
            [self.videoController.view bringSubviewToFront:self.topProgressView];
            
            //            [self setFullScreenView];
            
            NSLog(@"全屏宽 ： %f",[UIScreen mainScreen].bounds.size.width);
            
            
            /////***** 用于设置sub字幕和audio音轨
            [self getsubt];
            /////*****
            //            /////***** 注册通知，勇于设置sub字幕和audio音轨
            //            //此处销毁通知，防止一个通知被多次调用
            //            [[NSNotificationCenter defaultCenter] removeObserver:self];
            //            //注册通知
            //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAndSetSubLanguage ) name:@"getAndSetSubLanguage" object:nil];
            //
            //            ////******
            
        };
        
        
        [self.videoController showInView:self.view];
        self.navigationController.navigationBar.translucent = NO;
        self.extendedLayoutIncludesOpaqueBars
        = NO;
        
        self.edgesForExtendedLayout =UIRectEdgeNone;
        
        //        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    }
    
    
    self.videoController.video = self.video;
    
}
//-(void)test
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        self.topProgressView.hidden = YES;
//    }];
//    NSLog(@"teteteteeteteteteteetetetetetetetetetetetetetetetet");
//
//}

//-(void)setVideoProgress
//{
//    self.topProgressView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -50 , [UIScreen mainScreen].bounds.size.width, 2);
//
//
//    self.video.redview = [self duplicate:self.topProgressView];
//}
//- (THProgressView*)duplicate:(UIView*)view
//{
//    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
//    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
//}
-(void)fixprogressView :(NSNotification *)text{
    int show = [text.userInfo[@"boolBarShow"] intValue];
    touchStatusNum = show;
    if (show ==1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.topProgressView.hidden = YES;
        }];
        [self prefersStatusBarHidden];
        NSLog(@"SCREEN_WIDTH 1 :%f",SCREEN_WIDTH);
        NSLog(@"SCREEN_HEIGHT 1 :%f",SCREEN_HEIGHT);
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self setNeedsStatusBarAppearanceUpdate];
                             
                             //                             self. UIViewControllerWrapperView
                             if (statusNum == 3) {
                                 self.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
                             }else
                             {
                                 self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                             }
                             
                         }];
        
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            self.topProgressView.hidden = NO;
        }];
        [self prefersStatusBarHidden];
        NSLog(@"SCREEN_WIDTH 2 :%f",SCREEN_WIDTH);
        NSLog(@"SCREEN_HEIGHT 2 :%f",SCREEN_HEIGHT);
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self setNeedsStatusBarAppearanceUpdate];
                             
                             if (statusNum == 3) {
                                 self.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
                             }else
                             {
                                 self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                             }
                         }];
    }
    
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
    //    searchViewCon = [[SearchViewController alloc]init];
    //    searchViewCon.tableView = [[UITableView alloc]init];
    //    searchViewCon.dataList = [[NSMutableArray alloc]init];
    //    searchViewCon.dataList =  [searchViewCon getServiceArray ];
    //    searchViewCon.showData = [NSMutableArray arrayWithArray:searchViewCon.dataList];
    //     [USER_DEFAULT setObject: searchViewCon.showData forKey:@"showData"];
    
    [self.navigationController pushViewController:searchViewCon animated:YES];
    searchViewCon.tabBarController.tabBar.hidden = YES;
    NSLog(@"searchViewCon: %@,",searchViewCon);
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
    
    cell.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
        
        
        //此处判断是否为空，防止出错
        if ( ISNULL(self.serviceData)) {
            
        }else{
            [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
            
        }
        
        
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
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    TVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TVCell"];
    if (cell == nil){
        cell = [TVCell loadFromNib];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self touchSelectChannel:indexPath.row diction:self.dicTemp];
    //    //先传输数据到socket，然后再播放视频
    //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    //
    //
    //    //__
    //
    //    NSArray * audio_infoArr = [[NSArray alloc]init];
    //    NSArray * subt_infoArr = [[NSArray alloc]init];
    //
    //    NSArray * epg_infoArr = [[NSArray alloc]init];
    //    //****
    //
    //
    //    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
    //    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
    //    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
    //    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
    //    socketView.socket_ServiceModel.subt_pid = [audio_infoArr[0] objectForKey:@"subt_pid"];
    //    socketView.socket_ServiceModel.service_network_id = [epgDicToSocket objectForKey:@"service_network_id"];
    //    socketView.socket_ServiceModel.service_ts_id =[epgDicToSocket objectForKey:@"service_ts_id"];
    //    socketView.socket_ServiceModel.service_tuner_mode = [epgDicToSocket objectForKey:@"service_tuner_mode"];
    //    socketView.socket_ServiceModel.service_service_id = [epgDicToSocket objectForKey:@"service_service_id"];
    //
    //    //********
    //    self.service_videoindex = [epgDicToSocket objectForKey:@"service_logic_number"];
    //    if(self.service_videoindex.length == 1)
    //    {
    //        self.service_videoindex = [NSString stringWithFormat:@"00%@",self.service_videoindex];
    //    }
    //    else if (self.service_videoindex.length == 2)
    //    {
    //        self.service_videoindex = [NSString stringWithFormat:@"0%@",self.service_videoindex];
    //    }
    //    else if (self.service_videoindex.length == 3)
    //    {
    //        self.service_videoindex = [NSString stringWithFormat:@"%@",self.service_videoindex];
    //    }
    //    else if (self.service_videoindex.length > 3)
    //    {
    //     self.service_videoindex = [self.service_videoindex substringFromIndex:self.service_videoindex.length - 3];
    //    }
    //
    //    self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
    //    epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
    //    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
    //    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
    //    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
    //    self.TVSubAudioDic = [[NSDictionary alloc]init];
    //    self.TVSubAudioDic = epgDicToSocket;
    //    self.TVChannlDic = [[NSDictionary alloc]init];
    //    self.TVChannlDic = self.dicTemp;
    //    NSLog(@"eventname :%@",self.event_startTime);
    //    //*********
    //
    //
    //
    //
    //    if (ISEMPTY(socketView.socket_ServiceModel.audio_pid)) {
    //        socketView.socket_ServiceModel.audio_pid = @"0";
    //    }else if (ISEMPTY(socketView.socket_ServiceModel.subt_pid)){
    //        socketView.socket_ServiceModel.subt_pid = @"0";
    //    }else if (ISEMPTY(socketView.socket_ServiceModel.service_network_id)){
    //        socketView.socket_ServiceModel.service_network_id = @"0";
    //    }else if (ISEMPTY(socketView.socket_ServiceModel.service_ts_id)){
    //        socketView.socket_ServiceModel.service_ts_id = @"0";
    //    }else if (ISEMPTY(socketView.socket_ServiceModel.service_tuner_mode)){
    //        socketView.socket_ServiceModel.service_tuner_mode = @"0";
    //    }else if (ISEMPTY(socketView.socket_ServiceModel.service_service_id)){
    //        socketView.socket_ServiceModel.service_service_id = @"0";
    //    }
    //
    //    NSLog(@"------%@",socketView.socket_ServiceModel);
    //
    //
    //
    //    //此处销毁通知，防止一个通知被多次调用
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    //注册通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
    //
    //    [self.socketView  serviceTouch ];
    //
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}

- (void)getDataService:(NSNotification *)text{
    NSLog(@"%@",text.userInfo[@"playdata"]);
    NSLog(@"－－－－－接收到通知------");
    
    //NSData --->byte[]-------NSData----->NSString
    
    
    _byteDatas = [[NSMutableData alloc]init];
    
    //此处加入判断语句，判断返回的结果RET是否满足几个报错信息
    NSData * retData = [[NSData alloc]init];
    retData = [[USER_DEFAULT objectForKey:@"data_service11"] subdataWithRange:NSMakeRange(12, 4)];
    NSLog(@"retData : %@",retData);
    
    int value = CFSwapInt32BigToHost(*(int*)([retData bytes]));
    NSLog(@"value : %d",value);
    //通过获得data数据减去发送的data数据得到播放连接，一下是返回数据的ret，如果ret不等于0则报错
    [self  getLinkData :value];
    //    //调用GGutil的方法
    //    byteDatas =  [GGUtil convertNSDataToByte:[USER_DEFAULT objectForKey:@"data_service"] bData:[USER_DEFAULT objectForKey:@"data_service11"]];
    //
    
    NSLog(@"---urlData%@",_byteDatas);
    
    //    self.video.playUrl = [@"h"stringByAppendingString:[[NSString alloc] initWithData:_byteDatas encoding:NSUTF8StringEncoding]];
    self.video.playUrl = [[NSString alloc] initWithData:_byteDatas encoding:NSUTF8StringEncoding];
    
    //    self.video.title = [self.service_videoindex stringByAppendingString:self.service_videoname];
    
    self.video.channelId = self.service_videoindex;
    self.video.channelName = self.service_videoname;
    
    
    self.video.playEventName = self.event_videoname;
    self.video.startTime = self.event_startTime;
    self.video.endTime = self.event_endTime;
    //    self.video.dicSubAudio = self.TVSubAudioDic;
    
    [self setStateNonatic];
    [self playVideo];
    
    playState = NO;
    if (! playState ) {
        timerState =   [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playClick) userInfo:nil repeats:YES];
    }
    
    
    
    //** 计算进度条
    if(!ISNULL(self.event_startTime)&&!ISNULL(self.event_endTime))
    {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        if (ISNULL(self.event_startTime) || self.event_startTime == NULL || self.event_startTime == nil) {
            
        }else
        {
            NSLog(@"此处可能报错，因为StarTime不为空 ");
            [dict setObject:self.event_startTime forKey:@"StarTime"];
        }
        if (ISNULL(self.event_startTime) || self.event_startTime == NULL || self.event_startTime == nil) {
            
        }else
        {
            NSLog(@"此处可能报错，因为StarTime不为空 ");
            [dict setObject:self.event_endTime forKey:@"EndTime"];
        }
        
        
        //        NSLog(@"dict.start :%@",[dict objectForKey:@"StarTime"]);
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress:) userInfo:dict repeats:YES];
    }
    //**
    NSLog(@"---urlData%@",self.video.playUrl);
    
    
    NSString * str = [NSString stringWithFormat:@"%@",self.video.playUrl];
    
    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"data信息"message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertview show];
    
    
}
//-(void)getAndSetSubLanguage {
//
//    self.dicSubAudio = [[NSMutableDictionary alloc]init];
//    self.subAudioData = [NSMutableArray array];
//
//    subAudiorightCell * subAudiocell =  [tableView dequeueReusableCellWithIdentifier:@"TVCell"];
//    if (cell == nil){
//        cell = [TVCell loadFromNib];
//    }
//}
-(void)getsubt
{
    //    NSDictionary * epgDictionary = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    //
    //
    //    //__
    //
    //    NSArray * audio_infoArr = [[NSArray alloc]init];
    //    NSArray * subt_infoArr = [[NSArray alloc]init];
    //
    //    NSArray * epg_infoArr = [[NSArray alloc]init];
    //    //****
    //
    //
    //    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
    //    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
    //    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
    //    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
    //    socketView.socket_ServiceModel.subt_pid = [audio_infoArr[0] objectForKey:@"subt_pid"];
    /////****
    //此处循环给赋值
    
    self.video.dicSubAudio = self.TVSubAudioDic;
    
    self.video.dicChannl = self.TVChannlDic;
    
    self.video.channelCount = self.categoryModel.service_indexArr.count;
}

//row 代表是service的每个类别下的序列是几，dic代表每个类别下的service
-(void)touchSelectChannel :(NSInteger)row diction :(NSDictionary *)dic
{
    NSLog(@"self.socket:%@",self.socketView);
    
    //先传输数据到socket，然后再播放视频
    //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",row]];
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    
    NSLog(@"dic: %@",dic);
    
    NSLog(@"row: %ld",(long)row);
    /*此处添加一个加入历史版本的函数*/
    [self addHistory:row diction:dic];
    
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
    if(self.service_videoindex.length == 1)
    {
        self.service_videoindex = [ NSString stringWithFormat:@"00%@",self.service_videoindex];
    }
    else if (self.service_videoindex.length == 2)
    {
        self.service_videoindex = [NSString stringWithFormat:@"0%@",self.service_videoindex];
    }
    else if (self.service_videoindex.length == 3)
    {
        self.service_videoindex = [NSString stringWithFormat:@"%@",self.service_videoindex];
    }
    else if (self.service_videoindex.length > 3)
    {
        self.service_videoindex = [self.service_videoindex substringFromIndex:self.service_videoindex.length - 3];
    }
    
    self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
    epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
    self.TVSubAudioDic = [[NSDictionary alloc]init];
    self.TVSubAudioDic = epgDicToSocket;
    self.TVChannlDic = [[NSDictionary alloc]init];
    self.TVChannlDic = self.dicTemp;
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
    
    
    
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
    
    
    //    self.socketView  = [[SocketView  alloc]init];
    //    [self.socketView viewDidLoad];
    
    NSLog(@"self.socket:%@",self.socketView);
    
    self.videoController.socketView1 = self.socketView;
    [self.socketView  serviceTouch ];
    
    
}

//-(void)touchSearchData :(NSInteger)row diction :(NSDictionary *)dic
//{
//    //先传输数据到socket，然后再播放视频
//    //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",row]];
//    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%d",row]];
//
//    //__
//
//    NSArray * audio_infoArr = [[NSArray alloc]init];
//    NSArray * subt_infoArr = [[NSArray alloc]init];
//
//    NSArray * epg_infoArr = [[NSArray alloc]init];
//    //****
//
//
//    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
//    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
//    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
//    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
//    socketView.socket_ServiceModel.subt_pid = [audio_infoArr[0] objectForKey:@"subt_pid"];
//    socketView.socket_ServiceModel.service_network_id = [epgDicToSocket objectForKey:@"service_network_id"];
//    socketView.socket_ServiceModel.service_ts_id =[epgDicToSocket objectForKey:@"service_ts_id"];
//    socketView.socket_ServiceModel.service_tuner_mode = [epgDicToSocket objectForKey:@"service_tuner_mode"];
//    socketView.socket_ServiceModel.service_service_id = [epgDicToSocket objectForKey:@"service_service_id"];
//
//    //********
//    self.service_videoindex = [epgDicToSocket objectForKey:@"service_logic_number"];
//    if(self.service_videoindex.length == 1)
//    {
//        self.service_videoindex = [NSString stringWithFormat:@"00%@",self.service_videoindex];
//    }
//    else if (self.service_videoindex.length == 2)
//    {
//        self.service_videoindex = [NSString stringWithFormat:@"0%@",self.service_videoindex];
//    }
//    else if (self.service_videoindex.length == 3)
//    {
//        self.service_videoindex = [NSString stringWithFormat:@"%@",self.service_videoindex];
//    }
//    else if (self.service_videoindex.length > 3)
//    {
//        self.service_videoindex = [self.service_videoindex substringFromIndex:self.service_videoindex.length - 3];
//    }
//
//    self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
//    epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
//    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
//    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
//    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
//    self.TVSubAudioDic = [[NSDictionary alloc]init];
//    self.TVSubAudioDic = epgDicToSocket;
//    self.TVChannlDic = [[NSDictionary alloc]init];
//    self.TVChannlDic = self.dicTemp;
//    NSLog(@"eventname :%@",self.event_startTime);
//    //*********
//
//
//
//
//    if (ISEMPTY(socketView.socket_ServiceModel.audio_pid)) {
//        socketView.socket_ServiceModel.audio_pid = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.subt_pid)){
//        socketView.socket_ServiceModel.subt_pid = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.service_network_id)){
//        socketView.socket_ServiceModel.service_network_id = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.service_ts_id)){
//        socketView.socket_ServiceModel.service_ts_id = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.service_tuner_mode)){
//        socketView.socket_ServiceModel.service_tuner_mode = @"0";
//    }else if (ISEMPTY(socketView.socket_ServiceModel.service_service_id)){
//        socketView.socket_ServiceModel.service_service_id = @"0";
//    }
//
//    NSLog(@"------%@",socketView.socket_ServiceModel);
//
//
//
//    //此处销毁通知，防止一个通知被多次调用
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
//
//
//    self.videoController.socketView1 = self.socketView;
//    [self.socketView  serviceTouch ];
//
//
//}
-(void)getLinkData : (int )val
{
    if (val == 0)  {
        //调用GGutil的方法
        NSLog(@"返回数据正常");
        _byteDatas =  [GGUtil convertNSDataToByte:[USER_DEFAULT objectForKey:@"data_service"] bData:[USER_DEFAULT objectForKey:@"data_service11"]];
    }
    else if(val == 1)
    {
        NSLog(@"CRC 错误");
    }
    else if(val == 2)
    {
        NSLog(@"通知事件");
    }
    else if(val == 3)
    {
        NSLog(@"资源连接");
    }
    else if(val == 4)
    {
        NSLog(@"播放错误"); //可能没插信号线
    }
    else if(val == 5)
    {
        NSLog(@"密码正确");
    }
    else if(val == 6)
    {
        NSLog(@"密码错误");
    }
    else if(val == 7)
    {
        NSLog(@"停止错误");
    }
    else if(val == 8)
    {
        NSLog(@"得到资源错误");
    }
    else if(val == 9)
    {
        NSLog(@"服务器停止分发");
    }
    else if(val == 10)
    {
        NSLog(@"无效");
    }
}

-(void)addHistory:(NSInteger)row diction :(NSDictionary *)dic
{
    
    // 1.获得点击的视频dictionary数据
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%d",row]];
    // 2. 初始化两个数组存放数据
    //     NSArray * historyArr = [[NSArray alloc]init];
    NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
    //3.获得以前的点击数据
    mutaArray = [[USER_DEFAULT objectForKey:@"historySeed"]mutableCopy];
    
    //4.将点击的数据加入可变数组
    //此处进行判断看新添加的节目是否曾经添加过
    BOOL addNewData = YES;
    //    if (mutaArray.count == 0) {
    //         [mutaArray addObject:epgDicToSocket];
    //    }
    //    else{
    for (int i = 0; i <mutaArray.count ; i++) {
        //原始数据
        NSString * service_network =  [mutaArray[i][0] objectForKey:@"service_network_id"];
        NSString * service_ts =  [mutaArray[i][0] objectForKey:@"service_ts_id"];
        NSString * service_service =  [mutaArray[i][0] objectForKey:@"service_service_id"];
        NSString * service_tuner =  [mutaArray[i][0] objectForKey:@"service_tuner_mode"];
        
        //新添加的数据
        NSString * newservice_network =  [epgDicToSocket objectForKey:@"service_network_id"];
        NSString * newservice_ts =  [epgDicToSocket objectForKey:@"service_ts_id"];
        NSString * newservice_service =  [epgDicToSocket objectForKey:@"service_service_id"];
        NSString * newservice_tuner =  [epgDicToSocket objectForKey:@"service_tuner_mode"];
        
        if ([service_network isEqualToString:newservice_network] && [service_ts isEqualToString:newservice_ts] && [service_tuner isEqualToString:newservice_tuner] && [service_service isEqualToString:newservice_service]) {
            addNewData = NO;
            
            NSArray * equalArr = mutaArray[i];
            
            [mutaArray removeObjectAtIndex:i];
            [mutaArray  addObject:equalArr];
            
            break;
        }
        
        
    }
    //    }
    if (addNewData == YES) {
        NSString * seedNowTime = [GGUtil GetNowTimeString];
        NSNumber *aNumber = [NSNumber numberWithInteger:row];
        NSArray * seedNowArr = [NSArray arrayWithObjects:epgDicToSocket,seedNowTime,aNumber,dic,nil];
        
        
        if (seedNowArr.count > 0) {
            [mutaArray addObject:seedNowArr];
            
        }else
        {
            NSAssert(seedNowArr != NULL, @"提示: 此时seedNowArr.count < 0,证明其为空");
        }
        
        
        //     [mutaArray addObject:epgDicToSocket];
    }
    
    
    
    //5。两个数组相加
    //    [ mutaArray addObject:historyArr];
    NSArray *myArray = [NSArray arrayWithArray:mutaArray];
    [USER_DEFAULT setObject:myArray forKey:@"historySeed"];
    
    
    //    NSLog(@"myarray:%@",myArray[3]);
    //    NSLog(@"myarray:%@",myArray[2]);
    //    NSLog(@"myarray:%@",myArray[2][0]);
    
    MEViewController * meview = [[MEViewController alloc]init];
    [meview viewDidAppear:YES];
    [meview viewDidLoad];
    
}
//引导页
- (void)viewWillAppear:(BOOL)animated{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
        self.tabBarController.tabBar.hidden = YES;
        firstShow = NO;
        statusNum = 0;
        [self prefersStatusBarHidden];
        
        
        [self addGuideView]; //添加引导图
        
    }else{
        NSLog(@"不是第一次启动");
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
        tableviewinit  = tableviewinit +1;
        firstShow = YES;
        statusNum = 1;
        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
        self.tabBarController.tabBar.hidden = NO;
        
        
        [self prefersStatusBarHidden];
        
        
        
        
        
        //        [self viewDidLoad];
        
        //new
        //        [self initData];    //table表
        [self loadNav];
        [self lineView];  //一条0.5pt的线
        //    [self loadUI];              //加载table 和scroll
        //    [self getTopCategory];
        [self getServiceData];    //获取表数据
        //        [self initProgressLine];
        //        [self getSearchData];
        [self setIPNoific];
        [self setVideoTouchNoific];
        [self newTunerNotific]; //新建一个tuner的通知
        [self deleteTunerInfoNotific]; //新建一个删除tuner的通知
        [self allCategorysBtnNotific];
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
        
        
        
    }
    
    NSLog(@"目前是sliderview:%f",_slideView.frame.origin.y);
}
- (void)addGuideView {
    
    NSMutableArray *paths = [NSMutableArray new];
    
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"引导页1" ofType:@"png"]];
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"引导页2" ofType:@"png"]];
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"引导页3" ofType:@"png"]];
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"引导页4" ofType:@"png"]];
    
    [[KSGuideManager shared] showGuideViewWithImages:paths];
    
    //2
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"enterTVView" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterTVView) name:@"enterTVView" object:nil];
    
    
}


//从第一次启动的引导页进入首页
-(void)enterTVView
{
    
    
    [self viewWillAppear:YES];
}

-(void)newTunerNotific
{
    //新建一个发送tuner请求并且接受返回信息的通知   //3
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tunerRevice" object:nil] ;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTunerInfo) name:@"tunerRevice" object:nil];
    
    
    
}
-(void)deleteTunerInfoNotific
{
    //新建一个发送tuner删除直播消息的通知   //4
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteTuner" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delegeTunerInfo) name:@"deleteTuner" object:nil];
    
}


-(void)allCategorysBtnNotific
{
    //新建一个发送tuner删除直播消息的通知   //4
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"allCategorysBtnNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allCategorysBtnClick) name:@"allCategorysBtnNotific" object:nil];
    
}
-(void)allCategorysBtnClick
{
    NSLog(@"点击分类了2");
    
    categoryView = [[CategoryViewController alloc]init];
    [self.navigationController pushViewController:categoryView animated:YES];
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
    self.categoryView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
    self.categoryView.navigationItem.leftBarButtonItem = myButton;
}
-(void)clickEvent
{
    
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)receiveTunerInfo
{
    //获取分发资源信息
    [self.socketView csGetResource];
}
-(void)delegeTunerInfo
{
    //停止播放，视频分发
    [self.socketView  deliveryPlayExit];
}
-(void)setIPNoific
{
    
    //新建一个发送IP 改变的消息的通知   //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IPHasChanged" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IPHasChanged) name:@"IPHasChanged" object:nil];
    
}
-(void)setVideoTouchNoific
{
    
    //新建一个发送IP 改变的消息的通知   //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VideoTouchNoific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoTouchNoificClick :) name:@"VideoTouchNoific" object:nil];
    
}
-(void)IPHasChanged
{
    NSLog(@"执行方法");
    [self getServiceData];
}
-(void)setStateNonatic
{
    //新建一个发送播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MPMediaPlaybackIsPreparedToPlayDidChangeNotification" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willplay) name:@"MPMediaPlaybackIsPreparedToPlayDidChangeNotification" object:nil];
}
-(void)playClick
{
    NSLog(@"playState:%d",playState);
    NSLog(@"(self.video.playUrl:%@",self.video.playUrl);
    if ( self.video.playUrl != NULL && ! playState) {
        [self playVideo];
        
        NSLog(@"播放");
    }
    else
    {
        [timerState invalidate];
        timerState = nil;
        
    }
}
-(void)willplay
{
    
    playState = YES;
}
/////////////其他页面的播放通知事件
//row 代表是service的每个类别下的序列是几，dic代表每个类别下的service
-(void)VideoTouchNoificClick : (NSNotification *)text//(NSInteger)row diction :(NSDictionary *)dic  //:(NSNotification *)text{
{
    
    NSInteger row = [text.userInfo[@"textOne"]integerValue];
    NSDictionary * dic = [[NSDictionary alloc]init];
    dic = text.userInfo[@"textTwo"];
    
    NSLog(@"self.socket:%@",self.socketView);
    
    //先传输数据到socket，然后再播放视频
    //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",row]];
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    
    NSLog(@"dic: %@",dic);
    
    NSLog(@"row: %ld",(long)row);
    /*此处添加一个加入历史版本的函数*/
    [self addHistory:row diction:dic];
    
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
    if(self.service_videoindex.length == 1)
    {
        self.service_videoindex = [ NSString stringWithFormat:@"00%@",self.service_videoindex];
    }
    else if (self.service_videoindex.length == 2)
    {
        self.service_videoindex = [NSString stringWithFormat:@"0%@",self.service_videoindex];
    }
    else if (self.service_videoindex.length == 3)
    {
        self.service_videoindex = [NSString stringWithFormat:@"%@",self.service_videoindex];
    }
    else if (self.service_videoindex.length > 3)
    {
        self.service_videoindex = [self.service_videoindex substringFromIndex:self.service_videoindex.length - 3];
    }
    
    self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
    epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
    self.TVSubAudioDic = [[NSDictionary alloc]init];
    self.TVSubAudioDic = epgDicToSocket;
    self.TVChannlDic = [[NSDictionary alloc]init];
    self.TVChannlDic = self.dicTemp;
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
    
    
    
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
    
    
    //    self.socketView  = [[SocketView  alloc]init];
    //    [self.socketView viewDidLoad];
    
    NSLog(@"self.socket:%@",self.socketView);
    
    self.videoController.socketView1 = self.socketView;
    [self.socketView  serviceTouch ];
    
    
}
-(UIViewController*) findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}

-(UIViewController*) currentViewController {
    
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
    
}
//状态栏隐藏于显示
- (BOOL)prefersStatusBarHidden {
    if (touchStatusNum !=1 && touchStatusNum != 2) {
        
        //        if (firstShow ==YES) {
        ////            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        //            return NO;  //显示
        //        }else
        //        {
        ////            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        //            return YES;    //隐藏
        //        }
        
        if(statusNum == 0)
        {
            return YES;
        }else if (statusNum == 1)
        {
            return NO;
        }else if (statusNum == 2)
        {
            return NO;
        }else if (statusNum == 3)
        {
            return NO;
        }
        
        
    }
    else if(touchStatusNum == 1 && statusNum == 3 ){
        //       self.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        return YES;
    }else if (touchStatusNum == 2 && statusNum == 3){
        //        self.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        return NO;
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if(statusNum == 1) { //竖屏
        NSLog(@"statusNum = 1");
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        return UIStatusBarStyleDefault;
    }else if(statusNum == 2) { //竖屏block
        NSLog(@"statusNum = 2");
        NSLog(@"statusNum 此时是竖屏");
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        return UIStatusBarStyleDefault;
    }else if(statusNum == 3) {  //全屏
        NSLog(@"statusNum = 3");
        NSLog(@"statusNum 此时是横");
        self.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        
        return UIStatusBarStyleLightContent;
        //        return UIStatusBarStyleDefault;
    }
    
    
}
@end
