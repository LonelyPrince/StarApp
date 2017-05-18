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
#import "MJRefresh.h"



#define SCREEN_FRAME ([UIScreen mainScreen].bounds)
//#import "HexColors.h"


static const CGSize progressViewSize = {375, 1.5f };
@interface TVViewController ()<YLSlideViewDelegate,UIScrollViewDelegate,
UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>
{
    
    YLSlideView * _slideView;   //它可以直接操作各个表，对表进行刷新
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
    //    NSTimer * timerState;
    int tableviewinit;
    
    //状态栏显示状态
    int statusNum;
    int touchStatusNum; //这个是在点击播放器的时候会改变的数字，用于判断全屏下状态栏的显示
    
    //判断是不是第一次进入首页，如果是，则自动播放第一个节目
    int firstOpenAPP;
    
    //判断当前是不是一个节目
    NSString * eventName1 ;
    NSString * eventName2 ;
    NSString * eventNameTemp ;
    
    BOOL firstfirst;   //第一次打开时，自动播放第一个节目，这时候需要将socket的touch事件放到viewdidload之后
    
    NSInteger  playNumCount;
    
    UITableView * tempTableviewForFocus;  //用于保存全屏页面点击时候的焦点
    NSIndexPath * tempIndexpathForFocus;  //用于保存全屏页面点击时候的焦点
    NSArray * tempArrForServiceArr;
    BOOL tempBoolForServiceArr;
    NSDictionary *  tempDicForServiceArr;
    UIImageView * hudImage; //无网络图片
    MBProgressHUD *HUD; //网络加载HUD
    UILabel * hudLab ;//无网络文字
    
    //为了防止[socket viewDidload]执行多次，在这里进行判断
    int viewDidloadHasRunBool;
    
    NSString * deviceString;
    int indexOfServiceToRefreshTable;
    UITextField *STBTextField_Encrypt;
    UITextField *CATextField_Encrypt;
    
    UIAlertView *STBAlert;
    UIAlertView *CAAlert;
    
    NSInteger STBTouch_Row ;  //STB 加锁后的通知中的row参数
    NSDictionary * STBTouch_Dic ; //STB 加锁后的通知中的dic参数
    NSString * STBTouchType_Str;  //STB 加锁后的通知中的字符串参数，勇于判断属于哪种播放类型
    NSInteger STBTouch_Audio ;  //STB 加锁后的通知中的audio参数
    NSInteger STBTouch_Subt ;  //STB 加锁后的通知中的subt参数
    NSMutableSet * channelStartimesList ; //用于保存开始时间的集合
    BOOL isNeedRefreshChannelListForStartTime;     //创建时间管理channelList
    int  manageRefreshTimeFor;   //管理NSSet刷新时间的，防止用户刷新NSSet，导致页面卡死，这里用时间做一次判断，就好比每过30s才刷新一次
    NSString * nwoTimeBreakStr;  //获得当前时间戳
    BOOL isEventStartTimeBiger_NowTime;
    BOOL isBarIsShowNow;
    NSMutableArray  * storeLastChannelArr; //保存用户最后一个播放的节目信息，用于在用户删除完历史节目后切换到的首页时候播放
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

@property (nonatomic, assign) NSInteger category_index;  //能够获得当前页面的category的index索引
@property (strong,nonatomic)NSMutableDictionary * dicTemp;

@property (strong,nonatomic)NSString * service_videoindex;     //video的频道索引
@property (strong,nonatomic)NSString * service_videoname;    //video的频道名称
@property (strong,nonatomic)NSString * event_videoname;      //video的节目名称
@property (strong,nonatomic)NSString * event_startTime;      //video的直播节目开始时间
@property (strong,nonatomic)NSString * event_endTime;        //video的节目名称结束时间

@property (strong,nonatomic)NSDictionary * TVSubAudioDic;        //video的字幕和音轨

@property (strong,nonatomic)NSDictionary * TVChannlDic;        //video的频道列表

@property (strong,nonatomic)NSMutableArray * progressEPGArr;        //为了进度条，保存EPG，然后获取不同时间段的时间
@property (assign,nonatomic)NSInteger  progressEPGArrIndex;  //进度条进行节目的索引

@property (strong,nonatomic)NSMutableData * byteDatas;
//@property (strong,nonatomic) NSMutableArray *arrdata;
//*****progressLineView
@property (nonatomic) CGFloat progress;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *progressViews;
@property (nonatomic, strong)  UIButton * searchBtn;
@property (nonatomic, strong)  TVTable * tableForSliderView;  //首页的频道列表tableView
@property (nonatomic, strong)  TVTable * tableForTemp;  //首页的频道列表
@property (nonatomic, strong)  NSMutableArray *  tableForDicIndexArr;  //数组保存首页每一个table和index的字典对应关系

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
@synthesize allStartEpgTime;
@synthesize tableForSliderView;
@synthesize timerState; //不播放时候的计时器
@synthesize progressEPGArr;  //为了进度条，保存EPG，然后获取不同时间段的时间
@synthesize progressEPGArrIndex;
//@synthesize videoPlay;
- (void)viewDidLoad {
    [super viewDidLoad];
    firstfirst = YES;
    tableviewinit = 1;
    firstOpenAPP = 0;
    IPString = @"";
    playState = NO;
    [self initData];    //table表
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    //打开时开始连接socket并且发送心跳
    self.socketView  = [[SocketView  alloc]init];
    //    [self.socketView viewDidLoad];
    firstShow =NO;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstStartTransform"];
    
    //    activeView = [[UIView alloc]initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
    //                                                         SCREEN_WIDTH,
    //                                                         SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)];
    activeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                         SCREEN_WIDTH,
                                                         SCREEN_HEIGHT)];
    
    
    //    activeView.backgroundColor = [UIColor redColor];
    [self.view addSubview:activeView];    //等待loading的view
    HUD = [[MBProgressHUD alloc] initWithView:self.activeView];
    
    //    UIView * hudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    hudImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 616/2)/2, 120, 616/2, 348/2)];
    hudImage.image = [UIImage imageNamed:@"网络无连接"];
    //调用上面的方法，获取 字体的 Size
    
    CGSize size = [self sizeWithText: @"Network Error" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
    hudLab.text = @"Network Error";
    hudLab.font = FONT(15);
    hudLab.textColor = [UIColor grayColor];
    
    
    //    [hudView addSubview:hudImage];
    
    
    //如果设置此属性则当前的view置于后台
    
    [HUD showAnimated:YES];
    
    
    //设置对话框文字
    
    HUD.labelText = @"loading";
    self.activeView.backgroundColor = [UIColor whiteColor];
    [self.activeView addSubview:HUD];
    
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressRefresh) object:nil];
    //    [self performSelector:@selector(notHaveNetWork) withObject:nil afterDelay:10];
    
    //    [self.activeView addSubview:hudImage];    //如果是断网状况下，解开注释，可以显示断网图片
    //    [self.activeView addSubview:hudLab];      //如果是断网状况下，解开注释，可以显示断网图片
    
    //search数据的获取，只能执行一次，所以不能放到viewwillapper中
    [self getSearchData];
    
    UIApplication *app = [UIApplication sharedApplication];
    
    [[NSNotificationCenter defaultCenter]
     
     addObserver:self
     
     selector:@selector(applicationWillResignActive:)
     
     name:UIApplicationWillResignActiveNotification
     
     object:app];
    
    
    //KVO
    
    self.kvo_NoDataPic = [[KVO_NoDataPic alloc]init];
    
    [self.kvo_NoDataPic addObserver:self forKeyPath:@"numberOfTable_NoData" options:NSKeyValueObservingOptionNew context:nil];
    
    
    viewDidloadHasRunBool = 0;
    [USER_DEFAULT setObject: [NSNumber numberWithInt:viewDidloadHasRunBool] forKey:@"viewDidloadHasRunBool"];
    
    NSNumber *  abc = [USER_DEFAULT objectForKey:@"viewDidloadHasRunBool"];
    NSLog(@"abc %d",[abc intValue]);
    
}
#pragma mark-----KVO回调----
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (![keyPath isEqualToString:@"numberOfTable_NoData"]) {
        return;
    }
    if ([self.categoryModel.service_indexArr count]==0) {//无数据
        //        [[BJNoDataView shareNoDataView] showCenterWithSuperView:self.tableView icon:nil iconClicked:^{
        //            //图片点击回调
        //            [self loadData];//刷新数据
        //        }];
        
        self.kvo_NoDataImageview.image = [UIImage imageNamed:@"圆环-9"];
        self.kvo_NoDataImageview.frame = CGRectMake(100, tableForSliderView.frame.origin.y+50, SCREEN_WIDTH - 200, SCREEN_WIDTH - 200) ;
        self.kvo_NoDataImageview.alpha = 1;
        
        //CGRectMake(tableForSliderView.frame.origin.x, tableForSliderView.frame.origin.y, tableForSliderView.frame.size.width, tableForSliderView.frame.size.height);
        [self.tableForSliderView addSubview:self.kvo_NoDataImageview];
        //        [_table bringSubviewToFront:self.kvo_NoDataImageview];
        NSLog(@"此时数据无，添加占位图");
        return;
    }else
    {
        self.kvo_NoDataImageview.alpha = 0;
        self.kvo_NoDataImageview = nil;
        [self.kvo_NoDataImageview removeFromSuperview];
        self.kvo_NoDataImageview = nil;
        [self.kvo_NoDataImageview removeFromSuperview];
        self.kvo_NoDataImageview.frame = CGRectMake(100000, tableForSliderView.frame.origin.y+500000, 1, 1) ;
        NSLog(@"此时数据有，删除啦啦占位图");
        return;
    }
    
    
    //有数据
    //    [[BJNoDataView shareNoDataView] clear];
}
- (void)applicationWillResignActive:(NSNotification *)notification
{
    self.video.playUrl = @"";
    //    [self playVideo];
    [self.videoController stop];
    
    
}
-(void)notHaveNetWork
{
    [self.activeView removeFromSuperview];
    [HUD removeFromSuperview];
    HUD = nil;
    self.activeView.backgroundColor = [UIColor whiteColor];
    [self.activeView addSubview:hudImage];
    [self.activeView addSubview:hudLab];
    [self.view addSubview:activeView];
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
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
    allStartEpgTime = [[NSMutableArray alloc]init];
    self.tableForDicIndexArr = [[NSMutableArray alloc]init];
    //
    //    _slideView = [[YLSlideView alloc]initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
    //                                                              SCREEN_WIDTH,
    //                                                              SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5)
    //                                         forTitles:self.categorys];
    //
    
    //    _slideView = [YLSlideView alloc];
    //    self.videoController = [[ZXVideoPlayerController alloc]init];
    
    progressEPGArr = [[NSMutableArray alloc]init];
    
    tempTableviewForFocus = [[UITableView alloc]init]; //用于保存全屏页面点击时候的焦点
    tempIndexpathForFocus = [[NSIndexPath alloc]init];  //用于保存全屏页面点击时候的焦点
    
    tempArrForServiceArr = [[NSArray alloc]init]; //用于保存点击后的列表数组信息
    tempBoolForServiceArr = NO;
    tempDicForServiceArr = [[NSDictionary alloc]init];
    
    self.kvo_NoDataImageview = [[UIImageView alloc]init];
    
    self.TVSubAudioDic = [[NSDictionary alloc]init];
    self.TVChannlDic = [[NSDictionary alloc]init];
    STBTextField_Encrypt = [[UITextField alloc]init];
    CATextField_Encrypt = [[UITextField alloc]init];
    STBTouch_Dic  = [[NSDictionary alloc]init];
    
    STBAlert = STBAlert = [[UIAlertView alloc] initWithTitle:@"请输入机顶盒密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    CAAlert = CAAlert = [[UIAlertView alloc] initWithTitle:@"请输入CA密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    channelStartimesList = [[NSMutableSet alloc]init];
    storeLastChannelArr = [[NSMutableArray alloc]init];
    
}
-(void)initProgressLine
{
    //    self.videoController.videoPlayerWillChangeToOriginalScreenModeBlock = ^(){
    //        NSLog(@"切换为竖屏模式");
    //      b
    //    };
    //    self.videoController.videoPlayerWillChangeToFullScreenModeBlock = ^(){
    //        NSLog(@"切换为全屏模式");
    //    };
    BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
    if (isFullScreen == NO) {
        self.topProgressView.frame = CGRectMake(-2 ,
                                                VIDEOHEIGHT+kZXVideoPlayerOriginalHeight ,
                                                SCREEN_WIDTH,
                                                progressViewSize.height);
        self.topProgressView.borderTintColor = [UIColor whiteColor];
        self.topProgressView.progressTintColor = ProgressLineColor;
        [self.view addSubview:self.topProgressView];
        [self.view bringSubviewToFront:self.topProgressView];
        
        self.progressViews = @[ self.topProgressView ];
        
        
    }else
    {
    }
    
    
}


- (void)updateProgress :(NSTimer *)Time
{
    NSInteger endTime =[[[Time userInfo] objectForKey:@"EndTime" ] intValue ];
    NSInteger startTime =[[[Time userInfo] objectForKey:@"StartTime" ] intValue ];
    NSLog(@"endTime :%d",endTime);
    NSLog(@"startTime :%d",startTime);
    int timeCut;
    NSString *  starttime;
    if(ISNULL([[Time userInfo] objectForKey:@"EndTime"]) || ISNULL([[Time userInfo]objectForKey:@"StarTime"]))
    {
        
        [self.topProgressView removeFromSuperview];  //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
        [self.timer invalidate];
        self.timer = nil;  //将计时器也删除
        NSLog(@"结束时间或者开始时间不能为空");
    }
    else
    {
        timeCut= [[[Time userInfo] objectForKey:@"EndTime" ] intValue ] - [[[Time userInfo]objectForKey:@"StarTime"] intValue];
        starttime =[[Time userInfo]objectForKey:@"StarTime"];
        
        if(timeCut<=0 && starttime <0)
        {
            [self.topProgressView removeFromSuperview];  //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
            [self.timer invalidate];
            self.timer = nil;  //将计时器也删除
            NSLog(@"z在updateProgress里面调用 replaceEventNameNotific");
            [self removeProgressNotific];
        }
    }
    //算出时间间隔
    //     = [[[Time userInfo] objectForKey:@"EndTime" ] intValue ] - [[[Time userInfo]objectForKey:@"StarTime"] intValue];
    NSLog(@"--==timecut %d",timeCut);
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
        
        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            [self getStartTimeFromchannelListArr : data1]; //将获得data存到集合
        });
        
        
        if (!isValidArray(data1) || data1.count == 0){
            [self getServiceData];
            return ;
        }
        self.serviceData = (NSMutableArray *)data1;
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        //        NSLog(@"--------%@",self.serviceData);
        
        
        
        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
            [self getServiceData];
        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notHaveNetWork) object:nil];
        [self playVideo];
        NSLog(@"playVideo55 :");
        
        
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
            
            //            if (tableviewinit == 2) {
            NSLog(@"_slideView %@",_slideView);
            if (!_slideView) {
                NSLog(@"上山打老虎4");
                
                
                
                
                
                //判断是不是全屏
                BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
                if (isFullScreen == NO) {   //竖屏状态
                    
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                    
                    
                }else //横屏状态，不刷新
                {
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                }
                
                
                
                
                
                
                //                //设置滑动条
                //                _slideView = [YLSlideView alloc];
                //                _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                //                                                                  SCREEN_WIDTH,
                //                                                                  SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                
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
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                
            }
            else
            {
                
            }
            NSLog(@"DMSIP:6666");
            [self.socketView viewDidLoad];
            if (firstfirst == YES) {
                
                //                   self.socketView  = [[SocketView  alloc]init];
                NSLog(@"DMSIP:1111");
                //                   [self.socketView viewDidLoad];
                NSLog(@"DMSIP:2222");
                
                //=======机顶盒加密
                NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:0 serviceListDic:self.dicTemp];
                if (characterStr != NULL && characterStr != nil) {
                    BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                    if (judgeIsSTBDecrypt == YES) {
                        // 此处代表需要记性机顶盒加密验证
                        NSNumber  *numIndex = [NSNumber numberWithInteger:0];
                        NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"firstOpenTouch",@"textThree",nil];
                        //创建通知
                        NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                        NSLog(@"POPPOPPOPPOP1111111111111111111");
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                        
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                        
                    }else //正常播放的步骤
                    {
                        //======
                        [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                    }
                }else //正常播放的步骤
                {
                    //======机顶盒加密
                    
                    [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }
            }else
            {}
            
            //            //刷新EPG数据。把所有的时间信息
            //
            //            NSArray *EPGservice_data = response[@"service"];
            //            if (!isValidArray(EPGservice_data) || EPGservice_data.count == 0){
            //            }
            //            else   //此时有数据
            //            {
            //                NSDictionary * dicEpg = [[NSDictionary alloc]init];
            //                for (int e = 0; e<EPGservice_data.count; e++) {
            //
            //                    dicEpg = EPGservice_data[e];
            //
            //                    NSArray * arrEpg = [[NSArray alloc]init];
            //                    arrEpg = [dicEpg objectForKey:@"epg_info"];   //epg 小数组
            //
            //                    //重新声明一个一个epg数组加载epg信息
            ////                    NSDictionary * epgTimeInfo = [[NSDictionary alloc]init];
            //                    for (int f = 0; f<arrEpg.count; f++) {
            //                        NSString * startTimeString = [arrEpg[f] objectForKey:@"event_starttime"];
            //
            //
            //                            if (![allStartEpgTime containsObject:startTimeString]) {
            //                                [allStartEpgTime addObject:startTimeString];
            //                            }
            //
            //
            //                    }
            //                }
            //
            //
            //            }
            //            NSLog(@"allStartEpgTime:--%@",allStartEpgTime);
            //            NSLog(@"allStartEpgTime.count:--%lu",(unsigned long)allStartEpgTime.count);
            //
            
            
            
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
    
    deviceString = [GGUtil deviceVersion];
    
    
    //搜索按钮
    //    self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight);
    //    [searchBtn setTitle:@"search" forState:UIControlStateNormal];
    [self.searchBtn setBackgroundColor:[UIColor whiteColor]];
    //    [searchBtn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
    [self.searchBtn setBackgroundImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal]  ;
    [self.view addSubview:self.searchBtn];
    //    [topView bringSubviewToFront:self.searchBtn];
    [self.searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];//mediaDeliveryUpdate //searchBtnClick //judgeJumpFromOtherView //tableViewCellToBlue //refreshTableviewByEPGTime
    
    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]  ) {
        NSLog(@"此刻是5s和4s 的大小");
        
        self.searchBtn.frame = CGRectMake(searchBtnX-2, searchBtnY, searchBtnWidth *0.8533, searchBtnHeight *0.8533 );
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]  || [deviceString isEqualToString:@"iPhone Simulator"] ) {
        NSLog(@"此刻是6的大小");
        self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight);
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        self.searchBtn.frame = CGRectMake(searchBtnX+1, searchBtnY, searchBtnWidth *1.104, searchBtnHeight *1.104 );
    }
    
    
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
-(void)refreshTableviewByEPGTime //由于EPG时间要发生变化，所以此处要刷新他
{
    //        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
    //
    //        TVCell *cell1 = [self.tableForSliderView cellForRowAtIndexPath:indexPath1];
    //
    //    NSLog(@"cell1 shi :%@",cell1);
    //    cell1.event_nextNameLab.text = @"woca";
    //    cell1.event_nameLab.text = @"woca";
    //    cell1.event_nextTime.text = @"woca";
    //        [cell1.event_nextNameLab setTextColor:[UIColor redColor]]; //CellGrayColor
    //        [cell1.event_nameLab setTextColor:[UIColor redColor]];  //CellBlackColor
    //        [cell1.event_nextTime setTextColor:[UIColor redColor]]; //CellGrayColor
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        self.dicTemp = NULL;
        //        self.dicTemp = nil;
        NSInteger beforeRefreshIndex = self.category_index; //由于刷新后，列表的index会迅速变换为0，所以这里要做一个等级
        [_slideView reloadData];
        [self.tableForTemp reloadData];
        [tableForSliderView reloadData];
        NSLog(@"self.category_index :%d",beforeRefreshIndex);
        NSNumber * currentIndex = [NSNumber numberWithInteger:beforeRefreshIndex];
        NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndex,@"currentIndex", nil];
        //创建通知，防止刷新后跳转错页面
        NSNotification *notification =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    });
    
    //        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    //        cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
    //        cell1.selectedBackgroundView.backgroundColor = [UIColor blueColor]; //RGBA(
    //        cell1.backgroundView = [[UIView alloc] initWithFrame:cell1.frame];
    //        cell1.backgroundView.backgroundColor = [UIColor whiteColor];
    //        cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
    //        cell1.selectedBackgroundView.backgroundColor = [UIColor whiteColor]; //RGBA
    //        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    //        if(i == row2)
    //        {
    //            [cell1.event_nextNameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)]; //CellGrayColor
    //            [cell1.event_nameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];  //CellBlackColor
    //            [cell1.event_nextTime setTextColor:RGBA(0x60, 0xa3, 0xec, 1)]; //CellGrayColor
    //            cell1.backgroundView = [[UIView alloc] initWithFrame:cell1.frame];
    //            cell1.backgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1); //RGBA(0xf8, 0xf8, 0xf8, 1);//[UIColor whiteColor];//
    //            cell1.selectedBackgroundView = [[UIView alloc] initWithFrame:cell1.frame];
    //            cell1.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1); //RGBA
    //
    //            cell1.selected = YES;
    //        }
    //    }
    //    double abcd = 100;
    //    for (int i = 0 ; i< 365*10; i++) {
    //        double shouyi = 300.0/370000;
    ////        double abcd = 37;
    //        abcd = abcd*(1+shouyi);
    //        NSLog(@"第 %d 天 每日结算总额：%f 万",i+1,abcd);
    //    }
}
#pragma mark - 被播放的节目变蓝
-(void)tableViewCellToBlue :(NSInteger)numberOfIndex  indexhah :(NSInteger)numberOfIndexForService AllNumberOfService:(NSInteger)AllNumberOfServiceIndex
{
    NSNumber * numIndex = [NSNumber numberWithInteger:numberOfIndex];
    NSNumber * numIndex2 = [NSNumber numberWithInteger:numberOfIndexForService];
    NSNumber * numIndex3 = [NSNumber numberWithInteger:AllNumberOfServiceIndex];
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",numIndex2,@"textTwo", numIndex3,@"textThree",nil];
    //创建通知
    //    NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoificAudioSubt" object:nil userInfo:dict];
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tableViewChangeBlue" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

- (void)playVideo
{
    NSLog(@"playvideo 的线程");
    if (!self.videoController) {
        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, VIDEOHEIGHT, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight)];
        //         self.videoController.frame = CGRectMake(0, VIDEOHEIGHT, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight);
        
        
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
            NSLog(@"sel.view.frame11 %f",self.view.frame.size.height);
            NSLog(@"sel.view.frame12 %f",self.view.frame.size.width);
            //            //
            firstShow = YES;
            statusNum = 2;
            [self prefersStatusBarHidden];
            [self setNeedsStatusBarAppearanceUpdate];
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            //                [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
            //
            //            self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight);
            if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]  ) {
                NSLog(@"此刻是5s和4s 的大小");
                
                self.searchBtn.frame = CGRectMake(searchBtnX-2, searchBtnY, searchBtnWidth *0.8533, searchBtnHeight *0.8533 );
                
            }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]  || [deviceString isEqualToString:@"iPhone Simulator"] ) {
                NSLog(@"此刻是6的大小");
                self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight);
                
            }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
                NSLog(@"此刻是6 plus的大小");
                
                self.searchBtn.frame = CGRectMake(searchBtnX+1, searchBtnY, searchBtnWidth *1.104, searchBtnHeight *1.104 );
            }
            
            //            self.topProgressView.hidden = NO;
            self.topProgressView.alpha = 1;
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
            NSLog(@"上山打老虎1");
            self.topProgressView.frame = CGRectMake(0  ,
                                                    VIDEOHEIGHT+kZXVideoPlayerOriginalHeight ,
                                                    SCREEN_WIDTH,
                                                    progressViewSize.height);
            [self judgeProgressIsNeedHide:NO]; //判断进度条需不需要隐藏，第一个参数表示是否全屏
            
        };
        self.videoController.videoPlayerWillChangeToFullScreenModeBlock = ^(){
            
            //new====
            NSString * isPreventFullScreenStr = [USER_DEFAULT objectForKey:@"modeifyTVViewRevolve"];//判断是否全屏界面下就跳转到首页面，容易出现界面混乱
            
            if ([isPreventFullScreenStr isEqualToString:@"NO"]) {
                
            }else if(([isPreventFullScreenStr isEqualToString:@"YES"]))
            {
                //new====
                NSLog(@"切换为全屏模式");
                NSLog(@"sel.view.frame21 %f",self.view.frame.size.height);
                NSLog(@"sel.view.frame22 %f",self.view.frame.size.width);
                
                
                NSLog(@"sel.view.frame21 %f",SCREEN_HEIGHT);
                NSLog(@"sel.view.frame22 %f",SCREEN_WIDTH);
                //            STBAlert.autoresizingMask = UIViewAutoresizingNone;
                //            STBAlert.transform = CGAffineTransformRotate(STBAlert.transform, M_PI/2);
                //
                //            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                //             TVCell *cell1 = [self.table cellForRowAtIndexPath:indexPath];
                //
                
                
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
                NSLog(@"上山打老虎2");
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
                
                [self judgeProgressIsNeedHide:YES]; //判断进度条需不需要隐藏，第一个参数表示是否全屏
                //            [self setFullScreenView];
                
                NSLog(@"全屏宽 ： %f",[UIScreen mainScreen].bounds.size.width);
                
                
                /////***** 用于设置sub字幕和audio音轨
                //            [self getsubt];
                /////*****
                //            /////***** 注册通知，勇于设置sub字幕和audio音轨
                //            //此处销毁通知，防止一个通知被多次调用
                //            [[NSNotificationCenter defaultCenter] removeObserver:self];
                //            //注册通知
                //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAndSetSubLanguage ) name:@"getAndSetSubLanguage" object:nil];
                //
                //            ////******
                
                //new=====
            }else
            {
            }
            //new=====
        };
        
        
        [self.videoController showInView:self.view];
        self.navigationController.navigationBar.translucent = NO;
        self.extendedLayoutIncludesOpaqueBars
        = NO;
        
        self.edgesForExtendedLayout =UIRectEdgeNone;
        
        //        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    }
    
    NSLog(@"contentURL 11TV");
    NSLog(@"replaceEventNameNotific 这里是在全屏横屏的地方的地方");
    NSLog(@"replaceEventNameNotific 这里是在全屏横屏的地方的地方  self.name %@",self.event_videoname);
    NSLog(@"replaceEventNameNotific 这里是在全屏横屏的地方的地方  self.name %@",self.video.playEventName);
    self.videoController.video = self.video;
    NSLog(@"contentURL 22TV");
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
        BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
        if (isFullScreen == YES) {
            //此刻是全屏，隐藏进度条
            [UIView animateWithDuration:0.3 animations:^{
                //                self.topProgressView.hidden = YES;
                self.topProgressView.alpha = 0;
            }];
        }else
        {//此刻是竖屏，不隐藏进度条
            
        }
        [USER_DEFAULT setBool:NO forKey:@"isBarIsShowNow"]; //阴影此时是隐藏
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
            //            self.topProgressView.hidden = NO;
            self.topProgressView.alpha = 1;
        }];
        [USER_DEFAULT setBool:YES  forKey:@"isBarIsShowNow"]; //阴影此时是显示
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
    
    
    //    [self isSTBDEncrypt:@"3"];
}

