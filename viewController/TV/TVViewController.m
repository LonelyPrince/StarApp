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
#import "JXCustomAlertView.h"
#import "GetPushInfoAlertView.h"
#import "MDPhonePushService.h"
#import "FilePushService.h"
#import "OtherDevicePushService.h"
#import "OtherDevicePushLive.h"
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
    UIScrollView *scrollView; //用于存放并显示引导页
    UIImageView *imageViewOne;
    UIImageView *imageViewTwo;
    UIImageView *imageViewThree;
    UIImageView *imageViewFour;
    
    BOOL playState;
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
    NSArray * getLastCategoryArr;
    NSArray * getLastRecFileArr;
    BOOL channelListMustRefresh;
    NSMutableArray * pushDataMutilArr;
    NSMutableArray * phonePushOtherArr;
    NSMutableArray * pushBtnSelectArr;
    pushViewCell * tempPushViewCell;
    UILabel * pushSecNumLab ;
    UIView * blueCircleView ;
    int timeNum ;
    GetPushInfoAlertView * JXAlertView;
    NSString * channnelNameString;
    int pushChannelId;
    NSMutableDictionary * allChannelsDic ;
    //    int pushAlertViewIndex; //推屏倒计时弹窗的位置
    int card_ret;
    int playVideoType;   //值 = 1，则代表直播；值 = 2，则代表录制   等于0则不处理
    BOOL judgeRecIsCA;
    int judgeIsNeedShowDeliveryStop;
    int SDTMonitor_addHistory ;

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
//@property (strong,nonatomic)NSMutableDictionary * dicTemp;

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
@property (nonatomic, strong) NSTimer *pushTVTimer;   //进度条的计时器
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
@synthesize pushTVTimer;
@synthesize nowPlayChannelInfo;
@synthesize pushTableView;
@synthesize pushViewCell;
@synthesize shareViewArr;
//@synthesize videoPlay;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    firstfirst = YES;
    tableviewinit = 1;
    firstOpenAPP = 0;
    IPString = @"";
    playState = NO;
    channelListMustRefresh = NO;
    
    //每次播放前，都先把 @"deliveryPlayState" 状态重置，这个状态是用来判断视频断开分发后，除非用户点击
    [USER_DEFAULT setObject:@"beginDelivery" forKey:@"deliveryPlayState"];
    
    [self initData];    //table表
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    //打开时开始连接socket并且发送心跳
    self.socketView = [[SocketView  alloc]init];
    //    [self.socketView viewDidLoad];
    //    firstShow =NO;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstStartTransform"];
    
    activeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                         SCREEN_WIDTH,
                                                         SCREEN_HEIGHT)];
    [self.view addSubview:activeView];    //等待loading的view
    HUD = [[MBProgressHUD alloc] initWithView:self.activeView];
    
    //    UIView * hudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    hudImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 616/2)/2, 120, 616/2, 348/2)];
    hudImage.image = [UIImage imageNamed:@"网络无连接"];
    //调用上面的方法，获取 字体的 Size
    
    NSString * MLNetworkError = NSLocalizedString(@"MLNetworkError", nil);
    CGSize size = [self sizeWithText: MLNetworkError font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
    hudLab.text = MLNetworkError;
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
    if ([self.categoryModel.service_indexArr isKindOfClass:[NSMutableArray class]]){
        if ([self.categoryModel.service_indexArr count]==0) {//无数据
            
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
    SDTMonitor_addHistory = 0;
    judgeIsNeedShowDeliveryStop = 0;
    //    pushAlertViewIndex = 0;
    shareViewArr = [[NSMutableArray alloc]init];
    blueCircleView = [[UIView alloc]init];
    pushSecNumLab = [[UILabel alloc]init];
    pushBtnSelectArr = [[NSMutableArray alloc]init];
    pushTableView = [[UITableView alloc]init];
    nowPlayChannelInfo = [[NowPlayChannelInfo alloc]init];
    nowPlayChannelInfo.numberOfCategoryInt = 0;
    nowPlayChannelInfo.numberOfRowInt = 0;
    NSString * CancelLabel = NSLocalizedString(@"CancelLabel", nil);
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
    
    NSString * STBTitle = NSLocalizedString(@"DecoderPIN", nil);
    NSString * ConfirmLabel = NSLocalizedString(@"ConfirmLabel", nil);
    STBAlert = [[UICustomAlertView alloc] initWithTitle:STBTitle message:@"" delegate:self cancelButtonTitle:ConfirmLabel otherButtonTitles:CancelLabel,nil]
    ;
    STBAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    
    NSString * CAAlertTitle = NSLocalizedString(@"CAPIN", nil);
    CAAlert = [[UICustomAlertView alloc] initWithTitle:CAAlertTitle message:@"" delegate:self cancelButtonTitle:ConfirmLabel otherButtonTitles:CancelLabel,nil];
    CAAlert.alertViewStyle = UIAlertViewStyleSecureTextInput; //UIAlertViewStylePlainTextInput;
    
    channelStartimesList = [[NSMutableSet alloc]init];
    storeLastChannelArr = [[NSMutableArray alloc]init];
    
    CAAlert.dontDisppear = YES;
    STBAlert.dontDisppear = YES;
    
    self.CategoryAndREC = [[NSMutableArray alloc]init];
    self.RECAndLiveCellForRowsDic = [[NSMutableArray alloc]init];
    pushDataMutilArr = [[NSMutableArray alloc]init];
    phonePushOtherArr = [[NSMutableArray alloc]init];
    judgeRecIsCA = NO;
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

    getLastCategoryArr = self.categorys; //[USER_DEFAULT objectForKey:@"serviceData_Default"];
    getLastRecFileArr  = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
    WEAKGET
    [request setCompletionBlock:^{


        NSDictionary *response = httpRequest.responseString.JSONValue;



        NSArray *data1 = response[@"service"];

        //录制节目,保存数据
        NSArray *recFileData = response[@"rec_file_info"];
        [USER_DEFAULT setObject:recFileData forKey:@"categorysToCategoryViewContainREC"];


        if ( data1.count == 0 && recFileData.count == 0){

            firstfirst = NO;

            NSArray *data1 = response[@"service"];

            //录制节目,保存数据
            NSArray *recFileData = response[@"rec_file_info"];
            [USER_DEFAULT setObject:recFileData forKey:@"categorysToCategoryViewContainREC"];

            self.serviceData = (NSMutableArray *)data1; //data1 代表service
            [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];


            BOOL serviceDatabool = [self judgeServiceDataIsnull];

            if (YES && recFileData.count == 0) {
                //            [self getServiceData]; //如果 self.serviceData 数据为空，则重新获取数据
                if (response[@"data_valid_flag"] != NULL && ![response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                    //机顶盒连接成功了，但是没有数据
                    //显示列表为空的数据
                    if (_slideView) {
                        [_slideView removeFromSuperview];
                        _slideView = nil;

                    }

                    if (!self.NoDataImageview) {
                        self.NoDataImageview = [[UIImageView alloc]init];
                    }
                    if (!self.NoDataLabel) {
                        self.NoDataLabel = [[UILabel alloc]init];
                    }
                    [self NOChannelDataShow];
                    isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
                    [self removeTipLabAndPerformSelector];   //取消不能播放的文字
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                    [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
                }else
                {
                    //机顶盒连接成功了，但是没有数据
                    //显示列表为空的数据
                    if (_slideView) {
                        [_slideView removeFromSuperview];
                        _slideView = nil;

                    }

                    if (!self.NoDataImageview) {
                        self.NoDataImageview = [[UIImageView alloc]init];
                    }
                    if (!self.NoDataLabel) {
                        self.NoDataLabel = [[UILabel alloc]init];
                    }
                    [self NOChannelDataShow];
                    isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
                    [self removeTipLabAndPerformSelector];   //取消不能播放的文字
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                    [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
                }

            }
            [self activeViewRemove];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notHaveNetWork) object:nil];
            [self playVideo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.socketView viewDidLoad];
            });

            NSArray *data = response[@"category"];
            self.categorys = (NSMutableArray *)data;
            [self setCategoryAndREC:data RECFile:recFileData];

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
                    [GGUtil postfullScreenBtnShow];
                }else //横屏状态，不刷新
                {
                    //设置滑动条
                    _slideView = [YLSlideView alloc];
                    _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                                                      SCREEN_WIDTH,
                                                                      SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.CategoryAndREC];

                    [self.tableForDicIndexDic removeAllObjects];
                    [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
                    [GGUtil postfullScreenBtnShow];
                }


                NSArray *ArrayTocategory = [NSArray arrayWithArray:self.CategoryAndREC];
                [USER_DEFAULT setObject:ArrayTocategory forKey:@"categorysToCategoryView"];


                _slideView.backgroundColor = [UIColor whiteColor];
                _slideView.delegate        = self;

                [self.view addSubview:_slideView];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];

            }

            [USER_DEFAULT  setObject:@"YES" forKey:@"viewHasAddOver"];  //第一次进入时，显示页面加载完成


            if (data1.count == 0 && recFileData.count == 0)
            {
                //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空

                if (response[@"data_valid_flag"] != NULL && ![response[@"data_valid_flag"] isEqualToString:@"0"] ) {

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

                [USER_DEFAULT setObject:@"stopDelivery" forKey:@"deliveryPlayState"];



                [self NOChannelDataShow];
                [self removeTopProgressView]; //删除进度条
                isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
                [self removeTipLabAndPerformSelector];   //取消不能播放的文字
                [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];


                double delayInSeconds = 0.8;
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, mainQueue, ^{
                    [self ifNotISTVView];
                    [GGUtil postcantDeliveryNotific];
                    NSNotification *notification1 =[NSNotification notificationWithName:@"fullScreenBtnHidden" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];


                });



            }
        }
        else{
            [GGUtil postfullScreenBtnShow];
            //将数据本地化
            [USER_DEFAULT setObject:response forKey:@"TVHttpAllData"];

            self.serviceData = (NSMutableArray *)data1; //data1 代表service
            [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];


            BOOL serviceDatabool = [self judgeServiceDataIsnull];
            if (serviceDatabool && recFileData.count == 0) {
                //            [self getServiceData]; //如果 self.serviceData 数据为空，则重新获取数据
                if (response[@"data_valid_flag"] != NULL && ![response[@"data_valid_flag"] isEqualToString:@"0"] ) {

                    //机顶盒连接成功了，但是没有数据
                    //显示列表为空的数据
                    if (_slideView) {
                        [_slideView removeFromSuperview];
                        _slideView = nil;

                    }

                    if (!self.NoDataImageview) {
                        self.NoDataImageview = [[UIImageView alloc]init];
                    }
                    if (!self.NoDataLabel) {
                        self.NoDataLabel = [[UILabel alloc]init];
                    }
                    [self NOChannelDataShow];
                    isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
                    [self removeTipLabAndPerformSelector];   //取消不能播放的文字
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                    [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
                }else
                {

                    //机顶盒连接成功了，但是没有数据
                    //显示列表为空的数据
                    if (_slideView) {
                        [_slideView removeFromSuperview];
                        _slideView = nil;

                    }

                    if (!self.NoDataImageview) {
                        self.NoDataImageview = [[UIImageView alloc]init];
                    }
                    if (!self.NoDataLabel) {
                        self.NoDataLabel = [[UILabel alloc]init];
                    }
                    [self NOChannelDataShow];
                    isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
                    [self removeTipLabAndPerformSelector];   //取消不能播放的文字
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
                    [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
                }

            }
            [self activeViewRemove];

            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notHaveNetWork) object:nil];
            [self playVideo];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.socketView viewDidLoad];
            });
            //////
            //获取数据的链接
            NSString *urlCate = [NSString stringWithFormat:@"%@",S_category];


            LBGetHttpRequest *request = CreateGetHTTP(urlCate);



            [request startAsynchronous];

            WEAKGET
            [request setCompletionBlock:^{
                NSDictionary *response = httpRequest.responseString.JSONValue;

                NSArray *data = response[@"category"];

                [self setCategoryAndREC:data RECFile:recFileData];


                if (data1.count == 0 && recFileData.count == 0)
                {
                    //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空

                    if (response[@"data_valid_flag"] != NULL && ![response[@"data_valid_flag"] isEqualToString:@"0"] ) {

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

                    [self NOChannelDataShow];
                    [self removeTopProgressView]; //删除进度条
                    isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
                    [self removeTipLabAndPerformSelector];   //取消不能播放的文字
                    [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
                }else
                {
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
                            [GGUtil postfullScreenBtnShow];
                        }else //横屏状态，不刷新
                        {

                            //设置滑动条
                            _slideView = [YLSlideView alloc];
                            _slideView = [_slideView initWithFrame:CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                                                              SCREEN_WIDTH,
                                                                              SCREEN_HEIGHT-64.5-1.5-   kZXVideoPlayerOriginalHeight-49.5)  forTitles:self.CategoryAndREC];

                            [self.tableForDicIndexDic removeAllObjects];
                            [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
                            [GGUtil postfullScreenBtnShow];
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
                    //            [self.socketView viewDidLoad];
                    if (firstfirst == YES) {

                        //=======机顶盒加密
                        NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:0 serviceListDic:self.dicTemp];
                        if (characterStr != NULL && characterStr != nil) {
                            BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                            if (judgeIsSTBDecrypt == YES) {
                                // 此处代表需要记性机顶盒加密验证
                                NSNumber  *numIndex = [NSNumber numberWithInteger:0];
                                NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"firstOpenTouch",@"textThree",nil];

                                NSMutableDictionary * epgDicToSocket = [[self.dicTemp objectForKey:[NSString stringWithFormat:@"0"]] mutableCopy];
                                NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
                                [GGUtil postsetChannelNameAndEventNameNotic:nowPlayingDic];


                                [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                                firstOpenAPP = firstOpenAPP+1;

                                firstfirst = NO;

                            }else //正常播放的步骤
                            {
                                [self firstOpenAppAutoPlayZero:0 diction:self.dicTemp];
                            }
                        }else //正常播放的步骤
                        {
                            [self firstOpenAppAutoPlayZero:0 diction:self.dicTemp];
                        }
                    }else
                    {}

                    [USER_DEFAULT  setObject:@"YES" forKey:@"viewHasAddOver"];  //第一次进入时，显示页面加载完成
                }
            }];

            if (data1.count == 0 && recFileData.count == 0)
            {
            }else{
                [self initProgressLine];
                [self.table reloadData];
            }
        }



    }];

}
-(void)loadNav
{
    //顶部搜索条
    self.navigationController.navigationBarHidden = YES;
    
    deviceString = [GGUtil deviceVersion];
    
    
    //搜索按钮
    //    self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight);
    //    [searchBtn setTitle:@"search" forState:UIControlStateNormal];
    [self.searchBtn setBackgroundColor:[UIColor whiteColor]];
    //    [searchBtn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
    
    NSString * MLRecording = NSLocalizedString(@"MLRecording", nil);
    
    if (MLRecording.length > 10) {
        [self.searchBtn setBackgroundImage:[UIImage imageNamed:@"Input"] forState:UIControlStateNormal]  ;
    }else
    {
        [self.searchBtn setBackgroundImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal]  ;
    }
    
    [self.searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];//mediaDeliveryUpdate //searchBtnClick //judgeJumpFromOtherView //tableViewCellToBlue //refreshTableviewByEPGTime
    
    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]  ) {
        NSLog(@"此刻是5s和4s 的大小");
        self.searchBtn.frame = CGRectMake(searchBtnX-2, searchBtnY, searchBtnWidth *0.8533, searchBtnHeight *0.8533 );
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"] || [deviceString isEqualToString:@"iPhone8"] || [deviceString isEqualToString:@"iPhoneX"] || [deviceString isEqualToString:@"iPhone Simulator"] ) {
        NSLog(@"此刻是6的大小");
        self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight);
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] || [deviceString isEqualToString:@"iPhone8 Plus"]) {
        NSLog(@"此刻是6 plus的大小");
        
        self.searchBtn.frame = CGRectMake(searchBtnX+1, searchBtnY, searchBtnWidth *1.104, searchBtnHeight *1.104 );
    }
    
    
    //视频播放
    //----直播源
    self.video = [[ZXVideo alloc] init];
    self.video.channelId = self.service_videoindex;
    self.video.channelName = self.service_videoname;
    self.video.playEventName = self.event_videoname;
    
}
-(void)refreshTableviewByEPGTime //由于EPG时间要发生变化，所以此处要刷新他
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger beforeRefreshIndex = self.category_index; //由于刷新后，列表的index会迅速变换为0，所以这里要做一个等级
        //        [self refreshSliderAndTableview];
        [self.table reloadData];
        [tempTableviewForFocus reloadData];
        NSNumber * currentIndex = [NSNumber numberWithInteger:beforeRefreshIndex];
        NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndex,@"currentIndex", nil];
        //创建通知，防止刷新后跳转错页面
        NSNotification *notification =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    });
    
    
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
        //**用于刷新列表的timer 设置，防止在没网的情况下，过长时间停留在无网络图下，又可能出现异常
        NSString * nowTimeStr = [GGUtil GetNowTimeString];
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
            
            statusNum = 2;
            [self prefersStatusBarHidden];
            [self setNeedsStatusBarAppearanceUpdate];
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]  ) {
                NSLog(@"此刻是5s和4s 的大小");
                
                self.searchBtn.frame = CGRectMake(searchBtnX-2, searchBtnY, searchBtnWidth *0.8533, searchBtnHeight *0.8533 );
                
            }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"] || [deviceString isEqualToString:@"iPhone8"] || [deviceString isEqualToString:@"iPhoneX"] || [deviceString isEqualToString:@"iPhone Simulator"] ) {
                NSLog(@"此刻是6的大小");
                self.searchBtn.frame = CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight);
                
            }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] || [deviceString isEqualToString:@"iPhone8 Plus"]) {
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
                //                //new====
                NSLog(@"切换为全屏模式");
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
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                UIViewController * viewNow = [self currentViewController];
                if ([viewNow isKindOfClass:[TVViewController class]]) {
                    self.tabBarController.tabBar.hidden = YES;
                }
                _slideView.frame = CGRectMake(0, 64.5+kZXVideoPlayerOriginalHeight+1.5+1000,
                                              SCREEN_WIDTH,
                                              SCREEN_HEIGHT-64.5-1.5-kZXVideoPlayerOriginalHeight-49.5);
                
                NSLog(@"目前是全屏");
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fixprogressView" object:nil ];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fixprogressView:) name:@"fixprogressView" object:nil];
                
                self.topProgressView.frame = CGRectMake(0, SCREEN_WIDTH -50 , SCREEN_HEIGHT, 2);
                [self.view bringSubviewToFront:self.topProgressView];
                [self.videoController.view bringSubviewToFront:self.topProgressView];
                [USER_DEFAULT setObject:@"YES" forKey:@"topProgressViewISNotExist"];
                
                [self judgeProgressIsNeedHide:YES]; //判断进度条需不需要隐藏，第一个参数表示是否全屏
                _lineView.frame = CGRectMake(0, -64, 0, 0);
            }else
            {
            }
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
    /**/
    if(![self.navigationController.topViewController isKindOfClass:[searchViewCon class]]) {
        [self.navigationController pushViewController:searchViewCon animated:YES];
    }else
    {
        NSLog(@"此处可能会由于页面跳转过快报错");
    }
    searchViewCon.tabBarController.tabBar.hidden = YES;

    //     [tempTableviewForFocus reloadData];
    //    [self refreshTableviewByEPGTime];
    //    [self.table reloadData];
    //    [self tableViewDataRefreshForMjRefresh_ONEMinute];
    //    NSLog(@"search  sousuosoususousouosuosususuos");

    //    [self refreshSliderAndTableViewNoVisible];    //增加刷新做测试
}
////用于刷新页面和slderView
//-(void)refreshSliderAndTableview
//{
////    [self.tableForSliderView reloadData];
////    [self.table reloadData];
////    [_slideView reloadData];
//    [tempTableviewForFocus reloadData];
//
//}
//-(void)refreshSliderAndTableViewNoVisible
//{
//    [self.tableForSliderView reloadData];
//    [self.table reloadData];
//    [_slideView  reloadDataNoVisibleZero];// reloadDataNoVisibleZero];
//}
//************************************************
//table可以滑动的次数
- (NSInteger)columnNumber{
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
    if ([RECAndLiveType isEqualToString:@"RecAndLiveNotHave"]) {  //都不存在
        
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
    int categorysNum =  self.categorys.count;
    
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
    nowPlayChannelInfo.numberOfCategoryInt = index;
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
                
                
                
                //如果发现第二列，则展示REC这个数组
                NSArray * RECTempArr = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
                self.categoryModel = [[CategoryModel alloc]init];
                self.categoryModel.service_indexArr = RECTempArr;
                tempArrForServiceArr =  RECTempArr;
                numberOfRowsForTable = RECTempArr.count;
                
                /*
                 用于分别获取REC Json数据中的值
                 **/
                
                [self.dicTemp removeAllObjects];
                
                for (int i = 0; i< RECTempArr.count ; i++) {
                    [self.dicTemp setObject:RECTempArr[i] forKey:[NSString stringWithFormat:@"%d",i] ];
                }
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
                [USER_DEFAULT setObject:self.dicTemp forKey:@"selfDicTemp"];
            }else if (playTypeClass == 3){
                
                if (index == 0) {
                    
                    if (self.categorys.count > index) {
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
                        [USER_DEFAULT setObject:self.dicTemp forKey:@"selfDicTemp"];
                        numberOfRowsForTable = self.categoryModel.service_indexArr.count;
                    }
                    
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
    
    if ([tableView isEqual:pushTableView]) {
        return phonePushOtherArr.count ;
    }else
    {
        int playTypeClass;
        playTypeClass = [GGUtil judgePlayTypeClass];
        if (playTypeClass == 0) {
            return 0;
        }else if (playTypeClass == 1){
            //algorithm /swift / datastruct / OC
            //jiagou /
            return numberOfRowsForTable;
        }else if (playTypeClass == 2){
            nwoTimeBreakStr = [GGUtil GetNowTimeString];  //获得时间戳，用于对tableView表的数据进行定位
            self.kvo_NoDataPic.numberOfTable_NoData = [NSString stringWithFormat:@"%lu",(unsigned long)self.categoryModel.service_indexArr.count];
            
            return self.categoryModel.service_indexArr.count;
        }else if (playTypeClass == 3){
            
            nwoTimeBreakStr = [GGUtil GetNowTimeString];  //获得时间戳，用于对tableView表的数据进行定位
            self.kvo_NoDataPic.numberOfTable_NoData = [NSString stringWithFormat:@"%lu",(unsigned long)numberOfRowsForTable];
            
            return numberOfRowsForTable;
        }
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:pushTableView] ) {
        return 50;
    }else
    {
        return [TVCell defaultCellHeight];
    }
    
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:pushTableView]) {
        pushViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[pushViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.pushTypeImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 25, 25)];
        
        if ([pushDataMutilArr[indexPath.row][3] isEqualToString:@"HMC"]) {
            cell.pushTypeImage.image = [UIImage imageNamed:@"pushSTB"];
        }else if ([pushDataMutilArr[indexPath.row][3] isEqualToString:@"mini"])
        {
            cell.pushTypeImage.image = [UIImage imageNamed:@"pushMini"];
        }else
        {
            cell.pushTypeImage.image = [UIImage imageNamed:@"pushPhone"];
        }
        [cell addSubview:cell.pushTypeImage];
        
        cell.pushDeviceLab = [[UILabel alloc]initWithFrame:CGRectMake(55, 21, 200, 10)];
        cell.pushDeviceLab.text = phonePushOtherArr[indexPath.row][2];
        cell.pushDeviceLab.font = FONT(13);
        [cell addSubview:cell.pushDeviceLab];
        cell.pushBtnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(250, 15, 20, 20)];
        [cell addSubview:cell.pushBtnImageView];
        cell.pushBtnImageView.image = [UIImage imageNamed:@"NoSelect"];
        
        
        //        indexPath.row == _selectCellIndex ? (cell.accessoryType =UITableViewCellAccessoryCheckmark) : (cell.accessoryType = UITableViewCellAccessoryNone);
        
        indexPath.row ==  (cell.accessoryType = UITableViewCellAccessoryNone);
        return cell;
    }else
    {
        static NSString *TableSampleIdentifier = @"TVCell";
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tempTableviewForFocus = tableView;
        TVCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
        if (cell == nil){
            cell = [TVCell loadFromNib];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        if (!ISEMPTY(self.dicTemp)) {
            cell.nowTimeStr = nwoTimeBreakStr;  //这里的nwoTimeBreakStr 是在numbeOfrows获取的当前时间
            cell.dataDic = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            //焦点
            NSDictionary * fourceDic = [USER_DEFAULT objectForKey:@"NowChannelDic"];
            if ([GGUtil judgeTwoEpgDicIsEqual:cell.dataDic TwoDic:fourceDic]) {
                NSLog(@"setTextColorsetTextColor");
                [cell.event_nextNameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
                [cell.event_nameLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
                [cell.event_nextTime setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
                [cell.channel_id setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
                [cell.channel_Name setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
            }else
            {
                [cell.event_nextNameLab setTextColor:CellGrayColor];  //CellGrayColor
                [cell.event_nameLab setTextColor:CellBlackColor];  //CellBlackColor
                [cell.event_nextTime setTextColor:CellGrayColor];//[UIColor greenColor]
                [cell.channel_id setTextColor:CellGrayColor];//[UIColor greenColor]
                [cell.channel_Name setTextColor:CellGrayColor];//[UIColor greenColor]
            }
        }else{//如果为空，什么都不执行
        }
        return cell;
    }
}
-(void)reducePushSharingView
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reducePushSharingViewNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reducePushSharingViewNotific) name:@"reducePushSharingViewNotific" object:nil];
    
}
-(void)reducePushSharingViewNotific
{
    if (shareViewArr.count > 0) {
        [shareViewArr removeObjectAtIndex:0];
        if (shareViewArr.count > 0) {
            NSNotification * textOne = shareViewArr[0][0];
            NSString * typeStr = shareViewArr[0][1];
            
            if ([typeStr isEqualToString:@"Service"]) {
                [self OtherDevicePushToPhone:textOne];
            }else
            {
                [self OtherDevicePushToPhoneLive:textOne];
            }
        }
    }
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
                        [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                    }else //正常播放的步骤
                    {
                        [self firstOpenAppAutoPlayZero:0 diction:self.dicTemp];
                    }
                }else //正常播放的步骤
                {
                    [self firstOpenAppAutoPlayZero:0 diction:self.dicTemp];
                }
            }
            
        });
    }
}
-(void)firstOpenAppAutoPlayZero:(NSInteger)row diction :(NSDictionary *)dic
{
    [self firstOpenAppAutoPlay:row diction:dic];
    firstOpenAPP = firstOpenAPP+1;
    firstfirst = NO;
}
///点击了投屏弹窗的选择确定按钮
-(void)PushSelectBtnClick
{
    if([self.video.channelId  isEqual: @""] || [self.video.channelId isEqualToString:@""]){
        
        socketView.filePushService = [[FilePushService alloc]init];
        socketView.filePushService.file_name = socketView.cs_serviceREC.file_name;
        socketView.filePushService.file_name_len = socketView.cs_serviceREC.file_name_len;
        socketView.filePushService.client_name = socketView.cs_serviceREC.client_name;
        socketView.filePushService.client_name_len = socketView.cs_serviceREC.client_name_len;
        socketView.filePushService.push_type = 0;
        
        
        int tempCount = 0;
        NSMutableArray *pushDataMutableArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < pushBtnSelectArr.count ; i++) {
            if ([pushBtnSelectArr[i] isEqualToString:@"YES"]) {
                tempCount ++;
                NSString * astr = phonePushOtherArr[i][0];
                [pushDataMutableArray addObject: [astr componentsSeparatedByString:@"."]]; //从字符.中分隔成2个元素的数组
            }
        }
        socketView.filePushService.client_count = tempCount;
        socketView.filePushService.push_client_ip = pushDataMutableArray;
        
        
        [self.socketView  SetCSMDPushLive];
    }else
    {
        socketView.mdPhonePushService = [[MDPhonePushService alloc]init];
        
        socketView.mdPhonePushService.service_tuner_type = socketView.socket_ServiceModel.service_tuner_mode;
        socketView.mdPhonePushService.service_network_id = socketView.socket_ServiceModel.service_network_id;
        socketView.mdPhonePushService.service_ts_id = socketView.socket_ServiceModel.service_ts_id;
        socketView.mdPhonePushService.service_service_id = socketView.socket_ServiceModel.service_service_id;
        socketView.mdPhonePushService.audio_pid = socketView.socket_ServiceModel.audio_pid;
        socketView.mdPhonePushService.subt_pid = socketView.socket_ServiceModel.subt_pid;
        NSString * clientName = [NSString stringWithFormat:@"%@",[GGUtil deviceVersion]];
        socketView.mdPhonePushService.client_name = clientName;
        socketView.mdPhonePushService.client_name_len = clientName.length;
        socketView.mdPhonePushService.push_type = 0;
        
        int tempCount = 0;
        NSMutableArray *pushDataMutableArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < pushBtnSelectArr.count ; i++) {
            if ([pushBtnSelectArr[i] isEqualToString:@"YES"]) {
                tempCount ++;
                NSString * astr = phonePushOtherArr[i][0];
                NSLog(@"arrrrri %d",i);
                NSLog(@"astr %@",astr);
                [pushDataMutableArray addObject: [astr componentsSeparatedByString:@"."]]; //从字符.中分隔成2个元素的数组
            }
        }
        socketView.mdPhonePushService.client_count = tempCount;
        socketView.mdPhonePushService.push_client_ip = pushDataMutableArray;
        
        
        [self.socketView  SetCSMDPushService ];
    }
    
    
    
    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tempTableviewForFocus deselectRowAtIndexPath:tempIndexpathForFocus animated:YES];
    if ([tableView isEqual:pushTableView]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        tempPushViewCell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSString * str = pushBtnSelectArr[indexPath.row];
        if ([str isEqualToString:@"NO"]) {
            [pushBtnSelectArr setObject:@"YES" atIndexedSubscript:indexPath.row];
            tempPushViewCell.pushBtnImageView.image = [UIImage imageNamed:@"BeSelect"];
        }else
        {
            [pushBtnSelectArr setObject:@"NO" atIndexedSubscript:indexPath.row];
            tempPushViewCell.pushBtnImageView.image = [UIImage imageNamed:@"NoSelect"];
        }
        
        
    }
    else{
        NSLog(@"self.video.dicChannl88==11");
        [self updateFullScreenDic];
        
        TVViewTouchPlay = YES;
        //每次播放前，都先把 @"deliveryPlayState" 状态重置，这个状态是用来判断视频断开分发后，除非用户点击
        [USER_DEFAULT setObject:@"beginDelivery" forKey:@"deliveryPlayState"];
        
        
        tempBoolForServiceArr = YES;
        tempArrForServiceArr =  self.categoryModel.service_indexArr;
        tempDicForServiceArr = self.TVChannlDic;
        self.video.dicChannl = [tempDicForServiceArr mutableCopy];
        
        if ([tempArrForServiceArr isKindOfClass:[NSArray class]]){
            self.video.channelCount = tempArrForServiceArr.count;
        }
        tempIndexpathForFocus = indexPath;
        nowPlayChannelInfo.numberOfRowInt = indexPath.row;
        
        //====快速切换频道名称和节目名称
        NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
        [GGUtil postsetChannelNameAndEventNameNotic:nowPlayingDic];
        indexpathRowStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        
        
        
        //①加入播放判断，如果节目正在播放，则不点击没有反应，不会重新播放
        
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
        
        NSDictionary * epgDicToSocketTemp = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)rowIndex]]; //找到了正在播放的节目的信息
        
        //②
        NSUInteger  indexPathRow = [indexpathRowStr integerValue];
        NSDictionary * nowPlayingChannelDic =   [self.dicTemp objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPathRow]];
        
        if ([GGUtil judgeTwoEpgDicIsEqual:nowPlayingChannelDic TwoDic:epgDicToSocketTemp]) {
            NSLog(@"相等");
        }
        else
        {
            judgeIsNeedShowDeliveryStop = 1;
            NSLog(@"不相等");
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didselectRowToPlayClick) object:nil];
            [self performSelector:@selector(didselectRowToPlayClick) withObject:nil afterDelay:0.3];
            [self removeLabAndAddIndecatorView];
            //=====则去掉不能播放的字样，加上加载环   ft/usdt   eth/usdt   ft/eth
            
            
            //加入历史记录
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"dispatch_get_global_queue 加入历史记录");
                
                [self addHistory:indexPath.row diction:self.dicTemp];
                [USER_DEFAULT setObject:@"NO" forKey:@"audioOrSubtTouch"];
                [USER_DEFAULT setObject:tempArrForServiceArr forKey:@"tempArrForServiceArr"];
                [USER_DEFAULT setObject:tempDicForServiceArr forKey:@"tempDicForServiceArr"];
                [self.videoController setaudioOrSubtRowIsZero];
                
                //                sleep(10);
                NSLog(@"dispatch_get_global_queue 加入历史记录==结束");
            });
            
            //    //关闭当前正在播放的节目
            [self.videoController.player stop];
            [self.videoController.player shutdown];
            [self.videoController.player.view removeFromSuperview];
        }
        
        
        //        [tableView reloadData];
        
        
        [tempTableviewForFocus reloadData];
        NSLog(@"ksksksksksakjsdiasdiuasdasdiu");
        
    }
    
}
#pragma mark - 点击tableView 变蓝
-(void)performChangeColor
{
    int indexOfCategory =  self.category_index;
    NSArray * allNumberOfServiceArr ;
    
    NSArray * categoryTempArr = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
    if (categoryTempArr.count >1 && categoryTempArr != NULL && categoryTempArr !=nil) {
        //有录制有直播
        
        if (self.categorys.count > 0) {
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
            [self tableViewCellToBlue:0 indexhah:[indexpathRowStr integerValue] AllNumberOfService:allNumberOfServiceArr.count];
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
    NSLog(@"时间==111");
    //    [_slideView reloadDataNoVisibleZero];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"dispatch_get_global_queue 播放的第一个方法");
        NSUInteger  indexPathRow = [indexpathRowStr integerValue];
        NSLog(@" indexPathRow %lu",(unsigned long)indexPathRow);
        //=======机顶盒加密
        NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:indexPathRow serviceListDic:self.dicTemp];
        
        if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
            [GGUtil postnoPlayShowNotic];
            NSLog(@"postnoPlayShowNotic 11111");
            [tempTableviewForFocus reloadData];
            [self refreshTableviewByEPGTime];
            
            //=======new z
            NSDictionary * epgDicToSocket = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPathRow]];
            
            if (epgDicToSocket.count > 14) {  //录制
                //                return ;
            }else //直播
            {
                NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
                [GGUtil postsetChannelNameAndEventNameNotic:nowPlayingDic];
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
                    int audiopidTemp;
                    audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];
                    
                    if (audio_infoArr.count >audiopidTemp ) {
                        socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];
                        //                socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
                    }
                    
                }else
                {
                    if (audio_infoArr.count > 0 ) {
                        
                        int audiopidTemp;
                        audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];
                        
                        if (audio_infoArr.count > audiopidTemp ) {
                            socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];
                        }
                        
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
                
                
                [self SetService_videoindex:epgDicToSocket];
                self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
                
                NSLog(@"self.service_videoname %@",self.service_videoname);
                
                if (epg_infoArr.count > 0) {
                    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
                }else
                {
                    self.event_startTime = @"";
                    self.event_endTime = @"";
                }
                
                self.video.startTime = self.event_startTime;
                self.video.endTime = self.event_endTime;
                epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
                if (epg_infoArr.count > 0) {
                    if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
                        self.video.startTime = @"0";
                        self.video.endTime = @"0";
                        self.event_videoname = @"";
                        [GGUtil postsetTimeAndProgressIsNullNotific];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self removeTopProgressView];
                        });
                        
                        NSLog(@"hidenhidenhidenhiden 11111");
                    }else
                    {
                        self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
                        self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                        self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
                        
                        NSLog(@"hidenhidenhidenhiden 11111 aaaaaaa");
                    }
                    
                }else
                {
                    //            return;
                    
                    self.event_videoname = @"";
                    self.event_startTime = @"";
                    self.event_endTime = @"";
                    [GGUtil postsetTimeAndProgressIsNullNotific];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self removeTopProgressView];
                    });
                }
                
                isEventStartTimeBiger_NowTime = NO;
                BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
                if (isEventStartTimeBigNowTime == YES) {
                    self.event_videoname = @"";
                    self.event_startTime = @"";
                    self.event_endTime = @"";
                    [GGUtil postsetTimeAndProgressIsNullNotific];
                    [self removeTopProgressView];
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
                
            }
            
            NSLog(@" sel.StartTime = %@",self.event_startTime);
            NSLog(@" sel.StartTimeEnd = %@",self.event_endTime);
            
            self.video.startTime = self.event_startTime;
            self.video.endTime = self.event_endTime;
            if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
                self.video.startTime = @"0";
                self.video.endTime = @"0";
                self.event_videoname = @"";
                [GGUtil postsetTimeAndProgressIsNullNotific];
                [self removeTopProgressView];
                NSLog(@"hidenhidenhidenhiden 2222222");
            }else{
                self.video.startTime = self.event_startTime;
                self.video.endTime = self.event_endTime;
                NSLog(@"hidenhidenhidenhiden 2222222 aaaaaaa");
            }
            NSLog(@"timeIsChange1 %@",self.video.startTime);
            
            [self removeTopProgressView];
            [self.timer invalidate];
            self.timer = nil;
            
            //=====***
            [self.videoController setaudioOrSubtRowIsZero];
            NSArray * audio_infoArr = [[NSArray alloc]init];
            NSArray * subt_infoArr = [[NSArray alloc]init];
            NSArray * epg_infoArr = [[NSArray alloc]init];
            //****
            
            
            socketView.socket_ServiceModel = [[ServiceModel alloc]init];
            audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
            subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
            if (audio_infoArr.count > 0 && subt_infoArr.count > 0) {
                
                int audiopidTemp;
                audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];
                
                if (audio_infoArr.count > audiopidTemp) {
                    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];
                    
                    socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
                }
                
            }else
            {
                if (audio_infoArr.count > 0 ) {
                    int audiopidTemp;
                    audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];
                    
                    if (audio_infoArr.count > audiopidTemp) {
                        socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];
                    }
                    
                    
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
            
            
            //********
            [self SetService_videoindex:epgDicToSocket];
            //此处获得该EPG的当前信息，否则我们播放的信息还是它之前的信息
            for (int i = 0; i<self.serviceData.count; i++) {
                
                BOOL isYes =  [GGUtil judgeTwoEpgDicIsEqual:self.serviceData[i] TwoDic:epgDicToSocket]; //此处通过判断两个EPG信息是否相等来找到两个一样的EPG信息
                if(isYes == YES)
                {
                    epgDicToSocket = self.serviceData[i];   //给epgDicToSocket 赋新值
                }
            }
            self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
            epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
            if (epg_infoArr.count == 0 || epg_infoArr == nil) {
                self.event_videoname = @"";
                self.event_startTime = @"";
                self.event_endTime = @"";
                [GGUtil postsetTimeAndProgressIsNullNotific];
                [self removeTopProgressView];
            }else
            {
#pragma mark - 需要注意名称变化
                self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
                self.video.startTime = self.event_startTime;
                self.video.endTime = self.event_endTime;
                if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
                    self.video.startTime = @"0";
                    self.video.endTime = @"0";
                    self.event_videoname = @"";
                    [GGUtil postsetTimeAndProgressIsNullNotific];
                    [self removeTopProgressView];
                    NSLog(@"hidenhidenhidenhiden 333333");
                    
                }else{
                    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
                    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
                    NSLog(@"hidenhidenhidenhiden 333333 aaaaaa");
                }
                
            }
            
            isEventStartTimeBiger_NowTime = NO;
            BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
            if (isEventStartTimeBigNowTime == YES) {
                self.event_videoname = @"";
                self.event_startTime = @"";
                self.event_endTime = @"";
                [GGUtil postsetTimeAndProgressIsNullNotific];
                [self removeTopProgressView];
            }
            self.TVSubAudioDic = epgDicToSocket;
            self.TVChannlDic = self.dicTemp;
            tempBoolForServiceArr = YES;
            tempArrForServiceArr =  self.categoryModel.service_indexArr;
            tempDicForServiceArr = self.TVChannlDic;
            
            self.video.dicChannl = [tempDicForServiceArr mutableCopy];
            if ([tempArrForServiceArr isKindOfClass:[NSArray class]]){
                self.video.channelCount = tempArrForServiceArr.count;
            }
            [self judgeAllArgueIsZero];
            [self getsubt];
            //            [self.tableForSliderView reloadData];
            //            [self.table reloadData];
            [tempTableviewForFocus reloadData];
            
            //            [tableForSliderView reloadData];
            tempBoolForServiceArr = YES;
            tempArrForServiceArr =  self.categoryModel.service_indexArr;
            tempDicForServiceArr = self.TVChannlDic;
            self.video.dicChannl = [tempDicForServiceArr mutableCopy];
            if ([tempArrForServiceArr isKindOfClass:[NSArray class]]){
                self.video.channelCount = tempArrForServiceArr.count;
            }
            [USER_DEFAULT setObject:self.video.dicChannl forKey:@"VideoTouchOtherViewdicChannl"];
            NSNumber * channelCountNum = [NSNumber numberWithInt:self.video.channelCount];
            [USER_DEFAULT setObject:channelCountNum forKey:@"VideoTouchOtherViewchannelCount"];
            
            if (epg_infoArr.count > 0) {
                self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
            }else{
                self.event_startTime = @"";
                self.event_endTime = @"";
            }
            //
            self.video.startTime = self.event_startTime;
            self.video.endTime = self.event_endTime;
            if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
                self.video.startTime = @"0";
                self.video.endTime = @"0";
                self.event_videoname = @"";
                [GGUtil postsetTimeAndProgressIsNullNotific];
                [self removeTopProgressView];
                NSLog(@"hidenhidenhidenhiden 444444");
            }else{
                self.video.startTime = self.event_startTime;
                self.video.endTime = self.event_endTime;
                NSLog(@"hidenhidenhidenhiden 444444 aaaaaaaa");
            }
            
            //== 录制时间赋值
            if (epgDicToSocket.count > 14) {  //录制
                
                //录制节目的时间
                self.event_startTime = [epgDicToSocket objectForKey:@"record_time"];
                NSString * RECStartTime = [epgDicToSocket objectForKey:@"record_time"];
                NSString * RECDurationTime = [epgDicToSocket objectForKey:@"duration"];
                self.event_endTime = [NSString stringWithFormat:@"%ld",[RECStartTime integerValue] + [RECDurationTime integerValue]];
                
                BOOL isEventStartTimeBigNowTime = NO;//= [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
                if (isEventStartTimeBigNowTime == YES) {
                    self.event_videoname = @"";
                    self.event_startTime = @"";
                    self.event_endTime = @"";
                    [GGUtil postsetTimeAndProgressIsNullNotific];
                    [self removeTopProgressView];
                }
                
                if (epg_infoArr.count > 0) {
                    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
                }else{
                    self.event_startTime = @"";
                    self.event_endTime = @"";
                }
                
                self.video.startTime = self.event_startTime;
                self.video.endTime = self.event_endTime;
                if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
                    self.video.startTime = @"0";
                    self.video.endTime = @"0";
                    self.event_videoname = @"";
                    [GGUtil postsetTimeAndProgressIsNullNotific];
                    [self removeTopProgressView];
                    NSLog(@"hidenhidenhidenhiden 55555");
                }else{
                    self.video.startTime = self.event_startTime;
                    self.video.endTime = self.event_endTime;
                    NSLog(@"hidenhidenhidenhiden 555555 aaaaaaa");
                }
            }
            [self updateFullScreenDic];
            //            [self.tableForSliderView reloadData];
            [tempTableviewForFocus reloadData];
            [self refreshTableviewByEPGTime];
            [self caculatorProgress];
            // 只显示时间，不显示进度条
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view addSubview:self.topProgressView];
                [self.view bringSubviewToFront:self.topProgressView];
                [USER_DEFAULT setObject:@"YES" forKey:@"topProgressViewISNotExist"];
            });
            
            //取消加载环
            NSNotification *notification3 =[NSNotification notificationWithName:@"IndicatorViewHiddenNotic" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification3];
            
            return ;
            
        }else
        {
            [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
            
            if (characterStr != NULL && characterStr != nil) {
                BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                if (judgeIsSTBDecrypt == YES) {
                    
                    //将上一个节目关闭
                    [self stopVideoPlay];
                    
                    // 此处代表需要记性机顶盒加密验证
                    NSNumber  *numIndex = [NSNumber numberWithInteger:indexPathRow];
                    NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"LiveTouch",@"textThree",nil];
                    [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                    firstOpenAPP = firstOpenAPP+1;
                    firstfirst = NO;
                    
                    NSMutableDictionary * epgDicToSocket = [[self.dicTemp objectForKey:[NSString stringWithFormat:@"%ld",(long)numIndex]] mutableCopy];
                    NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
                    [GGUtil postsetChannelNameAndEventNameNotic:nowPlayingDic];
                    
                    
                }else //正常播放的步骤
                {
                    [self firstOpenAppAutoPlayZero:indexPathRow diction:self.dicTemp];
                }
                
            }else //正常播放的步骤
            {
                [self firstOpenAppAutoPlayZero:indexPathRow diction:self.dicTemp];
            }
        }
        NSLog(@"dispatch_get_global_queue 播放的第一个方法==结束");
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
- (void)getDataService:(NSNotification *)text
{
    NSLog(@"this is Major 22222");
    judgeIsNeedShowDeliveryStop = 2;
    if (self.showTVView == YES) {
        playVideoType = 1;
        NSLog(@"%@",text.userInfo[@"playdata"]);
        NSLog(@"－－－－－接收到LIVe通知------");
        //NSData --->byte[]-------NSData----->NSString

        if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
            //判断状态
            if ([[USER_DEFAULT objectForKey:@"ConnectStatus_userDefault"] isEqualToString: @"ConnectIsSuccess"]) {
                [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
                NSLog(@"正常情况，可以播放");
            }else
            {   //出现异常
                [GGUtil postnoPlayShowNotic];
                NSLog(@"postnoPlayShowNotic 22222");
                return ;
            }
        }else{
            [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];  //正常情况，可以播放
        }

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
            self.video.playEventName = self.event_videoname;
            self.video.startTime = self.event_startTime;
            self.video.endTime = self.event_endTime;

            NSLog(@"[[GGUtil GetNowTimeString] intValue] %d",[[GGUtil GetNowTimeString] intValue]);
            NSLog(@"[self.video.endTime intValue] %d",[self.video.endTime intValue]);
            NSLog(@"[self.video.startTime intValue] %d",[self.video.startTime intValue]);
            if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {

                self.video.startTime = @"0";
                self.video.endTime = @"0";
                self.event_videoname = @"";
                [GGUtil postsetTimeAndProgressIsNullNotific];
                [self removeTopProgressView];
                NSLog(@"hidenhidenhidenhiden 6666666");
            }else{
                self.video.startTime = self.event_startTime;
                self.video.endTime = self.event_endTime;
                NSLog(@"hidenhidenhidenhiden 66666666 aaaaaa");

            }

            [self setStateNonatic];

            [USER_DEFAULT setObject:@"NO" forKey:@"isStartBeginPlay"]; //是否已经开始播放，如果已经开始播放，则停止掉中心点的旋转等待圆圈


            //==========正文
            double delayInSeconds = 0;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                NSLog(@"dispatch_get_global_queue 播放方法");
                [USER_DEFAULT setObject:@"YES" forKey:@"isStartBeginPlay"]; //是否已经开始播放，如果已经开始播放，则停止掉中心点的旋转等待圆圈
                [self playVideo];
            });

            playState = NO;

            if (self.showTVView == YES) {
                [self ifNeedPlayClick];
                NSLog(@"play-Click 1111");
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
            [self caculatorProgress];

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
    //    card_ret = 0;
    NSLog(@"card_retcard_retcard_retcard_retcard_retcard_ret %d",card_ret);
    if (card_ret != 0) {
        
        if (self.showTVView == YES) {
            
            playVideoType = 2;
            
            NSLog(@"%@",text.userInfo[@"playdata"]);
            NSLog(@"－－－－－接收到REC通知------");
            _byteDatas = [[NSMutableData alloc]init];
            
            if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
                //判断状态
                if ([[USER_DEFAULT objectForKey:@"ConnectStatus_userDefault"] isEqualToString: @"ConnectIsSuccess"]) {
                    [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
                    NSLog(@"正常情况，可以播放");
                }else
                {   //出现异常
                    [GGUtil postnoPlayShowNotic];
                    NSLog(@"postnoPlayShowNotic 33333");
                    return ;
                }
            }else{
                [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];  //正常情况，可以播放
            }
            
            
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
                [USER_DEFAULT setObject:self.video.startTime forKey:@"RECVideoStartTime"];
                [USER_DEFAULT setObject:self.video.endTime forKey:@"RECVideoEndTime"];
                
                int RECDurationTimeTemp = [self.video.endTime intValue] - [self.video.startTime intValue];
                NSString * RECDurationTimeTempStr = [NSString stringWithFormat:@"%d",RECDurationTimeTemp];
                [USER_DEFAULT setObject:RECDurationTimeTempStr forKey:@"RECVideoDurationTime"];
                [USER_DEFAULT setObject:@"YES" forKey:@"IsfirstPlayRECVideo"];
                
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
                    NSLog(@"play-Click 2222");
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
        
        
    }else
    {
        playVideoType = 2;
        NSLog(@" bu nnge  bof ang ");
        
        if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
            [GGUtil postnoPlayShowNotic];
            NSLog(@"postnoPlayShowNotic 44444");
            return ;
            
        }else{
            [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
        }
        [GGUtil postnoPlayShowNotic];
        NSLog(@"postnoPlayShowNotic 55555");
        [self removeTopProgressView];
        self.video.startTime = @"0";
        self.video.endTime = @"0";
        [USER_DEFAULT setObject:self.video.startTime forKey:@"RECVideoStartTime"];
        [USER_DEFAULT setObject:self.video.endTime forKey:@"RECVideoEndTime"];
        
        int RECDurationTimeTemp = [self.video.endTime intValue] - [self.video.startTime intValue];
        NSString * RECDurationTimeTempStr = [NSString stringWithFormat:@"%d",RECDurationTimeTemp];
        [USER_DEFAULT setObject:RECDurationTimeTempStr forKey:@"RECVideoDurationTime"];
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
    NSLog(@"时间==222");
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
        
        NSLog(@"epgDicToSocketlala %@",epgDicToSocket);
        
        /*
         直播和录制的分水岭
         **/
        if (epgDicToSocket.count > 14) {  //录制
            [self playRECVideo:epgDicToSocket];
        }else //直播
        {
            NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
            [GGUtil postsetChannelNameAndEventNameNotic:nowPlayingDic];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self addHistory:row diction:dic];
            });
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
                int audiopidTemp;
                audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];
                
                socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];
                //                socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
            }else
            {
                if (audio_infoArr.count > 0 ) {
                    
                    int audiopidTemp;
                    audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];
                    
                    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];
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
            //********
            [self SetService_videoindex:epgDicToSocket];
            self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
            epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
            if (epg_infoArr.count > 0) {
                self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
            }else
            {
                NSLog(@"数据为空lslslslsls");
                self.event_startTime = @"";
                self.event_endTime = @"";
            }
            
            if (epg_infoArr.count > 0) {
                self.video.startTime = self.event_startTime;
                self.video.endTime = self.event_endTime;
                if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
                    self.video.startTime = @"0";
                    self.video.endTime = @"0";
                    self.event_videoname = @"";
                    [GGUtil postsetTimeAndProgressIsNullNotific];
                    [self removeTopProgressView];
                    NSLog(@"hidenhidenhidenhiden 77777777");
                }else{
                    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
                    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
                    NSLog(@"hidenhidenhidenhiden 77777777 aaaaaaaaa");
                }
                
            }else
            {
                
                
                self.event_videoname = @"";
                self.event_startTime = @"";
                self.event_endTime = @"";
                [GGUtil postsetTimeAndProgressIsNullNotific];
                [self removeTopProgressView];
            }
            
            isEventStartTimeBiger_NowTime = NO;
            BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
            if (isEventStartTimeBigNowTime == YES) {
                self.event_videoname = @"";
                self.event_startTime = @"";
                self.event_endTime = @"";
                [GGUtil postsetTimeAndProgressIsNullNotific];
                [self removeTopProgressView];
            }
            
            self.TVSubAudioDic = epgDicToSocket;
            self.TVChannlDic = self.dicTemp;
            [self judgeAllArgueIsZero];
            [self getsubt];
            //此处销毁通知，防止一个通知被多次调用    // 1
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
            //注册通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
                    [GGUtil postnoPlayShowNotic];
                    NSLog(@"postnoPlayShowNotic 66666");
                }else{
                    [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
                    
                    if (self.showTVView == YES) {
                        self.videoController.socketView1 = self.socketView;
                        [self.socketView  serviceTouch ];
                    }else
                    {
                        [self ifNotISTVView];
                    }
                }
            });
        }
    }else
    {
        NSLog(@"已经不是TV页面了");
        [self ifNotISTVView];
    }
    
    
}
//-(int)setAudioPidTemp:(NSMutableArray *)aduioInfoArr
-(int)setAudioPidTemp:(NSMutableArray *)aduioInfoArr   EPGDic:(NSDictionary *)allEPGDic
{
    NSString * localLanguage = [USER_DEFAULT objectForKey:@"systemLocalLanguage"];
    
    if ([localLanguage isEqualToString:@"en"]) {
        localLanguage = @"English";
    }else if ([localLanguage isEqualToString:@"fr"]) {
        localLanguage = @"Français";
    }else if ([localLanguage isEqualToString:@"sw"]) {
        localLanguage = @"Kiswahili";
    }else if ([localLanguage isEqualToString:@"pt"]) {
        localLanguage = @"Português";
    }else if ([localLanguage isEqualToString:@"zh"]) {
        localLanguage = @"Chinese";
    }
    int audiopidTemp;
    
    NSMutableArray * mutableAudioInfo = [USER_DEFAULT objectForKey:@"MutableAudioInfo"];
    for (int i = 0; i < mutableAudioInfo.count; i++) {
        
        if ([GGUtil judgeTwoEpgDicIsEqual:allEPGDic TwoDic:mutableAudioInfo[i][0]]) {
            return [mutableAudioInfo[i][1]intValue];
        }
        
    }
    
    for ( int i = 0; i < aduioInfoArr.count ; i ++) {
        if ([[aduioInfoArr[i] objectForKey:@"audio_language"] isEqualToString:localLanguage]){
            audiopidTemp = i;
            //存储记录音频信息
            //1.记录播放信息存到本地  2.每次播放时，先判断音频信息是否被设置过，如果已经设置，则获取播放的节目信息。否则播放默认音轨   3.APP重新打开时，将列表情况
            
            NSMutableArray * mutableArrTemp= [[NSMutableArray alloc]init];
            
            mutableArrTemp = [[USER_DEFAULT objectForKey:@"MutableAudioInfo"] mutableCopy];
            BOOL judgeIsHasAudio = NO;
            if (mutableArrTemp.count == 0) {
                
                NSMutableArray * firstTempArr = [[NSMutableArray alloc]init];
                [firstTempArr addObject:[allEPGDic copy]];
                [firstTempArr addObject:[NSNumber numberWithInt:audiopidTemp]];
                
                mutableArrTemp= [[NSMutableArray alloc]init];
                [mutableArrTemp addObject:[firstTempArr copy]];
                judgeIsHasAudio = YES;
            }else  //不为空
            {
                for (int i = 0; i < mutableArrTemp.count; i++) {
                    if ([GGUtil judgeTwoEpgDicIsEqual:mutableArrTemp[i][0] TwoDic:allEPGDic]) {
                        //如果相等    //存储节目的EPG和PID信息
                        
                        [mutableArrTemp removeObjectAtIndex:i];
                        
                        
                        NSMutableArray * otherTempArr = [[NSMutableArray alloc]init];
                        [otherTempArr addObject:allEPGDic];
                        [otherTempArr addObject:[NSNumber numberWithInt:audiopidTemp]];
                        
                        //                [otherTempArr addObject:allEPGDic];
                        //                [otherTempArr addObject:[NSNumber numberWithInt:audiopidTemp]];
                        
                        //                        NSArray * otherArrTemp = [otherTempArr copy];
                        [mutableArrTemp addObject: [otherTempArr copy]];
                        judgeIsHasAudio = YES;
                        //[NSNumber numberWithInt:audioRow] ;
                        break;
                    }else
                    {
                        judgeIsHasAudio = NO;
                    }
                }
            }
            
            if (judgeIsHasAudio == YES) {
                [USER_DEFAULT setObject:[mutableArrTemp copy] forKey:@"MutableAudioInfo"];
            }else
            {
                NSMutableArray * otherTempArr = [[NSMutableArray alloc]init];
                [otherTempArr addObject:allEPGDic];
                [otherTempArr addObject:[NSNumber numberWithInt:audiopidTemp]];
                [mutableArrTemp addObject: [otherTempArr copy]];
                [USER_DEFAULT setObject:[mutableArrTemp copy] forKey:@"MutableAudioInfo"];
            }
            return audiopidTemp;
        }else{
            audiopidTemp = 0;
        }
    }
    return audiopidTemp;
}
#pragma  mark -视频分发返回来的RET区的结果
-(BOOL)getLinkData : (int )val tempDataA:(NSMutableData *)aData tempDataB:(NSMutableData *)bData type:(NSString *)typeTemp
{
    if (val == 0)  {
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
        [GGUtil postnoPlayShowNotic];
        NSLog(@"postnoPlayShowNotic 77777");
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
            
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
    
    dic = [dic mutableCopy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"dispatch_get_global_queue 历史记录的主方法开始");
        [USER_DEFAULT setObject:@"Lab" forKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
        [USER_DEFAULT setObject:[NSNumber numberWithInt:row] forKey: @"Touch_Channel_index"];
        if (![[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
            [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
            [GGUtil postnoPlayShowShutNotic];
//            [GGUtil postIndicatorViewShowNotic];
            if (SDTMonitor_addHistory == 0) {
                [GGUtil postIndicatorViewShowNotic];
            }else{ // SDTMonitor_addHistory == 1 代表是触发监控导致的addhistory
                SDTMonitor_addHistory = 0;
            }

        }
        //        if (self.showTVView == YES) {
        //            [self ifNeedPlayClick];
        //            NSLog(@"play-Click 3333");
        //        }else
        //        {
        //            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
        //        }
        NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%d",row]];
        [self judgeNowISRadio:epgDicToSocket]; //此处加个方法，判断是不是音频
        progressEPGArr =[epgDicToSocket objectForKey:@"epg_info"];  //新加的，为了进度条保存EPG数据
        [USER_DEFAULT setObject:[progressEPGArr copy] forKey:@"NowChannelEPG"];
        [USER_DEFAULT setObject:epgDicToSocket forKey:@"NowChannelDic"];
        // 2. 初始化两个数组存放数据
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
                        NSString * seedNowTime = [GGUtil GetNowTimeString];
                        NSNumber *aNumber = [NSNumber numberWithInteger:row];
                        [tempArr replaceObjectAtIndex:1 withObject:seedNowTime];
                        [tempArr replaceObjectAtIndex:2 withObject:aNumber];
                        [tempArr replaceObjectAtIndex:3 withObject:dic];
                        [mutaArray removeObjectAtIndex:i];
                        [mutaArray  addObject:[tempArr copy]];
                        break;
                    }
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
                    
                    //新添加的数据
                    NSString * newservice_network =  [epgDicToSocket objectForKey:@"service_network_id"];
                    NSString * newservice_ts =  [epgDicToSocket objectForKey:@"service_ts_id"];
                    NSString * newservice_service =  [epgDicToSocket objectForKey:@"service_service_id"];
                    NSString * newservice_tuner =  [epgDicToSocket objectForKey:@"service_tuner_mode"];
                    
                    if ([service_network isEqualToString:newservice_network] && [service_ts isEqualToString:newservice_ts] && [service_tuner isEqualToString:newservice_tuner] && [service_service isEqualToString:newservice_service]) {
                        addNewData = NO;
                        
                        NSArray * equalArr = duplicateArray[i];
                        NSMutableArray * tempArr = [equalArr mutableCopy];
                        NSString * seedNowTime = [GGUtil GetNowTimeString];
                        NSNumber *aNumber = [NSNumber numberWithInteger:row];
                        [tempArr replaceObjectAtIndex:0 withObject:epgDicToSocket];
                        [tempArr replaceObjectAtIndex:1 withObject:seedNowTime];
                        [tempArr replaceObjectAtIndex:2 withObject:aNumber];
                        [tempArr replaceObjectAtIndex:3 withObject:dic];
                        [mutaArray removeObjectAtIndex:i];
                        [mutaArray  addObject:[tempArr copy]];
                        
                        //                        NSLog(@"=ZZ==========tempArr %@",tempArr);
                        //                        NSLog(@"=ZZ==========epgDicToSocket %@",epgDicToSocket);
                        //                        NSLog(@"=ZZ==========dic %@",dic);
                        //                        NSLog(@"=ZZ==========mutaArray %@",mutaArray);
                        
                        //                        NSLog(@"相同的历史 ：%@",[tempArr copy]);
                        break;
                    }
                }
            }
        }
        NSLog(@"触发历史记录==判断");
        NSLog(@"触发历史记录mutaArraycount 111数量 %lu",(unsigned long)mutaArray.count);
        if (addNewData == YES) {
            NSString * seedNowTime = [GGUtil GetNowTimeString];
            NSNumber *aNumber = [NSNumber numberWithInteger:row];
            NSArray * seedNowArr = [NSArray arrayWithObjects:epgDicToSocket,seedNowTime,aNumber,dic,nil];
            if (seedNowArr.count > 0) {
                //根据数组大小，删除数据。只保留20个以内的历史记录
                NSLog(@"触发历史记录mutaArraycount 数量 %lu",(unsigned long)mutaArray.count);
                if (mutaArray.count > 19) {
                    for (int i = 0; i < mutaArray.count - 19; i ++) {
                        NSLog(@"触发历史记录删除");
                        [mutaArray removeObjectAtIndex:0];
                    }
                }
                [mutaArray addObject:seedNowArr];
                
                
            }else
            {
                NSAssert(seedNowArr != NULL, @"提示: 此时seedNowArr.count < 0,证明其为空");
            }
        }
        NSArray *myArray = [NSArray arrayWithArray:mutaArray];
        //获取播放的第一个节目信息
        if (myArray.count <1) {   //第一次打开APP的时候，历史为空
            storeLastChannelArr = nil;
        }else
        {
            storeLastChannelArr = myArray[myArray.count - 1];
        }
        [USER_DEFAULT setObject:myArray forKey:@"historySeed"];
        MEViewController * meview = [[MEViewController alloc]init];
        [meview viewDidAppear:YES];
        [meview viewDidLoad];
        
        NSNotification *notification3 =[NSNotification notificationWithName:@"judgeLastNextBtnIsEnableNotific" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification3];
        
        NSLog(@"dispatch_get_global_queue 历史记录的主方法==结束");
    });
    
    
}

