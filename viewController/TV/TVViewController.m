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
#import "UICustomAlertView.h"
#import "UIViewController+animationView.h"
#import "UITextField+NOPasteTextField.h"

#define SCREEN_FRAME ([UIScreen mainScreen].bounds)
#define EndMJRefreshTime 12  //下拉刷新做12秒超时处理




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
    
    //    BOOL firstShow;
    BOOL playState;
    //    NSTimer * timerState;
    int tableviewinit;
    
    //状态栏显示状态
    
    int statusNum;
    int touchStatusNum; //这个是在点击播放器的时候会改变的数字，用于判断全屏下状态栏的显示
    
    //判断是不是第一次进入首页，如果是，则自动播放第一个节目
    int firstOpenAPP;
    
    //在进度条的地方 判断当前是不是一个节目
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
    
    //    UIAlertView *STBAlert;
    //    UIAlertView *CAAlert;
    UICustomAlertView *STBAlert;
    UICustomAlertView *CAAlert;
    
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
    NSString * indexpathRowStr;
    
    BOOL TVViewTouchPlay;
    BOOL isHasChannleDataList ;  //是否存频道列表，如果不存在，则在跳转页面的时候不播放
    int  numberOfRowsForTable;  //对于首页列表，每一个分类下的列表数量
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
@property (nonatomic, strong) NSTimer *timer;   //进度条的计时器
@property (nonatomic, strong) NSArray *progressViews;
@property (nonatomic, strong)  UIButton * searchBtn;
@property (nonatomic, strong)  TVTable * tableForSliderView;  //首页的频道列表tableView
@property (nonatomic, strong)  TVTable * tableForTemp;  //首页的频道列表
@property (nonatomic, strong)  NSMutableDictionary *  tableForDicIndexDic;  //数组保存首页每一个table和index的字典对应关系,用字典存储

@property (nonatomic, strong) NSTimer *ONEMinuteTimer; //用于一分钟一次刷新tableView列表
@property (nonatomic, strong) NSTimer *viewFirstShowTimer; //用于第一次展示时，计算多少秒刷新tableView列表
@property (strong,nonatomic)NSMutableArray * CategoryAndREC;        //category和REC录制组合起来之后的数组
@property (strong,nonatomic)NSMutableDictionary * RECAndLiveCellForRowsDic;  //用于
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
//@synthesize timerState; //不播放时候的计时器
@synthesize progressEPGArr;  //为了进度条，保存EPG，然后获取不同时间段的时间
@synthesize progressEPGArrIndex;
@synthesize ONEMinuteTimer;
@synthesize viewFirstShowTimer;
//@synthesize videoPlay;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    firstfirst = YES;
    tableviewinit = 1;
    firstOpenAPP = 0;
    IPString = @"";
    playState = NO;
    
    //每次播放前，都先把 @"deliveryPlayState" 状态重置，这个状态是用来判断视频断开分发后，除非用户点击
    [USER_DEFAULT setObject:@"beginDelivery" forKey:@"deliveryPlayState"];
    
    [self initData];    //table表
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    //打开时开始连接socket并且发送心跳
    self.socketView  = [[SocketView  alloc]init];
    //    [self.socketView viewDidLoad];
    //    firstShow =NO;
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
        
        //        self.NoDataImageview.image = [UIImage imageNamed:@"圆环-9"];
        //        self.NoDataImageview.frame = CGRectMake(100, tableForSliderView.frame.origin.y+50, SCREEN_WIDTH - 200, SCREEN_WIDTH - 200) ;
        //        self.NoDataImageview.alpha = 1;
        //
        //        //CGRectMake(tableForSliderView.frame.origin.x, tableForSliderView.frame.origin.y, tableForSliderView.frame.size.width, tableForSliderView.frame.size.height);
        //        [self.tableForSliderView addSubview:self.NoDataImageview];
        //        //        [_table bringSubviewToFront:self.kvo_NoDataImageview];
        NSLog(@"此时数据无，添加占位图");
        return;
    }else
    {
        self.NoDataImageview.alpha = 0;
        self.NoDataImageview = nil;
        [self.NoDataImageview removeFromSuperview];
        self.NoDataImageview.frame = CGRectMake(100000, tableForSliderView.frame.origin.y+500000, 1, 1) ;
        
        
        self.NoDataLabel.alpha = 0;
        self.NoDataLabel = nil;
        [self.NoDataLabel removeFromSuperview];
        self.NoDataLabel.frame = CGRectMake(100000, tableForSliderView.frame.origin.y+500000, 1, 1) ;
  
        return;
    }
    
    
    //有数据
    //    [[BJNoDataView shareNoDataView] clear];
}
- (void)applicationWillResignActive:(NSNotification *)notification
{
    self.video.playUrl = @"";
    
    [self.videoController.player stop];
    
    
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
    searchViewCon.dataList =  [searchViewCon getServiceArray ];  //dataList 是所有的名字和符号的组合
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
        //        [self.view addSubview:_lineView];
    }
    return _lineView;
}
#pragma mark --防止刚开始没有网络的时候时候显示一天线和搜索框，可能会造成崩溃
-(void)lineAndSearchBtnShow
{
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:_lineView];
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
    self.tableForDicIndexDic = [[NSMutableDictionary alloc]init];

    progressEPGArr = [[NSMutableArray alloc]init];
    
    tempTableviewForFocus = [[UITableView alloc]init]; //用于保存全屏页面点击时候的焦点
    tempIndexpathForFocus = [[NSIndexPath alloc]init];  //用于保存全屏页面点击时候的焦点
    
    tempArrForServiceArr = [[NSArray alloc]init]; //用于保存点击后的列表数组信息
    tempBoolForServiceArr = NO;
    tempDicForServiceArr = [[NSDictionary alloc]init];
    
    self.NoDataImageview = [[UIImageView alloc]init];
    self.NoDataLabel = [[UILabel alloc]init];
    
    self.TVSubAudioDic = [[NSDictionary alloc]init];
    self.TVChannlDic = [[NSDictionary alloc]init];
    STBTextField_Encrypt = [[UITextField alloc]init];
    CATextField_Encrypt = [[UITextField alloc]init];
    STBTouch_Dic  = [[NSDictionary alloc]init];
    
    STBAlert = [[UICustomAlertView alloc] initWithTitle:@"Please input your Decoder PIN" message:@"" delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel",nil]
    ;
    STBAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    
    CAAlert = [[UICustomAlertView alloc] initWithTitle:@"Please input CA PIN" message:@"" delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:@"Cancel",nil];
    CAAlert.alertViewStyle = UIAlertViewStyleSecureTextInput; //UIAlertViewStylePlainTextInput;
    
    channelStartimesList = [[NSMutableSet alloc]init];
    storeLastChannelArr = [[NSMutableArray alloc]init];
    
    CAAlert.dontDisppear = YES;
    STBAlert.dontDisppear = YES;
    
    self.CategoryAndREC = [[NSMutableArray alloc]init];
    self.RECAndLiveCellForRowsDic = [[NSMutableArray alloc]init];
}

#pragma mark - 获取Json数据的方法
//获取table
-(void) getServiceData
{
    isHasChannleDataList = YES;
    
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
    
    
    [request startAsynchronous];
    
    WEAKGET
    [request setCompletionBlock:^{
        
        
        
        NSDictionary *response = httpRequest.responseString.JSONValue;
        
        //将数据本地化
        [USER_DEFAULT setObject:response forKey:@"TVHttpAllData"];
        
        NSArray *data1 = response[@"service"];
        
        //录制节目,保存数据
        NSArray *recFileData = response[@"rec_file_info"];
        NSLog(@"recFileData %@",recFileData);
        [USER_DEFAULT setObject:recFileData forKey:@"categorysToCategoryViewContainREC"];
        
        
        
        if ( data1.count == 0 && recFileData.count == 0){
            //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空

            if (response[@"data_valid_flag"] != NULL || [response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                //机顶盒连接成功了，但是没有数据
                //显示列表为空的数据
                
                if (_slideView) {
                    [_slideView removeFromSuperview];
                    _slideView = nil;
                    
                }
                
                self.NoDataImageview = [[UIImageView alloc]init];
                self.NoDataImageview.image = [UIImage imageNamed:@"无频道列表@3x"];
                self.NoDataImageview.frame = CGRectMake((SCREEN_WIDTH - 60)/2, (SCREEN_HEIGHT -(64.5+kZXVideoPlayerOriginalHeight+1.5 + 110 + 49))/2 + 64.5+kZXVideoPlayerOriginalHeight+1.5 ,  60,  60) ;
                self.NoDataImageview.alpha = 1;
                [self.view addSubview:self.NoDataImageview];
                self.NoDataLabel = [[UILabel alloc]init];
                self.NoDataLabel.text = @"Channel List is empty";
                self.NoDataLabel.textColor = UIColorFromRGB(0x848484);
                //
                CGSize sizeNoDataLabel = [GGUtil sizeWithText:@"Channel List is empty" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                
                self.NoDataLabel.frame = CGRectMake((SCREEN_WIDTH - sizeNoDataLabel.width)/2,self.NoDataImageview.frame.origin.y + 10 + self.NoDataImageview.frame.size.height , sizeNoDataLabel.width, sizeNoDataLabel.height);
                self.NoDataLabel.textAlignment = NSTextAlignmentCenter;
                self.NoDataLabel.alpha = 1;
                [self.view addSubview:self.NoDataLabel];
                
                isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
                [self removeTipLabAndPerformSelector];   //取消不能播放的文字
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
                
                
            }else
            {
                double delayInSeconds = 1;
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, mainQueue, ^{
                    NSLog(@"延时执行的2秒");
                    //机顶盒连接出错了，所以要显示没有网络的加载图
                    [self getServiceData]; //如果数据为空，则重新获取数据
                });
                
                [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
                NSLog(@"可能会出现播放器空白的情况");
                return ;
            }
           
        }
        self.serviceData = (NSMutableArray *)data1; //data1 代表service
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
       
        
        BOOL serviceDatabool = [self judgeServiceDataIsnull];
        if (serviceDatabool && recFileData.count == 0) {
            //            [self getServiceData]; //如果 self.serviceData 数据为空，则重新获取数据
            if (response[@"data_valid_flag"] != NULL || [response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                
                //机顶盒连接成功了，但是没有数据
                //显示列表为空的数据
                if (_slideView) {
                    [_slideView removeFromSuperview];
                    _slideView = nil;
                    
                }
                
                if (!self.NoDataImageview) {
                    self.NoDataImageview = [[UIImageView alloc]init];
                    
                }
                
            
                self.NoDataImageview.image = [UIImage imageNamed:@"无频道列表@3x"];
                
                self.NoDataImageview.frame = CGRectMake((SCREEN_WIDTH - 60)/2, (SCREEN_HEIGHT -(64.5+kZXVideoPlayerOriginalHeight+1.5 + 110 + 49))/2 + 64.5+kZXVideoPlayerOriginalHeight+1.5 ,  60,  60) ;
              
                self.NoDataImageview.alpha = 1;
                [self.view addSubview:self.NoDataImageview];
                
                
                if (!self.NoDataLabel) {
                    self.NoDataLabel = [[UILabel alloc]init];
                    
                }
                self.NoDataLabel.text = @"Channel List is empty";
                self.NoDataLabel.textColor = UIColorFromRGB(0x848484);
                //
                CGSize sizeNoDataLabel = [GGUtil sizeWithText:@"Channel List is empty" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                
                self.NoDataLabel.frame = CGRectMake((SCREEN_WIDTH - sizeNoDataLabel.width)/2,self.NoDataImageview.frame.origin.y + 10 + self.NoDataImageview.frame.size.height , sizeNoDataLabel.width, sizeNoDataLabel.height);
                self.NoDataLabel.textAlignment = NSTextAlignmentCenter;
                self.NoDataLabel.alpha = 1;
                [self.view addSubview:self.NoDataLabel];
                
                //
                
                
                isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
                [self removeTipLabAndPerformSelector];   //取消不能播放的文字
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
            }else
            {
                //机顶盒连接出错了，所以要显示没有网络的加载图
                [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];

                [self getServiceData]; //如果数据为空，则重新获取数据
                //                return ;
            }
        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        [self lineAndSearchBtnShow];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notHaveNetWork) object:nil];
        [self playVideo];
        
        
        //////
        //获取数据的链接
        NSString *urlCate = [NSString stringWithFormat:@"%@",S_category];
        
        
        LBGetHttpRequest *request = CreateGetHTTP(urlCate);
        
        
        
        [request startAsynchronous];
        
        WEAKGET
        [request setCompletionBlock:^{
            NSDictionary *response = httpRequest.responseString.JSONValue;
            
            NSArray *data = response[@"category"];
            
            if (data.count == 0 && recFileData.count == 0){ //没有数据
                
                [USER_DEFAULT setObject:@"RecAndLiveNotHave" forKey:@"RECAndLiveType"];
                return ;
            }else if(data.count == 0 && recFileData.count != 0){ //有录制没直播
             
                [USER_DEFAULT setObject:@"RecExit" forKey:@"RECAndLiveType"];
                
                // 特殊情况，有录制但是没有service数据
                [self.CategoryAndREC removeAllObjects];
                [self.CategoryAndREC addObject: recFileData];
                
            }else if(recFileData.count == 0 && data.count != 0) //有直播没录制
            {
                [USER_DEFAULT setObject:@"LiveExit" forKey:@"RECAndLiveType"];
                
                [self.CategoryAndREC removeAllObjects];
                [self.CategoryAndREC addObject:data];
            }else //两种都有
            {
                [USER_DEFAULT setObject:@"RecAndLiveAllHave" forKey:@"RECAndLiveType"];
                
                [self.CategoryAndREC removeAllObjects];
                [self.CategoryAndREC addObject:data];
                [self.CategoryAndREC addObject: recFileData];
            }
            self.categorys = (NSMutableArray *)data;
            
            if (!_slideView) {
 
                //判断是不是全屏
                BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
                if (isFullScreen == NO) {   //竖屏状态
                    
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.CategoryAndREC];
                    isHasChannleDataList = YES;
                    [self.tableForDicIndexDic removeAllObjects];
                    [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
                    NSNotification *notification1 =[NSNotification notificationWithName:@"fullScreenBtnShow" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                }else //横屏状态，不刷新
                {
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.CategoryAndREC];
                    
                    [self.tableForDicIndexDic removeAllObjects];
                    [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
                    NSNotification *notification1 =[NSNotification notificationWithName:@"fullScreenBtnShow" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                }
                
                
                NSArray *ArrayTocategory = [NSArray arrayWithArray:self.CategoryAndREC];
                [USER_DEFAULT setObject:ArrayTocategory forKey:@"categorysToCategoryView"];
                
                
                _slideView.backgroundColor = [UIColor whiteColor];
                _slideView.delegate        = self;
                
                [self.view addSubview:_slideView];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                
            }
            else
            {
                
            }
            [self.socketView viewDidLoad];
            if (firstfirst == YES) {
        
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
            
            [USER_DEFAULT  setObject:@"YES" forKey:@"viewHasAddOver"];  //第一次进入时，显示页面加载完成
            
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
    //    [self.view addSubview:self.searchBtn];
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
    self.video.playEventName = self.event_videoname;
    NSLog(@"self.video.channelName : %@",self.video.channelName);
    
    
    
}
-(void)refreshTableviewByEPGTime //由于EPG时间要发生变化，所以此处要刷新他
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger beforeRefreshIndex = self.category_index; //由于刷新后，列表的index会迅速变换为0，所以这里要做一个等级
        [_slideView reloadData];
        [self.tableForTemp reloadData];
        [tableForSliderView reloadData];
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
   
}
#pragma mark - 被播放的节目变蓝
-(void)tableViewCellToBlue :(NSInteger)numberOfIndex  indexhah :(NSInteger)numberOfIndexForService AllNumberOfService:(NSInteger)AllNumberOfServiceIndex
{
    NSNumber * numIndex = [NSNumber numberWithInteger:numberOfIndex];   //分类中第几个
    NSNumber * numIndex2 = [NSNumber numberWithInteger:numberOfIndexForService];  //列表中的第几个
    NSNumber * numIndex3 = [NSNumber numberWithInteger:AllNumberOfServiceIndex];    //列表一共有几个
    
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
    NSLog(@"已经跳转到firstopen方法 在playVideo 中播放");
    NSLog(@"playvideo 的线程");
    if (!self.videoController) {
        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, VIDEOHEIGHT, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight)];
        //         self.videoController.frame = CGRectMake(0, VIDEOHEIGHT, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight);
       
        
        //**用于刷新列表的timer 设置，防止在没网的情况下，过长时间停留在无网络图下，又可能出现异常
        NSString * nowTimeStr = [GGUtil GetNowTimeString];
        //    NSInteger nowTimeInteger = [nowTimeStr integerValue];
        //    NSInteger nowTimeMinuteInteger = nowTimeInteger / 60;
        //    NSInteger firstRefreshTime = (nowTimeMinuteInteger + 1) * 60 - nowTimeInteger;
        NSInteger firstRefreshTime = ([nowTimeStr integerValue] / 60 + 1) * 60 - [nowTimeStr integerValue] + 2;
        //刚进来，先整点刷新一次   repeats:NO
        viewFirstShowTimer = [NSTimer scheduledTimerWithTimeInterval:firstRefreshTime target:self selector:@selector(tableViewDataRefreshForMjRefresh_ONEMinute) userInfo:nil repeats:NO];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshTableviewOneMinute) object:nil];
        [self performSelector:@selector(refreshTableviewOneMinute) withObject:nil afterDelay:firstRefreshTime];
        //*******
        
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
            //            firstShow = YES;
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
            float noewWidth = SCREEN_WIDTH;
            
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
            [self judgeProgressIsNeedHide:NO]; //判断进度条需不需要隐藏，第一个参数表示是否全屏
            
            _lineView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 0.5);
            
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
  
                //                firstShow = NO;
                statusNum = 3;
                [self prefersStatusBarHidden];
                [self setNeedsStatusBarAppearanceUpdate];
                self.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
           
                self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY+1000, searchBtnWidth, searchBtnHeight);
               
                self.navigationController.navigationBar.translucent = NO;
                self.extendedLayoutIncludesOpaqueBars
                = NO;
                
                self.edgesForExtendedLayout =UIRectEdgeNone;
                float noewWidth = SCREEN_HEIGHT;
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",noewWidth],@"noewWidth",nil];
                
                
                
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"fixTopBottomImage" object:nil userInfo:dict];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                UIViewController * viewNow = [self currentViewController];
                if ([viewNow isKindOfClass:[TVViewController class]]) {
                    self.tabBarController.tabBar.hidden = YES;
                }
                
                //                self.view.frame = CGRectMake(0, 0, 800, 800);
                _slideView.frame = CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                              SCREEN_WIDTH,
                                              SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5);
               
                NSLog(@"目前是全屏");
                NSLog(@"目前是全屏sliderview:%f",_slideView.frame.origin.y);
                
                ////////****************** 进度条
                //此处销毁通知，防止一个通知被多次调用   //5
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fixprogressView" object:nil ];
                //注册通知
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fixprogressView:) name:@"fixprogressView" object:nil];
                
                self.topProgressView.frame = CGRectMake(0, SCREEN_WIDTH -50 , SCREEN_HEIGHT, 2);
                
                
                //            //此处销毁通知，*防止一个通知被多次调用
                //    NSNotificationCenter a = [[NSNotificationCenter defaultCenter] removeObserver:self];
                //            //注册通知
                //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"test" object:nil];
                
                
                
                [self.view bringSubviewToFront:self.topProgressView];
                [self.videoController.view bringSubviewToFront:self.topProgressView];
                [USER_DEFAULT setObject:@"YES" forKey:@"topProgressViewISNotExist"];
                
                [self judgeProgressIsNeedHide:YES]; //判断进度条需不需要隐藏，第一个参数表示是否全屏
                //            [self setFullScreenView];
                
                NSLog(@"全屏宽 ： %f",SCREEN_HEIGHT);
                
                
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
                _lineView.frame = CGRectMake(0, -64, 0, 0);
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
    
    
    if (self.showTVView == YES) {
        self.videoController.video = self.video;
    }else
    {
        
    }
  
}