//************************************************
//table可以滑动的次数
- (NSInteger)columnNumber{
    //   return colors.count;
    return self.categorys.count;
}

- (TVTable *)slideView:(YLSlideView *)slideView
     cellForRowAtIndex:(NSUInteger)index{
    
    tableForSliderView =[slideView dequeueReusableCell];
    //    TVTable * cell = [slideView dequeueReusableCell];
    
    if (!tableForSliderView) {
        tableForSliderView = [[TVTable alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT -_slideView.frame.origin.y-49.5)
                                                     style:UITableViewStylePlain];
        tableForSliderView.delegate   = self;
        tableForSliderView.dataSource = self;
        
    }
    // 添加头部的下拉刷新
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];  //下拉触发
    tableForSliderView.mj_header = header;
    
    //    //保存到字典中 tableView和index
    //    NSDictionary * dicTableAndIndex = [[NSDictionary alloc]init];
    NSMutableArray * arrTemp = [[NSMutableArray alloc]init];
    NSNumber *  indexforTableToNum = [NSNumber numberWithInteger:index];
    [arrTemp addObject:indexforTableToNum];
    [arrTemp addObject:tableForSliderView];
    
    //    NSString * indexforTableToStr = [NSString stringWithFormat:@"%@",dicTableAndIndex];
    //
    //    [dicTableAndIndex setValue:tableForSliderView forKey:indexforTableToStr]; //将table保存为字典的序号
    //
    
    [self.tableForDicIndexArr addObject:arrTemp];
    
    return tableForSliderView;
}
// 头部的下 拉刷新触发事件
- (void)headerClick {
    
    self.tableForSliderView =  self.tableForTemp;
    // 可在此处实现下拉刷新时要执行的代码
    // ......
    
    [self tableViewDataRefreshForMjRefresh];  //重新获取json数据
    //    [self tableViewDataRefresh];
    NSLog(@"tableForDicIndexArr:%@",self.tableForDicIndexArr);
    //    for (int i = 0; i<self.tableForDicIndexArr.count; i++) {
    //
    //        id idTemp = self.tableForDicIndexArr[i][1];
    //        NSNumber * numTemp = self.self.tableForDicIndexArr[i][0];
    //
    //        if (idTemp == self.tableForSliderView ) {
    //
    //            NSInteger index = [numTemp integerValue];
    //            NSDictionary *item = self.categorys[index];   //当前页面类别下的信息
    //            self.categoryModel = [[CategoryModel alloc]init];
    //
    //            self.categoryModel.service_indexArr = item[@"service_index"];   //当前类别下包含的节目索引  0--9
    //
    //            //获取EPG信息 展示
    //            //时间戳转换
    //
    //            [self.dicTemp removeAllObjects];
    //            //获取不同类别下的节目，然后是节目下不同的cell值                10
    //            for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {
    //
    //                int indexCat ;
    //                //   NSString * str;
    //                indexCat =[self.categoryModel.service_indexArr[i] intValue];
    //                //cell.tabledataDic = self.serviceData[indexCat -1];
    //
    //
    //                //此处判断是否为空，防止出错
    //                if ( ISNULL(self.serviceData)) {
    //
    //                }else{
    //                    [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
    //                }
    //
    //
    //            }
    //
    //
    //
    //
    //
    //        }
    //    }
    
    NSLog(@"self.dicTemp==--== :%@",self.dicTemp);
    //    重新赋值self.dictemp
    //uitableview reloaddata
    
    //    [self.tableForSliderView reloadData];
    //    [self refreshTableviewByEPGTime];
    //    // 模拟延迟2秒
    //
    //    double delayInSeconds = 2;
    //    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    //    dispatch_after(popTime, mainQueue, ^{
    //        NSLog(@"延时执行的2秒");
    //        //        [self runThread1];
    //        NSLog(@"byteValue1 TVTVTVTVTVTV222");
    //        [self.tableForSliderView reloadData];
    ////        [_slideView reloadData];  //新加的刷新
    //        [self refreshTableviewByEPGTime];
    //        NSLog(@"byteValue1 TVTVTVTVTVTV333");
    //    });
    //    [NSThread sleepForTimeInterval:2];
    ////    [self mediaDeliveryUpdate];
    ////    [tableForSliderView reloadData];
    //    // 结束刷新
    //
    ////    NSLog(@"tableForSliderView22--:%@",self.tableForSliderView);
    //    [self.tableForSliderView.mj_header endRefreshing];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.tableForTemp = scrollView;
    NSLog(@"self.tableForTemp%@",self.tableForTemp);
}
- (void)slideVisibleView:(TVTable *)cell forIndex:(NSUInteger)index{
    
    NSLog(@"index :%@ ",@(index));
    NSLog(@"self.category_index :%d",index);
    
    if(index < 10000)
    { self.category_index = index;
        cell.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        //self.categorys[i]                          不同类别
        //self.categoryModel.service_indexArr        类别的索引数组
        //self.categoryModel.service_indexArr.count
        //给不同的table赋值
        //    for (int i = 0 ; i<self.categorys.count; i++) {
        
        NSDictionary *item = self.categorys[index];   //当前页面类别下的信息
        self.categoryModel = [[CategoryModel alloc]init];
        
        
        self.categoryModel.service_indexArr = item[@"service_index"];
        NSLog(@"self.TVChannlDic 2:%d",self.TVChannlDic.count);
        
        //    self.categoryModel.service_indexArr = item[@"service_index"];   //当前类别下包含的节目索引  0--9
        
        //获取EPG信息 展示
        //时间戳转换
        
        [self.dicTemp removeAllObjects];
        
        //获取不同类别下的节目，然后是节目下不同的cell值                10
        for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {
            
            int indexCat ;
            //   NSString * str;
            indexCat =[self.categoryModel.service_indexArr[i] intValue];
            NSLog(@"self.TVChannlDic 5:%lu",(unsigned long)self.TVChannlDic.count);
            //cell.tabledataDic = self.serviceData[indexCat -1];
            
            
            //此处判断是否为空，防止出错
            if ( ISNULL(self.serviceData)) {
                
            }else{
                [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
            }
            
        }
        
        //    tempDicForServiceArr = self.TVChannlDic;
        
        //        cell.tabledataDic =  self.categorys[index];
        //    }
        
        //    self.a = index;
        //    NSLog(@"index  self.a--------:%@ ",@(index));
        [cell reloadData]; //刷新TableView
        //    NSLog(@"刷新数据");
        //    [self getsubt];
        
    }else
    {
        self.category_index = 0;
        NSLog(@"index 的长度出错了，不应该这么长");
    }
}

- (void)slideViewInitiatedComplete:(TVTable *)cell forIndex:(NSUInteger)index{
    
    //可以在这里做数据的预加载（缓存数据）
    NSLog(@"缓存数据 %@",@(index));
    NSLog(@"self.category_index2 :%d",index);
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell reloadData];
        
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)self.serviceData.count);
    NSLog(@"当前tableView个数 :%lu",self.categoryModel.service_indexArr.count);
    nwoTimeBreakStr = [GGUtil GetNowTimeString];  //获得时间戳，用于对tableView表的数据进行定位
    self.kvo_NoDataPic.numberOfTable_NoData = [NSString stringWithFormat:@"%lu",(unsigned long)self.categoryModel.service_indexArr.count];
    return self.categoryModel.service_indexArr.count;
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TVCell defaultCellHeight];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TableSampleIdentifier = @"TVCell";
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    NSLog(@"当前tableView 的cell方法");
    tempTableviewForFocus = tableView;
    TVCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil){
        cell = [TVCell loadFromNib];
        //        cell = [[TVCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
        
        //UITableViewCell *cell;
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //        [cell.event_nameLab setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
        //        [cell.event_nextNameLab setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
    }
    
    
    
    
    
    //
    //    TVTable * table = [[TVTable alloc]init];
    //    cell.dataDic = table.tabledataDic;
    
    
    //    cell.aa =  self.category_index;
    //    cell.aaa =self.categoryModel.service_indexArr.count;
    //    NSLog(@"index  cell.aaa--------:%d",cell.aaa);
    
    if (!ISEMPTY(self.dicTemp)) {
        cell.nowTimeStr = nwoTimeBreakStr;  //这里的nwoTimeBreakStr 是在numbeOfrows获取的当前时间
        cell.dataDic = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
        
        
        //焦点
        NSDictionary * fourceDic = [USER_DEFAULT objectForKey:@"NowChannelDic"];  //这里还用作判断播放的焦点展示
        NSLog(@"cell.dataDic 11:%@",cell.dataDic);
        NSLog(@"cell.dataDic fourceDic: %@",fourceDic);
        //        NSArray * serviceArrForJudge =  self.serviceData;
        //        for (int i = 0; i< serviceArrForJudge.count; i++) {
        //            NSDictionary * serviceForJudgeDic = serviceArrForJudge[i];
        //       [GGUtil judgeTwoChannelDicIs]
        if ([GGUtil judgeTwoEpgDicIsEqual:cell.dataDic TwoDic:fourceDic]) { //[cell.dataDic isEqualToDictionary:fourceDic]
            
            //                int indexForJudgeService = i;
            //                 NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
            [cell.event_nextNameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
            [cell.event_nameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
            [cell.event_nextTime setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
            
            
        }else
        {
            [cell.event_nextNameLab setTextColor:CellGrayColor];  //CellGrayColor
            [cell.event_nameLab setTextColor:CellBlackColor];  //CellBlackColor
            [cell.event_nextTime setTextColor:CellGrayColor];//[UIColor greenColor]
            
            
        }
        
        //        }
        //        [self judgeServiceArrIndex :serviceArrForJudgeInd];
        
        
    }else{//如果为空，什么都不执行
        NSLog(@"==");
    }
    
    NSLog(@"cell.dataDic:%@",cell.dataDic);
    
    return cell;
    
}
-(void)judgeServiceArrIndex :(NSArray *)serviceArrForJudge
{
    
}
-(void)refreshTableFocus
{
    //这是刷主页面的table焦点的通知
    //    此处销毁通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTableFocusNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableFocusNotific:) name:@"refreshTableFocusNotific" object:nil];
    
}
-(void)refreshTableFocusNotific: (NSNotification *)text
{
    
    [tempTableviewForFocus deselectRowAtIndexPath:tempIndexpathForFocus animated:YES];
    //先全部变黑
    for (NSInteger  i = 0; i<self.categoryModel.service_indexArr.count; i++) {
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:0];
        
        TVCell *cell1 = [tempTableviewForFocus cellForRowAtIndexPath:indexPath1];
        [cell1.event_nextNameLab setTextColor:CellGrayColor];
        [cell1.event_nameLab setTextColor:CellBlackColor];
        [cell1.event_nextTime setTextColor:CellGrayColor];
    }
    
    NSIndexPath * indexPathDict =text.userInfo[@"indexPathDic"];
    tempIndexpathForFocus = indexPathDict;
    //    NSInteger row = [text.userInfo[@"indexpathRow"]integerValue];
    //    NSIndexPath *indexPathNow = [NSIndexPath indexPathForRow:row inSection:0];
    //选中的变蓝
    TVCell *cell = [tempTableviewForFocus cellForRowAtIndexPath:indexPathDict];
    NSLog(@"tableForSliderViewtableForSliderViewtableForSliderView%@",tableForSliderView);
    NSLog(@"tabletabletabletabletabletable%@",self.table);
    NSLog(@"cellcellcellcellcellcell:%@",cell);
    [cell.event_nextNameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
    [cell.event_nameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
    [cell.event_nextTime setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"POPPOPPOPPOP222222222222221333");
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        //        dispatch_async(dispatch_get_main_queue,^{
        //for example [activityIndicator stopAnimating];
        if (firstOpenAPP == 0) {
            
            //=======机顶盒加密
            NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:0 serviceListDic:self.dicTemp];
            if (characterStr != NULL && characterStr != nil) {
                BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                if (judgeIsSTBDecrypt == YES) {
                    // 此处代表需要记性机顶盒加密验证
                    NSNumber  *numIndex = [NSNumber numberWithInteger:0];
                    NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"firstOpenTouch",@"textThree",nil];
                    //创建通知
                    NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                    NSLog(@"POPPOPPOPPOP222222222222221");
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                    
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }else //正常播放的步骤
                {
                    //======
                    [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }
            }else //正常播放的步骤
            {
                //======机顶盒加密
                [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                firstOpenAPP = firstOpenAPP+1;
            }
        }
        
        //        });
    }
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    tempBoolForServiceArr = YES;
    tempArrForServiceArr =  self.categoryModel.service_indexArr;
    tempDicForServiceArr = self.TVChannlDic;
    [USER_DEFAULT setObject:tempArrForServiceArr forKey:@"tempArrForServiceArr"];
    [USER_DEFAULT setObject:tempDicForServiceArr forKey:@"tempDicForServiceArr"];
    self.video.dicChannl = [tempDicForServiceArr mutableCopy];
    self.video.channelCount = tempArrForServiceArr.count;
    
    tempIndexpathForFocus = indexPath;
    //    DetailViewController *controller =[[DetailViewController alloc] init];
    //    controller.dataDic = self.dataSource[indexPath.row];
    //    [self.navigationController pushViewController:controller animated:YES];
    
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
    
    //=======机顶盒加密
    NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:indexPath.row serviceListDic:self.dicTemp];
    if (characterStr != NULL && characterStr != nil) {
        BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
        if (judgeIsSTBDecrypt == YES) {
            // 此处代表需要记性机顶盒加密验证
            NSNumber  *numIndex = [NSNumber numberWithInteger:0];
            NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"LiveTouch",@"textThree",nil];
            //创建通知
            NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
            NSLog(@"POPPOPPOPPOP33333333333");
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification1];
            
            firstOpenAPP = firstOpenAPP+1;
            
            firstfirst = NO;
        }else //正常播放的步骤
        {
            //======
            [self touchSelectChannel:indexPath.row diction:self.dicTemp];
            firstOpenAPP = firstOpenAPP+1;
            
            firstfirst = NO;
        }
    }else //正常播放的步骤
    {
        //======机顶盒加密
        
        [self touchSelectChannel:indexPath.row diction:self.dicTemp];
        firstOpenAPP = firstOpenAPP+1;
        
        firstfirst = NO;
    }
    NSLog(@"tableForSliderView11--tableview:%@",tableView);
    
    //    //此处应该记住indexpath和是哪个UItableView
    NSIndexPath * indexPathNow = indexPath;
    //    NSIndexPath * indexPathTemp = indexPathNow;
    //    NSDictionary * dicCellShow = self.dicTemp;
    //    [USER_DEFAULT setInteger:indexPath.row forKey:@"indexPathNow"];
    //    [USER_DEFAULT setInteger:indexPathTemp.row forKey:@"indexPathTemp"];
    //    [USER_DEFAULT setObject:dicCellShow forKey:@"dicCellShow"];
    //
    //    self.categoryModel.service_indexArr.count
    
    
    //    //先全部变黑
    //    for (NSInteger  i = 0; i<self.categoryModel.service_indexArr.count; i++) {
    //        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:0];
    //
    //        TVCell *cell1 = [tableView cellForRowAtIndexPath:indexPath1];
    //        [cell1.event_nextNameLab setTextColor:CellGrayColor];
    //        [cell1.event_nameLab setTextColor:CellBlackColor];
    //        [cell1.event_nextTime setTextColor:CellGrayColor];
    //    }
    //
    //
    //
    //
    //    //选中的变蓝
    //    TVCell *cell = [tableView cellForRowAtIndexPath:indexPathNow];
    //    [cell.event_nextNameLab setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
    //    [cell.event_nameLab setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
    //    [cell.event_nextTime setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
    //    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    //    NSLog(@"cellcellcellcellcellcell:%@",cell);
    
    //new ==
    int indexOfCategory =  self.category_index;  //[self judgeCategoryType:[self.dicTemp objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]]; //从别的页面跳转过来，要先判断节目的类别，然后让底部的category转到相应的类别下
    NSArray * allNumberOfServiceArr = [self.categorys[indexOfCategory] objectForKey:@"service_index"];
    [self tableViewCellToBlue:indexOfCategory indexhah:indexPath.row AllNumberOfService:allNumberOfServiceArr.count];
    
    [tableView scrollToRowAtIndexPath:indexPath  atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)getDataService:(NSNotification *)text{
    NSLog(@"%@",text.userInfo[@"playdata"]);
    NSLog(@"哦按都按搜到那是你大劫案申冬奥房那是大放悲声");
    NSLog(@"－－－－－接收到通知------");
    NSLog(@"playState---===TV 页接收到通知------");
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
    
    NSLog(@"---urlDataTV接收%@",_byteDatas);
    NSLog(@"---urlData接收页面shang面的video.playurl 111%@",self.video.playUrl);
    
    //        self.video.playUrl = [@"h"stringByAppendingString:[[NSString alloc] initWithData:_byteDatas encoding:NSUTF8StringEncoding]];
    self.video.playUrl = @"";
    self.video.playUrl = [[NSString alloc] initWithData:_byteDatas encoding:NSUTF8StringEncoding];
    NSLog(@"self.video :%@",self.video);
    NSLog(@"playState-==self.video.playUrl 22 %@ ",self.video.playUrl);
    
    //    self.video.title = [self.service_videoindex stringByAppendingString:self.service_videoname];
    
    self.video.channelId = self.service_videoindex;
    self.video.channelName = self.service_videoname;
    NSLog(@"self.video.channelName %@",self.video.channelName);
    
    self.video.playEventName = self.event_videoname;
    NSLog(@"self.event_videoname 获取列表中 replaceEventNameNotific %@",self.event_videoname);
    NSLog(@"replaceEventNameNotific self.video.playeventName :%@",self.video.playEventName);
    self.video.startTime = self.event_startTime;
    self.video.endTime = self.event_endTime;
    //    self.video.dicSubAudio = self.TVSubAudioDic;
    
    [self setStateNonatic];
    //    NSLog(@"playvideo 前面的线程");
    ////    NSThread * thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(runThread1) object:nil];
    ////    [thread1 start];
    //    NSLog(@"TVcontentURL play11");
    //    [self performSelector:@selector(runThread1) withObject:nil afterDelay:4]  ;
    NSLog(@"byteValue1 TVTVTVTVTVTV");
    
    
    [USER_DEFAULT setObject:@"NO" forKey:@"isStartBeginPlay"]; //是否已经开始播放，如果已经开始播放，则停止掉中心点的旋转等待圆圈
    
    
    //==========正文
    double delayInSeconds = 5;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, mainQueue, ^{
        NSLog(@"延时执行的2秒");
        //        [self runThread1];
        NSLog(@"byteValue1 TVTVTVTVTVTV222");
        
        [USER_DEFAULT setObject:@"YES" forKey:@"isStartBeginPlay"]; //是否已经开始播放，如果已经开始播放，则停止掉中心点的旋转等待圆圈
        
        [self playVideo];
        NSLog(@"byteValue1 TVTVTVTVTVTV333");
    });
    
    //    [self playClick];
    //==========正文
    //    [self playVideo];
    
    //    NSLog(@"TVcontentURL play22");
    //
    //    [self performSelector:@selector(runThread1) withObject:nil afterDelay:2];
    
    
    //    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //    dispatch_async(mainQueue, ^{
    //        NSLog(@"aa1");
    //        [self setStateNonatic];
    //    });
    //    dispatch_async(mainQueue, ^{
    //        NSLog(@"aa2");
    //        [self playVideo];
    //    });
    //    dispatch_async(mainQueue, ^{
    //        NSLog(@"aa3");
    //    });
    //    dispatch_async(mainQueue, ^{
    //        NSLog(@"aa4");
    //    });
    
    //    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);    //并行
    //    dispatch_async(defaultQueue, ^{
    //        NSLog(@"1");
    //        [self setStateNonatic];
    //    });
    //    dispatch_async(defaultQueue, ^{
    //        NSLog(@"2");
    //        [self playVideo];
    //    });
    //    dispatch_async(defaultQueue, ^{
    //        NSLog(@"3");
    //    });
    //    dispatch_async(defaultQueue, ^{
    //        NSLog(@"4");
    //    });
    
    
    NSLog(@"playvideo 后面的线程");
    NSLog(@"playVideo11 :");
    
    playState = NO;
    
    NSLog(@"timerState:22 %@",timerState);
    NSLog(@"playState:111111 %d",playState);
    [timerState invalidate];
    timerState = nil;
    NSLog(@"timerState:33 %@",timerState);
    //    if (! playState ) {
    //   NSLog(@"playState:2222222 %d",playState);
    ////        NSInteger  timerIndex = 1;
    ////        NSNumber * timerNum = [NSNumber numberWithInteger:timerIndex];
    ////        NSDictionary *myDictionary = [[NSDictionary alloc] initWithObjectsAndKeys: timerNum,@"oneNum",nil];
    //        //此处给禁止了
    //        playNumCount = 1;
    //        timerState =   [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playClick) userInfo:nil repeats:YES];
    //        NSLog(@"timerState:11 %@",timerState);
    //    }
    
    
    
    [self.timer invalidate];
    self.timer = nil;
    
    //    self.video.startTime =@"1494299017";
    //    self.event_startTime = @"1494299017";
    //    self.video.endTime = @"1494328517";
    //    self.event_endTime = @"1494328517";
    
    //** 计算进度条
    if(self.event_startTime.length != 0 || self.event_endTime.length != 0)
    {
        [self.view addSubview:self.topProgressView];
        [self.view bringSubviewToFront:self.topProgressView];
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        NSLog(@"self.event_startTime--==%@",self.event_startTime);
        NSLog(@"self.event_startTime--==%@",self.event_endTime);
        if (ISNULL(self.event_startTime) || self.event_startTime == NULL || self.event_startTime == nil || ISNULL(self.event_endTime) || self.event_endTime == NULL || self.event_endTime == nil || self.event_startTime.length == 0 || self.event_endTime.length == 0) {
            
            NSLog(@"此处可能报错，因为StarTime不为空 ");
            NSLog(@"z在getDataService里面调用 replaceEventNameNotific");
            [self removeProgressNotific];
        }else
        {
            NSLog(@"self.event_startTime 开始结束2--==%@",self.event_startTime);
            NSLog(@"self.event_startTime 结束开始2--==%@",self.event_endTime);
            
            [dict setObject:self.event_startTime forKey:@"StarTime"];
            [dict setObject:self.event_endTime forKey:@"EndTime"];
            
            
            
            //判断当前是不是一个节目（此处应该没有实质价值）
            eventName1 = self.event_videoname;
            eventName2 = self.event_videoname;
            //        eventNameTemp ;
            eventNameTemp = eventName1;
            if (eventName2 != eventNameTemp) {
                // 不同的节目   @"同一个节目";
            }else
            {
                //@"同一个节目";
                eventName2 = eventNameTemp;
                
                //        NSLog(@"dict.start :%@",[dict objectForKey:@"StarTime"]);
                
                
                progressEPGArrIndex = 0;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress:) userInfo:dict repeats:YES];
                
                int tempIndex =progressEPGArrIndex;
                NSString * tempIndexStr = [NSString stringWithFormat:@"%d",tempIndex];
                [USER_DEFAULT setObject:tempIndexStr  forKey:@"nowChannelEPGArrIndex"];
                //此处应该加一个方法，判断 endtime - starttime 之后，让进度条刷新从新计算
                NSInteger endTime =[self.event_endTime intValue ];
                //                NSInteger startTime =[self.event_startTime intValue ];
                NSDate *senddate = [NSDate date];
                
                //                NSLog(@"date1时间戳 = %ld",time(NULL));
                NSString *nowDate = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
                NSInteger endTimeCutStartTime =endTime-[nowDate integerValue];
                
                NSLog(@"djbaisbdoabsdbaisbdiuabsdub");
                NSLog(@"replaceEventNameNotific 计算进度条的里面");
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressRefresh) object:nil];
                [self performSelector:@selector(progressRefresh) withObject:nil afterDelay:endTimeCutStartTime];
                
                NSLog(@"计算差值：endTimeCutStartTime:%d",endTimeCutStartTime);
                
            }
        }
        //        if (ISNULL(self.event_startTime) || self.event_startTime == NULL || self.event_startTime == nil) {
        //
        //        }else
        //        {
        //            NSLog(@"此处可能报错，因为StarTime不为空 ");
        //
        //        }
        
        
        
        
    }else{
        
        [self.topProgressView removeFromSuperview];  //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
        [self.timer invalidate];
        self.timer = nil;
        
        
    }
    //**
    NSLog(@"---urlData接收页面下面的video.playurl%@",self.video.playUrl);
    
    
    NSString * str = [NSString stringWithFormat:@"%@",self.video.playUrl];
    
    //    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"data信息"message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    [alertview show];
    
    
}
-(void)runThread1
{ NSLog(@"playvideo 的--线程");
    //    if (playState == NO) {
    //        [self playVideo];
    //        [self performSelector:@selector(runThread1) withObject:nil afterDelay:2];
    //    }
    //
    //     NSLog(@"playvideo 的++线程");
    
    //    if (playState == NO) {
    //        [self playVideo];
    //        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runThread1) object:nil];
    ////        [self performSelector:@selector(runThread1) withObject:nil afterDelay:1];
    //    }else
    //    {
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runThread1) object:nil];
    //    }
    
    [self playVideo];
    double delayInSeconds = 1;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, mainQueue, ^{
        NSLog(@"延时执行的2秒");
        //        [self abcd];
        [self playVideo];
    });
}
//-(void)abcd
//{
//    [self playVideo];
//    double delayInSeconds = 0.5;
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, mainQueue, ^{
//        NSLog(@"延时执行的2秒");
//        [self playVideo];
//    });
//}
#pragma 进度条刷新
-(void)progressRefresh
{
    NSLog(@" 进入了一次progressRefresh  replaceEventNameNotific ");
    progressEPGArrIndex = progressEPGArrIndex +1;
    [self.topProgressView removeFromSuperview];
    [self.timer invalidate];
    self.timer = nil;
    
    if(isEventStartTimeBiger_NowTime == YES) //加一个判断，防止EPG的第一个数据的开始时间大于当前时间
    {
        progressEPGArrIndex = progressEPGArrIndex - 1;
    }else
    {
        
    }
    
    
    
    NSLog(@"progressRefresh");
    //    progressEPGArr
    NSLog(@"progressEPGArr.count %d",progressEPGArr.count);
    if (progressEPGArr.count - 1<progressEPGArrIndex) //如果索引过大，则停止
    {
        NSLog(@"abcd");
        //如果EPG的数组数少于索引数量，那么可能是超过一天的播放时长了，这里可以重新加载一次获取数据
    }
    else{
        NSLog(@"progressEPGArrIndex %d",progressEPGArrIndex);
        NSInteger abcd = progressEPGArr.count -1;
        if(progressEPGArrIndex <= abcd){
            NSInteger abcd = progressEPGArr.count -1;
            NSLog(@"abcd== %d",abcd);
            if (1 <= -1) {
                NSLog(@"func");
            }
            if(![[progressEPGArr[progressEPGArrIndex]objectForKey:@"event_starttime"] isEqualToString:@""])
                
            {
                NSLog(@"progressEPGArrIndex lal :%d",progressEPGArrIndex);
                int tempIndex =progressEPGArrIndex;
                NSString * tempIndexStr = [NSString stringWithFormat:@"%d",tempIndex];
                [USER_DEFAULT setObject:tempIndexStr  forKey:@"nowChannelEPGArrIndex"];
                
                NSLog(@"progressEPGArrIndex22 lal :%d", [tempIndexStr intValue]);
                // 如果索引大于epg数组的长度或者没有开始时间
                NSNotification *notification =[NSNotification notificationWithName:@"TimerOfEventTimeNotific" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                
                
                self.event_videoname = [progressEPGArr[progressEPGArrIndex] objectForKey:@"event_name"];
                //=======
                //刷新节目名称
                //        self.video.playEventName = self.event_videoname;
                self.video.playEventName = self.event_videoname;
                NSNotification *replaceEventNameNotific =[NSNotification notificationWithName:@"replaceEventNameNotific" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:replaceEventNameNotific];
                NSLog(@"replaceEventNameNotific 的通知发出去了");
                //======
                
                
                self.event_startTime = [progressEPGArr[progressEPGArrIndex] objectForKey:@"event_starttime"];
                self.event_endTime = [progressEPGArr[progressEPGArrIndex] objectForKey:@"event_endtime"];
                //把节目时间通过通知发送出去
                
                //** 计算进度条
                if(self.event_startTime.length != 0 || self.event_endTime.length != 0)
                {
                    [self.view addSubview:self.topProgressView];
                    [self.view bringSubviewToFront:self.topProgressView];
                    
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                    NSLog(@"progressRefreshself.event_startTime--==%@",self.event_startTime);
                    NSLog(@"progressRefreshself.event_startTime--==%@",self.event_endTime);
                    if (ISNULL(self.event_startTime) || self.event_startTime == NULL || self.event_startTime == nil || ISNULL(self.event_endTime) || self.event_endTime == NULL || self.event_endTime == nil || self.event_startTime.length == 0 || self.event_endTime.length == 0) {
                        
                        NSLog(@"此处可能报错，因为StarTime不为空 ");
                        NSLog(@"z在progressRefresh里面调用 replaceEventNameNotific");
                        [self removeProgressNotific];
                    }else
                    {
                        NSLog(@"self.event_startTime 开始结束2--==%@",self.event_startTime);
                        NSLog(@"self.event_startTime 结束开始2--==%@",self.event_endTime);
                        
                        [dict setObject:self.event_startTime forKey:@"StarTime"];
                        [dict setObject:self.event_endTime forKey:@"EndTime"];
                        
                        
                        
                        //判断当前是不是一个节目
                        eventName1 = self.event_videoname;
                        eventName2 = self.event_videoname;
                        //        eventNameTemp ;
                        eventNameTemp = eventName1;
                        if (!eventName2 == eventNameTemp) {
                            // 不同的节目   @"同一个节目";
                        }else
                        {
                            //@"同一个节目";
                            eventName2 = eventNameTemp;
                            
                            //        NSLog(@"dict.start :%@",[dict objectForKey:@"StarTime"]);
                            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress:) userInfo:dict repeats:YES];
                            
                            //此处应该加一个方法，判断 endtime - starttime 之后，让进度条刷新从新计算
                            NSInteger endTime =[self.event_endTime intValue ];
                            NSDate *senddate = [NSDate date];
                            
                            //                    NSLog(@"date1时间戳 = %ld",time(NULL));
                            NSString *nowDate = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
                            NSInteger endTimeCutStartTime =endTime-[nowDate integerValue];
                            
                            NSLog(@"pregressfresh进度条的地方replaceEventNameNotific");
                            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressRefresh) object:nil];
                            [self performSelector:@selector(progressRefresh) withObject:nil afterDelay:endTimeCutStartTime];
                        }
                    }
                    //        if (ISNULL(self.event_startTime) || self.event_startTime == NULL || self.event_startTime == nil) {
                    //
                    //        }else
                    //        {
                    //            NSLog(@"此处可能报错，因为StarTime不为空 ");
                    //
                    //        }
                    
                    
                    
                    
                }else{
                    
                    [self.topProgressView removeFromSuperview];  //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
                    [self.timer invalidate];
                    self.timer = nil;
                    
                    
                }
                
            }
            else
            {
                [self.topProgressView removeFromSuperview];
                [self.timer invalidate];
                self.timer = nil;
                return;
                //        [self removeProgressNotific];
            }
        }else
        {
            [self.topProgressView removeFromSuperview];
            [self.timer invalidate];
            self.timer = nil;
            return;
            //        [self removeProgressNotific];
        }
    }
}
-(void)removeLineProgressNotific//进度条的时间不对，发送消除的通知
{
    //    此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeProgressNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressNotific) name:@"removeProgressNotific" object:nil];
    
}
-(void)removeProgressNotific
{
    //    [self.topProgressView removeFromSuperview];
    //    [self.timer invalidate];
    //    self.timer = nil;
    
    
    
    if (self.event_endTime == NULL ) {
        [self.topProgressView removeFromSuperview];
        [self.timer invalidate];
        self.timer = nil;
    }else
    {
        //此处应该加一个方法，判断 endtime - starttime 之后，让进度条刷新从新计算
        NSInteger endTime =[self.event_endTime intValue ];
        //                NSInteger startTime =[self.event_startTime intValue ];
        NSDate *senddate = [NSDate date];
        
        //    NSLog(@"date1时间戳 = %ld",time(NULL));
        NSString *nowDate = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
        NSInteger endTimeCutStartTime =endTime-[nowDate integerValue];
        
        //    NSLog(@"endTimeCutStartTime :%d",endTimeCutStartTime);
        //    NSLog(@"djbaisbdoabsdbaisbdiuabsdub");
        
        NSLog(@" 删除进度条的地方replaceEventNameNotific");
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressRefresh) object:nil];
        [self performSelector:@selector(progressRefresh) withObject:nil afterDelay:endTimeCutStartTime];  //记录一个结束时间，到达这个时间点后需要刷新进度条
    }
    
    
    
    
    
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
    NSLog(@"self.video.dicSubAudio :%",self.video.dicSubAudio);
    
    //    NSLog(@"self.TVChannlDic 4:%lu",(unsigned long)self.TVChannlDic.count);
    //    if (tempBoolForServiceArr == YES) {
    ////        if ( tempDicForServiceArr.count !=0) {
    ////            self.video.dicChannl = tempDicForServiceArr;
    ////        }else
    ////        {
    ////            self.video.dicChannl = self.TVChannlDic;
    ////        }
    //        self.video.dicChannl = [tempDicForServiceArr mutableCopy];
    //        self.video.channelCount = tempArrForServiceArr.count;
    ////    self.video.dicChannl = self.TVChannlDic;
    ////      self.video.channelCount =  self.categoryModel.service_indexArr.count;
    //        NSLog(@"self.video.dicChannl %@",tempDicForServiceArr);
    //    }else
    //    {
    //        self.video.dicChannl = [self.TVChannlDic mutableCopy];
    //        //self.dicTemp
    //        if (self.dicTemp.count >0 && self.video.dicChannl.count == 0) {
    //            self.video.dicChannl = self.dicTemp;
    //        }
    //    self.video.channelCount = self.categoryModel.service_indexArr.count;
    //    }
    //
    //    NSLog(@"tempDicForServiceArr %@",tempDicForServiceArr);
    //    NSLog(@"self.video.dicChannl %@",self.video.dicChannl);
    //    NSLog(@"self.video.channelCount %d",self.video.channelCount);
    
}