-(void)judgeNowISRadio :(NSDictionary *)nowVideoDic  //判断当前播放时视频还是音频
{
    NSString * radioServiceType = [nowVideoDic objectForKey:@"service_type"];
    if ([radioServiceType isEqualToString:@"4"]) { //视频是1  音频是4
        [USER_DEFAULT setObject:@"radio" forKey:@"videoOrRadioPlay"];
        [USER_DEFAULT setObject:videoCantPlayTip forKey:@"videoOrRadioTip"];
    }else { //视频是1  音频是4
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
        statusNum = 0;
        [self prefersStatusBarHidden];
        
        [self addGuideView]; //添加引导图
        [self performSelector:@selector(notHaveNetWork) withObject:nil afterDelay:60];
        
    }else{
        
        self.showTVView = YES;
        [USER_DEFAULT setObject:@"YES" forKey:@"showTVView"];
        [self preventTVViewOnceFullScreen]; //防止刚切换到主界面全屏
        [self performSelector:@selector(notHaveNetWork) withObject:nil afterDelay:10];
        TVViewTouchPlay = YES;
        [USER_DEFAULT setObject:@"YES" forKey:@"topProgressViewISNotExist"];
        
        tableviewinit  = tableviewinit +1;
        statusNum = 1;
        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
        [self prefersStatusBarHidden];
        
        self.tabBarController.tabBar.hidden = NO;
        [self loadNav];
        [USER_DEFAULT setObject:@"1" forKey:@"viewISTVView"];  //如果是TV页面，则再用户按home键后再次进入，需要重新播放
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(viewWillAppearDealyFunction) object:nil];
        [self performSelector:@selector(viewWillAppearDealyFunction) withObject:nil afterDelay:0.3];
        
        //
    }
    double delayInSeconds = 0.7;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, mainQueue, ^{
        
        [self setCardTypeNotific];
        double delayInSeconds = 0.2;
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, mainQueue, ^{
            self.videoController.socketView1 = self.socketView;
            [self.socketView  judgeCardType];
        });
    });
    
    [GGUtil getCurrentLanguage];
}
//0.3s 后执行
-(void)viewWillAppearDealyFunction
{
    [USER_DEFAULT setBool:YES forKey:@"isBarIsShowNow"]; //进度条在刚打开时是显示状态
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [USER_DEFAULT setBool:NO forKey:@"lockedFullScreen"];  //解开全屏页面的锁
        [USER_DEFAULT setBool:NO forKey:@"isFullScreenMode"];  //判断是不是全屏模式
    });
    
    [self lineView];  //一条0.5pt的线
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
        if ([[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"YES"]) {
            
        }else
        {
            [self getServiceDataNotHaveSocket];    //获取表数据的不含有socket 的初始化方法
        }
        
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
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
        [self reducePushSharingView];  //刷新tableView焦点颜色的通知
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
        [self popPushAlertView]; //增加投屏弹窗弹出的通知
        [self setPushDataNotific];///创建通知，用于列表数据
        [self OtherDevicePushToPhoneNotific];
        [self OtherDevicePushToPhoneLiveNotific];
        [self reConnectSocketToRefreshTableNotific];
        [self removeAlertViewNotfic];
        
        
        
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
        if ([[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"YES"]) {
            [self showDelivaryStopped];
        }else
        {
            [self judgeJumpFromOtherView];
        }
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        [USER_DEFAULT setObject:@"Lab" forKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
    });
}