-(void)setFullScreenView
{
    _fullScreenView = [[FullScreenView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
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
    
    //    [self.navigationController pushViewController:searchViewCon animated:YES];
    if(![self.navigationController.topViewController isKindOfClass:[searchViewCon class]]) {
        [self.navigationController pushViewController:searchViewCon animated:YES];
    }else
    {
        NSLog(@"此处可能会由于页面跳转过快报错");
    }
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
    NSLog(@"CategoryAndREC.count %lu",(unsigned long)_CategoryAndREC.count);
    NSLog(@"CategoryAndREC.cou %@",_CategoryAndREC);
    int  columntemp = [self CategoryAndRECArrReplace:self.CategoryAndREC];
    return columntemp;
}
-(int)CategoryAndRECArrReplace:(NSMutableArray*)columnTempArr
{
    int * tempInt ;
    /*
     1.先判断是那种类型，录制和直播节目是否同时存在
     2.根部不同的类别进行数据组合和最后的赋值
     **/
    //#define   RecAndLiveNotHave  @"0"      //录制和直播都不存在
    //#define   RecExit            @"1"      //录制存在直播不存在
    //#define   LiveExit           @"2"      //录制不存在直播存在
    //#define   RecAndLiveAllHave  @"3"      //录制直播都存在
    NSString * RECAndLiveType = [USER_DEFAULT objectForKey:@"RECAndLiveType"];
    NSLog(@"RECAndLiveType %@",RECAndLiveType);
    
    if ([RECAndLiveType isEqualToString:@"RecAndLiveNotHave"]) {  //都不存在
        tempInt = columnTempArr.count;
    }else if ([RECAndLiveType isEqualToString:@"RecExit"]){ //录制存在直播不存在
//        [_titles addObject:@"Recordings"];
        tempInt = columnTempArr.count;
    }else if ([RECAndLiveType isEqualToString:@"LiveExit"]){ //录制不存在直播存在
        
        NSArray * arrTemp = columnTempArr[0];
        tempInt =arrTemp.count;

        
    }else if([RECAndLiveType isEqualToString:@"RecAndLiveAllHave"]){//都存在
        if (columnTempArr.count == 2 ) {   //正常情况
            NSArray * arrTemp = columnTempArr[0];
            tempInt =arrTemp.count + 1;
           
        }else if(columnTempArr.count == 1 )  //异常刷新，数组中只有一个元素
        {
        }
        
    }

  
    return tempInt;
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
    NSString *  indexforTableToNum =  [NSString stringWithFormat:@"%lu",(unsigned long)index];
    //    [NSNumber numberWithInteger:index];
    [arrTemp addObject:indexforTableToNum];
    [arrTemp addObject:tableForSliderView];
    
    //    NSString * indexforTableToStr = [NSString stringWithFormat:@"%@",dicTableAndIndex];
    //
    //    [dicTableAndIndex setValue:tableForSliderView forKey:indexforTableToStr]; //将table保存为字典的序号
    //
    
    int categorysNum =  self.categorys.count;
    NSLog(@"categorysNum %d",categorysNum);
   
    if (self.tableForDicIndexDic.count < categorysNum) {
        [self.tableForDicIndexDic setObject:arrTemp forKey:[NSString stringWithFormat:@"%@",arrTemp[0]]];
    }else
    {
       
        [self.tableForDicIndexDic removeAllObjects];
        [self.tableForDicIndexDic setObject:arrTemp forKey:[NSString stringWithFormat:@"%@",arrTemp[0]]];
    }
    
    return tableForSliderView;
}
// 头部的下 拉刷新触发事件
- (void)headerClick {
    
    self.tableForSliderView =  self.tableForTemp;
    // 可在此处实现下拉刷新时要执行的代码
    // ......
    
    [self tableViewDataRefreshForMjRefresh];  //重新获取json数据
    //    [self tableViewDataRefresh];
    NSLog(@"tableForDicIndexDic:%@",self.tableForDicIndexDic);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.tableForTemp = scrollView;
    NSLog(@"self.tableForTemp%@",self.tableForTemp);
}
#define mark - 主页横向类别列表
- (void)slideVisibleView:(TVTable *)cell forIndex:(NSUInteger)index{
    
    NSLog(@"index :%@ ",@(index));
    NSLog(@"self.category_index :%d",index);
    
    if(index < 10000)
    {
        self.category_index = index;
        cell.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        //self.categorys[i]                          不同类别
        //self.categoryModel.service_indexArr        类别的索引数组
        //self.categoryModel.service_indexArr.count
        //给不同的table赋值
        //    for (int i = 0 ; i<self.categorys.count; i++) {
        
        int playTypeClass;
        int if_Has_REC = 0;
        playTypeClass = [GGUtil judgePlayTypeClass];
        if(playTypeClass == 1 || playTypeClass == 3)
        {
            if_Has_REC = 1;
        }else
        {
            if_Has_REC = 0;
        }
        if (index < self.categorys.count + if_Has_REC ) {
            /*
             判断是否存在录制
             **/
            //#define   RecAndLiveNotHave  @"0"      //录制和直播都不存在
            //#define   RecExit            @"1"      //录制存在直播不存在
            //#define   LiveExit           @"2"      //录制不存在直播存在
            //#define   RecAndLiveAllHave  @"3"      //录制直播都存在
//            int playTypeClass;
//            playTypeClass = [GGUtil judgePlayTypeClass];
            if (playTypeClass == 0) {
            }else if (playTypeClass == 1){
                
            }else if (playTypeClass == 2){
                
                NSDictionary *item = self.categorys[index];   //当前页面类别下的信息
                self.categoryModel = [[CategoryModel alloc]init];
                self.categoryModel.service_indexArr = item[@"service_index"];
                
                [self.dicTemp removeAllObjects];
                
                //获取不同类别下的节目，然后是节目下不同的cell值
                for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {
                    int indexCat ;
                    if (i < self.categoryModel.service_indexArr.count) {
                        indexCat =[self.categoryModel.service_indexArr[i] intValue];
                    }else
                    {
                        return;
                    }
                    
                       
                    //此处判断是否为空，防止出错
                    if ( ISNULL(self.serviceData)) {
                        
                    }else{
                        if (indexCat -1 < self.serviceData.count) {
                            [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
                            
                        }else
                        {
                            return;
                        }
                        
                    }
                    
                }
        
            }else if (playTypeClass == 3){
                
                if (index == 0) {
                    
                    NSDictionary *item = self.categorys[index];   //当前页面类别下的信息
                    self.categoryModel = [[CategoryModel alloc]init];
              
                    self.categoryModel.service_indexArr = item[@"service_index"];
                  
                    [self.dicTemp removeAllObjects];
                    
                    //获取不同类别下的节目，然后是节目下不同的cell值                10
                    for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {
                        
                        int indexCat ;
                        if (i < self.categoryModel.service_indexArr.count) {
                            indexCat =[self.categoryModel.service_indexArr[i] intValue];
                        }else
                        {
                            return;
                        }
                        //此处判断是否为空，防止出错
                        if ( ISNULL(self.serviceData)) {
                            
                        }else{
                          
                            if (indexCat -1 < self.serviceData.count) {
                                [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
                                
                            }else
                            {
                                return;
                            }
                            
                            
                        }
                        
                    }
                    
                    numberOfRowsForTable = self.categoryModel.service_indexArr.count;
                }else if (index == 1)
                {
                    
                    
                    
                    //如果发现第二列，则展示REC这个数组
                    NSArray * RECTempArr = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
                    self.categoryModel.service_indexArr = RECTempArr;
                    numberOfRowsForTable = RECTempArr.count;
                    
                    /*
                     用于分别获取REC Json数据中的值
                     **/
                    
                    [self.dicTemp removeAllObjects];
                    
                    for (int i = 0; i< RECTempArr.count ; i++) {
                        [self.dicTemp setObject:RECTempArr[i] forKey:[NSString stringWithFormat:@"%d",i] ];
                    }
                    
                }else  //录制分类之后的节目分类
                {
                    NSDictionary *item = self.categorys[index - 1];   //当前页面类别下的信息
                    self.categoryModel = [[CategoryModel alloc]init];
                    
                    
                    self.categoryModel.service_indexArr = item[@"service_index"];
                    
       
                    //获取EPG信息 展示
                    //时间戳转换
                    
                    [self.dicTemp removeAllObjects];
                    
                    //获取不同类别下的节目，然后是节目下不同的cell值                10
                    for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {
                        
                        int indexCat ;
                        if (i < self.categoryModel.service_indexArr.count) {
                            indexCat =[self.categoryModel.service_indexArr[i] intValue];
                        }else
                        {
                            return;
                        }
                        //此处判断是否为空，防止出错
                        if ( ISNULL(self.serviceData)) {
                        }else{
                         
                            if (indexCat -1 < self.serviceData.count) {
                                [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
                                
                            }else
                            {
                                return;
                            }
                            
                            
                        }
                        
                    }
                    
                    numberOfRowsForTable = self.categoryModel.service_indexArr.count;
                }
                
                
//                self.dicTemp
//                aaa
            }
            
        }

        [cell reloadData]; //刷新TableView
    
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
    NSLog(@"sectionsection %ld",(long)section);
    //#define   RecAndLiveNotHave  @"0"      //录制和直播都不存在
    //#define   RecExit            @"1"      //录制存在直播不存在
    //#define   LiveExit           @"2"      //录制不存在直播存在
    //#define   RecAndLiveAllHave  @"3"      //录制直播都存在
    int playTypeClass;
    playTypeClass = [GGUtil judgePlayTypeClass];
    if (playTypeClass == 0) {
        return 0;
    }else if (playTypeClass == 1){
        //algorithm /swift / datastruct / OC
        //jiagou /
        return 1;
    }else if (playTypeClass == 2){
        NSLog(@"%lu",(unsigned long)self.serviceData.count);
        NSLog(@"llself.serviceData %@",self.serviceData);
        NSLog(@"当前tableView个数 :%lu",self.categoryModel.service_indexArr.count);
        nwoTimeBreakStr = [GGUtil GetNowTimeString];  //获得时间戳，用于对tableView表的数据进行定位
        self.kvo_NoDataPic.numberOfTable_NoData = [NSString stringWithFormat:@"%lu",(unsigned long)self.categoryModel.service_indexArr.count];
        
        return self.categoryModel.service_indexArr.count;
    }else if (playTypeClass == 3){
       
        NSLog(@"%lu",(unsigned long)self.serviceData.count);
        NSLog(@"当前tableView个数 :%lu",numberOfRowsForTable);
        nwoTimeBreakStr = [GGUtil GetNowTimeString];  //获得时间戳，用于对tableView表的数据进行定位
        self.kvo_NoDataPic.numberOfTable_NoData = [NSString stringWithFormat:@"%lu",(unsigned long)numberOfRowsForTable];
        
        return numberOfRowsForTable;
 
    }
    
    
    
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
        
    }
    
    
    
    if (!ISEMPTY(self.dicTemp)) {
        cell.nowTimeStr = nwoTimeBreakStr;  //这里的nwoTimeBreakStr 是在numbeOfrows获取的当前时间
        cell.dataDic = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//        cell.RECAndLiveDataDic = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        
        int playTypeClass;
        playTypeClass = [GGUtil judgePlayTypeClass];
        if (playTypeClass == 0) {
        }else if (playTypeClass == 1){
            
        }else if (playTypeClass == 2){
      
        }else if (playTypeClass == 3){
            
            //            RECAndLiveDataArr
            NSLog(@"self.dicTempself.dicTemp%@",self.dicTemp);
            
            if (numberOfRowsForTable == 1) {
            }else
            {
                
            }

        }
   
        //焦点
        NSDictionary * fourceDic = [USER_DEFAULT objectForKey:@"NowChannelDic"];
        if ([GGUtil judgeTwoEpgDicIsEqual:cell.dataDic TwoDic:fourceDic]) { //[cell.dataDic isEqualToDictionary:fourceDic]
            
            //                int indexForJudgeService = i;
            //                 NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
            [cell.event_nextNameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
            [cell.event_nameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
            [cell.event_nextTime setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
            NSLog(@"asbfabsfkabfjabfkab11");
            
        }else
        {
            NSLog(@"asbfabsfkabfjabfkab");
            [cell.event_nextNameLab setTextColor:CellGrayColor];  //CellGrayColor
            [cell.event_nameLab setTextColor:CellBlackColor];  //CellBlackColor
            [cell.event_nextTime setTextColor:CellGrayColor];//[UIColor greenColor]
            
            
        }
        
  
    }else{//如果为空，什么都不执行
    }
    
    
    return cell;
    
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
  
    [cell.event_nextNameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
    [cell.event_nameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
    [cell.event_nextTime setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        
        dispatch_async(dispatch_get_global_queue(0, 0),^{
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
            
        });
    }
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateFullScreenDic];
    TVViewTouchPlay = YES;
    //每次播放前，都先把 @"deliveryPlayState" 状态重置，这个状态是用来判断视频断开分发后，除非用户点击
    [USER_DEFAULT setObject:@"beginDelivery" forKey:@"deliveryPlayState"];
    
    
    tempBoolForServiceArr = YES;
    tempArrForServiceArr =  self.categoryModel.service_indexArr;
    tempDicForServiceArr = self.TVChannlDic;
    
    self.video.dicChannl = [tempDicForServiceArr mutableCopy];
    self.video.channelCount = tempArrForServiceArr.count;
    NSLog(@"self.video.channelCount ]]] %d",self.video.channelCount);
    tempIndexpathForFocus = indexPath;
 
    //====快速切换频道名称和节目名称
    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
    //创建通知
    NSNotification *notification2 =[NSNotification notificationWithName:@"setChannelNameAndEventNameNotic" object:nil userInfo:nowPlayingDic];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
    //====快速切换频道名称和节目名称
    
    
    indexpathRowStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didselectRowToPlayClick) object:nil];
    [self performSelector:@selector(didselectRowToPlayClick) withObject:nil afterDelay:0.3];
    
    //=====则去掉不能播放的字样，加上加载环
    //    NSNotification *notification1 =[NSNotification notificationWithName:@"noPlayShowShutNotic" object:nil userInfo:nil];
    //    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    //
    //    NSNotification *notification =[NSNotification notificationWithName:@"IndicatorViewShowNotic" object:nil userInfo:nil];
    //    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self removeLabAndAddIndecatorView];
    //=====则去掉不能播放的字样，加上加载环
    
    
    //加入历史记录
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self addHistory:indexPath.row diction:self.dicTemp];
        [USER_DEFAULT setObject:@"NO" forKey:@"audioOrSubtTouch"];
        [USER_DEFAULT setObject:tempArrForServiceArr forKey:@"tempArrForServiceArr"];
        [USER_DEFAULT setObject:tempDicForServiceArr forKey:@"tempDicForServiceArr"];
        [self.videoController setaudioOrSubtRowIsZero];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performChangeColor) object:nil];
            [self performSelector:@selector(performChangeColor) withObject:nil afterDelay:0.2];
        });
        //变蓝

    });
    
    //    //关闭当前正在播放的节目
    [self.videoController.player stop];
    [self.videoController.player shutdown];
    [self.videoController.player.view removeFromSuperview];
    
    
    [tableView scrollToRowAtIndexPath:indexPath  atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    
}

#pragma mark - 点击tableView 变蓝
-(void)performChangeColor
{
    int indexOfCategory =  self.category_index;
    
        NSLog(@"indexOfCategory %d",indexOfCategory);
        NSLog(@"self.categorys %@",self.categorys);
        NSArray * allNumberOfServiceArr ;
    
    NSArray * categoryTempArr = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
    if (categoryTempArr.count >1 && categoryTempArr != NULL && categoryTempArr !=nil) {
        //有录制有直播
        
       

            if (indexOfCategory == 0) {
                allNumberOfServiceArr = [self.categorys[indexOfCategory] objectForKey:@"service_index"];

                [self tableViewCellToBlue:indexOfCategory indexhah:[indexpathRowStr integerValue] AllNumberOfService:allNumberOfServiceArr.count];
            }else if (indexOfCategory == 1) {
                allNumberOfServiceArr = categoryTempArr;

                [self tableViewCellToBlue:indexOfCategory indexhah:[indexpathRowStr integerValue] AllNumberOfService:allNumberOfServiceArr.count];
            }else if (indexOfCategory > 1){
                allNumberOfServiceArr = [self.categorys[indexOfCategory -1] objectForKey:@"service_index"];

                [self tableViewCellToBlue:indexOfCategory indexhah:[indexpathRowStr integerValue] AllNumberOfService:allNumberOfServiceArr.count];
            }else
            {
                return;
            }
       
        
        
    }else
    {
        if (self.categorys.count > indexOfCategory) {
            allNumberOfServiceArr = [self.categorys[indexOfCategory] objectForKey:@"service_index"];
        }else
        {
            return;
        }
        
        [self tableViewCellToBlue:indexOfCategory indexhah:[indexpathRowStr integerValue] AllNumberOfService:allNumberOfServiceArr.count];
    }
 
}
#pragma mark - didselecttableview 方法中播放事件
-(void)didselectRowToPlayClick
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger  indexPathRow = [indexpathRowStr integerValue];
        NSLog(@" indexPathRow %lu",(unsigned long)indexPathRow);
        //=======机顶盒加密
        NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:indexPathRow serviceListDic:self.dicTemp];
        if (characterStr != NULL && characterStr != nil) {
            BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
            if (judgeIsSTBDecrypt == YES) {
                
                //将上一个节目关闭
                [self stopVideoPlay];
            
                // 此处代表需要记性机顶盒加密验证
                NSNumber  *numIndex = [NSNumber numberWithInteger:indexPathRow];
                NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"LiveTouch",@"textThree",nil];
                //创建通知
                NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
              
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification1];
                
                firstOpenAPP = firstOpenAPP+1;
                firstfirst = NO;
            }else //正常播放的步骤
            {
                [self touchSelectChannel:indexPathRow diction:self.dicTemp];
                
                firstOpenAPP = firstOpenAPP+1;
                
                firstfirst = NO;
            
            }
            
        }else //正常播放的步骤
        {
            //======机顶盒加密
            [self touchSelectChannel:indexPathRow diction:self.dicTemp];
            firstOpenAPP = firstOpenAPP+1;
            firstfirst = NO;
        }
        
    });
    
   
}

#pragma  mark - 关闭当前正在播放的视频节目
-(void)stopVideoPlay
{
    [self.videoController.player shutdown];
    [self.videoController.player.view removeFromSuperview];
    self.videoController.player = nil;
    
}
#pragma mark - 获取信息，准备播放
- (void)getDataService:(NSNotification *)text{
    
    if (self.showTVView == YES) {
        
        NSLog(@"%@",text.userInfo[@"playdata"]);
        NSLog(@"－－－－－接收到通知------");
        //NSData --->byte[]-------NSData----->NSString
        
        _byteDatas = [[NSMutableData alloc]init];
        
        //此处加入判断语句，判断返回的结果RET是否满足几个报错信息
        NSData * retData = [[NSData alloc]init];
        //获得数据区的长度
        if ([[USER_DEFAULT objectForKey:@"data_service11"] length] >=  16) {
            
            retData = [[USER_DEFAULT objectForKey:@"data_service11"] subdataWithRange:NSMakeRange(12, 4)];
        }else
        {
            return;
        }
        
        int value = CFSwapInt32BigToHost(*(int*)([retData bytes]));
        NSLog(@"value : %d",value);
        //通过获得data数据减去发送的data数据得到播放连接，一下是返回数据的ret，如果ret不等于0则报错
        BOOL getLinkDataBool = [self  getLinkData :value tempDataA:[USER_DEFAULT objectForKey:@"data_service"] tempDataB:[USER_DEFAULT objectForKey:@"data_service11"] type:@"Live"];
        if (getLinkDataBool == YES) {
            
            self.video.playUrl = @"";
            self.video.playUrl = [[NSString alloc] initWithData:_byteDatas encoding:NSUTF8StringEncoding];
           
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

            [USER_DEFAULT setObject:@"NO" forKey:@"isStartBeginPlay"]; //是否已经开始播放，如果已经开始播放，则停止掉中心点的旋转等待圆圈
            
            
            //==========正文
            double delayInSeconds = 0;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                NSLog(@"延时执行的2秒");
                //        [self runThread1];
                [USER_DEFAULT setObject:@"YES" forKey:@"isStartBeginPlay"]; //是否已经开始播放，如果已经开始播放，则停止掉中心点的旋转等待圆圈
                [self playVideo];
            });
            
            
    
            
            playState = NO;
            
           
            
            if (self.showTVView == YES) {
                [self ifNeedPlayClick];
            }else
            {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
                NSLog(@"取消25秒的等待2");
            }
           
            [self removeTopProgressView];
            [self.timer invalidate];
            self.timer = nil;
            
            //用于判断进度条类型
            [USER_DEFAULT setObject:@"LiveChannel" forKey:@"ChannelType"];
            
            //** 计算进度条
            if(self.event_startTime.length != 0 || self.event_endTime.length != 0)
            {
                [self.view addSubview:self.topProgressView];
                [self.view bringSubviewToFront:self.topProgressView];
                [USER_DEFAULT setObject:@"YES" forKey:@"topProgressViewISNotExist"];
                
                NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                NSLog(@"self.event_startTime--==%@",self.event_startTime);
                NSLog(@"self.event_startTime--==%@",self.event_endTime);
                if (ISNULL(self.event_startTime) || self.event_startTime == NULL || self.event_startTime == nil || ISNULL(self.event_endTime) || self.event_endTime == NULL || self.event_endTime == nil || self.event_startTime.length == 0 || self.event_endTime.length == 0) {
                    
                    NSLog(@"此处可能报错，因为StarTime不为空 ");
                    NSLog(@"在getDataService里面调用 replaceEventNameNotific");
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
                      
                        progressEPGArrIndex = 0;
                        
                        
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress:) userInfo:dict repeats:YES];
                        
                        int tempIndex =progressEPGArrIndex;
                        NSString * tempIndexStr = [NSString stringWithFormat:@"%d",tempIndex];
                        [USER_DEFAULT setObject:tempIndexStr  forKey:@"nowChannelEPGArrIndex"];
                        //此处应该加一个方法，判断 endtime - starttime 之后，让进度条刷新从新计算
                        NSInteger endTime =[self.event_endTime intValue ];
                        //                NSInteger startTime =[self.event_startTime intValue ];
                        
                        //                NSDate *senddate = [NSDate date];
                        //                NSLog(@"date1时间戳 = %ld",time(NULL));
                        NSString *nowDate = [GGUtil GetNowTimeString];
                        NSInteger endTimeCutStartTime =endTime-[nowDate integerValue];
                        
                        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressRefresh) object:nil];
                        [self performSelector:@selector(progressRefresh) withObject:nil afterDelay:endTimeCutStartTime];
                        
                        NSLog(@"计算差值：endTimeCutStartTime:%d",endTimeCutStartTime);
                        
                    }
                }
                
                
            }else{
                [self removeTopProgressView]; //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
            }
            NSString * str = [NSString stringWithFormat:@"%@",self.video.playUrl];
        }else{
        }
    }
    else
    {
        NSLog(@"已经不是TV页面了");
        [self ifNotISTVView];
    }
}

#pragma mark - 获取录制信息，播放录制内容
- (void)getRECDataService:(NSNotification *)text{
    
    if (self.showTVView == YES) {
        NSLog(@"%@",text.userInfo[@"playdata"]);
        NSLog(@"－－－－－接收到通知------");
        _byteDatas = [[NSMutableData alloc]init];
        
        //此处加入判断语句，判断返回的结果RET是否满足几个报错信息
        NSData * retData = [[NSData alloc]init];
        //获得数据区的长度
        if ([[USER_DEFAULT objectForKey:@"data_service11REC"] length] >=  16) {
            
            retData = [[USER_DEFAULT objectForKey:@"data_service11REC"] subdataWithRange:NSMakeRange(12, 4)];
        }else
        {
            return;
        }
        
        
        NSLog(@"retData : %@",retData);
        
        int value = CFSwapInt32BigToHost(*(int*)([retData bytes]));
        NSLog(@"value : %d",value);
        //通过获得data数据减去发送的data数据得到播放连接，一下是返回数据的ret，如果ret不等于0则报错
        BOOL getLinkDataBool = [self  getLinkData :value tempDataA:[USER_DEFAULT objectForKey:@"data_serviceREC"] tempDataB:[USER_DEFAULT objectForKey:@"data_service11REC"] type:@"REC"];
        if (getLinkDataBool == YES) {
            
            self.video.playUrl = @"";
            self.video.playUrl = [[NSString alloc] initWithData:_byteDatas encoding:NSUTF8StringEncoding];
           
            self.video.startTime = self.event_startTime;
            self.video.endTime = self.event_endTime;
            NSLog(@"self.video.startTime %@",self.video.startTime);
            NSLog(@"self.video.endTime %@",self.video.endTime);
            
            [USER_DEFAULT setObject:self.video.startTime forKey:@"RECVideoStartTime"];
            [USER_DEFAULT setObject:self.video.endTime forKey:@"RECVideoEndTime"];
            
            int RECDurationTimeTemp = [self.video.endTime intValue] - [self.video.startTime intValue];
            NSString * RECDurationTimeTempStr = [NSString stringWithFormat:@"%d",RECDurationTimeTemp];
            [USER_DEFAULT setObject:RECDurationTimeTempStr forKey:@"RECVideoDurationTime"];
            [USER_DEFAULT setBool:YES forKey:@"IsfirstPlayRECVideo"];
            
            [self setStateNonatic];

            [USER_DEFAULT setObject:@"NO" forKey:@"isStartBeginPlay"]; //是否已经开始播放，如果已经开始播放，则停止掉中心点的旋转等待圆圈
            
            
            //==========正文
            double delayInSeconds = 0;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{

                [USER_DEFAULT setObject:@"YES" forKey:@"isStartBeginPlay"]; //是否已经开始播放，如果已经开始播放，则停止掉中心点的旋转等待圆圈
   
                [self playVideo];

            });
            
            
            
            
            playState = NO;
            
            if (self.showTVView == YES) {
                [self ifNeedPlayClick];
            }else
            {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
                NSLog(@"取消25秒的等待2");
            }
            
            [self removeTopProgressView];
            [self.timer invalidate];
            self.timer = nil;
            
            /**
             *新加的进度条
             */
            [USER_DEFAULT setObject:@"RECChannel" forKey:@"ChannelType"];
            //            [self.videoController startDurationTimer];
            [self removeTopProgressView]; //删除直播的进度条
 
        }else
        {
            
        }
      
    }
    else
    {
        NSLog(@"已经不是TV页面了");
        [self ifNotISTVView];
    }
}
 
-(void)getsubt
{
    /////****
    //此处循环给赋值
    
    self.video.dicSubAudio = self.TVSubAudioDic;
    
    if ([[USER_DEFAULT objectForKey:@"VideoTouchFromOtherView"] isEqualToString:@"YES"]) {
        [USER_DEFAULT setObject:self.video.dicSubAudio forKey:@"VideoTouchOtherViewdicSubAudio"];
    }
 
}
//row 代表是service的每个类别下的序列是几，dic代表每个类别下的service
-(void)touchSelectChannel :(NSInteger)row diction :(NSDictionary *)dic
{
    if (self.showTVView) {
        //=====则去掉不能播放的字样，加上加载环
        [self removeLabAndAddIndecatorView];
        
        [USER_DEFAULT setObject:@"no" forKey:@"alertViewHasPop"];
        tempBoolForServiceArr = YES;
        tempArrForServiceArr =  self.categoryModel.service_indexArr;
        tempDicForServiceArr = self.TVChannlDic;
        
        
        //先传输数据到socket，然后再播放视频
        //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",row]];
        NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
        
        NSLog(@"epgDicToSocket %@",epgDicToSocket);
        
        /*
         直播和录制的分水岭
         **/
        
        if (epgDicToSocket.count > 14) {  //录制
            NSLog(@"asbda;sbdasfsjbdajbd %@",[epgDicToSocket objectForKey:@"file_name"]);
            socketView.cs_serviceREC.file_name = [epgDicToSocket objectForKey:@"file_name"];
            
            socketView.cs_serviceREC.file_name_len = socketView.cs_serviceREC.file_name.length;
            
            //开始进行数据赋值
            NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
            
            //创建通知
            NSNotification *notification2 =[NSNotification notificationWithName:@"setChannelNameAndEventNameNotic" object:nil userInfo:nowPlayingDic];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification2];
            
            NSLog(@"row: %ld",(long)row);
            /*此处添加一个加入历史版本的函数*/
//            [self addHistory:row diction:dic];
            [USER_DEFAULT setObject:@"NO" forKey:@"audioOrSubtTouch"];
            [self.videoController setaudioOrSubtRowIsZero];
            
            isEventStartTimeBiger_NowTime = NO;
            
            //录制节目的时间
            self.event_startTime = [epgDicToSocket objectForKey:@"record_time"];
            NSString * RECStartTime = [epgDicToSocket objectForKey:@"record_time"];
            NSString * RECDurationTime = [epgDicToSocket objectForKey:@"duration"];
            self.event_endTime = [NSString stringWithFormat:@"%ld",[RECStartTime integerValue] + [RECDurationTime integerValue]]; 
            
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
            
            //*********
            
            [self getsubt];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noticeREC" object:nil];
            //注册通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRECDataService:) name:@"noticeREC" object:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.showTVView == YES) {
                    self.videoController.socketView1 = self.socketView;
                    [self.socketView  serviceRECTouch ];
                }else
                {
                    NSLog(@"已经不是TV页面了");
                    [self ifNotISTVView];
                }
                
            });
        }else //直播
        {
            NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
            
            //创建通知
            NSNotification *notification2 =[NSNotification notificationWithName:@"setChannelNameAndEventNameNotic" object:nil userInfo:nowPlayingDic];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification2];
            /*此处添加一个加入历史版本的函数*/
            [self addHistory:row diction:dic];
            [USER_DEFAULT setObject:@"NO" forKey:@"audioOrSubtTouch"];
            [self.videoController setaudioOrSubtRowIsZero];
            //__
            
            NSArray * audio_infoArr = [[NSArray alloc]init];
            NSArray * subt_infoArr = [[NSArray alloc]init];
            
            NSArray * epg_infoArr = [[NSArray alloc]init];
            //****
            
            
            socketView.socket_ServiceModel = [[ServiceModel alloc]init];
            audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
            subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
            if (audio_infoArr.count > 0 && subt_infoArr.count > 0) {
                
                
                socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
                socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
            }else
            {
                if (audio_infoArr.count > 0 ) {
                    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
                }else
                {
                    socketView.socket_ServiceModel.audio_pid = nil;
                }
                if (subt_infoArr.count > 0 ) {
                    socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
                }else
                {
                    socketView.socket_ServiceModel.subt_pid = nil;
                }
                
            }
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
            
            NSLog(@"self.service_videoname %@",self.service_videoname);
            
            epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
            if (epg_infoArr.count > 0) {
                self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
                self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
            }else
            {
                //            return;
            }
            
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
            
            
            [self getsubt];
            //此处销毁通知，防止一个通知被多次调用    // 1
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
            //注册通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
            
       
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.showTVView == YES) {
                    self.videoController.socketView1 = self.socketView;
                    [self.socketView  serviceTouch ];
                }else
                {
                    NSLog(@"已经不是TV页面了");
                    [self ifNotISTVView];
                }
                
            });
        }
        

    
    }else
    {
        NSLog(@"已经不是TV页面了");
        [self ifNotISTVView];
    }
    

}