//row 代表是service的每个类别下的序列是几，dic代表每个类别下的service
-(void)touchSelectChannel :(NSInteger)row diction :(NSDictionary *)dic
{
    tempBoolForServiceArr = YES;
    tempArrForServiceArr =  self.categoryModel.service_indexArr;
    tempDicForServiceArr = self.TVChannlDic;
    
    NSLog(@"self.socket:%@",self.socketView);
    
    //先传输数据到socket，然后再播放视频
    //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",row]];
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    
    //     socketView.socket_ServiceModel.service_character = [epgDicToSocket objectForKey:@"service_character"]; //新加了一个service_character
    
    //    if (socketView.socket_ServiceModel.service_character != NULL && socketView.socket_ServiceModel.service_character != nil) {
    //        BOOL isJudgeEncrypt = NO;
    //         isJudgeEncrypt=  [self isSTBDEncrypt:socketView.socket_ServiceModel.service_character];
    //        if (isJudgeEncrypt == YES) {
    //            [self popSTBAlertView]; //此时执行弹窗
    //        }else //正常播放的步骤
    //        {
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
    socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
    
    NSLog(@"socketView.socket_ServiceModel.subt_pid :%@",socketView.socket_ServiceModel.subt_pid );
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
    isEventStartTimeBiger_NowTime = NO;
    BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
    if (isEventStartTimeBigNowTime == YES) {
        self.event_videoname = @"";
        self.event_startTime = @"";
        self.event_endTime = @"";
    }
    //            self.TVSubAudioDic = [[NSDictionary alloc]init];
    self.TVSubAudioDic = epgDicToSocket;
    //            self.TVChannlDic = [[NSDictionary alloc]init];
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
    
    
    [self getsubt];
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
    
    
    //    self.socketView  = [[SocketView  alloc]init];
    //    [self.socketView viewDidLoad];
    
    NSLog(@"self.socket:%@",self.socketView);
    
    self.videoController.socketView1 = self.socketView;
    [self.socketView  serviceTouch ];
    
    
    //        }
    //    }
    
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
    NSLog(@"val :%d",val);
    if (val == 0)  {
        //调用GGutil的方法
        NSLog(@"返回数据正常");
        _byteDatas =  [GGUtil convertNSDataToByte:[USER_DEFAULT objectForKey:@"data_service"] bData:[USER_DEFAULT objectForKey:@"data_service11"]];
    }
    else if(val == 1)
    {
        NSLog(@"CRC 错误");
        
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
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
        
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else if(val == 5)
    {
        NSLog(@"密码正确");
    }
    else if(val == 6)
    {
        NSLog(@"密码错误");
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else if(val == 7)
    {
        NSLog(@"停止错误");
        
    }
    else if(val == 8)
    {
        NSLog(@"得到资源错误");
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else if(val == 9)
    {
        NSLog(@"服务器停止分发");
        
    }
    else if(val == 10)
    {
        NSLog(@"无效");
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

-(void)addHistory:(NSInteger)row diction :(NSDictionary *)dic
{
    //   tempBoolForServiceArr = YES;
    //    tempArrForServiceArr =  self.categoryModel.service_indexArr;
    //    tempDicForServiceArr = self.TVChannlDic;
    //    [self getsubt];
    //加载圈动画
    //创建通知  如果视频要播放呀，则去掉不能播放的字样
    NSNotification *notification1 =[NSNotification notificationWithName:@"noPlayShowShutNotic" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    
    NSNotification *notification =[NSNotification notificationWithName:@"IndicatorViewShowNotic" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //
    
    
    // 1.获得点击的视频dictionary数据
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%d",row]];
    
    
    NSLog(@"epgDicToSocket %@",epgDicToSocket );
    NSLog(@"audio_Pid  %@",[[epgDicToSocket objectForKey:@"audio_info"][0]objectForKey:@"audio_pid"]);
    NSLog(@"audio_language  %@",[[epgDicToSocket objectForKey:@"audio_info"][0]objectForKey:@"audio_language"]);
    //    [self storeNowDicForEventName :epgDicToSocket]; //epgDicToSocket是当前正在播放的节目信息，将他存储起来，用作切换eventName
    [self judgeNowISRadio:epgDicToSocket]; //此处加个方法，判断是不是音频
    progressEPGArr =[epgDicToSocket objectForKey:@"epg_info"];  //新加的，为了进度条保存EPG数据
    
    [USER_DEFAULT setObject:[progressEPGArr copy] forKey:@"NowChannelEPG"];
    [USER_DEFAULT setObject:epgDicToSocket forKey:@"NowChannelDic"];
    //这里还用作判断播放的焦点展示
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
        //        NSLog(@"mutaArray[0] :%@",mutaArray[0]);
        //        NSLog(@"mutaArray[1] :%@",mutaArray[1]);
        //        NSLog(@"mutaArray[2] :%@",mutaArray[2]);
        //        NSLog(@"mutaArray[3] :%@",mutaArray[3]);
        //新添加的数据
        NSString * newservice_network =  [epgDicToSocket objectForKey:@"service_network_id"];
        NSString * newservice_ts =  [epgDicToSocket objectForKey:@"service_ts_id"];
        NSString * newservice_service =  [epgDicToSocket objectForKey:@"service_service_id"];
        NSString * newservice_tuner =  [epgDicToSocket objectForKey:@"service_tuner_mode"];
        
        if ([service_network isEqualToString:newservice_network] && [service_ts isEqualToString:newservice_ts] && [service_tuner isEqualToString:newservice_tuner] && [service_service isEqualToString:newservice_service]) {
            addNewData = NO;
            
            NSArray * equalArr = mutaArray[i];
            NSMutableArray * tempArr = [equalArr mutableCopy];
            //            [tempArr[3] removeLastObject];
            //            [tempArr[3] addObject:dic];
            //            [tempArr insertObject:dic atIndex:3];
            NSString * seedNowTime = [GGUtil GetNowTimeString];
            NSNumber *aNumber = [NSNumber numberWithInteger:row];
            [tempArr replaceObjectAtIndex:1 withObject:seedNowTime];
            [tempArr replaceObjectAtIndex:2 withObject:aNumber];
            [tempArr replaceObjectAtIndex:3 withObject:dic];
            NSLog(@"tempArr :%@",tempArr);
            //            equalArr = [tempArr copy];
            
            
            
            [mutaArray removeObjectAtIndex:i];
            [mutaArray  addObject:[tempArr copy]];
            
            NSLog(@"mutaArray: %@",mutaArray);
            //            [mutaArray replaceObjectAtIndex:i withObject:[tempArr copy]]
            break;
        }
        
        
    }
    //    }
    if (addNewData == YES) {
        NSString * seedNowTime = [GGUtil GetNowTimeString];
        NSNumber *aNumber = [NSNumber numberWithInteger:row];
        NSArray * seedNowArr = [NSArray arrayWithObjects:epgDicToSocket,seedNowTime,aNumber,dic,nil];
        NSLog(@"seedNowArr : %@",seedNowArr);
        NSLog(@"dic : %@",dic);
        
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
    //获取播放的第一个节目信息
    if (myArray.count <1) {   //第一次打开APP的时候，历史为空
        storeLastChannelArr = nil;
    }else
    {
        storeLastChannelArr = myArray[myArray.count - 1];
    }
    
    NSLog(@"获取播放的第一个节目信息 成功");
    [USER_DEFAULT setObject:myArray forKey:@"historySeed"];
    
    
    //    NSLog(@"myarray:%@",myArray[3]);
    //    NSLog(@"myarray:%@",myArray[2]);
    //    NSLog(@"myarray:%@",myArray[2][0]);
    
    MEViewController * meview = [[MEViewController alloc]init];
    [meview viewDidAppear:YES];
    [meview viewDidLoad];
    
}
//-(void)storeNowDicForEventName :(NSDictionary *)Nowdic  //存储名称和时间，时间到了刷新名称
//{
//
//    NSArray * epg_infoArr = [Nowdic objectForKey:@"epg_info"];
//    //发送通知
//
//    NSMutableArray * epg;
//    for (int i = 0; i<epg_infoArr.count; i++) {
////        self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
////        self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
//    }
////    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
////    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
////    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
//
//    //[USER_DEFAULT setObject:Nowdic forKey:@"NowDicForEventName"];
//
//
//}
-(void)judgeNowISRadio :(NSDictionary *)nowVideoDic  //判断当前播放时视频还是音频
{
    NSString * radioServiceType = [nowVideoDic objectForKey:@"service_type"];
    if ([radioServiceType isEqualToString:@"4"]) { //视频是1  音频是4
        NSLog(@"此时播放的是音频");
        //发送通知，显示音频图片
        //如果不能播放，则显示sorry , radio 不能播放
        
        
        [USER_DEFAULT setObject:@"radio" forKey:@"videoOrRadioPlay"];
        [USER_DEFAULT setObject:@"sorry, this radio can't play" forKey:@"videoOrRadioTip"];
        
    }else { //视频是1  音频是4
        NSLog(@"此时播放的是视频");
        //发送通知，取消掉视频通知
        
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"removeConfigRadioShowNotific" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [USER_DEFAULT setObject:@"video" forKey:@"videoOrRadioPlay"];
        [USER_DEFAULT setObject:@"sorry, this video can't play" forKey:@"videoOrRadioTip"];
    }
}
//引导页
- (void)viewWillAppear:(BOOL)animated{
    
    //            NSArray * serviceArrForJudge =  self.serviceData;
    //            NSDictionary * fourceDic = [USER_DEFAULT objectForKey:@"NowChannelDic"];  //这里获得当前焦点
    //        NSLog(@"aaaaaa=====  %@",fourceDic);
    //            for (int i = 0; i< serviceArrForJudge.count; i++) {
    //                NSDictionary * serviceForJudgeDic = serviceArrForJudge[i];
    //
    //                if ([serviceForJudgeDic isEqualToDictionary:fourceDic]) {
    //
    //                    int indexForJudgeService = i;
    //                    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:indexForJudgeService inSection:0];
    //
    //                    [tableForSliderView scrollToRowAtIndexPath:scrollIndexPath  atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //                }
    //            }
    
    //    NSArray * serviceArrForJudge =  self.serviceData;
    //    //    NSDictionary * fourceDic = [USER_DEFAULT objectForKey:@"NowChannelDic"];  //这里获得当前焦点
    //    NSArray * arrForServiceByCategory = [self.categorys[indexOfCategory] objectForKey:@"service_index"];
    //    for (int i = 0; i< arrForServiceByCategory.count; i++) {
    //        NSDictionary * serviceForJudgeDic = arrForServiceByCategory[i];
    //
    //        if ([serviceForJudgeDic isEqualToDictionary:epgDicToSocket]) {
    //
    //            int indexForJudgeService = i;
    //            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:indexForJudgeService inSection:0];
    //
    //            [tableForSliderView scrollToRowAtIndexPath:scrollIndexPath  atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //        }
    //    }
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
        self.tabBarController.tabBar.hidden = YES;
        firstShow = NO;
        statusNum = 0;
        [self prefersStatusBarHidden];
        
        [self addGuideView]; //添加引导图
        [self performSelector:@selector(notHaveNetWork) withObject:nil afterDelay:60];
        
    }else{
        //        [USER_DEFAULT setObject:@"NO" forKey:@"modeifyTVViewRevolve"];
        NSLog(@"不是第一次启动");
        [self performSelector:@selector(notHaveNetWork) withObject:nil afterDelay:10];
        [USER_DEFAULT setBool:NO forKey:@"lockedFullScreen"];  //解开全屏页面的锁
        [USER_DEFAULT setBool:NO forKey:@"isFullScreenMode"];  //判断是不是全屏模式
        [self preventTVViewOnceFullScreen];
        //        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
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
        
        viewDidloadHasRunBool =  [[USER_DEFAULT objectForKey:@"viewDidloadHasRunBool"] intValue];
        if (viewDidloadHasRunBool == 0) {
            [self getServiceData];    //获取表数据
            
            
            viewDidloadHasRunBool = 1;
            [USER_DEFAULT setObject:[NSNumber numberWithInt:viewDidloadHasRunBool] forKey:@"viewDidloadHasRunBool"];
            
            
        }else{
            [self getServiceDataNotHaveSocket];    //获取表数据的不含有socket 的初始化方法
        }
        
        //        [self initProgressLine];
        //        [self getSearchData];
        [self setIPNoific];
        [self setHMCChangeNoific];  //新加，简历新的通知，当HMC改变时发送通知
        [self setVideoTouchNoific];   //其他页面的点击播放视频的通知
        [self setVideoTouchNoificAudioSubt]; //全屏页面音轨字幕切换的通知
        [self newTunerNotific]; //新建一个tuner的通知
        [self socketGetIPAddressNotific]; //新建一个socket 获取IP地址的通知
        [self deleteTunerInfoNotific]; //新建一个删除tuner的通知
        [self allCategorysBtnNotific];
        [self removeLineProgressNotific]; //进度条停止的刷新通知
        [self refreshTableFocus];  //刷新tableView焦点颜色的通知
        [self mediaDeliveryUpdateNotific];   //机顶盒数据刷新，收到通知，节目列表也刷新
        [self STBDencryptNotific];   //机顶盒加密的通知
        [self CADencryptNotific];   //机顶盒加密的通知
        [self STBDencryptVideoTouchNotific];   //机顶盒加密后的播放通知
        //        [self timerStateInvalidateNotific];   //播放时的循环播放计时器关闭的通知
        //修改tabbar选中的图片颜色和字体颜色
        UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = image;
        [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
        
        //视频部分
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        
        
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars =NO;
        self.modalPresentationCapturesStatusBarAppearance =NO;
        self.navigationController.navigationBar.translucent =NO;
        
        if (firstfirst == YES) {
            [USER_DEFAULT setObject:@"NO" forKey:@"jumpFormOtherView"];
        }else
        {
            [self judgeJumpFromOtherView];
        }
        
    }
    
    NSLog(@"目前是sliderview:%f",_slideView.frame.origin.y);
}
#pragma mark -//如果是从其他的页面条转过来的，则自动播放上一个视频
-(void)judgeJumpFromOtherView //如果是从其他的页面条转过来的，则自动播放上一个视频
{
    NSString * jumpFormOtherView =  [USER_DEFAULT objectForKey:@"jumpFormOtherView"];
    if([jumpFormOtherView isEqualToString:@"YES"])
    {
        NSMutableArray * historyArr  =  (NSMutableArray *) [USER_DEFAULT objectForKey:@"historySeed"];
        NSLog(@"挖从奥到底dic come on");
        if (historyArr == NULL || historyArr.count == 0 || historyArr == nil) {
            
            NSInteger row = [storeLastChannelArr[2] integerValue];
            NSDictionary * dic = storeLastChannelArr [3];
            NSLog(@"挖从奥到底dic 00 %@",dic);
            NSNumber * numIndex = [NSNumber numberWithInt:row];
            
            //添加 字典，将label的值通过key值设置传递
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            NSLog(@"目前是judgeJumpFromOtherView");
            
            //        [self.videoController play];
            
            [USER_DEFAULT setObject:@"NO" forKey:@"jumpFormOtherView"];//为TV页面存储方法
        }else
        {
            NSArray * touchArr = historyArr[historyArr.count - 1];
            
            NSInteger row = [storeLastChannelArr[2] integerValue];
            NSDictionary * dic = storeLastChannelArr [3];
            NSLog(@"挖从奥到底dic 11 %@",dic);
            NSNumber * numIndex = [NSNumber numberWithInt:row];
            
            //添加 字典，将label的值通过key值设置传递
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            NSLog(@"目前是judgeJumpFromOtherView");
            
            //        [self.videoController play];
            
            [USER_DEFAULT setObject:@"NO" forKey:@"jumpFormOtherView"];//为TV页面存储方法
        }
        
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

#pragma mark - 通过socket获取路由器的IP地址
-(void)socketGetIPAddressNotific
{
    //新建一个发送tuner请求并且接受返回信息的通知   //3
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"socketGetIPAddressNotific" object:nil] ;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketGetIPAddress) name:@"socketGetIPAddressNotific" object:nil];
    
    
    
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
-(void)mediaDeliveryUpdateNotific
{
    //新建一个通知，用来监听机顶盒发出的节目列表更新的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mediaDeliveryUpdateNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaDeliveryUpdate) name:@"mediaDeliveryUpdateNotific" object:nil];
}
-(void)tableViewDataRefresh
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
        
        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            [self getStartTimeFromchannelListArr : data1]; //将获得data存到集合
        });
        
        
        
        
        if (!isValidArray(data1) || data1.count == 0){
            //            [self getServiceData];
            [self tableViewDataRefresh];
            return ;
        }
        self.serviceData = (NSMutableArray *)data1;
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        
        
        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
            //            [self getServiceData];
            [self tableViewDataRefresh];
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
            
            
            
            NSArray *data = response[@"category"];
            
            if (!isValidArray(data) || data.count == 0){
                return ;
            }
            self.categorys = (NSMutableArray *)data;
            
            //
            //            if (!_slideView) {
            //
            //
            //                //设置滑动条
            //                _slideView = [YLSlideView alloc];
            //                _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
            //                                                                  SCREEN_WIDTH,
            //                                                                  SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
            //
            //                NSArray *ArrayTocategory = [NSArray arrayWithArray:self.categorys];
            //                [USER_DEFAULT setObject:ArrayTocategory forKey:@"categorysToCategoryView"];
            //
            //                _slideView.backgroundColor = [UIColor whiteColor];
            //                _slideView.delegate        = self;
            //
            //                [self.view addSubview:_slideView];
            //                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
            //
            //            }
            //            else
            //            {
            //
            //            }
            
            //            [self.socketView viewDidLoad];
            if (firstfirst == YES) {
                
                
                //                [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                //                firstOpenAPP = firstOpenAPP+1;
                
                //                firstfirst = NO;
                
            }else
            {}
            
        }];
        
        
        //        [self initProgressLine];
        
        [self.table reloadData];
        
        
    }];
}
-(void)mediaDeliveryUpdate
{
    NSLog(@"//此时应该列表刷新11");
    
    
    
    BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
    if (isFullScreen == NO) {   //竖屏状态
        [_slideView removeFromSuperview];
        _slideView = nil;
        
        //    [self.table  removeFromSuperview];
        //    self.table = nil;
        //重新加载
        [self getMediaDeliverUpdate];
        
        
    }else //竖屏状态，不刷新
    {
    }
    
    
    
    
    
    
    
    
}
#pragma mark - 机顶盒发送通知，需要刷新节目了
-(void)getMediaDeliverUpdate
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
        
        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            [self getStartTimeFromchannelListArr : data1]; //将获得data存到集合
        });
        
        if (!isValidArray(data1) || data1.count == 0){
            //            [self getServiceData];
            [self getMediaDeliverUpdate];
            return ;
        }
        self.serviceData = (NSMutableArray *)data1;
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        
        //        NSLog(@"--------%@",self.serviceData);
        
        
        
        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
            //            [self getServiceData];
            [self getMediaDeliverUpdate];
        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        //        [self playVideo];
        
        
        //////
        //获取数据的链接
        NSString *urlCate = [NSString stringWithFormat:@"%@",S_category];
        
        
        LBGetHttpRequest *request = CreateGetHTTP(urlCate);
        
        
        
        [request startAsynchronous];
        
        WEAKGET
        [request setCompletionBlock:^{
            NSDictionary *response = httpRequest.responseString.JSONValue;
            
            
            
            NSArray *data = response[@"category"];
            
            if (!isValidArray(data) || data.count == 0){
                return ;
            }
            self.categorys = (NSMutableArray *)data;
            
            
            if (!_slideView) {
                NSLog(@"上山打老虎3");
                //判断是不是全屏
                BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
                if (isFullScreen == NO) {   //竖屏状态
                    
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                    
                    NSArray *ArrayTocategory = [NSArray arrayWithArray:self.categorys];
                    [USER_DEFAULT setObject:ArrayTocategory forKey:@"categorysToCategoryView"];
                    NSLog(@"ArrayTocategory %@",ArrayTocategory);
                    NSLog(@"self.dicTemp %@",self.dicTemp);
                    _slideView.backgroundColor = [UIColor whiteColor];
                    _slideView.delegate        = self;
                    
                    [self.view addSubview:_slideView];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                    
                    
                }else //横屏状态，不刷新
                {
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                    
                    NSArray *ArrayTocategory = [NSArray arrayWithArray:self.categorys];
                    [USER_DEFAULT setObject:ArrayTocategory forKey:@"categorysToCategoryView"];
                    NSLog(@"ArrayTocategory %@",ArrayTocategory);
                    NSLog(@"self.dicTemp %@",self.dicTemp);
                    _slideView.backgroundColor = [UIColor whiteColor];
                    _slideView.delegate        = self;
                    
                    [self.view addSubview:_slideView];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                }
                
                
                
                
            }
            else
            {
                
            }
            
            [self judgeVideoByDelete];
            
            //            NSArray * arrHistoryNow = [USER_DEFAULT objectForKey:@"historySeed"];
            //            NSLog(@"history Arr0: %@",arrHistoryNow[0][0]);  //wor
            //            NSLog(@"history Arr1: %@",arrHistoryNow[1][0]);  //wor
            //            NSLog(@"history Arr2: %@",arrHistoryNow[2][0]);  //wor
            //            NSLog(@"history Arr6: %@",arrHistoryNow[6][0]);  //wor
            //            NSLog(@"history Arr22: %@",[self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",0]]);  //wor
            //
            //
            //            for (int i = 0; i<self.dicTemp.count; i++) {
            //                [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",i]];
            //                NSLog(@"i - 1%d",(i));
            //
            //
            //                if ([arrHistoryNow[6][0] isEqual: [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",i]]]) { //此处判断，如果被播放的视频被删除了，则播放第一个
            //                    NSLog(@"aaabbbb");
            //                                }
            //                else{
            //                 [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
            //                    NSLog(@"asdasdasdasdasdasdasdasdasdasdas");
            //                }
            //            }
            ////                if (![self.dicTemp isEqualToArray:self.dicTemp]) { //此处判断，如果被播放的视频被删除了，则播放第一个
            ////                    [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
            ////                }
            //
            //
            ////            [self.socketView viewDidLoad];
            if (firstfirst == YES) {
                
                
                //                [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                //                firstOpenAPP = firstOpenAPP+1;
                
                //                firstfirst = NO;
                
            }else
            {}
            
        }];
        
        
        //        [self initProgressLine];
        
        [self.table reloadData];
        
        
    }];
    
    
}
//判断列表变化后，是否把正在播放的那个节目给删除了，如果是的，则刷新列表，并且重新播放第一个视频
-(void)judgeVideoByDelete
{
    
    NSArray * arrHistoryNow = [USER_DEFAULT objectForKey:@"historySeed"];   //播放的历史老师
    
    //    NSLog(@"history Arr6: %@",arrHistoryNow[arrHistoryNow.count -1][0]);  //历史中正在播放的第一个节目
    //    NSLog(@"history Arr22: %@",[self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",0]]);  //wor
    NSLog(@"history Arr22:");
    BOOL allisNO = YES ; //表示当前播放的节目不存在新的列表中，证明节目被刷新没了，所以需要重新播放第一个节目
    for (int i = 0; i<self.dicTemp.count; i++) {
        [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",i]];   //循环查找self.dicTemp 看有没有历史中的这个节目
        NSLog(@"i - 1%d",(i));
        
        
        //原始数据
        NSString * service_network =  [[self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"service_network_id"];
        NSString * service_ts =  [[self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"service_ts_id"];
        NSString * service_service =  [[self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"service_service_id"];
        NSString * service_tuner =  [[self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"service_tuner_mode"];
        
        NSString * newservice_network ;
        NSString * newservice_ts ;
        NSString * newservice_service ;
        NSString * newservice_tuner ;
        //新添加的数据
        if(arrHistoryNow.count >= 1)
        {
            newservice_network =  [arrHistoryNow[arrHistoryNow.count -1][0] objectForKey:@"service_network_id"];
            newservice_ts =  [arrHistoryNow[arrHistoryNow.count -1][0] objectForKey:@"service_ts_id"];
            newservice_service =  [arrHistoryNow[arrHistoryNow.count -1][0] objectForKey:@"service_service_id"];
            newservice_tuner =  [arrHistoryNow[arrHistoryNow.count -1][0] objectForKey:@"service_tuner_mode"];
            
            
            
            if ([service_network isEqualToString:newservice_network] && [service_ts isEqualToString:newservice_ts] && [service_tuner isEqualToString:newservice_tuner] && [service_service isEqualToString:newservice_service]) {
                //证明节目存在，不需要刷新
                NSLog(@"aaabbbb");
                allisNO = NO;
            }
            else{
                //            [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                NSLog(@"asdasdasdasdasdasdasdasdasdasdas");
            }
            
        }
        
        
        //        if ([arrHistoryNow[6][0] isEqual: [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",i]]]) { //此处判断，如果被播放的视频被删除了，则播放第一个
        //            NSLog(@"aaabbbb");
        //        }
        //        else{
        //            [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
        //            NSLog(@"asdasdasdasdasdasdasdasdasdasdas");
        //        }
    }
    if (allisNO == NO) {
        NSLog(@"不刷新");
    }else
    {
        //刷新
        //=======机顶盒加密
        NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:0 serviceListDic:self.dicTemp];
        if (characterStr != NULL && characterStr != nil) {
            BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
            if (judgeIsSTBDecrypt == YES) {
                // 此处代表需要记性机顶盒加密验证
                NSNumber  *numIndex = [NSNumber numberWithInteger:0];
                NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"firstOpenTouch",@"textThree",nil];
                //创建通知
                NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                NSLog(@"POPPOPPOPPOP44444444444441");
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification1];
                
                firstOpenAPP = firstOpenAPP+1;
                
                firstfirst = NO;
            }else //正常播放的步骤
            {
                //======
                [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                firstOpenAPP = firstOpenAPP+1;
                
                firstfirst = NO;
            }
        }else //正常播放的步骤
        {
            //======机顶盒加密
            [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
        }
    }
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

#pragma mark - 通过socket获取机顶盒路由器
-(void)socketGetIPAddress
{
    //获取分发资源信息
    [self.socketView csGetRouteIPAddress];
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
-(void)viewDidDisappear:(BOOL)animated
{
    self.video.playUrl = @"";
    //    [self playVideo];
    [self.videoController stop];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.video.playUrl = @"";
    //    [self playVideo];
    [self.videoController stop];
    
}
-(void)setIPNoific
{
    
    //新建一个发送IP 改变的消息的通知   //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IPHasChanged" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IPHasChanged) name:@"IPHasChanged" object:nil];
    
}
//其他页面的播放通知
-(void)setVideoTouchNoific
{
    
    //新建一个发送IP 改变的消息的通知   //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VideoTouchNoific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoTouchNoificClick :) name:@"VideoTouchNoific" object:nil];
    
}
//全屏页面的音轨字幕的切换
-(void)setVideoTouchNoificAudioSubt
{
    
    //新建一个发送IP 改变的消息的通知   //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VideoTouchNoificAudioSubt" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoTouchNoificAudioSubtClick :) name:@"VideoTouchNoificAudioSubt" object:nil];
    
}
-(void)setHMCChangeNoific
{
    
    //新建一个发送IP 改变的消息的通知   //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HMCHasChanged" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HMCHasChanged) name:@"HMCHasChanged" object:nil];
    
}
-(void)HMCHasChanged
{
    NSLog(@"执行方法 HMC 改变了");
    //    [self getServiceData];
    [self getServiceDataForIPChange];
    
}
-(void)IPHasChanged
{
    
    
    NSLog(@"执行方法  IP地址改变了");
    //    [self getServiceData];
    [self getServiceDataForIPChange];
}
-(void)setStateNonatic
{
    //新建一个发送播放通知
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MPMediaPlaybackIsPreparedToPlayDidChangeNotification" object:nil];
    //    //注册通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willplay) name:@"MPMediaPlaybackIsPreparedToPlayDidChangeNotification" object:nil];
    //两者都响应一个方法
    //    [NSThread sleepForTimeInterval:4];
    //    if (playState == 0) {
    //        [NSThread sleepForTimeInterval:1];
    //    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willplay) name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:nil];
    
    // 播放状态改变，可配合playbakcState属性获取具体状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willplay) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    
    // 媒体网络加载状态改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
}
//-(void)timerStateInvalidateNotific
//{
//    //
//    //此处销毁通知，防止一个通知被多次调用    // 1
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"timerStateInvalidate" object:nil];
//    //注册通知,用来取消循环播放
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerStateInvalidate) name:@"timerStateInvalidate" object:nil];
//}
//-(void)timerStateInvalidate
//{
//    [timerState invalidate];
//    timerState = nil;
//    NSLog(@"右侧列表asdboasbdiasbidbasidbiasbdiasbdiasbdiuas");
//}
-(void)playClick  //:(NSTimer *)timer
{
    //     NSDictionary * dic =  [timer userInfo];
    //    NSNumber *
    playNumCount ++;
    NSLog(@"playState33333还在一遍一遍播放");
    NSLog(@"playState33333:%d",playState);
    NSLog(@"playState33333+playNumCount:%d", playNumCount);
    NSLog(@"(self.video.playUrl:%@",self.video.playUrl);
    
    if (playNumCount >= 8){  //如果大于次10，即大于8秒，则停止播放，循环结束，显示无法播放的标语
        NSLog(@"timerState now:%@",timerState);
        [timerState invalidate];
        timerState = nil;
        
        NSNotification *notification1 =[NSNotification notificationWithName:@"IndicatorViewHiddenNotic" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
        
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
        NSLog(@"timerState :%@",timerState);
        [timerState invalidate];
        timerState = nil;
        NSLog(@"timerState :%@",timerState);
    }else {//次数小于10，判断是否播放
        if ( self.video.playUrl != NULL && playState)
        {
            //如果已经播放，结束循环
            [timerState invalidate];
            timerState = nil;
            
            playNumCount = 0;
            NSLog(@"播放");
            
            NSLog(@"右侧列表消失 playClick1 %ld",(long)playNumCount);
            
        }else{
            //没有播放.接着循环
            ////            [self playVideo];
            
            
            self.videoController.contentURL = [NSURL URLWithString:self.video.playUrl];
            self.videoController.shouldAutoplay = YES;
            NSLog(@"playVideo 999");
            
            if (self.videoController.isPreparedToPlay == YES) {
                [self willplay];
            }
            ////            [self.videoController stop];
            ////            [self.videoController setMovieSourceType:MPMovieSourceTypeStreaming];
            ////            self.videoController.shouldAutoplay = YES;
            //            [self.videoController prepareToPlay];
            //            NSLog(@"playVideo22 :");
            //            NSLog(@"右侧列表消失 playClick2 %ld",(long)playNumCount);
        }
    }
    
    
}
-(void)willplay
{
    //创建通知  如果视频要播放呀，则去掉不能播放的字样
    NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowShutNotic" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSLog(@"playState44444现在正在准备播放，TV 页面willplay");
    playState = YES;
    [timerState invalidate];
    timerState = nil;
    NSString * videoOrRadioPlaystr = [USER_DEFAULT objectForKey:@"videoOrRadioPlay"];
    if ([videoOrRadioPlaystr isEqualToString:@"radio"]) {
        //发送通知，添加radio图片
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"configRadioShowNotific" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}
/// 媒体网络加载状态改变
- (void)onMPMoviePlayerLoadStateDidChangeNotification
{
    NSLog(@"MPMoviePlayer  LoadStateDidChange  Notification");
    NSLog(@"MPMoviePlayer  加载");
    if (MPMovieLoadStateUnknown) {
        NSLog(@"playState---=====状态未知");
    }
    if (self.videoController.loadState & MPMovieLoadStateStalled) {
        NSLog(@"playState111---.self.videoController.loadState %lu",(unsigned long)self.videoController.loadState);
        NSLog(@"playState---首页的暂停状态，就是将正在播放的暂停1111");
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(judegeIsPlaying) object:nil];
        [self performSelector:@selector(judegeIsPlaying) withObject:nil afterDelay:0.2];
        
    }
    else
    {
        if (MPMovieLoadStateUnknown) {
            NSLog(@"playState---=====状态未知");
        }if (MPMovieLoadStatePlayable) {
            NSLog(@"playState---=====缓存数据足够开始播放，但是视频并没有缓存完全");
        }if (MPMovieLoadStatePlaythroughOK) {
            NSLog(@"playState---=====已经缓存完成，如果设置了自动播放，这时会自动播放");
        }
        NSLog(@"MPMoviePlayer  停止加载");
        NSLog(@"playState---=====停止加载");
    }
}
-(void)judegeIsPlaying
{
    if (self.videoController.loadState & MPMovieLoadStateStalled) {
        NSLog(@"playState111---.self.videoController.loadState %lu",(unsigned long)self.videoController.loadState);
        NSLog(@"首页的暂停状态，就是将正在播放的暂停");
        NSLog(@"playState---首页的暂停状态，就是将正在播放的暂停2222");
        //        [self playVideo];
        //        [self.videoController pause];
        //        self.videoController.contentURL = [NSURL URLWithString:self.video.playUrl];
        //        NSLog(@"playVideo33 :");
        //        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(judegeIsPlaying) object:nil];
        //        [self performSelector:@selector(judegeIsPlaying) withObject:nil afterDelay:0.2];
        
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(judegeIsPlaying) object:nil];
    }
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
    NSLog(@"epgDicToSocket: %@",epgDicToSocket);
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
    NSLog(@"socketView.socket_ServiceModel.audio_pid :%@",socketView.socket_ServiceModel.audio_pid);
    socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
    NSLog(@"socketView.socket_ServiceModel.subt_pid :%@",socketView.socket_ServiceModel.subt_pid);
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
    //此处获得该EPG的当前信息，否则我们播放的信息还是它之前的信息
    for (int i = 0; i<self.serviceData.count; i++) {
        
        BOOL isYes =  [GGUtil judgeTwoEpgDicIsEqual:self.serviceData[i] TwoDic:epgDicToSocket]; //此处通过判断两个EPG信息是否相等来找到两个一样的EPG信息
        if(isYes == YES)
        {
            epgDicToSocket = self.serviceData[i];   //给epgDicToSocket 赋新值
        }
        else //没有找到
        {
            
        }
    }
    
    
    
    self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
    epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
    isEventStartTimeBiger_NowTime = NO;
    BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
    if (isEventStartTimeBigNowTime == YES) {
        self.event_videoname = @"";
        self.event_startTime = @"";
        self.event_endTime = @"";
    }
    //    self.TVSubAudioDic = [[NSDictionary alloc]init];
    self.TVSubAudioDic = epgDicToSocket;
    //    self.TVChannlDic = [[NSDictionary alloc]init];
    NSLog(@"self.TVChannlDic.count1 :%d",self.TVChannlDic.count);
    self.TVChannlDic = self.dicTemp;
    NSLog(@"self.TVChannlDic.count2 :%d",self.TVChannlDic.count);
    //*********
    
    //    tempBoolForServiceArr = YES;
    //    tempArrForServiceArr =  self.categoryModel.service_indexArr;
    //    tempDicForServiceArr = self.TVChannlDic;
    
    
    
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
    
    
    [self getsubt];
    //此处销毁通知，防止一个通知被多次调用    // 1   有可能不用，可以删除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
    
    
    //    self.socketView  = [[SocketView  alloc]init];
    //    [self.socketView viewDidLoad];
    
    NSLog(@"self.socket:%@",self.socketView);
    
    self.videoController.socketView1 = self.socketView;
    [self.socketView  serviceTouch ];
    
    
    //    double delayInSeconds = 0.5;
    //    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    //    dispatch_after(popTime, mainQueue, ^{
    //        NSLog(@"延时执行的2秒");
    //        ZXVideoPlayerController * abcdef = [[ZXVideoPlayerController alloc]init];
    //        [abcdef  fullScreenButtonClick];
    //    });
    
    int indexOfCategory = [self judgeCategoryType:epgDicToSocket]; //从别的页面跳转过来，要先判断节目的类别，然后让底部的category转到相应的类别下
    NSNumber * currentIndexForCategory = [NSNumber numberWithInt:indexOfCategory];
    NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndexForCategory,@"currentIndex", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.tableForSliderView reloadData];
    [self.table reloadData];
    //    self.table celltorow
    //    NSIndexPath * hahah = [NSIndexPath indexPathForRow:2 inSection:0];
    //    [_tableForTemp scrollToRowAtIndexPath:hahah  atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //    [tableForSliderView scrollToRowAtIndexPath:hahah  atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    NSArray * serviceArrForJudge =  self.serviceData;
    //    NSDictionary * fourceDic = [USER_DEFAULT objectForKey:@"NowChannelDic"];  //这里获得当前焦点
    NSArray * arrForServiceByCategory = [self.categorys[indexOfCategory] objectForKey:@"service_index"];
    //    for (int i = 0; i< arrForServiceByCategory.count; i++) {
    //        NSDictionary * serviceForJudgeDic = self.serviceData[[arrForServiceByCategory[i] intValue]-1];
    //
    //
    //        if ([serviceForJudgeDic isEqualToDictionary:epgDicToSocket]) {
    //
    //            int indexForJudgeService = i;
    //            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:indexForJudgeService inSection:0];
    //
    //            [tableForSliderView scrollToRowAtIndexPath:scrollIndexPath  atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //        }
    //    }
    
    
    //            NSArray * serviceArrForJudge =  self.serviceData;
    //            NSDictionary * fourceDic = [USER_DEFAULT objectForKey:@"NowChannelDic"];  //这里获得当前焦点
    for (int i = 0; i< arrForServiceByCategory.count; i++) {
        NSDictionary * serviceForJudgeDic = serviceArrForJudge[[arrForServiceByCategory[i] intValue]-1];
        
        //此处需要验证epg节目中的三个值是否相等
        BOOL isEqualForTwoDic = [GGUtil judgeTwoEpgDicIsEqual: serviceForJudgeDic TwoDic:epgDicToSocket];
        
        if (isEqualForTwoDic) {
            
            int indexForJudgeService = i;
            indexOfServiceToRefreshTable =indexForJudgeService;
            //                    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:indexForJudgeService inSection:0];
            //
            //                    [tableForSliderView scrollToRowAtIndexPath:scrollIndexPath  atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            //                    [self tableViewCellToBlue:indexForJudgeService];
            [self tableViewCellToBlue:indexOfCategory indexhah:indexForJudgeService AllNumberOfService:arrForServiceByCategory.count];
            
        }
    }
    
    
    [tableForSliderView reloadData];
    //     [self refreshTableFocusNotific:epgDicToSocket];
    
    
    //先全部变黑
    for (NSInteger  i = 0; i<arrForServiceByCategory.count; i++) {
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:0];
        
        TVCell *cell1 = [tableForSliderView cellForRowAtIndexPath:indexPath1];
        
        [cell1.event_nextNameLab setTextColor:CellGrayColor]; //CellGrayColor
        [cell1.event_nameLab setTextColor:CellBlackColor];  //  [UIColor redColor]
        [cell1.event_nextTime setTextColor:CellGrayColor]; //CellGrayColor
    }
    
    
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:indexOfServiceToRefreshTable inSection:0];
    //选中的变蓝
    TVCell *cell2 = [tableForSliderView cellForRowAtIndexPath:scrollIndexPath];
    [cell2.event_nextNameLab setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
    [cell2.event_nameLab setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)]; //RGBA(0x60, 0xa3, 0xec, 1)
    [cell2.event_nextTime setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];  //[UIColor blueColor]
    
    
    //    TVCell *cell = [tableForSliderView dequeueReusableCellWithIdentifier:@"TVCell"];
    //    if (cell == nil){
    //        cell = [TVCell loadFromNib];
    //
    //        [cell.event_nextNameLab setTextColor:CellGrayColor];
    //        [cell.event_nameLab setTextColor:CellBlackColor];
    //        [cell.event_nextTime setTextColor:CellGrayColor];
    //    }
    //    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:indexOfServiceToRefreshTable inSection:0];
    //
    //    cell =  [tableForSliderView cellForRowAtIndexPath:scrollIndexPath];
    //    [cell.event_nextNameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
    //    [cell.event_nameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
    //    [cell.event_nextTime setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
}
-(int)judgeCategoryType:(NSDictionary *)NowServiceDic
{
    //获取全部的channel数据，判断当前点击的channel是哪一个dic
    NSArray * serviceArrForJudge =  [USER_DEFAULT objectForKey:@"serviceData_Default"];
    NSDictionary * serviceArrForJudge_dic ;
    for (int i = 0; i<serviceArrForJudge.count; i++) {
        serviceArrForJudge_dic = serviceArrForJudge[i];
        if ([GGUtil judgeTwoEpgDicIsEqual:serviceArrForJudge_dic TwoDic:NowServiceDic]) {
            //此时的service就是真正的service
            //进行后续操作
            int nowServiceIndex = i+1;
            NSString * service_indexForJudgeType = [NSString  stringWithFormat:@"%d",nowServiceIndex];   //返回当前的i,作为节目的service_index值
            NSArray  * categoryArrForJudgeType = [USER_DEFAULT objectForKey:@"categorysToCategoryView"];
            for (int i = 0; i < categoryArrForJudgeType.count; i++) {
                NSDictionary * categoryIndexDic = categoryArrForJudgeType[i];
                NSArray * categoryServiceIndexArr = [categoryIndexDic objectForKey:@"service_index"];
                for (int y = 0; y < categoryServiceIndexArr.count; y++) {
                    NSString * serviceIndexForJundgeStr = categoryServiceIndexArr[y];
                    NSLog(@"没有进入判断方法1 %@",serviceIndexForJundgeStr);
                    NSLog(@"没有进入判断方法2 %@",service_indexForJudgeType);
                    if ([serviceIndexForJundgeStr isEqualToString:service_indexForJudgeType]) {
                        NSLog(@"没有进入判断方法这里要输出 i %d",i);
                        return i;
                    }
                    
                }
                
            }
        }
    }
    //否则什么都不是
    return 0;
    
    //    NSString * service_indexForJudgeType = [NowServiceDic objectForKey:@"service_index"];
    //    NSArray  * categoryArrForJudgeType = [USER_DEFAULT objectForKey:@"categorysToCategoryView"];
    //    for (int i = 0; i < categoryArrForJudgeType.count; i++) {
    //        NSDictionary * categoryIndexDic = categoryArrForJudgeType[i];
    //        NSArray * categoryServiceIndexArr = [categoryIndexDic objectForKey:@"service_index"];
    //        for (int y = 0; y < categoryServiceIndexArr.count; y++) {
    //            NSString * serviceIndexForJundgeStr = categoryServiceIndexArr[y];
    //            NSLog(@"没有进入判断方法1 %@",serviceIndexForJundgeStr);
    //            NSLog(@"没有进入判断方法2 %@",service_indexForJudgeType);
    //            if ([serviceIndexForJundgeStr isEqualToString:service_indexForJudgeType]) {
    //                NSLog(@"没有进入判断方法这里要输出 i %d",i);
    //                return i;
    //            }
    //
    //        }
    //
    //    }
    //    return 0;
}
/////////////全屏状态切换音轨字幕通知
//row 代表是service的每个类别下的序列是几，dic代表每个类别下的service
-(void)VideoTouchNoificAudioSubtClick : (NSNotification *)text//(NSInteger)row diction :(NSDictionary *)dic  //:(NSNotification *)text{
{
    
    
    NSInteger row = [text.userInfo[@"textOne"]integerValue];
    NSDictionary * dic = [[NSDictionary alloc]init];
    dic = text.userInfo[@"textTwo"];
    //--
    NSNumber * numAudio = text.userInfo[@"textThree"];
    NSNumber * numSubt = text.userInfo[@"textFour"];
    
    NSInteger audioIndex =  [numAudio integerValue];
    NSInteger subtIndex =  [numSubt integerValue];
    //--
    NSLog(@"self.socket:%@",self.socketView);
    
    //先传输数据到socket，然后再播放视频
    //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",row]];
    
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    
    NSLog(@"dic: %@",dic);
    NSLog(@"epgDicToSocket: %@",epgDicToSocket);
    
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
    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audioIndex] objectForKey:@"audio_pid"];
    NSLog(@"socketView.socket_ServiceModel.audio_pid :%@",socketView.socket_ServiceModel.audio_pid);
    socketView.socket_ServiceModel.subt_pid = [subt_infoArr[subtIndex] objectForKey:@"subt_pid"];
    NSLog(@"socketView.socket_ServiceModel.subt_pid :%@",socketView.socket_ServiceModel.subt_pid);
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
    isEventStartTimeBiger_NowTime = NO;
    BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
    if (isEventStartTimeBigNowTime == YES) {
        self.event_videoname = @"";
        self.event_startTime = @"";
        self.event_endTime = @"";
    }
    //    self.TVSubAudioDic = [[NSDictionary alloc]init];
    self.TVSubAudioDic = epgDicToSocket;
    //    self.TVChannlDic = [[NSDictionary alloc]init];
    NSLog(@"self.TVChannlDic.count 1:%d",self.TVChannlDic.count);
    self.TVChannlDic = self.dicTemp;
    NSLog(@"self.TVChannlDic.count 2:%d",self.TVChannlDic.count);
    NSLog(@"eventname :%@",self.event_startTime);
    //*********
    //    tempBoolForServiceArr = YES;
    //    tempArrForServiceArr =  self.categoryModel.service_indexArr;
    //    tempDicForServiceArr = self.TVChannlDic;
    //
    //
    //    [self getsubt];
    
    
    
    
    
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
    
    
    [self getsubt];
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
/////////////本页面的显示播放，打开APP的时候自动播放第一个视频
//row 代表是service的每个类别下的序列是几，dic代表每个类别下的service
-(void)firstOpenAppAutoPlay : (NSInteger)row diction :(NSDictionary *)dic  //:(NSNotification *)text{
{
    
    //    NSInteger row = [text.userInfo[@"textOne"]integerValue];
    //    NSDictionary * dic = [[NSDictionary alloc]init];
    //    dic = text.userInfo[@"textTwo"];
    
    NSLog(@"self.socket:%@",self.socketView);
    
    //先传输数据到socket，然后再播放视频
    //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",row]];
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    
    NSLog(@"dic: %@",dic);
    
    NSLog(@"row: %ld",(long)row);
    /*此处添加一个加入历史版本的函数*/
    [self addHistory:row diction:dic];
    //    [self getsubt];
    //__
    
    NSArray * audio_infoArr = [[NSArray alloc]init];
    NSArray * subt_infoArr = [[NSArray alloc]init];
    
    NSArray * epg_infoArr = [[NSArray alloc]init];
    //****
    
    
    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
    socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
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
    NSLog(@"replaceEventNameNotific firstOpen :%@",self.event_videoname);
    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
    isEventStartTimeBiger_NowTime = NO;
    BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
    if (isEventStartTimeBigNowTime == YES) {
        self.event_videoname = @"";
        self.event_startTime = @"";
        self.event_endTime = @"";
    }
    //    self.TVSubAudioDic = [[NSDictionary alloc]init];
    self.TVSubAudioDic = epgDicToSocket;
    //    self.TVChannlDic = [[NSDictionary alloc]init];
    NSLog(@"self.TVChannlDic.count1 :%d",self.TVChannlDic.count);
    self.TVChannlDic = self.dicTemp;
    NSLog(@"self.TVChannlDic.count2 :%d",self.TVChannlDic.count);
    NSLog(@"eventname :%@",self.event_startTime);
    
    tempBoolForServiceArr = YES;
    tempArrForServiceArr =  self.categoryModel.service_indexArr;
    tempDicForServiceArr = self.TVChannlDic;
    NSLog(@"first tempDicForServiceArr %@",tempDicForServiceArr);
    [self getsubt];
    //*********
    
    [USER_DEFAULT setObject:tempArrForServiceArr forKey:@"tempArrForServiceArr"];
    [USER_DEFAULT setObject:tempDicForServiceArr forKey:@"tempDicForServiceArr"];
    self.video.dicChannl = [tempDicForServiceArr mutableCopy];
    self.video.channelCount = tempArrForServiceArr.count;
    
    
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
    NSLog(@"playState---== 第一次打开发送数据111");
    [self.socketView  serviceTouch ];
    NSLog(@"playState---== 第一次打开发送数据222");
    NSTimer * touchTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(touchTimer) userInfo:nil repeats:NO];
    
    
}
-(void)touchTimer
{
    [self.socketView  serviceTouch ];
}
-(UIViewController*) findBestViewController:(UIViewController*)vc {
    NSLog(@"viewController222== %@",vc);
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
        
    }else if ([vc.presentedViewController isKindOfClass:[UIAlertController class]]) {
        return vc;
    }
    else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}