-(void)reConnectSocketToRefreshTableNotific
{
    //网络回复连接通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reConnectSocketToRefreshTable" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFirstViewTbaleview) name:@"reConnectSocketToRefreshTable" object:nil];
    
    
}
-(void)removeAlertViewNotfic
{
    //网络回复连接通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoveAlertViewnotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveAlertViewnotific) name:@"RemoveAlertViewnotific" object:nil];
}
-(void)refreshFirstViewTbaleview
{
    //    [_slideView removeFromSuperview];
    //    _slideView = nil;
    [self tableViewDataRefreshForMjRefresh_ONEMinute];
}
#pragma mark -//如果是从其他的页面跳转过来的，则自动播放上一个视频（犹豫中特殊情况，视频断开后，此方法会无效。除非用户重新点击观看）
-(void)judgeJumpFromOtherView //如果是从其他的页面条转过来的，则自动播放上一个视频
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self updateFullScreenDic];
        
        if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
            [GGUtil postnoPlayShowNotic];
            NSLog(@"postnoPlayShowNotic 88888");
            return ;
            
        }else{
            [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
        }
    });
    if (self.showTVView == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
        });
        NSString * deliveryPlayState =  [USER_DEFAULT objectForKey:@"deliveryPlayState"];
        //
        if (isHasChannleDataList == NO) {
            [self ifNotISTVView];
            
        }else
        {
            if ([deliveryPlayState isEqualToString:@"stopDelivery"]) {
                //①视频停止分发，断开了和盒子的连接，跳转界面不播放  ②禁止播放  ③取消掉加载环  ④ 显示不能播放的文字
                [self stopVideoPlay]; //停止视频播放
                [USER_DEFAULT setObject:deliveryStopTip forKey:@"playStateType"];
                [GGUtil postnoPlayShowNotic];
                NSLog(@"postnoPlayShowNotic 99999");
            }else //视频没有停止分发，跳转界面可以播放
            {
                [self removeLabAndAddIndecatorView];
                NSString * jumpFormOtherView =  [USER_DEFAULT objectForKey:@"jumpFormOtherView"];
                if([jumpFormOtherView isEqualToString:@"YES"])
                {
                    NSMutableArray * historyArr  =  (NSMutableArray *) [USER_DEFAULT objectForKey:@"historySeed"];
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
                                    [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                                    firstOpenAPP = firstOpenAPP+1;
                                    
                                    firstfirst = NO;
                                }else //正常播放的步骤
                                {
                                    [self firstOpenAppAutoPlayZero:row diction:dic];
                                }
                            }else //正常播放的步骤
                            {
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
                            
                            if (storeLastChannelArr.count < 2) {
                                return;
                            }else
                            {
                                if (touchArr.count >= 4) {
                                    NSInteger row = [touchArr[2] integerValue];
                                    NSDictionary * dic = storeLastChannelArr [3];
                                    NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:row serviceListDic:dic];
                                    if (characterStr != NULL && characterStr != nil) {
                                        BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                                        if (judgeIsSTBDecrypt == YES) {
                                            // 此处代表需要记性机顶盒加密验证
                                            NSNumber  *numIndex = [NSNumber numberWithInteger:row];
                                            NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"otherTouch",@"textThree",nil];
                                            [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                                            firstOpenAPP = firstOpenAPP+1;
                                            firstfirst = NO;
                                        }else //正常播放的步骤
                                        {
                                            [self firstOpenAppAutoPlayZero:row diction:dic];
                                        }
                                    }else //正常播放的步骤
                                    {
                                        //======机顶盒加密
                                        [self firstOpenAppAutoPlay:row diction:dic];
                                    }
                                    
                                    [USER_DEFAULT setObject:@"NO" forKey:@"jumpFormOtherView"];//为TV页面存储方法
                                }else
                                {
                                    return;
                                }
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
        [self ifNotISTVView];
    }
    
    [self showDelivaryStopped];
}
-(void)setCardTypeNotific
{
    //2
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SetCardTypeNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCardtype:) name:@"SetCardTypeNotific" object:nil];
}
-(void)setCardtype: (NSNotification *)text//(NSInteger)row
{
    NSLog(@"如果card_ret为0，则不能播放，否则可以 %d ",card_ret);
    card_ret = [text.userInfo[@"CardTypeStr"]integerValue];
    
    if (playVideoType == 1) {
        //直播节目
    }else if (playVideoType == 2)
    {
        //录制节目
        if (card_ret == 0) {
            if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
                
            }else{
                [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
            }
            [GGUtil postnoPlayShowNotic];
            NSLog(@"postnoPlayShowNotic aaaaa");
            [self removeTopProgressView];
            
            //            self.video.startTime = @"0";
            //            self.video.endTime = @"0";
            [USER_DEFAULT setObject:self.video.startTime forKey:@"RECVideoStartTime"];
            [USER_DEFAULT setObject:self.video.endTime forKey:@"RECVideoEndTime"];
            int RECDurationTimeTemp = [self.video.endTime intValue] - [self.video.startTime intValue];
            NSString * RECDurationTimeTempStr = [NSString stringWithFormat:@"%d",RECDurationTimeTemp];
            [USER_DEFAULT setObject:RECDurationTimeTempStr forKey:@"RECVideoDurationTime"];
        }else
        {
            // 播放
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
            
            NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)rowIndex]];
            
            [self setSearchViewData];
            NSLog(@"setSearchViewDatasetSearchViewData===111");
            [self removeLabAndAddIndecatorView];
            [self playRECVideo:epgDicToSocket];
        }
    }
    
}
- (void)addGuideView {
    
    NSMutableArray *paths = [NSMutableArray new];
    [GGUtil addTVViewGuideView:paths];
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
    
    //新建一个通知，用来监听机顶盒发出的节目列表更新的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mediaDeliveryUpdateNotificSMT" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaDeliveryUpdateSMT) name:@"mediaDeliveryUpdateNotificSMT" object:nil];
    
    
}
-(void)mediaDeliveryUpdateSMT
{
    NSLog(@"//此时应该列表刷新11");
    
    // ① 刷新  ②先判断有没有正在播放的节目了  ③如果有正在播放的节目，并且判断和正在播放的节目的dic信息是否相等，如果不相等则重新播放
    
    //** 用于第一时间刷新页面，从恢复出厂设置到有列表状态
    NSString * channelListIsHas = [USER_DEFAULT objectForKey:@"NOChannelDataDefault"];
    if ([channelListIsHas isEqualToString:@"YES"]) {
        
        //希望从路由器回复出厂后，刷新页面可以出发这个方法
        
        [USER_DEFAULT setObject:@"" forKey:@"playStateType"]; //设置为空，防止“delivery has  been....”产生
        [self tableViewDataRefreshForMjRefresh_ONEMinute];
    }
    //**
    //①刷新
    [self tableViewDataRefreshForSDTMonitorSMT];
    
}
-(void)mediaDeliveryUpdate
{
    NSLog(@"//此时应该列表刷新11");
    
    // ① 刷新  ②先判断有没有正在播放的节目了  ③如果有正在播放的节目，并且判断和正在播放的节目的dic信息是否相等，如果不相等则重新播放
    
    //** 用于第一时间刷新页面，从恢复出厂设置到有列表状态
    NSString * channelListIsHas = [USER_DEFAULT objectForKey:@"NOChannelDataDefault"];
    if ([channelListIsHas isEqualToString:@"YES"]) {
        
        //希望从路由器回复出厂后，刷新页面可以出发这个方法
        
        [USER_DEFAULT setObject:@"" forKey:@"playStateType"]; //设置为空，防止“delivery has  been....”产生
        [self tableViewDataRefreshForMjRefresh_ONEMinute];
    }
    //**
    //①刷新
    [self tableViewDataRefreshForSDTMonitor];
    
}
#pragma mark - 机顶盒发送通知，需要刷新节目了   socket case = 0
-(void)tableViewDataRefreshForSDTMonitor
{
    NSLog(@"SDTSDTSDTSDTSTD！！！");
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
    [request startAsynchronous];   //异步
    
    NSLog(@"self.categorys=a=a=a= %lu",(unsigned long)self.categorys.count);
    
    getLastCategoryArr = self.categorys; //[USER_DEFAULT objectForKey:@"serviceData_Default"];
    getLastRecFileArr  = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
    WEAKGET
    [request setCompletionBlock:^{
        
        NSDictionary *response = httpRequest.responseString.JSONValue;
        
        //将数据本地化
        [USER_DEFAULT setObject:response forKey:@"TVHttpAllData"];
        NSArray *data1 = response[@"service"];
        NSArray *recFileData = response[@"rec_file_info"];
        [USER_DEFAULT setObject:recFileData forKey:@"categorysToCategoryViewContainREC"];
        self.serviceData = (NSMutableArray *)data1;
        self.categorys = (NSMutableArray *)response[@"category"];  //新加，防止崩溃的地方
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        //判断是不是需要刷新顶部的YLSlider
        if ([self judgeIfNeedRefreshSliderView:self.categorys recFileArr:recFileData lastCategoryArr:getLastCategoryArr lastRECFileArr:getLastRecFileArr]) {
            NSLog(@"删除了某个节目");
                        [_slideView removeFromSuperview];
                        _slideView = nil;
            //
            [self.tableForSliderView reloadData];
            [self refreshTableviewByEPGTime];
            [self.table reloadData];
            
            [self tableViewDataRefreshForMjRefresh_ONEMinute];
        }else if(getLastCategoryArr.count > 0 && self.categorys.count == 0 && getLastRecFileArr.count !=0)
        {
            //            [_slideView removeFromSuperview];
            //            _slideView = nil;
            [self.tableForSliderView reloadData];
            [self refreshTableviewByEPGTime];
            [self.table reloadData];
            
            [self tableViewDataRefreshForMjRefresh_ONEMinute];
        }else if (getLastCategoryArr.count == 0 && self.categorys.count > 0  )
        {
            //            [_slideView removeFromSuperview];
            //            _slideView = nil;
            //
            [self.tableForSliderView reloadData];
            [self refreshTableviewByEPGTime];
            [self.table reloadData];
            
            [self tableViewDataRefreshForMjRefresh_ONEMinute];
        }
        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
            [self tableViewDataRefreshForMjRefresh_ONEMinute];
        }
        [self activeViewRemove];
        
        NSString * YLSlideTitleViewButtonTagIndexStr = [USER_DEFAULT objectForKey:@"YLSlideTitleViewButtonTagIndexStr"];
        
        int YLSlideTitleViewButtonTagIndex = [YLSlideTitleViewButtonTagIndexStr  intValue];
        
        NSString *  indexforTableToNum = YLSlideTitleViewButtonTagIndexStr;
        
        self.tableForSliderView = [self.tableForDicIndexDic objectForKey:indexforTableToNum][1];
        
        if (YLSlideTitleViewButtonTagIndex < self.tableForDicIndexDic.count) {
            NSLog(@"YLSlideTitleViewButtonTagIndex small");
            NSNumber * numTemp = [self.tableForDicIndexDic objectForKey:indexforTableToNum][0];
            
            NSInteger index = [numTemp integerValue];
            if (self.categorys.count > index) {
                [self returnDicTemp:index]; //根据是否有录制返回不同的item
            }else if(self.categorys.count == 0 && recFileData.count > 0)
            {
                [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                double delayInSeconds = 0.5;
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, mainQueue, ^{
                    NSIndexPath *indexPathNow = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self tableView:tempTableviewForFocus didSelectRowAtIndexPath:indexPathNow];
                });
            }else
            {
                return;
            }
        }
        
        //        [self.tableForSliderView reloadData];
        [tempTableviewForFocus reloadData];
        
        double delayInSeconds = 2;
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, mainQueue, ^{
            //            [self.tableForSliderView reloadData];
            [tempTableviewForFocus reloadData];
            
        });
        
        
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
            NSLog(@"categorys==||=SDT");
            
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
        
        [self setSearchViewData ];
        NSLog(@"setSearchViewDatasetSearchViewData===2222");
        
        BOOL isHavePlayingChannel = NO;
        
        NSMutableArray * mutableArrTemp = [self.serviceData mutableCopy];
        if (recFileData.count > 0) {
            for (int i = 0; i < recFileData.count ; i++) {
                [mutableArrTemp addObject:recFileData[i]];
            }
        }
        for (int i = 0; i < mutableArrTemp.count; i++) {
            
            NSDictionary * serviceArrForJudge_dic = mutableArrTemp[i];
            BOOL isTwoDicEqual =  [GGUtil judgeTwoEpgDicIsEqual:epgDicToSocket TwoDic:serviceArrForJudge_dic];
            
            if (isTwoDicEqual == YES) {
                isHavePlayingChannel = YES;
                if ([serviceArrForJudge_dic isEqual: epgDicToSocket] ) {
                    [self SDTfirstOpenAppAutoPlay:rowIndex diction:dic];
                    firstOpenAPP = firstOpenAPP+1;
                    firstfirst = NO;
                    
                    
                }
                else
                {
                    NSMutableDictionary * mutableDicTemp = [dic mutableCopy];
                    [mutableDicTemp setObject:[serviceArrForJudge_dic copy] forKey:[NSString stringWithFormat:@"%ld",(long)rowIndex]];
                    dic = [mutableDicTemp mutableCopy];
                    // 1. 修改id
                    NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:serviceArrForJudge_dic,@"nowPlayingDic", nil];
                    [GGUtil postsetChannelNameAndEventNameNotic:nowPlayingDic];
                    //2. 修改历史和store
                    
                    NSMutableArray * touchArrTemp ;
                    if (historyArr.count >= 1) {
                        touchArrTemp = [historyArr[historyArr.count - 1] mutableCopy];
                    }else
                    {
                        NSLog(@"historyArr== %@",historyArr);
                        return;
                    }
                    
                    //                    NSInteger rowIndex; =
                    touchArrTemp [3] = [dic copy];
                    [historyArr replaceObjectAtIndex:historyArr.count - 1 withObject:[touchArrTemp copy]];
                    
                    // 3.store
                    
                    storeLastChannelArr = [touchArrTemp copy];
                    
                    // history 修改
                    
                    [self addHistory:rowIndex diction:dic];
                    SDTMonitor_addHistory = 1;
                    
                    
                    //==========fix
                    //重新执行播放,并且要注意判断是不是加锁类型
                    
                    NSString * characterStr = [serviceArrForJudge_dic  objectForKey:@"service_character"];
                    
                    int program_character_int = [characterStr intValue];
                    
                    uint32_t character_And =  program_character_int &  0x02;
                    if (character_And > 0) {
                        // 此处代表需要记性机顶盒加密验证
                        NSNumber  *numIndex = [NSNumber numberWithInteger:rowIndex];
                        NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"LiveTouch",@"textThree",nil];
                        [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                        firstOpenAPP = firstOpenAPP+1;
                        firstfirst = NO;
                        
                        
                        
                    }else //从加锁到不加锁正常播放的步骤，但是要注意得如果用户此时还处于弹窗或者未输入密码界面，得去掉弹窗和输入密码
                    {
                        NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigDecoderPINShowNotific" object:nil userInfo:nil];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                        [STBAlert dismissWithClickedButtonIndex:1 animated:YES];
                        [self SDTfirstOpenAppAutoPlay:rowIndex diction:dic];
                        firstOpenAPP = firstOpenAPP+1;
                        firstfirst = NO;
                        
                    }
                    
                    return ;
                }
            }
        }
        //③如果有正在播放的节目，并且判断和正在播放的节目的dic信息是否相等，如果不相等则重新播放
        if (isHavePlayingChannel == NO) {
            NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:0 serviceListDic:self.dicTemp];
            if (characterStr != NULL && characterStr != nil) {
                BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                if (judgeIsSTBDecrypt == YES) {
                    // 此处代表需要记性机顶盒加密验证
                    NSNumber  *numIndex = [NSNumber numberWithInteger:0];
                    NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"firstOpenTouch",@"textThree",nil];
                    [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                    firstOpenAPP = firstOpenAPP+1;
                    firstfirst = NO;
                    
                }else //正常播放的步骤
                {
                    [self SDTfirstOpenAppAutoPlay:rowIndex diction:dic];
                    firstOpenAPP = firstOpenAPP+1;
                    firstfirst = NO;
                    double delayInSeconds = 0.5;
                    dispatch_queue_t mainQueue = dispatch_get_main_queue();
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, mainQueue, ^{
                        NSIndexPath *indexPathNow = [NSIndexPath indexPathForRow:0 inSection:0];
                        [self tableView:tempTableviewForFocus didSelectRowAtIndexPath:indexPathNow];
                    });
                }
            }else //正常播放的步骤
            {
                [self SDTfirstOpenAppAutoPlay:rowIndex diction:dic];
                [self performChangeColor];
                double delayInSeconds = 0.5;
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, mainQueue, ^{
                    NSIndexPath *indexPathNow = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self tableView:tempTableviewForFocus didSelectRowAtIndexPath:indexPathNow];
                });
            }
        }{
            NSLog(@"我们有正在播放的节目");
        }
        //        [self.tableForSliderView reloadData];
        [tempTableviewForFocus reloadData];
        [self refreshTableviewByEPGTime];
        //        [self.table reloadData];
        
    }];
    double delayInSeconds = 1;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, mainQueue, ^{
        //        [self.tableForSliderView reloadData];
        [tempTableviewForFocus reloadData];
        [self refreshTableviewByEPGTime];
        //        [self.table reloadData];
    });
    
    NSLog(@"zhengzihaisdhiashdaisdisisiso");
    //    [USER_DEFAULT setObject:self.video.dicChannl forKey:@"VideoTouchOtherViewdicChannl"];
    [self updateFullScreenDic];
    
    NSNotification *notificationX =[NSNotification notificationWithName:@"refreshChannelTableNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notificationX];

}
-(void)tableViewDataRefreshForSDTMonitorSMT
{
    NSLog(@"SDTSDTSDTSDTSTD！！！");
    NSLog(@" 机顶盒发送通知，需要刷新节目了 ==");
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
    [request startAsynchronous];   //异步
    getLastCategoryArr = self.categorys; //[USER_DEFAULT objectForKey:@"serviceData_Default"];
    getLastRecFileArr  = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
    WEAKGET
    [request setCompletionBlock:^{
        
        NSDictionary *response = httpRequest.responseString.JSONValue;
        
        //将数据本地化
        [USER_DEFAULT setObject:response forKey:@"TVHttpAllData"];
        NSArray *data1 = response[@"service"];
        NSArray *recFileData = response[@"rec_file_info"];
        NSLog(@"recFileData %@",recFileData);
        [USER_DEFAULT setObject:recFileData forKey:@"categorysToCategoryViewContainREC"];
        self.serviceData = (NSMutableArray *)data1;
        self.categorys = (NSMutableArray *)response[@"category"];  //新加，防止崩溃的地方
        
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        //判断是不是需要刷新顶部的YLSlider
        if ([self judgeIfNeedRefreshSliderView:self.categorys recFileArr:recFileData lastCategoryArr:getLastCategoryArr lastRECFileArr:getLastRecFileArr]) {
            [_slideView removeFromSuperview];
            _slideView = nil;
            [self tableViewDataRefreshForMjRefresh_ONEMinute];
            //            [self tableViewDataRefreshForMjRefresh];
            
        }else if(getLastCategoryArr.count > 0 && self.categorys.count == 0 && getLastRecFileArr.count !=0)
        {
            
            [_slideView removeFromSuperview];
            _slideView = nil;
            [self tableViewDataRefreshForMjRefresh_ONEMinute];
        }else if (getLastCategoryArr.count == 0 && self.categorys.count > 0  )
        {
            [_slideView removeFromSuperview];
            _slideView = nil;
            [self tableViewDataRefreshForMjRefresh_ONEMinute];
        }
        
        
        if (ISNULL(self.serviceData) || self.serviceData == nil|| self.serviceData == nil) {
            NSLog(@"mediaDeliveryUpdate SDTSDT 方法中触发refresh方法");
            [self tableViewDataRefreshForMjRefresh_ONEMinute];
        }
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        [self lineAndSearchBtnShow];
        
        NSString * YLSlideTitleViewButtonTagIndexStr = [USER_DEFAULT objectForKey:@"YLSlideTitleViewButtonTagIndexStr"];
        
        int YLSlideTitleViewButtonTagIndex = [YLSlideTitleViewButtonTagIndexStr  intValue];
        
        NSString *  indexforTableToNum = YLSlideTitleViewButtonTagIndexStr;
        
        self.tableForSliderView = [self.tableForDicIndexDic objectForKey:indexforTableToNum][1];
        
        if (YLSlideTitleViewButtonTagIndex < self.tableForDicIndexDic.count) {
            NSNumber * numTemp = [self.tableForDicIndexDic objectForKey:indexforTableToNum][0];
            
            NSInteger index = [numTemp integerValue];
            if (self.categorys.count > index) {
                [self returnDicTemp:index]; //根据是否有录制返回不同的item
            }else if(self.categorys.count == 0 && recFileData.count > 0)
            {
                [self firstOpenAppAutoPlay:0 diction:self.dicTemp];
                double delayInSeconds = 0.5;
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, mainQueue, ^{
                    NSIndexPath *indexPathNow = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self tableView:tempTableviewForFocus didSelectRowAtIndexPath:indexPathNow];
                });
            }else
            {
                return;
            }
        }
        
        //        [self.tableForSliderView reloadData];
        [tempTableviewForFocus reloadData];
        
        double delayInSeconds = 2;
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, mainQueue, ^{
            //            [self.tableForSliderView reloadData];
            [tempTableviewForFocus reloadData];
            
        });
        
        
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
        
        [self setSearchViewData ];
        NSLog(@"setSearchViewDatasetSearchViewData===3333");
        
        BOOL isHavePlayingChannel = NO;
        
        NSMutableArray * mutableArrTemp = [self.serviceData mutableCopy];
        if (recFileData.count > 0) {
            for (int i = 0; i < recFileData.count ; i++) {
                [mutableArrTemp addObject:recFileData[i]];
            }
        }
        
        for (int i = 0; i < mutableArrTemp.count; i++) {
            
            NSDictionary * serviceArrForJudge_dic = mutableArrTemp[i];
            BOOL isTwoDicEqual =  [GGUtil judgeTwoEpgDicIsEqual:epgDicToSocket TwoDic:serviceArrForJudge_dic];
            
            if (isTwoDicEqual == YES) {
                //找到了相匹配的节目，可以断定是正在播放的节目
                //看两个的信息是否完全相等，如果不相等，则替换dic
                isHavePlayingChannel = YES;
                if ([serviceArrForJudge_dic isEqual: epgDicToSocket] ) {
                    [self SDTfirstOpenAppAutoPlaySMT:rowIndex diction:dic];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }else
                {
                    //关闭当前正在播放的节目
                    [self.videoController.player stop];
                    [self.videoController.player shutdown];
                    [self.videoController.player.view removeFromSuperview];
                    
                    //修改字典信息
                    //历史记录信息和全部的信息
                    
                    NSMutableDictionary * mutableDicTemp = [dic mutableCopy];
                    [mutableDicTemp setObject:[serviceArrForJudge_dic copy] forKey:[NSString stringWithFormat:@"%ld",(long)rowIndex]];
                    dic = [mutableDicTemp mutableCopy];
                    
                    
                    //重新执行播放,并且要注意判断是不是加锁类型
                    
                    NSString * characterStr = [serviceArrForJudge_dic  objectForKey:@"service_character"];
                    
                    int program_character_int = [characterStr intValue];
                    
                    uint32_t character_And =  program_character_int &  0x02;
                    if (character_And > 0) {
                        // 此处代表需要记性机顶盒加密验证
                        NSNumber  *numIndex = [NSNumber numberWithInteger:rowIndex];
                        NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"LiveTouch",@"textThree",nil];
                        [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                        
                    }else //从加锁到不加锁正常播放的步骤，但是要注意得如果用户此时还处于弹窗或者未输入密码界面，得去掉弹窗和输入密码
                    {
                        NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigDecoderPINShowNotific" object:nil userInfo:nil];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                        [STBAlert dismissWithClickedButtonIndex:1 animated:YES];
                        //======
                        //                        [self firstOpenAppAutoPlay:rowIndex diction:dic];
                        
                        [self SDTfirstOpenAppAutoPlaySMT:rowIndex diction:dic];
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                        
                    }
                    
                    return ;
                }
                
            }
            
        }
        
        //③如果有正在播放的节目，并且判断和正在播放的节目的dic信息是否相等，如果不相等则重新播放
        if (isHavePlayingChannel == NO) {
            //没有找到这个节目，则播放第一个视频
            
            //=======机顶盒加密
            NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:0 serviceListDic:self.dicTemp];
            if (characterStr != NULL && characterStr != nil) {
                BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                if (judgeIsSTBDecrypt == YES) {
                    // 此处代表需要记性机顶盒加密验证
                    NSNumber  *numIndex = [NSNumber numberWithInteger:0];
                    NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"firstOpenTouch",@"textThree",nil];
                    [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }else //正常播放的步骤
                {
                    [self SDTfirstOpenAppAutoPlaySMT:rowIndex diction:dic];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                    
                    double delayInSeconds = 0.5;
                    dispatch_queue_t mainQueue = dispatch_get_main_queue();
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, mainQueue, ^{
                        NSIndexPath *indexPathNow = [NSIndexPath indexPathForRow:0 inSection:0];
                        [self tableView:tempTableviewForFocus didSelectRowAtIndexPath:indexPathNow];
                    });
                }
            }else //正常播放的步骤
            {
                [self SDTfirstOpenAppAutoPlaySMT:rowIndex diction:dic];
                [self performChangeColor];
                
                double delayInSeconds = 0.5;
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, mainQueue, ^{
                    NSIndexPath *indexPathNow = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self tableView:tempTableviewForFocus didSelectRowAtIndexPath:indexPathNow];
                });
            }
        }
        //        [self.tableForSliderView reloadData];
        [tempTableviewForFocus reloadData];
        [self refreshTableviewByEPGTime];
        //        [self.table reloadData];
        
    }];
    double delayInSeconds = 1;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, mainQueue, ^{
        [self.tableForSliderView reloadData];
        [self refreshTableviewByEPGTime];
        [self.table reloadData];
    });
}
//判断列表变化后，是否把正在播放的那个节目给删除了，如果是的，则刷新列表，并且重新播放第一个视频
-(void)judgeVideoByDelete
{
    NSArray * arrHistoryNow = [USER_DEFAULT objectForKey:@"historySeed"];   //播放的历史
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
                allisNO = NO;
            }
            
        }
        
    }
    if (allisNO == NO) {
    }else
    {
        NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:0 serviceListDic:self.dicTemp];
        if (characterStr != NULL && characterStr != nil) {
            BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
            if (judgeIsSTBDecrypt == YES) {
                // 此处代表需要记性机顶盒加密验证
                NSNumber  *numIndex = [NSNumber numberWithInteger:0];
                NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"firstOpenTouch",@"textThree",nil];
                [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                firstOpenAPP = firstOpenAPP+1;
                
                firstfirst = NO;
            }else //正常播放的步骤
            {
                [self firstOpenAppAutoPlayZero:0 diction:self.dicTemp];
            }
        }else //正常播放的步骤
        {
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
    //    [self hideTabBar];
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
    [self getServiceDataForIPChange];
}
-(void)setStateNonatic
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willplay) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:nil];
    
    // 播放状态改变，可配合playbakcState属性获取具体状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willplay) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
}
#pragma mark - 如果视频20秒内不播放，则显示这个文字提示
//如果视频20秒内不播放，则显示这个文字提示
-(void)playClick  //:(NSTimer *)timer
{
    if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
        
    }else{
        [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
    }
    [GGUtil postnoPlayShowNotic];
    NSLog(@"play-Click 4444");
    NSLog(@"postnoPlayShowNotic bbbbb");
}
#pragma mark - 将要播放的通知
-(void)willplay
{
    NSLog(@"结束==计时===已经播放");
    //取消掉20秒后显示提示文字的方法，如果视频要播放呀，则去掉不能播放的字样
    [self removeTipLabAndPerformSelector];
    NSLog(@"从willplay跳转过去 取消25秒的等待6");
    playState = YES;
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
    if (self.videoController.loadState & MPMovieLoadStateStalled) {
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
    }
}
-(void)judegeIsPlaying
{
    if (self.videoController.loadState & MPMovieLoadStateStalled) {
    }else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(judegeIsPlaying) object:nil];
    }
}