#pragma  mark -视频分发返回来的RET区的结果
-(BOOL)getLinkData : (int )val tempDataA:(NSMutableData *)aData tempDataB:(NSMutableData *)bData type:(NSString *)typeTemp
{
    NSLog(@"val :%d",val);
    if (val == 0)  {
        //调用GGutil的方法
        NSLog(@"返回数据正常");
//        _byteDatas =  [GGUtil convertNSDataToByte:[USER_DEFAULT objectForKey:@"data_service"] bData:[USER_DEFAULT objectForKey:@"data_service11"]];
    _byteDatas =  [GGUtil convertNSDataToByte:aData bData:bData dataType:typeTemp];
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
        NSLog(@"访问资源冲突，需要显示No resources,this video can't play. Please check in Devices Management on StarTimes ONE");
        [USER_DEFAULT setObject:ResourcesFull forKey:@"playStateType"];
        [USER_DEFAULT setObject:@"Lab" forKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
        NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
        //        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
//            NSLog(@"取消25秒的等待7");
//            NSLog(@"取消播放第二次");
//            NSLog(@"取消播放第二次 %@",[NSThread currentThread]);
//            if (self.showTVView == YES) {
//                [self performSelector:@selector(playClick) withObject:nil afterDelay:25];
//                NSLog(@"开始25秒的等待");
//            }else
//            {
//
//                NSLog(@"进入了这个方法");
//            }
            
        });
        return NO;
    }
    else if(val == 4)
    {
        NSLog(@"播放错误"); //可能没插信号线
        
    }
    else if(val == 5)
    {
        NSLog(@"机顶盒加密或者CA密码正确");
    }
    else if(val == 6)
    {
        NSLog(@"机顶盒加密或者CA密码错误");
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
    
    return YES;
}

-(void)addHistory:(NSInteger)row diction :(NSDictionary *)dic
{
    NSLog(@"ajsbd;absd;asbdkasbd");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [USER_DEFAULT setObject:@"Lab" forKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
        
        [USER_DEFAULT setObject:[NSNumber numberWithInt:row] forKey: @"Touch_Channel_index"];
        NSLog(@"history线程%@",[NSThread currentThread]);
   
        //加载圈动画
        //创建通知  如果视频要播放呀，则去掉不能播放的字样
        NSNotification *notification1 =[NSNotification notificationWithName:@"noPlayShowShutNotic" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
        
        NSNotification *notification =[NSNotification notificationWithName:@"IndicatorViewShowNotic" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        //
        
        //    //如果视频25秒内不播放，则显示sorry的提示文字
        //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
        //    [self performSelector:@selector(playClick) withObject:nil afterDelay:25];
        if (self.showTVView == YES) {
            [self ifNeedPlayClick];
        }else
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
            NSLog(@"取消25秒的等待3");
        }
        
        NSLog(@"开始==计时===");
        
        // 1.获得点击的视频dictionary数据
        NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%d",row]];
        
        
        //epgDicToSocket是当前正在播放的节目信息，将他存储起来，用作切换eventName
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
        
        if (mutaArray == nil) {
            mutaArray = [[NSMutableArray alloc] init];
        }
        
        //4.将点击的数据加入可变数组
        //此处进行判断看新添加的节目是否曾经添加过
        BOOL addNewData = YES;
      
        NSMutableArray *duplicateArray = [mutaArray mutableCopy];
        
        if (epgDicToSocket.count > 14) { //节目是录制，按照录制来判断

            for (int i = 0; i <duplicateArray.count ; i++) {
                NSDictionary * dupDicTemp = duplicateArray[i][0];
                if (dupDicTemp.count > 14) { //录制
                    
                    //原始数据
                    NSString * tuner_mode1 =  [dupDicTemp objectForKey:@"tuner_mode"];
                    NSString * network_id1 =  [dupDicTemp objectForKey:@"network_id"];
                    NSString * ts_id1 =  [dupDicTemp objectForKey:@"ts_id"];
                    NSString * service_id1 =  [dupDicTemp objectForKey:@"service_id"];
                    NSString * record_time1 =  [dupDicTemp objectForKey:@"record_time"];
                    
                    //新添加的数据
                    NSString * tuner_mode2 =  [epgDicToSocket objectForKey:@"tuner_mode"];
                    NSString * network_id2 =  [epgDicToSocket objectForKey:@"network_id"];
                    NSString * ts_id2 =  [epgDicToSocket objectForKey:@"ts_id"];
                    NSString * service_id2 =  [epgDicToSocket objectForKey:@"service_id"];
                    NSString * record_time2 =  [epgDicToSocket objectForKey:@"record_time"];
                  

                
                    
                    if ([tuner_mode1 isEqualToString:tuner_mode2] && [network_id1 isEqualToString:network_id2] && [ts_id1 isEqualToString:ts_id2] && [service_id1 isEqualToString:service_id2] && [record_time1 isEqualToString:record_time2]) {
                        addNewData = NO;
                        
                        NSArray * equalArr = duplicateArray[i];
                        NSMutableArray * tempArr = [equalArr mutableCopy];
                        //            [tempArr[3] removeLastObject];
                        //            [tempArr[3] addObject:dic];
                        //            [tempArr insertObject:dic atIndex:3];
                        NSString * seedNowTime = [GGUtil GetNowTimeString];
                        NSNumber *aNumber = [NSNumber numberWithInteger:row];
                        [tempArr replaceObjectAtIndex:1 withObject:seedNowTime];
                        [tempArr replaceObjectAtIndex:2 withObject:aNumber];
                        [tempArr replaceObjectAtIndex:3 withObject:dic];
                        //                NSLog(@"tempArr :%@",tempArr);
                        //            equalArr = [tempArr copy];
                        
                        
                        
                        [mutaArray removeObjectAtIndex:i];
                        [mutaArray  addObject:[tempArr copy]];
                        
                        //                NSLog(@"mutaArray: %@",mutaArray);
                        //            [mutaArray replaceObjectAtIndex:i withObject:[tempArr copy]]
                        break;
                    }
                }
                else
                {

                }
 
                
            }
        }else //节目是直播，按照直播来判断
        {
            for (int i = 0; i <duplicateArray.count ; i++) {
                NSDictionary * dupDicTemp = duplicateArray[i][0];
                if (dupDicTemp.count > 14 ) { //录制
                    
                    
                }
                else
                {
                    //原始数据
                    NSString * service_network =  [duplicateArray[i][0] objectForKey:@"service_network_id"];
                    NSString * service_ts =  [duplicateArray[i][0] objectForKey:@"service_ts_id"];
                    NSString * service_service =  [duplicateArray[i][0] objectForKey:@"service_service_id"];
                    NSString * service_tuner =  [duplicateArray[i][0] objectForKey:@"service_tuner_mode"];
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
                        
                        NSArray * equalArr = duplicateArray[i];
                        NSMutableArray * tempArr = [equalArr mutableCopy];
                        //            [tempArr[3] removeLastObject];
                        //            [tempArr[3] addObject:dic];
                        //            [tempArr insertObject:dic atIndex:3];
                        NSString * seedNowTime = [GGUtil GetNowTimeString];
                        NSNumber *aNumber = [NSNumber numberWithInteger:row];
                        [tempArr replaceObjectAtIndex:1 withObject:seedNowTime];
                        [tempArr replaceObjectAtIndex:2 withObject:aNumber];
                        [tempArr replaceObjectAtIndex:3 withObject:dic];
                        //                NSLog(@"tempArr :%@",tempArr);
                        //            equalArr = [tempArr copy];
                        
                        
                        
                        [mutaArray removeObjectAtIndex:i];
                        [mutaArray  addObject:[tempArr copy]];
                        
                        //                NSLog(@"mutaArray: %@",mutaArray);
                        //            [mutaArray replaceObjectAtIndex:i withObject:[tempArr copy]]
                        break;
                    }
                }
                
                
                
                
                
            }
        }

        //    }
        if (addNewData == YES) {
            NSString * seedNowTime = [GGUtil GetNowTimeString];
            NSNumber *aNumber = [NSNumber numberWithInteger:row];
            NSArray * seedNowArr = [NSArray arrayWithObjects:epgDicToSocket,seedNowTime,aNumber,dic,nil];
//            NSLog(@"seedNowArr : %@",seedNowArr);
//            NSLog(@"dic : %@",dic);
            
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
//            NSLog(@"storeLastChannelArr %@",storeLastChannelArr);
        }
        
        NSLog(@"获取播放的第一个节目信息 成功");
        [USER_DEFAULT setObject:myArray forKey:@"historySeed"];
        
        
        //    NSLog(@"myarray:%@",myArray[3]);
        //    NSLog(@"myarray:%@",myArray[2]);
        //    NSLog(@"myarray:%@",myArray[2][0]);
        
        MEViewController * meview = [[MEViewController alloc]init];
        [meview viewDidAppear:YES];
        [meview viewDidLoad];
    });
    
    
}

-(void)judgeNowISRadio :(NSDictionary *)nowVideoDic  //判断当前播放时视频还是音频
{
    NSString * radioServiceType = [nowVideoDic objectForKey:@"service_type"];
    if ([radioServiceType isEqualToString:@"4"]) { //视频是1  音频是4
        NSLog(@"此时播放的是音频");
        //发送通知，显示音频图片
        //如果不能播放，则显示sorry , radio 不能播放
        
        
        [USER_DEFAULT setObject:@"radio" forKey:@"videoOrRadioPlay"];
        [USER_DEFAULT setObject:radioCantPlayTip forKey:@"videoOrRadioTip"];
        
    }else { //视频是1  音频是4
        NSLog(@"此时播放的是视频");
        //发送通知，取消掉视频通知
        
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"removeConfigRadioShowNotific" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [USER_DEFAULT setObject:@"video" forKey:@"videoOrRadioPlay"];
        [USER_DEFAULT setObject:videoCantPlayTip forKey:@"videoOrRadioTip"];
    }
}
//引导页
- (void)viewWillAppear:(BOOL)animated{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
        self.tabBarController.tabBar.hidden = YES;
        //        firstShow = NO;
        statusNum = 0;
        [self prefersStatusBarHidden];
        
        [self addGuideView]; //添加引导图
        [self performSelector:@selector(notHaveNetWork) withObject:nil afterDelay:60];
        
    }else{
        
        self.showTVView = YES;
        [USER_DEFAULT setObject:@"YES" forKey:@"showTVView"];
        //        NSString *  viewAppearRandomStr  = @"yes";  //这是一个局部变量，确保每次打开时值都不一样，然后通过这个值来判断是偶可以播放了
        [self preventTVViewOnceFullScreen]; //防止刚切换到主界面全屏
        [self performSelector:@selector(notHaveNetWork) withObject:nil afterDelay:10];
        TVViewTouchPlay = YES;
        [USER_DEFAULT setObject:@"YES" forKey:@"topProgressViewISNotExist"];
        
        tableviewinit  = tableviewinit +1;
        //    firstShow = YES;
        statusNum = 1;
        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
        [self prefersStatusBarHidden];
        
        self.tabBarController.tabBar.hidden = NO;
        [self loadNav];
        //        //防止用户快速切换，做延迟处理
        //        if (self.TVViewStopVideoPlayAndCancelDealyFunctionBlock) {
        //            self.TVViewStopVideoPlayAndCancelDealyFunctionBlock();
        //        }
        [USER_DEFAULT setObject:@"1" forKey:@"viewISTVView"];  //如果是TV页面，则再用户按home键后再次进入，需要重新播放
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(viewWillAppearDealyFunction) object:nil];
        [self performSelector:@selector(viewWillAppearDealyFunction) withObject:nil afterDelay:0.3];
        
    }
    
    
    
    
}
//0.3s 后执行
-(void)viewWillAppearDealyFunction
{
    [USER_DEFAULT setBool:YES forKey:@"isBarIsShowNow"]; //进度条在刚打开时是显示状态
    
    //        [USER_DEFAULT setObject:@"NO" forKey:@"modeifyTVViewRevolve"];
    NSLog(@"不是第一次启动");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        [USER_DEFAULT setBool:NO forKey:@"lockedFullScreen"];  //解开全屏页面的锁
        [USER_DEFAULT setBool:NO forKey:@"isFullScreenMode"];  //判断是不是全屏模式
        
        
    });
  
    [self lineView];  //一条0.5pt的线
    //    [self loadUI];              //加载table 和scroll
    //    [self getTopCategory];
    
    viewDidloadHasRunBool =  [[USER_DEFAULT objectForKey:@"viewDidloadHasRunBool"] intValue];
    if (viewDidloadHasRunBool == 0) {
        
        [self getServiceData];    //刚进入页面，重新搜索获取表数据
        progressEPGArrIndex = 0;
        int tempIndex =progressEPGArrIndex;
        NSString * tempIndexStr = [NSString stringWithFormat:@"%d",tempIndex];
        [USER_DEFAULT setObject:tempIndexStr  forKey:@"nowChannelEPGArrIndex"];
        
        viewDidloadHasRunBool = 1;
        [USER_DEFAULT setObject:[NSNumber numberWithInt:viewDidloadHasRunBool] forKey:@"viewDidloadHasRunBool"];
        
        
    }else{
        [self getServiceDataNotHaveSocket];    //获取表数据的不含有socket 的初始化方法
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //        [self initProgressLine];
        //        [self getSearchData];
        [self setIPNoific];
        [self setHMCChangeNoific];  //新加，建立新的通知，当HMC改变时发送通知
        [self setVideoTouchNoific];   //其他页面的点击播放视频的通知
        [self setVideoTouchNoificAudioSubt]; //全屏页面音轨字幕切换的通知
        [self newTunerNotific]; //新建一个tuner的通知
        [self socketGetIPAddressNotific]; //新建一个socket 获取IP地址的通知
        [self deleteTunerInfoNotific]; //新建一个删除tuner的通知
        [self allCategorysBtnNotific];
        [self removeLineProgressNotific]; //进度条停止的刷新通知
        [self restartLineProgressNotific]; //进度条重新开始的通知
        
        [self refreshTableFocus];  //刷新tableView焦点颜色的通知
        [self mediaDeliveryUpdateNotific];   //机顶盒数据刷新，收到通知，节目列表也刷新
        
        
        [self STBDencryptNotific];   //机顶盒加锁的通知
        [self STBDencryptFailedNotific];   //机顶盒加锁,但是未验证成功，重新弹窗的通知
        [self STBDencryptInputAgainNotific];   //机顶盒加锁,但是未验证成功，重新弹窗的通知
        [self STBDencryptVideoTouchNotific];   //机顶盒加锁后的播放通知
        [self ChangeSTBLockNotific];   //机顶盒加锁后的播放通知
        
        
        [self CADencryptNotific];   //CA加密的通知
        [self CADencryptFailedNotific];   //CA加密,但是未验证成功，重新弹窗的通知
        [self CADencryptInputAgainNotific];   //第一次没有输入 CA PIN，第二次点击CA PIN按钮重新打开窗口输入
        [self ChangeCALockNotific];   //CA加密弹窗中，取消了CA加密的播放通知
        [self NOCACardNotific];   //CA加密弹窗中，取消了CA加密的播放通知
        
        [self returnFromHomeToTVViewNotific];   //用户按home键回到主界面，再次返回时，如果是首页，则自动播放历史中的最后一个视频
        [self cantDeliveryNotific]; //停止分发的通知，这个时候显示停止分发的提示语
    });
    
    
    //        [self CADencryptVideoTouchNotific];   //CA加密后的播放通知
    
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
        NSLog(@"已经跳转到firstopen方法 从别的方法跳转过来");
        [self judgeJumpFromOtherView];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        [USER_DEFAULT setObject:@"Lab" forKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
        NSLog(@"目前是sliderview:%f",_slideView.frame.origin.y);
    });
}
#pragma mark -//如果是从其他的页面跳转过来的，则自动播放上一个视频（犹豫中特殊情况，视频断开后，此方法会无效。除非用户重新点击观看）
-(void)judgeJumpFromOtherView //如果是从其他的页面条转过来的，则自动播放上一个视频
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [self updateFullScreenDic];
    });
    if (self.showTVView == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"judgeJumpFromOtherViewjudgeJumpFromOtherView");
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
            NSLog(@"取消25秒的等待4");
        });
        NSString * deliveryPlayState =  [USER_DEFAULT objectForKey:@"deliveryPlayState"];
        
        if (isHasChannleDataList == NO) {
            
            NSLog(@"已经不是TV页面了");
            [self ifNotISTVView];
            
        }else
        {
            
            if ([deliveryPlayState isEqualToString:@"stopDelivery"]) {
                //①视频停止分发，断开了和盒子的连接，跳转界面不播放  ②禁止播放  ③取消掉加载环  ④ 显示不能播放的文字
                [self stopVideoPlay]; //停止视频播放
                
                [USER_DEFAULT setObject:deliveryStopTip forKey:@"playStateType"];
                //        NSDictionary *playStateTypeDic =[[NSDictionary alloc] initWithObjectsAndKeys:playStateType,@"playStateType",nil];
                NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
                //        //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                
                
                
            }else //视频没有停止分发，跳转界面可以播放
            {
                //=====则去掉不能播放的字样，加上加载环
                [self removeLabAndAddIndecatorView];
                
                NSString * jumpFormOtherView =  [USER_DEFAULT objectForKey:@"jumpFormOtherView"];
                if([jumpFormOtherView isEqualToString:@"YES"])
                {
                    NSMutableArray * historyArr  =  (NSMutableArray *) [USER_DEFAULT objectForKey:@"historySeed"];
                    NSLog(@"挖从奥到底dic come on");
                    if (historyArr == NULL || historyArr.count == 0 || historyArr == nil) {
                        
                        if (storeLastChannelArr.count >= 4) {
                            NSInteger row ;
                            NSDictionary * dic = [[NSDictionary alloc]init];
                            if (storeLastChannelArr.count >= 2) {
                             row = [storeLastChannelArr[2] integerValue];
                            }else
                            {
                                return;
                            }
                            if(storeLastChannelArr.count >= 3) {
                             dic = storeLastChannelArr [3];
                            }else
                            {
                                return;
                            }
 
                            //=======机顶盒加密
                            NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:row serviceListDic:dic];
                            if (characterStr != NULL && characterStr != nil) {
                                BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                                if (judgeIsSTBDecrypt == YES) {
                                    // 此处代表需要记性机顶盒加密验证
                                    NSNumber  *numIndex = [NSNumber numberWithInteger:row];
                                    NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"otherTouch",@"textThree",nil];
                                    //创建通知
                                    NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                                    //通过通知中心发送通知
                                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                                    
                                    firstOpenAPP = firstOpenAPP+1;
                                    
                                    firstfirst = NO;
                                }else //正常播放的步骤
                                {
                                    //======
                                    [self firstOpenAppAutoPlay:row diction:dic];
                                    firstOpenAPP = firstOpenAPP+1;
                                    
                                    firstfirst = NO;
                                }
                            }else //正常播放的步骤
                            {
                                //======机顶盒加密
                                [self firstOpenAppAutoPlay:row diction:dic];
                            }
                            
                            
                            
                            
                            [USER_DEFAULT setObject:@"NO" forKey:@"jumpFormOtherView"];//为TV页面存储方法
                        }else
                        {
                            return ;
                        }
                        
                    }else
                    {
                        if (historyArr.count > 0) {
                            NSArray * touchArr = historyArr[historyArr.count - 1];
                            
                            if (touchArr.count >= 4) {
                                NSInteger row = [touchArr[2] integerValue];
//                                NSDictionary * dic = touchArr [3];
                                 NSDictionary * dic = storeLastChannelArr [3];
                                NSLog(@"storeLastChannelArr %@",storeLastChannelArr);
                                NSLog(@"storeLastChannelArr[3] %@",storeLastChannelArr[3]);
                                NSLog(@"row %ld",(long)row);
//                                NSLog(@"dic %@",dic);
                                //在这里添加判断 机顶盒是否加密
                                //=======机顶盒加密
                                NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:row serviceListDic:dic];
                                if (characterStr != NULL && characterStr != nil) {
                                    BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                                    if (judgeIsSTBDecrypt == YES) {
                                        // 此处代表需要记性机顶盒加密验证
                                        NSNumber  *numIndex = [NSNumber numberWithInteger:row];
                                        NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"otherTouch",@"textThree",nil];
                                        //创建通知
                                        NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                                        //通过通知中心发送通知
                                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                                        
                                        firstOpenAPP = firstOpenAPP+1;
                                        
                                        firstfirst = NO;
                                    }else //正常播放的步骤
                                    {
                                        //======
                                        [self firstOpenAppAutoPlay:row diction:dic];
                                        firstOpenAPP = firstOpenAPP+1;
                                        NSLog(@"测试播放111111111111111");
                                        firstfirst = NO;
                                    }
                                }else //正常播放的步骤
                                {
                                    //======机顶盒加密
                                    [self firstOpenAppAutoPlay:row diction:dic];
                                }
                                
                                //////
                                //            NSLog(@"挖从奥到底dic 11 %@",dic);
                                //            NSNumber * numIndex = [NSNumber numberWithInt:row];
                                //
                                //            //添加 字典，将label的值通过key值设置传递
                                //            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
                                //            //创建通知
                                //            NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
                                //            //通过通知中心发送通知
                                //            [[NSNotificationCenter defaultCenter] postNotification:notification];
                                //            NSLog(@"目前是judgeJumpFromOtherView");
                                
                                //        [self.videoController play];
                                
                                [USER_DEFAULT setObject:@"NO" forKey:@"jumpFormOtherView"];//为TV页面存储方法
                            }else
                            {
                                return;
                            }
                            
                        }else
                        {
                            return;
                        }
                        
                    }
                    
                }
            }
            
        }
    }else
    {
        
        NSLog(@"已经不是TV页面了");
        [self ifNotISTVView];
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
        
        //        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //        //异步执行队列任务
        //        dispatch_async(globalQueue, ^{
        //            [self getStartTimeFromchannelListArr : data1]; //将获得data存到集合
        //        });
        
        
        
        
        if (!isValidArray(data1) || data1.count == 0){
            
            [self tableViewDataRefresh];
            return ;
        }
        self.serviceData = (NSMutableArray *)data1;
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        
        
        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
            
            [self tableViewDataRefresh];
        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        [self lineAndSearchBtnShow];
        
        
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
                
                
             
            }else
            {}
            
        }];
        
        [self.table reloadData];
        
        
    }];
}
-(void)mediaDeliveryUpdate
{
    NSLog(@"//此时应该列表刷新11");
    
    // ① 刷新  ②先判断有没有正在播放的节目了  ③如果有正在播放的节目，并且判断和正在播放的节目的dic信息是否相等，如果不相等则重新播放
    
    //** 用于第一时间刷新页面，从恢复出厂设置到有列表状态
    NSLog(@"mediaDeliveryUpdate mm %@",self.NoDataImageview );
    NSString * channelListIsHas = [USER_DEFAULT objectForKey:@"NOChannelDataDefault"];
    if ([channelListIsHas isEqualToString:@"YES"]) {

        //希望从路由器回复出厂后，刷新页面可以出发这个方法
        
        [USER_DEFAULT setObject:@"" forKey:@"playStateType"]; //设置为空，防止“delivery has  been....”产生
        
        
        NSLog(@"mediaDeliveryUpdate 方法中触发refresh方法");
        [self tableViewDataRefreshForMjRefresh_ONEMinute];
    }
    //**
    //①刷新
    [self tableViewDataRefreshForSDTMonitor];
    
    
    
}
#pragma mark - 机顶盒发送通知，需要刷新节目了   socket case = 0
-(void)tableViewDataRefreshForSDTMonitor
{
    NSLog(@" 机顶盒发送通知，需要刷新节目了 ==");
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
    
    
    [request startAsynchronous];   //异步
    
    WEAKGET
    [request setCompletionBlock:^{
        
        
        
        NSDictionary *response = httpRequest.responseString.JSONValue;
        
        //将数据本地化
        [USER_DEFAULT setObject:response forKey:@"TVHttpAllData"];
        
        //        NSLog(@"response = %@",response);
        NSArray *data1 = response[@"service"];
        
        
        
        
        
        if (!isValidArray(data1) || data1.count == 0){
            //            [self getServiceData];
            [self tableViewDataRefreshForMjRefresh_ONEMinute];
            return ;
        }
        self.serviceData = (NSMutableArray *)data1;
        
        NSLog(@"before self.categorys %@",self.categorys);
        self.categorys = (NSMutableArray *)response[@"category"];  //新加，防止崩溃的地方
        NSLog(@"last   self.categorys %@",self.categorys);
        
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        
        
        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
            //            [self getServiceData];
            NSLog(@"mediaDeliveryUpdate SDTSDT 方法中触发refresh方法");
            [self tableViewDataRefreshForMjRefresh_ONEMinute];
        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        [self lineAndSearchBtnShow];
        
        
        
        
        //        for (int i = 0; i<self.tableForDicIndexArr.count; i++) {
        
        NSString * YLSlideTitleViewButtonTagIndexStr = [USER_DEFAULT objectForKey:@"YLSlideTitleViewButtonTagIndexStr"];
        
        int YLSlideTitleViewButtonTagIndex = [YLSlideTitleViewButtonTagIndexStr  intValue];
        
        NSString *  indexforTableToNum = YLSlideTitleViewButtonTagIndexStr;
        //        [NSNumber numberWithInteger:YLSlideTitleViewButtonTagIndex];
        
        self.tableForSliderView = [self.tableForDicIndexDic objectForKey:indexforTableToNum][1];
        NSLog(@"此时self.tableForSliderView 2%@",self.tableForSliderView);
        NSLog(@"此时self.tableForSliderView 33332%@",self.tableForDicIndexDic);
        //        self.tableForSliderView = self.tableForDicIndexArr[YLSlideTitleViewButtonTagIndex][1];
        if (YLSlideTitleViewButtonTagIndex < self.tableForDicIndexDic.count) {
            
            //            }
            
            ////////==================
            
            //            id idTemp = self.tableForDicIndexArr[YLSlideTitleViewButtonTagIndex][1];
            
            id idTemp = [self.tableForDicIndexDic objectForKey:indexforTableToNum][1];
            //            NSNumber * numTemp = self.tableForDicIndexArr[YLSlideTitleViewButtonTagIndex][0];
            NSLog(@" == %@",self.tableForDicIndexDic);
            NSLog(@" == %@",[self.tableForDicIndexDic objectForKey:indexforTableToNum]);
            NSNumber * numTemp = [self.tableForDicIndexDic objectForKey:indexforTableToNum][0];
            
            NSInteger index = [numTemp integerValue];
            if (index >= self.categorys.count) {
                
            }
            NSDictionary *item ;
            if (self.categorys.count > index) {
                item = self.categorys[index];   //当前页面类别下的信息
            }else
            {
                return;
            }
            
            self.categoryModel = [[CategoryModel alloc]init];
            
            self.categoryModel.service_indexArr = item[@"service_index"];   //当前类别下包含的节目索引  0--9
            
            //获取EPG信息 展示
            //时间戳转换
            
            [self.dicTemp removeAllObjects];
            //获取不同类别下的节目，然后是节目下不同的cell值                10
            for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {
                
                int indexCat ;
                indexCat =[self.categoryModel.service_indexArr[i] intValue];
                //cell.tabledataDic = self.serviceData[indexCat -1];
                
                
                //此处判断是否为空，防止出错
                if ( ISNULL(self.serviceData)) {
                    
                }else{
                    
                    if (indexCat-1 > self.serviceData.count) {
                    }
                    
                    if (indexCat -1 < self.serviceData.count) {
                        
                        if (self.serviceData.count > indexCat - 1) {
                            [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];
                        }else
                        {
                            return;
                        }
                        
                        
                    }else
                    {
                        NSLog(@"不能再往里面添加了，再添加会报错");
                        return;
                    }
                    
                }
                
                
            }
            
            ////////==================
            
            
            //            }
        }
        
        
        [self.tableForSliderView reloadData];
        NSLog(@"此时self.tableForSliderView 2%@",self.tableForSliderView);
        //        [self refreshTableviewByEPGTime];
        // 模拟延迟2秒
        
        double delayInSeconds = 2;
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, mainQueue, ^{
            NSLog(@"延时执行的2秒");
            //        [self runThread1];
            NSLog(@"byteValue1 TVTVTVTVTVTV222");
            [self.tableForSliderView reloadData];
            

        });
        //        [NSThread sleepForTimeInterval:2];
        //    [self mediaDeliveryUpdate];
        //    [tableForSliderView reloadData];
        // 结束刷新
        
        //    NSLog(@"tableForSliderView22--:%@",self.tableForSliderView);
        //        [self.tableForSliderView.mj_header endRefreshing];
        
        
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
        
        
        
        [self.table reloadData];
        
        
        
        //②先判断有没有正在播放的节目了
        NSMutableArray *  historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];
        NSArray * touchArr ;
        if (historyArr.count >= 1) {
            touchArr = historyArr[historyArr.count - 1];
        }else
        {
            return;
        }
        
        NSInteger rowIndex;
        NSMutableDictionary * dic;
        if (touchArr.count >= 4) {
            rowIndex = [touchArr[2] intValue];
            dic = touchArr [3];
        }
        
        
        NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)rowIndex]]; //找到了正在播放的节目的信息
        
        NSLog(@"epgDicToSocket ==%@",epgDicToSocket);
        
        [self setSearchViewData ];
        
        BOOL isHavePlayingChannel = NO;
        
        for (int i = 0; i < self.serviceData.count; i++) {
            
            
            NSDictionary * serviceArrForJudge_dic = self.serviceData[i];
            
            BOOL isTwoDicEqual =  [GGUtil judgeTwoEpgDicIsEqual:epgDicToSocket TwoDic:serviceArrForJudge_dic];
            
            if (isTwoDicEqual == YES) {
                //找到了相匹配的节目，可以断定是正在播放的节目
                //看两个的信息是否完全相等，如果不相等，则替换dic
                
                isHavePlayingChannel = YES;
                
                NSLog(@" serviceArrForJudge_dic == %@",serviceArrForJudge_dic);
                NSLog(@" epgDicToSocket == %@",epgDicToSocket);
                if ([serviceArrForJudge_dic isEqual: epgDicToSocket] ) {
                    //如果完全相等，则不作处理
                }else
                {
                    //需要重新播放当前的节目
                    //先替换掉原先dic的信息
                    //                [dic setObject:serviceArrForJudge_dic forKey:[NSString stringWithFormat:@"%ld",(long)rowIndex]];
                    
                    //关闭当前正在播放的节目
                    [self.videoController.player stop];
                    [self.videoController.player shutdown];
                    [self.videoController.player.view removeFromSuperview];
                    
                    //修改字典信息
                    //历史记录信息和全部的信息
                    
                    //                NSLog(@"asfjalsbfabfba 1 %@",[dic objectForKey:[NSString stringWithFormat:@"%d",row]]);
                    
                    //                //赋予新值
                    //                NSMutableDictionary * tempDic_updateCharacter =[[dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]] mutableCopy];
                    //                NSString * newService_character =  [NSString stringWithFormat:@"%ld",(long)program_character_int];
                    //
                    //
                    //                [tempDic_updateCharacter setObject:newService_character forKey:@"service_character"];
                    //
                    //                NSLog(@"asfjalsbfabfba 4 %@",tempDic_updateCharacter);
                    NSMutableDictionary * mutableDicTemp = [dic mutableCopy];
                    [mutableDicTemp setObject:[serviceArrForJudge_dic copy] forKey:[NSString stringWithFormat:@"%ld",(long)rowIndex]];
                    dic = [mutableDicTemp mutableCopy];
                    
                    NSDictionary * aaa = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)rowIndex]];
                    
                    //修改 @"TVHttpAllData"   search界面的 self.response
                    NSMutableArray * serviceData_DefaultTemp = [[USER_DEFAULT objectForKey:@"serviceData_Default"] mutableCopy];
                    
                    
                    
                    //重新执行播放,并且要注意判断是不是加锁类型
                    
                    NSString * characterStr = [serviceArrForJudge_dic  objectForKey:@"service_character"];
                    
                    int program_character_int = [characterStr intValue];
                    
                    uint32_t character_And =  program_character_int &  0x02;
                    NSLog(@"ahsdahsfafvjahsvfjasvfa 1");
                    if (character_And > 0) {
                        NSLog(@"ahsdahsfafvjahsvfjasvfa 2");
                        // 此处代表需要记性机顶盒加密验证
                        NSNumber  *numIndex = [NSNumber numberWithInteger:rowIndex];
                        NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"LiveTouch",@"textThree",nil];
                        //创建通知
                        NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                        
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                        
                    }else //从加锁到不加锁正常播放的步骤，但是要注意得如果用户此时还处于弹窗或者未输入密码界面，得去掉弹窗和输入密码
                    {
                        NSLog(@"ahsdahsfafvjahsvfjasvfa 3");
                        NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigDecoderPINShowNotific" object:nil userInfo:nil];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                        
                        NSLog(@"不一致，不弹窗。===或者将窗口取消掉33");
                        [STBAlert dismissWithClickedButtonIndex:1 animated:YES];
                        //======
                        [self firstOpenAppAutoPlay:rowIndex diction:dic];
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                        
                        NSLog(@"self.video.dicChannl2 %@",self.video.dicChannl);
                        NSLog(@"self.video.channelCount2 %d",self.video.channelCount);
                        NSLog(@"self.video.dicChannl2222 %@",self.dicTemp);
                        NSLog(@"self.video.dicChannl2222222 %@",dic);
                        
                        
                        
                    }
                    
                    return ;
                }
                
                
            }
            
            
            
        }
        
        
        //③如果有正在播放的节目，并且判断和正在播放的节目的dic信息是否相等，如果不相等则重新播放
        if (isHavePlayingChannel == NO) {
            //没有找到这个节目，则播放第一个视频
            
            //=======机顶盒加密
            NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:rowIndex serviceListDic:self.dicTemp];
            if (characterStr != NULL && characterStr != nil) {
                BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                if (judgeIsSTBDecrypt == YES) {
                    // 此处代表需要记性机顶盒加密验证
                    NSNumber  *numIndex = [NSNumber numberWithInteger:rowIndex];
                    NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"firstOpenTouch",@"textThree",nil];
                    //创建通知
                    NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                    
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }else //正常播放的步骤
                {
                    //======
                    [self firstOpenAppAutoPlay:rowIndex diction:self.dicTemp];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }
            }else //正常播放的步骤
            {
                //======机顶盒加密
                [self firstOpenAppAutoPlay:rowIndex diction:self.dicTemp];
            }
            
            
        }
        
        
        
    }];
}
//判断列表变化后，是否把正在播放的那个节目给删除了，如果是的，则刷新列表，并且重新播放第一个视频
-(void)judgeVideoByDelete
{
    
    NSArray * arrHistoryNow = [USER_DEFAULT objectForKey:@"historySeed"];   //播放的历史老师
    
    //    NSLog(@"history Arr6: %@",arrHistoryNow[arrHistoryNow.count -1][0]);  //历史中正在播放的第一个节目
    //    NSLog(@"history Arr22: %@",[self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",0]]);  //wor
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
    //    [self.navigationController pushViewController:categoryView animated:YES];
    if(![self.navigationController.topViewController isKindOfClass:[categoryView class]]) {
        [self.navigationController pushViewController:categoryView animated:YES];
    }else
    {
        NSLog(@"此处可能会由于页面跳转过快报错");
    }
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoTouchNoificClick:) name:@"VideoTouchNoific" object:nil];
    
}
//全屏页面的音轨字幕的切换
-(void)setVideoTouchNoificAudioSubt
{
    
    //新建一个发送IP 改变的消息的通知   //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VideoTouchNoificAudioSubt" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoTouchNoificAudioSubtClick:) name:@"VideoTouchNoificAudioSubt" object:nil];
    
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
    [self getServiceDataForIPChange];
    
}
-(void)IPHasChanged
{
    
    
    NSLog(@"执行方法  IP地址改变了");
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willplay) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:nil];
    
    // 播放状态改变，可配合playbakcState属性获取具体状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willplay) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    
    // 媒体网络加载状态改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
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
//    playNumCount = 0;
//    NSLog(@"右侧列表asdboasbdiasbidbasidbiasbdiasbdiasbdiuas");
//}
#pragma mark - 如果视频20秒内不播放，则显示这个文字提示
//如果视频20秒内不播放，则显示这个文字提示
-(void)playClick  //:(NSTimer *)timer
{
    NSLog(@"结束==计时===不能播放");
    //①取消掉加载环  ②显示不能播放的文字
    //    NSNotification *notification1 =[NSNotification notificationWithName:@"IndicatorViewHiddenNotic" object:nil userInfo:nil];
    //    //        //通过通知中心发送通知
    //    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    
    
    [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
    //    NSDictionary *playStateTypeDic =[[NSDictionary alloc] initWithObjectsAndKeys:playStateType,@"playStateType",nil];
    NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
    //        //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    
}
#pragma mark - 将要播放的通知
-(void)willplay
{
    NSLog(@"结束==计时===已经播放");
    //取消掉20秒后显示提示文字的方法，如果视频要播放呀，则去掉不能播放的字样
    [self removeTipLabAndPerformSelector];
    NSLog(@"从willplay跳转过去 取消25秒的等待6");
    playState = YES;
    //    [timerState invalidate];
    //    timerState = nil;
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
    //做判断，如果3秒内不能播，则停止
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runThread1) object:nil];
    
    
    //    NSLog(@"xxxxxx MPMoviePlayer  LoadStateDidChange  Notification 媒体网络加载状态改变");
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
        
   
        
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(judegeIsPlaying) object:nil];
    }
}