-(UIViewController*) currentViewController {
    
    // Find best view controller
    //    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    //    NSLog(@"viewController== %@",viewController);
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController* viewController = appdelegate.window.rootViewController;
    NSLog(@"[self findBestViewController:viewController] :%@",[self findBestViewController:viewController]) ;// [self findBestViewController:viewController];;
    return [self findBestViewController:viewController];
    
}
//状态栏隐藏与显示
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
        //                return UIStatusBarStyleDefault;
    }
    
    
}
-(void)getServiceDataNotHaveSocket
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
        
        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            [self getStartTimeFromchannelListArr : data1]; //将获得data存到集合
        });
        
        if (!isValidArray(data1) || data1.count == 0){
            [self getServiceDataNotHaveSocket];
            return ;
        }
        self.serviceData = (NSMutableArray *)data1;
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        
        //        NSLog(@"--------%@",self.serviceData);
        
        
        
        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
            [self getServiceDataNotHaveSocket];
        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notHaveNetWork) object:nil];
        [self playVideo];
        NSLog(@"playVideo44 :");
        
        
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
            
            //            if (tableviewinit == 2) {
            if (!_slideView) {
                NSLog(@"上山打老虎4");
                
                
                
                
                
                
                //判断是不是全屏
                BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
                if (isFullScreen == NO) {   //竖屏状态
                    
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                    
                    
                }else //横屏状态，不刷新
                {
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                }
                
                
                
                
                
                
                //                //设置滑动条
                //                _slideView = [YLSlideView alloc];
                //                _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                //                                                                  SCREEN_WIDTH,
                //                                                                  SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                
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
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                
            }
            else
            {
                
            }
            NSLog(@"DMSIP:6666");
            //            [self.socketView viewDidLoad];
            if (firstfirst == YES) {
                
                //                   self.socketView  = [[SocketView  alloc]init];
                NSLog(@"DMSIP:1111");
                //                   [self.socketView viewDidLoad];
                NSLog(@"DMSIP:2222");
                //=======机顶盒加密
                NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:0 serviceListDic:self.dicTemp];
                if (characterStr != NULL && characterStr != nil) {
                    BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                    if (judgeIsSTBDecrypt == YES) {
                        // 此处代表需要记性机顶盒加密验证
                        NSNumber  *numIndex = [NSNumber numberWithInteger:0];
                        NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"firstOpenTouch",@"textThree",nil];
                        //创建通知
                        NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                        NSLog(@"POPPOPPOPPOP555555555555551");
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                        
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                    }else //正常播放的步骤
                    {
                        //======
                        [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                    }
                }else //正常播放的步骤
                {
                    //======机顶盒加密
                    [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }
            }else
            {}
            
            //            //刷新EPG数据。把所有的时间信息
            //
            //            NSArray *EPGservice_data = response[@"service"];
            //            if (!isValidArray(EPGservice_data) || EPGservice_data.count == 0){
            //            }
            //            else   //此时有数据
            //            {
            //                NSDictionary * dicEpg = [[NSDictionary alloc]init];
            //                for (int e = 0; e<EPGservice_data.count; e++) {
            //
            //                    dicEpg = EPGservice_data[e];
            //
            //                    NSArray * arrEpg = [[NSArray alloc]init];
            //                    arrEpg = [dicEpg objectForKey:@"epg_info"];   //epg 小数组
            //
            //                    //重新声明一个一个epg数组加载epg信息
            ////                    NSDictionary * epgTimeInfo = [[NSDictionary alloc]init];
            //                    for (int f = 0; f<arrEpg.count; f++) {
            //                        NSString * startTimeString = [arrEpg[f] objectForKey:@"event_starttime"];
            //
            //
            //                            if (![allStartEpgTime containsObject:startTimeString]) {
            //                                [allStartEpgTime addObject:startTimeString];
            //                            }
            //
            //
            //                    }
            //                }
            //
            //
            //            }
            //            NSLog(@"allStartEpgTime:--%@",allStartEpgTime);
            //            NSLog(@"allStartEpgTime.count:--%lu",(unsigned long)allStartEpgTime.count);
            //
            
            
            
        }];
        
        
        [self initProgressLine];
        //        [self getSearchData];
        
        
        
        [self.table reloadData];
        
    }];
    
}