#pragma mark - 计算进度条
-(void)caculatorProgress
{
    
    //** 计算进度条
    if(self.event_startTime.length != 0 || self.event_endTime.length != 0)
    {
        NSLog(@"self.topProgressView121 %@",self.topProgressView);
        
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
            eventNameTemp = eventName1;
            eventName2 = eventNameTemp;
            
            progressEPGArrIndex = 0;
            
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress:) userInfo:dict repeats:YES];
            
            int tempIndex =progressEPGArrIndex;
            NSString * tempIndexStr = [NSString stringWithFormat:@"%d",tempIndex];
            [USER_DEFAULT setObject:tempIndexStr  forKey:@"nowChannelEPGArrIndex"];
            //此处应该加一个方法，判断 endtime - starttime 之后，让进度条刷新从新计算
            NSInteger endTime =[self.event_endTime intValue ];
            
            NSString *nowDate = [GGUtil GetNowTimeString];
            NSInteger endTimeCutStartTime =endTime-[nowDate integerValue];
            
            if (endTimeCutStartTime > 0) {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressRefresh) object:nil];
                [self performSelector:@selector(progressRefresh) withObject:nil afterDelay:endTimeCutStartTime];
            }
        }
        
        
    }else{
        [self removeTopProgressView]; //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
    }
//    self.topProgressView.alpha = 1;
}