/////////////其他页面的播放通知事件
//row 代表是service的每个类别下的序列是几，dic代表每个类别下的service
-(void)VideoTouchNoificClick : (NSNotification *)text//(NSInteger)row diction :(NSDictionary *)dic  //:(NSNotification *)text{
{
    [USER_DEFAULT setObject:@"YES" forKey:@"VideoTouchFromOtherView"]; //记录其他界面的点击播放时间，因为其他界面跳转过来的播放，可能会导致self.Video重新复制，导致EPG数据无法接受
    
    TVViewTouchPlay = NO;
    //=====则去掉不能播放的字样，加上加载环
    [self removeLabAndAddIndecatorView];
    
    [USER_DEFAULT setObject:@"no" forKey:@"alertViewHasPop"];
    
    NSInteger row = [text.userInfo[@"textOne"]integerValue];
    NSDictionary * dic = [[NSDictionary alloc]init];
    dic = text.userInfo[@"textTwo"];
    
   
    //先传输数据到socket，然后再播放视频
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    
    
    int indexOfCategory = [self judgeCategoryType:epgDicToSocket]; //从别的页面跳转过来，要先判断节目的类别，然后让底部的category转到相应的类别下
   
    
//    NSDictionary *item;
//    if (indexOfCategory <= self.categorys.count -1) {
//        item = self.categorys[indexOfCategory];   //当前页面类别下的信息
//    }
    [self setCategoryItem:indexOfCategory];
    

    //===
    
    
    epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    
    if (epgDicToSocket.count > 14) { //录制
 
 
         socketView.cs_serviceREC.file_name = [epgDicToSocket objectForKey:@"file_name"];
        socketView.cs_serviceREC.file_name_len = socketView.cs_serviceREC.file_name.length;
       
        
        
        //开始进行数据赋值
        NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
        
        //创建通知
        NSNotification *notification2 =[NSNotification notificationWithName:@"setChannelNameAndEventNameNotic" object:nil userInfo:nowPlayingDic];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification2];
        
        NSLog(@"row: %ld",(long)row);
        /*此处添加一个加入历史版本的函数*/
        [self addHistory:row diction:dic];
        [USER_DEFAULT setObject:@"NO" forKey:@"audioOrSubtTouch"];
        [self.videoController setaudioOrSubtRowIsZero];
        
        isEventStartTimeBiger_NowTime = NO;
        
        //录制节目的时间
        self.event_startTime = [epgDicToSocket objectForKey:@"record_time"];
        NSString * RECStartTime = [epgDicToSocket objectForKey:@"record_time"];
        NSString * RECDurationTime = [epgDicToSocket objectForKey:@"duration"];
        self.event_endTime = [NSString stringWithFormat:@"%ld",[RECStartTime integerValue] + [RECDurationTime integerValue]];
        
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
        
        //*********
        
        [self getsubt];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noticeREC" object:nil];
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRECDataService:) name:@"noticeREC" object:nil];
 
        
       
        self.TVSubAudioDic = epgDicToSocket;
        
        self.TVChannlDic = self.dicTemp;
        
        tempBoolForServiceArr = YES;
        tempArrForServiceArr =  self.categoryModel.service_indexArr;
        tempDicForServiceArr = self.TVChannlDic;
        
        self.video.dicChannl = [tempDicForServiceArr mutableCopy];
        self.video.channelCount = tempArrForServiceArr.count;
        //*********
       
        self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
        self.service_videoindex= @"";
        self.event_videoname = [epgDicToSocket objectForKey:@"event_name"];
        
        NSLog(@"LLL------%@",socketView.socket_ServiceModel);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.showTVView == YES) {
                self.videoController.socketView1 = self.socketView;
                [self.socketView  serviceRECTouch ];
            }else
            {
                NSLog(@"已经不是TV页面了");
                [self ifNotISTVView];
            }
            
        });
        
       
        
    }else//直播
    {
        //快速切换频道名称和节目名称
        NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
        
        //创建通知
        NSNotification *notification2 =[NSNotification notificationWithName:@"setChannelNameAndEventNameNotic" object:nil userInfo:nowPlayingDic];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification2];
        
        
        NSLog(@"dic: %@",dic);
        NSLog(@"self.dicTemp: %@",self.dicTemp);
        NSLog(@"epgDicToSocket: %@",epgDicToSocket);
        NSLog(@"row: %ld",(long)row);
        /*此处添加一个加入历史版本的函数*/
        [self addHistory:row diction:self.dicTemp];
        [USER_DEFAULT setObject:@"NO" forKey:@"audioOrSubtTouch"];
        [self.videoController setaudioOrSubtRowIsZero];
        //__
        
        NSArray * audio_infoArr = [[NSArray alloc]init];
        NSArray * subt_infoArr = [[NSArray alloc]init];
        
        NSArray * epg_infoArr = [[NSArray alloc]init];
        //****
        
        
        socketView.socket_ServiceModel = [[ServiceModel alloc]init];
        audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
        subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
        if (audio_infoArr.count > 0 && subt_infoArr.count > 0) {
            socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
            socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
            
        }else
        {
            if (audio_infoArr.count > 0 ) {
                socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
            }else
            {
                socketView.socket_ServiceModel.audio_pid = nil;
            }
            if (subt_infoArr.count > 0 ) {
                socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
            }else
            {
                socketView.socket_ServiceModel.subt_pid = nil;
            }
        }
        
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
        if (epg_infoArr.count == 0 || epg_infoArr == nil) {
            //        return;
        }else
        {
#pragma mark - 需要注意名称变化
            self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
            self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
            self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
        }
        
        isEventStartTimeBiger_NowTime = NO;
        BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
        if (isEventStartTimeBigNowTime == YES) {
            self.event_videoname = @"";
            self.event_startTime = @"";
            self.event_endTime = @"";
        }
        
        self.TVSubAudioDic = epgDicToSocket;
        
        self.TVChannlDic = self.dicTemp;
        NSLog(@"self.TVChannlDic.count2 :%d",self.TVChannlDic.count);
        
        tempBoolForServiceArr = YES;
        tempArrForServiceArr =  self.categoryModel.service_indexArr;
        tempDicForServiceArr = self.TVChannlDic;
        
        self.video.dicChannl = [tempDicForServiceArr mutableCopy];
        self.video.channelCount = tempArrForServiceArr.count;
        NSLog(@"channelCount==--==--22222= %d ",self.video.channelCount);
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
        
        NSLog(@"LLL------11%@",socketView.socket_ServiceModel);
        
        
        [self getsubt];
        //此处销毁通知，防止一个通知被多次调用    // 1   有可能不用，可以删除
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.showTVView == YES) {
                self.videoController.socketView1 = self.socketView;
                [self.socketView  serviceTouch ];
                
            }else
            {
                NSLog(@"已经不是TV页面了");
                [self ifNotISTVView];
            }
            
        });
        
    }
   
   
    
 
    NSNumber * currentIndexForCategory = [NSNumber numberWithInt:indexOfCategory];
    NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndexForCategory,@"currentIndex", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.tableForSliderView reloadData];
    [self.table reloadData];
   
    NSArray * serviceArrForJudge =  self.serviceData;
       //这里获得当前焦点
    NSArray * arrForServiceByCategory = [self.categorys[indexOfCategory] objectForKey:@"service_index"];
    
    for (int i = 0; i< arrForServiceByCategory.count; i++) {
        NSDictionary * serviceForJudgeDic = serviceArrForJudge[[arrForServiceByCategory[i] intValue]-1];
        
        //此处需要验证epg节目中的三个值是否相等 ，这里第一个参数代表最新数据
        BOOL isEqualForTwoDic = [GGUtil judgeTwoEpgDicIsEqual: serviceForJudgeDic TwoDic:epgDicToSocket];
        
        if (isEqualForTwoDic) {
            
            int indexForJudgeService = i;
            indexOfServiceToRefreshTable =indexForJudgeService;
          
            //选中数据变蓝
            [self tableViewCellToBlue:indexOfCategory indexhah:indexForJudgeService AllNumberOfService:arrForServiceByCategory.count];
            
        }
    }
    
    
    [tableForSliderView reloadData];

    tempBoolForServiceArr = YES;
    tempArrForServiceArr =  self.categoryModel.service_indexArr;
    tempDicForServiceArr = self.TVChannlDic;
    
    self.video.dicChannl = [tempDicForServiceArr mutableCopy];
    self.video.channelCount = tempArrForServiceArr.count;
    
    [USER_DEFAULT setObject:self.video.dicChannl forKey:@"VideoTouchOtherViewdicChannl"];
    NSNumber * channelCountNum = [NSNumber numberWithInt:self.video.channelCount];
    [USER_DEFAULT setObject:channelCountNum forKey:@"VideoTouchOtherViewchannelCount"];
  
    [self updateFullScreenDic];
    
}
-(int)judgeCategoryType:(NSDictionary *)NowServiceDic
{
    //获取全部的channel数据，判断当前点击的channel是哪一个dic
    NSArray * serviceArrForJudge =  [USER_DEFAULT objectForKey:@"serviceData_Default"];
    NSDictionary * serviceArrForJudge_dic ;
    //1.判断是不是存在录制  2。如果有录制，优先判断是不是录制类型  3.如果没有录制，则判断是不是有其他类型
    
    NSArray * RECArrForJudgeCategory = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
    
    if (RECArrForJudgeCategory.count > 0 && RECArrForJudgeCategory != nil) {
            for (int i = 0; i<RECArrForJudgeCategory.count; i++) {
                serviceArrForJudge_dic = RECArrForJudgeCategory[i];
                if ([GGUtil judgeTwoEpgDicIsEqual:serviceArrForJudge_dic TwoDic:NowServiceDic]) {
                    return 1;
                }
            }
    }
    
    for (int i = 0; i<serviceArrForJudge.count; i++) {
        serviceArrForJudge_dic = serviceArrForJudge[i];
        if ([GGUtil judgeTwoEpgDicIsEqual:serviceArrForJudge_dic TwoDic:NowServiceDic]) {
            //此时的service就是真正的service
            //进行后续操作
            int nowServiceIndex = i+1;
            NSString * service_indexForJudgeType = [NSString  stringWithFormat:@"%d",nowServiceIndex];   //返回当前的i,作为节目的service_index值
            NSArray  * categoryArrForJudgeType = [USER_DEFAULT objectForKey:@"categorysToCategoryView"] [0];
            for (int i = 0; i < categoryArrForJudgeType.count; i++) {
                NSDictionary * categoryIndexDic = categoryArrForJudgeType[i];
                NSArray * categoryServiceIndexArr = [categoryIndexDic objectForKey:@"service_index"];
//                NSArray * categoryServiceIndexArr = categoryIndexDic ;
                for (int y = 0; y < categoryServiceIndexArr.count; y++) {
                    NSString * serviceIndexForJundgeStr = categoryServiceIndexArr[y];
                    
                    if ([serviceIndexForJundgeStr isEqualToString:service_indexForJudgeType]) {
                        
                        if (i == 0) {
                            return i;
                        }else
                        {
                            if (RECArrForJudgeCategory.count > 0 && RECArrForJudgeCategory != nil) {
                                return i+1;
                            }else
                            {
                                return i;
                            }
                        }
//                        return i;
                    }
                    
                }
                
            }
        }
    }
   
    //否则什么都不是
    return 0;
    
}
/////////////全屏状态切换音轨字幕通知
//row 代表是service的每个类别下的序列是几，dic代表每个类别下的service
-(void)VideoTouchNoificAudioSubtClick : (NSNotification *)text//(NSInteger)row diction :(NSDictionary *)dic  //:(NSNotification *)text{
{
    TVViewTouchPlay = NO;
    //=====则去掉不能播放的字样，加上加载环
    [self removeLabAndAddIndecatorView];
    
    [USER_DEFAULT setObject:@"no" forKey:@"alertViewHasPop"];
    
    NSInteger row = [text.userInfo[@"textOne"]integerValue];
    NSDictionary * dic = [[NSDictionary alloc]init];
    dic = text.userInfo[@"textTwo"];
    //--
    NSNumber * numAudio = text.userInfo[@"textThree"];
    NSNumber * numSubt = text.userInfo[@"textFour"];
    
    [USER_DEFAULT setObject:numAudio forKey: @"Touch_Audio_index"];
    [USER_DEFAULT setObject:numSubt  forKey:@"Touch_Subt_index"];
    [USER_DEFAULT setObject:@"YES" forKey:@"audioOrSubtTouch"];
    
    
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
    
    if (audio_infoArr.count > audioIndex && subt_infoArr.count > subtIndex ) {
        socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audioIndex] objectForKey:@"audio_pid"];
        NSLog(@"socketView.socket_ServiceModel.audio_pid :%@",socketView.socket_ServiceModel.audio_pid);
        socketView.socket_ServiceModel.subt_pid = [subt_infoArr[subtIndex] objectForKey:@"subt_pid"];
        NSLog(@"socketView.socket_ServiceModel.subt_pid :%@",socketView.socket_ServiceModel.subt_pid);
    }else
    {
        return;
    }
    
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
    
    self.TVSubAudioDic = epgDicToSocket;
    self.TVChannlDic = self.dicTemp;
   
    
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
  
    [self getsubt];
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
 
    
    NSLog(@"self.socket:%@",self.socketView);
    
    if (self.showTVView == YES) {
        self.videoController.socketView1 = self.socketView;
        [self.socketView  serviceTouch ];
    }else
    {
        NSLog(@"已经不是TV页面了");
        [self ifNotISTVView];
    }
    
    
}
/////////////本页面的显示播放，打开APP的时候自动播放第一个视频
//row 代表是service的每个类别下的序列是几，dic代表每个类别下的service
-(void)firstOpenAppAutoPlay : (NSInteger)row diction :(NSDictionary *)dic  //:(NSNotification *)text{
{
    NSLog(@"执行执行执行执行8888");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self updateFullScreenDic];
    });
    if (self.showTVView == YES) {
        NSLog(@"已经跳转到firstopen方法");
        //=====则去掉不能播放的字样，加上加载环
        [self removeLabAndAddIndecatorView];
        
        [USER_DEFAULT setObject:@"no" forKey:@"alertViewHasPop"];
        
        NSMutableDictionary * epgDicToSocket = [[dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]] mutableCopy];
        
        //快速切换频道名称和节目名称
        NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
        
        //创建通知
        NSNotification *notification2 =[NSNotification notificationWithName:@"setChannelNameAndEventNameNotic" object:nil userInfo:nowPlayingDic];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification2];
        
        NSLog(@"dic: %@",dic);
        
        NSLog(@"row: %ld",(long)row);
        /*此处添加一个加入历史版本的函数*/
        [self addHistory:row diction:dic];
        [USER_DEFAULT setObject:@"NO" forKey:@"audioOrSubtTouch"];
        [self.videoController setaudioOrSubtRowIsZero];
        //    [self getsubt];
        //__
        
        NSArray * audio_infoArr = [[NSArray alloc]init];
        NSArray * subt_infoArr = [[NSArray alloc]init];
        
        NSArray * epg_infoArr = [[NSArray alloc]init];
        //****
        
        
        socketView.socket_ServiceModel = [[ServiceModel alloc]init];
        audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
        subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
 
        if (audio_infoArr.count > 0 && subt_infoArr.count > 0) {
    
            socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
            socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
        }else
        {
            if (audio_infoArr.count > 0 ) {
                socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
            }else
            {
                socketView.socket_ServiceModel.audio_pid = nil;
            }
            if (subt_infoArr.count > 0 ) {
                socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
            }else
            {
                socketView.socket_ServiceModel.subt_pid = nil;
            }
            
        }
        
        
        ////////
