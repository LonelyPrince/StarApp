//
//  ZXVideoPlayerController.m
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/21.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "ZXVideoPlayerController.h"
#import "ZXVideoPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>

#import "AudioCell.h"
#import "subtCell.h"
#import "ChannelCell.h"
#define KZXVideoStaticTime 6    //静帧时间超过找个时间，则停止播放，显示文字
typedef NS_ENUM(NSInteger, ZXPanDirection){
    ZXPanDirectionHorizontal, // 横向移动
    ZXPanDirectionVertical,   // 纵向移动
    
    
    
};
//typedef enum{
//    subCell = 1,
//    audioCell= 2,
//    channelCell= 3,
//
//}Cell;


/// 播放器显示和消失的动画时长
static const CGFloat kVideoPlayerControllerAnimationTimeInterval = 0.3f;

@interface ZXVideoPlayerController () <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIDeviceOrientation orientationAVer;  //竖
    UIDeviceOrientation orientationBHor;  //横
    NSInteger HorTime ;
    
    NSMutableArray * YFLabelArr;
    
    CGSize sizeChannelId;
    CGSize sizeChannelName;
    CGSize sizeEventName;
    int64_t strBytesTemp ;
    int64_t temptemp ;
    
    
    int64_t byte;
    int64_t byteValue1;   //视频缓存1
    int64_t byteValue2;   //视频缓存2
    
    int currentProgress;
    int subtRow;
    int audioRow;
    
    BOOL  isPlayIng;  //来判断是不是一直在播放的，如果不是则重新播放
    NSInteger   stopPlayTimeOne;   //停止播放的时间
    int   stopPlayTimeTwo;   //停止播放的时间
    float countBytes1;   //记录一次bytes
    
    float tempOne; //记录bytes的临时值
    float tempTwo;
    NSTimer * timerForGetBytes; //获取节目缓冲的大小计时器
    
    int audioPositionIndex;
    int subtPositionIndex;
    int channelPositionIndex;
    int openTime; //用于第一次打开时，触发隐藏方法，防止多次触犯，这里赋值为0
    
    int judgeVideoIsStatic;  //判断视频是否出现了静帧，如果静帧时间超过3秒，则提示不能播放的文字。视频静帧的时候，会触发“媒体网络状态改变的方法”，视频恢复正常播放的时候会触发“播放状态改变”的方法
    
    NSString *  tempUrl;
    
    float RECTime;
    int durationTimeTemp;
}


/// 播放器视图
@property (nonatomic, strong) ZXVideoPlayerControlView *videoControl;

//@property (nonatomic, strong) TVViewController *tvViewControlller;
/// 是否已经全屏模式
@property (nonatomic, assign) BOOL isFullscreenMode;
/// 是否锁定
@property (nonatomic, assign) BOOL isLocked;
/// 设备方向
@property (nonatomic, assign, readonly, getter=getDeviceOrientation) UIDeviceOrientation deviceOrientation;
/// player duration timer
@property (nonatomic, strong) NSTimer *durationTimer;
/// pan手势移动方向
@property (nonatomic, assign) ZXPanDirection panDirection;
/// 快进退的总时长
@property (nonatomic, assign) CGFloat sumTime;
/// 是否在调节音量
@property (nonatomic, assign) BOOL isVolumeAdjust;
/// 系统音量slider
@property (nonatomic, strong) UISlider *volumeViewSlider;
/// rightView是否在显示中
@property (nonatomic, assign) BOOL rightViewShowing;

/////此处是data的dic
@property (nonatomic, strong) NSMutableDictionary *subAudioDic;

@property (nonatomic, strong) NSMutableDictionary *channelDic;

//@property (nonatomic, strong) UITableView *subAudioTableView;

//cell的判断条件
@property (nonatomic, strong) NSString * cellStr;

//@property (nonatomic, strong) id * TableScollTimer;
@property (nonatomic, strong) UILabel * lab ;    //@"sorry, this video/radio can't play"的提示文字
@property (nonatomic, strong) UIImageView * radioImageView ; //展示音频的默认图
@property (nonatomic, strong) UILabel * decoderPINLab ; //展示decoder PIN 的文字
@property (nonatomic, strong) UIButton * decoderPINBtn ; //展示decoder PIN 的按钮


@property (nonatomic, strong) UILabel * CAPINLab ; //展示CA PIN 的文字
@property (nonatomic, strong) UIButton * CAPINBtn ; //展示CA PIN 的按钮
@property (nonatomic, strong) NSTimer * timerOfEventTime;

@property (nonatomic, weak) UIImageView *imageView1;  //侧边渐变的效果图
@property (nonatomic, weak) UIView *nullView;  //侧边渐变的效果图

@end

@implementation ZXVideoPlayerController

@synthesize socketView1;
@synthesize lab;
@synthesize radioImageView; //展示音频的默认图
@synthesize decoderPINLab; //展示decoder PIN 的文字
@synthesize decoderPINBtn; //展示decoder PIN 的按钮

@synthesize CAPINLab; //展示CA PIN 的文字
@synthesize CAPINBtn; //展示CA PIN 的按钮
@synthesize timerOfEventTime;
//@synthesize operationQueue;
//@synthesize tvViewController;
#pragma mark - life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init:frame];
    if (self) {
        RECTime = 0.f;
        openTime = 0;
        currentProgress = 0;
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor blackColor]; //blackColor
        NSLog(@"页面要显示了，显示了，显示了");
        //        self.view.backgroundColor = [UIColor redColor];
        //        tvViewController = [[TVViewController alloc]init];
        //        self.controlStyle = MPMovieControlStyleNone;
        [self.view addSubview:self.videoControl];
        self.videoControl.frame = self.view.bounds;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
        pan.delegate = self;
        [self.videoControl addGestureRecognizer:pan];
        
        [self configObserver];
        [self configControlAction];
        [self configDeviceOrientationObserver];
        [self configVolume];
        
        [self configLabNoPlayShow]; //如果视频无法播放，则显示sorry，this video cant play 的字样
        [self configIndicatorView]; //视频未播放加载钱，显示进度圈
        
        [self configRadioShow];  //判断当播放音频时，如果可以播放，则显示音频默认图
        [self configDecoderPINShow];  //判断当前是不是需要展示decoder PIN的输入按钮和文字
        
        [self configCAPINShow];  //判断当前是不是需要展示CA PIN的输入按钮和文字
        [self removeConfigRadioShow];  //如果不是音频节目，或者音频节目播放完成，则删除掉音频图
        [self removeConfigDecoderPINShow];  //如果用户点击了按钮，则发送删除通知把decoder的文字和按钮删除掉
        [self removeConfigCAPINShow]; //取消掉CAPIN的文字和按钮删除掉
        
        [self configIndicatorViewHidden]; //开始播放或者几秒后仍未播放则取消加载进度圈，改为sorry提示字
        
        [self setChannelNameOrOtherInfo];   //设置频道名称和其他信息
        [self setChannelNameAndEventName];   //快速设置频道名称和节目名称等信息
        [self configLabNoPlayShowShut]; //播放活加载状态，不显示播放字样
        
        [self reConnectSocketFromDisConnectNotic]; //socket断开后，重新连接socket
        
        self.rightViewShowing = NO;
        //                self.tvViewControlller = [[TVViewController alloc]init];
        self.socketView1 = [[SocketView alloc]init];
        HorTime =0;
        
        [self configTimerOfEventTimeNotific]; //timerOfEventTime
        
        subtRow = 0;
        audioRow = 0;
        
        //        [self configObserver];
        [self installMovieNotificationObservers];
        //        operationQueue = [[NSOperationQueue alloc]init];
        audioPositionIndex = 0;
        subtPositionIndex = 0;
        channelPositionIndex = 0;
        judgeVideoIsStatic = 0;
        [self initData];
    }
    return self;
}

#pragma mark -
#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    // UISlider & UIButton & topBar 不需要响应手势
    if([touch.view isKindOfClass:[UISlider class]] || [touch.view isKindOfClass:[UIButton class]] || [touch.view.accessibilityIdentifier isEqualToString:@"TopBar"] || [touch.view.accessibilityIdentifier isEqualToString:@"bottomBar"]  ) {
        //        || [touch.view.accessibilityIdentifier isEqualToString:@"RightView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]  || [touch.view isKindOfClass:[UITableViewCell class]] || [touch.view isKindOfClass:[UIScrollView class]]  || [touch.view isKindOfClass:[UITableView class]]
        return NO;
    } else {
        return YES;
    }
}

#pragma mark -
#pragma mark - Public Method

/// 展示播放器
- (void)showInView:(UIView *)view
{
    if ([UIApplication sharedApplication].statusBarStyle !=  UIStatusBarStyleLightContent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    [view addSubview:self.view];
    
    self.view.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeInterval animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {}];
    
    if (self.getDeviceOrientation == UIDeviceOrientationLandscapeLeft || self.getDeviceOrientation == UIDeviceOrientationLandscapeRight) {
        [self changeToOrientation:self.getDeviceOrientation];
    } else {
        [self changeToOrientation:UIDeviceOrientationPortrait];
    }
}

#pragma mark -
#pragma mark - Private Method

/// 控件点击事件
- (void)configControlAction
{
    [self.videoControl.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //    [self.videoControl.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.shrinkScreenButton1 addTarget:self action:@selector(shrinkScreenButton1Click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.videoControl.lockButton addTarget:self action:@selector(lockButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //////
    [self.videoControl.lastChannelButton addTarget:self action:@selector(lastChannelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.suspendButton addTarget:self action:@selector(suspendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.nextChannelButton addTarget:self action:@selector(nextChannelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.subtBtn addTarget:self action:@selector(subtBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.audioBtn addTarget:self action:@selector(audioBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.channelListBtn addTarget:self action:@selector(channelListBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // slider
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchCancel];
    
    [self setProgressSliderMaxMinValues];
//    [self monitorVideoPlayback];
}

/// 开始播放时根据视频文件长度设置slider最值
- (void)setProgressSliderMaxMinValues
{
//    CGFloat duration = self.duration;
    self.videoControl.progressSlider.minimumValue = 0.f;
    self.videoControl.progressSlider.maximumValue = 0.f;
}

/// 监听播放进度
- (void)monitorVideoPlayback
{
    RECTime ++;
    
    //    double currentTime = currentProgress;
    //    double totalTime = 50;
    ////    // 更新时间
    //    [self setTimeLabelValues:currentTime totalTime:totalTime];
    ////     更新播放进度
    self.videoControl.progressSlider.minimumValue = 0;// 设置最小值
    self.videoControl.progressSlider.maximumValue = 100;// 设置最大值
//    NSLog(@"self.player.playableDurationself.player.playableDuration %f",self.player.playableDuration);
    self.videoControl.progressSlider.value = self.player.playableDuration/durationTimeTemp * 100 ;// 设置初始值 ===》  此处的val = 当前时间/总时间 * 100  每一秒刷新一次，计算一次时间
  
    NSLog(@"self.player.playableDuration1 %f",self.player.playableDuration);
    NSLog(@"self.player.playableDuration33 %d",durationTimeTemp);
    NSLog(@"self.player.playableDuration2 %f",self.videoControl.progressSlider.value);
   
}

/// 更新播放时间显示
- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    NSString *timeElapsedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining = floor(totalTime / 60.0);
    double secondsRemaining = floor(fmod(totalTime, 60.0));
    NSString *timeRmainingString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesRemaining, secondsRemaining];
    
    self.videoControl.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeElapsedString,timeRmainingString];
}

/// 开启定时器
- (void)startDurationTimer
{
    BOOL IsfirstPlayRECVideo = [USER_DEFAULT objectForKey:@"IsfirstPlayRECVideo"];
    durationTimeTemp = [[USER_DEFAULT objectForKey:@"RECVideoDurationTime"] intValue];
    if ( IsfirstPlayRECVideo == YES) { //第一次操作
        self.videoControl.progressSlider.value = 0;
    }else
    {
        self.videoControl.progressSlider.value = self.player.playableDuration/durationTimeTemp * 100;
    }
    if ( IsfirstPlayRECVideo == YES) {
        RECTime = 0;
        [self.durationTimer invalidate];
        self.durationTimer = nil;
        
        self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSRunLoopCommonModes];
        
        [USER_DEFAULT setObject:@"NO" forKey:@"IsfirstPlayRECVideo"];
    }else
    {
        if (self.durationTimer) {
            [self.durationTimer setFireDate:[NSDate date]];
        } else {
            self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSRunLoopCommonModes];
            
            [USER_DEFAULT setObject:@"NO" forKey:@"IsfirstPlayRECVideo"];
        }
    }
   
}

/// 暂停定时器
- (void)stopDurationTimer
{
    if (_durationTimer) {
        [self.durationTimer setFireDate:[NSDate distantFuture]];
    }
}

/// MARK: 播放器状态通知

/// 监听播放器状态通知
- (void)configObserver
{
    // 播放状态改变，可配合playbakcState属性获取具体状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackStateDidChangeNotification) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:nil];  //IJKMPMoviePlayerPlaybackDidFinishNotification
    
    // 媒体网络加载状态改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.player];
    
    // 视频显示状态改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerReadyForDisplayDidChangeNotification) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.player];
    
    // 确定了媒体播放时长后
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMovieDurationAvailableNotification) name:MPMovieDurationAvailableNotification object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPayerControlViewHideNotification) name:kZXPlayerControlViewHideNotification object:self.player];
    
    // 视频播放结束时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackDidFinishNotification:) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    
}
//{
//    // 播放状态改变，可配合playbakcState属性获取具体状态
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackStateDidChangeNotification) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
//
//    // 媒体网络加载状态改变
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
//
//    // 视频显示状态改变
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerReadyForDisplayDidChangeNotification) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
//
//    // 确定了媒体播放时长后
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMovieDurationAvailableNotification) name:MPMovieDurationAvailableNotification object:nil];
//
//    // 视频播放结束时
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackDidFinishNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPayerControlViewHideNotification) name:kZXPlayerControlViewHideNotification object:nil];
//}

/// 播放状态改变, 可配合playbakcState属性获取具体状态
- (void)onMPMoviePlayerPlaybackStateDidChangeNotification
{
    NSLog(@"卡拉  开始配置  开始播放了，取消静帧");
    NSLog(@"judgeVideoIsStatic 为 %d",judgeVideoIsStatic);
    /*
    if (judgeVideoIsStatic == 1) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayAndShowLabel) object:nil];
            judgeVideoIsStatic = 0;
            
            [self.view insertSubview:self.player.view atIndex:0];
//            if (self.player.playbackState == MPMoviePlaybackStateInterrupted || self.player.playbackState == MPMoviePlaybackStateStopped) {
                [self.player play];
                NSLog(@"播放停止了，重新播放");
                
//            }
    
        }
     */
    NSLog(@"xxxxxx 播放状态改变,  开始播放了，取消静帧");
    if (openTime == 0) {
        self.videoControl.pauseButton.hidden = NO;
        self.videoControl.playButton.hidden = YES;
        //    [self startDurationTimer];
        
        [self.videoControl.indicatorView stopAnimating];
        [self.videoControl autoFadeOutControlBar];
        openTime ++ ;
        NSLog(@"openTimeopenTimeopenTimeopenTime");
    }
    
}