/////////////其他页面的播放通知事件
//row 代表是service的每个类别下的序列是几，dic代表每个类别下的service
-(void)VideoTouchNoificClick: (NSNotification *)text//(NSInteger)row diction :(NSDictionary *)dic  //:(NSNotification *)text{
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

    if(indexOfCategory == -1)
    {
        [self performSelector:@selector(NOChannelToPlay) withObject:nil afterDelay:0.5];//将CA PIN 的文

    }else
    {
        [self setCategoryItem:indexOfCategory];

        if ([epgDicToSocket isKindOfClass:[NSDictionary class]]){
            if (epgDicToSocket.count > 14) { //录制
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self addHistory:row diction:dic];
                });
                if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
                    [GGUtil postnoPlayShowNotic];
                    NSLog(@"postnoPlayShowNotic ccccc");
                    NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
                    [GGUtil postsetChannelNameAndEventNameNotic:nowPlayingDic];

                    self.TVSubAudioDic = epgDicToSocket;
                    self.TVChannlDic = self.dicTemp;
                    tempBoolForServiceArr = YES;
                    tempArrForServiceArr =  self.categoryModel.service_indexArr;
                    tempDicForServiceArr = self.TVChannlDic;
                    self.video.dicChannl = [tempDicForServiceArr mutableCopy];
                    if ([tempArrForServiceArr isKindOfClass:[NSArray class]]){
                        self.video.channelCount = tempArrForServiceArr.count;
                    }
                    NSString * serviceName = [epgDicToSocket objectForKey:@"service_name"];
                    NSString * eventName = [epgDicToSocket objectForKey:@"event_name"];
                    if ([eventName isEqualToString:@""]) {
                        self.service_videoname = serviceName;
                    }else
                    {
                        self.service_videoname = [NSString stringWithFormat:@"%@_%@",serviceName,eventName];
                    }
                    self.service_videoindex= @"";
                    self.event_videoname = @"";


                    //== 录制时间赋值
                    if (epgDicToSocket.count > 14) {  //录制

                        //录制节目的时间
                        self.event_startTime = [epgDicToSocket objectForKey:@"record_time"];
                        NSString * RECStartTime = [epgDicToSocket objectForKey:@"record_time"];
                        NSString * RECDurationTime = [epgDicToSocket objectForKey:@"duration"];
                        self.event_endTime = [NSString stringWithFormat:@"%ld",[RECStartTime integerValue] + [RECDurationTime integerValue]];

                        BOOL isEventStartTimeBigNowTime = NO;//= [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
                        if (isEventStartTimeBigNowTime == YES) {
                            self.event_videoname = @"";
                            self.event_startTime = @"";
                            self.event_endTime = @"";
                            [GGUtil postsetTimeAndProgressIsNullNotific];
                            [self removeTopProgressView];
                        }
                        self.video.startTime = self.event_startTime;
                        self.video.endTime = self.event_endTime;
                        if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
                            //                            self.video.startTime = @"0";
                            //                            self.video.endTime = @"0";
                            self.event_videoname = @"";
                            [GGUtil postsetTimeAndProgressIsNullNotific];
                            [self removeTopProgressView];
                            NSLog(@"hidenhidenhidenhiden 88888888");
                        }else{
                            self.video.startTime = self.event_startTime;
                            self.video.endTime = self.event_endTime;
                            NSLog(@"hidenhidenhidenhiden 88888888 aaaaaaaaa");
                        }

                        NSString * acc = self.video.startTime;
                        NSString * cca = self.video.endTime;
                        NSLog(@"acc == %@",acc);
                        NSLog(@"cca == %@",cca);

                    }

                    //                    [self.tableForSliderView reloadData];
                    [tempTableviewForFocus reloadData];
                    [self refreshTableviewByEPGTime];



                    if (epgDicToSocket.count > 14) {  //录制

                        NSNotification *notificationREC =[NSNotification notificationWithName:@"setRECTimeNotific" object:nil userInfo:nil];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notificationREC];

                        //开始进行数据赋值
                        NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
                        [GGUtil postsetChannelNameAndEventNameNotic:nowPlayingDic];
                        [self removeTopProgressView];

                    }else
                    {
                        [GGUtil postTimerOfEventTimeNotific];
                        [self caculatorProgress];
                    }
                    return ;

                }else{
                    [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
                }
                [self playRECVideo:epgDicToSocket];

                self.TVSubAudioDic = epgDicToSocket;

                self.TVChannlDic = self.dicTemp;

                tempBoolForServiceArr = YES;
                tempArrForServiceArr =  self.categoryModel.service_indexArr;
                tempDicForServiceArr = self.TVChannlDic;

                self.video.dicChannl = [tempDicForServiceArr mutableCopy];
                NSLog(@"self.video.dicChannl33 %@",self.video.dicChannl);

                if ([tempArrForServiceArr isKindOfClass:[NSArray class]]){
                    self.video.channelCount = tempArrForServiceArr.count;
                }
                //*********

                //        self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];

                NSString * serviceName = [epgDicToSocket objectForKey:@"service_name"];
                NSString * eventName = [epgDicToSocket objectForKey:@"event_name"];
                if ([eventName isEqualToString:@""]) {
                    self.service_videoname = serviceName;
                }else
                {
                    self.service_videoname = [NSString stringWithFormat:@"%@_%@",serviceName,eventName];
                }


                //            self.service_videoname = [epgDicToSocket objectForKey:@"file_name"];
                self.service_videoindex= @"";
                //        self.event_videoname = [epgDicToSocket objectForKey:@"event_name"];
                self.event_videoname = @"";





            }else//直播
            {
                //快速切换频道名称和节目名称
                NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];



                NSLog(@"dic: %@",dic);
                NSLog(@"self.dicTemp: %@",self.dicTemp);
                NSLog(@"epgDicToSocket: %@",epgDicToSocket);
                NSLog(@"row: %ld",(long)row);
                /*此处添加一个加入历史版本的函数*/

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self addHistory:row diction:self.dicTemp];
                });
                if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
                    [GGUtil postnoPlayShowNotic];
                    NSLog(@"postnoPlayShowNotic dddddd");
                    [GGUtil postsetChannelNameAndEventNameNotic:nowPlayingDic];

                    [self.videoController setaudioOrSubtRowIsZero];
                    NSArray * audio_infoArr = [[NSArray alloc]init];
                    NSArray * subt_infoArr = [[NSArray alloc]init];
                    NSArray * epg_infoArr = [[NSArray alloc]init];
                    //****


                    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
                    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
                    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
                    if (audio_infoArr.count > 0 && subt_infoArr.count > 0) {

                        int audiopidTemp;
                        audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];

                        socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];

                        socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];

                    }else
                    {
                        if (audio_infoArr.count > 0 ) {
                            int audiopidTemp;
                            audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];

                            socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];

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
                    //********
                    [self SetService_videoindex:epgDicToSocket];
                    //此处获得该EPG的当前信息，否则我们播放的信息还是它之前的信息
                    for (int i = 0; i<self.serviceData.count; i++) {

                        BOOL isYes =  [GGUtil judgeTwoEpgDicIsEqual:self.serviceData[i] TwoDic:epgDicToSocket]; //此处通过判断两个EPG信息是否相等来找到两个一样的EPG信息
                        if(isYes == YES)
                        {
                            epgDicToSocket = self.serviceData[i];   //给epgDicToSocket 赋新值
                        }
                    }
                    self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
                    epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
                    if (epg_infoArr.count == 0 || epg_infoArr == nil) {
                        //            return;

                        self.event_videoname = @"";
                        self.event_startTime = @"";
                        self.event_endTime = @"";
                        [GGUtil postsetTimeAndProgressIsNullNotific];
                        [self removeTopProgressView];

                    }else
                    {
                        self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                        self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
                        self.video.startTime = self.event_startTime;
                        self.video.endTime = self.event_endTime;
                        if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
                            self.video.startTime = @"0";
                            self.video.endTime = @"0";
                            self.event_videoname = @"";
                            [GGUtil postsetTimeAndProgressIsNullNotific];
                            [self removeTopProgressView];
                            NSLog(@"hidenhidenhidenhiden 999999999 aaaaaaaaa");

                        }else{
                            self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
                            self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                            self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
                            [GGUtil postsetTimeAndProgressIsShowNotific];
                            NSLog(@"hidenhidenhidenhiden 999999999 aaaaaaaaa");
                        }

                    }

                    isEventStartTimeBiger_NowTime = NO;
                    BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
                    if (isEventStartTimeBigNowTime == YES) {
                        self.event_videoname = @"";
                        self.event_startTime = @"";
                        self.event_endTime = @"";
                        [GGUtil postsetTimeAndProgressIsNullNotific];
                        [self removeTopProgressView];
                    }

                    self.TVSubAudioDic = epgDicToSocket;

                    self.TVChannlDic = self.dicTemp;

                    tempBoolForServiceArr = YES;
                    tempArrForServiceArr =  self.categoryModel.service_indexArr;
                    tempDicForServiceArr = self.TVChannlDic;

                    self.video.dicChannl = [tempDicForServiceArr mutableCopy];

                    NSLog(@"self.video.dicChannl44 %@",self.video.dicChannl);

                    if ([tempArrForServiceArr isKindOfClass:[NSArray class]]){
                        self.video.channelCount = tempArrForServiceArr.count;
                    }

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

                    NSNumber * currentIndexForCategory = [NSNumber numberWithInt:indexOfCategory];
                    NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndexForCategory,@"currentIndex", nil];
                    //创建通知
                    NSNotification *notification12 =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
                    [[NSNotificationCenter defaultCenter] postNotification:notification12];
                    //                    [self.tableForSliderView reloadData];
                    [tempTableviewForFocus reloadData];
                    //                    [self.table reloadData];

                    NSArray * serviceArrForJudge =  self.serviceData;
                    //这里获得当前焦点
                    NSArray * arrForServiceByCategory = [[NSArray alloc]init];
                    if ([self.categorys isKindOfClass:[NSMutableArray class]] && [epgDicToSocket isKindOfClass:[NSDictionary class]]){
                        if (epgDicToSocket.count > 14) { //录制

                            arrForServiceByCategory = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];

                        }else
                        {

                            if (self.categorys.count >indexOfCategory ) {
                                arrForServiceByCategory = [self.categorys[indexOfCategory] objectForKey:@"service_index"];
                            }


                        }
                    }
                    if ([arrForServiceByCategory isKindOfClass:[NSArray class]]){

                        for (int i = 0; i< arrForServiceByCategory.count; i++) {
                            NSLog(@"arrForServiceByCategory %lu",(unsigned long)arrForServiceByCategory.count);

                            if ([epgDicToSocket isKindOfClass:[NSDictionary class]]){
                                if (epgDicToSocket.count > 14) { //录制

                                    NSDictionary * serviceForJudgeDic = arrForServiceByCategory[i];

                                    //此处需要验证epg节目中的三个值是否相等 ，这里第一个参数代表最新数据
                                    BOOL isEqualForTwoDic = [GGUtil judgeTwoEpgDicIsEqual: serviceForJudgeDic TwoDic:epgDicToSocket];
                                    NSLog(@"isEqualForTwoDic %d",isEqualForTwoDic);
                                    if (isEqualForTwoDic) {

                                        int indexForJudgeService = i;
                                        indexOfServiceToRefreshTable =indexForJudgeService;

                                        //选中数据变蓝
                                        [self tableViewCellToBlue:indexOfCategory indexhah:indexForJudgeService AllNumberOfService:arrForServiceByCategory.count];

                                    }
                                }else
                                {
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
                            }
                        }

                    }

                    [tableForSliderView reloadData];

                    tempBoolForServiceArr = YES;
                    tempArrForServiceArr =  self.categoryModel.service_indexArr;
                    tempDicForServiceArr = self.TVChannlDic;

                    self.video.dicChannl = [tempDicForServiceArr mutableCopy];

                    NSLog(@"self.video.dicChannl55 %@",self.video.dicChannl);

                    if ([tempArrForServiceArr isKindOfClass:[NSArray class]]){
                        self.video.channelCount = tempArrForServiceArr.count;
                    }

                    //== 录制时间赋值
                    if (epgDicToSocket.count > 14) {  //录制

                        //录制节目的时间
                        self.event_startTime = [epgDicToSocket objectForKey:@"record_time"];
                        NSString * RECStartTime = [epgDicToSocket objectForKey:@"record_time"];
                        NSString * RECDurationTime = [epgDicToSocket objectForKey:@"duration"];
                        self.event_endTime = [NSString stringWithFormat:@"%ld",[RECStartTime integerValue] + [RECDurationTime integerValue]];

                        BOOL isEventStartTimeBigNowTime = NO;//= [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
                        if (isEventStartTimeBigNowTime == YES) {
                            self.event_videoname = @"";
                            self.event_startTime = @"";
                            self.event_endTime = @"";
                            [GGUtil postsetTimeAndProgressIsNullNotific];
                            [self removeTopProgressView];
                        }
                        self.video.startTime = self.event_startTime;
                        self.video.endTime = self.event_endTime;
                        if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
                            //                            self.video.startTime = @"0";
                            //                            self.video.endTime = @"0";
                            self.event_videoname = @"";
                            NSLog(@"hidenhidenhidenhiden 101010101010101");
                        }else{
                            self.video.startTime = self.event_startTime;
                            self.video.endTime = self.event_endTime;
                            NSLog(@"hidenhidenhidenhiden 101010101010101 aaaaaaaaa");
                        }

                        NSString * acc = self.video.startTime;
                        NSString * cca = self.video.endTime;
                        NSLog(@"acc == %@",acc);
                        NSLog(@"cca == %@",cca);

                    }



                    [USER_DEFAULT setObject:self.video.dicChannl forKey:@"VideoTouchOtherViewdicChannl"];
                    NSNumber * channelCountNum = [NSNumber numberWithInt:self.video.channelCount];
                    [USER_DEFAULT setObject:channelCountNum forKey:@"VideoTouchOtherViewchannelCount"];

                    NSLog(@"self.video.dicChannl88==33");

                    if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
                        //                        self.video.startTime = @"0";
                        //                        self.video.endTime = @"0";
                    }else{
                        self.video.startTime = self.event_startTime;
                        self.video.endTime = self.event_endTime;
                    }

                    [self updateFullScreenDic];

                    //                    [self.tableForSliderView reloadData];
                    [tempTableviewForFocus reloadData];
                    [self refreshTableviewByEPGTime];
                    [self caculatorProgress];
                    return ;

                }
                else{
                    [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
                }
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
                    int audiopidTemp;
                    audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];
                    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];
                    socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
                }else
                {
                    if (audio_infoArr.count > 0 ) {
                        int audiopidTemp;
                        audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];

                        socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];

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


                //********
                [self SetService_videoindex:epgDicToSocket];
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
                    //            return;

                    self.event_videoname = @"";
                    self.event_startTime = @"";
                    self.event_endTime = @"";
                    [GGUtil postsetTimeAndProgressIsNullNotific];
                    [self removeTopProgressView];
                }else
                {
#pragma mark - 需要注意名称变化
                    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
                    self.video.startTime = self.event_startTime;
                    self.video.endTime = self.event_endTime;
                    if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
                        self.video.startTime = @"0";
                        self.video.endTime = @"0";
                        self.event_videoname = @"";
                        [GGUtil postsetTimeAndProgressIsNullNotific];
                        [self removeTopProgressView];
                        NSLog(@"hidenhidenhidenhiden bbbbbbb");

                    }
                    else{
                        self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
                        self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                        self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
                        [GGUtil postsetTimeAndProgressIsShowNotific];
                        NSLog(@"hidenhidenhidenhiden bbbbbbb aaaaaaaaa");
                    }

                }

                isEventStartTimeBiger_NowTime = NO;
                BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
                if (isEventStartTimeBigNowTime == YES) {
                    self.event_videoname = @"";
                    self.event_startTime = @"";
                    self.event_endTime = @"";
                    [GGUtil postsetTimeAndProgressIsNullNotific];
                }

                self.TVSubAudioDic = epgDicToSocket;

                self.TVChannlDic = self.dicTemp;

                tempBoolForServiceArr = YES;
                tempArrForServiceArr =  self.categoryModel.service_indexArr;
                tempDicForServiceArr = self.TVChannlDic;

                self.video.dicChannl = [tempDicForServiceArr mutableCopy];
                if ([tempArrForServiceArr isKindOfClass:[NSArray class]]){
                    self.video.channelCount = tempArrForServiceArr.count;
                }
                [self judgeAllArgueIsZero];
                [self getsubt];
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];

                    if (self.showTVView == YES) {
                        self.videoController.socketView1 = self.socketView;
                        [self.socketView  serviceTouch ];
                    }else
                    {
                        [self ifNotISTVView];
                    }
                });
            }
        }

        NSNumber * currentIndexForCategory = [NSNumber numberWithInt:indexOfCategory];
        NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndexForCategory,@"currentIndex", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        //        [self.tableForSliderView reloadData];
        //        [self.table reloadData];
        [tempTableviewForFocus reloadData];

        //        __NSConstantString * abc =

        NSArray * serviceArrForJudge =  self.serviceData;
        //这里获得当前焦点
        NSArray * arrForServiceByCategory = [[NSArray alloc]init];
        NSLog(@" self.categorys11 %@",[self.categorys class]);
        NSLog(@" self.categorys22 %@",[self.categorys superclass]);
        NSLog(@" epgDicToSocket %@",[epgDicToSocket class]);
        NSLog(@" epgDicToSocket %@",[epgDicToSocket superclass]);
        if ([self.categorys isKindOfClass:[NSArray class]] && [epgDicToSocket isKindOfClass:[NSDictionary class]]){
            if (epgDicToSocket.count > 14) { //录制

                arrForServiceByCategory = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];

            }else
            {

                if (self.categorys.count >indexOfCategory ) {
                    arrForServiceByCategory = [self.categorys[indexOfCategory] objectForKey:@"service_index"];
                }


            }
        }
        if ([arrForServiceByCategory isKindOfClass:[NSArray class]]){

            for (int i = 0; i< arrForServiceByCategory.count; i++) {
                NSLog(@"arrForServiceByCategory %lu",(unsigned long)arrForServiceByCategory.count);

                if ([epgDicToSocket isKindOfClass:[NSDictionary class]]){
                    if (epgDicToSocket.count > 14) { //录制

                        NSDictionary * serviceForJudgeDic = arrForServiceByCategory[i];

                        //此处需要验证epg节目中的三个值是否相等 ，这里第一个参数代表最新数据
                        BOOL isEqualForTwoDic = [GGUtil judgeTwoEpgDicIsEqual: serviceForJudgeDic TwoDic:epgDicToSocket];
                        NSLog(@"isEqualForTwoDic %d",isEqualForTwoDic);
                        if (isEqualForTwoDic) {

                            int indexForJudgeService = i;
                            indexOfServiceToRefreshTable =indexForJudgeService;

                            //选中数据变蓝
                            [self tableViewCellToBlue:indexOfCategory indexhah:indexForJudgeService AllNumberOfService:arrForServiceByCategory.count];

                        }
                    }else
                    {
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
                }
            }

        }

        [tableForSliderView reloadData];

        tempBoolForServiceArr = YES;
        tempArrForServiceArr =  self.categoryModel.service_indexArr;
        tempDicForServiceArr = self.TVChannlDic;

        self.video.dicChannl = [tempDicForServiceArr mutableCopy];

        NSLog(@"self.video.dicChannl55 %@",self.video.dicChannl);

        if ([tempArrForServiceArr isKindOfClass:[NSArray class]]){
            self.video.channelCount = tempArrForServiceArr.count;
        }

        [USER_DEFAULT setObject:self.video.dicChannl forKey:@"VideoTouchOtherViewdicChannl"];
        NSNumber * channelCountNum = [NSNumber numberWithInt:self.video.channelCount];
        [USER_DEFAULT setObject:channelCountNum forKey:@"VideoTouchOtherViewchannelCount"];

        NSLog(@"self.video.dicChannl88==33");
        [self updateFullScreenDic];

    }


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
    return -1;
    
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self addHistory:row diction:dic];
    });
    
    //__
    if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
        [GGUtil postnoPlayShowNotic];
        NSLog(@"postnoPlayShowNotic eeeee");
        return ;
        
    }else{
        [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
    }
    
    NSArray * audio_infoArr = [[NSArray alloc]init];
    NSArray * subt_infoArr = [[NSArray alloc]init];
    
    NSArray * epg_infoArr = [[NSArray alloc]init];
    //****
    
    
    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
    
    if (  (audio_infoArr.count > audioIndex && subt_infoArr.count > subtIndex )  ) {
        socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audioIndex] objectForKey:@"audio_pid"];
        NSLog(@"socketView.socket_ServiceModel.audio_pid :%@",socketView.socket_ServiceModel.audio_pid);
        socketView.socket_ServiceModel.subt_pid = [subt_infoArr[subtIndex] objectForKey:@"subt_pid"];
        NSLog(@"socketView.socket_ServiceModel.subt_pid :%@",socketView.socket_ServiceModel.subt_pid);
    }else if(audio_infoArr.count == 0  || subt_infoArr.count == 0 )
    {
        if (audio_infoArr.count == 0 && subt_infoArr.count >0) {
            socketView.socket_ServiceModel.audio_pid = @"";
            socketView.socket_ServiceModel.subt_pid = [subt_infoArr[subtIndex] objectForKey:@"subt_pid"];
        }else if (audio_infoArr.count > 0 && subt_infoArr.count == 0)
        {
            
            socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audioIndex] objectForKey:@"audio_pid"];
            socketView.socket_ServiceModel.subt_pid = @"";
            
        }else if (subt_infoArr.count > 0 && subt_infoArr.count == 0)
        {
            
            socketView.socket_ServiceModel.audio_pid = @"";
            socketView.socket_ServiceModel.subt_pid = [subt_infoArr[subtIndex] objectForKey:@"subt_pid"];
            
        }else
        {
            socketView.socket_ServiceModel.audio_pid = @"";
            socketView.socket_ServiceModel.subt_pid = @"";
        }
    }
    else
    {
        return;
    }
    
    
    [self SetService_videoindex:epgDicToSocket];
    
    self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
    epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
    
    
    if (epg_infoArr.count > 0) {
        self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
        self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
        self.video.startTime = self.event_startTime;
        self.video.endTime = self.event_endTime;
        if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
            self.video.startTime = @"0";
            self.video.endTime = @"0";
            self.event_videoname = @"";
            [GGUtil postsetTimeAndProgressIsNullNotific];
            [self removeTopProgressView];
            NSLog(@"hidenhidenhidenhiden cccccccc ");
            
        }else{
            self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
            self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
            self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
            [GGUtil postsetTimeAndProgressIsShowNotific];
            NSLog(@"hidenhidenhidenhiden cccccccc aaaaaaaaa");
        }
    }else
    {
        self.event_videoname = @"";
        self.event_startTime = @"";
        self.event_endTime = @"";
        [GGUtil postsetTimeAndProgressIsNullNotific];
        [self removeTopProgressView];
    }
    
    
    isEventStartTimeBiger_NowTime = NO;
    BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
    if (isEventStartTimeBigNowTime == YES) {
        self.event_videoname = @"";
        self.event_startTime = @"";
        self.event_endTime = @"";
        [GGUtil postsetTimeAndProgressIsNullNotific];
        [self removeTopProgressView];
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
/////////////本页面的显示播放，打开APP的时候自动播放第一个视频
//row 代表是service的每个类别下的序列是几，dic代表每个类别下的service
-(void)firstOpenAppAutoPlay : (NSInteger)row diction :(NSDictionary *)dic  //:(NSNotification *)text{
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSLog(@"dispatch_get_global_queue 播放的第二个方法");
        [self updateFullScreenDic];

        if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
            [GGUtil postnoPlayShowNotic];
            NSLog(@"postnoPlayShowNotic ffffff");
            return ;

        }else{
            [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
        }
        NSLog(@"dispatch_get_global_queue 播放的第二个方法==结束");
    });
    if (self.showTVView == YES) {
        NSLog(@"已经跳转到firstopen方法");
        [self removeLabAndAddIndecatorView];
        [USER_DEFAULT setObject:@"no" forKey:@"alertViewHasPop"];
        NSMutableDictionary * epgDicToSocket = [[dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]] mutableCopy];
        if (epgDicToSocket.count > 14) {  //录制

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self addHistory:row diction:dic];
            });
            [self playRECVideo:epgDicToSocket];
        }else
        {
            //快速切换频道名称和节目名称
            NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
            [GGUtil postsetChannelNameAndEventNameNotic:nowPlayingDic];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"dispatch_get_global_queue 播放的第三个方法");
                [self addHistory:row diction:dic];
                NSLog(@"dispatch_get_global_queue 播放的第三个方法 == 结束");
            });
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

                int audiopidTemp;
                audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];

                socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];
                //                socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
                socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
            }else
            {
                if (audio_infoArr.count > 0 ) {

                    int audiopidTemp;
                    audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];

                    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];
                    //                    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
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
            //********
            [self SetService_videoindex:epgDicToSocket];

            self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];

            NSLog(@" self.service_videoname %@",self.service_videoname);

            epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];

            if (epg_infoArr.count > 0) {
                self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
                self.video.startTime = self.event_startTime;
                self.video.endTime = self.event_endTime;
                NSLog(@"[[GGUtil GetNowTimeString] intValue] %d",[[GGUtil GetNowTimeString] intValue]);
                NSLog(@"[self.video.endTime intValue] %d",[self.video.endTime intValue]);
                NSLog(@"[self.video.startTime intValue] %d",[self.video.startTime intValue]);
                if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
                    self.video.startTime = @"0";
                    self.video.endTime = @"0";
                    self.event_videoname = @"";
                    [GGUtil postsetTimeAndProgressIsNullNotific];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self removeTopProgressView];
                    });
                    NSLog(@"hidenhidenhidenhiden dddddddd");

                }else
                {
                    self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
                    NSLog(@"replaceEventNameNotific firstOpen :%@",self.event_videoname);
                    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
                    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
                    NSLog(@"hidenhidenhidenhiden dddddddd aaaaaaaaa");

                }
            }else
            {
                self.event_videoname = @"";
                self.event_startTime = @"";
                self.event_endTime = @"";
                [GGUtil postsetTimeAndProgressIsNullNotific];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeTopProgressView];
                });
            }
            isEventStartTimeBiger_NowTime = NO;
            BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
            if (isEventStartTimeBigNowTime == YES) {
                self.event_videoname = @"";
                self.event_startTime = @"";
                self.event_endTime = @"";
                [GGUtil postsetTimeAndProgressIsNullNotific];
                [self removeTopProgressView];
            }else
            {
                [GGUtil postsetTimeAndProgressIsShowNotific];
            }
            self.TVSubAudioDic = epgDicToSocket;
            self.TVChannlDic = self.dicTemp;
            tempBoolForServiceArr = YES;
            tempArrForServiceArr =  self.categoryModel.service_indexArr;
            tempDicForServiceArr = self.TVChannlDic;
            [self getsubt];
            //*********

            //再单独开一个线程用于default操作
            dispatch_queue_t  queueA = dispatch_queue_create("firstOpen",DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queueA, ^{
                NSLog(@"dispatch_get_global_queue 播放的第四个方法");
                [USER_DEFAULT setObject:tempArrForServiceArr forKey:@"tempArrForServiceArr"];
                [USER_DEFAULT setObject:tempDicForServiceArr forKey:@"tempDicForServiceArr"];

                NSLog(@"dispatch_get_global_queue 播放的第四个方法 == 结束");
            });

            self.video.dicChannl = [tempDicForServiceArr mutableCopy];
            if ([tempArrForServiceArr isKindOfClass:[NSArray class]]){
                self.video.channelCount = tempArrForServiceArr.count;
            }
            [self judgeAllArgueIsZero];
            //此处销毁通知，防止一个通知被多次调用    // 1
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
            //注册通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];

            NSLog(@"    ");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"dispatch_get_global_queue 主线程Socket");

                if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
                    [GGUtil postnoPlayShowNotic];
                    NSLog(@"postnoPlayShowNotic gggggg");
                }else{
                    [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];

                    if (self.showTVView == YES) {
                        self.videoController.socketView1 = self.socketView;
                        [self.socketView  serviceTouch ];
                    }else
                    {
                        NSLog(@"已经不是TV页面了");
                        [self ifNotISTVView];
                    }
                }
                NSLog(@"dispatch_get_global_queue 主线程Socket == 结束");
            });
        }

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
        
        //录制节目,保存数据
        NSArray *recFileData = response[@"rec_file_info"];
        
        self.serviceData = (NSMutableArray *)data1;
        
        [self.activeView removeFromSuperview];
        self.activeView = nil;
        [self lineAndSearchBtnShow];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notHaveNetWork) object:nil];
        
        
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
            
            [self setCategoryAndREC:data RECFile:recFileData];
            
            if (data.count == 0 && recFileData.count == 0){ //没有数据
                
                
                //                     data1 = [USER_DEFAULT objectForKey:@"serviceData_Default"];
                self.serviceData = [USER_DEFAULT objectForKey:@"serviceData_Default"];
                //                    recFileData = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
                
                [self setCategoryAndREC:[USER_DEFAULT objectForKey:@"serviceData_Default"] RECFile:[USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"]];
                
                return ;
            }
            self.categorys = (NSMutableArray *)data;
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
            
            if (firstfirst == YES) {
                
                //=======机顶盒加密
                NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:0 serviceListDic:self.dicTemp];
                if (characterStr != NULL && characterStr != nil) {
                    BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                    if (judgeIsSTBDecrypt == YES) {
                        // 此处代表需要记性机顶盒加密验证
                        NSNumber  *numIndex = [NSNumber numberWithInteger:0];
                        NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"firstOpenTouch",@"textThree",nil];
                        [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                    }else //正常播放的步骤
                    {
                        [self firstOpenAppAutoPlayZero:0 diction:self.dicTemp];
                    }
                }else //正常播放的步骤
                {
                    [self firstOpenAppAutoPlayZero:0 diction:self.dicTemp];
                }
            }else
            {}
            
            
        }];
        
        
        [self initProgressLine];
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
    [GGUtil postremoveConfigCAPINShowNotific];
    NSString * CAPINIsIncorrect = NSLocalizedString(@"CAPINIsIncorrect", nil);
    CAAlert.title = CAPINIsIncorrect;
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
        NSString * DecoderPINIsIncorrect = NSLocalizedString(@"DecoderPINIsIncorrect", nil);
        STBAlert.title = DecoderPINIsIncorrect;
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
    
    NSString * STBTitle = NSLocalizedString(@"DecoderPIN", nil);
    STBAlert.title = STBTitle;
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
    NSString * CAAlertTitle = NSLocalizedString(@"CAPIN", nil);
    CAAlert.title = CAAlertTitle; //@"Please input your CA PIN";
    if (self.showTVView == YES) {
        [CAAlert show];
    }else
    {
        NSLog(@"已经不是TV页面了");
        [self ifNotISTVView];
    }
    CATextField_Encrypt.text = @"";
    CAAlert.dontDisppear = YES;
    [GGUtil postremoveConfigCAPINShowNotific];
}
#pragma mark - STB弹窗
-(void)popSTBAlertView: (NSNotification *)text
{
    [self stopVideoPlay];
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新，
        
        if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
            [GGUtil postnoPlayShowNotic];
            NSLog(@"postnoPlayShowNotic hhhhhh");
            return ;
            
        }else{
            [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
        }
        //
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
            NSString * STBTitle = NSLocalizedString(@"DecoderPIN", nil);
            STBAlert.title = STBTitle;
            if (self.showTVView == YES) {
                [STBAlert show];
            }else
            {
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
                NSString * DecoderPINLabel = NSLocalizedString(@"DecoderPINLabel", nil);
                STBTextField_Encrypt.placeholder = DecoderPINLabel;
            }
            
            
            NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigDecoderPINShowNotific" object:nil userInfo:nil];
            //通过通知中心发送通知,将decoderPIN 的文字和按钮删除掉。
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
        
        ///////+++++++++++++++++++++++
        int indexOfCategory = [self judgeCategoryType:epgDicFromPopSTB]; //从别的页面跳转过来，要先判断节目的类别，然后让底部的category转到相应的类别下
        
        NSArray * arrForServiceByCategory = [[NSArray alloc]init];
        if (epgDicFromPopSTB.count > 14) { //录制
            
            arrForServiceByCategory = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
            
        }else
        {
            if (self.categorys.count >indexOfCategory ) {
                arrForServiceByCategory = [self.categorys[indexOfCategory] objectForKey:@"service_index"];
            }
            
        }
        
        
        for (int i = 0; i< arrForServiceByCategory.count; i++) {
            NSLog(@"arrForServiceByCategory %lu",(unsigned long)arrForServiceByCategory.count);
            if (epgDicFromPopSTB.count > 14) { //录制
                
                NSDictionary * serviceForJudgeDic = arrForServiceByCategory[i];
                
                //此处需要验证epg节目中的三个值是否相等 ，这里第一个参数代表最新数据
                BOOL isEqualForTwoDic = [GGUtil judgeTwoEpgDicIsEqual: serviceForJudgeDic TwoDic:epgDicFromPopSTB];
                NSLog(@"isEqualForTwoDic %d",isEqualForTwoDic);
                if (isEqualForTwoDic) {
                    
                    int indexForJudgeService = i;
                    indexOfServiceToRefreshTable =indexForJudgeService;
                    
                    //选中数据变蓝
                    [self tableViewCellToBlue:indexOfCategory indexhah:indexForJudgeService AllNumberOfService:arrForServiceByCategory.count];
                    
                }
            }
            else
            {
                NSArray * serviceArrForJudge =  [USER_DEFAULT objectForKey:@"serviceData_Default"];
                NSDictionary * serviceForJudgeDic = serviceArrForJudge[[arrForServiceByCategory[i] intValue]-1];
                
                //此处需要验证epg节目中的三个值是否相等 ，这里第一个参数代表最新数据
                BOOL isEqualForTwoDic = [GGUtil judgeTwoEpgDicIsEqual: serviceForJudgeDic TwoDic:epgDicFromPopSTB];
                
//                if (isEqualForTwoDic) {
//
//                    int indexForJudgeService = i;
//                    indexOfServiceToRefreshTable =indexForJudgeService;
//
//                    //选中数据变蓝
//                    [self tableViewCellToBlue:indexOfCategory indexhah:indexForJudgeService AllNumberOfService:arrForServiceByCategory.count];
//                }
                
                int indexForJudgeService = i;
                if (isEqualForTwoDic) {
                    
                    //                    int indexForJudgeService = i;
                    indexOfServiceToRefreshTable =indexForJudgeService;
                    
                    //选中数据变蓝
                    [self tableViewCellToBlue:indexOfCategory indexhah:indexForJudgeService AllNumberOfService:arrForServiceByCategory.count];
                    
                    
                    double delayInSeconds = 0.4;
                    dispatch_queue_t mainQueue = dispatch_get_main_queue();
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, mainQueue, ^{
                        NSLog(@"延时执行的2秒");
                        
                        if (indexForJudgeService != 0 && indexForJudgeService < [tableForSliderView numberOfRowsInSection:0]) {
                            NSIndexPath * hahah = [NSIndexPath indexPathForRow:indexForJudgeService inSection:0];
                            //                        [tempTableviewForFocus scrollToRowAtIndexPath:hahah  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                            //                        [self.table scrollToRowAtIndexPath:hahah  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                            //                        [self.tableForTemp scrollToRowAtIndexPath:hahah  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                            [tableForSliderView scrollToRowAtIndexPath:hahah  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                        }
                    });
                }

            }
            
        }
        
    });
    
    if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:mediaDisConnect]) {
        
        NSNotification *notification3 =[NSNotification notificationWithName:@"IndicatorViewHiddenNotic" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification3];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            //取消掉提示文字和延迟方法
            [self removeTipLabAndPerformSelector];
            [GGUtil postIndicatorViewShowNotic];
        });
    }
    
}
#pragma mark - CA弹窗
-(void)popCAAlertView: (NSNotification *)text
{
    STBTouchType_Str = nil; //用于判断是哪个类型，如果此类型有数据，则代表是STB，否则代表是CA
    
    [USER_DEFAULT setObject:@"yes" forKey:@"alertViewHasPop"];
    
    
    //取消掉提示文字和延迟方法
    [self removeTipLabAndPerformSelector];
    [GGUtil postIndicatorViewShowNotic];
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
    
    if (CATuner_modeStr  == [socketView.socket_ServiceModel.service_tuner_mode  intValue] &&CANetwork_idStr  == [socketView.socket_ServiceModel.service_network_id  intValue] && CATs_idStr == [socketView.socket_ServiceModel.service_ts_id intValue] && CAService_idStr == [socketView.socket_ServiceModel.service_service_id intValue]) {
        //证明一致，是这个CA节目
        
        [self stopVideoPlay];
        
        [CAAlert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
        CAAlert.delegate =  self;
        NSString * CAAlertTitle = NSLocalizedString(@"CAPIN", nil);
        CAAlert.title = CAAlertTitle; //@"Please input your CA PIN";
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
            NSString * CAPINLabel = NSLocalizedString(@"CAPINLabel", nil);
            CATextField_Encrypt.placeholder = CAPINLabel;
        }
        
    }else
    {
        //不一致，不弹窗。===或者将窗口取消掉
        
        NSLog(@"不一致，不弹窗。===或者将窗口取消掉11");
        if(CAAlert){
            [CAAlert dismissWithClickedButtonIndex:1 animated:YES];
        }
    }
    [GGUtil postremoveConfigCAPINShowNotific];
}
#pragma mark - 弹窗点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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
    NSString * STBTitle = NSLocalizedString(@"DecoderPIN", nil);
    STBAlert.title = STBTitle; //将decoder PIN 的文字改成@"Please input your Decoder PIN"
}
-(void)changeCAAlertTitle
{
    NSString * CAAlertTitle = NSLocalizedString(@"CAPIN", nil);
    CAAlert.title = CAAlertTitle; //@"Please input your CA PIN";
    
}
-(BOOL)textFiledEditChanged:(NSNotification *)obj{
    
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    if (textField.text.length == 0) {
        STBAlert.dontDisppear = YES;
        CAAlert.dontDisppear = YES;
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
    //=====则去掉不能播放的字样，加上加载环
    [self removeLabAndAddIndecatorView];
    
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    
    /*此处添加一个加入历史版本的函数*/
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self addHistory:row diction:dic];
    });
    [USER_DEFAULT setObject:@"NO" forKey:@"audioOrSubtTouch"];
    [self.videoController setaudioOrSubtRowIsZero];
    
    NSArray * audio_infoArr = [[NSArray alloc]init];
    NSArray * subt_infoArr = [[NSArray alloc]init];
    
    NSArray * epg_infoArr = [[NSArray alloc]init];
    
    
    socketView.socket_ServiceModel = [[ServiceModel alloc]init];
    audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
    subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
    if (audio_infoArr.count > 1) {
        socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
    }
    if (subt_infoArr.count > 1) {
        socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
    }
    
    
    //********
    [self SetService_videoindex:epgDicToSocket];
    
    self.service_videoname = [epgDicToSocket objectForKey:@"service_name"];
    epg_infoArr = [epgDicToSocket objectForKey:@"epg_info"];
    if (epg_infoArr.count == 0) {
        
    }else
    {
        self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
        self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
        self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
        [GGUtil postsetTimeAndProgressIsShowNotific];
    }
    
    isEventStartTimeBiger_NowTime = NO;
    BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
    if (isEventStartTimeBigNowTime == YES) {
        self.event_videoname = @"";
        self.event_startTime = @"";
        self.event_endTime = @"";
        [GGUtil postsetTimeAndProgressIsNullNotific];
        [self removeTopProgressView];
    }
    self.TVSubAudioDic = epgDicToSocket;
    
    self.TVChannlDic = self.dicTemp;
    
    tempBoolForServiceArr = YES;
    tempArrForServiceArr =  self.categoryModel.service_indexArr;
    tempDicForServiceArr = self.TVChannlDic;
    [self getsubt];
    //*********
    
    [USER_DEFAULT setObject:tempArrForServiceArr forKey:@"tempArrForServiceArr"];
    [USER_DEFAULT setObject:tempDicForServiceArr forKey:@"tempDicForServiceArr"];
    self.video.dicChannl = [tempDicForServiceArr mutableCopy];
    
    NSLog(@"self.video.dicChannl77 %@",self.video.dicChannl);
    
    if ([tempArrForServiceArr isKindOfClass:[NSArray class]]){
        self.video.channelCount = tempArrForServiceArr.count;
    }
    
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
    
    self.video.channelId = self.service_videoindex;
    self.video.channelName = self.service_videoname;
    self.video.startTime = self.event_startTime;
    self.video.endTime = self.event_endTime;
    
    if (epg_infoArr.count > 0) {
        
        self.event_videoname = [epg_infoArr[0] objectForKey:@"event_name"];
        NSLog(@"replaceEventNameNotific firstOpen :%@",self.event_videoname);
        self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
        self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
    }else
    {
        self.event_videoname = @"";
        self.event_startTime = @"";
        self.event_endTime = @"";
        [GGUtil postsetTimeAndProgressIsNullNotific];
        [self removeTopProgressView];
    }
    //    self.event_startTime = [epg_infoArr[0] objectForKey:@"event_starttime"];
    //    self.event_endTime = [epg_infoArr[0] objectForKey:@"event_endtime"];
    if ([[GGUtil GetNowTimeString] intValue] > [self.video.endTime intValue] || [[GGUtil GetNowTimeString] intValue] < [self.video.startTime intValue]) {
        self.video.startTime = @"0";
        self.video.endTime = @"0";
        self.event_videoname = @"";
        [GGUtil postsetTimeAndProgressIsNullNotific];
        [self removeTopProgressView];
        NSLog(@"hidenhidenhidenhiden eeeeeeeeee aaaaaaaaa");
    }else{
        self.video.startTime = self.event_startTime;
        self.video.endTime = self.event_endTime;
        NSLog(@"hidenhidenhidenhiden eeeeeeeeee aaaaaaaaa");
    }
    NSLog(@"timeIsChange6 %@",self.video.startTime);
    
    NSDictionary *channlIdNameDic =[[NSDictionary alloc] initWithObjectsAndKeys:self.video.channelId,@"channelIdStr",self.video.channelName,@"channelNameStr", nil];
    //创建通知
    NSNotification *notification2 =[NSNotification notificationWithName:@"setChannelNameOrOtherInfoNotic" object:nil userInfo:channlIdNameDic];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
    
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
    //    }
    
}

