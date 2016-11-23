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
//@synthesize videoPlay;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    //打开时开始连接socket并且发送心跳
    self.socketView  = [[SocketView  alloc]init];
    [self.socketView viewDidLoad];
    firstShow =NO;
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

//-(void)viewWillAppear:(BOOL)animated
//{
//    NSLog(@"展示展示展示展示展示展示展示展示");
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)getSearchData
{
    searchViewCon = [[SearchViewController alloc]init];
    searchViewCon.tableView = [[UITableView alloc]init];
    searchViewCon.dataList = [[NSMutableArray alloc]init];
    searchViewCon.dataList =  [searchViewCon getServiceArray ];
    searchViewCon.showData = [NSMutableArray arrayWithArray:searchViewCon.dataList];
    [USER_DEFAULT setObject: searchViewCon.showData forKey:@"showData"];

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
    monitorView = [[MonitorViewController alloc]init];
    self.dicTemp = [[NSMutableDictionary alloc]init];
    self.dataSource = [NSMutableArray array];
}
-(void)initProgressLine
{
     self.topProgressView = [[THProgressView alloc] initWithFrame:CGRectMake(0  ,
                                                                                       VIDEOHEIGHT+kZXVideoPlayerOriginalHeight ,
                                                                                       SCREEN_WIDTH,
                                                                                       progressViewSize.height)];
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

        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
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
    if (show ==1) {
        [UIView animateWithDuration:0.3 animations:^{
         self.topProgressView.hidden = YES;
        }];
        
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            self.topProgressView.hidden = NO;
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
    self.video.playUrl = [@"h"stringByAppendingString:[[NSString alloc] initWithData:_byteDatas encoding:NSUTF8StringEncoding]];
//    self.video.playUrl = [[NSString alloc] initWithData:byteDatas encoding:NSUTF8StringEncoding];

//    self.video.title = [self.service_videoindex stringByAppendingString:self.service_videoname];
    
    self.video.channelId = self.service_videoindex;
    self.video.channelName = self.service_videoname;
    

    self.video.playEventName = self.event_videoname;
    self.video.startTime = self.event_startTime;
    self.video.endTime = self.event_endTime;
//    self.video.dicSubAudio = self.TVSubAudioDic;
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
   
    //先传输数据到socket，然后再播放视频
//    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",row]];
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%d",row]];
    
    NSLog(@"dic: %@",dic);
    
    NSLog(@"row: %d",row);
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
            break;
        }
        
    
    }
//    }
    if (addNewData == YES) {
       NSString * seedNowTime = [GGUtil GetNowTimeString];
        NSNumber *aNumber = [NSNumber numberWithInteger:row];
        NSArray * seedNowArr = [NSArray arrayWithObjects:epgDicToSocket,seedNowTime,aNumber,dic,nil];
        
        [mutaArray addObject:seedNowArr];
//     [mutaArray addObject:epgDicToSocket];
    }
    
    //5。两个数组相加
//    [ mutaArray addObject:historyArr];
   NSArray *myArray = [NSArray arrayWithArray:mutaArray];
    [USER_DEFAULT setObject:myArray forKey:@"historySeed"];

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
        [self prefersStatusBarHidden];


        [self addGuideView]; //添加引导图
        
    }else{
        NSLog(@"不是第一次启动");
        firstShow = YES;
             [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
        self.tabBarController.tabBar.hidden = NO;

        
        [self prefersStatusBarHidden];
        
        
        
        
        
        //        [self viewDidLoad];
        [self loadNav];
        [self lineView];  //一条0.5pt的线
        //new
        [self initData];    //table表
        //    [self loadUI];              //加载table 和scroll
        //    [self getTopCategory];
        [self getServiceData];    //获取表数据
        [self initProgressLine];
        [self getSearchData];
        
        [self newTunerNotific]; //新建一个tuner的通知
        [self deleteTunerInfoNotific]; //新建一个删除tuner的通知
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
//状态栏隐藏于显示
- (BOOL)prefersStatusBarHidden {
    if (firstShow ==YES) {
        return NO;
    }else
    {
    return YES;
    }
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
@end