-(void)stopPlayAndShowLabel  //如果静帧超过3秒钟，显示不能播放的文字
{
    NSLog(@"卡拉  开始配置 进入方法22");
    [USER_DEFAULT setObject:videoCantPlayTip forKey:@"playStateType"];
    [USER_DEFAULT setObject:@"Lab" forKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
    
//    NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
//    //        //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self stopPlayAndWaitBuffering];
    
}
/// 媒体网络加载状态改变
- (void)onMPMoviePlayerLoadStateDidChangeNotification
{
    NSLog(@"卡拉  开始配置 进入方法1");
    NSLog(@"judgeVideoIsStatic 为 %d",judgeVideoIsStatic);
    if (judgeVideoIsStatic == 0) {
        //        /    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(runThread1) object:nil];
        NSLog(@"卡拉  开始配置 进入方法11");
   /*
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayAndShowLabel) object:nil];
        [self performSelector:@selector(stopPlayAndShowLabel) withObject:nil afterDelay:KZXVideoStaticTime];
    */
//        double delayInSeconds = KZXVideoStaticTime;
//        dispatch_queue_t mainQueue = dispatch_get_main_queue();
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, mainQueue, ^{
//        
//            [self stopPlayAndShowLabel];
//        });
        
        judgeVideoIsStatic = 1;
    }
    NSLog(@"xxxxxx MPMoviePlayer  开始3秒的静帧等待");
    NSLog(@"MPMoviePlayer  加载");
    if (MPMovieLoadStateUnknown) {
        NSLog(@"playState---=====状态未知");
    }
    if (self.loadState & MPMovieLoadStateStalled) {
        NSLog(@"准备开始加载");
        NSLog(@"playState---=====正在加载中");
        NSLog(@"MPMoviePlayer  开始加载");
        NSLog(@"playState111---.self.loadState %lu",(unsigned long)self.loadState);
        
        //如果URL为空，则不进行播放
        if(self.video.playUrl == NULL || [self.video.playUrl isEqualToString:@""] ||self.video.playUrl == nil)
        {
            [self.videoControl.indicatorView stopAnimating];
            NSLog(@"数据开始加载，圆圈暂停");
        }else
        {
            [self.videoControl.indicatorView startAnimating];
        }
        
        //        //创建通知
        //        NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
        //        //通过通知中心发送通知
        //        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else
    {   NSLog(@"playState222---.self.loadState %lu",(unsigned long)self.loadState);
        if (MPMovieLoadStateUnknown) {
            NSLog(@"playState---=====状态未知");
        }if (MPMovieLoadStatePlayable) {
            NSLog(@"playState---=====缓存数据足够开始播放，但是视频并没有缓存完全");
        }if (MPMovieLoadStatePlaythroughOK) {
            NSLog(@"playState---=====已经缓存完成，如果设置了自动播放，这时会自动播放");
        }
        NSLog(@"MPMoviePlayer  停止加载");
        NSLog(@"playState---=====停止加载");
        
        //获取当前是否正在播放的信息
        NSString * isVideoPlaying = [USER_DEFAULT objectForKey: @"isStartBeginPlay"]; //是否已经开始播放，如果已经开始播放，则停止掉中心点的旋转等待圆圈
        
        if ([isVideoPlaying isEqualToString:@"YES"]) {
            [self.videoControl.indicatorView stopAnimating];
        }else
        {
            //        [self.videoControl.indicatorView stopAnimating];
        }
        
        NSLog(@"数据停止加载，圆圈暂停");
    }
}

/// 视频显示状态改变
- (void)onMPMoviePlayerReadyForDisplayDidChangeNotification
{
    NSLog(@"开始播放");
    
    NSString * channelType = [USER_DEFAULT objectForKey:@"ChannelType"];
    if ([channelType isEqualToString:@"RECChannel"]) {
        [self startDurationTimer];
    }
    
    NSLog(@"xxxxxx MPMoviePlayer  Notification 视频显示状态改变");
    NSLog(@"MPMoviePlayer  视频显示状态改变");
    NSLog(@"playState---=====视频显示状态改变");
}

/// 确定了媒体播放时长
- (void)onMPMovieDurationAvailableNotification
{
    NSLog(@"MPMovie  DurationAvailable  Notification");
//    [self startDurationTimer];
//    [self setProgressSliderMaxMinValues];
    
    //    self.videoControl.fullScreenButton.hidden = NO;
    if ([[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"NO"]) {
        self.videoControl.fullScreenButton.hidden = NO;
    }else
    {
        self.videoControl.fullScreenButton.hidden = YES;
    }
    //    self.videoControl.shrinkScreenButton.hidden = YES;
    self.videoControl.shrinkScreenButton1.hidden = YES;
    self.videoControl.lastChannelButton.hidden = YES;
    self.videoControl.suspendButton.hidden = YES;
    self.videoControl.nextChannelButton.hidden = YES;
    self.videoControl.subtBtn.hidden = YES;
    self.videoControl.audioBtn.hidden = YES;
    self.videoControl.channelListBtn.hidden = YES;
    self.videoControl.eventTimeLabNow.hidden = YES;
    self.videoControl.eventTimeLabAll.hidden = YES;
    
    
    //    self.videoControl.backButton.hidden = YES;
}

//视频播放结束时
-(void)onMPMoviePlayerPlaybackDidFinishNotification:(NSNotification*)notification
{
    //判断是不是播放的录制节目
    if ([self.videoControl.channelIdLab.text  isEqual: @""] || [self.videoControl.channelIdLab.text isEqualToString:@""]) {
        
        [self shrinkScreenButton1Click];
    }
    NSLog(@"xxxxxx playState---=====视频播放结束 视频播放结束时");
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayAndShowLabel) object:nil];
//    [self performSelector:@selector(stopPlayAndShowLabel) withObject:nil afterDelay:KZXVideoStaticTime];
//    
//    judgeVideoIsStatic = 1;
    
    NSLog(@"xxxxxx 新加的方法，如果实现了这个方法，视频将在3秒后停止");
    
    
    NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:{
            NSLog(@"playbackFinished. Reason: Playback Ended");
        }
            break;
        case MPMovieFinishReasonPlaybackError:{
            NSLog(@"playbackFinished. Reason: Playback Error");
            //new
            //            [self stop];
            //            [self prepareToPlay];
            //            [self play];
            //            NSLog(@"stopPlayTimeOne 重新开始");
            //            isPlayIng = NO;  //这里对判断是否播放的值赋初值
            //            stopPlayTimeOne = 0;
            //            stopPlayTimeTwo = 0;
            //            tempOne = 0.0;
            //            tempTwo = 0.0;
            
        }
            break;
        case MPMovieFinishReasonUserExited:
            NSLog(@"playbackFinished. Reason: User Exited");
            break;
        default:
            break;
    }
}

/// 控制视图隐藏
- (void)onPayerControlViewHideNotification
{///如果是全屏模式
    if (self.isFullscreenMode) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

/// MARK: pan手势处理

/// pan手势触发
- (void)panDirection:(UIPanGestureRecognizer *)pan
{
    CGPoint locationPoint = [pan locationInView:self.videoControl];
    CGPoint veloctyPoint = [pan velocityInView:self.videoControl];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: { // 开始移动
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            
            if (x > y) { // 水平移动
                if ([self.videoControl.channelIdLab.text  isEqual: @""] || [self.videoControl.channelIdLab.text isEqualToString:@""]) {
                    //录制
                    self.panDirection = ZXPanDirectionHorizontal;
                    self.sumTime = self.player.playableDuration; //currentPlaybackTime; // sumTime初值
                    NSLog(@"currentPlaybackTime== %f",self.player.currentPlaybackTime);
                    [self.player pause];
                    [self stopDurationTimer];
                }else
                {
                }
                
            } else if (x < y) { // 垂直移动
                self.panDirection = ZXPanDirectionVertical;
                if (locationPoint.x > self.view.bounds.size.width / 2) { // 音量调节
                    self.isVolumeAdjust = YES;
                } else { // 亮度调节
                    self.isVolumeAdjust = NO;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged: { // 正在移动
            switch (self.panDirection) {
                case ZXPanDirectionHorizontal: {
                    
                    if ([self.videoControl.channelIdLab.text  isEqual: @""] || [self.videoControl.channelIdLab.text isEqualToString:@""]) {
                        //录制
                        [self horizontalMoved:veloctyPoint.x];
                        NSLog(@"veloctyPoint.x %f",veloctyPoint.x);
                        NSLog(@"floor(self.sumTime) %f",floor(self.sumTime));
                    }else
                    {
                    }

                }
                    break;
                case ZXPanDirectionVertical: {
                    [self verticalMoved:veloctyPoint.y];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case UIGestureRecognizerStateEnded: { // 移动停止
            switch (self.panDirection) {
                case ZXPanDirectionHorizontal: {
                    if ([self.videoControl.channelIdLab.text  isEqual: @""] || [self.videoControl.channelIdLab.text isEqualToString:@""]) {
                        //录制
//                        NSLog(@"floor(self.sumTime) %f",floor(self.sumTime));
                        [self.player seek:floor(self.sumTime)];
                        [self.player play];
                        [self startDurationTimer];
                        [self.videoControl autoFadeOutControlBar];
                    }else
                    {
                        //                    [self.player seek:floor(self.sumTime)];
                        [self.player play];
                        [self startDurationTimer];
                        [self.videoControl autoFadeOutControlBar];
                    }

                }
                    break;
                case ZXPanDirectionVertical: {
                    break;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

/// pan水平移动
- (void)horizontalMoved:(CGFloat)value
{
    // 每次滑动叠加时间
    self.sumTime += value / 200;
     NSLog(@"self.sumTime01: %f",self.sumTime);
    // 容错处理
    if (self.sumTime > durationTimeTemp) {
        self.sumTime = durationTimeTemp;
    } else if (self.sumTime < 0) {
        self.sumTime = 0;
    }
    NSLog(@"self.sumTime02: %f",self.sumTime);
    NSLog(@"self.sumTime03: %f",self.player.playableDuration); //self.player.duration);
    NSLog(@"self.sumTime03！！: %f",self.player.duration); //self.player.duration);
    // 时间更新
    double currentTime = self.sumTime;
    double totalTime =  durationTimeTemp;//self.player.playableDuration;
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    // 提示视图
    self.videoControl.timeIndicatorView.labelText = self.videoControl.timeLabel.text;
    // 播放进度更新
    self.videoControl.progressSlider.value =  self.sumTime/durationTimeTemp * 100;//self.sumTime;
    
    // 快进or后退 状态调整
    ZXTimeIndicatorPlayState playState = ZXTimeIndicatorPlayStateRewind;
    
    if (value < 0) { // left
        playState = ZXTimeIndicatorPlayStateRewind;
    } else if (value > 0) { // right
        playState = ZXTimeIndicatorPlayStateFastForward;
    }
    
    if (self.videoControl.timeIndicatorView.playState != playState) {
        if (value < 0) { // left
            NSLog(@"------fast rewind");
            self.videoControl.timeIndicatorView.playState = ZXTimeIndicatorPlayStateRewind;
            [self.videoControl.timeIndicatorView setNeedsLayout];
        } else if (value > 0) { // right
            NSLog(@"------fast forward");
            self.videoControl.timeIndicatorView.playState = ZXTimeIndicatorPlayStateFastForward;
            [self.videoControl.timeIndicatorView setNeedsLayout];
        }
    }
}


/// pan垂直移动
- (void)verticalMoved:(CGFloat)value
{
    if (self.isVolumeAdjust) {
        // 调节系统音量
        // [MPMusicPlayerController applicationMusicPlayer].volume 这种简单的方式调节音量也可以，只是CPU高一点点
        self.volumeViewSlider.value -= value / 10000;
    }else {
        // 亮度
        [UIScreen mainScreen].brightness -= value / 10000;
    }
}

/// MARK: 系统音量控件

/// 获取系统音量控件
- (void)configVolume
{
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    volumeView.center = CGPointMake(-1000, 0);
    [self.view addSubview:volumeView];
    
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *error = nil;
    BOOL success = [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &error];
    
    if (!success) {/* error */}
    
    // 监听耳机插入和拔掉通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}
//播放失败或者开始播放，去掉加载圈
-(void)configIndicatorViewHidden
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IndicatorViewHiddenNotic" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IndicatorViewHiddenNotic) name:@"IndicatorViewHiddenNotic" object:nil];
    
}
-(void)IndicatorViewHiddenNotic
{
    [self.videoControl.indicatorView stopAnimating];
    NSLog(@"圆圈停止的通知，圆圈暂停");
}
//设置节目名称和其他信息的通知
-(void)setChannelNameOrOtherInfo
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setChannelNameOrOtherInfoNotic" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setChannelNameOrOtherInfoNotic:) name:@"setChannelNameOrOtherInfoNotic" object:nil];
}
-(void)setChannelNameOrOtherInfoNotic :(NSNotification *)text{
    
    NSLog(@"kasdbfo;bsafobassssssss");
    NSString * channelIdLabStr = text.userInfo[@"channelIdStr"];
    NSString * channelNameLabStr = text.userInfo[@"channelNameStr"];
    self.video.channelId =channelIdLabStr;
    self.video.channelName =channelNameLabStr;
    self.videoControl.channelIdLab.text = self.video.channelId;
    
    self.videoControl.channelNameLab.text = self.video.channelName;
}
#pragma mark -未播放前显示加载圈 ①显示加载圈时停止显示decoder PIN 按钮 ②停止显示不能播放文字
//未播放前显示加载圈
-(void)configIndicatorView
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IndicatorViewShowNotic" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IndicatorViewShowNotic) name:@"IndicatorViewShowNotic" object:nil];
}
//未播放前显示加载圈的通知 ①显示加载圈时停止显示decoder PIN 按钮 ②停止显示不能播放文字
-(void)IndicatorViewShowNotic
{   //如果URL为空，则不进行播放
    //    if(self.video.playUrl == NULL || [self.video.playUrl isEqualToString:@""] ||self.video.playUrl == nil)
    //    {
    //        [self.videoControl.indicatorView stopAnimating];
    //    }else
    //    {
    [self removeConfigDecoderPINShowNotific];   //删除掉了decoder PIN的文字和按钮
    
    [self removeConfigCAPINShowNotific];   //删除掉了CA PIN的文字和按钮
    
    [self.videoControl.indicatorView startAnimating];
    
    //    }
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
#pragma mark -如果不能播放 ，则①显示不能播放的文字  ② 取消掉加载环  ③  通知播放的动作               以下几种情况可以使用①CRC 错误（此时的CRC也无法判断）  ②播放时间超过15秒  ③播放器通知（暂时没有找到不能播放的通知）  ④盒子主动停掉，盒子的stop通知（socket 16：代表我主动停止分发   socket 19：代表机顶盒主动停）
//如果不能播放，则显示不能播放字样
-(void)configLabNoPlayShow
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noPlayShowNotic" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noPlayShowNotic) name:@"noPlayShowNotic" object:nil];
}

#pragma mark - CA PIN输入按钮和文字展示
-(void)configCAPINShow
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"configCAPINShowNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configCAPINShowNotific) name:@"configCAPINShowNotific" object:nil];
    
    
    
}
-(void)configCAPINShowNotific
{
    
    [USER_DEFAULT setObject:@"POP" forKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
    NSNotification *notification1 =[NSNotification notificationWithName:@"noPlayShowShutNotic" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    
    NSNotification *notification =[NSNotification notificationWithName:@"IndicatorViewShowNotic" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.player stop];
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    
    [self.videoControl.indicatorView stopAnimating];
    NSLog(@"CAPINLab.frame %@",NSStringFromCGRect(CAPINLab.frame));
    NSLog(@"CAPINBtn.frame %@",NSStringFromCGRect(CAPINBtn.frame));
    
    UIDeviceOrientation orientation = self.getDeviceOrientation;
    if (!self.isLocked)
    {
        switch (orientation) {
            case UIDeviceOrientationPortrait: {           // Device oriented vertically, home button on the bottom
                NSLog(@"home键在 下");
                [self restoreOriginalScreen];
                
                
                if (!CAPINLab) {
                    CAPINLab = [[UILabel alloc]init];
                    CAPINLab.text = @"Please input";
                    CAPINLab.textColor = [UIColor whiteColor];
                    CAPINBtn = [[UIButton alloc]init];
                    [CAPINBtn setTitle:@"  CA PIN  " forState:UIButtonTypeCustom];
                    [CAPINBtn.layer setBorderColor:[[UIColor grayColor] CGColor] ];//边框颜色
                    [CAPINBtn.layer setBorderWidth:2.0f];
                    [CAPINBtn addTarget:self action:@selector(CAPINBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    //        [self.view addSubview:radioImageView];
                    //                    [self.view insertSubview:decoderPINLab atIndex:1];
                    [self.view addSubview:CAPINLab];
                    [self.view addSubview:CAPINBtn];
                    //                    [self.view insertSubview:decoderPINBtn atIndex:1];
                }
                CGSize sizeCAPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CGSize sizeCAPINBtn = [GGUtil sizeWithText:@"  CA PIN  " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CAPINLab.frame = CGRectMake((SCREEN_WIDTH - sizeCAPIN.width)/2,SCREEN_WIDTH/16*9/2-15, sizeCAPIN.width, sizeCAPIN.height);
                CAPINLab.textAlignment = NSTextAlignmentCenter;
                CAPINBtn.frame = CGRectMake((SCREEN_WIDTH - sizeCAPINBtn.width)/2,SCREEN_WIDTH/16*9/2+15, sizeCAPINBtn.width, sizeCAPIN.height);
                CAPINBtn.layer.cornerRadius = 14.0f;
                CAPINBtn.layer.masksToBounds = YES;
                
                //                    lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                
                
            }
                break;
            case UIDeviceOrientationPortraitUpsideDown: { // Device oriented vertically, home button on the top
                NSLog(@"home键在 上");
                
                if (!CAPINLab) {
                    CAPINLab = [[UILabel alloc]init];
                    CAPINLab.text = @"Please input";
                    CAPINLab.textColor = [UIColor whiteColor];
                    CAPINBtn = [[UIButton alloc]init];
                    [CAPINBtn setTitle:@"  CA PIN  " forState:UIButtonTypeCustom];
                    [CAPINBtn.layer setBorderColor:[[UIColor grayColor] CGColor] ];//边框颜色
                    [CAPINBtn.layer setBorderWidth:2.0f];
                    [CAPINBtn addTarget:self action:@selector(CAPINBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    //        [self.view addSubview:radioImageView];
                    //                    [self.view insertSubview:decoderPINLab atIndex:1];
                    [self.view addSubview:CAPINLab];
                    [self.view addSubview:CAPINBtn];
                    //                    [self.view insertSubview:decoderPINBtn atIndex:1];
                }
                CGSize sizeCAPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CGSize sizeCAPINBtn = [GGUtil sizeWithText:@"  CA PIN  " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CAPINLab.frame = CGRectMake((SCREEN_WIDTH - sizeCAPIN.width)/2,SCREEN_WIDTH/16*9/2-15, sizeCAPIN.width, sizeCAPIN.height);
                CAPINLab.textAlignment = NSTextAlignmentCenter;
                CAPINBtn.frame = CGRectMake((SCREEN_WIDTH - sizeCAPINBtn.width)/2,SCREEN_WIDTH/16*9/2+15, sizeCAPINBtn.width, sizeCAPIN.height);
                CAPINBtn.layer.cornerRadius = 14.0f;
                CAPINBtn.layer.masksToBounds = YES;
                
            }
                break;
            case UIDeviceOrientationLandscapeLeft: {      // Device oriented horizontally, home button on the right
                NSLog(@"home键在 右");
                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                
                if (!CAPINLab) {
                    CAPINLab = [[UILabel alloc]init];
                    CAPINLab.text = @"Please input";
                    CAPINLab.textColor = [UIColor whiteColor];
                    CAPINBtn = [[UIButton alloc]init];
                    [CAPINBtn setTitle:@"  CA PIN  " forState:UIButtonTypeCustom];
                    [CAPINBtn.layer setBorderColor:[[UIColor grayColor] CGColor] ];//边框颜色
                    [CAPINBtn.layer setBorderWidth:2.0f];
                    [CAPINBtn addTarget:self action:@selector(CAPINBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    //        [self.view addSubview:radioImageView];
                    //                    [self.view insertSubview:decoderPINLab atIndex:1];
                    [self.view addSubview:CAPINLab];
                    [self.view addSubview:CAPINBtn];
                    //                    [self.view insertSubview:decoderPINBtn atIndex:1];
                }
                CGSize sizeCAPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CGSize sizeCAPINBtn = [GGUtil sizeWithText:@"  CA PIN  " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CAPINLab.frame = CGRectMake((self.view.frame.size.width - sizeCAPIN.width)/2,self.view.frame.size.height/2-15, sizeCAPIN.width, sizeCAPIN.height);
                CAPINLab.textAlignment = NSTextAlignmentCenter;
                CAPINBtn.frame = CGRectMake((self.view.frame.size.width - sizeCAPINBtn.width)/2,self.view.frame.size.height/2+15, sizeCAPINBtn.width, sizeCAPIN.height);
                CAPINBtn.layer.cornerRadius = 14.0f;
                CAPINBtn.layer.masksToBounds = YES;
                
            }
                break;
            case UIDeviceOrientationLandscapeRight: {     // Device oriented horizontally, home button on the left
                NSLog(@"home键在 左");
                //                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeRight];
                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                
                if (!CAPINLab) {
                    CAPINLab = [[UILabel alloc]init];
                    CAPINLab.text = @"Please input";
                    CAPINLab.textColor = [UIColor whiteColor];
                    CAPINBtn = [[UIButton alloc]init];
                    [CAPINBtn setTitle:@"  CA PIN  " forState:UIButtonTypeCustom];
                    [CAPINBtn.layer setBorderColor:[[UIColor grayColor] CGColor] ];//边框颜色
                    [CAPINBtn.layer setBorderWidth:2.0f];
                    [CAPINBtn addTarget:self action:@selector(CAPINBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    //        [self.view addSubview:radioImageView];
                    //                    [self.view insertSubview:decoderPINLab atIndex:1];
                    [self.view addSubview:CAPINLab];
                    [self.view addSubview:CAPINBtn];                    //                    [self.view insertSubview:decoderPINBtn atIndex:1];
                }
                CGSize sizeCAPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CGSize sizeCAPINBtn = [GGUtil sizeWithText:@"  CA PIN  " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CAPINLab.frame = CGRectMake((self.view.frame.size.width - sizeCAPIN.width)/2,self.view.frame.size.height/2-15, sizeCAPIN.width, sizeCAPIN.height);
                CAPINLab.textAlignment = NSTextAlignmentCenter;
                CAPINBtn.frame = CGRectMake((self.view.frame.size.width - sizeCAPINBtn.width)/2,self.view.frame.size.height/2+15, sizeCAPINBtn.width, sizeCAPIN.height);
                CAPINBtn.layer.cornerRadius = 14.0f;
                CAPINBtn.layer.masksToBounds = YES;
                
            }
                break;
                
            default:   //
            {           // Device oriented vertically, home button on the bottom
                NSLog(@"手机可能屏幕朝上，可能不知道方向，可能斜着");
                //                [self restoreOriginalScreen];
                if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 420 )  {           // Device oriented vertically, home button on the bottom
                    //此时是竖屏状态
                    NSLog(@"home键在 下");
                    [self restoreOriginalScreen];
                    
                    
                    if (!CAPINLab) {
                        CAPINLab = [[UILabel alloc]init];
                        CAPINLab.text = @"Please input";
                        CAPINLab.textColor = [UIColor whiteColor];
                        CAPINBtn = [[UIButton alloc]init];
                        [CAPINBtn setTitle:@"  CA PIN  " forState:UIButtonTypeCustom];
                        [CAPINBtn.layer setBorderColor:[[UIColor grayColor] CGColor] ];//边框颜色
                        [CAPINBtn.layer setBorderWidth:2.0f];
                        [CAPINBtn addTarget:self action:@selector(CAPINBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        
                        //        [self.view addSubview:radioImageView];
                        //                    [self.view insertSubview:decoderPINLab atIndex:1];
                        [self.view addSubview:CAPINLab];
                        [self.view addSubview:CAPINBtn];
                        //                    [self.view insertSubview:decoderPINBtn atIndex:1];
                    }
                    CGSize sizeCAPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                    CGSize sizeCAPINBtn = [GGUtil sizeWithText:@"  CA PIN  " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];;
                    CAPINLab.frame = CGRectMake((SCREEN_WIDTH - sizeCAPIN.width)/2,SCREEN_WIDTH/16*9/2-15, sizeCAPIN.width, sizeCAPIN.height);
                    CAPINLab.textAlignment = NSTextAlignmentCenter;
                    CAPINBtn.frame = CGRectMake((SCREEN_WIDTH - sizeCAPINBtn.width)/2,SCREEN_WIDTH/16*9/2+15, sizeCAPINBtn.width, sizeCAPIN.height);
                    CAPINBtn.layer.cornerRadius = 14.0f;
                    CAPINBtn.layer.masksToBounds = YES;
                    
                }else //此时是横屏状态
                {     // Device oriented horizontally, home button on the left
                    NSLog(@"home键在 左");
                    //                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeRight];
                    [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                    
                    if (!CAPINLab) {
                        CAPINLab = [[UILabel alloc]init];
                        CAPINLab.text = @"Please input";
                        CAPINLab.textColor = [UIColor whiteColor];
                        CAPINBtn = [[UIButton alloc]init];
                        [CAPINBtn setTitle:@"  CA PIN  " forState:UIButtonTypeCustom];
                        [CAPINBtn.layer setBorderColor:[[UIColor grayColor] CGColor] ];//边框颜色
                        [CAPINBtn.layer setBorderWidth:2.0f];
                        [CAPINBtn addTarget:self action:@selector(CAPINBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        
                        //        [self.view addSubview:radioImageView];
                        //                    [self.view insertSubview:decoderPINLab atIndex:1];
                        [self.view addSubview:CAPINLab];
                        [self.view addSubview:CAPINBtn];                    //                    [self.view insertSubview:decoderPINBtn atIndex:1];
                    }
                    CGSize sizeCAPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                    CGSize sizeCAPINBtn = [GGUtil sizeWithText:@"  CA PIN  " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                    CAPINLab.frame = CGRectMake((SCREEN_HEIGHT - sizeCAPIN.width)/2,SCREEN_WIDTH/2-15, sizeCAPIN.width, sizeCAPIN.height);
                    CAPINLab.textAlignment = NSTextAlignmentCenter;
                    CAPINBtn.frame = CGRectMake((SCREEN_HEIGHT - sizeCAPINBtn.width)/2,SCREEN_WIDTH/2+15, sizeCAPINBtn.width, sizeCAPIN.height);
                    CAPINBtn.layer.cornerRadius = 14.0f;
                    CAPINBtn.layer.masksToBounds = YES;
                    
                }
                
            }
                break;
        }
    }
    
}
#pragma mark - decoder PIN输入按钮和文字展示
-(void)configDecoderPINShow
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"configDecoderPINShowNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configDecoderPINShowNotific) name:@"configDecoderPINShowNotific" object:nil];
    
}
-(void)configDecoderPINShowNotific
{
    [USER_DEFAULT setObject:@"POP" forKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
    NSNotification *notification1 =[NSNotification notificationWithName:@"noPlayShowShutNotic" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    
    NSNotification *notification =[NSNotification notificationWithName:@"IndicatorViewShowNotic" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.player stop];
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    
    [self.videoControl.indicatorView stopAnimating];
    NSLog(@"decoderPINLab.frame %@",NSStringFromCGRect(decoderPINLab.frame));
    NSLog(@"decoderPINBtn.frame %@",NSStringFromCGRect(decoderPINBtn.frame));
    
    UIDeviceOrientation orientation = self.getDeviceOrientation;
    if (!self.isLocked)
    {
        switch (orientation) {
            case UIDeviceOrientationPortrait: {           // Device oriented vertically, home button on the bottom
                NSLog(@"home键在 下");
                [self restoreOriginalScreen];
                
                
                if (!decoderPINLab) {
                    decoderPINLab = [[UILabel alloc]init];
                    decoderPINLab.text = @"Please input";
                    decoderPINLab.textColor = [UIColor whiteColor];
                    decoderPINBtn = [[UIButton alloc]init];
                    [decoderPINBtn setTitle:@" Decoder PIN " forState:UIButtonTypeCustom];
                    [decoderPINBtn.layer setBorderColor:[[UIColor grayColor] CGColor] ];//边框颜色
                    [decoderPINBtn.layer setBorderWidth:2.0f];
                    [decoderPINBtn addTarget:self action:@selector(decoderPINBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    //        [self.view addSubview:radioImageView];
                    //                    [self.view insertSubview:decoderPINLab atIndex:1];
                    [self.view addSubview:decoderPINLab];
                    [self.view addSubview:decoderPINBtn];
                    //                    [self.view insertSubview:decoderPINBtn atIndex:1];
                }
                CGSize sizeDecoderPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CGSize sizeDecoderPINBtn = [GGUtil sizeWithText:@" Decoder PIN " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                decoderPINLab.frame = CGRectMake((SCREEN_WIDTH - sizeDecoderPIN.width)/2,SCREEN_WIDTH/16*9/2-15, sizeDecoderPIN.width, sizeDecoderPIN.height);
                decoderPINLab.textAlignment = NSTextAlignmentCenter;
                decoderPINBtn.frame = CGRectMake((SCREEN_WIDTH - sizeDecoderPINBtn.width)/2,SCREEN_WIDTH/16*9/2+15, sizeDecoderPINBtn.width, sizeDecoderPIN.height);
                decoderPINBtn.layer.cornerRadius = 14.0f;
                decoderPINBtn.layer.masksToBounds = YES;
                
                //                    lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                
                
            }
                break;
            case UIDeviceOrientationPortraitUpsideDown: { // Device oriented vertically, home button on the top
                NSLog(@"home键在 上");
                
                if (!decoderPINLab) {
                    decoderPINLab = [[UILabel alloc]init];
                    decoderPINLab.text = @"Please input";
                    decoderPINLab.textColor = [UIColor whiteColor];
                    decoderPINBtn = [[UIButton alloc]init];
                    [decoderPINBtn setTitle:@" Decoder PIN " forState:UIButtonTypeCustom];
                    [decoderPINBtn.layer setBorderColor:[[UIColor grayColor] CGColor] ];//边框颜色
                    [decoderPINBtn.layer setBorderWidth:2.0f];
                    [decoderPINBtn addTarget:self action:@selector(decoderPINBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    //        [self.view addSubview:radioImageView];
                    //                    [self.view insertSubview:decoderPINLab atIndex:1];
                    [self.view addSubview:decoderPINLab];
                    [self.view addSubview:decoderPINBtn];
                    //                    [self.view insertSubview:decoderPINBtn atIndex:1];
                }
                CGSize sizeDecoderPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CGSize sizeDecoderPINBtn = [GGUtil sizeWithText:@" Decoder PIN " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                decoderPINLab.frame = CGRectMake((SCREEN_WIDTH - sizeDecoderPIN.width)/2,SCREEN_WIDTH/16*9/2-15, sizeDecoderPIN.width, sizeDecoderPIN.height);
                decoderPINLab.textAlignment = NSTextAlignmentCenter;
                decoderPINBtn.frame = CGRectMake((SCREEN_WIDTH - sizeDecoderPINBtn.width)/2,SCREEN_WIDTH/16*9/2+15, sizeDecoderPINBtn.width, sizeDecoderPIN.height);
                decoderPINBtn.layer.cornerRadius = 14.0f;
                decoderPINBtn.layer.masksToBounds = YES;
                
            }
                break;
            case UIDeviceOrientationLandscapeLeft: {      // Device oriented horizontally, home button on the right
                NSLog(@"home键在 右");
                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                
                if (!decoderPINLab) {
                    decoderPINLab = [[UILabel alloc]init];
                    decoderPINLab.text = @"Please input";
                    decoderPINLab.textColor = [UIColor whiteColor];
                    decoderPINBtn = [[UIButton alloc]init];
                    [decoderPINBtn setTitle:@" Decoder PIN " forState:UIButtonTypeCustom];
                    [decoderPINBtn.layer setBorderColor:[[UIColor grayColor] CGColor] ];//边框颜色
                    [decoderPINBtn.layer setBorderWidth:2.0f];
                    [decoderPINBtn addTarget:self action:@selector(decoderPINBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    //        [self.view addSubview:radioImageView];
                    //                    [self.view insertSubview:decoderPINLab atIndex:1];
                    [self.view addSubview:decoderPINLab];
                    [self.view addSubview:decoderPINBtn];
                    //                    [self.view insertSubview:decoderPINBtn atIndex:1];
                }
                CGSize sizeDecoderPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CGSize sizeDecoderPINBtn = [GGUtil sizeWithText:@" Decoder PIN " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                decoderPINLab.frame = CGRectMake((self.view.frame.size.width - sizeDecoderPIN.width)/2,self.view.frame.size.height/2-15, sizeDecoderPIN.width, sizeDecoderPIN.height);
                decoderPINLab.textAlignment = NSTextAlignmentCenter;
                decoderPINBtn.frame = CGRectMake((self.view.frame.size.width - sizeDecoderPINBtn.width)/2,self.view.frame.size.height/2+15, sizeDecoderPINBtn.width, sizeDecoderPIN.height);
                decoderPINBtn.layer.cornerRadius = 14.0f;
                decoderPINBtn.layer.masksToBounds = YES;
                
            }
                break;
            case UIDeviceOrientationLandscapeRight: {     // Device oriented horizontally, home button on the left
                NSLog(@"home键在 左");
                //                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeRight];
                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                
                if (!decoderPINLab) {
                    decoderPINLab = [[UILabel alloc]init];
                    decoderPINLab.text = @"Please input";
                    decoderPINLab.textColor = [UIColor whiteColor];
                    decoderPINBtn = [[UIButton alloc]init];
                    [decoderPINBtn setTitle:@" Decoder PIN " forState:UIButtonTypeCustom];
                    [decoderPINBtn.layer setBorderColor:[[UIColor grayColor] CGColor] ];//边框颜色
                    [decoderPINBtn.layer setBorderWidth:2.0f];
                    [decoderPINBtn addTarget:self action:@selector(decoderPINBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    
                    //        [self.view addSubview:radioImageView];
                    //                    [self.view insertSubview:decoderPINLab atIndex:1];
                    [self.view addSubview:decoderPINLab];
                    [self.view addSubview:decoderPINBtn];
                    //                    [self.view insertSubview:decoderPINBtn atIndex:1];
                }
                CGSize sizeDecoderPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CGSize sizeDecoderPINBtn = [GGUtil sizeWithText:@" Decoder PIN " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                decoderPINLab.frame = CGRectMake((self.view.frame.size.width - sizeDecoderPIN.width)/2,self.view.frame.size.height/2-15, sizeDecoderPIN.width, sizeDecoderPIN.height);
                decoderPINLab.textAlignment = NSTextAlignmentCenter;
                decoderPINBtn.frame = CGRectMake((self.view.frame.size.width - sizeDecoderPINBtn.width)/2,self.view.frame.size.height/2+15, sizeDecoderPINBtn.width, sizeDecoderPIN.height);
                decoderPINBtn.layer.cornerRadius = 14.0f;
                decoderPINBtn.layer.masksToBounds = YES;
                
            }
                break;
                
            default:   //
            {           // Device oriented vertically, home button on the bottom
                NSLog(@"手机可能屏幕朝上，可能不知道方向，可能斜着");
                //                [self restoreOriginalScreen];
                if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 420)  {           // Device oriented vertically, home button on the bottom
                    //此时是竖屏状态
                    NSLog(@"home键在 下");
                    [self restoreOriginalScreen];
                    
                    
                    if (!decoderPINLab) {
                        decoderPINLab = [[UILabel alloc]init];
                        decoderPINLab.text = @"Please input";
                        decoderPINLab.textColor = [UIColor whiteColor];
                        decoderPINBtn = [[UIButton alloc]init];
                        [decoderPINBtn setTitle:@" Decoder PIN " forState:UIButtonTypeCustom];
                        [decoderPINBtn.layer setBorderColor:[[UIColor grayColor] CGColor] ];//边框颜色
                        [decoderPINBtn.layer setBorderWidth:2.0f];
                        [decoderPINBtn addTarget:self action:@selector(decoderPINBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        
                        //        [self.view addSubview:radioImageView];
                        //                    [self.view insertSubview:decoderPINLab atIndex:1];
                        [self.view addSubview:decoderPINLab];
                        [self.view addSubview:decoderPINBtn];
                        //                    [self.view insertSubview:decoderPINBtn atIndex:1];
                    }
                    CGSize sizeDecoderPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                    CGSize sizeDecoderPINBtn = [GGUtil sizeWithText:@" Decoder PIN " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                    decoderPINLab.frame = CGRectMake((SCREEN_WIDTH - sizeDecoderPIN.width)/2,SCREEN_WIDTH/16*9/2-15, sizeDecoderPIN.width, sizeDecoderPIN.height);
                    decoderPINLab.textAlignment = NSTextAlignmentCenter;
                    decoderPINBtn.frame = CGRectMake((SCREEN_WIDTH - sizeDecoderPINBtn.width)/2,SCREEN_WIDTH/16*9/2+15, sizeDecoderPINBtn.width, sizeDecoderPIN.height);
                    decoderPINBtn.layer.cornerRadius = 14.0f;
                    decoderPINBtn.layer.masksToBounds = YES;
                    
                }else //此时是横屏状态
                {     // Device oriented horizontally, home button on the left
                    NSLog(@"home键在 左");
                    //                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeRight];
                    [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                    
                    if (!decoderPINLab) {
                        decoderPINLab = [[UILabel alloc]init];
                        decoderPINLab.text = @"Please input";
                        decoderPINLab.textColor = [UIColor whiteColor];
                        decoderPINBtn = [[UIButton alloc]init];
                        [decoderPINBtn setTitle:@" Decoder PIN " forState:UIButtonTypeCustom];
                        [decoderPINBtn.layer setBorderColor:[[UIColor grayColor] CGColor] ];//边框颜色
                        [decoderPINBtn.layer setBorderWidth:2.0f];
                        [decoderPINBtn addTarget:self action:@selector(decoderPINBtnClick) forControlEvents:UIControlEventTouchUpInside];
                        
                        //        [self.view addSubview:radioImageView];
                        //                    [self.view insertSubview:decoderPINLab atIndex:1];
                        [self.view addSubview:decoderPINLab];
                        [self.view addSubview:decoderPINBtn];
                        //                    [self.view insertSubview:decoderPINBtn atIndex:1];
                    }
                    CGSize sizeDecoderPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                    CGSize sizeDecoderPINBtn = [GGUtil sizeWithText:@" Decoder PIN " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                    decoderPINLab.frame = CGRectMake((self.view.frame.size.width - sizeDecoderPIN.width)/2,self.view.frame.size.height/2-15, sizeDecoderPIN.width, sizeDecoderPIN.height);
                    decoderPINLab.textAlignment = NSTextAlignmentCenter;
                    decoderPINBtn.frame = CGRectMake((self.view.frame.size.width - sizeDecoderPINBtn.width)/2,self.view.frame.size.height/2+15, sizeDecoderPINBtn.width, sizeDecoderPIN.height);
                    decoderPINBtn.layer.cornerRadius = 14.0f;
                    decoderPINBtn.layer.masksToBounds = YES;
                    
                }
                
            }
                break;
        }
    }
    
}
-(void)removeConfigDecoderPINShow  //删除掉DecoderPIN的文字和按钮
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeConfigDecoderPINShowNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeConfigDecoderPINShowNotific) name:@"removeConfigDecoderPINShowNotific" object:nil];
}
-(void)removeConfigDecoderPINShowNotific
{
    [decoderPINLab removeFromSuperview];
    decoderPINLab = nil;
    decoderPINLab = NULL;
    [decoderPINBtn removeFromSuperview];
    decoderPINBtn = nil;
    decoderPINBtn = NULL;
    NSLog(@"decoder 删除了");
}
-(void)removeConfigCAPINShow  //删除掉CAPIN的文字和按钮
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeConfigCAPINShowNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeConfigCAPINShowNotific) name:@"removeConfigCAPINShowNotific" object:nil];
}
-(void)removeConfigCAPINShowNotific
{
    [CAPINLab removeFromSuperview];
    CAPINLab = nil;
    CAPINLab = NULL;
    [CAPINBtn removeFromSuperview];
    CAPINBtn = nil;
    CAPINBtn = NULL;
    NSLog(@"CAPIN 删除了");
}
-(void) CAPINBtnClick //CA pin 按钮被点击
{
    //1.先删除CA pin的文字和按钮   2. 发送通知弹窗
    [self removeConfigCAPINShowNotific];
    
    NSNotification *notification1 =[NSNotification notificationWithName:@"CADencryptInputAgainNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    
    NSLog(@"CA 点击了");
}
-(void) decoderPINBtnClick //decoder pin 按钮被点击
{
    //1.先删除decoder pin的文字和按钮   2. 发送通知弹窗
    [self removeConfigDecoderPINShowNotific];
    
    NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptInputAgainNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    
    NSLog(@"decoder 点击了");
}

#pragma mark - 音频节目背景图展示
//////如果是音频节目，则显示背景图
-(void)configRadioShow
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"configRadioShowNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configRadioShowNotific) name:@"configRadioShowNotific" object:nil];
}
-(void)configRadioShowNotific
{
    //    if (!radioImageView) {
    //        radioImageView = [[UIImageView alloc]init];
    //        radioImageView.image = [UIImage imageNamed:@"音频背景.jpg"];
    ////        [self.view addSubview:radioImageView];
    //        [self.view insertSubview:radioImageView atIndex:1];
    //    }
    //    radioImageView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    
    NSLog(@"radioImageView.frame %@",NSStringFromCGRect(radioImageView.frame));
    
    UIDeviceOrientation orientation = self.getDeviceOrientation;
    if (!self.isLocked)
    {
        switch (orientation) {
            case UIDeviceOrientationPortrait: {           // Device oriented vertically, home button on the bottom
                NSLog(@"home键在 下");
                [self restoreOriginalScreen];
                
                
                if (!radioImageView) {
                    radioImageView = [[UIImageView alloc]init];
                    radioImageView.image = [UIImage imageNamed:@"音频背景.jpg"];
                    //        [self.view addSubview:radioImageView];
                    [self.view insertSubview:radioImageView atIndex:1];
                }
                radioImageView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
                
                //                    lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                
                
            }
                break;
            case UIDeviceOrientationPortraitUpsideDown: { // Device oriented vertically, home button on the top
                NSLog(@"home键在 上");
                
                if (!radioImageView) {
                    radioImageView = [[UIImageView alloc]init];
                    radioImageView.image = [UIImage imageNamed:@"音频背景.jpg"];
                    //        [self.view addSubview:radioImageView];
                    [self.view insertSubview:radioImageView atIndex:1];
                }
                radioImageView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
            }
                break;
            case UIDeviceOrientationLandscapeLeft: {      // Device oriented horizontally, home button on the right
                NSLog(@"home键在 右");
                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                
                if (!radioImageView) {
                    radioImageView = [[UIImageView alloc]init];
                    radioImageView.image = [UIImage imageNamed:@"音频背景.jpg"];
                    //        [self.view addSubview:radioImageView];
                    [self.view insertSubview:radioImageView atIndex:1];
                }
                radioImageView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
            }
                break;
            case UIDeviceOrientationLandscapeRight: {     // Device oriented horizontally, home button on the left
                NSLog(@"home键在 左");
                //                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeRight];
                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                
                if (!radioImageView) {
                    radioImageView = [[UIImageView alloc]init];
                    radioImageView.image = [UIImage imageNamed:@"音频背景.jpg"];
                    //        [self.view addSubview:radioImageView];
                    [self.view insertSubview:radioImageView atIndex:1];
                }
                radioImageView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
            }
                break;
                
            default:
            {     // Device oriented horizontally, home button on the left
                NSLog(@"手机可能屏幕朝上，可能不知道方向，可能斜着");
                
                if (!radioImageView) {
                    radioImageView = [[UIImageView alloc]init];
                    radioImageView.image = [UIImage imageNamed:@"音频背景.jpg"];
                    //        [self.view addSubview:radioImageView];
                    [self.view insertSubview:radioImageView atIndex:1];
                }
                if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.width > 420) { //全屏
                    radioImageView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
                }else //竖屏
                {
                    radioImageView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
                    NSLog(@"可能会出错的地方self.view.frame.bounds.width2");
                }
                
            }
                break;
        }
    }
    
}
-(void)removeConfigRadioShow  //删除掉音频图
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeConfigRadioShowNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeConfigRadioShowNotific) name:@"removeConfigRadioShowNotific" object:nil];
}
-(void)removeConfigRadioShowNotific
{
    [radioImageView removeFromSuperview];
    radioImageView = nil;
    radioImageView = NULL;
}
#pragma  mark - 如果播放活加载状态，代表视频将要准备播放了，此时不显示播放字样
//播放活加载状态，不显示播放字样
-(void)configLabNoPlayShowShut
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noPlayShowShutNotic" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noPlayShowShutNotic) name:@"noPlayShowShutNotic" object:nil];
}
#pragma  mark - 不能播放时，准备显示不能播放的文字 @"sorry, this Video/Radio Cant play"
//如果不能播放 ，则①显示不能播放的文字  ② 取消掉加载环  ③  停止播放的动作
-(void)noPlayShowNotic
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString * isShowLabStr = [USER_DEFAULT objectForKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
        
        if ([isShowLabStr isEqualToString:@"POP"]) {
            //什么都不执行,因为此时有弹窗的文字在展示
        }else
        {
            //保存三个有用的信息
            
            NSString * playStateType = [USER_DEFAULT objectForKey:@"playStateType"];//text.userInfo[@"playStateType"];
            
            
            
            //①创建通知,删除进度条
            NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            //②右侧列表消失
            NSLog(@"右侧列表消失 noPlayShowNotic111");
//            self.subAudioTableView.hidden = YES;
//            self.subAudioTableView = nil;
//            [self.subAudioTableView removeFromSuperview];
//            self.subAudioTableView = NULL;
//            self.subAudioTableView.alpha = 0;
            //③ 删除音频图片
            [self removeConfigRadioShowNotific];  //删除音频图片的函数。，防止音频图片显示
            //④取消掉加载环
            [self.videoControl.indicatorView stopAnimating];
            //⑤停止播放的动作,并且取消掉图画
            [self.player stop];
            [self.player shutdown];
            [self.player.view removeFromSuperview];
            
            
            //⑥显示不能播放的字，通过判断home键的位置来判断label的显示大小和位置
            UIDeviceOrientation orientation = self.getDeviceOrientation;
            if (!self.isLocked)
            {
                NSLog(@"width== %f",self.view.frame.size.width);
                NSLog(@"height== %f",self.view.frame.size.height);
                NSLog(@"screenWidth== %f",[UIScreen mainScreen].bounds.size.width);
                NSLog(@"screenHeight== %f",[UIScreen mainScreen].bounds.size.height);
                
                //转盘方向  研究
                
                switch (orientation) {
                    case UIDeviceOrientationPortrait: {           // Device oriented vertically, home button on the bottom
                        NSLog(@"home键在 下");
                        [self restoreOriginalScreen];
                        
                        if ( !lab) {
                            lab = [[UILabel alloc]init];
                            NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                            if (videoOrRadiostr != NULL) {
                                if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                                    lab.text = deliveryStopTip;   //如果不为空,则显示
                                }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = mediaDisConnect;
                                }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = ResourcesFull;
                                }
                                else
                                {
                                    lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                                }
                                
                            }else
                            {
                                lab.text = videoCantPlayTip;
                            }
                            
                            
                            lab.font = FONT(17);
                            lab.textAlignment = NSTextAlignmentCenter;
                            lab.textColor = [UIColor whiteColor];
                            [self.view addSubview:lab];
                            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                            CGSize size=[lab.text sizeWithAttributes:attrs];
                            lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                            
                            //创建通知
                            NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                            
                        }
                    }
                        break;
                    case UIDeviceOrientationPortraitUpsideDown: { // Device oriented vertically, home button on the top
                        NSLog(@"home键在 上");
                        
                        if ( !lab) {
                            lab = [[UILabel alloc]init];
                            
                            
                            NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                            if (videoOrRadiostr != NULL) {
                                if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                                    lab.text = deliveryStopTip;   //如果不为空,则显示
                                }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = mediaDisConnect;
                                }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = ResourcesFull;
                                }
                                else
                                {
                                    lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                                }
                            }else
                            {
                                lab.text = videoCantPlayTip;
                            }
                            lab.font = FONT(17);
                            lab.textAlignment = NSTextAlignmentCenter;
                            lab.textColor = [UIColor whiteColor];
                            [self.view addSubview:lab];
                            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                            CGSize size=[lab.text sizeWithAttributes:attrs];
                            lab.frame = CGRectMake((SCREEN_HEIGHT - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                            
                            //创建通知
                            NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                            
                        }
                    }
                        break;
                    case UIDeviceOrientationLandscapeLeft: {      // Device oriented horizontally, home button on the right
                        NSLog(@"home键在 右");
                        [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                        
                        if ( !lab) {
                            lab = [[UILabel alloc]init];
                            
                            NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                            if (videoOrRadiostr != NULL) {
                                if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                                    lab.text = deliveryStopTip;   //如果不为空,则显示
                                }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = mediaDisConnect;
                                }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = ResourcesFull;
                                }
                                else
                                {
                                    lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                                }
                            }else
                            {
                                lab.text = videoCantPlayTip;
                            }
                            lab.font = FONT(17);
                            lab.textAlignment = NSTextAlignmentCenter;
                            lab.textColor = [UIColor whiteColor];
                            [self.view addSubview:lab];
                            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                            CGSize size=[lab.text sizeWithAttributes:attrs];
                            
                            lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                            
                            
                            //创建通知
                            NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                        }
                    }
                        break;
                    case UIDeviceOrientationLandscapeRight: {     // Device oriented horizontally, home button on the left
                        NSLog(@"home键在 左");
                        //                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeRight];
                        [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                        
                        if ( !lab) {
                            lab = [[UILabel alloc]init];
                            
                            NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                            if (videoOrRadiostr != NULL) {
                                if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                                    lab.text = deliveryStopTip;   //如果不为空,则显示
                                }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = mediaDisConnect;
                                }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = ResourcesFull;
                                }else
                                {
                                    lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                                }
                            }else
                            {
                                lab.text = videoCantPlayTip;
                            }
                            lab.font = FONT(17);
                            lab.textAlignment = NSTextAlignmentCenter;
                            lab.textColor = [UIColor whiteColor];
                            [self.view addSubview:lab];
                            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                            CGSize size=[lab.text sizeWithAttributes:attrs];
                            lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                            
                            //创建通知
                            NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                            
                        }
                    }
                        break;
                        
                    default: // 还有一种情况是界面朝上或者界面朝下
                    {
                        NSLog(@"width %f",self.view.frame.size.width);
                        NSLog(@"height %f",self.view.frame.size.height);
                        if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 420) //证明此时是竖屏状态
                        {           // Device oriented vertically, home button on the bottom
                            NSLog(@"home键在 下");
                            [self restoreOriginalScreen];
                            
                            if ( !lab) {
                                lab = [[UILabel alloc]init];
                                NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                                if (videoOrRadiostr != NULL) {
                                    if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                                        lab.text = deliveryStopTip;   //如果不为空,则显示
                                    }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                                    {
                                        lab.numberOfLines = 0;
                                        lab.text = mediaDisConnect;
                                    }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                                    {
                                        lab.numberOfLines = 0;
                                        lab.text = ResourcesFull;
                                    }else
                                    {
                                        lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                                    }
                                }else
                                {
                                    lab.text = videoCantPlayTip;
                                }
                                
                                
                                lab.font = FONT(17);
                                lab.textAlignment = NSTextAlignmentCenter;
                                lab.textColor = [UIColor whiteColor];
                                [self.view addSubview:lab];
                                NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                                CGSize size=[lab.text sizeWithAttributes:attrs];
                                lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                                
                                //创建通知
                                NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                                //通过通知中心发送通知
                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                                
                            }
                        }else //证明此时是横屏状态
                        {      // Device oriented horizontally, home button on the right
                            NSLog(@"home键在 右");
                            [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                            
                            if ( !lab) {
                                lab = [[UILabel alloc]init];
                                
                                NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                                if (videoOrRadiostr != NULL) {
                                    if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                                        lab.text = deliveryStopTip;   //如果不为空,则显示
                                    }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                                    {
                                        lab.numberOfLines = 0;
                                        lab.text = mediaDisConnect;
                                    }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                                    {
                                        lab.numberOfLines = 0;
                                        lab.text = ResourcesFull;
                                    }else
                                    {
                                        lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                                    }
                                }else
                                {
                                    lab.text = videoCantPlayTip;
                                }
                                lab.font = FONT(17);
                                lab.textAlignment = NSTextAlignmentCenter;
                                lab.textColor = [UIColor whiteColor];
                                [self.view addSubview:lab];
                                NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                                CGSize size=[lab.text sizeWithAttributes:attrs];
                                lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                                
                                
                                //创建通知
                                NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                                //通过通知中心发送通知
                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                            }
                        }
                        
                        
                        
                        
                    }
                        break;
                }
                
                if (lab) {
                    NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                    if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                        lab.text = deliveryStopTip;   //如果不为空,则显示
                    }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                    {
                        lab.numberOfLines = 0;
                        lab.text = mediaDisConnect;
                    }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                    {
                        lab.numberOfLines = 0;
                        lab.textAlignment = NSTextAlignmentCenter;
                        lab.text = ResourcesFull;
                    }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                    {
                        lab.numberOfLines = 0;
                        lab.text = ResourcesFull;
                    }else
                    {
                        lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                    }
                    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                    
                    if ([UIScreen mainScreen].bounds.size.width <  [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 420) {
                        CGSize size=[lab.text sizeWithAttributes:attrs];
                        lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                    }else
                    {
                        CGSize size=[lab.text sizeWithAttributes:attrs];
                        lab.frame = CGRectMake((SCREEN_HEIGHT - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                    }
                    
                }
            }
            
        }
        
        
        
        
    });
    
    
    
}
-(void)noPlayShowShutNotic
{
    
    if ( !lab) {
        
    }else
    {
        [lab removeFromSuperview];
        lab = nil;
        lab = NULL;
        
    }
    
    
}
/// 耳机插入、拔出事件
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSInteger routeChangeReason = [[notification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"---耳机插入");
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable: {
            NSLog(@"---耳机拔出");
            // 拔掉耳机继续播放
            [self.player play];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
            
        default:
            break;
    }
}

/// MARK: 设备方向

//////关闭通知
//-(void)shutDownNotific
//{
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification  object:nil];
//
//}
/// 设置监听设备旋转通知
- (void)configDeviceOrientationObserver
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationDidChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    
    //    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shutDownOrientationNotific" object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shutDownNotific) name:@"shutDownOrientationNotific" object:nil];
    //
}

/// 设备旋转方向改变
- (void)onDeviceOrientationDidChange
{
    NSLog(@"右侧列表消失 之 屏幕旋转");
    [self rightViewHidden];  //旋转时，将右侧列表取消掉
    
    UIDeviceOrientation orientation = self.getDeviceOrientation;
    
    
    if(orientation ==UIDeviceOrientationLandscapeLeft || orientation==UIDeviceOrientationLandscapeRight){
        if (!self.isLocked) { //此时没有按锁屏键
            orientationAVer = orientation;
            [USER_DEFAULT setInteger:orientationAVer forKey:@"orientationAVer"];
            HorTime = 0;
            switch (orientationAVer) {
                case 1:
                    NSLog(@"此时 home键1 在下");
                    break;
                case 2:
                    NSLog(@"此时 home键1 在上");
                    break;
                case 3:
                    NSLog(@"此时 home键1 在右");
                    break;
                case 4:
                    NSLog(@"此时 home键1 在左");
                    break;
                    
                default:
                    break;
            }
        }
        else{
            if (HorTime == 0) {
                orientationBHor = orientationAVer;  //记住锁屏前最后一次方向s
                switch (orientationBHor) {
                    case 1:
                        NSLog(@"此时 home键2 在下");
                        break;
                    case 2:
                        NSLog(@"此时 home键2 在上");
                        break;
                    case 3:
                        NSLog(@"此时 home键2 在右");
                        break;
                    case 4:
                        NSLog(@"此时 home键2 在左");
                        break;
                        
                    default:
                        break;
                }
                HorTime++;
            }
            
        }
    }
    
    NSLog(@"self.isLocked %d",self.isLocked);
    if (!self.isLocked)
    {
        switch (orientation) {
            case UIDeviceOrientationPortrait: {           // Device oriented vertically, home button on the bottom
                NSLog(@"此时 home键3在 下");
                [self restoreOriginalScreen];
            }
                break;
            case UIDeviceOrientationPortraitUpsideDown: { // Device oriented vertically, home button on the top
                NSLog(@"此时 home键3在 上");
            }
                break;
            case UIDeviceOrientationLandscapeLeft: {      // Device oriented horizontally, home button on the right
                NSLog(@"此时 home键3在 右");
                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
            }
                break;
            case UIDeviceOrientationLandscapeRight: {     // Device oriented horizontally, home button on the left
                NSLog(@"此时 home键3在 左");
                //                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeRight];
                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
            }
                break;
                
            default:
                break;
        }
    }
    else //锁屏状态不动
    {
        [USER_DEFAULT setInteger:orientationBHor forKey:@"orientationBHor"];
        switch (orientationBHor) {
            case 1:
                NSLog(@"home键 在下");
                break;
            case 2:
                NSLog(@"home键 在上");
                break;
            case 3:
                NSLog(@"home键 在右");
                break;
            case 4:
                NSLog(@"home键 在左");
                break;
                
            default:
                break;
        }
        //        switch (orientationBHor) {
        //            case UIDeviceOrientationPortrait: {           // Device oriented vertically, home button on the bottom
        //                NSLog(@"home键在 下");
        ////                [self restoreOriginalScreen];
        //                [self changeToFullScreenForOrientation:orientationBHor];
        //            }
        //                break;
        //            case UIDeviceOrientationPortraitUpsideDown: { // Device oriented vertically, home button on the top
        //                NSLog(@"home键在 上");
        //                [self changeToFullScreenForOrientation:orientationBHor];
        //            }
        //                break;
        //            case UIDeviceOrientationLandscapeLeft: {      // Device oriented horizontally, home button on the right
        //                NSLog(@"home键在 右");
        //                [self changeToFullScreenForOrientation:orientationBHor];
        ////                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
        //            }
        //                break;
        //            case UIDeviceOrientationLandscapeRight: {     // Device oriented horizontally, home button on the left
        //                NSLog(@"home键在 左");
        //                [self changeToFullScreenForOrientation:orientationBHor];
        //                //                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeRight];
        ////                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
        //            }
        //                break;
        //
        //            default:
        //                break;
        //        }
    }
    
}

#pragma mark - ///// 切换到全屏模式
///// 切换到全屏模式
- (void)changeToFullScreenForOrientation:(UIDeviceOrientation)orientation
{
    if ([[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"NO"]) {
        //new====
        NSString * isPreventFullScreenStr = [USER_DEFAULT objectForKey:@"modeifyTVViewRevolve"];//判断是否全屏界面下就跳转到首页面，容易出现界面混乱
        
        if ([isPreventFullScreenStr isEqualToString:@"NO"]) {
            
        }else if(([isPreventFullScreenStr isEqualToString:@"YES"]))
        {
            NSLog(@"==-=-===-==000==-全屏了");
            //new====
            
            if (self.isFullscreenMode) {
                return;
            }
            if (self.videoControl.isBarShowing) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            } else {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            }
            
            
            if (self.videoPlayerWillChangeToFullScreenModeBlock) {
                self.videoPlayerWillChangeToFullScreenModeBlock();
            }
            
            //            self.frame = [UIScreen mainScreen].bounds;
            self.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
            //    self.videoControl.bottomBar.userInteractionEnabled = YES;
            self.isFullscreenMode = YES;
            self.videoControl.fullScreenButton.hidden = YES;
            //    self.videoControl.shrinkScreenButton.hidden = NO;
            self.videoControl.shrinkScreenButton1.hidden = NO;
            self.videoControl.lastChannelButton.hidden = NO;
            self.videoControl.suspendButton.hidden = YES;
            self.videoControl.nextChannelButton.hidden = NO;
            self.videoControl.subtBtn.hidden = NO;
            self.videoControl.audioBtn.hidden = NO;
            self.videoControl.channelListBtn.hidden = NO;
            self.videoControl.eventTimeLabNow.hidden = NO;
            self.videoControl.eventTimeLabAll.hidden = NO;
            self.videoControl.backButton.hidden = NO;
            
            self.videoControl.lockButton.hidden = NO; //切换到竖屏模式，锁屏按钮出现
            [USER_DEFAULT setBool:YES forKey:@"isFullScreenMode"];
            
            NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
            NSString * playStateType = [USER_DEFAULT objectForKey:@"playStateType"];
            if (videoOrRadiostr != NULL) {
                if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                    lab.text = deliveryStopTip;   //如果不为空,则显示
                }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                {
                    lab.numberOfLines = 0;
                    lab.text = mediaDisConnect;
                }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                {
                    lab.numberOfLines = 0;
                    lab.text = ResourcesFull;
                }else
                {
                    lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                }
            }else
            {
                lab.text = videoCantPlayTip;
            }
            lab.font = FONT(17);
            lab.textAlignment = NSTextAlignmentCenter;
            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
            CGSize size=[lab.text sizeWithAttributes:attrs];
            lab.frame = CGRectMake((SCREEN_HEIGHT - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
            
            
            
            if (radioImageView) {
                radioImageView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
            }
            if (decoderPINLab) {
                CGSize sizeDecoderPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CGSize sizeDecoderPINBtn = [GGUtil sizeWithText:@" Decoder PIN " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                decoderPINLab.frame = CGRectMake((self.view.frame.size.width - sizeDecoderPIN.width)/2,self.view.frame.size.height/2-15, sizeDecoderPIN.width, sizeDecoderPIN.height);
                decoderPINLab.textAlignment = NSTextAlignmentCenter;
                decoderPINBtn.frame = CGRectMake((self.view.frame.size.width - sizeDecoderPINBtn.width)/2,self.view.frame.size.height/2+15, sizeDecoderPINBtn.width, sizeDecoderPIN.height);
                
            }
            if (CAPINLab) {
                CGSize sizeCAPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CGSize sizeCAPINBtn = [GGUtil sizeWithText:@"  CA PIN  " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
                CAPINLab.frame = CGRectMake((self.view.frame.size.width - sizeCAPIN.width)/2,self.view.frame.size.height/2-15, sizeCAPIN.width, sizeCAPIN.height);
                CAPINLab.textAlignment = NSTextAlignmentCenter;
                CAPINBtn.frame = CGRectMake((self.view.frame.size.width - sizeCAPINBtn.width)/2,self.view.frame.size.height/2+15, sizeCAPINBtn.width, sizeCAPIN.height);
                
            }
            
            
            
            //     self.videoControl.channelIdLab.hidden = NO;
            //     self.videoControl.channelNameLab.hidden = NO;
            self.videoControl.FulleventNameLab.hidden = NO;
            if (self.videoControl.FullEventYFlabel) {
                self.videoControl.FullEventYFlabel.hidden = NO; //全屏页面跑马灯
            }
            
            
            
            self.videoControl.eventnameLabel.hidden = YES;
            
            self.videoControl.channelIdLab.font =[UIFont systemFontOfSize:27];
            self.videoControl.channelNameLab.font =[UIFont systemFontOfSize:11];
            
          
            sizeChannelId = [self sizeWithText:self.videoControl.channelIdLab.text font:[UIFont systemFontOfSize:27] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            sizeChannelName = [self sizeWithText:self.videoControl.channelNameLab.text font:[UIFont systemFontOfSize:11] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            //     CGSize sizeEventName = [self sizeWithText:self.videoControl.FulleventNameLab.text font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            self.videoControl.channelIdLab.frame = CGRectMake(42, 26, 56 , 55); //sizeChannelId.width+6
            NSLog(@"self.videoControl.channelNameLab.text== :%@",self.videoControl.channelNameLab.text);
            self.videoControl.channelNameLab.frame = CGRectMake(42+60, 34, sizeChannelName.width+180, 18); //sizeChannelId.width+12

            self.videoControl.FulleventNameLab.text = self.videoControl.eventnameLabel.text;
            //    if (! YFLabelArr) {   //初始化arr，方便后面对label赋值
            YFLabelArr = [[NSMutableArray alloc]initWithObjects:self.videoControl.FulleventNameLab.text, nil];
   
            self.videoControl.FullEventYFlabel.hidden = NO;
            //    self.videoControl.FullEventYFlabel.speed = 3;
            self.videoControl.FulleventNameLab.hidden = YES; //本应该是no，此处为了测试
            
            self.videoControl.FulleventNameLab.frame =  CGRectMake(self.videoControl.channelNameLab.frame.origin.x, 30+22, sizeEventName.width, 18);
            
            
            
            //此处强制销毁，再重新init一次
            //    if (self.videoControl.FullEventYFlabel) {
            [self.videoControl.FullEventYFlabel removeFromSuperview];
            self.videoControl.FullEventYFlabel = nil;
            [self.videoControl.FullEventYFlabel stopTimer];
            
            [self abctest];
            //    }
            
            
            //判断是不是播放的录制节目
            if ([self.videoControl.channelIdLab.text  isEqual: @""] || [self.videoControl.channelIdLab.text isEqualToString:@""]) {
                //此时是录制节目
                self.videoControl.channelIdLab.hidden = YES;
                self.videoControl.channelNameLab.hidden = NO;
                self.videoControl.FulleventNameLab.hidden = YES;
//                self.videoControl.FulleventNameLab.frame = CGRectMake( 20, 20, 200, 30);
//
//                self.videoControl.FullEventYFlabel.frame = CGRectMake( 45, 38, 200, 30);
                self.videoControl.channelNameLab.frame = CGRectMake( 45, 38, 300, 30);
                // 1. 暂停按钮出现 2. Nextbutton和时间右移
                
                self.videoControl.suspendButton.hidden = NO;
                
               
                self.videoControl.nextChannelButton.frame = CGRectMake(100, CGRectGetHeight(self.videoControl.bottomBar.bounds) -16.5 -17-13, 44, 44);
                
                 self.videoControl.suspendButton.frame = CGRectMake((self.videoControl.nextChannelButton.frame.origin.x - self.videoControl.lastChannelButton.frame.origin.x -  44 -44)/2 + self.videoControl.lastChannelButton.frame.origin.x + 44,CGRectGetHeight(self.videoControl.bottomBar.bounds) -16.5 -17-13,44, 44);
                
                self.videoControl.eventTimeLabNow.frame = CGRectMake(164, CGRectGetHeight(self.videoControl.bottomBar.bounds) -16.5 -17, 90, 17);
                self.videoControl.eventTimeLabAll.frame = CGRectMake(164+80, CGRectGetHeight(self.videoControl.bottomBar.bounds) -16.5 -17, 90, 17);

                
                //全屏
                self.videoControl.progressSlider.frame = CGRectMake(0, self.videoControl.bottomBar.frame.size.height -50 , SCREEN_HEIGHT+1, 2);
                
                NSLog(@"lalalalalalalalalalalal111");
            }
            //test
            //此处销毁通知，防止一个通知被多次调用
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"abctest" object:nil];
            //注册通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(abctest) name:@"abctest" object:nil];
            
            [self judgeLastBtnIsGray];
            [self judgeNextBtnIsGray];
            NSArray * subtarr =[self.video.dicSubAudio  objectForKey:@"subt_info"];
            NSArray * audioStr =[self.video.dicSubAudio  objectForKey:@"audio_info"];
            BOOL judgeIsNull = [self judgeSubtIsNull:subtarr];
            if (judgeIsNull == YES) {
                NSLog(@"数值为空，所以此时应该直接返回");
                [self.videoControl.subtBtn setEnabled:NO];
                
            }else
            {
                //        [self.videoControl.subtBtn setEnabled:YES];  //此处需要置灰，以后再开放这个接口
                [self.videoControl.subtBtn setEnabled:NO];
            }
            BOOL judgeIsNull1 = [self judgeAudioIsNull:audioStr];
            if (judgeIsNull1 == YES) {
                NSLog(@"数值为空，所以此时应该直接返回");
                [self.videoControl.audioBtn setEnabled:NO];
                
                
            }else
            {
                [self.videoControl.audioBtn setEnabled:YES];
            }
            //IJK
            self.player.view.frame = self.view.bounds;
            NSLog(@"self.view.bounds %d");
            //new====
        }else
        {
        }
        //new====
    }
    
    
}

-(void)abctest
{
    sizeEventName = [self sizeWithText:self.videoControl.FulleventNameLab.text font:[UIFont systemFontOfSize:11] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    NSLog(@"FullEventYFlabel lalal1 :%@",self.videoControl.FullEventYFlabel);
    //先销毁再创建
    [self.videoControl.FullEventYFlabel removeFromSuperview];
    self.videoControl.FullEventYFlabel = nil;
    [self.videoControl.FullEventYFlabel stopTimer];
    //
    
    NSLog(@"FullEventYFlabel lalal3 :%@",self.videoControl.FullEventYFlabel);
    self.videoControl.FullEventYFlabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake(self.videoControl.channelNameLab.frame.origin.x, 30+22, 260, 18)  textArray:YFLabelArr font:[UIFont systemFontOfSize:11] textColor:[UIColor whiteColor]];
    
    //进行判断,看是不是录制节目
    if ([self.videoControl.channelIdLab.text  isEqual: @""] || [self.videoControl.channelIdLab.text isEqualToString:@""]) {
        
          self.videoControl.FullEventYFlabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake( 45, 38, 200, 30)  textArray:YFLabelArr font:[UIFont systemFontOfSize:11] textColor:[UIColor whiteColor]];
    }
    
    
    
    
    NSLog(@"FullEventYFlabel lalal2 :%@",self.videoControl.FullEventYFlabel);
    NSString * abcaa =self.videoControl.eventnameLabel.text;
    NSArray * arr = [[NSArray alloc]init];
    if(abcaa == nil|| abcaa == NULL)
    {
        arr = @[@"NO Event"];
    }else
    {
        arr = @[abcaa];
    }
    
    
    [self.videoControl.FullEventYFlabel initArr:arr];
    //[self.videoControl.FullEventYFlabel initArr:@[@"111asdasdasdasdasdASDMAMSDASDAOISDMASDMAOSIMDasdasdasdasdasdasdasdasd"]];
    self.videoControl.FullEventYFlabel.hidden = NO;
    [self.videoControl.topBar addSubview: self.videoControl.FullEventYFlabel];
    double aa =1.8*sizeEventName.width/260;
    NSLog(@"aa：%f",aa);
    self.videoControl.FullEventYFlabel.speed = aa;
    
    
    
    
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
#pragma mark - /// 切换到竖屏模式
/// 切换到竖屏模式
- (void)restoreOriginalScreen
{
    NSLog(@"==-=-===-==000==-竖屏了");
    if (!self.isFullscreenMode) {
        return;
    }
    
    if ([UIApplication sharedApplication].statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    if (self.videoPlayerWillChangeToOriginalScreenModeBlock) {
        self.videoPlayerWillChangeToOriginalScreenModeBlock();
    }
    
    self.frame = CGRectMake(0, VIDEOHEIGHT, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight);
    
    self.isFullscreenMode = NO;
    if ([[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"NO"]) {
        self.videoControl.fullScreenButton.hidden = NO;
    }else
    {
        self.videoControl.fullScreenButton.hidden = YES;
    }
    
    //    self.videoControl.shrinkScreenButton.hidden = YES;
    self.videoControl.shrinkScreenButton1.hidden = YES;
    self.videoControl.backButton.hidden = YES;
    //     self.videoControl.channelIdLab.hidden = YES;
    //     self.videoControl.channelNameLab.hidden = YES;
    self.videoControl.FulleventNameLab.hidden = YES;
    
    if (self.videoControl.FullEventYFlabel) {
        self.videoControl.FullEventYFlabel.hidden = YES; //全屏页面跑马灯
    }
    
    self.videoControl.lastChannelButton.hidden = YES;
    self.videoControl.suspendButton.hidden = YES;
    self.videoControl.nextChannelButton.hidden = YES;
    self.videoControl.subtBtn.hidden = YES;
    self.videoControl.audioBtn.hidden = YES;
    self.videoControl.channelListBtn.hidden = YES;
    //    self.videoControl.eventTimeLab.hidden = YES;
    self.videoControl.eventTimeLabNow.hidden = YES;
    self.videoControl.eventTimeLabAll.hidden = YES;
    self.videoControl.eventnameLabel.hidden = NO;
    
    self.videoControl.lockButton.hidden = YES; //切换到竖屏模式，锁屏按钮消失
    [USER_DEFAULT setBool:NO forKey:@"isFullScreenMode"];
    
    NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
    NSString * playStateType = [USER_DEFAULT objectForKey:@"playStateType"];
    if (videoOrRadiostr != NULL) {
        if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
            lab.text = deliveryStopTip;   //如果不为空,则显示
        }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
        {
            lab.numberOfLines = 0;
            lab.text = mediaDisConnect;
        }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
        {
            lab.numberOfLines = 0;
            lab.text = ResourcesFull;
        }else
        {
            lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
        }
    }else
    {
        lab.text = videoCantPlayTip;
    }
    lab.font = FONT(17);
    lab.textAlignment = NSTextAlignmentCenter;
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
    CGSize size=[lab.text sizeWithAttributes:attrs];
    lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
    
    
    if (radioImageView) {
        radioImageView.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    }
    if (decoderPINLab) {
        CGSize sizeDecoderPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGSize sizeDecoderPINBtn = [GGUtil sizeWithText:@" Decoder PIN " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        decoderPINLab.frame = CGRectMake((SCREEN_WIDTH - sizeDecoderPIN.width)/2,SCREEN_WIDTH/16*9/2-15, sizeDecoderPIN.width, sizeDecoderPIN.height);
        decoderPINLab.textAlignment = NSTextAlignmentCenter;
        decoderPINBtn.frame = CGRectMake((SCREEN_WIDTH - sizeDecoderPINBtn.width)/2,SCREEN_WIDTH/16*9/2+15, sizeDecoderPINBtn.width, sizeDecoderPIN.height);
    }
    if (CAPINLab) {
        CGSize sizeCAPIN = [GGUtil sizeWithText:@"Please input" font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGSize sizeCAPINBtn = [GGUtil sizeWithText:@"  CA PIN  " font:[UIFont systemFontOfSize:24] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CAPINLab.frame = CGRectMake((SCREEN_WIDTH - sizeCAPIN.width)/2,SCREEN_WIDTH/16*9/2-15, sizeCAPIN.width, sizeCAPIN.height);
        CAPINLab.textAlignment = NSTextAlignmentCenter;
        CAPINBtn.frame = CGRectMake((SCREEN_WIDTH - sizeCAPINBtn.width)/2,SCREEN_WIDTH/16*9/2+15, sizeCAPINBtn.width, sizeCAPIN.height);
    }
    
    self.videoControl.channelIdLab.frame = CGRectMake(20, 10, 25, 18);
    self.videoControl.channelNameLab.frame = CGRectMake(56, 10, 120+50, 18);
    self.videoControl.channelIdLab.font =[UIFont systemFontOfSize:12];
    self.videoControl.channelNameLab.font =[UIFont systemFontOfSize:12];
    
    
   
    
    if ([self.video.channelId isEqualToString: @""]) {
        
        self.videoControl.channelNameLab.frame = CGRectMake(20, 10, 25+200, 18);
        self.videoControl.channelIdLab.hidden = NO;
        self.videoControl.channelNameLab.hidden = NO;
    }

    //判断是不是播放的录制节目
    if ([self.videoControl.channelIdLab.text  isEqual: @""] || [self.videoControl.channelIdLab.text isEqualToString:@""]) {
        
        //竖屏状态 progressSlider的frame
         self.videoControl.progressSlider.frame = CGRectMake(-2, self.videoControl.bottomBar.frame.size.height - 1.5, SCREEN_WIDTH+3, 1.5f);
        NSLog(@"lalalalalalalalalalalal222");
    }
    
    //切换到竖屏，跑马灯消失
    if (self.videoControl.FullEventYFlabel) {
        [self.videoControl.FullEventYFlabel removeFromSuperview];
        self.videoControl.FullEventYFlabel = nil;
        [self.videoControl.FullEventYFlabel stopTimer];
    }
    //IJK
    self.player.view.frame = self.view.bounds;
    
    
}

/// 手动切换设备方向
- (void)changeToOrientation:(UIDeviceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        NSLog(@"aaaaaa手动切换设备方向");
    }
}

#pragma mark -
#pragma mark - Action Code

////
///上一个节目
- (void)lastChannelButtonClick
{
    [self.videoControl.suspendButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    audioRow = 0;
    subtRow = 0;
    NSLog(@"shang 上一个节目");
    
    NSMutableArray *  historyArr  = [[NSMutableArray alloc]init];
    historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];
    
    NSArray * touchArr = historyArr[historyArr.count - 1];
    NSLog(@"touchArr：%@",touchArr);
    //    [self touchToSee :touchArr];
    
    
    NSInteger row = [touchArr[2] intValue];
    NSDictionary * dic = touchArr [3];
    
    if (row >= 1) {
        self.videoControl.lastChannelButton.enabled = YES;
        self.videoControl.nextChannelButton.enabled = YES;
        NSNumber * numIndex = [NSNumber numberWithInt:(row -1)];
        //添加 字典，将label的值通过key值设置传递
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
        
        
        //这里需要进行一次判断，看是不是需要弹出机顶盒加锁密码框
        NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
        
        NSString * characterStr = [epgDicToSocket objectForKey:@"service_character"]; //新加了一个service_character
        
        
        if (characterStr != NULL && characterStr != nil) {
            
            BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
            if (judgeIsSTBDecrypt == YES) {
                // 此处代表需要记性机顶盒加密验证
                //弹窗
                //发送通知
                
                //        [self popSTBAlertView];
                //        [self popCAAlertView];
                NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"otherTouch",@"textThree",nil];
                //创建通知
                NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                NSLog(@"POPPOPPOPPOP66666666666");
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification1];
                [self judgeLastBtnIsGray];
                //                [self.tabBarController setSelectedIndex:1];
                
            }else //正常播放的步骤
            {
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [self judgeLastBtnIsGray];
                //                [self.tabBarController setSelectedIndex:1];
            }
            
            
        }else //正常播放的步骤
        {
            
            
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self judgeLastBtnIsGray];
        }
        
    }else
    {
        NSLog(@"对不起，已经没有上一个节目了");
        self.videoControl.lastChannelButton.enabled = NO;
    }
    //    NSNumber * numIndex = [NSNumber numberWithInt:(row -1)];
    
    //    //添加 字典，将label的值通过key值设置传递
    //    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
    //    //创建通知
    //    NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
    //    //通过通知中心发送通知
    //    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
#pragma  mark -点击了暂停按钮
- (void)suspendButtonClick
{
    
    
    if ([self.player isPlaying]) {  //暂停
        [self.player pause];
        NSLog(@"用户点击了暂停按钮");
        //给通知，暂停进度条
        
        [self.videoControl.suspendButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        
        [self stopDurationTimer];
    }else  //重新播放
    {
        [self.player play];
        NSLog(@"用户点击了播放按钮");
        //重新启动进度条
        
        [self.videoControl.suspendButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [self startDurationTimer];
    }
    
    
}
- (void)nextChannelButtonClick
{
    [self.videoControl.suspendButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    audioRow = 0;
    subtRow = 0;
    NSLog(@"下一个节目");
    NSMutableArray *  historyArr  = [[NSMutableArray alloc]init];
    historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];
    
    NSArray * touchArr = historyArr[historyArr.count - 1];   //最后一个历史
   
    NSInteger row = [touchArr[2] intValue];
    NSDictionary * dic = touchArr [3];
    int dic_Count = [[dic allKeys] count] -1;
    if (row < dic_Count) {
        self.videoControl.lastChannelButton.enabled = YES;
        self.videoControl.nextChannelButton.enabled = YES;
        NSLog(@"row2 :%ld",(long)row);
        NSInteger tempInt = row+1;
        NSLog(@"row3 :%ld",(long)row);
        NSNumber * numIndex = [NSNumber numberWithInteger:tempInt];
        //添加 字典，将label的值通过key值设置传递
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
      
        //这里需要进行一次判断，看是不是需要弹出机顶盒加锁密码框
        NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
        
        NSString * characterStr = [epgDicToSocket objectForKey:@"service_character"]; //新加了一个service_character
        
        
        if (characterStr != NULL && characterStr != nil) {
            
            BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
            if (judgeIsSTBDecrypt == YES) {
                // 此处代表需要记性机顶盒加密验证
                //弹窗
                //发送通知
                
                //        [self popSTBAlertView];
                //        [self popCAAlertView];
                NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"otherTouch",@"textThree",nil];
                //创建通知
                NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification1];
                [self judgeNextBtnIsGray];
                
                
            }else //正常播放的步骤
            {
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [self judgeNextBtnIsGray];
                
            }
            
            
        }else //正常播放的步骤
        {
            
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self judgeNextBtnIsGray];
        }
    }else
    {
        NSLog(@"对不起，已经没有下一个节目了");
        self.videoControl.nextChannelButton.enabled = NO;
    }
}
-(void)judgeLastBtnIsGray
{
    //上一个节目
    NSMutableArray *  historyArr  = [[NSMutableArray alloc]init];
    historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];
    
    if (historyArr.count >= 1) {
        NSArray * touchArr = historyArr[historyArr.count - 1];
        NSLog(@"touchArr：%@",touchArr);
        //    [self touchToSee :touchArr];
        
        
        NSInteger row = [touchArr[2] intValue];
        NSDictionary * dic = touchArr [3];
        if (row >= 1) {
            self.videoControl.lastChannelButton.enabled = YES;
            
        }else
        {
            NSLog(@"对不起，已经没有上一个节目了");
            self.videoControl.lastChannelButton.enabled = NO;
        }
        
    }else
    {
        //历史为空，不操作
    }
    
}
//static int abb = 2;
-(void)judgeNextBtnIsGray
{
    NSLog(@"下一个节目");
    NSMutableArray *  historyArr  = [[NSMutableArray alloc]init];
    historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];   //总的数据
    if (historyArr.count > 1) {
        
        int historyArrCount = historyArr.count - 1;
        NSArray * touchArr = historyArr[historyArrCount];
        
        
        NSLog(@"historyArr：%@",historyArr);
        NSLog(@"touchArr：%@",touchArr);
        NSLog(@"touchArr3：%@",touchArr[3]);
        
        NSInteger row = [touchArr[2] intValue];
        NSDictionary * dic = touchArr [3];
//        NSLog(@"dic :%@",dic);
        NSLog(@"dic。count :%lu",(unsigned long)dic.count);
        NSLog(@"row1 :%ld",(long)row);
        int dic_Count = [dic count] -1;
        if (row < dic_Count) {
            //        self.videoControl.lastChannelButton.enabled = YES;
            self.videoControl.nextChannelButton.enabled = YES;
        }else
        {
            self.videoControl.nextChannelButton.enabled = NO;
        }
    }
    else
    {
        //历史数据为空，不操作
    }
    
}
- (void)subtBtnClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timerStateInvalidate" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"lockButtonHide" object:nil];
    NSLog(@"sub字幕");
    _cellStr = @"subt";
    if (self.rightViewShowing == YES)
    {
        [self rightViewHidden];
        
        
        
        
    }else if(self.rightViewShowing ==NO)
    {
        [self rightViewshow];
        
        ////        int show = 1;
        ////        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",show],@"boolBarShow",nil];
        //        NSNotification * notification =[NSNotification notificationWithName:@"test" object:nil userInfo:nil];
        
    }
    
    [self configDeviceOrientationObserver];
    
    
    
    
    
    
    NSArray * subtarr =[self.subAudioDic  objectForKey:@"subt_info"];
    BOOL judgeIsNull = [self judgeSubtIsNull:subtarr];
    if (judgeIsNull == YES || subtarr.count == 0 || subtarr == NULL || subtarr == nil) {
        
        NSLog(@"音轨可能没有数据");
        
    }else
    {
        if ([[USER_DEFAULT objectForKey:@"audioOrSubtTouch"] isEqualToString:@"YES"] ) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:subtPositionIndex inSection:0];
            [self.subAudioTableView scrollToRowAtIndexPath:scrollIndexPath  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }else
        {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.subAudioTableView scrollToRowAtIndexPath:scrollIndexPath  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
    
    //
    
    
    
    
}
-(void)initData
{
    self.subAudioDic = [[NSMutableDictionary alloc]init];
    self.channelDic= [[NSMutableDictionary alloc]init];
    self.imageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"渐变"]];
    self.nullView =  [[UIView alloc] initWithFrame:CGRectZero];
    
}
-(void)rightViewshow
{
    NSLog(@"右侧列表展示");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"lockButtonHide" object:nil];
    self.videoControl.rightView.hidden = NO;
    self.videoControl.rightView.alpha = 1;
    
    self.subAudioTableView.hidden = NO;
    self.subAudioTableView.alpha = 1;
    
    self.rightViewShowing = YES;
    
    self.videoControl.topBar.alpha = 0;
    self.videoControl.bottomBar.alpha = 0;
    
    
    
    
    self.subAudioDic = self.video.dicSubAudio;
    
    NSLog(@"self.video.dicChannl= %@",self.video.dicChannl);
    self.channelDic = self.video.dicChannl;
    
    
    //////tableview
    if(!self.subAudioTableView)
    {
        self.subAudioTableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)-145, 0, 145, CGRectGetHeight(self.videoControl.rightView.bounds)) style:UITableViewStylePlain];
    }
    
    self.subAudioTableView.delegate = self;
    self.subAudioTableView.dataSource = self;
    
    self.subAudioTableView.backgroundColor = [UIColor clearColor]; //clearColor
    [self.subAudioTableView setBackgroundView:self.imageView1];
    self.subAudioTableView.tableFooterView = self.nullView;
    
    //    self.subAudioTableView.backgroundColor=[UIColor clearColor];
    //    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [self.videoControl.rightView addSubview:self.subAudioTableView];
    [self.subAudioTableView reloadData];
    
    [self.view addSubview:self.subAudioTableView];
    //    self.subAudioTableView = table;
    
    
    
    
    
    
    int show = 1;
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",show],@"boolBarShow",nil];
    NSNotification *notification =[NSNotification notificationWithName:@"fixprogressView" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    NSLog(@"右侧列表消失 in show");
    [self.videoControl autoFadeRightTableView];
    
    
    //此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tableviewHidden" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightViewHidden) name:@"tableviewHidden" object:nil];
    
    
    
    
}
-(void)rightViewHidden
{
    NSLog(@"右侧列表消失333");
    self.videoControl.rightView.hidden = YES;
    self.videoControl.rightView.alpha = 0;
    
    self.subAudioTableView.hidden = YES;
    self.subAudioTableView.alpha = 0;
    self.subAudioTableView = nil;
    
    self.rightViewShowing = NO;
    
    int show = 1;
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",show],@"boolBarShow",nil];
    NSNotification * notification =[NSNotification notificationWithName:@"fixprogressView" object:nil userInfo:dict];
}


- (void)audioBtnClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timerStateInvalidate" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"lockButtonHide" object:nil];
    _cellStr = @"audio";
    NSLog(@"audio音轨");
    
    if (self.rightViewShowing == YES)
    {
        [self rightViewHidden];
        
        
    }else if(self.rightViewShowing ==NO)
    {
        [self rightViewshow];
        
    }
    
    NSArray * audioarr =[self.subAudioDic  objectForKey:@"audio_info"];
    BOOL judgeIsNull = [self judgeAudioIsNull:audioarr];
    if (judgeIsNull == YES || audioarr.count == 0 || audioarr == NULL || audioarr == nil) {
        
        NSLog(@"音轨可能没有数据");
        
    }else
    {
        if ([[USER_DEFAULT objectForKey:@"audioOrSubtTouch"] isEqualToString:@"YES"] ) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:audioPositionIndex inSection:0];
            [self.subAudioTableView scrollToRowAtIndexPath:scrollIndexPath  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }else
        {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.subAudioTableView scrollToRowAtIndexPath:scrollIndexPath  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        
    }
    
    
    
}

- (void)channelListBtnClick
{
    //    [tvViewController timerStateInvalidate];
    //    self.tvViewController.timerState = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timerStateInvalidate" object:nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"lockButtonHide" object:nil];
    _cellStr = @"channel";
    NSLog(@"channellist 频道列表");
    
    if (self.rightViewShowing == YES)
    {
        [self rightViewHidden];
        
        
    }else if(self.rightViewShowing ==NO)
    {
        [self rightViewshow];
        
    }
    
    //    if (self.video.dicChannl.count > ) {
    //        <#statements#>
    //    }
    
    //    NSArray *   =[self.chann  objectForKey:@"audio_info"];
    //    BOOL judgeIsNull = [self judgeAudioIsNull:self.video.dicChannl];
//    NSArray * subtarr =[self.video.dicChannl  objectForKey:@"epg_info"];
    if (self.video.dicChannl.count == 0 || self.video.dicChannl == NULL || self.video.dicChannl == nil || [self.subAudioTableView numberOfRowsInSection:0] <=0 || [self.subAudioTableView numberOfRowsInSection:0] <= channelPositionIndex) {
        
        NSLog(@"节目列表可能没有数据");
        
    }else
    {
    
        NSLog(@"channelPositionIndex %d",channelPositionIndex);
        NSLog(@"self.subAudioTableView %@",self.subAudioTableView);
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:channelPositionIndex inSection:0];
        [self.subAudioTableView scrollToRowAtIndexPath:scrollIndexPath  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        
    }

    
}



/// 返回按钮点击
- (void)backButtonClick
{
    if (!self.isFullscreenMode) { // 如果是竖屏模式，返回关闭
        if (self) {
            [self.durationTimer invalidate];
            [self.player stop];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
            
            if (self.videoPlayerGoBackBlock) {
                [self.videoControl cancelAutoFadeOutControlBar];
                self.videoPlayerGoBackBlock();
            }
        }
    } else { // 全屏模式，返回到竖屏模式
        if (self.isLocked) { // 解锁
            [self lockButtonClick:self.videoControl.lockButton];
        }
        [self changeToOrientation:UIDeviceOrientationPortrait];
        [self restoreOriginalScreen];
    }
}

/// 播放按钮点击
- (void)playButtonClick
{
    [self.player play];
    self.videoControl.playButton.hidden = YES;
    self.videoControl.pauseButton.hidden = NO;
}

/// 暂停按钮点击
- (void)pauseButtonClick
{
    [self.player pause];
    self.videoControl.playButton.hidden = NO;
    self.videoControl.pauseButton.hidden = YES;
}

///// 锁屏按钮点击
- (void)lockButtonClick:(UIButton *)lockBtn
{
    lockBtn.selected = !lockBtn.selected;
    
    if (lockBtn.selected) { // 锁定
        self.isLocked = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"ZXVideoPlayer_DidLockScreen"];
        [USER_DEFAULT setBool:YES forKey:@"lockedFullScreen"];
        
        
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"lockButtonHide" object:nil];
        
        [self.videoControl animateHide];
        
    } else { // 解除锁定
        self.isLocked = NO;
        [USER_DEFAULT setBool:NO forKey:@"lockedFullScreen"];
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
        
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"lockButtonHide" object:nil];
        
        [self.videoControl animateShow];
    }
}

/// 全屏按钮点击
- (void)fullScreenButtonClick
{
    if (self.isFullscreenMode) {
        return;
    }
    
    if (self.isLocked) { // 解锁
        [self lockButtonClick:self.videoControl.lockButton];
    }
    
    // FIXME: ?
    [self changeToOrientation:UIDeviceOrientationLandscapeLeft];
    [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
}

///// 返回竖屏按钮点击
//- (void)shrinkScreenButtonClick
//{
//
//
//    if (!self.isFullscreenMode) {
//        return;
//    }
//
//    if (self.isLocked) { // 解锁
//        [self lockButtonClick:self.videoControl.lockButton];
//    }
//
//    [self changeToOrientation:UIDeviceOrientationPortrait];
//}

/// 返回竖屏按钮点击1
- (void)shrinkScreenButton1Click
{
    
    if (!self.isFullscreenMode) {
        return;
    }
    
    if (self.isLocked) { // 解锁
        [self lockButtonClick:self.videoControl.lockButton];
    }
    
    [self changeToOrientation:UIDeviceOrientationPortrait];
    [self restoreOriginalScreen];
}

/// slider 按下事件
- (void)progressSliderTouchBegan:(MySlider *)slider
{
    NSLog(@"进度条按下了");
    [self.player pause];
    [self stopDurationTimer];
    [self.videoControl cancelAutoFadeOutControlBar];
}

/// slider 松开事件
- (void)progressSliderTouchEnded:(MySlider *)slider
{
    NSLog(@"进度条松开了");
    
    [self.player seek:floor(slider.value)];
    [self.player play];
    [self startDurationTimer];
    [self.videoControl autoFadeOutControlBar];
}

/// slider value changed
- (void)progressSliderValueChanged:(MySlider *)slider
{
    NSLog(@"进度条改变了");
    NSLog(@"slider.value %f",slider.value);
    double currentTime = floor(slider.value);
    double totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    
}

#pragma mark -
#pragma mark - getters and setters

-(void)setUrl:(NSURL *)url
{
    
    //    self.player = [[IJKFFMoviePlayerController alloc]initWithContentURL:url withOptions:nil playView:self.view];
    //     self.view = self.player.view ;
    //
    //    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //    self.player.view.frame = self.view.bounds;
    //
    ////    [self.view insertSubview:playerView atIndex:1];
    //    [self.player play];
    //    UIView *playerView = [[UIView alloc]initWithFrame:self.view.frame];
    
    //    [self.view addSubview:playerView];
    //    self.player = [[IJKFFMoviePlayerController alloc]initWithContentURL:url withOptions:nil playView:self.playerView];
    
    
    //    [operationQueue cancelAllOperations];
    //
    //    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
    //
    //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //            // 处理耗时操作的代码块...
    if (url == nil) {
        
    }else
    {
        //                UIAlertView *  abcalert  = [[UIAlertView alloc] initWithTitle:@"开始一个新的播放器" message:@"哈哈哈" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        //                [abcalert show];
        
        [self.player shutdown];
        [self.player.view removeFromSuperview];
        self.player = nil;
        [self.player stop];
        
        //        self.view  = nil;
        //        [self.view removeFromSuperview];
        
        
        //        self.view.backgroundColor = [UIColor  redColor];
        
        NSLog(@"self.View %@",self.view);
        //    if (self.player) {
        //        self.player = [self.player initWithContentURL:url withOptions:nil playView:nil];
        
        //    }
        NSLog(@"执行执行执行执行3333 %@",url);
        self.player =  [[IJKFFMoviePlayerController alloc]initWithContentURL:url withOptions:nil playView:nil];
        tempUrl = url;
        //    UIView *playerView = [self.player view];
        //    playerView.frame = self.PlayerView.frame;
        NSLog(@"self.playerView %@",self.player);
        self.player.view.frame = self.view.bounds;
        //    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //    [self.view insertSubview:self.playerView atIndex:1];
        [self.view insertSubview:self.player.view atIndex:0];
        
        //    [self.view addSubview:self.player.view];
        
        //        if (self. showTVView == YES) {
        if ([[USER_DEFAULT objectForKey:@"showTVView"] isEqualToString:@"YES"]) {
            [self.player prepareToPlay:0];
            [self.player play];

        }else
        {
            [self.player shutdown];
            [self.player.view removeFromSuperview];
            self.player = nil;
        }
        
        //        }
        
        
        
        NSLog(@"执行中0000000");
        
        //删除decoder PIN的文字和按钮
        NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigDecoderPINShowNotific" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
        
        //删除decoder PIN的文字和按钮
        NSNotification *notification2 =[NSNotification notificationWithName:@"removeConfigCAPINShowNotific" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification2];
        //                timerForGetBytes = nil; //此处把计时器销毁
        //                timerForGetBytes = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moviePlay) userInfo:nil repeats:YES];
    }
}

- (ZXVideoPlayerControlView *)videoControl
{
    if (!_videoControl) {
        _videoControl = [[ZXVideoPlayerControlView alloc] init];
    }
    return _videoControl;
}

- (void)setFrame:(CGRect)frame
{
    [self.view setFrame:frame];
    [self.videoControl setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.videoControl setNeedsLayout];
    [self.videoControl layoutIfNeeded];
}

- (UIDeviceOrientation)getDeviceOrientation
{
    return [UIDevice currentDevice].orientation;
}


-(void)newReplaceEventNameNotific
{
    //此处销毁通知，防止一个通知被多次调用    刷新节目名称的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"replaceEventNameNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replaceEventNameNotific) name:@"replaceEventNameNotific" object:nil];
}
-(void)replaceEventNameNotific
{
    self.videoControl.eventnameLabel.text = self.video.playEventName;
}

//时间戳转换

-(NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    int time1 ;
    if ([timeString intValue] >= 0) {
        time1 = [timeString intValue];
    }
    int seconds = time1 % 60;
    int minutes = (time1 / 60) % 60;
    int hours = time1 / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    
    
}

-(BOOL)judgeAudioIsNull :(NSArray *)audioArr
{
    if (audioArr.count >= 1) {
        NSString * AudioPidStr = [audioArr[0] objectForKey:@"audio_pid"];
        NSString * AudiolanguageStr = [audioArr[0] objectForKey:@"audio_language"];
        if ([AudioPidStr isEqualToString:@""] || [AudiolanguageStr isEqualToString:@""] ) {
            NSLog(@"数值为空，所以此时应该直接返回");
            return YES;
        }else
        {
            return  NO;
        }
    }else
    {
        return YES;
    }
}

-(BOOL)judgeSubtIsNull :(NSArray *)SubtArr
{
    if (SubtArr.count >= 1) {
        
        NSString * subtPidStr = [SubtArr[0] objectForKey:@"subt_pid"];
        NSString * subtlanguageStr = [SubtArr[0] objectForKey:@"subt_language"];
        if ([subtPidStr isEqualToString:@""] || [subtlanguageStr isEqualToString:@""] ) {
            NSLog(@"数值为空，所以此时应该直接返回");
            return YES;
        }else
        {
            return  NO;
        }
    }else
    {
        return YES;
    }
}
/////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([_cellStr isEqualToString:@"subt"]) {
        NSLog(@"self.subAudioDic--:%@",self.subAudioDic);
        NSArray * subtarr =[self.subAudioDic  objectForKey:@"subt_info"];
        BOOL judgeIsNull = [self judgeSubtIsNull:subtarr];
        if (judgeIsNull == YES) {
            NSLog(@"数值为空，所以此时应该直接返回");
            [self.videoControl.subtBtn setEnabled:NO];
            return 0;
            
        }else
        {
            
            NSLog(@"subtarr--:%@",subtarr);
            if (subtarr.count <=8) {
                self.subAudioTableView.frame = CGRectMake(CGRectGetWidth(self.view.bounds)-145,( SCREEN_WIDTH-subtarr.count*45)/2, 145,subtarr.count*46);
            }else
            {
                self.subAudioTableView.frame  =  CGRectMake(CGRectGetWidth(self.view.bounds)-145, 0, 145, CGRectGetHeight(self.videoControl.rightView.bounds));
            }
            
            //        [self.videoControl.subtBtn setEnabled:YES];  //此处需要置灰，以后再开放这个接口
            [self.videoControl.subtBtn setEnabled:NO];
            return subtarr.count;
            //        return 8;
        }
        
    }
    else if ([_cellStr isEqualToString:@"audio"]) {
        NSArray * audioarr =[self.subAudioDic  objectForKey:@"audio_info"];
        BOOL judgeIsNull = [self judgeAudioIsNull:audioarr];
        if (judgeIsNull == YES || audioarr.count == 0) {
            [self.videoControl.audioBtn setEnabled:NO];
            NSLog(@"数值为空，所以此时应该直接返回");
            return 0;
        }else
        {
            NSLog(@"audioarr--:%@",audioarr);
            if (audioarr.count <=8) {
                self.subAudioTableView.frame = CGRectMake(CGRectGetWidth(self.view.bounds)-145,( SCREEN_WIDTH-audioarr.count*45)/2, 145,audioarr.count*46);
            }else
            {
                self.subAudioTableView.frame  =  CGRectMake(CGRectGetWidth(self.view.bounds)-145, 0, 145, CGRectGetHeight(self.videoControl.rightView.bounds));
                
            }
            [self.videoControl.audioBtn setEnabled:YES];
            return audioarr.count;
        }
        
    }
    else if ([_cellStr isEqualToString:@"channel"]) {
        
        NSLog(@"22self.video =======----===---==---==-= %@ ",self.video);
        
        
        NSLog(@"self.video.channelCountababab :%d",self.video.channelCount);
        if (self.video.channelCount <= 8) {
            self.subAudioTableView.frame = CGRectMake(CGRectGetWidth(self.view.bounds)-145,( SCREEN_WIDTH-self.video.channelCount*45)/2, 145,self.video.channelCount*46);
        }else
        {
            self.subAudioTableView.frame  =  CGRectMake(CGRectGetWidth(self.view.bounds)-145, 0, 145, CGRectGetHeight(self.videoControl.rightView.bounds));
        }
        
        NSLog(@"self.video.channelCount %d",self.video.channelCount);
        
        
        return self.video.channelCount;
        
        //        return 8;
    }
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_cellStr isEqualToString:@"subt"]) {
        return [subtCell defaultCellHeight];
    }
    else if ([_cellStr isEqualToString:@"audio"]) {
        return [AudioCell defaultCellHeight];
        
    }
    else if ([_cellStr isEqualToString:@"channel"]) {
        return [ChannelCell defaultCellHeight];
    }
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_cellStr isEqualToString:@"subt"]) {
        subtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subtCell"];
        if (cell == nil){
            cell = [subtCell loadFromNib];
            cell.languageLab.textAlignment = UITextAlignmentCenter;
            cell.backgroundColor=[UIColor clearColor];
            
            UIView * viewClick = [[UIView alloc]initWithFrame:cell.frame];
            viewClick.backgroundColor = [UIColor clearColor];
            UIView * grayViewUP = [[UIView alloc]initWithFrame:CGRectMake(12.8, 0, cell.frame.size.width, 0.5)];
            grayViewUP.backgroundColor = [UIColor whiteColor];
            UIView * grayViewDown = [[UIView alloc]initWithFrame:CGRectMake(12.8, cell.frame.size.height - 1, cell.frame.size.width, 0.5)];
            grayViewDown.backgroundColor = [UIColor whiteColor];
            [viewClick addSubview:grayViewUP];
            [viewClick addSubview:grayViewDown];
            
            cell.selectedBackgroundView=viewClick;
            
            //            [cell.languageLab setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
            
            
            
        }
        
        
        
        if (!ISEMPTY(self.video.dicSubAudio)) {
            //        cell.dataDic
            NSArray * subAudioArr = [[NSArray alloc]init];
            
            subAudioArr  =[self.subAudioDic  objectForKey:@"subt_info"];
            
            
            
            NSMutableArray * subArrTemp = [[NSMutableArray alloc]init];
            int sub_languageIndex = 0;
            for (int i = 0; i < subAudioArr.count; i++) {
                
                [subArrTemp addObject: [subAudioArr[i] objectForKey:@"subt_language"]];
            }
            for (int i = 0; i < subAudioArr.count; i++) {
                
                NSString * subLanguageTemp = [subAudioArr[indexPath.row] objectForKey:@"subt_language"];
                
                
                if ([subLanguageTemp isEqualToString:[subAudioArr[i] objectForKey:@"subt_language"]]) {
                    sub_languageIndex ++ ;
                }
                
            }
            if (sub_languageIndex > 1) {
                //需要加号码
                NSMutableDictionary * mutableSubDic = [subAudioArr[indexPath.row] mutableCopy];
                [mutableSubDic setObject:@"yes" forKey:@"yes"];
                
                NSDictionary * subDicTemp = [mutableSubDic copy];
                cell.dataDic = subDicTemp;
            }else
            {
                //不需要加号码
                cell.dataDic = subAudioArr[indexPath.row];
            }
            
            
            
            if (sub_languageIndex > 1) {
                //需要加号码
                //            //焦点
                NSDictionary * fourceDic = [USER_DEFAULT objectForKey:@"NowChannelDic"];  //这里还用作判断播放的焦点展示
                NSLog(@"cell.dataDic 11:%@",cell.dataDic);
                //            NSLog(@"cell.dataDic fourceDic: %@",fourceDic);
                NSDictionary * subtDicBlue = [fourceDic objectForKey:@"subt_info"][subtRow];
                NSLog(@"cell.dataDic fourceDic: %@",subtDicBlue);
                
                NSMutableDictionary * mutableSubDic22 = [subtDicBlue mutableCopy];
                [mutableSubDic22 setObject:@"yes" forKey:@"yes"];
                
                if ([cell.dataDic isEqual:mutableSubDic22]) {
                    
                    [cell.languageLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
                    
                }else
                {
                    [cell.languageLab setTextColor:[UIColor whiteColor]];
                    
                }
                
            }else
            {
                //焦点
                NSDictionary * fourceDic = [USER_DEFAULT objectForKey:@"NowChannelDic"];  //这里还用作判断播放的焦点展示
                NSLog(@"cell.dataDic 11:%@",cell.dataDic);
                //            NSLog(@"cell.dataDic fourceDic: %@",fourceDic);
                NSDictionary * subtDicBlue = [fourceDic objectForKey:@"subt_info"][subtRow];
                NSLog(@"cell.dataDic fourceDic: %@",subtDicBlue);
                //            if ([cell.dataDic isEqual:subtDicBlue]) {
                if ([cell.dataDic isEqual:subtDicBlue]) {
                    
                    [cell.languageLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
                    
                }else
                {
                    [cell.languageLab setTextColor:[UIColor whiteColor]];
                    
                }
                
            }
            
            
            
            
            
            //上下两个都可以试一下
            //        cell.dataDic =self.subAudioDic;
        }else{//如果为空，什么都不执行
        }
        
        //        NSLog(@"cell.dataDic:%@",cell.dataDic);
        
        return cell;
    }
    else if ([_cellStr isEqualToString:@"audio"]) {
        AudioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioCell"];
        if (cell == nil){
            cell = [AudioCell loadFromNib];
            cell.languageLab.textAlignment = UITextAlignmentCenter;
            cell.backgroundColor=[UIColor clearColor];
            
            
            UIView * viewClick = [[UIView alloc]initWithFrame:cell.frame];
            viewClick.backgroundColor = [UIColor clearColor];
            UIView * grayViewUP = [[UIView alloc]initWithFrame:CGRectMake(12.8, 0, cell.frame.size.width, 0.5)];
            grayViewUP.backgroundColor = [UIColor whiteColor];
            UIView * grayViewDown = [[UIView alloc]initWithFrame:CGRectMake(12.8, cell.frame.size.height - 1, cell.frame.size.width, 0.5)];
            grayViewDown.backgroundColor = [UIColor whiteColor];
            [viewClick addSubview:grayViewUP];
            [viewClick addSubview:grayViewDown];
            
            cell.selectedBackgroundView=viewClick;
            
            //            [cell.languageLab setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
            
            
            
        }
        
        
        
        if (!ISEMPTY(self.video.dicSubAudio)) {
            
            NSArray * audioArr = [[NSArray alloc]init];
            
            audioArr  =[self.subAudioDic  objectForKey:@"audio_info"];
            
            NSLog(@"audioArr :%@",audioArr);
            NSLog(@"audioArr.count :%lu",(unsigned long)audioArr.count);
            
            NSMutableArray * audioArrTemp = [[NSMutableArray alloc]init];
            int audio_languageIndex = 0;
            for (int i = 0; i < audioArr.count; i++) {
                
                [audioArrTemp addObject: [audioArr[i] objectForKey:@"audio_language"]];
            }
            for (int i = 0; i < audioArr.count; i++) {
                
                NSString * audioLanguageTemp = [audioArr[indexPath.row] objectForKey:@"audio_language"];
                
                
                if ([audioLanguageTemp isEqualToString:[audioArr[i] objectForKey:@"audio_language"]]) {
                    audio_languageIndex ++ ;
                }
                
            }
            if (audio_languageIndex > 1) {
                //需要加号码
                NSMutableDictionary * mutableAudioDic = [audioArr[indexPath.row] mutableCopy];
                [mutableAudioDic setObject:@"yes" forKey:@"yes"];
                
                NSDictionary * AudioDicTemp = [mutableAudioDic copy];
                cell.dataDic = AudioDicTemp;
            }else
            {
                //不需要加号码
                cell.dataDic = audioArr[indexPath.row];
            }

            
            if (audio_languageIndex > 1) {
                //需要加号码
                //            //焦点
                NSDictionary * fourceDic = [USER_DEFAULT objectForKey:@"NowChannelDic"];  //这里还用作判断播放的焦点展示
                NSLog(@"cell.dataDic 11:%@",cell.dataDic);
                //            NSLog(@"cell.dataDic fourceDic: %@",fourceDic);
                NSDictionary * audioDicBlue = [fourceDic objectForKey:@"audio_info"][audioRow];
                NSLog(@"cell.dataDic fourceDic: %@",audioDicBlue);
                
                NSMutableDictionary * mutableAudioDic22 = [audioDicBlue mutableCopy];
                [mutableAudioDic22 setObject:@"yes" forKey:@"yes"];
                
                if ([cell.dataDic isEqual:mutableAudioDic22]) {
                    
                    [cell.languageLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
                    
                }else
                {
                    [cell.languageLab setTextColor:[UIColor whiteColor]];
                    
                }
                
            }else
            {
                //不需要加号码
                //            //焦点
                NSDictionary * fourceDic = [USER_DEFAULT objectForKey:@"NowChannelDic"];  //这里还用作判断播放的焦点展示
                NSLog(@"cell.dataDic 11:%@",cell.dataDic);
                //            NSLog(@"cell.dataDic fourceDic: %@",fourceDic);
                NSDictionary * audioDicBlue = [fourceDic objectForKey:@"audio_info"][audioRow];
                NSLog(@"cell.dataDic fourceDic: %@",audioDicBlue);
                //            if ([cell.dataDic isEqual:audioDicBlue]) {
                //                if ([GGUtil judgeTwoEpgDicIsEqual:cell.dataDic TwoDic:audioDicBlue]) {
                if ([cell.dataDic isEqual:audioDicBlue]) {
                    
                    [cell.languageLab setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
                    
                }else
                {
                    [cell.languageLab setTextColor:[UIColor whiteColor]];
                    
                }
                
            }
            
            
            //上下两个都可以试一下
            //        cell.dataDic =self.subAudioDic;
        }else{//如果为空，什么都不执行
        }
        
        //        NSLog(@"cell.dataDic:%@",cell.dataDic);
        
        return cell;
    }
    
    else if ([_cellStr isEqualToString:@"channel"]) {
        NSLog(@"右侧列表展示channel");
        ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell"];
        if (cell == nil){
            cell = [ChannelCell loadFromNib];
            cell.channelId.textAlignment =  NSTextAlignmentCenter;
            cell.channelName.textAlignment = NSTextAlignmentLeft;
           
    //            NSLog(@"cell.channelId %@ ",cell.channelId.text);
    //            if (cell.channelId.text == NULL || [cell.channelId.text isEqualToString:@""] || cell.channelId.text == nil) {
    //
    //                cell.channelName.frame = CGRectMake(20, 10, cell.frame.size.width, 15);
    //            }
            
            cell.backgroundColor=[UIColor clearColor];
            
            
            
           
            UIView * viewClick = [[UIView alloc]initWithFrame:cell.frame];
            viewClick.backgroundColor = [UIColor clearColor];
            UIView * grayViewUP = [[UIView alloc]initWithFrame:CGRectMake(12.8, 0, cell.frame.size.width, 0.5)];
            grayViewUP.backgroundColor = [UIColor whiteColor];
            UIView * grayViewDown = [[UIView alloc]initWithFrame:CGRectMake(12.8, cell.frame.size.height - 1, cell.frame.size.width, 0.5)];
            grayViewDown.backgroundColor = [UIColor whiteColor];
            [viewClick addSubview:grayViewUP];
            [viewClick addSubview:grayViewDown];
            
            cell.selectedBackgroundView=viewClick;
            
            
            
            
        }
        
        
        if (!ISEMPTY(self.video.dicChannl)) {
            
            cell.dataDic = [self.video.dicChannl objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
  
            //焦点
            NSDictionary * fourceDic = [USER_DEFAULT objectForKey:@"NowChannelDic"];  //这里还用作判断播放的焦点展示
          
            __block BOOL boolTemp;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                boolTemp = [GGUtil judgeTwoEpgDicIsEqual:cell.dataDic TwoDic:fourceDic];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (boolTemp) {
                        
                        [cell.channelId setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
                        [cell.channelName setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
                        
                    }else
                    {
                        [cell.channelId setTextColor:[UIColor whiteColor]];
                        [cell.channelName setTextColor:[UIColor whiteColor]];
                        
                    }
                });
                
            });
            
            
            
        }else{//如果为空，什么都不执行
            NSLog(@"self.video.dicChannl   %@",self.video.dicChannl);
        }
        
        
        return cell;
    }
    
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoControl.isBarShowing = NO;
        [self rightViewHidden];
    });
    
    
    //每次播放前，都先把 @"deliveryPlayState" 状态重置，这个状态是用来判断视频断开分发后，除非用户点击
    [USER_DEFAULT setObject:@"beginDelivery" forKey:@"deliveryPlayState"];
    
    //    if (self.rightViewShowing == YES)
    //    {
    //        self.videoControl.isBarShowing = NO;
    //        [self rightViewHidden];
    //    }
    NSInteger rowIndex;
    if ([_cellStr isEqualToString:@"subt"]) {
        
        
        if (!ISEMPTY(self.video.dicChannl)) {
            
            NSMutableArray *  historyArr  = [[NSMutableArray alloc]init];
            historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];
            
            NSArray * touchArr = historyArr[historyArr.count - 1];
            NSLog(@"touchArr：%@",touchArr);
            //    [self touchToSee :touchArr];
            
            
            rowIndex = [touchArr[2] intValue];
            NSDictionary * dic = touchArr [3];
            
            
            subtRow = indexPath.row;
            //            audioRow = 0;
            [self touchToSeeAudioSubt :dic DicWithRow:rowIndex  audio:audioRow subt:subtRow];
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView.separatorColor = [UIColor whiteColor];
            
            
            NSDictionary *indexPathdict =[[NSDictionary alloc] initWithObjectsAndKeys:indexPath,@"indexPathDic", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableFocusNotific" object:nil userInfo:indexPathdict];
        }else{//如果为空，什么都不执行
        }
        //        [self.socketView1  serviceTouch ];
        
    }
    else if ([_cellStr isEqualToString:@"audio"]) {
        
        
        if (!ISEMPTY(self.video.dicChannl)) {
         
            
            NSMutableArray *  historyArr  = [[NSMutableArray alloc]init];
            historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];
            
            NSArray * touchArr = historyArr[historyArr.count - 1];
            NSLog(@"touchArr：%@",touchArr);
            //    [self touchToSee :touchArr];
            
            
            rowIndex = [touchArr[2] intValue];
            NSDictionary * dic = touchArr [3];
            
            
            
          
            audioRow = indexPath.row;
            [self touchToSeeAudioSubt :dic DicWithRow:rowIndex  audio:audioRow subt:subtRow];
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView.separatorColor = [UIColor whiteColor];
            
            
            
            NSDictionary *indexPathdict =[[NSDictionary alloc] initWithObjectsAndKeys:indexPath,@"indexPathDic", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableFocusNotific" object:nil userInfo:indexPathdict];
            
            
        }else{//如果为空，什么都不执行
        }
        //        [self.socketView1  serviceTouch ];
        
    }
    else if ([_cellStr isEqualToString:@"channel"]) {
        
        
        __block NSDictionary * dic ;
        if (!ISEMPTY(self.video.dicChannl)) {
            
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                audioRow = 0;
                subtRow = 0;
                dispatch_async(dispatch_get_main_queue(), ^{
                    dic = [self.video.dicChannl objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                    //            [self.tvViewControlller  touchSelectChannel:indexPath.row diction:self.video.dicChannl];
                    NSLog(@"dic-- %@",dic);
                    [self touchToSee :dic DicWithRow:indexPath.row];
                });
                
                tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                tableView.separatorColor = [UIColor whiteColor];
                
            });
      
            //刷新注意的焦点
            NSDictionary *indexPathdict =[[NSDictionary alloc] initWithObjectsAndKeys:indexPath,@"indexPathDic", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableFocusNotific" object:nil userInfo:indexPathdict];
            
        }else{//如果为空，什么都不执行
        }
        //        [self.socketView1  serviceTouch ];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self judgeLastBtnIsGray];
        [self judgeNextBtnIsGray];
        NSArray * subtarr =[self.video.dicSubAudio  objectForKey:@"subt_info"];
        NSArray * audioStr =[self.video.dicSubAudio  objectForKey:@"audio_info"];
        BOOL judgeIsNull = [self judgeSubtIsNull:subtarr];
        if (judgeIsNull == YES) {
            NSLog(@"数值为空，所以此时应该直接返回");
            [self.videoControl.subtBtn setEnabled:NO];
            
        }else
        {
            //        [self.videoControl.subtBtn setEnabled:YES];  //此处需要置灰，以后再开放这个接口
            [self.videoControl.subtBtn setEnabled:NO];
        }
        BOOL judgeIsNull1 = [self judgeAudioIsNull:audioStr];
        if (judgeIsNull1 == YES) {
            NSLog(@"数值为空，所以此时应该直接返回");
            [self.videoControl.audioBtn setEnabled:NO];
            
            
        }else
        {
            [self.videoControl.audioBtn setEnabled:YES];
        }
        NSLog(@"我被选中了，哈哈哈哈哈哈哈");
    });
    
}
//节目播放点击
-(void)touchToSee :(NSDictionary* )dic DicWithRow:(NSInteger)row
{
    //关闭当前正在播放的节目
    [self.player stop];
    [self.player shutdown];
    [self.player.view removeFromSuperview];
    
    NSMutableArray *  historyArr  = [[NSMutableArray alloc]init];
    historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];
    
    NSArray * touchArr;
    if (historyArr.count >= 1) {
        touchArr = historyArr[historyArr.count - 1];
    }else
    {
        return;
    }
    //    NSArray * touchArr = historyArr[historyArr.count - 1];
    NSLog(@"touchArr：%@",touchArr);
    NSDictionary * dicAll = touchArr [3];
    
    
    NSLog(@"dicdicdicdic %@",dicAll);
    //    NSInteger row = [touchArr[2] intValue];
    //    NSDictionary * dic = touchArr [3];
    //    NSDictionary *dicNow =[[NSDictionary alloc] initWithObjectsAndKeys:dic,[NSString stringWithFormat:@"%ld",(long)row], nil];
    
    //将整形转换为number
    NSNumber * numIndex = [NSNumber numberWithInteger:row];
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dicAll,@"textTwo", nil];
    
    
    //这里需要进行一次判断，看是不是需要弹出机顶盒加锁密码框
    NSDictionary * epgDicToSocket = [dicAll objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    
    
    //快速切换频道名称和节目名称
    NSDictionary *nowPlayingDic =[[NSDictionary alloc] initWithObjectsAndKeys:epgDicToSocket,@"nowPlayingDic", nil];
    
    //创建通知
    NSNotification *notification2 =[NSNotification notificationWithName:@"setChannelNameAndEventNameNotic" object:nil userInfo:nowPlayingDic];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
    
    
    NSString * characterStr = [epgDicToSocket objectForKey:@"service_character"]; //新加了一个service_character
    
    
    if (characterStr != NULL && characterStr != nil) {
        
        BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
        if (judgeIsSTBDecrypt == YES) {
            // 此处代表需要记性机顶盒加密验证
            //弹窗
            //发送通知
            
            //        [self popSTBAlertView];
            //        [self popCAAlertView];
            NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dicAll,@"textTwo", @"otherTouch",@"textThree",nil];
            //创建通知
            NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
            NSLog(@"POPPOPPOPPOP888888888");
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification1];
            
            
        }else //正常播放的步骤
        {
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            
        }
        
        
    }else //正常播放的步骤
    {
        
        
        
        
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
      
    }
}

//音轨字幕点击
-(void)touchToSeeAudioSubt :(NSDictionary* )dic DicWithRow:(NSInteger)row audio:(NSInteger)audioIndex subt:(NSInteger)subtIndex
{
    
    NSMutableArray *  historyArr  = [[NSMutableArray alloc]init];
    historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];
    
    NSArray * touchArr = historyArr[historyArr.count - 1];
    NSLog(@"touchArr：%@",touchArr);
    NSDictionary * dicAll = touchArr [3];
    
    //    NSInteger row = [touchArr[2] intValue];
    //    NSDictionary * dic = touchArr [3];
    //    NSDictionary *dicNow =[[NSDictionary alloc] initWithObjectsAndKeys:dic,[NSString stringWithFormat:@"%ld",(long)row], nil];
    
    
    
    
    //=======机顶盒加密
    NSString * characterStr = [GGUtil judgeIsNeedSTBDecrypt:row serviceListDic:dicAll];
    if (characterStr != NULL && characterStr != nil) {
        BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
        if (judgeIsSTBDecrypt == YES) {
            // 此处代表需要记性机顶盒加密验证
            NSNumber * numIndex = [NSNumber numberWithInteger:row];
            
            NSNumber * audioNum = [NSNumber numberWithInteger:audioIndex];
            NSNumber * subtNum = [NSNumber numberWithInteger:subtIndex];
            NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dicAll,@"textTwo", @"AudioSubtTouch",@"textThree",audioNum,@"textFour",subtNum,@"textFive",nil];
            //创建通知
            NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
            NSLog(@"POPPOPPOPPOP99999999999991");
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification1];
            
        }else //正常播放的步骤
        {
            NSNumber * numIndex = [NSNumber numberWithInteger:row];
            
            NSNumber * audioNum = [NSNumber numberWithInteger:audioIndex];
            NSNumber * subtNum = [NSNumber numberWithInteger:subtIndex];
            //添加 字典，将label的值通过key值设置传递
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dicAll,@"textTwo",audioNum,@"textThree",subtNum,@"textFour", nil];
            
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoificAudioSubt" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }else //正常播放的步骤
    {
        //======机顶盒加密
        
        //    NSLog(@"dicNow %@",dicNow);
        //将整形转换为number
        NSNumber * numIndex = [NSNumber numberWithInteger:row];
        
        NSNumber * audioNum = [NSNumber numberWithInteger:audioIndex];
        NSNumber * subtNum = [NSNumber numberWithInteger:subtIndex];
        //添加 字典，将label的值通过key值设置传递
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dicAll,@"textTwo",audioNum,@"textThree",subtNum,@"textFour", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoificAudioSubt" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        //    [self.navigationController popViewControllerAnimated:YES];
        //    [self.navigationController popToViewController:_tvViewController animated:YES];
        //    [self.navigationController pushViewController:_tvViewController animated:YES];
        //    [self.tabBarController setSelectedIndex:1];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(TableViewHidden) object:nil];
    //
    //    [self performSelector:@selector(TableViewHidden) withObject:nil afterDelay:5];
    
    //    [self.videoControl autoFadeOutControlBar];
    [self.videoControl autoFadeRightTableView];
    
    //    NSIndexPath *path =  [self.subAudioTableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    //
    //    NSLog(@"这是第%i行",path.row);
    //
    
    
}

#pragma mark -- new add ijkplayer 通知
- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.player];
    
}
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = self.player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (self.player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)self.player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)self.player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)self.player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)self.player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)self.player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)self.player.playbackState);
            break;
        }
    }
}