//判断开始时间和当前时间的大小关系，如果开始时间比当前时间还大，那么则isEventStartTimeBiger_NowTime == yes
-(BOOL )judgeEventStartTime :(NSString *)videoName startTime :(NSString *)startTime endTime :(NSString *)endTime
{
    NSLog(@"panduan 时间");
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
    NSLog(@"准备刷新！！！");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endMJRefresh) object:nil];
    [self performSelector:@selector(endMJRefresh) withObject:nil afterDelay:EndMJRefreshTime];
    NSLog(@"12 秒后准备停止刷新");
    
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
    [request startAsynchronous];   //异步
    getLastCategoryArr = self.categorys; //[USER_DEFAULT objectForKey:@"serviceData_Default"];
    getLastRecFileArr  = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
    
    WEAKGET
    [request setCompletionBlock:^{
        NSDictionary *response = httpRequest.responseString.JSONValue;
        //将数据本地化
        [USER_DEFAULT setObject:response forKey:@"TVHttpAllData"];
        
        NSArray *data1 = response[@"service"];
        NSArray *data = response[@"category"];
        //录制节目,保存数据
        NSArray *recFileData = response[@"rec_file_info"];
        [USER_DEFAULT setObject:recFileData forKey:@"categorysToCategoryViewContainREC"];
        if (data.count == 0 && recFileData.count == 0){ //没有数据
            [USER_DEFAULT setObject:@"RecAndLiveNotHave" forKey:@"RECAndLiveType"];
            if (data1.count == 0 && recFileData.count == 0)
            {
                //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空
                
                if (response[@"data_valid_flag"] != NULL && ![response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                    
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
                [self NOChannelDataShow];
                [self removeTopProgressView]; //删除进度条
                isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
                [self removeTipLabAndPerformSelector];   //取消不能播放的文字
                [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
            }
            else
            {
                
                if ([[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"YES"]) {
                    if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 420) {
                        NSNotification *notification1 =[NSNotification notificationWithName:@"channeListIsShow" object:nil userInfo:nil];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification1];
                        
                    }
                    [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
                }
            }
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
            NSLog(@"两种都有 1");
            [USER_DEFAULT setObject:@"RecAndLiveAllHave" forKey:@"RECAndLiveType"];
            
            [self.CategoryAndREC removeAllObjects];
            [self.CategoryAndREC addObject:data];
            [self.CategoryAndREC addObject: recFileData];
        }
        
        if (data1.count == 0 && recFileData.count == 0)
        {
            //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空
            
            if (response[@"data_valid_flag"] != NULL && ![response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                
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
            
            [self NOChannelDataShow];
            [self removeTopProgressView]; //删除进度条
            isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
            [self removeTipLabAndPerformSelector];   //取消不能播放的文字
            [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
        }
        else
        {
            if ([[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"YES"]) {
                if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 420) {
                    NSNotification *notification1 =[NSNotification notificationWithName:@"channeListIsShow" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                    
                }
                [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
            }
            
        }
        self.serviceData = (NSMutableArray *)data1;
        self.categorys = (NSMutableArray *)response[@"category"];  //新加，防止崩溃的地方
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        if ([self judgeIfNeedRefreshSliderView:self.categorys recFileArr:recFileData lastCategoryArr:getLastCategoryArr lastRECFileArr:getLastRecFileArr]) {
            [_slideView removeFromSuperview];
            _slideView = nil;
            [self tableViewDataRefreshForMjRefresh_ONEMinute];
        }
        
        
        if (data1.count == 0 && recFileData.count == 0)
        {
            //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空
            
            if (response[@"data_valid_flag"] != NULL && ![response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                
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
            [self NOChannelDataShow];
            [self removeTopProgressView]; //删除进度条
            isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
            [self removeTipLabAndPerformSelector];   //取消不能播放的文字
            [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
            
        }else
        {
            if ([[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"YES"]) {
                if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 400) {
                    
                    
                    NSNotification *notification1 =[NSNotification notificationWithName:@"channeListIsShow" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                    
                }
                [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
            }
            
            if (recFileData.count > 0 && data1.count == 0 ) {
                //如果发现第二列，则展示REC这个数组
                NSArray * RECTempArr = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
                self.categoryModel = [[CategoryModel alloc]init];
                self.categoryModel.service_indexArr = RECTempArr;
                NSLog(@" self.categoryModel.service_indexArr==333 %@ ", self.categoryModel.service_indexArr);
                tempArrForServiceArr =  RECTempArr;
                numberOfRowsForTable = RECTempArr.count;
                
                /*
                 用于分别获取REC Json数据中的值
                 **/
                
                [self.dicTemp removeAllObjects];
                
                for (int i = 0; i< RECTempArr.count ; i++) {
                    [self.dicTemp setObject:RECTempArr[i] forKey:[NSString stringWithFormat:@"%d",i] ];
                }
                self.showTVView = YES;
                
                [self firstOpenAppAutoPlayZero:0 diction:self.dicTemp];
                
                firstOpenAPP = firstOpenAPP+1;
                firstfirst = NO;
                
                [self tableViewCellToBlue:0 indexhah:0 AllNumberOfService:self.dicTemp.count];
            }
        }
        [self activeViewRemove];
        NSString * YLSlideTitleViewButtonTagIndexStr = [USER_DEFAULT objectForKey:@"YLSlideTitleViewButtonTagIndexStr"];
        
        NSString *  indexforTableToNum =YLSlideTitleViewButtonTagIndexStr ;
        self.tableForSliderView = [self.tableForDicIndexDic objectForKey :indexforTableToNum] [1];
        
        NSNumber * numTemp = [self.tableForDicIndexDic objectForKey:indexforTableToNum][0];
        
        NSInteger index = [numTemp integerValue];
        
        [self returnDicTemp:index]; //根据是否有录制返回不同的item
        //        [self.tableForSliderView reloadData];
        [tempTableviewForFocus reloadData];
        [self refreshTableviewByEPGTime];
        // 模拟延迟2秒
        
        double delayInSeconds = 2;
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, mainQueue, ^{
            
            //            [self.tableForSliderView reloadData];
            [tempTableviewForFocus reloadData];
            
            [self refreshTableviewByEPGTime];
        });
        [NSThread sleepForTimeInterval:1.5];
        //    [self mediaDeliveryUpdate];
        //    [tableForSliderView reloadData];
        // 结束刷新
        
        [self.tableForSliderView.mj_header endRefreshing];
        
        //////eos  HT
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
            NSLog(@"categorys==||=MJRefresh");
            
        }];
        
        [self.table reloadData];
        [self setSearchViewData];
        NSLog(@"setSearchViewDatasetSearchViewData===4444");
    }];
}

#pragma mark - 主页一秒钟刷新一次
-(void)tableViewDataRefreshForMjRefresh_ONEMinute
{
    NSLog(@"yifenz 刷新");
    __block  NSArray *dataForData1;
    __block  NSArray *dataForrecFileData;
    
    NSLog(@"我要刷新一次呀=^_^");
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
    [request startAsynchronous];   //异步
    //
    getLastCategoryArr = self.categorys; //[USER_DEFAULT objectForKey:@"serviceData_Default"];
    getLastRecFileArr  = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
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
        dataForData1 = [data1 copy];
        dataForrecFileData = [recFileData copy];
        
        
        [self setCategoryAndREC:data1 RECFile:recFileData];
        if (data1.count == 0 && recFileData.count == 0)
        {
            //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空
            
            if (response[@"data_valid_flag"] != NULL && ![response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                
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
            [self NOChannelDataShow];
            [self removeTopProgressView]; //删除进度条
            isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
            
            if ([[USER_DEFAULT objectForKey:@"playStateType"] isEqualToString:deliveryStopTip]) {
                
            }else{
                [self removeTipLabAndPerformSelector];   //取消不能播放的文字
            }
            
            [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
            
            [self showDelivaryStopped];
        }else if(data1.count == 0 && recFileData.count > 0)
        {
            [self newSlideView];
        }
        
        if ( data1.count != 0 ){
            if ( data1.count == 0 && recFileData.count == 0){
                //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空
                channelListMustRefresh = YES;
                
                if (response[@"data_valid_flag"] != NULL && ![response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                    //机顶盒连接成功了，但是没有数据
                    //显示列表为空的数据
                    
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
                    //                //机顶盒连接出错了，所以要显示没有网络的加载图
                    //                [self tableViewDataRefreshForMjRefresh_ONEMinute]; //如果数据为空，则重新获取数据
                    return ;
                }
                
                [self NOChannelDataShow];
                isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
                [self removeTipLabAndPerformSelector];   //取消不能播放的文字
                [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
                
                [self removeTopProgressView]; //删除进度条
                
                if ( [[USER_DEFAULT objectForKey:@"deliveryPlayState"] isEqualToString:@"stopDelivery"]) {
                    [USER_DEFAULT setObject:@"stopDelivery" forKey:@"deliveryPlayState"];
                    [GGUtil postcantDeliveryNotific];
                }
            }else
            {
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
            NSArray * tempCategoryArr = (NSMutableArray *)response[@"category"];
            if (tempCategoryArr.count == 0 ) {
                
            }else{
                self.serviceData = (NSMutableArray *)data1;
                
                self.categorys = (NSMutableArray *)response[@"category"];  //新加，防止崩溃的地方
                NSLog(@"categorys==||=One");
            }
            
            
            [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
            
            BOOL serviceDatabool = [self judgeServiceDataIsnull];
            
            if (serviceDatabool && recFileData.count == 0) {
                //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空
                
                if (response[@"data_valid_flag"] != NULL && ![response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                    
                    if (_slideView) {
                        [_slideView removeFromSuperview];
                        _slideView = nil;
                        
                    }
                    
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
                
                [self NOChannelDataShow];
                isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
                [self removeTipLabAndPerformSelector];   //取消不能播放的文字
                [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
                NSLog(@"zidong  刷新了一次");
                [self removeTopProgressView]; //删除进度条
                if ( [[USER_DEFAULT objectForKey:@"deliveryPlayState"] isEqualToString:@"stopDelivery"]) {
                    [USER_DEFAULT setObject:@"stopDelivery" forKey:@"deliveryPlayState"];
                    [GGUtil postcantDeliveryNotific];
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
            [self activeViewRemove];
            NSString * YLSlideTitleViewButtonTagIndexStr = [USER_DEFAULT objectForKey:@"YLSlideTitleViewButtonTagIndexStr"];
            
            int YLSlideTitleViewButtonTagIndex = [YLSlideTitleViewButtonTagIndexStr  intValue];
            
            NSString *  indexforTableToNum = YLSlideTitleViewButtonTagIndexStr;
            //        [NSNumber numberWithInteger:YLSlideTitleViewButtonTagIndex];
            self.tableForSliderView = [self.tableForDicIndexDic objectForKey:indexforTableToNum][1];
            
            if (YLSlideTitleViewButtonTagIndex < self.tableForDicIndexDic.count) {
                
                //            id idTemp = [self.tableForDicIndexDic objectForKey:indexforTableToNum][1];
                
                NSNumber * numTemp = [self.tableForDicIndexDic objectForKey:indexforTableToNum][0];
                
                NSInteger index = [numTemp integerValue];
                NSLog(@"jfabdjasbajsbd index %ld",(long)index);
                
                //此处可能出现崩溃-----数组为空
                if (index > 0 ) {
                    [self returnDicTemp:index]; //根据是否有录制返回不同的item
                }else
                {
                }
                
                
            }
            
            //==========
            //            [self.tableForSliderView reloadData];
            [tempTableviewForFocus reloadData];
            
            // 模拟延迟2秒
            
            double delayInSeconds = 2;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                NSLog(@"延时执行的2秒");
                
                //                [self.tableForSliderView reloadData];
                [tempTableviewForFocus reloadData];
                
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
                if (data1.count == 0 && recFileData.count == 0){
                }else{
                    [self newSlideView];
                }
                
            }];
            
            [self refreshTableviewByEPGTime];
            [self.table reloadData];
            [self setSearchViewData];
            NSLog(@"setSearchViewDatasetSearchViewData===4444");
        }
    }];
    
    
    if ( dataForData1.count == 0 ){
        
    }else
    {
        double delayInSeconds = 1;
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, mainQueue, ^{
            
            //            [self.tableForSliderView reloadData];
            [tempTableviewForFocus reloadData];
            [self refreshTableviewByEPGTime];
            //            [self.table reloadData];
        });
    }
    
    
}
#pragma mark - IP改变后的刷新方法
//IP改变后或者是HMC改变后的刷新方法  ,类似于getServiceData
-(void) getServiceDataForIPChange
{
    NSLog(@"ip has change");
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
            if (response[@"data_valid_flag"] != NULL && ![response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                //机顶盒连接成功了，但是没有数据
                //显示列表为空的数据
                
                if (_slideView) {
                    [_slideView removeFromSuperview];
                    _slideView = nil;
                    
                }
                
                self.NoDataImageview = [[UIImageView alloc]init];
                
                self.NoDataLabel = [[UILabel alloc]init];
                [self NOChannelDataShow];
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
                    [self getServiceDataForIPChange]; //如果数据为空，则重新获取数据
                });
                
                [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
                return ;
            }
            
        }
        self.serviceData = (NSMutableArray *)data1;
        [USER_DEFAULT setObject:self.serviceData forKey:@"serviceData_Default"];
        //        NSLog(@"--------%@",self.serviceData);
        
        
        BOOL serviceDatabool = [self judgeServiceDataIsnull];
        if (serviceDatabool && recFileData.count == 0) {
            //            [self getServiceDataForIPChange];
            
            if (response[@"data_valid_flag"] != NULL && ![response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                
                //机顶盒连接成功了，但是没有数据
                //显示列表为空的数据
                if (_slideView) {
                    [_slideView removeFromSuperview];
                    _slideView = nil;
                    
                }
                
                if (!self.NoDataImageview) {
                    self.NoDataImageview = [[UIImageView alloc]init];
                    
                }
                
                if (!self.NoDataLabel) {
                    self.NoDataLabel = [[UILabel alloc]init];
                }
                [self NOChannelDataShow];
                NSLog(@"NOChannelDataShow--!!7777777");
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
        
        [self activeViewRemove];
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
            NSLog(@"categorys==||=IPChange");
            
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
                        [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                        firstOpenAPP = firstOpenAPP+1;
                        
                        firstfirst = NO;
                        
                    }else //正常播放的步骤
                    {
                        [self firstOpenAppAutoPlayZero:0 diction:self.dicTemp];
                    }
                }else //正常播放的步骤
                {
                    [self firstOpenAppAutoPlayZero:0 diction:self.dicTemp];
                }
            }else
            {}
            [USER_DEFAULT  setObject:@"YES" forKey:@"viewHasAddOver"];  //第一次进入时，显示页面加载完成
            
        }];
        
        
        [self initProgressLine];
        [self.table reloadData];
        
    }];
    
}
-(void)activeViewRemove
{
    [self.activeView removeFromSuperview];
    self.activeView = nil;
    [self lineAndSearchBtnShow];
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
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
        NSLog(@"取消25秒的等待5");
    });
    
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
                    [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                    firstOpenAPP = firstOpenAPP+1;
                    firstfirst = NO;
                }else //正常播放的步骤
                {
                    [self firstOpenAppAutoPlayZero:row diction:dic];
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
                    [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }else //正常播放的步骤
                {
                    [self firstOpenAppAutoPlayZero:row diction:dic];
                }
            }else //正常播放的步骤
            {
                //======机顶盒加密
                [self firstOpenAppAutoPlay:row diction:dic];
            }
            [USER_DEFAULT setObject:@"NO" forKey:@"jumpFormOtherView"];//为TV页面存储方法
        }
        
    }
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
    NSData * changeCALockData = [[NSData alloc]init];
    changeCALockData = text.userInfo[@"CARemovePopThreedata"];
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
        [GGUtil postremoveConfigCAPINShowNotific];
        NSArray * arrHistoryNow = [USER_DEFAULT objectForKey:@"historySeed"]; //历史数据
        NSArray * nowPlayChannel_Arr = arrHistoryNow[arrHistoryNow.count - 1];
        NSInteger row = [nowPlayChannel_Arr[2] intValue];
        NSDictionary * dic = nowPlayChannel_Arr [3];
        [CAAlert dismissWithClickedButtonIndex:1 animated:YES];
        [self firstOpenAppAutoPlayZero:row diction:dic];
    }
    
}
#pragma mark - 机顶盒回复出厂设置后，需要提示不能分发
-(void)cantDeliveryNotific //机顶盒加锁改变的消息
{
    //新建一个通知，用来监听从机顶盒密码验证正确跳转来的播放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cantDeliveryNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cantDelivery) name:@"cantDeliveryNotific" object:nil];
    
    //新建一个通知，用来监听从机顶盒密码验证正确跳转来的播放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cantDeliverySpecialChannelNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cantDeliverySpecialChannel:) name:@"cantDeliverySpecialChannelNotific" object:nil];
}
-(void)judgeChannelIsSame:(NSData *)data
{
    NSData * willStopThreeData = data;
    NSData * willStopTuner_modeData = [[NSData alloc]init];
    //获得数据区的长度
    if ([willStopThreeData length] >=  4) {
        willStopTuner_modeData = [willStopThreeData subdataWithRange:NSMakeRange(0,4)];
    }else
    {
        return;
    }
    
    NSData * willStopNetwork_idData = [[NSData alloc]init];
    //获得数据区的长度
    if ([willStopThreeData length] >=  6) {
        
        willStopNetwork_idData = [willStopThreeData subdataWithRange:NSMakeRange(4,2)];
    }else
    {
        return;
    }
    
    NSData * willStopTs_idData = [[NSData alloc]init];
    if ([willStopThreeData length] >=  8) {
        
        willStopTs_idData = [willStopThreeData subdataWithRange:NSMakeRange(6,2)];
    }else
    {
        return;
    }
    
    NSData * willStopService_idData = [[NSData alloc]init];
    if ([willStopThreeData length] >=  10) {
        
        willStopService_idData = [willStopThreeData subdataWithRange:NSMakeRange(8,2)];
    }else
    {
        return;
    }
    
    NSData * willStopAudio_PidData = [[NSData alloc]init];
    if ([willStopThreeData length] >=  12) {
        
        willStopAudio_PidData = [willStopThreeData subdataWithRange:NSMakeRange(10,2)];
    }else
    {
        return;
    }
    
    uint32_t  willStopTuner_modeStr = [SocketUtils uint16FromBytes:willStopTuner_modeData]; //
    
    uint16_t  willStopNetwork_idStr = [SocketUtils uint16FromBytes:willStopNetwork_idData]; // [[NSString alloc] initWithData:CANetwork_idData  encoding:NSUTF8StringEncoding];
    uint16_t  willStopTs_idStr =  [SocketUtils uint16FromBytes:willStopTs_idData]; //[[NSString alloc] initWithData:CATs_idData  encoding:NSUTF8StringEncoding];
    uint16_t  willStopService_idStr =  [SocketUtils uint16FromBytes:willStopService_idData];//[[NSString alloc] initWithData:CAService_idData  encoding:NSUTF8StringEncoding];
    //判断当前节目是不是CA弹窗节目
    uint16_t  willStopAudio_PidStr =  [SocketUtils uint16FromBytes:willStopAudio_PidData];
    
    if (willStopTuner_modeStr  == [socketView.socket_ServiceModel.service_tuner_mode  intValue] &&willStopNetwork_idStr  == [socketView.socket_ServiceModel.service_network_id  intValue] && willStopTs_idStr == [socketView.socket_ServiceModel.service_ts_id intValue] && willStopService_idStr == [socketView.socket_ServiceModel.service_service_id intValue] && willStopAudio_PidStr == [socketView.socket_ServiceModel.audio_pid intValue]) {
        NSLog(@"this is Major 1111111");
        
        
        if (judgeIsNeedShowDeliveryStop != 1) {
            
            NSLog(@"this is Major  擦擦擦擦");
            [USER_DEFAULT setObject:@"stopDelivery" forKey:@"deliveryPlayState"];
            [GGUtil postcantDeliveryNotific];
        }else
        {
            //            judgeIsNeedShowDeliveryStop 等于1 证明还没有点击或者刚刚点击
        }
        
        
        
        
        
    }else
    {
        //不执行操作
    }
    
    
}
-(void)cantDeliverySpecialChannel:(NSNotification *)text{
    
    
    NSData * changeCALockData = [[NSData alloc]init];
    changeCALockData = text.userInfo[@"changeLockData"];
    
    NSLog(@"changeCALockData %@",changeCALockData);
    
    [self judgeChannelIsSame:changeCALockData];
    
}
-(void)cantDelivery
{
    //①视频停止分发，断开了和盒子的连接，跳转界面不播放  ②禁止播放  ③取消掉加载环  ④ 显示不能播放的文字
    [self stopVideoPlay]; //停止视频播放
    [USER_DEFAULT setObject:deliveryStopTip forKey:@"playStateType"];
    [GGUtil postnoPlayShowNotic];
    NSLog(@"postnoPlayShowNotic iiiii");
    
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
    
    //    NSLog(@"changeCALockData %@",changeCALockData);
    
    
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
        
        [USER_DEFAULT setObject:@"Lab" forKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
        [GGUtil postnoPlayShowNotic];
        NSLog(@"postnoPlayShowNotic jjjjjjj");
        [GGUtil postremoveConfigCAPINShowNotific];
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
    NSData * changeLockData = [[NSData alloc]init];
    changeLockData = text.userInfo[@"changeLockData"];
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
        NSData * ts_id_data = [[NSData alloc]init];
        if ([updateChannelServiceData length] >=  45) {
            
            ts_id_data = [updateChannelServiceData subdataWithRange:NSMakeRange(43,2)];
        }else
        {
            return;
        }
        
        uint32_t ts_id_int = [SocketUtils uint16FromBytes:ts_id_data];
        NSData * service_id_data = [[NSData alloc]init];
        if ([updateChannelServiceData length] >=  47) {
            
            service_id_data = [updateChannelServiceData subdataWithRange:NSMakeRange(45,2)];
        }else
        {
            return;
        }
        uint32_t service_id_int = [SocketUtils uint16FromBytes:service_id_data];
        NSData * program_character_data = [[NSData alloc]init];
        if ([updateChannelServiceData length] >=  51) {
            
            program_character_data = [updateChannelServiceData subdataWithRange:NSMakeRange(47,4)];
        }else
        {
            return;
        }
        uint32_t program_character_int = [SocketUtils uint32FromBytes:program_character_data];
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
            
            
            //如果这几项相等，则找到了是哪一个节目
            if (service_network_id1_int == network_id_int && service_ts_id1_int == ts_id_int && service_service_id1_int == service_id_int) {
                
                
                
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
                
                NSDictionary * judgeIsEqualDic_One = serviceArrForJudge_dic;
                NSDictionary * judgeIsEqualDic_Two = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
                BOOL * judgeIsEqual = [GGUtil judgeTwoEpgDicIsEqual:judgeIsEqualDic_One TwoDic:judgeIsEqualDic_Two];
                
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
                    [USER_DEFAULT setObject:self.dicTemp forKey:@"selfDicTemp"];
                    
                    NSMutableArray * serviceData_DefaultTemp = [[USER_DEFAULT objectForKey:@"serviceData_Default"] mutableCopy];
                    
                    [serviceData_DefaultTemp replaceObjectAtIndex:i withObject:[dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]]];
                    [USER_DEFAULT setObject:[serviceData_DefaultTemp copy]  forKey :@"serviceData_Default"]; // 存到serviceData_Default 中
                    
                    /*
                     
                     storeLastChannelArr
                     1. 修改storeLastArr = self.dicTemp;
                     2.修改storeLastARR
                     
                     */
                    
                    //                    NSMutableDictionary * dicTempCopy = [self.dicTemp mutableCopy];
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
                            [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
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
                            [self firstOpenAppAutoPlayZero:row diction:dic];
                        });
                        
                        
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
                    [USER_DEFAULT setObject:self.dicTemp forKey:@"selfDicTemp"];
                    
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
    
    
    [searchViewCon.dataList removeAllObjects];
    [searchViewCon.showData removeAllObjects];
    searchViewCon.dataList =  [searchViewCon getServiceArray ];  //dataList 是所有的名字和符号的组合
    searchViewCon.showData = [NSMutableArray arrayWithArray:searchViewCon.dataList];
    [USER_DEFAULT setObject: searchViewCon.showData forKey:@"showData"];
}
//新增的修改search界面数据的方法，与上面一个方法重载，建议使用方法
-(void)setSearchViewData
{
    NSLog(@"setSearchViewDatasetSearchViewData");
    [searchViewCon.dataList removeAllObjects];
    [searchViewCon.showData removeAllObjects];
    searchViewCon.dataList =  [searchViewCon getServiceArray ];  //dataList 是所有的名字和符号的组合
    
    searchViewCon.showData = [NSMutableArray arrayWithArray:searchViewCon.dataList];
    
    [USER_DEFAULT setObject: searchViewCon.showData forKey:@"showData"];
    
    NSLog(@"searchViewCon.showData %@",searchViewCon.showData);
}
#pragma mark - 播放过程中，或者点击了加锁的按钮。此时停止掉显示不能播放文字,并且取消掉延迟方法
-(void)removeTipLabAndPerformSelector
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //弹窗之后，取消显示sorry不能播放的字样，并且取消不能播放的提示文字
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
        [GGUtil postnoPlayShowShutNotic];
    });
}
#pragma mark -- 判断是否需要延迟20秒执行播放状态判断，如果有CA或者加锁弹窗，则不进行判断
-(void)ifNeedPlayClick
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
        if (self.showTVView == YES) {
            [self performSelector:@selector(playClick) withObject:nil afterDelay:25];
            NSLog(@"开始25秒的等待");
        }else
        {
            
            NSLog(@"进入了这个方法");
        }
        NSLog(@"play-Click 5555");
    });
    
}
#pragma mark - 则去掉不能播放的字样，加上加载环
-(void)removeLabAndAddIndecatorView
{
    [GGUtil postnoPlayShowShutNotic];
    [GGUtil postIndicatorViewShowNotic];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.Animating = NO;
    
}
-(void)viewDidDisappear:(BOOL)animated
{
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
    [GGUtil postremoveConfigCAPINShowNotific];
    //取消掉20秒后显示提示文字的方法，如果视频要播放呀，则去掉不能播放的字样
    [self removeTipLabAndPerformSelector];
    
    
    NSNotification *notification3 =[NSNotification notificationWithName:@"animateHideNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification3];
    
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
    BOOL isFullScreen =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
    if (isFullScreen == NO) {
        self.topProgressView.frame = CGRectMake(-2 ,
                                                VIDEOHEIGHT+kZXVideoPlayerOriginalHeight ,
                                                SCREEN_WIDTH,
                                                progressViewSize.height);
        self.topProgressView.borderTintColor = [UIColor whiteColor];
        self.topProgressView.progressTintColor = ProgressLineColor;
        self.topProgressView.progressBackgroundColor = [UIColor colorWithRed:0x80 green:0x80 blue:0x80 alpha:0.3];
        [self.view addSubview:self.topProgressView];
        [self.view bringSubviewToFront:self.topProgressView];
        [USER_DEFAULT setObject:@"YES" forKey:@"topProgressViewISNotExist"];
        
        self.progressViews = @[ self.topProgressView ];
    }
}

//每隔一秒刷新一次进度条
- (void)updateProgress :(NSTimer *)Time
{
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
                             //                             [self setNeedsStatusBarAppearanceUpdate];
                             
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
            
            NSLog(@"[progressEPGArr  %@",[progressEPGArr[progressEPGArrIndex]objectForKey:@"event_starttime"]);
            if(![[progressEPGArr[progressEPGArrIndex]objectForKey:@"event_starttime"] isEqualToString:@""])
                
            {
                NSInteger tempIndex =progressEPGArrIndex;
                NSString * tempIndexStr = [NSString stringWithFormat:@"%ld",(long)tempIndex];
                [USER_DEFAULT setObject:tempIndexStr  forKey:@"nowChannelEPGArrIndex"];
                [GGUtil postTimerOfEventTimeNotific];
                self.event_videoname = [progressEPGArr[progressEPGArrIndex] objectForKey:@"event_name"];
                //=======
                //刷新节目名称
                self.video.playEventName = self.event_videoname;
                NSNotification *replaceEventNameNotific =[NSNotification notificationWithName:@"replaceEventNameNotific" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:replaceEventNameNotific];
                NSLog(@"5555555 replace progresFresh");
                
                
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
                    if (ISNULL(self.event_startTime) || self.event_startTime == NULL || self.event_startTime == nil || ISNULL(self.event_endTime) || self.event_endTime == NULL || self.event_endTime == nil || self.event_startTime.length == 0 || self.event_endTime.length == 0) {
                        
                        [self removeProgressNotific];
                    }else
                    {
                        [dict setObject:self.event_startTime forKey:@"StarTime"];
                        [dict setObject:self.event_endTime forKey:@"EndTime"];
                        //判断当前是不是一个节目
                        eventName1 = self.event_videoname;
                        eventName2 = self.event_videoname;
                        
                        eventNameTemp = eventName1;
                        if (![eventName2 isEqualToString: eventNameTemp]) {
                            // 不同的节目   @"同一个节目";
                        }else
                        {
                            //@"同一个节目";
                            eventName2 = eventNameTemp;
                            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress:) userInfo:dict repeats:YES];
                            NSInteger endTime =[self.event_endTime intValue ];
                            NSDate *senddate = [NSDate date];
                            NSString *nowDate = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
                            NSInteger endTimeCutStartTime =endTime-[nowDate integerValue];
                            if (endTimeCutStartTime > 0) {
                                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressRefresh) object:nil];
                                [self performSelector:@selector(progressRefresh) withObject:nil afterDelay:endTimeCutStartTime];
                            }
                            
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
            [self removeTopProgressView];  //如果时间不存在，则删除进度条，等到下一个节目的时候再显示
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
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.topProgressView.alpha = 0;
////        [self.topProgressView removeFromSuperview];
////        [self.timer invalidate];
////            self.timer = nil;
//    });
    
}

#pragma mark -////重新开始进度条和计时器的通知
-(void)restartLineProgressNotific
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"restartTopProgressView" object:nil];
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