#pragma mark-- 密码校验 / 机顶盒密码加锁  /  CA验证
-(void)CADencryptNotific
{
    //新建一个通知，用来监听机顶盒加密
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CADencryptNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCAAlertView:) name:@"CADencryptNotific" object:nil];
    
}
-(void)STBDencryptNotific
{
    //新建一个通知，用来监听机顶盒加密
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"STBDencryptNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popSTBAlertView:) name:@"STBDencryptNotific" object:nil];
    
}
-(void)STBDencryptVideoTouchNotific
{
    //新建一个通知，用来监听从机顶盒密码验证正确跳转来的播放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"STBDencryptVideoTouchNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allVideoTouchFromSTB) name:@"STBDencryptVideoTouchNotific" object:nil];
}
-(void)allVideoTouchFromSTB
{
    //判断类型
    //    STBTouchType_Str
    if([STBTouchType_Str isEqualToString:@"otherTouch"])
    {
        
        //将整形转换为number
        NSNumber * numIndex = [NSNumber numberWithInteger:STBTouch_Row];
        
        //添加 字典，将label的值通过key值设置传递
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",STBTouch_Dic,@"textTwo", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else   if([STBTouchType_Str isEqualToString:@"firstOpenTouch"])
    {
        
        [self firstOpenAppAutoPlay:0 diction:STBTouch_Dic];
        
    }else   if([STBTouchType_Str isEqualToString:@"AudioSubtTouch"])
    {
        
        NSNumber * numIndex = [NSNumber numberWithInteger:STBTouch_Row];
        
        NSNumber * audioNum = [NSNumber numberWithInteger:STBTouch_Audio];
        NSNumber * subtNum = [NSNumber numberWithInteger:STBTouch_Subt];
        //添加 字典，将label的值通过key值设置传递
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",STBTouch_Dic,@"textTwo",audioNum,@"textThree",subtNum,@"textFour", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoificAudioSubt" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    }else  if([STBTouchType_Str isEqualToString:@"LiveTouch"])
    {
        
        [self touchSelectChannel:STBTouch_Row diction:STBTouch_Dic];
        
    }
}
-(BOOL)isSTBDEncrypt :(NSString *)characterStr
{
    uint32_t character10 = [characterStr intValue];  //转换成10进制的数
    NSLog(@"character10 :%d",character10);
    
    uint32_t character2_And =  character10 &  0x02;
    NSLog(@"character2 与运算 %d",character2_And);
    
    
    if (character2_And > 0) {
        // 此处代表需要记性机顶盒加密验证
        //弹窗
        
        return YES;
        //        [self popSTBAlertView];
        //        [self popCAAlertView];
        
        
    }else
    {
        return NO;
    }
}
-(void)popSTBAlertView: (NSNotification *)text
{
    
    //保存三个有用的信息
    STBTouch_Row = [text.userInfo[@"textOne"]integerValue];
    STBTouch_Dic = text.userInfo[@"textTwo"];
    STBTouchType_Str = text.userInfo[@"textThree"];
    NSDictionary * epgDicFromPopSTB = [STBTouch_Dic objectForKey:[NSString stringWithFormat:@"%d",STBTouch_Row]];
    NSLog(@"epgDicFromPopSTB== %@",epgDicFromPopSTB);
    
    [USER_DEFAULT setObject:epgDicFromPopSTB forKey:@"NowChannelDic"];
    if (text.userInfo.count >3) {
        STBTouch_Audio = [text.userInfo[@"textFour"]integerValue];
        STBTouch_Subt = [text.userInfo[@"textFive"]integerValue];
    }
    //===
    
    [self serviceEPGSetData:STBTouch_Row diction:STBTouch_Dic];
    //    NSArray * epg_infoArr = [[NSArray alloc]init];
    //    self.service_videoname = [epgDicFromPopSTB objectForKey:@"service_name"];
    //    epg_infoArr = [epgDicFromPopSTB objectForKey:@"epg_info"];
    //    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
    //    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
    //    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
    //    //    self.TVSubAudioDic = [[NSDictionary alloc]init];
    //    self.TVSubAudioDic = epgDicFromPopSTB;
    //    //    self.TVChannlDic = [[NSDictionary alloc]init];
    //    NSLog(@"self.TVChannlDic.count 1:%d",self.TVChannlDic.count);
    //    self.TVChannlDic = self.dicTemp;
    //    NSLog(@"self.TVChannlDic.count 2:%d",self.TVChannlDic.count);
    //    NSLog(@"eventname :%@",self.event_startTime);
    //
    //
    //
    //    tempBoolForServiceArr = YES;
    //    tempArrForServiceArr =  self.categoryModel.service_indexArr;
    //    tempDicForServiceArr = self.TVChannlDic;
    //    NSLog(@"first tempDicForServiceArr %@",tempDicForServiceArr);
    //    [self getsubt];
    //    //*********
    //
    //    [USER_DEFAULT setObject:tempArrForServiceArr forKey:@"tempArrForServiceArr"];
    //    [USER_DEFAULT setObject:tempDicForServiceArr forKey:@"tempDicForServiceArr"];
    //    self.video.dicChannl = [tempDicForServiceArr mutableCopy];
    //    self.video.channelCount = tempArrForServiceArr.count;
    
    //=====
    
    //    STBAlert = [[UIAlertView alloc] initWithTitle:@"请输入机顶盒密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [STBAlert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    STBAlert.delegate =  self;
    [STBAlert show];
    
    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"文本对话框" message:@"登录和密码对话框示例" preferredStyle:UIAlertControllerStyleAlert];
    //
    //    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
    //
    //        textField.placeholder = @"登录";
    //
    //    }];
    //
    //    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    //
    //        textField.placeholder = @"密码";
    //
    //        textField.secureTextEntry = YES;
    //
    //    }];
    //    [self presentViewController:alertController animated:YES completion:nil];
    
    //    UIView * viewhah = [[UIView alloc]init];
    //    viewhah.frame = CGRectMake(30, 30, 50, 50);
    //    viewhah.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:viewhah];
    
    
    
    //        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"请输入机顶盒密码"];
    //    [BMAlertHud showWithTitle:title message:nil delegate:self textfield:YES cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    STBAlert.transform = CGAffineTransformRotate(STBAlert.transform, M_PI/2);
    
    
    STBTextField_Encrypt.delegate = self;
    STBTextField_Encrypt.autocorrectionType = UITextAutocorrectionTypeNo;
    STBTextField_Encrypt = [STBAlert textFieldAtIndex:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:STBTextField_Encrypt];
}
-(void)popCAAlertView : (NSNotification *)text
{
    NSData * CAThreeData = text.userInfo[@"CAThreedata"];
    NSData * CANetwork_idData = [CAThreeData subdataWithRange:NSMakeRange(0,2)];
    NSData * CATs_idData = [CAThreeData subdataWithRange:NSMakeRange(2,2)];
    NSData * CAService_idData = [CAThreeData subdataWithRange:NSMakeRange(4,2)];
    
    uint16_t  CANetwork_idStr = [SocketUtils uint16FromBytes:CANetwork_idData]; // [[NSString alloc] initWithData:CANetwork_idData  encoding:NSUTF8StringEncoding];
    uint16_t  CATs_idStr =  [SocketUtils uint16FromBytes:CATs_idData]; //[[NSString alloc] initWithData:CATs_idData  encoding:NSUTF8StringEncoding];
    uint16_t  CAService_idStr =  [SocketUtils uint16FromBytes:CAService_idData];//[[NSString alloc] initWithData:CAService_idData  encoding:NSUTF8StringEncoding];
    //判断当前节目是不是CA弹窗节目
    
    NSLog(@"socketView.socket_ServiceModel.service_ts_id :%@",socketView.socket_ServiceModel.service_ts_id) ;
    NSLog(@"socketView.socket_ServiceModel.service_net_id :%@",socketView.socket_ServiceModel.service_network_id) ;
    NSLog(@"socketView.socket_ServiceModel.service_service_id :%@",socketView.socket_ServiceModel.service_service_id) ;
    
    if (CANetwork_idStr  == [socketView.socket_ServiceModel.service_network_id  intValue] && CATs_idStr == [socketView.socket_ServiceModel.service_ts_id intValue] && CAService_idStr == [socketView.socket_ServiceModel.service_service_id intValue]) {
        //证明一致，是这个CA节目
        
        [CAAlert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
        CAAlert.delegate =  self;
        [CAAlert show];
        
        
        CATextField_Encrypt.delegate = self;
        CATextField_Encrypt.autocorrectionType = UITextAutocorrectionTypeNo;
        CATextField_Encrypt = [CAAlert textFieldAtIndex:0];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:CATextField_Encrypt];
        
    }else
    {
        //不一致，不弹窗。===或者将窗口取消掉
        
        if(CAAlert){
            [CAAlert dismissWithClickedButtonIndex:[CAAlert cancelButtonIndex] animated:YES];
        }
    }
    
    
    
    //    CAAlert = [[UIAlertView alloc] initWithTitle:@"请输入CA密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    textField_Encrypt.delegate = self;
    //    textField_Encrypt.autocorrectionType = UITextAutocorrectionTypeNo;
    //    textField_Encrypt = [alertView textFieldAtIndex:0];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
    //                                                name:@"UITextFieldTextDidChangeNotification"
    //                                              object:textField_Encrypt];
    
    if ([alertView  isEqual: STBAlert]) {
        
        if(buttonIndex == 0)
        {
            NSLog(@"charact  STB  验证");
            NSLog(@"没有进行STB密码验证，所以不能播放");
            //取消了
        }else{
            NSLog(@"charact  STB  验证");
            NSLog(@"character2txt  字符 ：%@",STBTextField_Encrypt.text);
            
            [self.socketView passwordCheck:STBTextField_Encrypt.text passwordType:1];  //密码六位
        }
    }
    else if([alertView  isEqual: CAAlert])
    {
        if(buttonIndex == 0)
        {
            //取消了
            NSLog(@"charact  CA 验证");
            NSLog(@"没有进行CA密码验证，所以不能播放");
        }else{
            NSLog(@"charact  CA 验证");
            NSLog(@"character2txt  字符 ：%@",CATextField_Encrypt.text);
            [self.socketView passwordCheck:CATextField_Encrypt.text passwordType:0]; //密码四位
        }
    }
    
    
    
}
-(BOOL)textFiledEditChanged:(NSNotification *)obj{
    
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if ([textField  isEqual: STBTextField_Encrypt]) {
        
        NSUInteger lengthOfString = toBeString.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [toBeString characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}  ;  -  45  _95
            if (character < 48)
            {
                
                textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
                return NO; // 48 unichar for 0..
            }
            
            if (character > 57 && character < 64)
            {
                
                textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
                return NO; // 48 unichar for 0..
            }
            if (character > 64)
            {
                textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
                return NO; //
            }
            
            
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length ;//- range.length + string.length;
        if (proposedNewLength > 6) {
            textField.text = [toBeString substringToIndex:6];
            return NO;//限制长度
        }
        return YES;
        
    }
    else if ([textField  isEqual: CATextField_Encrypt]) {
        NSUInteger lengthOfString = toBeString.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [toBeString characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}  ;  -  45  _95
            if (character < 48)
            {
                
                textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
                return NO; // 48 unichar for 0..
            }
            
            //            if (character > 57 && character < 64)
            //            {
            //
            //                textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
            //                return NO; // 48 unichar for 0..
            //            }
            if (character > 57)
            {
                textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
                return NO; //
            }
            
            
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length ;//- range.length + string.length;
        if (proposedNewLength > 4) {
            textField.text = [toBeString substringToIndex:4];
            return NO;//限制长度
        }
        return YES;
        
        
    }
    
}
//-(void)passWordCheck_Socket:(NSInteger)row diction :(NSDictionary *)dic
//{
//
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
////    [self addHistory:row diction:dic];
//    //    [self getsubt];
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
//    socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
//    socketView.socket_ServiceModel.service_network_id = [epgDicToSocket objectForKey:@"service_network_id"];
//    socketView.socket_ServiceModel.service_ts_id =[epgDicToSocket objectForKey:@"service_ts_id"];
//    socketView.socket_ServiceModel.service_tuner_mode = [epgDicToSocket objectForKey:@"service_tuner_mode"];
//    socketView.socket_ServiceModel.service_service_id = [epgDicToSocket objectForKey:@"service_service_id"];
//    socketView.socket_ServiceModel.service_character = [epgDicToSocket objectForKey:@"service_character"]; //新加了一个service_character
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
//    NSLog(@"replaceEventNameNotific firstOpen :%@",self.event_videoname);
//    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
//    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
//    self.TVSubAudioDic = [[NSDictionary alloc]init];
//    self.TVSubAudioDic = epgDicToSocket;
//    self.TVChannlDic = [[NSDictionary alloc]init];
//    NSLog(@"self.TVChannlDic.count1 :%d",self.TVChannlDic.count);
//    self.TVChannlDic = self.dicTemp;
//    NSLog(@"self.TVChannlDic.count2 :%d",self.TVChannlDic.count);
//    NSLog(@"eventname :%@",self.event_startTime);
//
//    tempBoolForServiceArr = YES;
//    tempArrForServiceArr =  self.categoryModel.service_indexArr;
//    tempDicForServiceArr = self.TVChannlDic;
//    NSLog(@"first tempDicForServiceArr %@",tempDicForServiceArr);
//    [self getsubt];
//    //*********
//
//    [USER_DEFAULT setObject:tempArrForServiceArr forKey:@"tempArrForServiceArr"];
//    [USER_DEFAULT setObject:tempDicForServiceArr forKey:@"tempDicForServiceArr"];
//    self.video.dicChannl = [tempDicForServiceArr mutableCopy];
//    self.video.channelCount = tempArrForServiceArr.count;
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
//    NSLog(@"self.socket:%@",self.socketView);
//
//    self.videoController.socketView1 = self.socketView;
//    NSLog(@"playState---== 第一次打开发送数据111");
//    [self.socketView  serviceTouch ];
//    NSLog(@"playState---== 第一次打开发送数据222");
//
//
//}
-(void)serviceEPGSetData : (NSInteger)row diction :(NSDictionary *)dic
{
    NSLog(@"self.socket:%@",self.socketView);
    
    //先传输数据到socket，然后再播放视频
    //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",row]];
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    
    NSLog(@"dic: %@",dic);
    
    NSLog(@"row: %ld",(long)row);
    /*此处添加一个加入历史版本的函数*/
    [self addHistory:row diction:dic];
    //    [self getsubt];
    //__
    
    NSArray * audio_infoArr = [[NSArray alloc]init];
    NSArray * subt_infoArr = [[NSArray alloc]init];
    
    NSArray * epg_infoArr = [[NSArray alloc]init];
    //****
    
    
    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
    socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
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
    NSLog(@"replaceEventNameNotific firstOpen :%@",self.event_videoname);
    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
    isEventStartTimeBiger_NowTime = NO;
    BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
    if (isEventStartTimeBigNowTime == YES) {
        self.event_videoname = @"";
        self.event_startTime = @"";
        self.event_endTime = @"";
    }
    //    self.TVSubAudioDic = [[NSDictionary alloc]init];
    self.TVSubAudioDic = epgDicToSocket;
    //    self.TVChannlDic = [[NSDictionary alloc]init];
    NSLog(@"self.TVChannlDic.count1 :%d",self.TVChannlDic.count);
    self.TVChannlDic = self.dicTemp;
    NSLog(@"self.TVChannlDic.count2 :%d",self.TVChannlDic.count);
    NSLog(@"eventname :%@",self.event_startTime);
    
    tempBoolForServiceArr = YES;
    tempArrForServiceArr =  self.categoryModel.service_indexArr;
    tempDicForServiceArr = self.TVChannlDic;
    NSLog(@"first tempDicForServiceArr %@",tempDicForServiceArr);
    [self getsubt];
    //*********
    
    [USER_DEFAULT setObject:tempArrForServiceArr forKey:@"tempArrForServiceArr"];
    [USER_DEFAULT setObject:tempDicForServiceArr forKey:@"tempDicForServiceArr"];
    self.video.dicChannl = [tempDicForServiceArr mutableCopy];
    self.video.channelCount = tempArrForServiceArr.count;
    
    
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
    
    
    self.video.channelId = self.service_videoindex;
    self.video.channelName = self.service_videoname;
    NSLog(@"self.video.channelName== %@",self.video.channelName);
    self.video.playEventName = self.event_videoname;
    NSLog(@"self.event_videoname 获取列表中 replaceEventNameNotific %@",self.event_videoname);
    NSLog(@"replaceEventNameNotific self.video.playeventName :%@",self.video.playEventName);
    self.video.startTime = self.event_startTime;
    self.video.endTime = self.event_endTime;
    
    NSDictionary *channlIdNameDic =[[NSDictionary alloc] initWithObjectsAndKeys:self.video.channelId,@"channelIdStr",self.video.channelName,@"channelNameStr", nil];
    //创建通知
    NSNotification *notification2 =[NSNotification notificationWithName:@"setChannelNameOrOtherInfoNotic" object:nil userInfo:channlIdNameDic];
    NSLog(@"POPPOPPOPPOP==setchannelNameOrOtherInfo");
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
    
    
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
    
    
}
//获取EPG中的每个节目的开始时间
-(void)getStartTimeFromchannelListArr :(NSArray *)channelListArr
//{}
{
    NSLog(@"在这里获取 开始获取ListArr");
    //channelStartimesList = [NSSet alloc];
    for (int i = 0; i< channelListArr.count; i++) {
        
        NSArray * epg_info_ArrForStartTime = [channelListArr[i] objectForKey:@"epg_info"];
        
        
        for (int y = 0; y< epg_info_ArrForStartTime.count; y++) {
            
            NSString * startTimeStr = [epg_info_ArrForStartTime[y] objectForKey:@"event_endtime"];  //注意，这里把开始时间都换成了结束时间
            if(startTimeStr == nil ||  startTimeStr == NULL || [startTimeStr isEqualToString:@""])
            {
                //如果为空，不能放入集合
                //                NSLog(@"epg_info_ArrForStartTime[y] objectForKey:event_startime %@",startTimeStr);
            }else
            {
                NSLog(@"epg_info_ArrForStartTime[y] objectForKey:event_startime %@",startTimeStr);
                [channelStartimesList  addObject: startTimeStr];
                
            }
            
        }
    }
    
    
    
    
    
    
    NSLog(@"channelStartimesList :%@",channelStartimesList);
    
    [self nssetSortToArr:channelStartimesList];
    NSLog(@"在这里获取 发送到判断Nsset");
}