#pragma mark - 快速设置频道名称和节目名称等信息，并且
//快速设置频道名称和节目名称等信息
-(void)setChannelNameAndEventName
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setChannelNameAndEventNameNotic" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setChannelNameAndEventNameNotic:) name:@"setChannelNameAndEventNameNotic" object:nil];
}
-(void)setChannelNameAndEventNameNotic :(NSNotification *)text{
    
    //先获取当前正在播放的节目字典
    NSDictionary * nowPlayingDic = text.userInfo[@"nowPlayingDic"];
    
    NSLog(@" nowPlayingDic %@",nowPlayingDic);
    NSLog(@" nowPlayingDic.count %lu",(unsigned long)nowPlayingDic.count);
    
    if (nowPlayingDic.count < 20) { //直播
        
        NSLog(@"kdjfb;asddasdadasasbf==");
        
        NSString * channelIdLabStr = [nowPlayingDic objectForKey:@"service_logic_number"];
        
        
        if(channelIdLabStr.length == 1)
        {
            channelIdLabStr = [NSString stringWithFormat:@"00%@", channelIdLabStr];
        }
        else if (channelIdLabStr.length == 2)
        {
            channelIdLabStr = [NSString stringWithFormat:@"0%@", channelIdLabStr];
        }
        else if (channelIdLabStr.length == 3)
        {
            channelIdLabStr = [NSString stringWithFormat:@"%@", channelIdLabStr];
        }
        else if (channelIdLabStr.length > 3)
        {
            channelIdLabStr= [ channelIdLabStr substringFromIndex: channelIdLabStr.length - 3];
        }
        
        
        NSString * channelNameLabStr = [nowPlayingDic objectForKey:@"service_name"];
        NSArray * arrNowPlayingTemp = [nowPlayingDic objectForKey:@"epg_info"];
        if (arrNowPlayingTemp.count > 0) {
            NSString * eventNameLabStr = [[nowPlayingDic objectForKey:@"epg_info"][0] objectForKey:@"event_name"];  //这里得做修改，因为不能总播放第一个节目
            self.video.playEventName =eventNameLabStr;
        }
            self.video.channelId =channelIdLabStr;
            self.video.channelName =channelNameLabStr;
        
            
            self.videoControl.channelIdLab.text = self.video.channelId;
            
            self.videoControl.channelNameLab.text = self.video.channelName;
            self.videoControl.channelIdLab.frame = CGRectMake(20, 10, 25, 18);
            self.videoControl.channelNameLab.frame = CGRectMake(56, 10, 120+50, 18);
            self.videoControl.eventnameLabel.text = self.video.playEventName;

        //    NSString * eventNameLabStr = [[nowPlayingDic objectForKey:@"epg_info"][0] objectForKey:@"event_name"];  //这里得做修改，因为不能总播放第一个节目
        
        self.videoControl.progressSlider.hidden = YES;
        self.videoControl.progressSlider.alpha = 0;
        
    }else
    {
        //录制
        self.videoControl.progressSlider.hidden = NO;
        self.videoControl.progressSlider.alpha = 1;
        
        NSString * channelNameLabStr = [nowPlayingDic objectForKey:@"file_name"];

//            NSString * eventNameLabStr = [nowPlayingDic objectForKey:@"event_name"];
            NSString * eventNameLabStr = @"";
        //这里得做修改，因为不能总播放第一个节目
        
//            self.video.channelId =channelIdLabStr;
            
            self.video.channelId = @"";
            self.video.channelName =channelNameLabStr;
        
        
            self.video.playEventName =eventNameLabStr;
            
            self.videoControl.channelIdLab.text = self.video.channelId;
        
            self.videoControl.channelNameLab.text = self.video.channelName;
        
        //通过判断是不是全屏或者是竖屏来展示频道名称
        if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.width > 420) { //全屏
            
            NSLog(@"REC  横屏");
            
           self.videoControl.channelNameLab.frame = CGRectMake(42, 26, 56+200 , 55);
            
            NSLog(@"SCREEN_WIDTH==SCREEN_WIDTH %f",SCREEN_WIDTH);
            self.videoControl.progressSlider.frame = CGRectMake(0, self.videoControl.bottomBar.frame.size.height - 50 , SCREEN_HEIGHT+1, 2);
            NSLog(@"lalalalalalalalalalalal3333");
            
        }else //竖屏
        {
            NSLog(@"REC  竖屏");
            if ([self.video.channelId isEqualToString: @""]) {
              
                self.videoControl.channelNameLab.frame = CGRectMake(20, 10, 25+200, 18);
            }
             self.videoControl.channelNameLab.frame = CGRectMake(20, 10, 25+200, 18);
            
            NSLog(@"可能会出错的地方self.view.frame.bounds.width2");
 
            self.videoControl.progressSlider.frame = CGRectMake(-2, self.videoControl.bottomBar.frame.size.height - 1.5, SCREEN_WIDTH+3, 1.5f);
            NSLog(@"lalalalalalalalalalalal444");

        }
        
 
            self.videoControl.eventnameLabel.text = self.video.playEventName;
        }
        //    NSString * eventNameLabStr = [[nowPlayingDic objectForKey:@"epg_info"][0] objectForKey:@"event_name"];  //这里得做修改，因为不能总播放第一个节目
        