-(void)updateFullScreenDic{
    //对于其他页面的dic重新赋值
    self.TVChannlDic = self.dicTemp;
    
    tempDicForServiceArr = self.TVChannlDic;
    
    self.video.dicChannl = [tempDicForServiceArr mutableCopy];
    
    if ([tempArrForServiceArr isKindOfClass:[NSArray class]]){
        self.video.channelCount = tempArrForServiceArr.count;
    }
    
    
}
#pragma mark - 下拉刷新做12秒超时处理
-(void)endMJRefresh{
    [self.tableForSliderView.mj_header endRefreshing];
}
#pragma mark - 如果这个时候展示的不是TV页面，则不进行播放的各个事件通知
//如果这个时候展示的不是TV页面，则不进行播放的各个事件通知
-(void)ifNotISTVView
{
    //① 去掉不能播放给的字样
    [GGUtil postnoPlayShowShutNotic];
    //② 去掉20s 播放
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playClick) object:nil];
    
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
        NSString * MLRecording = NSLocalizedString(@"MLRecording", nil);
        [tempTitlesArr insertObject:MLRecording atIndex:0];
    }else if ([RECAndLiveType isEqualToString:@"LiveExit"]){ //录制不存在直播存在
        
        tempTitlesArr =titles[0];
        
        
    }else if([RECAndLiveType isEqualToString:@"RecAndLiveAllHave"]){//都存在
        if (titles.count == 2 ) {   //正常情况
            tempTitlesArr =[titles[0] mutableCopy];
            NSString * MLRecording = NSLocalizedString(@"MLRecording", nil);
            [tempTitlesArr insertObject:MLRecording atIndex:1];
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
    NSLog(@"inputCategoryDic %d",inputCategoryDic);
    NSArray * RECArrForJudgeCategory = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
    if (RECArrForJudgeCategory.count > 0 && RECArrForJudgeCategory != nil) {
        
        if (inputCategoryDic == 1) { //录制
            
            for (int i = 0; i< self.CategoryAndREC.count; i++) {
                
                if (self.CategoryAndREC.count > 1) {
                    NSArray * CategoryAndREC_One = self.CategoryAndREC[1];
                    if (CategoryAndREC_One.count > i) {
                        [self.dicTemp setObject:self.CategoryAndREC[1][i] forKey:[NSString stringWithFormat:@"%d",i] ];
                    }
                }
            }
        }else  //点击了非录制节目
        {
            if (inputCategoryDic <= (self.categorys.count -1)) {
                
                if (self.CategoryAndREC.count > 0) {
                    NSArray * CategoryAndREC_Zero = self.CategoryAndREC[0];
                    if (CategoryAndREC_Zero.count > inputCategoryDic) {
                        
                        NSDictionary * item = self.CategoryAndREC[0][inputCategoryDic];
                        
                        self.categoryModel = [[CategoryModel alloc]init];
                        
                        self.categoryModel.service_indexArr = item[@"service_index"];
                        NSMutableDictionary * dicTemp_Temp = [self.dicTemp mutableCopy];
                        [self.dicTemp removeAllObjects];
                        //获取不同类别下的节目，然后是节目下不同的cell值                10
                        if ([self.categoryModel.service_indexArr isKindOfClass:[NSMutableArray class]] || [self.categoryModel.service_indexArr isKindOfClass:[NSArray class]]){
                            NSLog(@"属于NSMutableArray这个类");
                            
                            for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {
                                int indexCat ;
                                indexCat =[self.categoryModel.service_indexArr[i] intValue];
                                
                                if ( ISNULL(self.serviceData)) {
                                    
                                }else{
                                    [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
                                }
                                
                            }
                        }
                        else
                        {
                            self.dicTemp =  [dicTemp_Temp mutableCopy];
                            [USER_DEFAULT setObject:self.dicTemp forKey:@"selfDicTemp"];
                        }
                        [USER_DEFAULT setObject:self.dicTemp forKey:@"selfDicTemp"];
                    }
                }
            }
        }
    }
    else
    {
        if (inputCategoryDic <= self.categorys.count -1) {
            
            if (self.categorys.count > inputCategoryDic) {
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
                [USER_DEFAULT setObject:self.dicTemp forKey:@"selfDicTemp"];
            }
        }
    }
}
-(void)returnDicTemp :(NSInteger)index
{
    int playTypeClass;
    playTypeClass = [GGUtil judgePlayTypeClass];
    if (playTypeClass == 0) {
    }else if (playTypeClass == 1){
        
        //如果发现第二列，则展示REC这个数组
        NSArray * RECTempArr = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
        /*
         用于分别获取REC Json数据中的值
         **/
        [self.dicTemp removeAllObjects];
        for (int i = 0; i< RECTempArr.count ; i++) {
            [self.dicTemp setObject:RECTempArr[i] forKey:[NSString stringWithFormat:@"%d",i] ];
        }
    }else if (playTypeClass == 2){
        
        NSDictionary *item = [[NSDictionary alloc]init];
        if (self.categorys.count > index) {
            item = self.categorys[index];   //当前页面类别下的信息
        }
        
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
        [USER_DEFAULT setObject:self.dicTemp forKey:@"selfDicTemp"];
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
            [USER_DEFAULT setObject:self.dicTemp forKey:@"selfDicTemp"];
        }else if (index == 1)
        {
            
            //如果发现第二列，则展示REC这个数组
            NSArray * RECTempArr = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
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
            [USER_DEFAULT setObject:self.dicTemp forKey:@"selfDicTemp"];
        }
    }
}
-(void)playRECVideo :(NSDictionary *)epgDicToSocket
{
    NSString * service_rat_Str = [epgDicToSocket objectForKey:@"service_rat"];
    if ([service_rat_Str intValue] > card_ret) {
        // 如果节目级别 大于 卡级别，则输入弹窗CA
        judgeRecIsCA = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self stopVideoPlay];
            
            [CAAlert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
            CAAlert.delegate =  self;
            NSString * CAAlertTitle = NSLocalizedString(@"CAPIN", nil);
            CAAlert.title = CAAlertTitle; //@"Please input your CA PIN";
            if (self.showTVView == YES) {
                [CAAlert show];
            }else
            {
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
                NSString * CAPINLabel = NSLocalizedString(@"CAPINLabel", nil);
                CATextField_Encrypt.placeholder = CAPINLabel;
            }
        });
    }
    
    socketView.cs_serviceREC.file_name = [epgDicToSocket objectForKey:@"file_name"];
    
    socketView.cs_serviceREC.file_name_len = socketView.cs_serviceREC.file_name.length;
    
    //开始进行数据赋值
    NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
    [GGUtil postsetChannelNameAndEventNameNotic:nowPlayingDic];
    
    [USER_DEFAULT setObject:@"NO" forKey:@"audioOrSubtTouch"];
    [self.videoController setaudioOrSubtRowIsZero];
    
    isEventStartTimeBiger_NowTime = NO;
    
    //录制节目的时间
    self.event_startTime = [epgDicToSocket objectForKey:@"record_time"];
    NSString * RECStartTime = [epgDicToSocket objectForKey:@"record_time"];
    NSString * RECDurationTime = [epgDicToSocket objectForKey:@"duration"];
    self.event_endTime = [NSString stringWithFormat:@"%ld",[RECStartTime integerValue] + [RECDurationTime integerValue]];
    
    BOOL isEventStartTimeBigNowTime = NO;//= [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
    if (isEventStartTimeBigNowTime == YES) {
        self.event_videoname = @"";
        self.event_startTime = @"";
        self.event_endTime = @"";
        [GGUtil postsetTimeAndProgressIsNullNotific];
        [self removeTopProgressView];
    }
    self.TVSubAudioDic = epgDicToSocket;
    self.TVChannlDic = self.dicTemp;
    
    [self getsubt];
    
    if (judgeRecIsCA == NO) {
        
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
    }
}
/**
 无频道列表显示
 */
-(void)NOChannelDataShow
{
    self.NoDataImageview.image = [UIImage imageNamed:@"无频道列表@3x"];
    self.NoDataImageview.frame = CGRectMake((SCREEN_WIDTH - 60)/2, (SCREEN_HEIGHT -(64.5+kZXVideoPlayerOriginalHeight+1.5 + 110 + 49))/2 + 64.5+kZXVideoPlayerOriginalHeight+1.5 ,  60,  60) ;
    self.NoDataImageview.alpha = 1;
    [self.view addSubview:self.NoDataImageview];
    
    NSString * ChannelListIsEmpty = NSLocalizedString(@"ChannelListIsEmpty", nil);
    
    self.NoDataLabel.text = ChannelListIsEmpty;
    self.NoDataLabel.textColor = UIColorFromRGB(0x848484);
    CGSize sizeNoDataLabel = [GGUtil sizeWithText:ChannelListIsEmpty font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    self.NoDataLabel.frame = CGRectMake((SCREEN_WIDTH - sizeNoDataLabel.width)/2,self.NoDataImageview.frame.origin.y + 10 + self.NoDataImageview.frame.size.height , sizeNoDataLabel.width, sizeNoDataLabel.height);
    self.NoDataLabel.textAlignment = NSTextAlignmentCenter;
    self.NoDataLabel.alpha = 1;
    [self.view addSubview:self.NoDataLabel];
    
}
-(BOOL)judgeIfNeedRefreshSliderView :(NSArray *)categoryArr recFileArr:(NSArray *)recFileArr lastCategoryArr:(NSArray *)lastCategory lastRECFileArr:(NSArray *)lastFileArr
{
    
    if ([lastCategory isEqualToArray:categoryArr] && (lastFileArr.count >0 && recFileArr.count>0))
    {
        return NO;
    }else if([lastCategory isEqualToArray:categoryArr] && (lastFileArr.count ==0 && recFileArr.count==0)){
        return NO;
    }
    else
    {
        return YES;
    }
}
#pragma mark - 点击历史记录中的节目进行播放，但是此时该节目不存在
-(void)NOChannelToPlay
{
    //显示 sorry，this Video cant play
    [self playClick];
    NSLog(@"play-Click 6666");
    //⑤停止播放的动作,并且取消掉图画
    [self.videoController.player stop];
    [self.videoController.player shutdown];
    [self.videoController.player.view removeFromSuperview];
    //        return;
    [self dissmissCellColor];
}
/**
 *取消掉tableView Cell的节目的蓝色
 */
-(void)dissmissCellColor
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [tempTableviewForFocus deselectRowAtIndexPath:indexPath animated:YES];
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
    
    [tempTableviewForFocus deselectRowAtIndexPath:tempIndexpathForFocus animated:YES];
    //先全部变黑
    for (NSInteger  i = 0; i<self.categoryModel.service_indexArr.count; i++) {
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:0];
        
        TVCell *cell1 = [tempTableviewForFocus cellForRowAtIndexPath:indexPath1];
        [cell1.event_nextNameLab setTextColor:CellGrayColor];
        [cell1.event_nameLab setTextColor:CellBlackColor];
        [cell1.event_nextTime setTextColor:CellGrayColor];
    }
}

-(void)newSlideView
{
    NSLog(@"重新加载sliderview");
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
        [self firstOpenAppAutoPlayZero:0 diction:self.dicTemp];
        NSArray *ArrayTocategory = [NSArray arrayWithArray:self.CategoryAndREC];
        [USER_DEFAULT setObject:ArrayTocategory forKey:@"categorysToCategoryView"];
        
        _slideView.backgroundColor = [UIColor whiteColor];
        _slideView.delegate        = self;
        
        [self.view addSubview:_slideView];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStartTransform"];
        
        BOOL isFullScreen1 =  [USER_DEFAULT boolForKey:@"isFullScreenMode"];
        if (isFullScreen1 == YES) {
            //此刻是全屏，隐藏进度条
            
        }else
        {
            [GGUtil postfullScreenBtnShow];
        }
    }else
    {
        //判断是不是需要刷新顶部的YLSlider
        NSLog(@"准备做判断是否需要刷新！！！");
        NSArray *recFileData = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
        if ([self judgeIfNeedRefreshSliderView:self.categorys recFileArr:[USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"] lastCategoryArr:getLastCategoryArr lastRECFileArr:getLastRecFileArr]) {
            [_slideView removeFromSuperview];
            _slideView = nil;
            [self tableViewDataRefreshForMjRefresh_ONEMinute];
        }
        NSDictionary *response = [USER_DEFAULT objectForKey:@"TVHttpAllData"];
        if (self.serviceData.count == 0 && recFileData.count == 0)
        {
            //证明已经连接上了，但是数据为空，所以我们要显示列表数据为空
            
            if (response[@"data_valid_flag"] != NULL && ![response[@"data_valid_flag"] isEqualToString:@"0"] ) {
                
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
            
            [self NOChannelDataShow];
            [self removeTopProgressView]; //删除进度条
            isHasChannleDataList = NO;   //跳转页面的时候，不用播放节目，防止出现加载圈和文字
            [self removeTipLabAndPerformSelector];   //取消不能播放的文字
            [USER_DEFAULT setObject:@"YES" forKey:@"NOChannelDataDefault"];
            
        }else
        {
            if ([[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"YES"]) {
                if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 400) {
                    NSNotification *notification1 =[NSNotification notificationWithName:@"channeListIsShow" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                }
                [USER_DEFAULT setObject:@"NO" forKey:@"NOChannelDataDefault"];
            }
            if (recFileData.count > 0 && self.serviceData.count == 0 ) {
                
                //如果发现第二列，则展示REC这个数组
                NSArray * RECTempArr = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
                self.categoryModel = [[CategoryModel alloc]init];
                self.categoryModel.service_indexArr = RECTempArr;
                tempArrForServiceArr =  RECTempArr;
                numberOfRowsForTable = RECTempArr.count;
                [self.dicTemp removeAllObjects];
                
                for (int i = 0; i< RECTempArr.count ; i++) {
                    [self.dicTemp setObject:RECTempArr[i] forKey:[NSString stringWithFormat:@"%d",i] ];
                }
                self.showTVView = YES;
                [self firstOpenAppAutoPlayZero:0 diction:self.dicTemp];
                firstOpenAPP = firstOpenAPP+1;
                firstfirst = NO;
                [self tableViewCellToBlue:0 indexhah:0 AllNumberOfService:self.dicTemp.count];
            }
            
        }
        [self activeViewRemove];
        NSString * YLSlideTitleViewButtonTagIndexStr = [USER_DEFAULT objectForKey:@"YLSlideTitleViewButtonTagIndexStr"];
        
        NSString *  indexforTableToNum =YLSlideTitleViewButtonTagIndexStr ;
        self.tableForSliderView = [self.tableForDicIndexDic objectForKey :indexforTableToNum] [1];
        
        NSNumber * numTemp = [self.tableForDicIndexDic objectForKey:indexforTableToNum][0];
        
        NSInteger index = [numTemp integerValue];
        
        [self returnDicTemp:index]; //根据是否有录制返回不同的item
        //        [self.tableForSliderView reloadData];
        [tempTableviewForFocus reloadData];
        [self refreshTableviewByEPGTime];
        // 模拟延迟2秒
        
        double delayInSeconds = 2;
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, mainQueue, ^{
            
            //            [self.tableForSliderView reloadData];
            [tempTableviewForFocus reloadData];
            
            [self refreshTableviewByEPGTime];
        });
        //        [NSThread sleepForTimeInterval:2];
        [self.tableForSliderView.mj_header endRefreshing];
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
        }];
        
        [self.table reloadData];
        
    }
}

-(void)setCategoryAndREC :(NSArray *) data RECFile :(NSArray *)recFileData
{
    if (data.count == 0 && recFileData.count == 0){ //没有数据
        [USER_DEFAULT setObject:@"RecAndLiveNotHave" forKey:@"RECAndLiveType"];
        return ;
    }else if(data.count == 0 && recFileData.count != 0){ //有录制没直播
        [USER_DEFAULT setObject:@"RecExit" forKey:@"RECAndLiveType"];
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
}
- (UIView *)createPushView
{
    UIView *PushView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 50*phonePushOtherArr.count)];
    
    
    pushTableView = [[UITableView alloc]initWithFrame:PushView.bounds style:UITableViewStylePlain];
    
    pushTableView.scrollEnabled = NO;
    
    //    UITableView *tableView = [[UITableView alloc]initWithFrame:demoView.bounds style:UITableViewStylePlain];
    
    pushTableView.layer.cornerRadius = 7;
    pushTableView.layer.masksToBounds = YES;
    pushTableView.delegate = self;
    pushTableView.dataSource = self;
    [PushView addSubview:pushTableView];
    
    
    return PushView;
    
}
-(void)createAlertView{
    JXCustomAlertView *pushAlertView = [[JXCustomAlertView alloc] init];
    
    [pushAlertView setContainerView:[self createPushView]];
    
    NSString * CancelLabel = NSLocalizedString(@"CancelLabel", nil);
    NSString * MMShare = NSLocalizedString(@"MMShare", nil);
    
    [pushAlertView setButtonTitles:[NSMutableArray arrayWithObjects:CancelLabel, MMShare, nil]];
    pushAlertView.buttonTitleColors = @[pushViewBtnColor,pushViewBtnColor];
    
    pushAlertView.closeOnTouchUpOutside = YES;
    pushAlertView.useMotionEffects = YES;
    
    [pushAlertView setOnButtonTouchUpInside:^(JXCustomAlertView *pushAlertView, int buttonIndex) {
        if (buttonIndex == 0) { //点击了取消
            NSLog(@"点击了取消按钮");
            [self.videoController setPushBtnHasClickNO];
        }else
        {
            //发送通知
            [self PushSelectBtnClick];
            [self.videoController setPushBtnHasClickNO];
        }
        [pushAlertView close];
    }];
    
    [pushAlertView show];
    //    [pushAlertView show:pushChannelId];
}
-(void)popPushAlertView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popPushAlertViewNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popPushAlertViewNotific) name:@"popPushAlertViewNotific" object:nil];
    
}
-(void)popPushAlertViewNotific
{
    ///发送通知获取Push列表
    [self.socketView csGetPushInfo];  //密码六位
}
///快速设置频道名称和节目名称等信息
-(void)setPushDataNotific
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setPushDataNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPushData:) name:@"setPushDataNotific" object:nil];
}
-(void)setPushData:(NSNotification *)text{
    NSMutableArray * pushDataAllArr = text.userInfo[@"pushDataAll"];
    NSLog(@"pushDataAllArr= %@",pushDataAllArr);
    pushDataMutilArr = pushDataAllArr;
    
    NSString * strName = [NSString stringWithFormat:@"%@",[GGUtil deviceVersion]];
    [pushBtnSelectArr removeAllObjects];
    [phonePushOtherArr removeAllObjects];
    for (int i = 0; i< pushDataMutilArr.count;i++) {
        if (![pushDataMutilArr[i][2] isEqualToString:strName]) {
            [phonePushOtherArr addObject:pushDataMutilArr[i]];
            [pushBtnSelectArr addObject:@"NO"];
        }
    }
    [self createAlertView];
}