-(void)nssetSortToArr :(NSSet *)set //NSSet排序
{
    NSLog(@"在这里获取 这里接收到排序");
    //    NSSet *set = [NSSet setWithArray:arr];
    NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:YES]];
    NSArray *sortSetArray = [set sortedArrayUsingDescriptors:sortDesc];
    
    NSString * tempArrStr;
    NSString * nowTimeStr = [GGUtil GetNowTimeString];
    for (int i = 0; i< sortSetArray.count; i++) {
        tempArrStr = sortSetArray[i];
        //        nowTimeStr
        if ([tempArrStr intValue] > [nowTimeStr intValue] ) {
            //如果时间小于当前时间，那么几秒后刷新
            int delayTime = [tempArrStr intValue] - [nowTimeStr intValue] ;
            //            int delayTime = [nowTimeStr intValue] - [tempArrStr intValue];
            if (delayTime != 0 && delayTime >0) {
                NSLog(@"在这里获取 delayTime：%d",delayTime);
                //                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(twoFunctionOftableviewDataRefresh) object:nil];
                //                [self performSelector:@selector(twoFunctionOftableviewDataRefresh) withObject:nil afterDelay:delayTime];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getNSSetListHttpRequest) object:nil];
                [self performSelector:@selector(getNSSetListHttpRequest) withObject:nil afterDelay:10]; //getServiceData  //twoFunctionOftableviewDataRefresh //tableViewDataRefresh //getMediaDeliverUpdate //getServiceDataNotHaveSocket
                [[NSRunLoop currentRunLoop] run];
                
                NSLog(@"在这里获取 delayTime后开始自动刷新");
                //                if (i+1 < sortSetArray.count) {  //如果第二个数据小于总数量
                //                    NSString * tempArrStr2 = sortSetArray[i+1];
                //                    if ([tempArrStr2 intValue] < [nowTimeStr intValue] ) {
                //
                //                        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(twoFunctionOftableviewDataRefresh2) object:nil];
                //                        [self performSelector:@selector(twoFunctionOftableviewDataRefresh2) withObject:nil afterDelay:delayTime];
                //                    }
                //                }
                
                
                
                
                
            }
            
            //
            //CD 几秒
            //            [self  twoFunctionOftableviewDataRefresh];
            
            break;
        }else
        {
            
        }
    }
    
}
-(void)twoFunctionOftableviewDataRefresh   //这个方法只用作判断EPG时间，然后自动刷新表的方法中（nssetSortToArr）
{
    //    [self tableViewDataRefresh];   //获得数据
    //    [self refreshTableviewByEPGTime]; //刷新表
    [self tableViewDataRefreshForMjRefresh];  //重新获取json数据
}
-(void)twoFunctionOftableviewDataRefresh2   //这个方法只用作判断EPG时间，然后自动刷新表的方法中（nssetSortToArr）
{
    //    [self tableViewDataRefresh];   //获得数据
    //    [self refreshTableviewByEPGTime]; //刷新表
    [self tableViewDataRefreshForMjRefresh];  //重新获取json数据
}
//-(NSString *)getNowTimeStr //获得当前时间的时间戳
//{
//    NSString * nowTimeStr =[GGUtil GetNowTimeString]; //获得当前时间的时间戳
//    return nowTimeStr;
//
//}
-(BOOL )judgeEventStartTime :(NSString *)videoName startTime :(NSString *)startTime endTime :(NSString *)endTime
{
    NSString * nowTimeStr =[GGUtil GetNowTimeString]; //获得当前时间的时间戳
    
    if ([startTime intValue] > [nowTimeStr intValue]) {
        //        self.event_videoname = @"";
        //        self.event_startTime = @"";
        //        self.event_endTime = @"";
        //        NSArray * arr = @[self.event_videoname,self.event_startTime,self.event_endTime];
        //        return  arr;
        isEventStartTimeBiger_NowTime = YES;
        return YES;
    }else
    {
        isEventStartTimeBiger_NowTime = NO;
        return NO;
    }
    
}
-(void)tableViewDataRefreshForMjRefresh
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
        
        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            [self getStartTimeFromchannelListArr : data1]; //将获得data存到集合
            NSLog(@"在这里获取 准备跳转到获取List方法中");
        });
        
        
        
        
        if (!isValidArray(data1) || data1.count == 0){
            //            [self getServiceData];
            [self tableViewDataRefreshForMjRefresh];
            return ;
        }
        self.serviceData = (NSMutableArray *)data1;
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        
        
        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
            //            [self getServiceData];
            [self tableViewDataRefreshForMjRefresh];
        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        
        
        
        //
        for (int i = 0; i<self.tableForDicIndexArr.count; i++) {
            
            id idTemp = self.tableForDicIndexArr[i][1];
            NSNumber * numTemp = self.self.tableForDicIndexArr[i][0];
            
            if (idTemp == self.tableForSliderView ) {
                
                NSInteger index = [numTemp integerValue];
                NSDictionary *item = self.categorys[index];   //当前页面类别下的信息
                self.categoryModel = [[CategoryModel alloc]init];
                
                self.categoryModel.service_indexArr = item[@"service_index"];   //当前类别下包含的节目索引  0--9
                
                //获取EPG信息 展示
                //时间戳转换
                
                [self.dicTemp removeAllObjects];
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
                
                
                
                
                
            }
        }
        
        
        [self.tableForSliderView reloadData];
        [self refreshTableviewByEPGTime];
        // 模拟延迟2秒
        
        double delayInSeconds = 2;
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, mainQueue, ^{
            NSLog(@"延时执行的2秒");
            //        [self runThread1];
            NSLog(@"byteValue1 TVTVTVTVTVTV222");
            [self.tableForSliderView reloadData];
            
            [self refreshTableviewByEPGTime];
            NSLog(@"byteValue1 TVTVTVTVTVTV333");
        });
        [NSThread sleepForTimeInterval:2];
        //    [self mediaDeliveryUpdate];
        //    [tableForSliderView reloadData];
        // 结束刷新
        
        //    NSLog(@"tableForSliderView22--:%@",self.tableForSliderView);
        [self.tableForSliderView.mj_header endRefreshing];
        
        
        //////
        //获取数据的链接
        NSString *urlCate = [NSString stringWithFormat:@"%@",S_category];
        
        
        LBGetHttpRequest *request = CreateGetHTTP(urlCate);
        
        
        
        [request startAsynchronous];
        
        WEAKGET
        [request setCompletionBlock:^{
            NSDictionary *response = httpRequest.responseString.JSONValue;
            
            
            
            NSArray *data = response[@"category"];
            
            if (!isValidArray(data) || data.count == 0){
                return ;
            }
            self.categorys = (NSMutableArray *)data;
            
            
            if (firstfirst == YES) {
                
                
                //                [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                //                firstOpenAPP = firstOpenAPP+1;
                
                //                firstfirst = NO;
                
            }else
            {}
            
        }];
        
        
        //        [self initProgressLine];
        
        [self.table reloadData];
        
        
    }];
}
#pragma mark - IP改变后的刷新方法
//IP改变后或者是HMC改变后的刷新方法  ,类似于getServiceData
-(void) getServiceDataForIPChange
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
        
        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            [self getStartTimeFromchannelListArr : data1]; //将获得data存到集合
        });
        
        
        if (!isValidArray(data1) || data1.count == 0){
            [self getServiceDataForIPChange];
            return ;
        }
        self.serviceData = (NSMutableArray *)data1;
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        //        NSLog(@"--------%@",self.serviceData);
        
        
        
        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
            [self getServiceDataForIPChange];
        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notHaveNetWork) object:nil];
        [self playVideo];
        NSLog(@"playVideo55 :");
        
        
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
            
            //            if (tableviewinit == 2) {
            NSLog(@"_slideView %@",_slideView);
            
            //先判断是竖屏还是横屏，如果是竖屏   则竖屏，则刷新。如果是横屏，则不刷新
            //判断是不是全屏
            //            BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
            //            if (isFullScreen == NO) {   //竖屏状态
            //                [_slideView removeFromSuperview];
            //                _slideView = nil;
            //
            //            }else
            //            {
            //
            //            }
            [_slideView removeFromSuperview];
            _slideView = nil;
            
            if (!_slideView) {
                NSLog(@"上山打老虎4");
                
                
                
                
                
                //判断是不是全屏
                BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
                if (isFullScreen == NO) {   //竖屏状态
                    
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                    
                    
                }else //横屏状态，不刷新
                {
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                }
                
                
                
                
                
                
                //                //设置滑动条
                //                _slideView = [YLSlideView alloc];
                //                _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                //                                                                  SCREEN_WIDTH,
                //                                                                  SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                
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
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                
            }
            else
            {
                
            }
            NSLog(@"DMSIP:6666");
            [self.socketView viewDidLoad];
            if (firstfirst == YES) {
                
                //                   self.socketView  = [[SocketView  alloc]init];
                NSLog(@"DMSIP:1111");
                //                   [self.socketView viewDidLoad];
                NSLog(@"DMSIP:2222");
                
                //=======机顶盒加密
                NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:0 serviceListDic:self.dicTemp];
                if (characterStr != NULL && characterStr != nil) {
                    BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                    if (judgeIsSTBDecrypt == YES) {
                        // 此处代表需要记性机顶盒加密验证
                        NSNumber  *numIndex = [NSNumber numberWithInteger:0];
                        NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"firstOpenTouch",@"textThree",nil];
                        //创建通知
                        NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                        NSLog(@"POPPOPPOPPOP1111111111111111111");
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                        
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                        
                    }else //正常播放的步骤
                    {
                        //======
                        [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                    }
                }else //正常播放的步骤
                {
                    //======机顶盒加密
                    
                    [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }
            }else
            {}
            
            //            //刷新EPG数据。把所有的时间信息
            //
            //            NSArray *EPGservice_data = response[@"service"];
            //            if (!isValidArray(EPGservice_data) || EPGservice_data.count == 0){
            //            }
            //            else   //此时有数据
            //            {
            //                NSDictionary * dicEpg = [[NSDictionary alloc]init];
            //                for (int e = 0; e<EPGservice_data.count; e++) {
            //
            //                    dicEpg = EPGservice_data[e];
            //
            //                    NSArray * arrEpg = [[NSArray alloc]init];
            //                    arrEpg = [dicEpg objectForKey:@"epg_info"];   //epg 小数组
            //
            //                    //重新声明一个一个epg数组加载epg信息
            ////                    NSDictionary * epgTimeInfo = [[NSDictionary alloc]init];
            //                    for (int f = 0; f<arrEpg.count; f++) {
            //                        NSString * startTimeString = [arrEpg[f] objectForKey:@"event_starttime"];
            //
            //
            //                            if (![allStartEpgTime containsObject:startTimeString]) {
            //                                [allStartEpgTime addObject:startTimeString];
            //                            }
            //
            //
            //                    }
            //                }
            //
            //
            //            }
            //            NSLog(@"allStartEpgTime:--%@",allStartEpgTime);
            //            NSLog(@"allStartEpgTime.count:--%lu",(unsigned long)allStartEpgTime.count);
            //
            
            
            
        }];
        
        
        [self initProgressLine];
        //        [self getSearchData];
        
        
        
        [self.table reloadData];
        
    }];
    
}
#pragma mark -判断进度条是否需要隐藏
-(void)judgeProgressIsNeedHide :(BOOL)isFullSreen//判断进度条是否需要隐藏 //isFullSreen 代表是否是全屏
{
    isBarIsShowNow = [USER_DEFAULT boolForKey:@"isBarIsShowNow"]; //当前的播放阴影是否在显示，如果没有显示，那么跳转到全屏状态下，进度条需要隐藏。否则，进度条不隐藏
    
    if (isFullSreen) { //如果是全屏
        if (isBarIsShowNow) { //如果阴影在在显示
            self.topProgressView.alpha = 1;   //显示
        }else//如果阴影隐藏
        {
            self.topProgressView.alpha = 0;   //隐藏
        }
    }
    else
    {
        self.topProgressView.alpha = 1;   //显示
    }
    
}
//这个方法是为了避免在获取nsset的过程中出发《getMediaDeliverUpdate》 方法，导致出发《judgeVideoByDelete》从而播放第一个节目
-(void)getNSSetListHttpRequest
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
        
        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            [self getStartTimeFromchannelListArr : data1]; //将获得data存到集合
        });
        
        if (!isValidArray(data1) || data1.count == 0){
            //            [self getServiceData];
            [self getNSSetListHttpRequest];
            return ;
        }
        self.serviceData = (NSMutableArray *)data1;
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        
        //        NSLog(@"--------%@",self.serviceData);
        
        
        
        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
            //            [self getServiceData];
            [self getNSSetListHttpRequest];
        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        //        [self playVideo];
        
        
        //////
        //获取数据的链接
        NSString *urlCate = [NSString stringWithFormat:@"%@",S_category];
        
        
        LBGetHttpRequest *request = CreateGetHTTP(urlCate);
        
        
        
        [request startAsynchronous];
        
        WEAKGET
        [request setCompletionBlock:^{
            NSDictionary *response = httpRequest.responseString.JSONValue;
            
            
            
            NSArray *data = response[@"category"];
            
            if (!isValidArray(data) || data.count == 0){
                return ;
            }
            self.categorys = (NSMutableArray *)data;
            
            
            if (!_slideView) {
                NSLog(@"上山打老虎3");
                //判断是不是全屏
                BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
                if (isFullScreen == NO) {   //竖屏状态
                    
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                    
                    NSArray *ArrayTocategory = [NSArray arrayWithArray:self.categorys];
                    [USER_DEFAULT setObject:ArrayTocategory forKey:@"categorysToCategoryView"];
                    NSLog(@"ArrayTocategory %@",ArrayTocategory);
                    NSLog(@"self.dicTemp %@",self.dicTemp);
                    _slideView.backgroundColor = [UIColor whiteColor];
                    _slideView.delegate        = self;
                    
                    [self.view addSubview:_slideView];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                    
                    
                }else //横屏状态，不刷新
                {
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.categorys];
                    
                    NSArray *ArrayTocategory = [NSArray arrayWithArray:self.categorys];
                    [USER_DEFAULT setObject:ArrayTocategory forKey:@"categorysToCategoryView"];
                    NSLog(@"ArrayTocategory %@",ArrayTocategory);
                    NSLog(@"self.dicTemp %@",self.dicTemp);
                    _slideView.backgroundColor = [UIColor whiteColor];
                    _slideView.delegate        = self;
                    
                    [self.view addSubview:_slideView];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                }
                
                
                
                
            }
            else
            {
                
            }
            
            //            [self judgeVideoByDelete];
            
            //            NSArray * arrHistoryNow = [USER_DEFAULT objectForKey:@"historySeed"];
            //            NSLog(@"history Arr0: %@",arrHistoryNow[0][0]);  //wor
            //            NSLog(@"history Arr1: %@",arrHistoryNow[1][0]);  //wor
            //            NSLog(@"history Arr2: %@",arrHistoryNow[2][0]);  //wor
            //            NSLog(@"history Arr6: %@",arrHistoryNow[6][0]);  //wor
            //            NSLog(@"history Arr22: %@",[self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",0]]);  //wor
            //
            //
            //            for (int i = 0; i<self.dicTemp.count; i++) {
            //                [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",i]];
            //                NSLog(@"i - 1%d",(i));
            //
            //
            //                if ([arrHistoryNow[6][0] isEqual: [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",i]]]) { //此处判断，如果被播放的视频被删除了，则播放第一个
            //                    NSLog(@"aaabbbb");
            //                                }
            //                else{
            //                 [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
            //                    NSLog(@"asdasdasdasdasdasdasdasdasdasdas");
            //                }
            //            }
            ////                if (![self.dicTemp isEqualToArray:self.dicTemp]) { //此处判断，如果被播放的视频被删除了，则播放第一个
            ////                    [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
            ////                }
            //
            //
            ////            [self.socketView viewDidLoad];
            if (firstfirst == YES) {
                
                
                //                [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                //                firstOpenAPP = firstOpenAPP+1;
                
                //                firstfirst = NO;
                
            }else
            {}
            
        }];
        
        
        //        [self initProgressLine];
        
        [self.table reloadData];
        
        
    }];
    
    
}
-(void)testIP
{
    self.videoController.shouldAutoplay = YES;
    [self.videoController prepareToPlay];
    [self.videoController play];
    
}
#pragma mark - 防止在刚转到TV页面时就全屏展示，需要至少先等待0.1秒
-(void)preventTVViewOnceFullScreen
{   [USER_DEFAULT setObject:@"NO" forKey:@"modeifyTVViewRevolve"];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(modeifyTVViewRevolve) object:nil];
    [self performSelector:@selector(modeifyTVViewRevolve) withObject:nil afterDelay:0.1];
    //    [[NSRunLoop currentRunLoop] run];
}
-(void)modeifyTVViewRevolve
{
    [USER_DEFAULT setObject:@"YES" forKey:@"modeifyTVViewRevolve"];
}
@end