//    }
    
   
    
}



-(void)judgeAudioOrSubtAndChannelIndex :(NSInteger) channelIndex
{
    
}
-(void)RECsetEventTime
{
    NSLog(@"this is 33333");
    float aa1 = [self.video.endTime intValue]  - [self.video.startTime intValue];
    NSString * aa = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%f",aa1]];
    
    
    int bb1 ;
    
    
    //如果时间为0 ,或者没有获取到时间，则显示为0
    if ([self.video.startTime intValue] == nil || [self.video.startTime intValue] == NULL || [self.video.startTime intValue] == 0) {
        bb1 = 0;
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    } else
    {
        bb1 = (int)self.player.playableDuration;
//        NSLog(@"self.player.playableDuration1bb1 %d",bb1);
    }
    if (bb1 <0) {
        bb1 = 0;
        aa1 = 0;
        aa = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%f",aa1]];
    }
    if (bb1 < aa1) {
        NSString * nowTime = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%d",bb1]];
        
        self.videoControl.eventTimeLabNow.text = [NSString stringWithFormat:@"%@ ",nowTime];
        self.videoControl.eventTimeLabAll.text = [NSString stringWithFormat:@"| %@",aa];
    }else
    {
        NSString * nowTime = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%d",bb1]];
        self.videoControl.eventTimeLabNow.text = [NSString stringWithFormat:@"%@ ",aa];
        self.videoControl.eventTimeLabAll.text = [NSString stringWithFormat:@"| %@",aa];
    }
    
  
    
    
}
-(void)setEventTime
{
    NSLog(@"this is 00000");
    float aa1 = [self.video.endTime intValue]  - [self.video.startTime intValue];
    NSString * aa = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%f",aa1]];
    
    
    int bb1 ;
    
    //如果时间为0 ,或者没有获取到时间，则显示为0
    if ([self.video.startTime intValue] == nil || [self.video.startTime intValue] == NULL || [self.video.startTime intValue] == 0) {
        bb1 = 0;
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    } else
    {
        
        bb1 = [[GGUtil GetNowTimeString] intValue]  - [self.video.startTime intValue];
        
        NSLog(@" bb1 %d",bb1);
    }
    if (bb1 <0) {
        bb1 = 0;
        aa1 = 0;
        aa = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%f",aa1]];
    }
    
    
    NSString * nowTime = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%d",bb1]];
    
    
    self.videoControl.eventTimeLabNow.text = [NSString stringWithFormat:@"%@ ",nowTime];
    self.videoControl.eventTimeLabAll.text = [NSString stringWithFormat:@"| %@",aa];
    
    
}
#pragma mark - 判断进度条是不是需要显示
-(void)configTimerOfEventTimeNotific
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TimerOfEventTimeNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TimerOfEventTimeNotific) name:@"TimerOfEventTimeNotific" object:nil];
}
//判断进度条是不是需要显示
-(void)TimerOfEventTimeNotific
{
    
    [timerOfEventTime invalidate];
    timerOfEventTime = nil;
    if (timerOfEventTime == nil) {
        timerOfEventTime =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setEventTime1) userInfo:nil repeats:YES];
    }
    
    
}
-(void)setEventTime1 //判断进度条是不是需要显示
{
    NSLog(@"this is 11111");
    NSLog(@"zxvideo 判断进度条是不是需要显示");
    int  EPGArrindex = 0; //先随便初始化一下
    NSString * tempIndexStr;
    NSArray * arr = [USER_DEFAULT objectForKey:@"NowChannelEPG"];
    if (arr.count > 0) {
        
        tempIndexStr =[USER_DEFAULT objectForKey:@"nowChannelEPGArrIndex"];   //一直没变，应该让他先变
        EPGArrindex = [tempIndexStr intValue];
        NSLog(@"EPGArrindexEPGArrindexEPGArrindex %d",EPGArrindex);
        if (EPGArrindex > arr.count-1) {
            NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else
        {
            
            self.video.startTime = [arr[EPGArrindex]objectForKey:@"event_starttime"];
            self.video.endTime = [arr[EPGArrindex]objectForKey:@"event_endtime"];
            
            if (self.video.startTime != NULL && self.video.startTime != nil && [self.video.startTime intValue] >0 && self.video.endTime != NULL && self.video.endTime != nil && [self.video.endTime intValue] >0 && [self.video.endTime intValue]> [self.video.startTime intValue]) {
                
                self.video.startTime = [arr[EPGArrindex]objectForKey:@"event_starttime"];
                self.video.endTime = [arr[EPGArrindex]objectForKey:@"event_endtime"];
                
                NSLog(@"self.video.startTime lalala22 :%@",self.video.startTime);
                NSLog(@"endTime lalala22 :%@",self.video.endTime);
                
                float aa1 = [self.video.endTime intValue]  - [self.video.startTime intValue];  //时间差
                NSString * aa = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%f",aa1]];
                NSLog(@"nowTime %@",aa);
                
                int bb1 ;
                
                //如果时间为0 ,或者没有获取到时间，则显示为0
                if ([self.video.startTime intValue] == nil || [self.video.startTime intValue] == NULL || [self.video.startTime intValue] == 0) {
                    bb1 = 0;
                } else
                {
                    NSLog(@"self.video.startTime lalala :%@",self.video.startTime);
                    bb1 = [[GGUtil GetNowTimeString] intValue]  - [self.video.startTime intValue];  //当前时间和开始时间比较
                }
                if (bb1 < 0) {
                    bb1 = 0;
                    aa1 = 0;
                    aa = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%f",aa1]];
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }
                NSLog(@"bb1 bb1 :%d",bb1);
                
                NSString * nowTime = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%d",bb1]];
                NSLog(@"nowTime %@",nowTime);
                
                //            if([nowTime intValue] >= [aa intValue] )
                if(bb1 >= aa1  )
                {
                    NSLog(@"出错了，节目的当前时间不能大于结束时间");
                    NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
                }
                else{
                    NSLog(@"nowTime nowTime :%@",nowTime);
                    NSLog(@"nowTime nowTime :%@",aa);
                    
                    self.videoControl.eventTimeLabNow.text = [NSString stringWithFormat:@"%@ ",nowTime];
                    self.videoControl.eventTimeLabAll.text = [NSString stringWithFormat:@"| %@",aa];
                }
                
            }
            
        }
        
    }
    
    
}
- (void)setVideo:(ZXVideo *)video
{
    NSLog(@"contentURL 22ZXVideo");
    _video = video;
    
    // 标题
    self.videoControl.titleLabel.text = self.video.title;
    // play url
    self.url = [NSURL URLWithString:self.video.playUrl];
    NSLog(@"contentURL 33ZXVideo");
    //当前节目名称
    self.videoControl.eventnameLabel.text = self.video.playEventName;
    //        self.videoControl.eventnameLabel.text = @"1234567890123456789012345678901234567890|1234567890123456789012345678901234567890|1234567890123456789012345678901234567890|1234567890123456789012345678901234567890|1234567890123456789012345678901234567890|1234567890123456789012345678901234567890|1234567890123456789012345678901234567890";
    //    self.videoControl.eventnameLabel.text = @"补充下，之前所说有点问题，苹果和pad不是不能播、只是没显示出来播放按钮、 被误导了。直接播.m3u8地址就会调动系统自身播放器，出现播放按钮。 PC上的浏览器不能播m3u8，安卓借用H5封装可以播，ios可以直接播。 这是系统本身决定的";
    //    self.videoControl.eventnameLabel.text = @"补充下，之前所说有点问题，苹果和pad不是不能播、只是没显示出来播放按钮、 被误导了。直接播.m3u8地址就会调动系统自身播放器，";
    //    self.videoControl.eventnameLabel.text = @"补充下，之前所说有点问题，苹果和pad不是不能播、只是";
    //    self.videoControl.eventnameLabel.text = @"补充下，之前所说有点问题，苹果和pad不是不能播";
//         self.videoControl.eventnameLabel.text = @"1234567890123456789012345678901234567890";
    [self newReplaceEventNameNotific];
    self.videoControl.channelIdLab.text = self.video.channelId;
    
    self.videoControl.channelNameLab.text =  self.video.channelName;
    
    
    [self setEventTime1];
    
    NSString * channelType = [USER_DEFAULT objectForKey:@"ChannelType"];
    if ([channelType isEqualToString:@"RECChannel"]) {
        [self startDurationTimer];
        [timerOfEventTime invalidate];
        timerOfEventTime = nil;
        
        timerOfEventTime =  [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(RECsetEventTime) userInfo:nil repeats:YES];  //时间变化的计时器
    }else
    {
        [timerOfEventTime invalidate];
        timerOfEventTime = nil;
        timerOfEventTime =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setEventTime) userInfo:nil repeats:YES];  //时间变化的计时器
    }
    
    
    
    [self.videoControl.FullEventYFlabel removeFromSuperview];
    self.videoControl.FullEventYFlabel = nil;
    [self.videoControl.FullEventYFlabel stopTimer];
    
    UIDeviceOrientation orientation = self.getDeviceOrientation;
    
    switch (orientation) {
        case UIDeviceOrientationPortrait: {           // Device oriented vertically, home button on the bottom
            NSLog(@"home键在 下");
            
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown: { // Device oriented vertically, home button on the top
            NSLog(@"home键在 上");
            [self abctest];
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {      // Device oriented horizontally, home button on the right
            NSLog(@"home键在 右");
            [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
            
            [self abctest];
        }
            break;
        case UIDeviceOrientationLandscapeRight: {     // Device oriented horizontally, home button on the left
            NSLog(@"home键在 左");
            //                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeRight];
            [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
            [self abctest];
        }
            break;
            
        default:
        {     // Device oriented horizontally, home button on the left
            NSLog(@"手机可能屏幕朝上，可能不知道方向，可能斜着");
            
            NSLog(@"self.view.frame.size.width %@",NSStringFromCGRect(self.view.frame));
            
            NSLog(@"UIScreen mainScreen].bounds.size.width %@",NSStringFromCGRect([UIScreen mainScreen].bounds));
            
            
            if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.width > 420) { //全屏
                [self abctest];  //全屏页面时候，加载跑马灯的名字
            }
            NSLog(@"可能会出错的地方self.view.frame.bounds.width3");
        }
            break;
    }
    
    
    if ([[USER_DEFAULT objectForKey:@"VideoTouchFromOtherView"] isEqualToString:@"YES"]) {
        self.video.dicChannl =   [USER_DEFAULT objectForKey:@"VideoTouchOtherViewdicChannl"];
        self.video.channelCount =  [[USER_DEFAULT objectForKey:@"VideoTouchOtherViewchannelCount"] intValue];
        NSLog(@"self.video.channelCountself.video.channelCount");
        self.video.dicSubAudio = [USER_DEFAULT objectForKey:@"VideoTouchOtherViewdicSubAudio"];
    }
    
    [USER_DEFAULT setObject:@"NO" forKey:@"VideoTouchFromOtherView"]; //记录其他界面的点击播放时间，因为其他界面跳转过来的播放，可能会导致self.Video重新复制，导致EPG数据无法接受;此处使用完成后，重新赋值为NO，防止在主页面点击播放会触发同样的效果
    
    NSArray * subtarr =[self.video.dicSubAudio  objectForKey:@"subt_info"];
    NSArray * audioStr =[self.video.dicSubAudio  objectForKey:@"audio_info"];
    BOOL judgeIsNull = [self judgeSubtIsNull:subtarr];
    if (judgeIsNull == YES) {
        NSLog(@"数值为空，所以此时应该直接返回");
        [self.videoControl.subtBtn setEnabled:NO];
        
    }else
    {
        //        [self.videoControl.subtBtn setEnabled:YES];  //此处需要置灰，以后再开放这个接口
        [self.videoControl.subtBtn setEnabled:NO];
    }
    BOOL judgeIsNull1 = [self judgeAudioIsNull:audioStr];
    if (judgeIsNull1 == YES) {
        NSLog(@"数值为空，所以此时应该直接返回");
        [self.videoControl.audioBtn setEnabled:NO];
        
        
    }else
    {
        [self.videoControl.audioBtn setEnabled:YES];
    }
    
    [self judgeLastBtnIsGray];
    [self judgeNextBtnIsGray];
    
    //分线程对传过来的数据进行判断，判断节目分别index是多少，然后进行展示
    
    //    [self judgeAudioOrSubtAndChannelIndex : channelIndex];
    
    
    if ([[USER_DEFAULT objectForKey:@"audioOrSubtTouch"] isEqualToString:@"YES"] ) {
        
        NSArray * audioarr =[self.subAudioDic  objectForKey:@"audio_info"];
        if (audioarr.count > [[USER_DEFAULT objectForKey:@"Touch_Audio_index"] intValue] ) {
            audioPositionIndex =  [[USER_DEFAULT objectForKey:@"Touch_Audio_index"] intValue];
            NSLog(@"audioPositionIndex %d",audioPositionIndex);
            //            audioRow = audioPositionIndex;
        }else
        {
            audioPositionIndex = 0;
            //            audioRow = 0;
        }
        NSArray * subtarr =[self.subAudioDic  objectForKey:@"subt_info"];
        if (subtarr.count > [[USER_DEFAULT objectForKey:@"Touch_Subt_index"] intValue] ) {
            subtPositionIndex =  [[USER_DEFAULT objectForKey:@"Touch_Subt_index"] intValue];
            NSLog(@"audioPositionIndex22 %d",subtPositionIndex);
            //            subtRow = subtPositionIndex;
        }else
        {
            subtPositionIndex = 0;
            //            subtRow = 0;
        }
        
        
    }else
    {
        audioPositionIndex = 0;
        subtPositionIndex = 0;
        //        audioRow = 0;
        //        subtRow = 0;
    }
    
    
    channelPositionIndex =  [[USER_DEFAULT objectForKey: @"Touch_Channel_index"] intValue];
    if (self.video.dicChannl.count > channelPositionIndex ) {
    }else
    {
        channelPositionIndex = 0;
    }
    [self.videoControl.suspendButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    
}
-(void)setaudioOrSubtRowIsZero
{
    audioRow = 0;
    subtRow = 0;
    
}
#define mark - 数据停止分发3秒后显示不能播放的文字，等到数据缓冲完成，自动重新播放
-(void)stopPlayAndWaitBuffering
{
    NSLog(@"卡拉  开始配置 进入方法3");
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString * isShowLabStr = [USER_DEFAULT objectForKey:@"LabOrPop"];  //不能播放的文字和弹窗互斥出现
        
        if ([isShowLabStr isEqualToString:@"POP"]) {
            //什么都不执行,因为此时有弹窗的文字在展示
            NSLog(@"卡拉  开始配置 进入方法33");
        }else
        {
            NSLog(@"卡拉  开始配置 进入方法333");
            //保存三个有用的信息
            
            NSString * playStateType = [USER_DEFAULT objectForKey:@"playStateType"];//text.userInfo[@"playStateType"];
            
            
            
            //①创建通知,删除进度条
            NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            //②右侧列表消失
            NSLog(@"右侧列表消失 noPlayShowNotic222");
            self.subAudioTableView.hidden = YES;
            self.subAudioTableView = nil;
            [self.subAudioTableView removeFromSuperview];
            self.subAudioTableView = NULL;
            self.subAudioTableView.alpha = 0;
            //③ 删除音频图片
            [self removeConfigRadioShowNotific];  //删除音频图片的函数。，防止音频图片显示
            //④取消掉加载环
            [self.videoControl.indicatorView stopAnimating];
//            //⑤停止播放的动作,并且取消掉图画
//            [self.player stop];
//            [self.player shutdown];
            [self.player.view removeFromSuperview];
            
            
            //⑥显示不能播放的字，通过判断home键的位置来判断label的显示大小和位置
            UIDeviceOrientation orientation = self.getDeviceOrientation;
            if (!self.isLocked)
            {
                NSLog(@"width== %f",self.view.frame.size.width);
                NSLog(@"height== %f",self.view.frame.size.height);
                NSLog(@"screenWidth== %f",[UIScreen mainScreen].bounds.size.width);
                NSLog(@"screenHeight== %f",[UIScreen mainScreen].bounds.size.height);
                
                //转盘方向  研究
                
                switch (orientation) {
                    case UIDeviceOrientationPortrait: {           // Device oriented vertically, home button on the bottom
                        NSLog(@"home键在 下");
                        [self restoreOriginalScreen];
                        
                        if ( !lab) {
                            lab = [[UILabel alloc]init];
                            NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                            if (videoOrRadiostr != NULL) {
                                if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                                    lab.text = deliveryStopTip;   //如果不为空,则显示
                                }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = mediaDisConnect;
                                }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = ResourcesFull;
                                }
                                else
                                {
                                    lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                                }
                                
                            }else
                            {
                                lab.text = videoCantPlayTip;
                            }
                            
                            
                            lab.font = FONT(17);
                            lab.textAlignment = NSTextAlignmentCenter;
                            lab.textColor = [UIColor whiteColor];
                            [self.view addSubview:lab];
                            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                            CGSize size=[lab.text sizeWithAttributes:attrs];
                            lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                            
                            //创建通知
                            NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                            
                        }
                    }
                        break;
                    case UIDeviceOrientationPortraitUpsideDown: { // Device oriented vertically, home button on the top
                        NSLog(@"home键在 上");
                        
                        if ( !lab) {
                            lab = [[UILabel alloc]init];
                            
                            
                            NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                            if (videoOrRadiostr != NULL) {
                                if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                                    lab.text = deliveryStopTip;   //如果不为空,则显示
                                }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = mediaDisConnect;
                                }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = ResourcesFull;
                                }
                                else
                                {
                                    lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                                }
                            }else
                            {
                                lab.text = videoCantPlayTip;
                            }
                            lab.font = FONT(17);
                            lab.textAlignment = NSTextAlignmentCenter;
                            lab.textColor = [UIColor whiteColor];
                            [self.view addSubview:lab];
                            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                            CGSize size=[lab.text sizeWithAttributes:attrs];
                            lab.frame = CGRectMake((SCREEN_HEIGHT - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                            
                            //创建通知
                            NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                            
                        }
                    }
                        break;
                    case UIDeviceOrientationLandscapeLeft: {      // Device oriented horizontally, home button on the right
                        NSLog(@"home键在 右");
                        [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                        
                        if ( !lab) {
                            lab = [[UILabel alloc]init];
                            
                            NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                            if (videoOrRadiostr != NULL) {
                                if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                                    lab.text = deliveryStopTip;   //如果不为空,则显示
                                }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = mediaDisConnect;
                                }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = ResourcesFull;
                                }
                                else
                                {
                                    lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                                }
                            }else
                            {
                                lab.text = videoCantPlayTip;
                            }
                            lab.font = FONT(17);
                            lab.textAlignment = NSTextAlignmentCenter;
                            lab.textColor = [UIColor whiteColor];
                            [self.view addSubview:lab];
                            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                            CGSize size=[lab.text sizeWithAttributes:attrs];
                            
                            lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                            
                            
                            //创建通知
                            NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                        }
                    }
                        break;
                    case UIDeviceOrientationLandscapeRight: {     // Device oriented horizontally, home button on the left
                        NSLog(@"home键在 左");
                        //                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeRight];
                        [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                        
                        if ( !lab) {
                            lab = [[UILabel alloc]init];
                            
                            NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                            if (videoOrRadiostr != NULL) {
                                if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                                    lab.text = deliveryStopTip;   //如果不为空,则显示
                                }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = mediaDisConnect;
                                }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                                {
                                    lab.numberOfLines = 0;
                                    lab.text = ResourcesFull;
                                }else
                                {
                                    lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                                }
                            }else
                            {
                                lab.text = videoCantPlayTip;
                            }
                            lab.font = FONT(17);
                            lab.textAlignment = NSTextAlignmentCenter;
                            lab.textColor = [UIColor whiteColor];
                            [self.view addSubview:lab];
                            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                            CGSize size=[lab.text sizeWithAttributes:attrs];
                            lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                            
                            //创建通知
                            NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                            //通过通知中心发送通知
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                            
                        }
                    }
                        break;
                        
                    default: // 还有一种情况是界面朝上或者界面朝下
                    {
                        NSLog(@"width %f",self.view.frame.size.width);
                        NSLog(@"height %f",self.view.frame.size.height);
                        if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 420) //证明此时是竖屏状态
                        {           // Device oriented vertically, home button on the bottom
                            NSLog(@"home键在 下");
                            [self restoreOriginalScreen];
                            
                            if ( !lab) {
                                lab = [[UILabel alloc]init];
                                NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                                if (videoOrRadiostr != NULL) {
                                    if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                                        lab.text = deliveryStopTip;   //如果不为空,则显示
                                    }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                                    {
                                        lab.numberOfLines = 0;
                                        lab.text = mediaDisConnect;
                                    }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                                    {
                                        lab.numberOfLines = 0;
                                        lab.text = ResourcesFull;
                                    }else
                                    {
                                        lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                                    }
                                }else
                                {
                                    lab.text = videoCantPlayTip;
                                }
                                
                                
                                lab.font = FONT(17);
                                lab.textAlignment = NSTextAlignmentCenter;
                                lab.textColor = [UIColor whiteColor];
                                [self.view addSubview:lab];
                                NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                                CGSize size=[lab.text sizeWithAttributes:attrs];
                                lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                                
                                //创建通知
                                NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                                //通过通知中心发送通知
                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                                
                            }
                        }else //证明此时是横屏状态
                        {      // Device oriented horizontally, home button on the right
                            NSLog(@"home键在 右");
                            [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                            
                            if ( !lab) {
                                lab = [[UILabel alloc]init];
                                
                                NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                                if (videoOrRadiostr != NULL) {
                                    if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                                        lab.text = deliveryStopTip;   //如果不为空,则显示
                                    }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                                    {
                                        lab.numberOfLines = 0;
                                        lab.text = mediaDisConnect;
                                    }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                                    {
                                        lab.numberOfLines = 0;
                                        lab.text = ResourcesFull;
                                    }else
                                    {
                                        lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                                    }
                                }else
                                {
                                    lab.text = videoCantPlayTip;
                                }
                                lab.font = FONT(17);
                                lab.textAlignment = NSTextAlignmentCenter;
                                lab.textColor = [UIColor whiteColor];
                                [self.view addSubview:lab];
                                NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                                CGSize size=[lab.text sizeWithAttributes:attrs];
                                lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                                
                                
                                //创建通知
                                NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                                //通过通知中心发送通知
                                [[NSNotificationCenter defaultCenter] postNotification:notification];
                            }
                        }
                        
                        
                        
                        
                    }
                        break;
                }
                
                if (lab) {
                    NSString * videoOrRadiostr = [USER_DEFAULT objectForKey:@"videoOrRadioTip"];
                    if (playStateType != NULL && [playStateType isEqualToString:deliveryStopTip] ) {
                        lab.text = deliveryStopTip;   //如果不为空,则显示
                    }else if (playStateType != NULL && [playStateType isEqualToString:mediaDisConnect] )
                    {
                        lab.numberOfLines = 0;
                        lab.text = mediaDisConnect;
                    }else if (playStateType != NULL && [playStateType isEqualToString:ResourcesFull] )
                    {
                        lab.numberOfLines = 0;
                        lab.textAlignment = NSTextAlignmentCenter;
                        lab.text = ResourcesFull;
                    }else
                    {
                        lab.text = videoOrRadiostr;   //如果不为空,则显示@"videoOrRadioTip" 的文字，否则总是展示Video不能播放
                    }
                    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
                    
                    if ([UIScreen mainScreen].bounds.size.width <  [UIScreen mainScreen].bounds.size.height && [UIScreen mainScreen].bounds.size.height > 420) {
                        CGSize size=[lab.text sizeWithAttributes:attrs];
                        lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                    }else
                    {
                        CGSize size=[lab.text sizeWithAttributes:attrs];
                        lab.frame = CGRectMake((SCREEN_HEIGHT - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
                    }
                    
                }
            }
            
        }
        
        
        
        
    });

}
-(void)reConnectSocketFromDisConnectNotic
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reConnectSocketFromDisConnect" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reConnectSocketFromDisConnect) name:@"reConnectSocketFromDisConnect" object:nil];
}
-(void)reConnectSocketFromDisConnect // 断开连接后重新连接
{
    NSNotification *notification1 =[NSNotification notificationWithName:@"noPlayShowShutNotic" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    
    NSNotification *notification =[NSNotification notificationWithName:@"IndicatorViewShowNotic" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
//    [self.view insertSubview:self.player.view atIndex:0];
//    [self.player stop];
//    [self.player prepareToPlay:0];
//    [self.player play];
    
    
//    [self.player shutdown];
//    [self.player.view removeFromSuperview];
//    self.player = nil;
//    [self.player stop];
//
//
//    NSLog(@"self.View %@",self.view);
//
//
//    self.player =  [[IJKFFMoviePlayerController alloc]initWithContentURL:tempUrl withOptions:nil playView:nil];
//
//    NSLog(@"self.playerView %@",self.player);
//    self.player.view.frame = self.view.bounds;
//
//    [self.view insertSubview:self.player.view atIndex:0];
//
//    if ([[USER_DEFAULT objectForKey:@"showTVView"] isEqualToString:@"YES"]) {
//        [self.player prepareToPlay:0];
//        [self.player play];
//        //            [self.player play];
//        //            [self.player play];
//        //            [self.player play];
//    }else
//    {
//        [self.player shutdown];
//        [self.player.view removeFromSuperview];
//        self.player = nil;
//    }
    

    
    
    
        audioRow = 0;
        subtRow = 0;
        NSLog(@"shang 上一个节目");
        
        NSMutableArray *  historyArr  = [[NSMutableArray alloc]init];
        historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];
        
        NSArray * touchArr = historyArr[historyArr.count - 1];
        NSLog(@"touchArr：%@",touchArr);
        //    [self touchToSee :touchArr];
        
        
        NSInteger row = [touchArr[2] intValue];
        NSDictionary * dic = touchArr [3];
        
//        if (row >= 1) {
            self.videoControl.lastChannelButton.enabled = YES;
            self.videoControl.nextChannelButton.enabled = YES;
            NSNumber * numIndex = [NSNumber numberWithInt:row];
            //添加 字典，将label的值通过key值设置传递
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
            
            
            //这里需要进行一次判断，看是不是需要弹出机顶盒加锁密码框
            NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
            
            NSString * characterStr = [epgDicToSocket objectForKey:@"service_character"]; //新加了一个service_character
            
            
            if (characterStr != NULL && characterStr != nil) {
                
                BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
                if (judgeIsSTBDecrypt == YES) {
                    // 此处代表需要记性机顶盒加密验证
                    //弹窗
                    //发送通知
                    
                    //        [self popSTBAlertView];
                    //        [self popCAAlertView];
                    NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"otherTouch",@"textThree",nil];
                    //创建通知
                    NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification1];
                    //                [self.tabBarController setSelectedIndex:1];
                    
                }else //正常播放的步骤
                {
                    //创建通知
                    NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    //                [self.tabBarController setSelectedIndex:1];
                }
    
            }else //正常播放的步骤
            {
      
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
    
}
@end