//        socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
//        socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
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
        
        NSLog(@" self.service_videoname %@",self.service_videoname);
        
        epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
        
        if (epg_infoArr.count > 0) {
       
        self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
        NSLog(@"replaceEventNameNotific firstOpen :%@",self.event_videoname);
        self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
        self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
        }else
        {
            
        }
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
        NSLog(@"self.TVChannlDic.count1 :%lu",(unsigned long)self.TVChannlDic.count);
        self.TVChannlDic = self.dicTemp;
        NSLog(@"self.TVChannlDic.count2 :%lu",(unsigned long)self.TVChannlDic.count);
        NSLog(@"eventname :%@",self.event_startTime);
        
        tempBoolForServiceArr = YES;
        tempArrForServiceArr =  self.categoryModel.service_indexArr;
        tempDicForServiceArr = self.TVChannlDic;
        NSLog(@"first tempDicForServiceArr %@",tempDicForServiceArr);
        [self getsubt];
        //*********
        
        //再单独开一个线程用于default操作
        dispatch_queue_t  queueA = dispatch_queue_create("firstOpen",DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queueA, ^{
            [USER_DEFAULT setObject:tempArrForServiceArr forKey:@"tempArrForServiceArr"];
            [USER_DEFAULT setObject:tempDicForServiceArr forKey:@"tempDicForServiceArr"];
        });
        
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
        NSLog(@"执行执行执行执行9999");
        if (self.showTVView == YES) {
            self.videoController.socketView1 = self.socketView;
            NSLog(@"playState---== 第一次打开发送数据111");
            [self.socketView  serviceTouch ];
            NSLog(@"执行执行执行执行101010");
            NSLog(@"playState---== 第一次打开发送数据222");
            NSLog(@"测试播放22222222222222");
        }else
        {
            NSLog(@"已经不是TV页面了");
            [self ifNotISTVView];
        }
//    }
//    else
//    {
//        NSLog(@"已经不是TV页面了");
//        [self ifNotISTVView];
//    }
    }
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
        
    } else if ([vc isKindOfClass:[XYZNavigationController class]]) {
        
        // Return top view
        XYZNavigationController* svc = (XYZNavigationController*) vc;
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
#pragma mark - 获取表数据的不含有socket 的初始化方法
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
        
        //        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //        //异步执行队列任务
        //        dispatch_async(globalQueue, ^{
        //            [self getStartTimeFromchannelListArr : data1]; //将获得data存到集合
        //        });
        
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
        [self lineAndSearchBtnShow];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notHaveNetWork) object:nil];
        
        NSLog(@" playVideo getservicedataNotHaveSocket");
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
               
                
                [self playVideo];
                //判断是不是全屏
                BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
                if (isFullScreen == NO) {   //竖屏状态
                    
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.CategoryAndREC];
                    
                    isHasChannleDataList = YES;
                    [self.tableForDicIndexDic removeAllObjects]; //存储表和索引关系的数组
                    NSLog(@"removeAllObjects 第 4 次");
                }else //横屏状态，不刷新
                {
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.CategoryAndREC];
                    [self.tableForDicIndexDic removeAllObjects]; //存储表和索引关系的数组
                    NSLog(@"removeAllObjects 第 5 次");
                }
                
                
                
                NSArray *ArrayTocategory = [NSArray arrayWithArray:self.CategoryAndREC];
                [USER_DEFAULT setObject:ArrayTocategory forKey:@"categorysToCategoryView"];
                
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
//第一次验证失败后，重新弹窗的通知
-(void)STBDencryptFailedNotific
{
    //新建一个通知，用来监听机顶盒加密
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"STBDencryptFailedNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popSTBAlertViewFaild) name:@"STBDencryptFailedNotific" object:nil];
    
}

//CA加密第一次验证失败后，重新弹窗的通知
-(void)CADencryptFailedNotific
{
    //新建一个通知，用来监听机顶盒加密
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CADencryptFailedNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCAAlertViewFaild) name:@"CADencryptFailedNotific" object:nil];
    
}
#pragma mark - CA加密第一次验证失败后，重新弹窗
-(void)popCAAlertViewFaild //: (NSNotification *)text
{
    NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigCAPINShowNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    
    CAAlert.title = @"It's wrong,Once more";
    if (self.showTVView == YES) {
        [CAAlert show];
    }else
    {
        NSLog(@"已经不是TV页面了");
        [self ifNotISTVView];
    }
    CATextField_Encrypt.text = @"";
    CAAlert.dontDisppear = YES;
    
}
//第一次没有输入，点击decoder PIN 按钮后重新弹出输入框
-(void)STBDencryptInputAgainNotific
{
    //新建一个通知，用来监听机顶盒加密
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"STBDencryptInputAgainNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popSTBAlertViewInputAgain) name:@"STBDencryptInputAgainNotific" object:nil];
    
}
-(void)CADencryptInputAgainNotific
{
    //新建一个通知，用来监听从CA密码验证正确跳转来的播放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CADencryptInputAgainNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popCAAlertViewInputAgain) name:@"CADencryptInputAgainNotific" object:nil];
}

//-(void)CADencryptVideoTouchNotific
//{
//    //新建一个通知，用来监听从机顶盒密码验证正确跳转来的播放
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CADencryptVideoTouchNotific" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allVideoTouchFromCA) name:@"CADencryptVideoTouchNotific" object:nil];
//}

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
#pragma mark - 机顶盒加密第一次验证失败后，重新弹窗
-(void)popSTBAlertViewFaild //: (NSNotification *)text
{
    [self performSelector:@selector(delayPopSTBOrCAAlert) withObject:nil afterDelay:0.6];
 
}
-(void)delayPopSTBOrCAAlert
{
    [self stopVideoPlay];
    
    if(STBTouchType_Str == nil )
    {
        NSLog(@"不一致，不弹窗。===或者将窗口取消掉");
        NSLog(@"弹出CA窗口 ");
        [self popCAAlertViewFaild]; // STBTouchType_Str == nil  代表是CA验证  不是STB
    }else
    {
        NSLog(@"弹出 STB 窗口 ");
        STBAlert.title = @"It's wrong,Once more";
        if (self.showTVView == YES) {
            [STBAlert show];
            NSLog(@"asoabsfbasfbaofbasobfasbfjbasbdn c");
        }else
        {
            NSLog(@"已经不是TV页面了");
            [self ifNotISTVView];
        }
        STBTextField_Encrypt.text = @"";
        STBAlert.dontDisppear = YES;
        
        NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigDecoderPINShowNotific" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
    }
}
//第一次没有输入PIN，第二次点击decoder PIN按钮重新打开窗口输入
-(void)popSTBAlertViewInputAgain //: (NSNotification *)text
{
    [self stopVideoPlay];
    
    STBAlert.title = @"Please input your Decoder PIN";
    if (self.showTVView == YES) {
        [STBAlert show];
    }else
    {
        NSLog(@"已经不是TV页面了");
        [self ifNotISTVView];
    }
    STBTextField_Encrypt.text = @"";
    STBAlert.dontDisppear = YES;
    
    NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigDecoderPINShowNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
}
//第一次没有输入 CA PIN，第二次点击CA PIN按钮重新打开窗口输入
-(void)popCAAlertViewInputAgain //: (NSNotification *)text
{
    CAAlert.title = @"Please input your CA PIN";
    if (self.showTVView == YES) {
        [CAAlert show];
    }else
    {
        NSLog(@"已经不是TV页面了");
        [self ifNotISTVView];
    }
    CATextField_Encrypt.text = @"";
    CAAlert.dontDisppear = YES;
    
    NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigCAPINShowNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
}
#pragma mark - STB弹窗
-(void)popSTBAlertView: (NSNotification *)text
{
    NSLog(@"changeLockData changeLockData");
    [self stopVideoPlay];
    
    
    
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新，
        
        
        
        if (self.showTVView == YES) {
            /**
             1.弹窗
             1.show的方法覆写
             2.弹窗那一刻进行判断
             3.弹窗的字样和按钮判断
             4.弹窗确认按钮点击后进行一次判断，防止按钮点击后，切换页面
             2.播放
             1.播放器初始化时，进行判断
             2.点击后socket请求进行判断
             3.所有带有播放请求的页面都进行一次判断
             */
            
            [STBAlert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
            STBAlert.delegate =  self;
            STBAlert.title = @"Please input your Decoder PIN";
            if (self.showTVView == YES) {
                [STBAlert show];
                NSLog(@"asoabsfbasfbaofbasobfasbfjbasbdn222 c");
            }else
            {
                NSLog(@"已经不是TV页面了");
                [self ifNotISTVView];
            }
            STBTextField_Encrypt.text = @"";
            STBAlert.dontDisppear = YES;
            
            
            
            STBAlert.transform = CGAffineTransformRotate(STBAlert.transform, M_PI/2);
            
            
            STBTextField_Encrypt.delegate = self;
            STBTextField_Encrypt.autocorrectionType = UITextAutocorrectionTypeNo;
            STBTextField_Encrypt = [STBAlert textFieldAtIndex:0];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:STBTextField_Encrypt];
            //修改decoderPIN 和CA PIN 的 占位文字
            if (STBAlert.alertViewStyle == UIAlertViewStyleSecureTextInput) {
                STBTextField_Encrypt.placeholder = @"decoder PIN";
            }
            
            
            NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigDecoderPINShowNotific" object:nil userInfo:nil];
            //通过通知中心发送通知,将decoderPIN 的文字和按钮删除掉
            [[NSNotificationCenter defaultCenter] postNotification:notification1];
            
            [self serviceEPGSetData:STBTouch_Row diction:STBTouch_Dic];
            
            
        }else
        {
            
            NSLog(@"已经不是TV页面了");
            [self ifNotISTVView];
        }
        
        
        
        
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        //保存三个有用的信息
        STBTouch_Row = [text.userInfo[@"textOne"]integerValue];
        NSLog(@"STBTouch_Row== %d",STBTouch_Row);
        STBTouch_Dic = text.userInfo[@"textTwo"];
        STBTouchType_Str = text.userInfo[@"textThree"];
        NSDictionary * epgDicFromPopSTB = [STBTouch_Dic objectForKey:[NSString stringWithFormat:@"%d",STBTouch_Row]];
      
        [USER_DEFAULT setObject:@"yes" forKey:@"alertViewHasPop"];
    
        [USER_DEFAULT setObject:epgDicFromPopSTB forKey:@"NowChannelDic"];
        
        if (text.userInfo.count >3) {
            STBTouch_Audio = [text.userInfo[@"textFour"]integerValue];
            STBTouch_Subt = [text.userInfo[@"textFive"]integerValue];
            
            [USER_DEFAULT setObject:text.userInfo[@"textFour"] forKey: @"Touch_Audio_index"];
            [USER_DEFAULT setObject:text.userInfo[@"textFive"]  forKey:@"Touch_Subt_index"];
            [USER_DEFAULT setObject:@"YES" forKey:@"audioOrSubtTouch"];
            [USER_DEFAULT setObject:text.userInfo[@"textOne"] forKey: @"Touch_Channel_index"];
        }else
        {
            [USER_DEFAULT setObject:@"NO" forKey:@"audioOrSubtTouch"];
        }
        
        
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //取消掉提示文字和延迟方法
        [self removeTipLabAndPerformSelector];
        
        NSNotification *notification =[NSNotification notificationWithName:@"IndicatorViewShowNotic" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
    });
}
#pragma mark - CA弹窗
-(void)popCAAlertView: (NSNotification *)text
{
    STBTouchType_Str = nil; //用于判断是哪个类型，如果此类型有数据，则代表是STB，否则代表是CA
    
    [USER_DEFAULT setObject:@"yes" forKey:@"alertViewHasPop"];
    
    
    //取消掉提示文字和延迟方法
    [self removeTipLabAndPerformSelector];
    
    NSNotification *notification =[NSNotification notificationWithName:@"IndicatorViewShowNotic" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    //协议改版后，这里的CAThreeData其实应该修改为CAFourData
    NSData * CAThreeData = text.userInfo[@"CAThreedata"];
    
    NSData * CATuner_modeData = [[NSData alloc]init];
    //获得数据区的长度
    if ([CAThreeData length] >=  4) {
        
        CATuner_modeData = [CAThreeData subdataWithRange:NSMakeRange(0,4)];
    }else
    {
        return;
    }
    
    NSData * CANetwork_idData = [[NSData alloc]init];
    //获得数据区的长度
    if ([CAThreeData length] >=  6) {
        
        CANetwork_idData = [CAThreeData subdataWithRange:NSMakeRange(4,2)];
    }else
    {
        return;
    }
    
    NSData * CATs_idData = [[NSData alloc]init];
    if ([CAThreeData length] >=  8) {
        
        CATs_idData = [CAThreeData subdataWithRange:NSMakeRange(6,2)];
    }else
    {
        return;
    }
    
    NSData * CAService_idData = [[NSData alloc]init];
    if ([CAThreeData length] >=  10) {
        
        CAService_idData = [CAThreeData subdataWithRange:NSMakeRange(8,2)];
    }else
    {
        return;
    }
    
    uint32_t  CATuner_modeStr = [SocketUtils uint16FromBytes:CATuner_modeData]; //
    
    uint16_t  CANetwork_idStr = [SocketUtils uint16FromBytes:CANetwork_idData]; // [[NSString alloc] initWithData:CANetwork_idData  encoding:NSUTF8StringEncoding];
    uint16_t  CATs_idStr =  [SocketUtils uint16FromBytes:CATs_idData]; //[[NSString alloc] initWithData:CATs_idData  encoding:NSUTF8StringEncoding];
    uint16_t  CAService_idStr =  [SocketUtils uint16FromBytes:CAService_idData];//[[NSString alloc] initWithData:CAService_idData  encoding:NSUTF8StringEncoding];
    //判断当前节目是不是CA弹窗节目
    
    NSLog(@"socketView.socket_ServiceModel.service_ts_id :%@",socketView.socket_ServiceModel.service_tuner_mode) ;
    NSLog(@"socketView.socket_ServiceModel.service_ts_id :%@",socketView.socket_ServiceModel.service_ts_id) ;
    NSLog(@"socketView.socket_ServiceModel.service_net_id :%@",socketView.socket_ServiceModel.service_network_id) ;
    NSLog(@"socketView.socket_ServiceModel.service_service_id :%@",socketView.socket_ServiceModel.service_service_id) ;
    
    if (CATuner_modeStr  == [socketView.socket_ServiceModel.service_tuner_mode  intValue] &&CANetwork_idStr  == [socketView.socket_ServiceModel.service_network_id  intValue] && CATs_idStr == [socketView.socket_ServiceModel.service_ts_id intValue] && CAService_idStr == [socketView.socket_ServiceModel.service_service_id intValue]) {
        //证明一致，是这个CA节目
        
        [self stopVideoPlay];
        
        [CAAlert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
        CAAlert.delegate =  self;
        CAAlert.title = @"Please input your CA PIN";
        if (self.showTVView == YES) {
            [CAAlert show];
        }else
        {
            NSLog(@"已经不是TV页面了");
            [self ifNotISTVView];
        }
        CATextField_Encrypt.text = @"";
        CAAlert.dontDisppear = YES;
        
        
        CATextField_Encrypt.delegate = self;
        CATextField_Encrypt.autocorrectionType = UITextAutocorrectionTypeNo;
        CATextField_Encrypt = [CAAlert textFieldAtIndex:0];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:CATextField_Encrypt];
        
        //修改decoderPIN 和CA PIN 的 占位文字
        if (CAAlert.alertViewStyle == UIAlertViewStyleSecureTextInput) {
            CATextField_Encrypt.placeholder = @"CA PIN";
        }
        
    }else
    {
        //不一致，不弹窗。===或者将窗口取消掉
        
        NSLog(@"不一致，不弹窗。===或者将窗口取消掉11");
        if(CAAlert){
            [CAAlert dismissWithClickedButtonIndex:1 animated:YES];
        }
    }
    
    
    
    //    CAAlert = [[UIAlertView alloc] initWithTitle:@"请输入CA密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    
    NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigCAPINShowNotific" object:nil userInfo:nil];
    //通过通知中心发送通知,将decoderPIN 的文字和按钮删除掉
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
}
#pragma mark - 弹窗点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    textField_Encrypt.delegate = self;
    //    textField_Encrypt.autocorrectionType = UITextAutocorrectionTypeNo;
    //    textField_Encrypt = [alertView textFieldAtIndex:0];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
    //                                                name:@"UITextFieldTextDidChangeNotification"
    //                                              object:textField_Encrypt];
    
    
    
    if ([alertView  isEqual: STBAlert]) {
        
        if(buttonIndex == 1)
        {
            NSLog(@"charact  STB  验证");
            NSLog(@"没有进行STB密码验证，所以不能播放");
            //取消了
            //1.先取消进度圈  2.弹出页面   3.将decoder PIN 的文字改成@"Please input your Decoder PIN";
            
            NSNotification *notification =[NSNotification notificationWithName:@"configDecoderPINShowNotific" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self performSelector:@selector(changeSTBAlertTitle) withObject:nil afterDelay:0.3];//将decoder PIN 的文字改成@"Please input your Decoder PIN"
            
        }else{
            NSLog(@"charact  STB  验证");
            NSLog(@"character2txt  字符 ：%@",STBTextField_Encrypt.text);
            if (STBTextField_Encrypt.text.length < 1) {
                STBAlert.dontDisppear = YES;
                
            }else
            {
                if (STBTextField_Encrypt.text.length <6) {
                    
                    [self performSelector:@selector(popSTBAlertViewFaild) withObject:nil afterDelay:0.8];
                    //                [self popSTBAlertViewAgain];
                }else
                {
                    [self.socketView passwordCheck:STBTextField_Encrypt.text passwordType:1];  //密码六位
                }
                
            }
            
            
            
            
        }
    }
    else if([alertView  isEqual: CAAlert])
    {
        if(buttonIndex == 1)
        {
            //            //取消了
            //            NSLog(@"charact  CA 验证");
            //            NSLog(@"没有进行CA密码验证，所以不能播放");
            NSLog(@"charact  CA 验证");
            NSLog(@"没有进行CA密码验证，所以不能播放");
            //取消了
            //1.先取消进度圈  2.弹出页面   3.将decoder PIN 的文字改成@"Please input your Decoder PIN";
            
            NSNotification *notification =[NSNotification notificationWithName:@"configCAPINShowNotific" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self performSelector:@selector(changeCAAlertTitle) withObject:nil afterDelay:0.3];//将CA PIN 的文字改成@"Please input your CA PIN"
            
        }else{
            
            
            NSLog(@"charact  CA 验证");
            NSLog(@"character2txt  字符 ：%@",CATextField_Encrypt.text);
            if (CATextField_Encrypt.text.length <1) {
                CAAlert.dontDisppear = YES;
            }else
            {
                
                if (CATextField_Encrypt.text.length <4) {
                    
                    [self performSelector:@selector(popCAAlertViewFaild) withObject:nil afterDelay:0.8];
                    //                [self popSTBAlertViewAgain];
                }else
                {
                    [self.socketView passwordCheck:CATextField_Encrypt.text passwordType:0]; //密码四位
                }
                
            }
        }
    }
    
    
    
}
-(void)changeSTBAlertTitle
{
    STBAlert.title = @"Please input your Decoder PIN"; //将decoder PIN 的文字改成@"Please input your Decoder PIN"
}
-(void)changeCAAlertTitle
{
    CAAlert.title = @"Please input your CA PIN"; //将CA PIN 的文字改成@"Please input your CA PIN"
}
-(BOOL)textFiledEditChanged:(NSNotification *)obj{
    
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (textField.text.length == 0) {
        STBAlert.dontDisppear = YES;
        CAAlert.dontDisppear = YES;
        NSLog(@"=0=0=0=0=0=0=0=00=0=0=0=0=0=0=0=0=0");
    }
    
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
        if (proposedNewLength >= 1) {
            STBAlert.dontDisppear = NO;
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
        if (proposedNewLength >= 1) {
            CAAlert.dontDisppear = NO;
        }
        return YES;
        
        
    }
}

-(void)serviceEPGSetData : (NSInteger)row diction :(NSDictionary *)dic
{
    NSLog(@"lansdannabfafa=asfasfbaf");
    //=====则去掉不能播放的字样，加上加载环
    [self removeLabAndAddIndecatorView];
    
    NSLog(@"self.socket:%@",self.socketView);
    
    //先传输数据到socket，然后再播放视频
    //    NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",row]];
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    
    NSLog(@"dic: %@",dic);
    
    NSLog(@"row: %ld",(long)row);
    /*此处添加一个加入历史版本的函数*/
    [self addHistory:row diction:dic];
    [USER_DEFAULT setObject:@"NO" forKey:@"audioOrSubtTouch"];
    [self.videoController setaudioOrSubtRowIsZero];
    //    [self getsubt];
    //__
    
    NSArray * audio_infoArr = [[NSArray alloc]init];
    NSArray * subt_infoArr = [[NSArray alloc]init];
    
    NSArray * epg_infoArr = [[NSArray alloc]init];
    //****
    
    
    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
    if (audio_infoArr.count > 1) {
        socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
    }
    if (subt_infoArr.count > 1) {
        socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
    }
    
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
    if (epg_infoArr.count == 0) {
        
    }else
    {
        self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
        self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
        self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
    }
  
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
    NSLog(@"channelCount==--==--55555= %d ",self.video.channelCount);
    
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
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
    
    
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
    
    
}