#pragma mark - 接收投屏弹窗
- (UIView *)createGetPushAlertView
{
    UIView *PushView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 130)];
    PushView.backgroundColor = [UIColor whiteColor];
    PushView.layer.cornerRadius = 7;
    
    blueCircleView = [[UIView alloc]init];
    blueCircleView.backgroundColor = RGB(80, 143, 231);
    blueCircleView.frame = CGRectMake((PushView.frame.size.width-45)/2, 8,45, 45);
    blueCircleView.alpha = 0.6;
    blueCircleView.layer.cornerRadius = 45/2;
    
    [PushView addSubview:blueCircleView];
    
    UILabel * getPushInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, (PushView.frame.size.width-30), 100)];
    getPushInfoLab.text = [NSString stringWithFormat:@"%@ is sharing the program %@ to you",socketView.otherDevicePushService.src_client_name,channnelNameString];
    getPushInfoLab.numberOfLines = 0;
    getPushInfoLab.font = FONT(13);
    [PushView addSubview:getPushInfoLab];
    
    
    
    pushSecNumLab = [[UILabel alloc]init];
    pushSecNumLab.frame = CGRectMake(7, 1, 45, 45);
    
    pushSecNumLab.text = @"60s";
    [self setPushSecNumLabFrame];
    
    pushSecNumLab.font = FONT(18);
    pushSecNumLab.textColor = [UIColor whiteColor];
    [blueCircleView addSubview:pushSecNumLab];
    timeNum = 60;
    pushTVTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pushTVTimerReduce) userInfo:nil repeats:YES];
    
    return PushView;
    
}
#pragma mark - 接收投屏弹窗录制
- (UIView *)createLiveGetPushAlertView
{
    UIView *PushView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 130)];
    PushView.backgroundColor = [UIColor whiteColor];
    PushView.layer.cornerRadius = 7;
    
    blueCircleView = [[UIView alloc]init];
    blueCircleView.backgroundColor = RGB(80, 143, 231);
    blueCircleView.frame = CGRectMake((PushView.frame.size.width-45)/2, 8,45, 45);
    blueCircleView.alpha = 0.6;
    blueCircleView.layer.cornerRadius = 45/2;
    
    [PushView addSubview:blueCircleView];
    
    UILabel * getPushInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, (PushView.frame.size.width-30), 100)];
    getPushInfoLab.text = [NSString stringWithFormat:@"%@ is sharing the program %@ to you",socketView.otherDevicePushLive.src_client_name,channnelNameString];
    getPushInfoLab.numberOfLines = 0;
    getPushInfoLab.font = FONT(13);
    [PushView addSubview:getPushInfoLab];
    
    
    
    pushSecNumLab = [[UILabel alloc]init];
    pushSecNumLab.frame = CGRectMake(7, 1, 45, 45);
    //    pushSecNumLab.text = @"4s";
    pushSecNumLab.text = @"60s";
    
    [self setPushSecNumLabFrame];
    
    pushSecNumLab.font = FONT(18);
    pushSecNumLab.textColor = [UIColor whiteColor];
    [blueCircleView addSubview:pushSecNumLab];
    
    
    
    timeNum = 60;
    pushTVTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pushTVTimerReduce) userInfo:nil repeats:YES];
    
    return PushView;
    
    
}
///改变弹出按钮的时间
-(void) pushTVTimerReduce
{
    timeNum --;
    if (timeNum > 0) {
        //        pushSecNumLab.text = [NSString stringWithFormat:@"%d=60s",pushAlertViewIndex];
        //        pushAlertViewIndex = pushAlertViewIndex +1;
        pushSecNumLab.text = [NSString stringWithFormat:@"%ds",timeNum];
        [self setPushSecNumLabFrame];
    }else
    {
        [JXAlertView close];
        [pushTVTimer invalidate];
        //        pushTVTimer = nil;
    }
    
}
///设置投屏时倒计时的位置
-(void)setPushSecNumLabFrame
{
    if (pushSecNumLab.text.length > 2) {
        pushSecNumLab.frame = CGRectMake(7, 1, 45, 45);
        [blueCircleView addSubview:pushSecNumLab];
    }else
    {
        pushSecNumLab.frame = CGRectMake(12, 1, 45, 45);
        [blueCircleView addSubview:pushSecNumLab];
    }
}
///创建机顶盒/手机 分享视频到手机 弹窗
-(void)createGetAlertView{
    JXAlertView = [[GetPushInfoAlertView alloc] init];
    [JXAlertView setContainerView:[self createGetPushAlertView]];
    NSString * CancelLabel = NSLocalizedString(@"CancelLabel", nil);
    NSString * MMWatch = NSLocalizedString(@"MMWatch", nil);
    
    [JXAlertView setButtonTitles:[NSMutableArray arrayWithObjects:CancelLabel, MMWatch, nil]];
    JXAlertView.buttonTitleColors = @[pushViewBtnColor,pushViewBtnColor];
    
    JXAlertView.closeOnTouchUpOutside = YES;
    JXAlertView.useMotionEffects = YES;
    
    //    JXAlertView
    
    [JXAlertView setOnButtonTouchUpInside:^(GetPushInfoAlertView *JXAlertView, int buttonIndex) {
        if (buttonIndex == 0) { //点击了取消
            [self.videoController setPushBtnHasClickNO];
            [pushTVTimer invalidate];
        }else
        {
            //发送通知
            //            [self PushSelectBtnClick];  //此处可能报错=====Major
            [self.videoController setPushBtnHasClickNO];
            [pushTVTimer invalidate];
            
            NSNumber * currentIndex = [NSNumber numberWithInt:0];
            NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndex,@"currentIndex", nil];
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                [self addHistory:pushChannelId diction:self.dicTemp];
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
            //=======机顶盒加密
            NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:pushChannelId serviceListDic:self.dicTemp];
            if (characterStr != NULL && characterStr != nil) {
                BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                if (judgeIsSTBDecrypt == YES) {
                    // 此处代表需要记性机顶盒加密验证
                    NSNumber  *numIndex = [NSNumber numberWithInteger:pushChannelId];
                    NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"LiveTouch",@"textThree",nil];
                    [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }else //正常播放的步骤
                {
                    [self firstOpenAppAutoPlayZero:pushChannelId diction:self.dicTemp];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //关闭当前正在播放的节目
                        [self.videoController.player stop];
                        [self.videoController.player shutdown];
                        [self.videoController.player.view removeFromSuperview];
                    });
                }
            }else //正常播放的步骤
            {
                [self firstOpenAppAutoPlayZero:pushChannelId diction:self.dicTemp];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //关闭当前正在播放的节目
                    [self.videoController.player stop];
                    [self.videoController.player shutdown];
                    [self.videoController.player.view removeFromSuperview];
                });
            }
            
            firstOpenAPP = firstOpenAPP+1;
            double delayInSeconds = 0.5;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                
                [self tableViewCellToBlue:0 indexhah:pushChannelId AllNumberOfService:self.dicTemp.count];
            });
        }
        [JXAlertView close];
    }];
    
    
    [JXAlertView show];
    
}
///创建机顶盒分享视频到手机录制
-(void)createLiveGetAlertView{
    
    JXAlertView = [[GetPushInfoAlertView alloc] init];
    
    [JXAlertView setContainerView:[self createLiveGetPushAlertView]];
    
    NSString * CancelLabel = NSLocalizedString(@"CancelLabel", nil);
    NSString * MMWatch = NSLocalizedString(@"MMWatch", nil);
    
    [JXAlertView setButtonTitles:[NSMutableArray arrayWithObjects:CancelLabel, MMWatch, nil]];
    JXAlertView.buttonTitleColors = @[pushViewBtnColor,pushViewBtnColor];
    
    JXAlertView.closeOnTouchUpOutside = YES;
    JXAlertView.useMotionEffects = YES;
    
    //    JXAlertView
    
    [JXAlertView setOnButtonTouchUpInside:^(GetPushInfoAlertView *JXAlertView, int buttonIndex) {
        if (buttonIndex == 0) { //点击了取消
            [self.videoController setPushBtnHasClickNO];
            [pushTVTimer invalidate];
        }else
        {
            //发送通知
            //            [self PushSelectBtnClick];
            [self.videoController setPushBtnHasClickNO];
            [pushTVTimer invalidate];
            
            NSNumber * currentIndex = [NSNumber numberWithInt:1];
            NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndex,@"currentIndex", nil];
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self.navigationController popViewControllerAnimated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self addHistory:pushChannelId diction:self.dicTemp];
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
            //            [self firstOpenAppAutoPlay:pushChannelId diction:self.dicTemp];
            //=======机顶盒加密
            NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:pushChannelId serviceListDic:self.dicTemp];
            if (characterStr != NULL && characterStr != nil) {
                BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                if (judgeIsSTBDecrypt == YES) {
                    // 此处代表需要记性机顶盒加密验证
                    NSNumber  *numIndex = [NSNumber numberWithInteger:pushChannelId];
                    NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",self.dicTemp,@"textTwo", @"firstOpenTouch",@"textThree",nil];
                    [GGUtil postSTBDencryptNotific:dict_STBDecrypt];
                    firstOpenAPP = firstOpenAPP+1;
                    
                    firstfirst = NO;
                }else //正常播放的步骤
                {
                    [self firstOpenAppAutoPlayZero:pushChannelId diction:self.dicTemp];
                }
            }else //正常播放的步骤
            {
                [self firstOpenAppAutoPlayZero:pushChannelId diction:self.dicTemp];
            }
            
            firstOpenAPP = firstOpenAPP+1;
            
            double delayInSeconds = 0.5;
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, mainQueue, ^{
                
                [self tableViewCellToBlue:1 indexhah:pushChannelId AllNumberOfService:self.dicTemp.count];
            });
            
        }
        [JXAlertView close];
    }];
    
    [JXAlertView show];
}
-(void)RemoveAlertViewnotific
{
    //    [JXAlertView close];
    //    [pushAlertView close];
    
    [CAAlert dismissWithClickedButtonIndex:1 animated:YES];
    [STBAlert dismissWithClickedButtonIndex:1 animated:YES];
    
}
///其他设备投屏手机
-(void)OtherDevicePushToPhoneNotific
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setOtherDevicePushToPhoneNotific" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPushMutableArr:) name:@"setOtherDevicePushToPhoneNotific" object:nil];
}
#pragma mark - 添加投屏信息到数组
-(void)addPushMutableArr:(NSNotification *)text{
    
    NSLog(@"添加投屏信息到数组");
    
    NSMutableArray * textAndIndexMutableArr = [[NSMutableArray alloc]init];
    [textAndIndexMutableArr addObject:text];
    [textAndIndexMutableArr addObject:@"Service"];
    
    NSLog(@"dengd 等待投屏");
    
    
    [shareViewArr addObject:textAndIndexMutableArr];
    
    //①将每一个投屏信息添加到数据
    //②逐个从数组中取出，然后逐个发送通知进行操作。如果点击了签一个被取消掉了，那么后一个跟进
    if (shareViewArr.count > 0 && shareViewArr.count == 1) {
        NSNotification * textOne = shareViewArr[0][0];
        NSString * typeStr = shareViewArr[0][1];
        
        if ([typeStr isEqualToString:@"Service"]) {
            [self OtherDevicePushToPhone:textOne];
        }else
        {
            [self OtherDevicePushToPhoneLive:textOne];
        }
    }
}
-(void)OtherDevicePushToPhone:(NSNotification *)text{
    NSData * data = text.userInfo[@"playdata"];
    NSData * tunerTypeData = [data subdataWithRange:NSMakeRange(37,4)];
    NSData * netWorkIdData = [data subdataWithRange:NSMakeRange(41,2)];
    NSData * tsIdData = [data subdataWithRange:NSMakeRange(43,2)];
    NSData * serviceIdData = [data subdataWithRange:NSMakeRange(45,2)];
    NSData * audioPidData = [data subdataWithRange:NSMakeRange(47,2)];
    NSData * subtPidData = [data subdataWithRange:NSMakeRange(49,2)];
    NSData * srcClientIpData = [data subdataWithRange:NSMakeRange(51,4)];
    NSData * srcClientNameLenData = [data subdataWithRange:NSMakeRange(55,1)];
    NSData * srcClientNameData = [data subdataWithRange:NSMakeRange(56,data.length - 56)];
    
    socketView.otherDevicePushService.service_tuner_type = [SocketUtils uint32FromBytes:tunerTypeData];
    socketView.otherDevicePushService.service_network_id = [SocketUtils uint16FromBytes:netWorkIdData];
    socketView.otherDevicePushService.service_ts_id =[SocketUtils uint16FromBytes:tsIdData];
    socketView.otherDevicePushService.service_service_id = [SocketUtils uint16FromBytes:serviceIdData];
    socketView.otherDevicePushService.audio_pid = [SocketUtils uint16FromBytes:audioPidData];
    socketView.otherDevicePushService.subt_pid = [SocketUtils uint16FromBytes:subtPidData];
    //    socketView.otherDevicePushService.src_push_client_ip = [[NSString alloc]initWithData:srcClientIpData encoding:NSUTF8StringEncoding];
    socketView.otherDevicePushService.src_client_name_len = [SocketUtils uint8FromBytes:srcClientNameLenData] ;
    socketView.otherDevicePushService.src_client_name = [[NSString alloc]initWithData:srcClientNameData encoding:NSUTF8StringEncoding];
    
    //1.判断是不是一个节目
    //2.弹窗，展示信息
    
    NSArray * arrHistoryNow = [USER_DEFAULT objectForKey:@"historySeed"]; //历史数据
    NSArray * nowPlayChannel_Arr ;
    if (arrHistoryNow.count >= 1) {
        nowPlayChannel_Arr = arrHistoryNow[arrHistoryNow.count - 1];
    }else
    {
        return;
    }
    NSDictionary * dic1 = nowPlayChannel_Arr [0];
    
    
    //用于判断是不是需要弹窗
    if ([[dic1 objectForKey:@"service_tuner_mode"] intValue] == socketView.otherDevicePushService.service_tuner_type && [[dic1 objectForKey:@"service_network_id"] intValue] ==socketView.otherDevicePushService.service_network_id && [[dic1 objectForKey:@"service_ts_id"] intValue] ==socketView.otherDevicePushService.service_ts_id && [[dic1 objectForKey:@"service_service_id"] intValue] ==socketView.otherDevicePushService.service_service_id )
    {
        NSLog(@"电视播放的节目和手机播放的节目相等，不操作");
        if (shareViewArr.count > 0) {
            [self reducePushSharingViewNotific];
        }
    }else
    {
        
        //新建字典
        NSMutableArray * serviceMutableArr = [self.serviceData mutableCopy];
        
        NSMutableDictionary * serviceMutableDic = [[NSMutableDictionary alloc]init];
        
        if ( ISNULL(serviceMutableArr)) {
            
        }else{
            for (int i = 0 ; i < serviceMutableArr.count; i++) {
                [serviceMutableDic setObject:serviceMutableArr[i] forKey:[NSString stringWithFormat:@"%d",i] ];
            }
        }
        
        for (int i = 0; i<serviceMutableDic.count; i++) {
            [serviceMutableDic objectForKey:[NSString stringWithFormat:@"%d",i]];   //循环查找self.dicTemp 看有没有历史中的这个节目
            //原始数据
            NSString * service_network =  [[serviceMutableDic objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"service_network_id"];
            NSString * service_ts =  [[serviceMutableDic objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"service_ts_id"];
            NSString * service_service =  [[serviceMutableDic objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"service_service_id"];
            NSString * service_tuner =  [[serviceMutableDic objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"service_tuner_mode"];
            //新添加的数据
            if(arrHistoryNow.count >= 1)
            {
                if ([service_network intValue] == socketView.otherDevicePushService.service_network_id && [service_ts intValue] == socketView.otherDevicePushService.service_ts_id && [service_tuner intValue] == socketView.otherDevicePushService.service_tuner_type && [service_service intValue] == socketView.otherDevicePushService.service_service_id) {
                    channnelNameString = [[serviceMutableDic objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"service_name"];
                    pushChannelId = i;
                    
                }
                
            }
            
        }
        NSMutableArray * tempInfoArr = [[NSMutableArray alloc]init];
        [tempInfoArr addObject:tunerTypeData];
        [tempInfoArr addObject:netWorkIdData];
        [tempInfoArr addObject:tsIdData];
        [tempInfoArr addObject:serviceIdData];
        [tempInfoArr addObject:audioPidData];
        [tempInfoArr addObject:subtPidData];
        [tempInfoArr addObject:srcClientIpData];
        [tempInfoArr addObject:srcClientNameLenData];
        [tempInfoArr addObject:srcClientNameData];
        [self  createGetAlertView];
        
    }
    
}
///其他设备投屏手机Live
-(void)OtherDevicePushToPhoneLiveNotific
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setOtherDevicePushToPhoneLiveNotific" object:nil];
    //    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPushLiveMutableArr:) name:@"setOtherDevicePushToPhoneLiveNotific" object:nil];
}
#pragma mark - 添加投屏信息到数组
-(void)addPushLiveMutableArr:(NSNotification *)text{
    
    NSMutableArray * textAndIndexMutableArr = [[NSMutableArray alloc]init];
    [textAndIndexMutableArr addObject:text];
    [textAndIndexMutableArr addObject:@"Live"];
    
    
    [shareViewArr addObject:textAndIndexMutableArr];
    NSLog(@"dengd 等待投屏");
    
    //①将每一个投屏信息添加到数据
    //②逐个从数组中取出，然后逐个发送通知进行操作。如果点击了签一个被取消掉了，那么后一个跟进
    if (shareViewArr.count > 0 && shareViewArr.count == 1) {
        NSNotification * textOne = shareViewArr[0][0];
        NSString * typeStr = shareViewArr[0][1];
        
        if ([typeStr isEqualToString:@"Service"]) {
            [self OtherDevicePushToPhone:textOne];
        }else
        {
            [self OtherDevicePushToPhoneLive:textOne];
        }
    }
    
}
-(void)OtherDevicePushToPhoneLive:(NSNotification *)text{
    NSData * data = text.userInfo[@"playdata"];
    NSData * fileNameLenData = [data subdataWithRange:NSMakeRange(37,1)];
    NSData * fileNameData = [data subdataWithRange:NSMakeRange(38,[SocketUtils uint8FromBytes:fileNameLenData])];
    
    NSData * srcClientIpData = [data subdataWithRange:NSMakeRange(38+[SocketUtils uint8FromBytes:fileNameLenData],4)];
    NSData * srcClientNameLenData = [data subdataWithRange:NSMakeRange(38+[SocketUtils uint8FromBytes:fileNameLenData]+4,1)];
    NSData * srcClientNameData = [data subdataWithRange:NSMakeRange(38+[SocketUtils uint8FromBytes:fileNameLenData]+5,[SocketUtils uint8FromBytes:srcClientNameLenData])];
    
    socketView.otherDevicePushLive.file_name_len = [SocketUtils uint8FromBytes:fileNameLenData];
    socketView.otherDevicePushLive.file_name = [[NSString alloc]initWithData:fileNameData encoding:NSUTF8StringEncoding];
    
    socketView.otherDevicePushLive.src_client_name_len = [SocketUtils uint8FromBytes:srcClientNameLenData];
    socketView.otherDevicePushLive.src_client_name = [[NSString alloc]initWithData:srcClientNameData encoding:NSUTF8StringEncoding];
    NSArray * arrHistoryNow = [USER_DEFAULT objectForKey:@"historySeed"]; //历史数据
    NSArray * nowPlayChannel_Arr ;
    if (arrHistoryNow.count >= 1) {
        nowPlayChannel_Arr = arrHistoryNow[arrHistoryNow.count - 1];
    }else
    {
        return;
    }
    NSDictionary * dic1 = nowPlayChannel_Arr [0];
    //用于判断是不是需要弹窗
    if ([[dic1 objectForKey:@"file_name"] isEqualToString: socketView.otherDevicePushLive.file_name])
    {
        if (shareViewArr.count > 0) {
            [self reducePushSharingViewNotific];
        }
    }else
    {
        NSMutableArray * liveMutableArr = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
        NSMutableDictionary * liveMutableDic = [[NSMutableDictionary alloc]init];
        if ( !ISNULL(liveMutableArr)) {
            for (int i = 0 ; i < liveMutableArr.count; i++) {
                [liveMutableDic setObject:liveMutableArr[i] forKey:[NSString stringWithFormat:@"%d",i] ];
            }
        }
        for (int i = 0; i<liveMutableDic.count; i++) {
            [liveMutableDic objectForKey:[NSString stringWithFormat:@"%d",i]];   //循环查找self.dicTemp 看有没有历史中的这个节目
            
            //原始数据
            NSString * file_name_live =  [[liveMutableDic objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"file_name"];
            //新添加的数据
            if(arrHistoryNow.count >= 1)
            {
                if ([file_name_live isEqualToString:socketView.otherDevicePushLive.file_name]) {
                    NSString * service_event_name;
                    NSString * serviceName = [[liveMutableDic objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"service_name"];
                    NSString * eventName = [[liveMutableDic objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"event_name"];
                    if ([eventName isEqualToString:@""]) {
                        service_event_name = serviceName;
                    }else
                    {
                        service_event_name = [NSString stringWithFormat:@"%@_%@",serviceName,eventName];
                    }
                    channnelNameString = service_event_name;
                    pushChannelId = i;
                }
            }
        }
        NSMutableArray * tempInfoArr = [[NSMutableArray alloc]init];
        [tempInfoArr addObject:fileNameLenData];
        [tempInfoArr addObject:fileNameData];
        [tempInfoArr addObject:srcClientIpData];
        [tempInfoArr addObject:srcClientNameLenData];
        [tempInfoArr addObject:srcClientNameData];
        
        //弹窗
        [self  createLiveGetAlertView];
        
    }
    
}

-(void)SDTfirstOpenAppAutoPlay : (NSInteger)row diction :(NSDictionary *)dic  //:(NSNotification *)text{
{
    if (self.showTVView == YES) {
        [USER_DEFAULT setObject:@"no" forKey:@"alertViewHasPop"];
        NSMutableDictionary * epgDicToSocket = [[dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]] mutableCopy];
        if (epgDicToSocket.count <= 14){
            NSArray * audio_infoArr = [[NSArray alloc]init];
            NSArray * subt_infoArr = [[NSArray alloc]init];
            NSArray * epg_infoArr = [[NSArray alloc]init];
            socketView.socket_ServiceModel = [[ServiceModel alloc]init];
            audio_infoArr = [epgDicToSocket objectForKey:@"audio_info"];
            subt_infoArr = [epgDicToSocket objectForKey:@"subt_info"];
            
            if (audio_infoArr.count > 0 && subt_infoArr.count > 0) {
                
                int audiopidTemp;
                audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];
                
                socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];
                //                socketView.socket_ServiceModel.audio_pid = [audio_infoArr[0] objectForKey:@"audio_pid"];
                socketView.socket_ServiceModel.subt_pid = [subt_infoArr[0] objectForKey:@"subt_pid"];
            }else
            {
                if (audio_infoArr.count > 0 ) {
                    
                    int audiopidTemp;
                    audiopidTemp = [self setAudioPidTemp:audio_infoArr EPGDic:epgDicToSocket];
                    
                    socketView.socket_ServiceModel.audio_pid = [audio_infoArr[audiopidTemp] objectForKey:@"audio_pid"];
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
            [self SetService_videoindex:epgDicToSocket];
            
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
                self.event_videoname = @"";
                self.event_startTime = @"";
                self.event_endTime = @"";
                [GGUtil postsetTimeAndProgressIsNullNotific];
                [self removeTopProgressView];
            }
            isEventStartTimeBiger_NowTime = NO;
            BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
            if (isEventStartTimeBigNowTime == YES) {
                self.event_videoname = @"";
                self.event_startTime = @"";
                self.event_endTime = @"";
                [GGUtil postsetTimeAndProgressIsNullNotific];
                [self removeTopProgressView];
            }
            //*********
            
            //再单独开一个线程用于default操作
            dispatch_queue_t  queueA = dispatch_queue_create("firstOpen",DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queueA, ^{
                [USER_DEFAULT setObject:tempArrForServiceArr forKey:@"tempArrForServiceArr"];
                [USER_DEFAULT setObject:tempDicForServiceArr forKey:@"tempDicForServiceArr"];
            });
            [self judgeAllArgueIsZero];
            
            
        }
    }
}
-(void)judgeAllArgueIsZero{
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
}
-(void)SDTfirstOpenAppAutoPlaySMT : (NSInteger)row diction :(NSDictionary *)dic  //:(NSNotification *)text{
{
    if (self.showTVView == YES) {
        [self removeLabAndAddIndecatorView];
        [USER_DEFAULT setObject:@"no" forKey:@"alertViewHasPop"];
        NSMutableDictionary * epgDicToSocket = [[dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]] mutableCopy];
        if (epgDicToSocket.count > 14) {  //录制
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self addHistory:row diction:dic];
            });
            [self playRECVideo:epgDicToSocket];
        }else
        {
            //快速切换频道名称和节目名称
            NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
            [GGUtil postsetChannelNameAndEventNameNotic:nowPlayingDic];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self addHistory:row diction:dic];
            });
            [USER_DEFAULT setObject:@"NO" forKey:@"audioOrSubtTouch"];
            [self.videoController setaudioOrSubtRowIsZero];
            NSArray * audio_infoArr = [[NSArray alloc]init];
            NSArray * subt_infoArr = [[NSArray alloc]init];
            NSArray * epg_infoArr = [[NSArray alloc]init];
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
            [self SetService_videoindex:epgDicToSocket];
            
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
                self.event_videoname = @"";
                self.event_startTime = @"";
                self.event_endTime = @"";
                [GGUtil postsetTimeAndProgressIsNullNotific];
                [self removeTopProgressView];
            }
            isEventStartTimeBiger_NowTime = NO;
            BOOL isEventStartTimeBigNowTime = [self judgeEventStartTime:self.event_videoname startTime:self.event_startTime endTime:self.event_endTime];
            if (isEventStartTimeBigNowTime == YES) {
                self.event_videoname = @"";
                self.event_startTime = @"";
                self.event_endTime = @"";
                [GGUtil postsetTimeAndProgressIsNullNotific];
                [self removeTopProgressView];
            }
            dispatch_queue_t  queueA = dispatch_queue_create("firstOpen",DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queueA, ^{
                [USER_DEFAULT setObject:tempArrForServiceArr forKey:@"tempArrForServiceArr"];
                [USER_DEFAULT setObject:tempDicForServiceArr forKey:@"tempDicForServiceArr"];
            });
            [self judgeAllArgueIsZero];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notice" object:nil];
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
    }
}
-(void)SetService_videoindex:(NSDictionary *)epgDicToSocket
{
    socketView.socket_ServiceModel.service_network_id = [epgDicToSocket objectForKey:@"service_network_id"];
    socketView.socket_ServiceModel.service_ts_id =[epgDicToSocket objectForKey:@"service_ts_id"];
    socketView.socket_ServiceModel.service_tuner_mode = [epgDicToSocket objectForKey:@"service_tuner_mode"];
    socketView.socket_ServiceModel.service_service_id = [epgDicToSocket objectForKey:@"service_service_id"];
    
    
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
}
-(void)showDelivaryStopped
{
    NSArray *data1 = self.serviceData;
    NSArray *recFileData = [USER_DEFAULT objectForKey:@"categorysToCategoryViewContainREC"];
    if (data1.count == 0 && recFileData.count == 0)
    {
        double delayInSeconds = 0;
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, mainQueue, ^{
            [self ifNotISTVView];
            [GGUtil showDeliveryStopIsNull];
        });
        
    }else
    {
        [GGUtil postfullScreenBtnShow];
    }
}
@end