//判断开始时间和当前时间的大小关系，如果开始时间比当前时间还大，那么则isEventStartTimeBiger_NowTime == yes
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endMJRefresh) object:nil];
    [self performSelector:@selector(endMJRefresh) withObject:nil afterDelay:EndMJRefreshTime];
    NSLog(@"12 秒后准备停止刷新");
    
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
    
    
    [request startAsynchronous];   //异步
    
    WEAKGET
    [request setCompletionBlock:^{
        
        
        
        NSDictionary *response = httpRequest.responseString.JSONValue;
        
        //将数据本地化
        [USER_DEFAULT setObject:response forKey:@"TVHttpAllData"];
        
        //        NSLog(@"response = %@",response);
        NSArray *data1 = response[@"service"];
        
        if (!isValidArray(data1) || data1.count == 0)
        {
            //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空
            
            if (response[@"data_valid_flag"] != NULL || [response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                
                if (_slideView) {
                    [_slideView removeFromSuperview];
                    _slideView = nil;
                    
                }
                //机顶盒连接成功了，但是没有数据
                //显示列表为空的数据
                if (!self.NoDataImageview) {
                    self.NoDataImageview = [[UIImageView alloc]init];
                    
                }
                //显示列表为空的数据
                if (!self.NoDataLabel) {
                    self.NoDataLabel = [[UILabel alloc]init];
                    
                }
            }else
            {
                //机顶盒连接出错了，所以要显示没有网络的加载图
                [self tableViewDataRefreshForMjRefresh]; //如果数据为空，则重新获取数据
                return ;
            }
            self.NoDataImageview.image = [UIImage imageNamed:@"无频道列表@3x"];
            self.NoDataImageview.frame = CGRectMake((SCREEN_WIDTH - 60)/2, (SCREEN_HEIGHT -(64.5+kZXVideoPlayerOriginalHeight+1.5 + 110 + 49))/2 + 64.5+kZXVideoPlayerOriginalHeight+1.5 ,  60,  60) ;
            
            
            self.NoDataImageview.alpha = 1;
            [self.view addSubview:self.NoDataImageview];
            
            
            
            self.NoDataLabel.text = @"Channel List is empty";
            self.NoDataLabel.textColor = UIColorFromRGB(0x848484);
            //
            CGSize sizeNoDataLabel = [GGUtil sizeWithText:@"Channel List is empty" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            
            self.NoDataLabel.frame = CGRectMake((SCREEN_WIDTH - sizeNoDataLabel.width)/2,self.NoDataImageview.frame.origin.y + 10 + self.NoDataImageview.frame.size.height , sizeNoDataLabel.width, sizeNoDataLabel.height);
            self.NoDataLabel.textAlignment = NSTextAlignmentCenter;
            self.NoDataLabel.alpha = 1;
            [self.view addSubview:self.NoDataLabel];
            //
            
            [self removeTopProgressView]; //删除进度条
            
            
            
            
            isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
            [self removeTipLabAndPerformSelector];   //取消不能播放的文字
            [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
        }
        else
        {
            NSLog(@"做一次显示的操作222");
            if ([[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"YES"]) {
                if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 420) {
                    
                    
                    NSNotification *notification1 =[NSNotification notificationWithName:@"channeListIsShow" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                    
                }
                [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
                NSLog(@"NOChannelDataDefault 555");
            }
            
        }
        //        {
        //
        //            [self tableViewDataRefreshForMjRefresh];
        //            return ;
        //        }
        self.serviceData = (NSMutableArray *)data1;
        
        NSLog(@"before self.categorys %@",self.categorys);
        self.categorys = (NSMutableArray *)response[@"category"];  //新加，防止崩溃的地方
        NSLog(@"last   self.categorys %@",self.categorys);
        
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        
        
        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil)
        {
            //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空
            
            if (response[@"data_valid_flag"] != NULL || [response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                
                if (_slideView) {
                    [_slideView removeFromSuperview];
                    _slideView = nil;
                    
                }
                
                //机顶盒连接成功了，但是没有数据
                //显示列表为空的数据
                if (!self.NoDataImageview) {
                    self.NoDataImageview = [[UIImageView alloc]init];
                }
                //显示列表为空的数据
                if (!self.NoDataLabel) {
                    self.NoDataLabel = [[UILabel alloc]init];
                    
                }
            }else
            {
                //机顶盒连接出错了，所以要显示没有网络的加载图
                [self tableViewDataRefreshForMjRefresh]; //如果数据为空，则重新获取数据
                return ;
            }
            self.NoDataImageview.image = [UIImage imageNamed:@"无频道列表@3x"];
            self.NoDataImageview.frame = CGRectMake((SCREEN_WIDTH - 60)/2, (SCREEN_HEIGHT -(64.5+kZXVideoPlayerOriginalHeight+1.5 + 110 + 49))/2 + 64.5+kZXVideoPlayerOriginalHeight+1.5 ,  60,  60) ;
            
            self.NoDataImageview.alpha = 1;
            [self.view addSubview:self.NoDataImageview];
            
            
            self.NoDataLabel.text = @"Channel List is empty";
            self.NoDataLabel.textColor = UIColorFromRGB(0x848484);
            //
            CGSize sizeNoDataLabel = [GGUtil sizeWithText:@"Channel List is empty" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            
            self.NoDataLabel.frame = CGRectMake((SCREEN_WIDTH - sizeNoDataLabel.width)/2,self.NoDataImageview.frame.origin.y + 10 + self.NoDataImageview.frame.size.height , sizeNoDataLabel.width, sizeNoDataLabel.height);
            self.NoDataLabel.textAlignment = NSTextAlignmentCenter;
            self.NoDataLabel.alpha = 1;
            [self.view addSubview:self.NoDataLabel];
            //
            [self removeTopProgressView]; //删除进度条
            
            isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
            [self removeTipLabAndPerformSelector];   //取消不能播放的文字
            [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
            
        }else
        {
            NSLog(@"做一次显示的操作222");
            if ([[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"YES"]) {
                if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 400) {
                    
                    
                    NSNotification *notification1 =[NSNotification notificationWithName:@"channeListIsShow" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                    
                }
                [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
                NSLog(@"NOChannelDataDefault 666");
            }
            
        }
        
        //        {
        //
        //            [self tableViewDataRefreshForMjRefresh];
        //        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        [self lineAndSearchBtnShow];
        
        
        
        //
        
        NSLog(@"self.tableForDicIndexDic.count :%lu",(unsigned long)self.tableForDicIndexDic.count);
        NSLog(@"self.tableForDicIndexDic :%@",self.tableForDicIndexDic);
        //        for (int i = 0; i<self.tableForDicIndexArr.count; i++) {
        
        NSString * YLSlideTitleViewButtonTagIndexStr = [USER_DEFAULT objectForKey:@"YLSlideTitleViewButtonTagIndexStr"];
        
        int YLSlideTitleViewButtonTagIndex = [YLSlideTitleViewButtonTagIndexStr  intValue];
        
        //        self.tableForSliderView = self.tableForDicIndexArr[YLSlideTitleViewButtonTagIndex][1];
        NSString *  indexforTableToNum =YLSlideTitleViewButtonTagIndexStr ;
        //        [NSNumber numberWithInteger:YLSlideTitleViewButtonTagIndex];
        self.tableForSliderView = [self.tableForDicIndexDic objectForKey :indexforTableToNum] [1];
        //            if (YLSlideTitleViewButtonTagIndex < self.tableForDicIndexArr.count) {
        //        if (YLSlideTitleViewButtonTagIndex < self.tableForDicIndexDic.count) {
        
        //            }
        
        ////////==================
        
        //            id idTemp = self.tableForDicIndexArr[YLSlideTitleViewButtonTagIndex][1];
        //            NSNumber *  indexforTableToNum = [NSNumber numberWithInteger:YLSlideTitleViewButtonTagIndex];
        id idTemp = [self.tableForDicIndexDic objectForKey:indexforTableToNum][1];
        NSNumber * numTemp = [self.tableForDicIndexDic objectForKey:indexforTableToNum][0];
     
        NSInteger index = [numTemp integerValue];
        if (index >= self.categorys.count) {
            
        }
        
        NSDictionary *item = self.categorys[index];   //当前页面类别下的信息
        self.categoryModel = [[CategoryModel alloc]init];
        
        self.categoryModel.service_indexArr = item[@"service_index"];   //当前类别下包含的节目索引  0--9
        
        //获取EPG信息 展示
        //时间戳转换
        
        [self.dicTemp removeAllObjects];
        //获取不同类别下的节目，然后是节目下不同的cell值                10
        for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {
            
            int indexCat ;
            indexCat =[self.categoryModel.service_indexArr[i] intValue];
            //cell.tabledataDic = self.serviceData[indexCat -1];
            
            
            //此处判断是否为空，防止出错
            if ( ISNULL(self.serviceData)) {
                
            }else{
                
                if (indexCat-1 > self.serviceData.count) {
                }
                
    
                NSLog(@" indexCat -1 %d",indexCat -1);
                NSLog(@" self.serviceData.count %lu",(unsigned long)self.serviceData.count);
                
                if (indexCat -1 < self.serviceData.count) {
                    
                    NSLog(@" self.dicTemp %@",self.dicTemp);
                    NSLog(@"=-=-===  在 33  中");
                    //                            [self.dicTemp setObject:abcddArr[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];
                    [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
                    //                            aaaaaaa = 1;
                    
                }else
                {
                    NSLog(@"不能再往里面添加了，再添加会报错");
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
        
        
        
        [self.table reloadData];
        
        
    }];
}

#pragma mark - 主页一秒钟刷新一次
-(void)tableViewDataRefreshForMjRefresh_ONEMinute
{
    
    NSLog(@"我要刷新一次呀=^_^");
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
 
    [request startAsynchronous];   //异步
    
    WEAKGET
    [request setCompletionBlock:^{
        
        NSDictionary *response = httpRequest.responseString.JSONValue;
        
        //将数据本地化
        [USER_DEFAULT setObject:response forKey:@"TVHttpAllData"];
        
        //        NSLog(@"response = %@",response);
        NSArray *data1 = response[@"service"];
        
        //录制节目,保存数据
        NSArray *recFileData = response[@"rec_file_info"];
        NSLog(@"recFileData %@",recFileData);
        [USER_DEFAULT setObject:recFileData forKey:@"categorysToCategoryViewContainREC"];
  
        if (!isValidArray(data1) || data1.count == 0){
            //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空
            
            if (response[@"data_valid_flag"] != NULL || [response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                
                if (_slideView) {
                    [_slideView removeFromSuperview];
                    _slideView = nil;
                    
                }
                
                //机顶盒连接成功了，但是没有数据
                //显示列表为空的数据
                if (!self.NoDataImageview) {
                    self.NoDataImageview = [[UIImageView alloc]init];
                }
                //显示列表为空的数据
                if (!self.NoDataLabel) {
                    self.NoDataLabel = [[UILabel alloc]init];
                    
                }
            }else
            {
                //机顶盒连接出错了，所以要显示没有网络的加载图
                [self tableViewDataRefreshForMjRefresh_ONEMinute]; //如果数据为空，则重新获取数据
                return ;
            }
            self.NoDataImageview.image = [UIImage imageNamed:@"无频道列表@3x"];
            self.NoDataImageview.frame = CGRectMake((SCREEN_WIDTH - 60)/2, (SCREEN_HEIGHT -(64.5+kZXVideoPlayerOriginalHeight+1.5 + 110 + 49))/2 + 64.5+kZXVideoPlayerOriginalHeight+1.5 ,  60,  60) ;
            
            self.NoDataImageview.alpha = 1;
            [self.view addSubview:self.NoDataImageview];
            
            
            self.NoDataLabel.text = @"Channel List is empty";
            self.NoDataLabel.textColor = UIColorFromRGB(0x848484);
            //
            CGSize sizeNoDataLabel = [GGUtil sizeWithText:@"Channel List is empty" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            
            self.NoDataLabel.frame = CGRectMake((SCREEN_WIDTH - sizeNoDataLabel.width)/2,self.NoDataImageview.frame.origin.y + 10 + self.NoDataImageview.frame.size.height , sizeNoDataLabel.width, sizeNoDataLabel.height);
            self.NoDataLabel.textAlignment = NSTextAlignmentCenter;
            self.NoDataLabel.alpha = 1;
            [self.view addSubview:self.NoDataLabel];
            //
            
            
            isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
            [self removeTipLabAndPerformSelector];   //取消不能播放的文字
            [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
            NSLog(@"zidong  刷新了一次");
            [self removeTopProgressView]; //删除进度条
          
            if ( [[USER_DEFAULT objectForKey:@"deliveryPlayState"] isEqualToString:@"stopDelivery"]) {

                [USER_DEFAULT setObject:@"stopDelivery" forKey:@"deliveryPlayState"];
                
                NSNotification *notification =[NSNotification notificationWithName:@"cantDeliveryNotific" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        }else
        {
            NSLog(@"做一次显示的操作222");
            if ([[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"YES"]) {
                if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 420) {
                    
                    
                    NSNotification *notification1 =[NSNotification notificationWithName:@"channeListIsShow" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                    
                }
                [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
                 NSLog(@"NOChannelDataDefault 777");
            }
            
        }
        self.serviceData = (NSMutableArray *)data1;
        
        self.categorys = (NSMutableArray *)response[@"category"];  //新加，防止崩溃的地方
        
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        
        NSLog(@"self.serviceData-c-c-c- %@",self.serviceData);
        if (self.serviceData.count == 0 || self.serviceData == nil|| self.serviceData == NULL )
        {
            //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空
            
            if (response[@"data_valid_flag"] != NULL || [response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                
                if (_slideView) {
                    [_slideView removeFromSuperview];
                    _slideView = nil;
                    
                }
                
                //机顶盒连接成功了，但是没有数据
                //显示列表为空的数据
                NSLog(@"zidong  刷新了一次22");
                if (!self.NoDataImageview) {
                    self.NoDataImageview = [[UIImageView alloc]init];
                    
                    //1. 全屏按钮隐藏 2.取消加载环 3.取消名称
                    
                }
            }else
            {
                //机顶盒连接出错了，所以要显示没有网络的加载图
                [self tableViewDataRefreshForMjRefresh_ONEMinute]; //如果数据为空，则重新获取数据
                return ;
            }
            self.NoDataImageview.image = [UIImage imageNamed:@"无频道列表@3x"];
            self.NoDataImageview.frame = CGRectMake((SCREEN_WIDTH - 60)/2, (SCREEN_HEIGHT -(64.5+kZXVideoPlayerOriginalHeight+1.5 + 110 + 49))/2 + 64.5+kZXVideoPlayerOriginalHeight+1.5 ,  60,  60) ;
            
            self.NoDataImageview.alpha = 1;
            [self.view addSubview:self.NoDataImageview];
            
            
            self.NoDataLabel.text = @"Channel List is empty";
            self.NoDataLabel.textColor = UIColorFromRGB(0x848484);
            //
            CGSize sizeNoDataLabel = [GGUtil sizeWithText:@"Channel List is empty" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            
            self.NoDataLabel.frame = CGRectMake((SCREEN_WIDTH - sizeNoDataLabel.width)/2,self.NoDataImageview.frame.origin.y + 10 + self.NoDataImageview.frame.size.height , sizeNoDataLabel.width, sizeNoDataLabel.height);
            self.NoDataLabel.textAlignment = NSTextAlignmentCenter;
            self.NoDataLabel.alpha = 1;
            [self.view addSubview:self.NoDataLabel];
            //
            
            
            isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
            [self removeTipLabAndPerformSelector];   //取消不能播放的文字
            [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
            NSLog(@"zidong  刷新了一次");
            [self removeTopProgressView]; //删除进度条
            
            if ( [[USER_DEFAULT objectForKey:@"deliveryPlayState"] isEqualToString:@"stopDelivery"]) {
                [USER_DEFAULT setObject:@"stopDelivery" forKey:@"deliveryPlayState"];
                
                NSNotification *notification =[NSNotification notificationWithName:@"cantDeliveryNotific" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        }else
        {
            NSLog(@"做一次显示的操作222");
            if ([[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"YES"]) {
                if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 400) {
                    
                    
                    NSNotification *notification1 =[NSNotification notificationWithName:@"channeListIsShow" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                    
                }
                [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
                NSLog(@"NOChannelDataDefault 888");
            }
            
        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        [self lineAndSearchBtnShow];
        
        
        
        
        //        for (int i = 0; i<self.tableForDicIndexArr.count; i++) {
        
        NSString * YLSlideTitleViewButtonTagIndexStr = [USER_DEFAULT objectForKey:@"YLSlideTitleViewButtonTagIndexStr"];
        
        int YLSlideTitleViewButtonTagIndex = [YLSlideTitleViewButtonTagIndexStr  intValue];
        
        NSString *  indexforTableToNum = YLSlideTitleViewButtonTagIndexStr;
        //        [NSNumber numberWithInteger:YLSlideTitleViewButtonTagIndex];
        self.tableForSliderView = [self.tableForDicIndexDic objectForKey:indexforTableToNum][1];
        NSLog(@"此时self.tableForSliderView 2%@",self.tableForSliderView);
        NSLog(@"此时self.tableForSliderView 33332%@",self.tableForDicIndexDic);
        //        self.tableForSliderView = self.tableForDicIndexArr[YLSlideTitleViewButtonTagIndex][1];
        if (YLSlideTitleViewButtonTagIndex < self.tableForDicIndexDic.count) {
            
            id idTemp = [self.tableForDicIndexDic objectForKey:indexforTableToNum][1];
            
            NSNumber * numTemp = [self.tableForDicIndexDic objectForKey:indexforTableToNum][0];
            
            NSInteger index = [numTemp integerValue];
            NSLog(@"jfabdjasbajsbd index %d",index);
//            if (index >= self.categorys.count) {
//
//            }
            //此处可能出现崩溃-----数组为空
            NSDictionary *item ;
            if (index > 0 ) {
                item = self.categorys[index];   //当前页面类别下的信息
               
                self.categoryModel = [[CategoryModel alloc]init];
                
                self.categoryModel.service_indexArr = item[@"service_index"];   //当前类别下包含的节目索引  0--9
            }else
            {

            }
            
       
            [self.dicTemp removeAllObjects];
            //获取不同类别下的节目，然后是节目下不同的cell值                10
            for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {
                
                int indexCat ;
                indexCat =[self.categoryModel.service_indexArr[i] intValue];
                //cell.tabledataDic = self.serviceData[indexCat -1];
                
                
                //此处判断是否为空，防止出错
                if ( ISNULL(self.serviceData)) {
                    
                }else{
                    
                    if (indexCat-1 > self.serviceData.count) {
                    }
                    
                    if (indexCat -1 < self.serviceData.count) {
              
                        NSMutableArray * abcddArr = [[NSMutableArray alloc]init];
                        abcddArr =  [self.serviceData mutableCopy];
                        
                        NSMutableDictionary * cccArr = [abcddArr[0]  mutableCopy] ;
                        
                        [abcddArr replaceObjectAtIndex:0 withObject:cccArr];
                        
                        [self.dicTemp setObject:abcddArr[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
                        
                        NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",i]];
                        
                        
                    }else
                    {
                        NSLog(@"不能再往里面添加了，再添加会报错");
                    }
                    
                }
                
                
            }
            
          
        }
        
      
        
        //==========
        [self.tableForSliderView reloadData];

        // 模拟延迟2秒

        double delayInSeconds = 2;
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, mainQueue, ^{
            NSLog(@"延时执行的2秒");

            [self.tableForSliderView reloadData];

        });
       
 
        //获取数据的链接
        NSString *urlCate = [NSString stringWithFormat:@"%@",S_category];
 
        LBGetHttpRequest *request = CreateGetHTTP(urlCate);
 
        [request startAsynchronous];
        
        WEAKGET
        [request setCompletionBlock:^{
            NSDictionary *response = httpRequest.responseString.JSONValue;
 
            NSArray *data = response[@"category"];
 
            if (data.count == 0 && recFileData.count == 0){ //没有数据

                [USER_DEFAULT setObject:@"RecAndLiveNotHave" forKey:@"RECAndLiveType"];
                return ;
            }else if(data.count == 0 && recFileData.count != 0){ //有录制没直播

                [USER_DEFAULT setObject:@"RecExit" forKey:@"RECAndLiveType"];

                // 特殊情况，有录制但是没有service数据
                [self.CategoryAndREC removeAllObjects];
                NSLog(@"recFileData %@",recFileData);
                [self.CategoryAndREC addObject: recFileData];

            }else if(recFileData.count == 0 && data.count != 0) //有直播没录制
            {
                [USER_DEFAULT setObject:@"LiveExit" forKey:@"RECAndLiveType"];

                [self.CategoryAndREC removeAllObjects];
                [self.CategoryAndREC addObject:data];
            }else //两种都有
            {
                [USER_DEFAULT setObject:@"RecAndLiveAllHave" forKey:@"RECAndLiveType"];

                [self.CategoryAndREC removeAllObjects];
                NSLog(@"self.categorys %@",self.categorys);
                [self.CategoryAndREC addObject:data];
                NSLog(@"recFileData %@",recFileData);
                [self.CategoryAndREC addObject: recFileData];
            }
            self.categorys = (NSMutableArray *)data;

            //2017.11.20 注释，防止刷新时造成整个列表都回到顶部
//            [_slideView removeFromSuperview];
//            _slideView = nil;

            if (!_slideView) {
               
                //判断是不是全屏
                BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
                if (isFullScreen == NO) {   //竖屏状态


                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.CategoryAndREC];

                    isHasChannleDataList = YES;
                    [self.tableForDicIndexDic removeAllObjects]; //存储表和索引关系的数组
                }else //横屏状态，不刷新
                {

                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.CategoryAndREC];
                    [self.tableForDicIndexDic removeAllObjects]; //存储表和索引关系的数组
                }



                NSArray *ArrayTocategory = [NSArray arrayWithArray:self.CategoryAndREC];
                [USER_DEFAULT setObject:ArrayTocategory forKey:@"categorysToCategoryView"];


                _slideView.backgroundColor = [UIColor whiteColor];
                _slideView.delegate        = self;

                [self.view addSubview:_slideView];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];


                NSLog(@"要显示了，没有隐藏");
                NSLog(@"mediaDeliveryUpdate 要显示了，没有隐藏" );
 
                BOOL isFullScreen1 =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
                if (isFullScreen1 == YES) {
                    //此刻是全屏，隐藏进度条

                }else
                {//此刻是竖屏，不隐藏进度条

                    NSNotification *notification1 =[NSNotification notificationWithName:@"fullScreenBtnShow" object:nil userInfo:nil];
    //                    通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                }


            }
            if (firstfirst == YES) {


                //                [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                //                firstOpenAPP = firstOpenAPP+1;

                //                firstfirst = NO;

            }else
            {}

        }];
        
        
        [self.table reloadData];
        
       
    }];
}
#pragma mark - IP改变后的刷新方法
//IP改变后或者是HMC改变后的刷新方法  ,类似于getServiceData
-(void) getServiceDataForIPChange
{
    NSLog(@"ip has change");
    NSLog(@"并且 HMC has change");
    NSLog(@"执行执行执行执行====iphaschange");
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
        
        
        //录制节目,保存数据
        NSArray *recFileData = response[@"rec_file_info"];
        NSLog(@"recFileData %@",recFileData);
        [USER_DEFAULT setObject:recFileData forKey:@"categorysToCategoryViewContainREC"];
        
        if ( data1.count == 0 && recFileData.count == 0){
//            [self getServiceDataForIPChange];
//            return ;
            //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空
            if (response[@"data_valid_flag"] != NULL || [response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                //机顶盒连接成功了，但是没有数据
                //显示列表为空的数据
                
                if (_slideView) {
                    [_slideView removeFromSuperview];
                    _slideView = nil;
                    
                }
                
                self.NoDataImageview = [[UIImageView alloc]init];
                self.NoDataImageview.image = [UIImage imageNamed:@"无频道列表@3x"];
                self.NoDataImageview.frame = CGRectMake((SCREEN_WIDTH - 60)/2, (SCREEN_HEIGHT -(64.5+kZXVideoPlayerOriginalHeight+1.5 + 110 + 49))/2 + 64.5+kZXVideoPlayerOriginalHeight+1.5 ,  60,  60) ;
                self.NoDataImageview.alpha = 1;
                [self.view addSubview:self.NoDataImageview];
                self.NoDataLabel = [[UILabel alloc]init];
                self.NoDataLabel.text = @"Channel List is empty";
                self.NoDataLabel.textColor = UIColorFromRGB(0x848484);
                //
                CGSize sizeNoDataLabel = [GGUtil sizeWithText:@"Channel List is empty" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                
                self.NoDataLabel.frame = CGRectMake((SCREEN_WIDTH - sizeNoDataLabel.width)/2,self.NoDataImageview.frame.origin.y + 10 + self.NoDataImageview.frame.size.height , sizeNoDataLabel.width, sizeNoDataLabel.height);
                self.NoDataLabel.textAlignment = NSTextAlignmentCenter;
                self.NoDataLabel.alpha = 1;
                [self.view addSubview:self.NoDataLabel];
                
                isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
                [self removeTipLabAndPerformSelector];   //取消不能播放的文字
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
                

            
            }else
            {
                double delayInSeconds = 1;
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, mainQueue, ^{
                    NSLog(@"延时执行的2秒");
                    //机顶盒连接出错了，所以要显示没有网络的加载图
                    [self getServiceDataForIPChange]; //如果数据为空，则重新获取数据
                });
                
                [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
                NSLog(@"NOChannelDataDefault 111");
                NSLog(@"可能会出现播放器空白的情况");
                return ;
            }
            
        }
        self.serviceData = (NSMutableArray *)data1;
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        //        NSLog(@"--------%@",self.serviceData);
        
        
        BOOL serviceDatabool = [self judgeServiceDataIsnull];
        if (serviceDatabool && recFileData.count == 0) {
//            [self getServiceDataForIPChange];
            
            if (response[@"data_valid_flag"] != NULL || [response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                
                //机顶盒连接成功了，但是没有数据
                //显示列表为空的数据
                if (_slideView) {
                    [_slideView removeFromSuperview];
                    _slideView = nil;
                    
                }
                
                if (!self.NoDataImageview) {
                    self.NoDataImageview = [[UIImageView alloc]init];
                    
                }
                
                
                self.NoDataImageview.image = [UIImage imageNamed:@"无频道列表@3x"];
                
                self.NoDataImageview.frame = CGRectMake((SCREEN_WIDTH - 60)/2, (SCREEN_HEIGHT -(64.5+kZXVideoPlayerOriginalHeight+1.5 + 110 + 49))/2 + 64.5+kZXVideoPlayerOriginalHeight+1.5 ,  60,  60) ;
                
                self.NoDataImageview.alpha = 1;
                [self.view addSubview:self.NoDataImageview];
                
                
                if (!self.NoDataLabel) {
                    self.NoDataLabel = [[UILabel alloc]init];
                    
                }
                self.NoDataLabel.text = @"Channel List is empty";
                self.NoDataLabel.textColor = UIColorFromRGB(0x848484);
                //
                CGSize sizeNoDataLabel = [GGUtil sizeWithText:@"Channel List is empty" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                
                self.NoDataLabel.frame = CGRectMake((SCREEN_WIDTH - sizeNoDataLabel.width)/2,self.NoDataImageview.frame.origin.y + 10 + self.NoDataImageview.frame.size.height , sizeNoDataLabel.width, sizeNoDataLabel.height);
                self.NoDataLabel.textAlignment = NSTextAlignmentCenter;
                self.NoDataLabel.alpha = 1;
                [self.view addSubview:self.NoDataLabel];
                
                //
                
                
                isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
                [self removeTipLabAndPerformSelector];   //取消不能播放的文字
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
            }else
            {
                //机顶盒连接出错了，所以要显示没有网络的加载图
                [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
                NSLog(@"NOChannelDataDefault 222");
                [self getServiceDataForIPChange]; //如果数据为空，则重新获取数据
                //                return ;
            }
        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        [self lineAndSearchBtnShow];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notHaveNetWork) object:nil];
        [self playVideo];
        
        
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
            
//            if (!isValidArray(data) || data.count == 0){
//                return ;
//            }
            if (data.count == 0 && recFileData.count == 0){ //没有数据
                
                [USER_DEFAULT setObject:@"RecAndLiveNotHave" forKey:@"RECAndLiveType"];
                return ;
            }else if(data.count == 0 && recFileData.count != 0){ //有录制没直播
                
                [USER_DEFAULT setObject:@"RecExit" forKey:@"RECAndLiveType"];
                
                // 特殊情况，有录制但是没有service数据
                [self.CategoryAndREC removeAllObjects];
                NSLog(@"recFileData %@",recFileData);
                [self.CategoryAndREC addObject: recFileData];
                
            }else if(recFileData.count == 0 && data.count != 0) //有直播没录制
            {
                [USER_DEFAULT setObject:@"LiveExit" forKey:@"RECAndLiveType"];
                
                [self.CategoryAndREC removeAllObjects];
                [self.CategoryAndREC addObject:data];
            }else //两种都有
            {
                [USER_DEFAULT setObject:@"RecAndLiveAllHave" forKey:@"RECAndLiveType"];
                
                [self.CategoryAndREC removeAllObjects];
                NSLog(@"self.categorys %@",self.categorys);
                [self.CategoryAndREC addObject:data];
                NSLog(@"recFileData %@",recFileData);
                [self.CategoryAndREC addObject: recFileData];
            }

            self.categorys = (NSMutableArray *)data;
            
           
            [_slideView removeFromSuperview];
            _slideView = nil;
            
            if (!_slideView) {
               
                [self playVideo];
                
                //判断是不是全屏
                BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
                if (isFullScreen == NO) {   //竖屏状态
                    
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.CategoryAndREC];
                    
                    isHasChannleDataList = YES;
                    [self.tableForDicIndexDic removeAllObjects]; //存储表和索引关系的数组
                    NSLog(@"removeAllObjects 第 6 次");
                }else //横屏状态，不刷新
                {
                    
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.CategoryAndREC];
                    [self.tableForDicIndexDic removeAllObjects]; //存储表和索引关系的数组
                    NSLog(@"removeAllObjects 第 7 次");
                }
                
                
                
                NSArray *ArrayTocategory = [NSArray arrayWithArray:self.CategoryAndREC];
                [USER_DEFAULT setObject:ArrayTocategory forKey:@"categorysToCategoryView"];
                
                
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
            NSLog(@"执行执行执行执行4444");
            if (firstfirst == YES) {
                
                
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
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                        
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                        
                    }else //正常播放的步骤
                    {
                        NSLog(@"执行执行执行执行6666");
                        //======
                        [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                    }
                }else //正常播放的步骤
                {
                    //======机顶盒加密
                    NSLog(@"执行执行执行执行7777");
                    [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }
            }else
            {}
            
           
            [USER_DEFAULT  setObject:@"YES" forKey:@"viewHasAddOver"];  //第一次进入时，显示页面加载完成
            
        }];
        
        
        [self initProgressLine];
        //        [self getSearchData];
        
        
        
        [self.table reloadData];
        
    }];
    
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

#pragma mark - 用户按home键回到主界面，再次返回时，如果是首页，则自动播放历史中的最后一个视频
-(void)returnFromHomeToTVViewNotific
{
    //新建一个通知，用来监听从机顶盒密码验证正确跳转来的播放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"returnFromHomeToTVViewNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnFromHomeToTVView) name:@"returnFromHomeToTVViewNotific" object:nil];
}
-(void)returnFromHomeToTVView //如果是从其他的页面条转过来的，则自动播放上一个视频
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"judgeJumpFromOtherViewjudgeJumpFromOtherView");
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
        NSLog(@"取消25秒的等待5");
    });
    NSString * deliveryPlayState =  [USER_DEFAULT objectForKey:@"deliveryPlayState"];
    
    //    if ([deliveryPlayState isEqualToString:@"stopDelivery"]) {
    //        //①视频停止分发，断开了和盒子的连接，跳转界面不播放  ②禁止播放  ③取消掉加载环  ④ 显示不能播放的文字
    //        [self stopVideoPlay]; //停止视频播放
    //
    //        //        //取消掉加载环
    //        //        NSNotification *notification1 =[NSNotification notificationWithName:@"IndicatorViewHiddenNotic" object:nil userInfo:nil];
    //        //        //        //通过通知中心发送通知
    //        //        [[NSNotificationCenter defaultCenter] postNotification:notification1];
    //
    //        //        NSString * playStateType = deliveryStopTip;
    //        [USER_DEFAULT setObject:deliveryStopTip forKey:@"playStateType"];
    //        //        NSDictionary *playStateTypeDic =[[NSDictionary alloc] initWithObjectsAndKeys:playStateType,@"playStateType",nil];
    //        NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
    //        //        //通过通知中心发送通知
    //        [[NSNotificationCenter defaultCenter] postNotification:notification];
    //
    //
    //
    //
    //    }else //视频没有停止分发，跳转界面可以播放
    //    {
    //=====则去掉不能播放的字样，加上加载环
    [self removeLabAndAddIndecatorView];
    
    //        NSString * jumpFormOtherView =  [USER_DEFAULT objectForKey:@"jumpFormOtherView"];
    //        if([jumpFormOtherView isEqualToString:@"YES"])
    //        {
    NSMutableArray * historyArr  =  (NSMutableArray *) [USER_DEFAULT objectForKey:@"historySeed"];
    NSLog(@"挖从奥到底dic come on");
    if (historyArr == NULL || historyArr.count == 0 || historyArr == nil) {
        
        if (storeLastChannelArr.count < 2) {
            return;
        }else
        {
            NSInteger row = [storeLastChannelArr[2] integerValue];
            NSDictionary * dic = storeLastChannelArr [3];
            //在这里添加判断 机顶盒是否加密
            
            //在这里添加判断 机顶盒是否加密
            //=======机顶盒加密
            NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:row serviceListDic:dic];
            if (characterStr != NULL && characterStr != nil) {
                BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                if (judgeIsSTBDecrypt == YES) {
                    // 此处代表需要记性机顶盒加密验证
                    NSNumber  *numIndex = [NSNumber numberWithInteger:row];
                    NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"otherTouch",@"textThree",nil];
                    //创建通知
                    NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                    
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }else //正常播放的步骤
                {
                    //======
                    [self firstOpenAppAutoPlay:row diction:dic];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }
            }else //正常播放的步骤
            {
                //======机顶盒加密
                [self firstOpenAppAutoPlay:row diction:dic];
            }
            
            
            
            
            [USER_DEFAULT setObject:@"NO" forKey:@"jumpFormOtherView"];//为TV页面存储方法
        }
        
        
    }else
    {
        if (storeLastChannelArr.count < 2) {
            return;
        }else
        {
            
            NSArray * touchArr = historyArr[historyArr.count - 1];
            
            NSInteger row = [storeLastChannelArr[2] integerValue];
            NSDictionary * dic = storeLastChannelArr [3];
            //在这里添加判断 机顶盒是否加密
            //=======机顶盒加密
            NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:row serviceListDic:dic];
            if (characterStr != NULL && characterStr != nil) {
                BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                if (judgeIsSTBDecrypt == YES) {
                    // 此处代表需要记性机顶盒加密验证
                    NSNumber  *numIndex = [NSNumber numberWithInteger:row];
                    NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"otherTouch",@"textThree",nil];
                    //创建通知
                    NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                    
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }else //正常播放的步骤
                {
                    //======
                    [self firstOpenAppAutoPlay:row diction:dic];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }
            }else //正常播放的步骤
            {
                //======机顶盒加密
                [self firstOpenAppAutoPlay:row diction:dic];
            }
            
            //////
            //            NSLog(@"挖从奥到底dic 11 %@",dic);
            //            NSNumber * numIndex = [NSNumber numberWithInt:row];
            //
            //            //添加 字典，将label的值通过key值设置传递
            //            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
            //            //创建通知
            //            NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
            //            //通过通知中心发送通知
            //            [[NSNotificationCenter defaultCenter] postNotification:notification];
            //            NSLog(@"目前是judgeJumpFromOtherView");
            
            //        [self.videoController play];
            
            [USER_DEFAULT setObject:@"NO" forKey:@"jumpFormOtherView"];//为TV页面存储方法
        }
        
    }
    //    }
    
    
}
#pragma mark - 当节目CA加密弹窗过程中，收到了取消弹窗的通知
-(void)ChangeCALockNotific //机顶盒加锁改变的消息
{
    //新建一个通知，用来监听从机顶盒密码验证正确跳转来的播放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeCALockNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChangeCALockNotice:) name:@"ChangeCALockNotific" object:nil];
}
-(void)getChangeCALockNotice:(NSNotification *)text//当节目正在播放时，收到加锁通知
{
    //1.处理信息，如果发现是当前正在播放的节目，则执行第二步，否则只要修改self.dictemp这个字典就可以，还有dictemp可能被序列化了，所以需要修改 2.取消掉当前播放  3.重新执行播放
    
    //处理信息
    NSData * changeCALockData = [[NSData alloc]init];
    changeCALockData = text.userInfo[@"CARemovePopThreedata"];
    
    NSLog(@"changeCALockData %@",changeCALockData);
    
    
    [self updateChannelCALockService:changeCALockData];
    
    
}

#pragma mark - CA 加锁时，收到消息然后弹窗小时的通知
-(void)updateChannelCALockService :(NSData *)updateChannelServiceDataTemp
{
    //获取全部的channel数据，判断当前点击的channel是哪一个dic
    NSData * updateChannelServiceData = updateChannelServiceDataTemp;
    
    //1
    NSData * tuner_type_data = [[NSData alloc]init];
    if ([updateChannelServiceData length] >=  41) {
        
        tuner_type_data = [updateChannelServiceData subdataWithRange:NSMakeRange(40,1)];
    }else
    {
        return;
    }
    
    uint32_t tuner_type_int = [SocketUtils uint8FromBytes:tuner_type_data];
    
    NSLog(@"tuner_type_int == %d",tuner_type_int);
    
    if (tuner_type_int == 0) {
        // tuner_type_int == 0 的情况下，取消弹窗，并且重新播放
        
        NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigCAPINShowNotific" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
        
        
        NSArray * arrHistoryNow = [USER_DEFAULT objectForKey:@"historySeed"]; //历史数据
        
        NSArray * nowPlayChannel_Arr = arrHistoryNow[arrHistoryNow.count - 1];
        NSInteger row = [nowPlayChannel_Arr[2] intValue];
        NSDictionary * dic = nowPlayChannel_Arr [3];
        
        
        NSLog(@"不一致，不弹窗。===或者将窗口取消掉22");
        [CAAlert dismissWithClickedButtonIndex:1 animated:YES];
        //======
        [self firstOpenAppAutoPlay:row diction:dic];
        firstOpenAPP = firstOpenAPP+1;
        
        firstfirst = NO;
        
        
    }else
    {
        //依旧保持弹窗状态
    }
    
    
    
}
#pragma mark - 机顶盒回复出厂设置后，需要提示不能分发
-(void)cantDeliveryNotific //机顶盒加锁改变的消息
{
    //新建一个通知，用来监听从机顶盒密码验证正确跳转来的播放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cantDeliveryNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cantDelivery) name:@"cantDeliveryNotific" object:nil];
}
-(void)cantDelivery
{
    //①视频停止分发，断开了和盒子的连接，跳转界面不播放  ②禁止播放  ③取消掉加载环  ④ 显示不能播放的文字
    [self stopVideoPlay]; //停止视频播放
    
    //        //取消掉加载环
    //        NSNotification *notification1 =[NSNotification notificationWithName:@"IndicatorViewHiddenNotic" object:nil userInfo:nil];
    //        //        //通过通知中心发送通知
    //        [[NSNotificationCenter defaultCenter] postNotification:notification1];
    
    //        NSString * playStateType = deliveryStopTip;
    [USER_DEFAULT setObject:deliveryStopTip forKey:@"playStateType"];
    //        NSDictionary *playStateTypeDic =[[NSDictionary alloc] initWithObjectsAndKeys:playStateType,@"playStateType",nil];
    NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
    //        //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
#pragma mark - 当CA卡拔出后，显示加扰节目不能播放
-(void)NOCACardNotific //机顶盒加锁改变的消息
{
    //新建一个通知，用来监听从机顶盒密码验证正确跳转来的播放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOCACardNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NOCACardNotific:) name:@"NOCACardNotific" object:nil];
}
-(void)NOCACardNotific:(NSNotification *)text//当CA卡拔出后，显示加扰节目不能播放
{
    // 1.先判断消息的值是否等于3  如果等于3就代表CA卡被拔出
    //2. 如果节目正在播放状态，停止掉节目，显示节目不能播放的语句
    //3. 如果节目正在弹窗状态，停止掉节目，显示节目不能播放的语句
    
    //处理信息
    NSData * changeCALockData = [[NSData alloc]init];
    changeCALockData = text.userInfo[@"NOCACarddata"];
    
    NSLog(@"changeCALockData %@",changeCALockData);
    
    
    [self judgeNOCACard:changeCALockData];
    
    
}
-(void)judgeNOCACard:(NSData *)changeCALockData
{
    
    NSData * NOCACardStatus = [[NSData alloc]init];
    if ([changeCALockData length] >=  28 + 10 ) {
        NOCACardStatus =[changeCALockData subdataWithRange:NSMakeRange(28 + 9 , 1 )]; //
    }else
    {
        return;
    }
    
    uint8_t NOCACardStatusInt = [SocketUtils uint8FromBytes:NOCACardStatus];
    
    NSLog(@"NOCACardStatusInt %d",NOCACardStatusInt);
    if (NOCACardStatusInt != 3) {
        NSLog(@"jajajajahahahasdasdasdasd");
        
        //        if (self.) {
        //            <#statements#>
        //        }
        
        [USER_DEFAULT setObject:@"Lab" forKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
        
        //显示不能播放的字样
        NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        //取消CAPIN的文字和按钮
        NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigCAPINShowNotific" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
        
        CAAlert.dontDisppear = YES;
        //取消弹窗
        [CAAlert dismissWithClickedButtonIndex:1 animated:YES];
        
        
        
        
    }
    
}
#pragma mark - 当节目正在播放时，收到加锁通知
-(void)ChangeSTBLockNotific //机顶盒加锁改变的消息
{
    //新建一个通知，用来监听从机顶盒密码验证正确跳转来的播放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeSTBLockNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChangeLockNotice:) name:@"ChangeSTBLockNotific" object:nil];
}
-(void)getChangeLockNotice:(NSNotification *)text//当节目正在播放时，收到加锁通知
{
    NSLog(@"*****机顶盒改变节目的加锁状态 准备进入下一阶段");
    //1.处理信息，如果发现是当前正在播放的节目，则执行第二步，否则只要修改self.dictemp这个字典就可以，还有dictemp可能被序列化了，所以需要修改 2.取消掉当前播放  3.重新执行播放
    
    //处理信息
    NSData * changeLockData = [[NSData alloc]init];
    changeLockData = text.userInfo[@"changeLockData"];
    
    NSLog(@"changeLockData %@",changeLockData);
    
    
    [self updateChannelService:changeLockData];
    
    
}

//通过network_id ,service_id,ts_id   如果需要增加正确性的话还可以判断Tuner type这个属性===》对应的Json中的tuner mode
/**
 参数一：是传递过来的数据，数据的内容就是DTV_SERVICE_MD_UPDATE_CHANNEL_SERVICE  case = 22
 data解析后的内容就是network_id ,service_id,ts_id等
 
 */
-(void)updateChannelService:(NSData *)updateChannelServiceDataTemp
{
    NSLog(@"*****机顶盒改变节目的加锁状态 ： 进入了节目判断阶段");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获取全部的channel数据，判断当前点击的channel是哪一个dic
        NSData * updateChannelServiceData = updateChannelServiceDataTemp;
        
        //1
        NSData * tuner_type_data = [[NSData alloc]init];
        if ([updateChannelServiceData length] >=  41) {
            
            tuner_type_data = [updateChannelServiceData subdataWithRange:NSMakeRange(37,4)];
        }else
        {
            return;
        }
        uint32_t tuner_type_int = [SocketUtils uint32FromBytes:tuner_type_data];
        
        NSLog(@"tuner_type_str == %d",tuner_type_int);
        //2
        NSData * network_id_data = [[NSData alloc]init];
        if ([updateChannelServiceData length] >=  43) {
            
            network_id_data = [updateChannelServiceData subdataWithRange:NSMakeRange(41,2)];
        }else
        {
            return;
        }
        
        uint32_t network_id_int = [SocketUtils uint16FromBytes:network_id_data];
        
        NSLog(@"tuner_type_str == %d",network_id_int);
        //3
        NSData * ts_id_data = [[NSData alloc]init];
        if ([updateChannelServiceData length] >=  45) {
            
            ts_id_data = [updateChannelServiceData subdataWithRange:NSMakeRange(43,2)];
        }else
        {
            return;
        }
        
        uint32_t ts_id_int = [SocketUtils uint16FromBytes:ts_id_data];
        
        NSLog(@"tuner_type_str == %d",ts_id_int);
        //4
        NSData * service_id_data = [[NSData alloc]init];
        if ([updateChannelServiceData length] >=  47) {
            
            service_id_data = [updateChannelServiceData subdataWithRange:NSMakeRange(45,2)];
        }else
        {
            return;
        }
        
        uint32_t service_id_int = [SocketUtils uint16FromBytes:service_id_data];
        
        NSLog(@"tuner_type_str == %d",service_id_int);
        //5
        NSData * program_character_data = [[NSData alloc]init];
        if ([updateChannelServiceData length] >=  51) {
            
            program_character_data = [updateChannelServiceData subdataWithRange:NSMakeRange(47,4)];
        }else
        {
            return;
        }
        
        uint32_t program_character_int = [SocketUtils uint32FromBytes:program_character_data];
        
        NSLog(@"tuner_type_str == %d",program_character_int);
        
        
        
        NSArray * serviceArrForJudge =  [USER_DEFAULT objectForKey:@"serviceData_Default"];
        NSDictionary * serviceArrForJudge_dic ;
        
        
        
        for (int i = 0; i<serviceArrForJudge.count; i++) {
            serviceArrForJudge_dic = serviceArrForJudge[i];
            
            NSString * service_network_id1 = [serviceArrForJudge_dic objectForKey:@"service_network_id"];
            NSInteger service_network_id1_int = [service_network_id1 integerValue];
            
            NSString * service_ts_id1 = [serviceArrForJudge_dic objectForKey:@"service_ts_id"];
            NSInteger service_ts_id1_int = [service_ts_id1 integerValue];
            
            NSString * service_service_id1 = [serviceArrForJudge_dic objectForKey:@"service_service_id"];
            NSInteger service_service_id1_int = [service_service_id1 integerValue];
            
            NSString * service_character_id1 = [serviceArrForJudge_dic objectForKey:@"service_character"];
            NSInteger service_character_id1_int = [service_character_id1 integerValue];
            
            //如果这几项相等，则找到了是哪一个节目
            if (service_network_id1_int == network_id_int && service_ts_id1_int == ts_id_int && service_service_id1_int == service_id_int) {
                
                //如果相等，则停止节目   刷新数据    弹窗
                NSLog(@"asdasdasffadasfds vsdcsasad");
                NSLog(@"asdasdasffadasfds vsdcsasad %d",i);
                
                NSArray * arrHistoryNow = [USER_DEFAULT objectForKey:@"historySeed"]; //历史数据
                NSArray * nowPlayChannel_Arr ;
                if (arrHistoryNow.count >= 1) {
                    nowPlayChannel_Arr = arrHistoryNow[arrHistoryNow.count - 1];
                }else
                {
                    return;
                }
                
                NSInteger row = [nowPlayChannel_Arr[2] intValue];
                NSDictionary * dic = nowPlayChannel_Arr [3];
                
//                NSLog(@"dic == %@",dic);
                NSString * service_character_id2 = [[dic objectForKey:[NSString stringWithFormat:@"%d",row]] objectForKey:@"service_character"];
                NSInteger service_character_id2_int = [service_character_id2 integerValue];
                
                
                NSDictionary * judgeIsEqualDic_One = serviceArrForJudge_dic;
                NSDictionary * judgeIsEqualDic_Two = [dic objectForKey:[NSString stringWithFormat:@"%d",row]];
                BOOL * judgeIsEqual = [GGUtil judgeTwoEpgDicIsEqual:judgeIsEqualDic_One TwoDic:judgeIsEqualDic_Two];
                
                NSString * service_service_name1 = [judgeIsEqualDic_One objectForKey:@"service_name"];
                NSString * service_service_name2 = [judgeIsEqualDic_Two objectForKey:@"service_name"];
                
                NSLog(@"*****机顶盒改变节目的加锁状态 name1 : %@",service_service_name1);
                NSLog(@"*****机顶盒改变节目的加锁状态 name2 : %@",service_service_name2);
                
                //            uint32_t character_And =  service_character_id1_int &  0x02;
                //            NSLog(@"character2 与运算 %d",character_And);
                
                //是当前正在播放的节目，所以说当前节目一定改变了，修改
                if (judgeIsEqual) {
                    
                   
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //关闭当前正在播放的节目
                        [self.videoController.player stop];
                        [self.videoController.player shutdown];
                        [self.videoController.player.view removeFromSuperview];
                    });
                    //修改字典信息
                    //历史记录信息和全部的信息
                    
                    NSLog(@"asfjalsbfabfba 1 %@",[dic objectForKey:[NSString stringWithFormat:@"%d",row]]);
                    
                    //赋予新值
                    NSMutableDictionary * tempDic_updateCharacter =[[dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]] mutableCopy];
                    NSString * newService_character =  [NSString stringWithFormat:@"%ld",(long)program_character_int];
                    
                    NSLog(@"asfjalsbfabfba 3 %@",newService_character);
                    
                    [tempDic_updateCharacter setObject:newService_character forKey:@"service_character"];
                    
                    NSLog(@"asfjalsbfabfba 4 %@",tempDic_updateCharacter);
                    NSMutableDictionary * mutableDicTemp = [dic mutableCopy];
                    [mutableDicTemp setObject:[tempDic_updateCharacter copy] forKey:[NSString stringWithFormat:@"%ld",(long)row]];
                    dic = [mutableDicTemp copy];
                    
                    self.dicTemp = [dic mutableCopy];   //修改self.dicTemp
                    
                    NSMutableArray * serviceData_DefaultTemp = [[USER_DEFAULT objectForKey:@"serviceData_Default"] mutableCopy];
                    
                    [serviceData_DefaultTemp replaceObjectAtIndex:i withObject:[dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]]];
                    [USER_DEFAULT setObject:[serviceData_DefaultTemp copy]  forKey :@"serviceData_Default"]; // 存到serviceData_Default 中
                    
                    /*
                     
                     storeLastChannelArr
                     1. 修改storeLastArr = self.dicTemp;
                     2.修改storeLastARR
                     
                     */
                    
                    storeLastChannelArr = [NSMutableArray arrayWithObjects:storeLastChannelArr[0],storeLastChannelArr[1],storeLastChannelArr[2],self.dicTemp,nil];
                    //修改 @"TVHttpAllData"   search界面的 self.response
                    [self setSearchViewData :[serviceData_DefaultTemp copy] ];
                    
                    
                    //重新执行播放,并且要注意判断是不是加锁类型
                    uint32_t character_And =  program_character_int &  0x02;
                    NSLog(@"ahsdahsfafvjahsvfjasvfa 1");
                    if (character_And > 0) {
                        NSLog(@"ahsdahsfafvjahsvfjasvfa 2");
                        // 此处代表需要记性机顶盒加密验证
                        NSNumber  *numIndex = [NSNumber numberWithInteger:row];
                        NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"LiveTouch",@"textThree",nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //创建通知
                            NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification1];
                            
                            firstOpenAPP = firstOpenAPP+1;
                            
                            firstfirst = NO;
                        });
                        
                    }else //从加锁到不加锁正常播放的步骤，但是要注意得如果用户此时还处于弹窗或者未输入密码界面，得去掉弹窗和输入密码
                    {
                        NSLog(@"ahsdahsfafvjahsvfjasvfa 3");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigDecoderPINShowNotific" object:nil userInfo:nil];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification1];
                            
                            NSLog(@"不一致，不弹窗。===或者将窗口取消掉33");
                            [STBAlert dismissWithClickedButtonIndex:1 animated:YES];
                            //======
                            [self firstOpenAppAutoPlay:row diction:dic];
                            firstOpenAPP = firstOpenAPP+1;
                            
                            firstfirst = NO;
                        });
                        
                        NSLog(@"self.video.dicChannl2 %@",self.video.dicChannl);
                        NSLog(@"self.video.channelCount2 %d",self.video.channelCount);
                        NSLog(@"self.video.dicChannl2222 %@",self.dicTemp);
                        NSLog(@"self.video.dicChannl2222222 %@",dic);
                    }
                    
                }else //不是当前正在播放的节目
                {
                    NSLog(@"*****机顶盒改变节目的加锁状态 ： 不是当前播放的节目");
                    //修改数据
                    //赋予新值
                    
                    //正在播放的第一个节目
//                    NSMutableDictionary * tempDic_updateCharacter =[[dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]] mutableCopy];
                    NSMutableDictionary * tempDic_updateCharacter =[[dic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]] mutableCopy];
                    NSLog(@"tempDic_updateCharacter %@",tempDic_updateCharacter);
                    //修改后的加锁状态值
                    NSString * newService_character =  [NSString stringWithFormat:@"%ld",(long)program_character_int];
                    NSLog(@"newService_character 3 %@",newService_character);
                    //修改了character的值
                    [tempDic_updateCharacter setObject:newService_character forKey:@"service_character"];
                    
                    NSLog(@"tempDic_updateCharacter 4 %@",tempDic_updateCharacter);
                    NSMutableDictionary * mutableDicTemp = [dic mutableCopy];
                    
                    NSLog(@"mutableDicTemp%@",mutableDicTemp);
//                    [mutableDicTemp setObject:[tempDic_updateCharacter copy] forKey:[NSString stringWithFormat:@"%ld",(long)row]];
                    
                    if (tempDic_updateCharacter == nil || tempDic_updateCharacter.count == 0) {
                        
                    }else
                    {
                        [mutableDicTemp setObject:[tempDic_updateCharacter copy] forKey:[NSString stringWithFormat:@"%ld",(long)i]];
                    }
                    
                    NSLog(@"mutableDicTemp11%@",mutableDicTemp);
                    dic = [mutableDicTemp copy];
                    
                    NSLog(@"asfjalsbfabfba 2 %@",[dic objectForKey:[NSString stringWithFormat:@"%d",row]]);
                    
                    self.dicTemp = [dic mutableCopy];
                    
                    [self notIsPlayingUpdateHistoryArr:network_id_int ts_int:ts_id_int service_int:service_id_int character_int:program_character_int dic_history3Dic:dic];  //修改一下，把历史的第一条数据删除
                    
                    NSMutableArray * serviceData_DefaultTemp = [[USER_DEFAULT objectForKey:@"serviceData_Default"] mutableCopy];
            
                    [serviceData_DefaultTemp replaceObjectAtIndex:i withObject:[dic objectForKey:[NSString stringWithFormat:@"%ld",(long)i]]];
                    [USER_DEFAULT setObject:[serviceData_DefaultTemp copy]  forKey :@"serviceData_Default"]; // 存到serviceData_Default 中
                  
                }
                
            }else
            {
            }
        }
    });
}
-(void)updateHistoryArr :(NSDictionary * )dic
{
 
    NSMutableArray * mutablearrHistoryNow = [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy]; //历史数据
    [mutablearrHistoryNow removeLastObject];
    [USER_DEFAULT setObject:[mutablearrHistoryNow copy] forKey:@"historySeed"];
    
    
    
}
-(void)notIsPlayingUpdateHistoryArr :(NSInteger) network_int   ts_int:(NSInteger) ts_int  service_int:(NSInteger)service_int  character_int :(NSInteger)character_int  dic_history3Dic :(NSDictionary*)dic_history3Dic
{
    NSMutableArray * mutablearrHistoryNow = [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy]; //历史数据
    
    for (int i = 0; i< mutablearrHistoryNow.count; i++) {
        NSDictionary * epgDicToSocket_temp = mutablearrHistoryNow[i][0];
        
        NSString * service_network_id1 = [epgDicToSocket_temp objectForKey:@"service_network_id"];
        NSInteger service_network_id1_int = [service_network_id1 integerValue];
        
        NSString * service_ts_id1 = [epgDicToSocket_temp objectForKey:@"service_ts_id"];
        NSInteger service_ts_id1_int = [service_ts_id1 integerValue];
        
        NSString * service_service_id1 = [epgDicToSocket_temp objectForKey:@"service_service_id"];
        NSInteger service_service_id1_int = [service_service_id1 integerValue];
        
        NSString * service_character_id1 = [epgDicToSocket_temp objectForKey:@"service_character"];
        NSInteger service_character_id1_int = [service_character_id1 integerValue];
        
        
        if (service_network_id1_int == network_int && service_ts_id1_int == ts_int && service_service_id1_int == service_int) {
            //相同，找到了历史中的位置，找到后替换数据
         
            NSString * seedNowTime_temp = mutablearrHistoryNow[i][1];
            NSNumber *aNumber_temp = mutablearrHistoryNow[i][2];
            NSLog(@"seedNowTime_temp %@",seedNowTime_temp);
            NSLog(@"aNumber_temp %@",aNumber_temp);
            
            NSMutableDictionary * mutableEpgDicToSocket_temp = [epgDicToSocket_temp mutableCopy]; //历史数组中的最后一个总数据，我们现在修改他
            [mutableEpgDicToSocket_temp setObject:service_character_id1 forKey:@"service_character"];
         
            NSArray * seedNowArr_temp = [NSArray arrayWithObjects:[mutableEpgDicToSocket_temp copy],seedNowTime_temp,aNumber_temp,dic_history3Dic,nil];
            
          
            [mutablearrHistoryNow replaceObjectAtIndex:i withObject:seedNowArr_temp];
            NSLog(@"mutablearrHistoryNow %@",mutablearrHistoryNow);

            NSArray *myArray_temp = [NSArray arrayWithArray:mutablearrHistoryNow];
            //                //获取播放的第一个节目信息
            //                if (myArray_temp.count <1) {   //第一次打开APP的时候，历史为空
            //                    storeLastChannelArr = nil;
            //                }else
            //                {
            //                    storeLastChannelArr = myArray_temp[myArray_temp.count - 1];
            //                }
            //
            NSLog(@"获取播放的第一个节目信息 成功");
            [USER_DEFAULT setObject:myArray_temp forKey:@"historySeed"];
    
            
        }else
        {
            //不是想要得到的数据
        }
        
        
    }
    
}
//修改 @"TVHttpAllData"   search界面的 self.response
-(void)setSearchViewData :(NSArray *)tempArr
{
    NSMutableDictionary * mutableDicForTVHttpAllData = [[USER_DEFAULT objectForKey:@"TVHttpAllData"] mutableCopy];
 
    [mutableDicForTVHttpAllData setObject:tempArr forKey:@"service"];
    
    [USER_DEFAULT setObject:[mutableDicForTVHttpAllData copy] forKey:@"TVHttpAllData"];
    
    searchViewCon.response = [USER_DEFAULT objectForKey:@"TVHttpAllData"];
    
    NSDictionary * aaa =[USER_DEFAULT objectForKey:@"TVHttpAllData"][@"service"][0];
 
    NSDictionary * bbb =[USER_DEFAULT objectForKey:@"serviceData_Default"][0];
 
    [searchViewCon.dataList removeAllObjects];
    [searchViewCon.showData removeAllObjects];
    searchViewCon.dataList =  [searchViewCon getServiceArray ];  //dataList 是所有的名字和符号的组合
    searchViewCon.showData = [NSMutableArray arrayWithArray:searchViewCon.dataList];
    [USER_DEFAULT setObject: searchViewCon.showData forKey:@"showData"];
}
//新增的修改search界面数据的方法，与上面一个方法重载，建议使用方法
-(void)setSearchViewData
{
    [searchViewCon.dataList removeAllObjects];
    [searchViewCon.showData removeAllObjects];
    searchViewCon.dataList =  [searchViewCon getServiceArray ];  //dataList 是所有的名字和符号的组合
    searchViewCon.showData = [NSMutableArray arrayWithArray:searchViewCon.dataList];
    [USER_DEFAULT setObject: searchViewCon.showData forKey:@"showData"];
}
//#pragma mark - 凡是播放事件，都会响应这个方法 , 每次播放前，都先把 @"deliveryPlayState" 状态重置，这个状态是用来判断视频断开分发后，除非用户点击
//-(void)beforeVideoPlayEvent
//{
////每次播放前，都先把 @"deliveryPlayState" 状态重置，这个状态是用来判断视频断开分发后，除非用户点击
//    [USER_DEFAULT setObject:@"beginDelivery" forKey:@"deliveryPlayState"];
//}
#pragma mark - 播放过程中，或者点击了加锁的按钮。此时停止掉显示不能播放文字,并且取消掉延迟方法
-(void)removeTipLabAndPerformSelector
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //弹窗之后，取消显示sorry不能播放的字样，并且取消不能播放的提示文字
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
        NSLog(@"取消25秒的等待6");
        NSLog(@"取消播放第一次");
        
        //创建通知  如果视频要播放呀，则去掉不能播放的字样
        NSNotification *notification1 =[NSNotification notificationWithName:@"noPlayShowShutNotic" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
    });
}
#pragma mark -- 判断是否需要延迟20秒执行播放状态判断，如果有CA或者加锁弹窗，则不进行判断
-(void)ifNeedPlayClick
{
    //    NSString * str = [USER_DEFAULT objectForKey:@"alertViewHasPop"];
    //    if ([str isEqualToString:@"no"]) {
    //        //如果视频20秒内不播放，则显示sorry的提示文字
    //        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
    //        [self performSelector:@selector(playClick) withObject:nil afterDelay:20];
    //    }else
    //    {
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
    //    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
        NSLog(@"取消25秒的等待7");
        NSLog(@"取消播放第二次");
        NSLog(@"取消播放第二次 %@",[NSThread currentThread]);
        if (self.showTVView == YES) {
            [self performSelector:@selector(playClick) withObject:nil afterDelay:25];
            NSLog(@"开始25秒的等待");
        }else
        {
            
            NSLog(@"进入了这个方法");
        }
        
    });
    
}
#pragma mark - 则去掉不能播放的字样，加上加载环
-(void)removeLabAndAddIndecatorView
{
    //=====则去掉不能播放的字样，加上加载环
    NSNotification *notification1 =[NSNotification notificationWithName:@"noPlayShowShutNotic" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    
    NSNotification *notification =[NSNotification notificationWithName:@"IndicatorViewShowNotic" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //=====则去掉不能播放的字样，加上加载环
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.Animating = NO;
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@" viewDidDisappear viewDidDisappear");
    [self removeONEMinuteTimer];
    self.video.playUrl = @"";
    
    [self.videoController.player stop];
    [self.videoController.player shutdown];
    [self.videoController.player.view removeFromSuperview];
    
    [super  viewDidDisappear:animated];
    self.Animating = NO;
}
#pragma mark - UIViewController对象的视图即将消失、被覆盖或是隐藏时调用
-(void)viewWillDisappear:(BOOL)animated
{
    self.showTVView = NO;
    [USER_DEFAULT setObject:@"NO" forKey:@"showTVView"];
    NSLog(@" viewWillDisappear viewWillDisappear");
    [self removeONEMinuteTimer];
    self.video.playUrl = @"";
    
    [self.videoController.player stop];
    [self.videoController.player shutdown];
    [self.videoController.player.view removeFromSuperview];
    NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigDecoderPINShowNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    
    NSNotification *notification2 =[NSNotification notificationWithName:@"removeConfigCAPINShowNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
    
    NSLog(@"asflna;nfanf;aonf;lkasfnas");
    //取消掉20秒后显示提示文字的方法，如果视频要播放呀，则去掉不能播放的字样
    [self removeTipLabAndPerformSelector];
    
}
-(void)removeONEMinuteTimer
{
    [ONEMinuteTimer invalidate];
    ONEMinuteTimer = nil;
    
    [viewFirstShowTimer invalidate];
    viewFirstShowTimer = nil;
}
-(void)refreshTableviewOneMinute
{
    ONEMinuteTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(tableViewDataRefreshForMjRefresh_ONEMinute) userInfo:nil repeats:YES];
}


#pragma mark - 进度条
//初始化进度条
-(void)initProgressLine
{
    //    self.videoController.videoPlayerWillChangeToOriginalScreenModeBlock = ^(){
    //        NSLog(@"切换为竖屏模式");
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
        [USER_DEFAULT setObject:@"YES" forKey:@"topProgressViewISNotExist"];
        
        self.progressViews = @[ self.topProgressView ];
        
        
    }else
    {
    }
    
    
}

//每隔一秒刷新一次进度条
- (void)updateProgress :(NSTimer *)Time
{
    NSInteger endTime =[[[Time userInfo] objectForKey:@"EndTime" ] intValue ];
    NSInteger startTime =[[[Time userInfo] objectForKey:@"StartTime" ] intValue ];
    int timeCut;
    NSString *  starttime;
    if(ISNULL([[Time userInfo] objectForKey:@"EndTime"]) || ISNULL([[Time userInfo]objectForKey:@"StarTime"]))
    {
        [self removeTopProgressView];  //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
    }
    else
    {
        timeCut= [[[Time userInfo] objectForKey:@"EndTime" ] intValue ] - [[[Time userInfo]objectForKey:@"StarTime"] intValue];
        starttime =[[Time userInfo]objectForKey:@"StarTime"];
        
        if(timeCut<=0 && starttime <0)
        {
           
            [self removeTopProgressView];  //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
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
#pragma mark --进度条刷新
-(void)progressRefresh
{
    NSLog(@" 进入了一次progressRefresh  replaceEventNameNotific ");
    progressEPGArrIndex = progressEPGArrIndex +1;   //准备开始播放下一个节目
    
    [self removeTopProgressView];  //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
    
    if(isEventStartTimeBiger_NowTime == YES){
        //加一个判断，防止EPG的第一个数据的开始时间大于当前时间
        //如果节目的开始时间比当前时间还大，那么则把索引减一
        progressEPGArrIndex = progressEPGArrIndex - 1;
    }else{
        
    }
    
    if (progressEPGArr.count - 1<progressEPGArrIndex) //如果索引过大，则停止
    {
        NSLog(@"abcd");
        //如果EPG的数组数少于索引数量，那么可能是超过一天的播放时长了，这里可以重新加载一次获取数据
#pragma mark 如果大于24小时，可以做一次刷新
    }
    else{
        NSLog(@"progressEPGArrIndex %ld",progressEPGArrIndex);
        NSInteger abcd = progressEPGArr.count -1;
        if(progressEPGArrIndex <= abcd && progressEPGArrIndex > 0){    //如果索引正常
      
            if(![[progressEPGArr[progressEPGArrIndex]objectForKey:@"event_starttime"] isEqualToString:@""])
                
            {
                NSInteger tempIndex =progressEPGArrIndex;
                NSString * tempIndexStr = [NSString stringWithFormat:@"%ld",(long)tempIndex];
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
                [[NSNotificationCenter defaultCenter] postNotification:replaceEventNameNotific];
          
                self.event_startTime = [progressEPGArr[progressEPGArrIndex] objectForKey:@"event_starttime"];
                self.event_endTime = [progressEPGArr[progressEPGArrIndex] objectForKey:@"event_endtime"];
                //把节目时间通过通知发送出去
                
                //** 计算进度条
                if(self.event_startTime.length != 0 || self.event_endTime.length != 0)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view addSubview:self.topProgressView];
                        [self.view bringSubviewToFront:self.topProgressView];
                        [USER_DEFAULT setObject:@"YES" forKey:@"topProgressViewISNotExist"];
                    });
                    
                    
                    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
                    NSLog(@"progressRefreshself.event_startTime--==%@",self.event_startTime);
                    NSLog(@"progressRefreshself.event_startTime--==%@",self.event_endTime);
                    if (ISNULL(self.event_startTime) || self.event_startTime == NULL || self.event_startTime == nil || ISNULL(self.event_endTime) || self.event_endTime == NULL || self.event_endTime == nil || self.event_startTime.length == 0 || self.event_endTime.length == 0) {

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
                    
                }else{
                    [self removeTopProgressView];  //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
                }
            }
            else
            {
                [self removeTopProgressView];  //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
                return;
            }
        }else
        {
        
            [self removeTopProgressView];  //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
            return;
   
        }
    }
}
#pragma mark -//进度条的时间不对，发送消除的通知
-(void)removeLineProgressNotific
{
    //    此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeProgressNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeProgressNotific) name:@"removeProgressNotific" object:nil];
    
}
//进度条的时间不对，发送消除的通知
-(void)removeProgressNotific
{
    
    if (self.event_endTime == NULL ) {
        [self removeTopProgressView];  //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
        
    }else
    {
        //假如说开始时间不知道，只知道一个结束时间，那么我们能够通过结束时间来计算刷新的时间点
        //此处应该加一个方法，判断 endtime - starttime 之后，让进度条刷新从新计算
        NSInteger endTime =[self.event_endTime intValue ];
        NSString *nowDate = [GGUtil GetNowTimeString];
        NSInteger endTimeCutStartTime =endTime-[nowDate integerValue];
  
        if (endTimeCutStartTime < 0) {
            
        }else
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressRefresh) object:nil];
            [self performSelector:@selector(progressRefresh) withObject:nil afterDelay:endTimeCutStartTime];  //记录一个结束时间，到达这个时间点后需要刷新进度条
        }
        
    }
 
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
//删除节目进度条并且停止计时器
-(void)removeTopProgressView
{
    [USER_DEFAULT setObject:@"NO" forKey:@"topProgressViewISNotExist"];
    [self.topProgressView removeFromSuperview];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark -////重新开始进度条和计时器的通知
-(void)restartLineProgressNotific
{
    //    此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"restartTopProgressView" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartTopProgressView :) name:@"restartTopProgressView" object:nil];
    
}
//重新开始进度条和计时器
-(void)restartTopProgressView :(NSNotification *)text
{
    
    [self.view bringSubviewToFront:self.topProgressView];
    [self.videoController.view bringSubviewToFront:self.topProgressView];
    [USER_DEFAULT setObject:@"YES" forKey:@"topProgressViewISNotExist"];
    //    [self.topProgressView removeFromSuperview];
    
    NSDictionary * dict = text.userInfo[@"restartTopProgressViewDic"];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress:) userInfo:dict repeats:YES];
}
#pragma  mark - 在列表刷新后，同一一个时间点做一次刷新，将有关节目的数据做一次统一刷新
//-(void)refreshAllAboutChannelData
//{
//
////    //当前正在播放的节目的EPG信息
////    [USER_DEFAULT setObject:epgDicToSocket forKey:@"NowChannelDic"];
//
//    //在此处刷新历史记录的信息
//    //①主页的记录   ②搜索界面的记录  ③ 全屏页面的记录   ④ 历史界面的记录
//    //⑤搜索页面的历史记录
//
//
//    [USER_DEFAULT setObject:epgDicToSocket forKey:@"NowChannelDic"];
//
//
//
//}

-(void)updateFullScreenDic
{
    //对于其他页面的dic重新赋值
    self.TVChannlDic = self.dicTemp;
    
    tempDicForServiceArr = self.TVChannlDic;
    
    self.video.dicChannl = [tempDicForServiceArr mutableCopy];
    
    
    self.video.channelCount = tempArrForServiceArr.count;
 
}
#pragma mark - 下拉刷新做12秒超时处理
-(void)endMJRefresh
{
    
    [self.tableForSliderView.mj_header endRefreshing];
    
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endMJRefresh) object:nil];
    //    [self performSelector:@selector(endMJRefresh) withObject:nil afterDelay:EndMJRefreshTime];
}
#pragma mark - 如果这个时候展示的不是TV页面，则不进行播放的各个事件通知
//如果这个时候展示的不是TV页面，则不进行播放的各个事件通知
-(void)ifNotISTVView
{
    NSLog(@"已经不是TV页面了");
    //停止加载
    NSLog(@"① 去掉不能播放给的字样  ② 去掉加载    ③只用展示黑屏");
    //① 去掉不能播放给的字样
    NSNotification *notification1 =[NSNotification notificationWithName:@"noPlayShowShutNotic" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    //② 去掉20s 播放
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
    NSLog(@"取消25秒的等待8");
    
    //③创建通知,删除进度条
    NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    //④ 删除音频图片
    NSNotification *notification2 =[NSNotification notificationWithName:@"removeConfigRadioShowNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
    
    //⑤取消掉加载环
    NSNotification *notification3 =[NSNotification notificationWithName:@"IndicatorViewHiddenNotic" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification3];
    
    //⑥停止播放的动作,并且取消掉图画
    [self stopVideoPlay];
}
-(BOOL)judgeServiceDataIsnull
{
    if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
        return YES;
    }else
    {
        return NO;
    }
}
//#pragma mark -
-(NSMutableArray *)titleArrReplace:(NSMutableArray*)titles
{
    NSMutableArray * tempTitlesArr = [[NSMutableArray alloc]init];
    /*
     1.先判断是那种类型，录制和直播节目是否同时存在
     2.根部不同的类别进行数据组合和最后的赋值
     **/
    //#define   RecAndLiveNotHave  @"0"      //录制和直播都不存在
    //#define   RecExit            @"1"      //录制存在直播不存在
    //#define   LiveExit           @"2"      //录制不存在直播存在
    //#define   RecAndLiveAllHave  @"3"      //录制直播都存在
    NSString * RECAndLiveType = [USER_DEFAULT objectForKey:@"RECAndLiveType"];
    NSLog(@"RECAndLiveType %@",RECAndLiveType);

    if ([RECAndLiveType isEqualToString:@"RecAndLiveNotHave"]) {  //都不存在

    }else if ([RECAndLiveType isEqualToString:@"RecExit"]){ //录制存在直播不存在

    }else if ([RECAndLiveType isEqualToString:@"LiveExit"]){ //录制不存在直播存在

        tempTitlesArr =titles[0];


    }else if([RECAndLiveType isEqualToString:@"RecAndLiveAllHave"]){//都存在
        if (titles.count == 2 ) {   //正常情况
            tempTitlesArr =[titles[0] mutableCopy];

            [tempTitlesArr insertObject:@"Recordings" atIndex:1];
        }else if(titles.count == 1 )  //异常刷新，数组中只有一个元素
        {
            tempTitlesArr =titles[0];
            for (int i = 0 ; i < tempTitlesArr.count; i++) {

            }
        }

    }


    return tempTitlesArr;
}
#pragma mark - VideoTouchNoificClick 的内部方法
-(void)setCategoryItem:(int)inputCategoryDic
{
    
    NSArray * RECArrForJudgeCategory = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
    if (RECArrForJudgeCategory.count > 0 && RECArrForJudgeCategory != nil) {
//        for (int i = 0; i<RECArrForJudgeCategory.count; i++) {
//
//            serviceArrForJudge_dic = RECArrForJudgeCategory[i];
//
//            if ([GGUtil judgeTwoEpgDicIsEqual:serviceArrForJudge_dic TwoDic:NowServiceDic]) {
//
//            }
//        }
        if (inputCategoryDic == 1) { //录制
 
            for (int i = 0; i< self.CategoryAndREC.count; i++) {
                NSArray *abc=self.CategoryAndREC;
                [self.dicTemp setObject:self.CategoryAndREC[1][i] forKey:[NSString stringWithFormat:@"%d",i] ];
            }
 
        }else  //点击了非录制节目
        {
            if (inputCategoryDic <= self.categorys.count -1) {

                NSDictionary * item = self.CategoryAndREC[0][inputCategoryDic];

                self.categoryModel = [[CategoryModel alloc]init];

                self.categoryModel.service_indexArr = item[@"service_index"];

                [self.dicTemp removeAllObjects];

                //获取不同类别下的节目，然后是节目下不同的cell值                10
                for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {

                    int indexCat ;
                    indexCat =[self.categoryModel.service_indexArr[i] intValue];
                   
                    if ( ISNULL(self.serviceData)) {

                    }else{

                        [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起

                    }

                }

            }
        }
    }
    else
    {
        if (inputCategoryDic <= self.categorys.count -1) {
            
            NSDictionary * item = self.categorys[inputCategoryDic];
            
            self.categoryModel = [[CategoryModel alloc]init];
            
            self.categoryModel.service_indexArr = item[@"service_index"];
            
            [self.dicTemp removeAllObjects];
            
            //获取不同类别下的节目，然后是节目下不同的cell值                10
            for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {
                
                int indexCat ;
                indexCat =[self.categoryModel.service_indexArr[i] intValue];
        
                if ( ISNULL(self.serviceData)) {
                    
                }else{
                 
                    [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
                    
                }
                
            }
            
        }
       
    }
  
    
}
@end
