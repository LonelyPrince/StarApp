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
@property (nonatomic, strong) UILabel * lab ;

@property (nonatomic, strong) NSTimer * timerOfEventTime;

@end

@implementation ZXVideoPlayerController

@synthesize socketView1;
@synthesize lab;
@synthesize timerOfEventTime;
//@synthesize tvViewController;
#pragma mark - life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.view.frame = frame;
                self.view.backgroundColor = [UIColor blackColor];
//        self.view.backgroundColor = [UIColor redColor];
//        tvViewController = [[TVViewController alloc]init];
        self.controlStyle = MPMovieControlStyleNone;
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
        [self configIndicatorViewHidden]; //开始播放或者几秒后仍未播放则取消加载进度圈，改为sorry提示字
        
        [self configLabNoPlayShowShut]; //如果视频无法播放，则显示sorry，this video cant play 的字样
        
        self.rightViewShowing = NO;
        //        self.tvViewControlller = [[TVViewController alloc]init];
        self.socketView1 = [[SocketView alloc]init];
        HorTime =0;
        
        [self configTimerOfEventTimeNotific]; //timerOfEventTime
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
    [self monitorVideoPlayback];
}

/// 开始播放时根据视频文件长度设置slider最值
- (void)setProgressSliderMaxMinValues
{
    CGFloat duration = self.duration;
    self.videoControl.progressSlider.minimumValue = 0.f;
    self.videoControl.progressSlider.maximumValue = floor(duration);
}

/// 监听播放进度
- (void)monitorVideoPlayback
{
    double currentTime = floor(self.currentPlaybackTime);
    double totalTime = floor(self.duration);
    // 更新时间
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    // 更新播放进度
    self.videoControl.progressSlider.value = ceil(currentTime);
    // 更新缓冲进度
    self.videoControl.bufferProgressView.progress = self.playableDuration / self.duration;
    
    //    if (self.duration == self.playableDuration && self.playableDuration != 0.0) {
    //        NSLog(@"缓冲完成");
    //    }
    //    int percentage = self.playableDuration / self.duration * 100;
    //    NSLog(@"缓冲进度: %d%%", percentage);
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
    if (self.durationTimer) {
        [self.durationTimer setFireDate:[NSDate date]];
    } else {
        self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSRunLoopCommonModes];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackStateDidChangeNotification) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    // 媒体网络加载状态改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    // 视频显示状态改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerReadyForDisplayDidChangeNotification) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
    
    // 确定了媒体播放时长后
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMovieDurationAvailableNotification) name:MPMovieDurationAvailableNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPayerControlViewHideNotification) name:kZXPlayerControlViewHideNotification object:nil];
}

/// 播放状态改变, 可配合playbakcState属性获取具体状态
- (void)onMPMoviePlayerPlaybackStateDidChangeNotification
{
    NSLog(@"MPMoviePlayer  PlaybackStateDidChange  Notification");
    NSLog(@"MPMoviePlayer  播放状态改变");
    
    if (self.playbackState == MPMoviePlaybackStatePlaying) {
        NSLog(@"视频正在播放");
        NSLog(@"准备开始播放");
        NSLog(@"MPMoviePlayer  正在播放");
        self.videoControl.pauseButton.hidden = NO;
        self.videoControl.playButton.hidden = YES;
        [self startDurationTimer];
        
        [self.videoControl.indicatorView stopAnimating];
        [self.videoControl autoFadeOutControlBar];
    } else {
        [self play];
        NSLog(@"视频正在播放停止");
        self.videoControl.pauseButton.hidden = YES;
        self.videoControl.playButton.hidden = NO;
        [self stopDurationTimer];
        if (self.playbackState == MPMoviePlaybackStateStopped) {
            [self.videoControl animateShow];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quality) name:@"" object:nil];
}

/// 媒体网络加载状态改变
- (void)onMPMoviePlayerLoadStateDidChangeNotification
{
    NSLog(@"MPMoviePlayer  LoadStateDidChange  Notification");
    NSLog(@"MPMoviePlayer  加载");
    
    if (self.loadState & MPMovieLoadStateStalled) {
         NSLog(@"准备开始加载");
        NSLog(@"MPMoviePlayer  开始加载");
        [self.videoControl.indicatorView startAnimating];
        
//        //创建通知
//        NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    else
    {
        NSLog(@"MPMoviePlayer  停止加载");
        [self.videoControl.indicatorView stopAnimating];
    }
}

/// 视频显示状态改变
- (void)onMPMoviePlayerReadyForDisplayDidChangeNotification
{
    NSLog(@"MPMoviePlayer  ReadyForDisplayDidChange  Notification");
    NSLog(@"MPMoviePlayer  视频显示状态改变");
}

/// 确定了媒体播放时长
- (void)onMPMovieDurationAvailableNotification
{
    NSLog(@"MPMovie  DurationAvailable  Notification");
    [self startDurationTimer];
    [self setProgressSliderMaxMinValues];
    
    self.videoControl.fullScreenButton.hidden = NO;
//    self.videoControl.shrinkScreenButton.hidden = YES;
    self.videoControl.shrinkScreenButton1.hidden = YES;
    self.videoControl.lastChannelButton.hidden = YES;
    self.videoControl.nextChannelButton.hidden = YES;
    self.videoControl.subtBtn.hidden = YES;
    self.videoControl.audioBtn.hidden = YES;
    self.videoControl.channelListBtn.hidden = YES;
    self.videoControl.eventTimeLab.hidden = YES;
    
    
    //    self.videoControl.backButton.hidden = YES;
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
                self.panDirection = ZXPanDirectionHorizontal;
                self.sumTime = self.currentPlaybackTime; // sumTime初值
                [self pause];
                [self stopDurationTimer];
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
                    [self horizontalMoved:veloctyPoint.x];
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
                    [self setCurrentPlaybackTime:floor(self.sumTime)];
                    [self play];
                    [self startDurationTimer];
                    [self.videoControl autoFadeOutControlBar];
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
    
    // 容错处理
    if (self.sumTime > self.duration) {
        self.sumTime = self.duration;
    } else if (self.sumTime < 0) {
        self.sumTime = 0;
    }
    
    // 时间更新
    double currentTime = self.sumTime;
    double totalTime = self.duration;
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    // 提示视图
    self.videoControl.timeIndicatorView.labelText = self.videoControl.timeLabel.text;
    // 播放进度更新
    self.videoControl.progressSlider.value = self.sumTime;
    
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
}
//未播放前显示加载圈
-(void)configIndicatorView
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IndicatorViewShowNotic" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IndicatorViewShowNotic) name:@"IndicatorViewShowNotic" object:nil];
}
-(void)IndicatorViewShowNotic
{
    [self.videoControl.indicatorView startAnimating];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
//如果不能播放，则显示不能播放字样
-(void)configLabNoPlayShow
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noPlayShowNotic" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noPlayShowNotic) name:@"noPlayShowNotic" object:nil];
}
//播放活加载状态，不显示播放字样
-(void)configLabNoPlayShowShut
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"noPlayShowShutNotic" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noPlayShowShutNotic) name:@"noPlayShowShutNotic" object:nil];
}
-(void)noPlayShowNotic
{
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    NSLog(@"右侧列表消失 noPlayShowNotic");
    self.subAudioTableView.hidden = YES;
    self.subAudioTableView = nil;
    [self.subAudioTableView removeFromSuperview];
    self.subAudioTableView = NULL;
    self.subAudioTableView.alpha = 0;
    UIDeviceOrientation orientation = self.getDeviceOrientation;
    
    if (!self.isLocked)
    {
        switch (orientation) {
            case UIDeviceOrientationPortrait: {           // Device oriented vertically, home button on the bottom
                NSLog(@"home键在 下");
                [self restoreOriginalScreen];
                
                if ( !lab) {
                    lab = [[UILabel alloc]init];
                    
                    lab.text = @"sorry, this video can't play";
                    lab.font = FONT(17);
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
                    
                    lab.text = @"sorry, this video can't play";
                    lab.font = FONT(17);
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
                    
                    lab.text = @"sorry, this video can't play";
                    lab.font = FONT(17);
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
            case UIDeviceOrientationLandscapeRight: {     // Device oriented horizontally, home button on the left
                NSLog(@"home键在 左");
                //                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeRight];
                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
                
                if ( !lab) {
                    lab = [[UILabel alloc]init];
                    
                    lab.text = @"sorry, this video can't play";
                    lab.font = FONT(17);
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
                
            default:
                break;
        }
    }
    
    
    
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
            [self play];
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
                NSLog(@"此时 orientation : %d",orientationBHor);
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

/// 切换到全屏模式
- (void)changeToFullScreenForOrientation:(UIDeviceOrientation)orientation
{
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
    
    self.frame = [UIScreen mainScreen].bounds;
    //    self.videoControl.bottomBar.userInteractionEnabled = YES;
    self.isFullscreenMode = YES;
    self.videoControl.fullScreenButton.hidden = YES;
//    self.videoControl.shrinkScreenButton.hidden = NO;
    self.videoControl.shrinkScreenButton1.hidden = NO;
    self.videoControl.lastChannelButton.hidden = NO;
    self.videoControl.nextChannelButton.hidden = NO;
    self.videoControl.subtBtn.hidden = NO;
    self.videoControl.audioBtn.hidden = NO;
    self.videoControl.channelListBtn.hidden = NO;
    self.videoControl.eventTimeLab.hidden = NO;
    self.videoControl.backButton.hidden = NO;
    
    self.videoControl.lockButton.hidden = NO; //切换到竖屏模式，锁屏按钮出现
    [USER_DEFAULT setBool:YES forKey:@"isFullScreenMode"];
    
    lab.text = @"sorry, this video can't play";
    lab.font = FONT(17);
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
    CGSize size=[lab.text sizeWithAttributes:attrs];
    lab.frame = CGRectMake((SCREEN_HEIGHT - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
    
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
//    }
  

    
    
//    CGSize sizeEventName = [self sizeWithText:self.videoControl.FulleventNameLab.text font:[UIFont systemFontOfSize:11] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
   
//    //初始化arr，方便后面对label赋值
//    if (! YFLabelArr) {
//        self.videoControl.FullEventYFlabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake(self.videoControl.channelNameLab.frame.origin.x, 30+22, sizeEventName.width, 18)  textArray:YFLabelArr font:[UIFont systemFontOfSize:11] textColor:[UIColor whiteColor]];
//        
//        
//        [self.videoControl.FullEventYFlabel initArr:YFLabelArr];
//        
//    }else
//    {
//        self.videoControl.FullEventYFlabel.frame = CGRectMake(self.videoControl.channelNameLab.frame.origin.x, 30+22, 250, 18);   //40字符长度是260
//        [self.videoControl.FullEventYFlabel initArr:YFLabelArr];
//        
//
//    }
    
    
    
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
    
    //test
    //此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"abctest" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector( abctest) name:@"abctest" object:nil];
    

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
    
    
//    [self FullEventYFlabel];
//    self.FullEventYFlabel.frame = CGRectMake(80, 30+26, 100, 18);
//    [self.FullEventYFlabel initArr:@[@"asdasdasdasdasdasdasdasdasdasdasdasdasd"]];
//    self.FullEventYFlabel.hidden = NO;
//    self.FullEventYFlabel.speed = 20;
//    [self addSubview:_FullEventYFlabel];
//    [self.topBar addSubview:_FullEventYFlabel];

}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
/// 切换到竖屏模式
- (void)restoreOriginalScreen
{
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
    self.videoControl.fullScreenButton.hidden = NO;
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
    self.videoControl.nextChannelButton.hidden = YES;
    self.videoControl.subtBtn.hidden = YES;
    self.videoControl.audioBtn.hidden = YES;
    self.videoControl.channelListBtn.hidden = YES;
    self.videoControl.eventTimeLab.hidden = YES;
    self.videoControl.eventnameLabel.hidden = NO;
    
    self.videoControl.lockButton.hidden = YES; //切换到竖屏模式，锁屏按钮消失
    [USER_DEFAULT setBool:NO forKey:@"isFullScreenMode"];
    
    lab.text = @"sorry, this video can't play";
    lab.font = FONT(17);

    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
    CGSize size=[lab.text sizeWithAttributes:attrs];
    lab.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.view.frame.size.height - size.height )/2, size.width, size.height);
    
    
    self.videoControl.channelIdLab.frame = CGRectMake(20, 10, 25, 18);
    self.videoControl.channelNameLab.frame = CGRectMake(56, 10, 120+50, 18);
    self.videoControl.channelIdLab.font =[UIFont systemFontOfSize:12];
    self.videoControl.channelNameLab.font =[UIFont systemFontOfSize:12];

    //切换到竖屏，跑马灯消失
    if (self.videoControl.FullEventYFlabel) {
        [self.videoControl.FullEventYFlabel removeFromSuperview];
        self.videoControl.FullEventYFlabel = nil;
        [self.videoControl.FullEventYFlabel stopTimer];
    }
   

    
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
        
    }
}

#pragma mark -
#pragma mark - Action Code

////
///上一个节目
- (void)lastChannelButtonClick
{
    NSLog(@"shang 上一个节目");
    
    NSMutableArray *  historyArr  = [[NSMutableArray alloc]init];
    historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];
    
    NSArray * touchArr = historyArr[historyArr.count - 1];
    NSLog(@"touchArr：%@",touchArr);
    //    [self touchToSee :touchArr];
    
    
    NSInteger row = [touchArr[2] intValue];
    NSDictionary * dic = touchArr [3];
    
    if (row >= 1) {
        NSNumber * numIndex = [NSNumber numberWithInt:(row -1)];
        //添加 字典，将label的值通过key值设置传递
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
   
    }else
    {
        NSLog(@"对不起，已经没有上一个节目了");
    }
//    NSNumber * numIndex = [NSNumber numberWithInt:(row -1)];
    
//    //添加 字典，将label的值通过key值设置传递
//    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
- (void)nextChannelButtonClick
{
    NSLog(@"下一个节目");
    NSMutableArray *  historyArr  = [[NSMutableArray alloc]init];
    historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];
    
    NSLog(@"historyArr.count：%d",historyArr.count);
    NSArray * touchArr = historyArr[historyArr.count - 1];
    NSLog(@"touchArr：%@",touchArr);
    //    [self touchToSee :touchArr];
    
    
    NSInteger row = [touchArr[2] intValue];
    NSDictionary * dic = touchArr [3];
    NSLog(@"dic :%@",dic);
    NSLog(@"dic。count :%lu",(unsigned long)dic.count);
    NSLog(@"row1 :%ld",(long)row);
    int dic_Count = dic.count -1;
    if (row < dic_Count) {
        NSLog(@"row2 :%ld",(long)row);
        NSInteger tempInt = row+1;
        NSLog(@"row3 :%ld",(long)row);
        NSNumber * numIndex = [NSNumber numberWithInteger:tempInt];
        //添加 字典，将label的值通过key值设置传递
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    }else
    {
        NSLog(@"对不起，已经没有下一个节目了");
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
}
-(void)rightViewshow
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"lockButtonHide" object:nil];
    self.videoControl.rightView.hidden = NO;
    self.videoControl.rightView.alpha = 1;
    
    self.subAudioTableView.hidden = NO;
    self.subAudioTableView.alpha = 1;
    
    self.rightViewShowing = YES;
    
    self.videoControl.topBar.alpha = 0;
    self.videoControl.bottomBar.alpha = 0;
    
    
    
    self.subAudioDic = [[NSMutableDictionary alloc]init];
    self.subAudioDic = self.video.dicSubAudio;
    
    self.channelDic= [[NSMutableDictionary alloc]init];
    self.channelDic = self.video.dicChannl;
    
    
    //////tableview
    if(!self.subAudioTableView)
    {
    self.subAudioTableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)-145, 0, 145, CGRectGetHeight(self.videoControl.rightView.bounds)) style:UITableViewStylePlain];
    }
    
    self.subAudioTableView.delegate = self;
    self.subAudioTableView.dataSource = self;
    UIImageView *imageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"渐变"]];
    self.subAudioTableView.backgroundColor = [UIColor clearColor];
    [self.subAudioTableView setBackgroundView:imageView1];
    self.subAudioTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector( rightViewHidden) name:@"tableviewHidden" object:nil];
    
    
    
    
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
    
}



/// 返回按钮点击
- (void)backButtonClick
{
    if (!self.isFullscreenMode) { // 如果是竖屏模式，返回关闭
        if (self) {
            [self.durationTimer invalidate];
            [self stop];
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
    [self play];
    self.videoControl.playButton.hidden = YES;
    self.videoControl.pauseButton.hidden = NO;
}

/// 暂停按钮点击
- (void)pauseButtonClick
{
    [self pause];
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
- (void)progressSliderTouchBegan:(UISlider *)slider
{
    [self pause];
    [self stopDurationTimer];
    [self.videoControl cancelAutoFadeOutControlBar];
}

/// slider 松开事件
- (void)progressSliderTouchEnded:(UISlider *)slider
{
    [self setCurrentPlaybackTime:floor(slider.value)];
    [self play];
    
    [self startDurationTimer];
    [self.videoControl autoFadeOutControlBar];
}

/// slider value changed
- (void)progressSliderValueChanged:(UISlider *)slider
{
    double currentTime = floor(slider.value);
    double totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}

#pragma mark -
#pragma mark - getters and setters

- (void)setContentURL:(NSURL *)contentURL
{
    [self stop];
    [super setContentURL:contentURL];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(crclePlayUrl) userInfo:nil repeats:YES];
    
    [self play];

    //    self.useApplicationAudioSession = NO;
    
    
}
-(void)crclePlayUrl
{
    [self play];
//    NSLog(@"循环播放");
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

- (void)setVideo:(ZXVideo *)video
{
    _video = video;
    
    // 标题
    self.videoControl.titleLabel.text = self.video.title;
    // play url
    self.contentURL = [NSURL URLWithString:self.video.playUrl];
    //当前节目名称
    self.videoControl.eventnameLabel.text = self.video.playEventName;
//    self.videoControl.eventnameLabel.text = @"1234567890123456789012345678901234567890|1234567890123456789012345678901234567890|1234567890123456789012345678901234567890|1234567890123456789012345678901234567890|1234567890123456789012345678901234567890|1234567890123456789012345678901234567890|1234567890123456789012345678901234567890";
//     self.videoControl.eventnameLabel.text = @"1234567890123456789012345678901234567890";
    
    self.videoControl.channelIdLab.text = self.video.channelId;
    
    self.videoControl.channelNameLab.text = self.video.channelName;
    
    
    //    self.subAudioDic = [[NSMutableDictionary alloc]init];
    //    self.subAudioDic = self.video.dicSubAudio;
    //    NSLog(@"self.video.dicSubAudio:%@",self.video.dicSubAudio);
    //    NSLog(@"self.video.dicSubAudio:%@",self.subAudioDic);
    //self.video.dicSubAudio;
  timerOfEventTime =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setEventTime) userInfo:nil repeats:YES];  //时间变化的计时器
    
    
}

-(void)setEventTime
{
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
    }
    if (bb1 <0) {
        bb1 = 0;
    }
    
    NSString * nowTime = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%d",bb1]];
    
    self.videoControl.eventTimeLab.text = [NSString stringWithFormat:@"%@ | %@",nowTime,aa];
}
-(void)configTimerOfEventTimeNotific
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TimerOfEventTimeNotific" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TimerOfEventTimeNotific) name:@"TimerOfEventTimeNotific" object:nil];
}

-(void)TimerOfEventTimeNotific
{
    
    [timerOfEventTime invalidate];
    timerOfEventTime = nil;
    timerOfEventTime =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setEventTime1) userInfo:nil repeats:YES];

}
-(void)setEventTime1
{
    int  EPGArrindex = 0; //先随便初始化一下
    NSString * tempIndexStr;
    NSArray * arr = [USER_DEFAULT objectForKey:@"NowChannelEPG"];
    tempIndexStr =[USER_DEFAULT objectForKey:@"nowChannelEPGArrIndex"];
    EPGArrindex = [tempIndexStr intValue];
    NSLog(@"EPGArrindex lal :%d",EPGArrindex);
    NSLog(@"arr lal :%@",arr);
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
            
            float aa1 = [self.video.endTime intValue]  - [self.video.startTime intValue];
            NSString * aa = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%f",aa1]];
            
            
            int bb1 ;
            
            //如果时间为0 ,或者没有获取到时间，则显示为0
            if ([self.video.startTime intValue] == nil || [self.video.startTime intValue] == NULL || [self.video.startTime intValue] == 0) {
                bb1 = 0;
            } else
            {
                NSLog(@"self.video.startTime lalala :%@",self.video.startTime);
                bb1 = [[GGUtil GetNowTimeString] intValue]  - [self.video.startTime intValue];
            }
            if (bb1 < 0) {
                bb1 = 0;
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
            NSLog(@"bb1 bb1 :%d",bb1);
            
            NSString * nowTime = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%d",bb1]];
            
            if([nowTime intValue] >= [aa intValue] )
            {
                NSLog(@"出错了，节目的当前时间不能大于结束时间");
                NSNotification *notification =[NSNotification notificationWithName:@"removeProgressNotific" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
            }
            else{
                NSLog(@"nowTime nowTime :%@",nowTime);
                self.videoControl.eventTimeLab.text = [NSString stringWithFormat:@"%@ | %@",nowTime,aa];
            }
            
        }

    }
    
    
    
   
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



/////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([_cellStr isEqualToString:@"subt"]) {
        NSArray * subtarr =[self.subAudioDic  objectForKey:@"subt_info"];
        if (subtarr.count <=8) {
            self.subAudioTableView.frame = CGRectMake(CGRectGetWidth(self.view.bounds)-145,( SCREEN_WIDTH-subtarr.count*45)/2, 145,subtarr.count*46);
        }else
        {
            self.subAudioTableView.frame  =  CGRectMake(CGRectGetWidth(self.view.bounds)-145, 0, 145, CGRectGetHeight(self.videoControl.rightView.bounds));
        }

        return subtarr.count;
        //        return 8;
    }
    else if ([_cellStr isEqualToString:@"audio"]) {
        NSArray * audioarr =[self.subAudioDic  objectForKey:@"audio_info"];
        NSLog(@"audioarr--:%@",audioarr);
        if (audioarr.count <=8) {
            self.subAudioTableView.frame = CGRectMake(CGRectGetWidth(self.view.bounds)-145,( SCREEN_WIDTH-audioarr.count*45)/2, 145,audioarr.count*46);
        }else
        {
                self.subAudioTableView.frame  =  CGRectMake(CGRectGetWidth(self.view.bounds)-145, 0, 145, CGRectGetHeight(self.videoControl.rightView.bounds));
            
        }

        return audioarr.count;
        
    }
    else if ([_cellStr isEqualToString:@"channel"]) {
        
        NSLog(@"self.video.channelCount :%d",self.video.channelCount);
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
            
            [cell.languageLab setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
          

            
        }
        
        
        
        if (!ISEMPTY(self.video.dicSubAudio)) {
            //        cell.dataDic
            NSArray * subAudioArr = [[NSArray alloc]init];
            
            subAudioArr  =[self.subAudioDic  objectForKey:@"subt_info"];
            
            cell.dataDic = subAudioArr[indexPath.row];
            
            
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
            
            [cell.languageLab setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];

            

        }
        
        
        
        if (!ISEMPTY(self.video.dicSubAudio)) {
            
            NSArray * audioArr = [[NSArray alloc]init];
            
            audioArr  =[self.subAudioDic  objectForKey:@"audio_info"];
            
            NSLog(@"audioArr :%@",audioArr);
            NSLog(@"audioArr.count :%lu",(unsigned long)audioArr.count);
            
            cell.dataDic = audioArr[indexPath.row];
            
            
            //上下两个都可以试一下
            //        cell.dataDic =self.subAudioDic;
        }else{//如果为空，什么都不执行
        }
        
        //        NSLog(@"cell.dataDic:%@",cell.dataDic);
        
        return cell;
    }
    
    else if ([_cellStr isEqualToString:@"channel"]) {
        ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell"];
        if (cell == nil){
            cell = [ChannelCell loadFromNib];
            cell.channelId.textAlignment = UITextAlignmentCenter;
            cell.channelName.textAlignment = UITextAlignmentCenter;
            
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
            //            cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
            
            //            cell.selectedBackgroundView.backgroundColor=[UIColor  clearColor];
            
            //            cell.backgroundView = viewClick;
            
            [cell.channelId setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
            [cell.channelName setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
            
            
        }
        
        
        
        if (!ISEMPTY(self.video.dicChannl)) {
            
            cell.dataDic = [self.video.dicChannl objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
            NSLog(@"self.video.dicChannl %@",self.video.dicChannl);
            NSLog(@"cell.dataDic %@",cell.dataDic);
            
            
            //焦点
            NSDictionary * fourceDic = [USER_DEFAULT objectForKey:@"NowChannelDic"];  //这里还用作判断播放的焦点展示
            NSLog(@"cell.dataDic 11:%@",cell.dataDic);
            NSLog(@"cell.dataDic fourceDic: %@",fourceDic);
            if ([cell.dataDic isEqualToDictionary:fourceDic]) {
                
                [cell.channelId setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
                [cell.channelName setTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
                
            }else
            {
                [cell.channelId setTextColor:[UIColor whiteColor]];
                [cell.channelName setTextColor:[UIColor whiteColor]];
                
            }
            
            
        }else{//如果为空，什么都不执行
        }
        
        //        NSLog(@"cell.dataDic:%@",cell.dataDic);
        
        return cell;
    }
    
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_cellStr isEqualToString:@"subt"]) {
        
        NSDictionary * dic ;
        if (!ISEMPTY(self.video.dicChannl)) {
            NSString * channelName = self.videoControl.channelNameLab.text;
            NSDictionary * dicChannelName  = self.video.dicChannl;
            for (int i = 0; i<self.video.channelCount; i++) {
                NSString * nameTemp = [[self.video.dicChannl objectForKey:[NSString stringWithFormat:@"%d",i ]] objectForKey:@"service_name"];
                NSLog(@"nameTemp :%@",nameTemp);
                NSLog(@"channelName :%@",channelName);
                if ([nameTemp isEqualToString:channelName]) {
                    NSLog(@"self.video.dicChannl :%@",self.video.dicChannl);
                    NSLog(@"i :%d",i);
                    dic = [self.video.dicChannl objectForKey:[NSString stringWithFormat:@"%d",i]];
                    break;
                }
            }
            //            NSDictionary * didName  = [self.video.dicChannl objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            //            self.video.channelCount
            
            
            //            [self.tvViewControlller  touchSelectChannel:indexPath.row diction:self.video.dicChannl];
            //            NSNumber * subtNum = [NSNumber numberWithInteger:0];
            //            NSNumber * audioNum = [NSNumber numberWithInteger:indexPath.row];
            [self touchToSeeAudioSubt :dic DicWithRow:indexPath.row  audio:0 subt:indexPath.row];
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView.separatorColor = [UIColor whiteColor];
            
        }else{//如果为空，什么都不执行
        }
        //        [self.socketView1  serviceTouch ];
        
    }
    else if ([_cellStr isEqualToString:@"audio"]) {
      
        NSDictionary * dic ;
        if (!ISEMPTY(self.video.dicChannl)) {
            NSString * channelName = self.videoControl.channelNameLab.text;
            NSDictionary * dicChannelName  = self.video.dicChannl;
            for (int i = 0; i<self.video.channelCount; i++) {
                NSString * nameTemp = [[self.video.dicChannl objectForKey:[NSString stringWithFormat:@"%d",i ]] objectForKey:@"service_name"];
                NSLog(@"nameTemp :%@",nameTemp);
                NSLog(@"channelName :%@",channelName);
                if ([nameTemp isEqualToString:channelName]) {
                    NSLog(@"self.video.dicChannl :%@",self.video.dicChannl);
                    NSLog(@"i :%d",i);
                    dic = [self.video.dicChannl objectForKey:[NSString stringWithFormat:@"%d",i]];
                    break;
                }
            }
//            NSDictionary * didName  = [self.video.dicChannl objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//            self.video.channelCount
            
          
            //            [self.tvViewControlller  touchSelectChannel:indexPath.row diction:self.video.dicChannl];
//            NSNumber * subtNum = [NSNumber numberWithInteger:0];
//            NSNumber * audioNum = [NSNumber numberWithInteger:indexPath.row];
            [self touchToSeeAudioSubt :dic DicWithRow:indexPath.row  audio:indexPath.row subt:0];
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView.separatorColor = [UIColor whiteColor];
            
            
            
        }else{//如果为空，什么都不执行
        }
        //        [self.socketView1  serviceTouch ];
        
    }
    else if ([_cellStr isEqualToString:@"channel"]) {
        
        NSDictionary * dic ;
        if (!ISEMPTY(self.video.dicChannl)) {
            
            
            dic = [self.video.dicChannl objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            //            [self.tvViewControlller  touchSelectChannel:indexPath.row diction:self.video.dicChannl];
            [self touchToSee :dic DicWithRow:indexPath.row];
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView.separatorColor = [UIColor whiteColor];
            
            
            
            //先全部变白
            for (NSInteger  i = 0; i<self.video.channelCount; i++) {
                NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:0];
                
                ChannelCell *cell1 = [tableView cellForRowAtIndexPath:indexPath1];
                [cell1.channelId setTextColor:[UIColor whiteColor]];
                [cell1.channelName setTextColor:[UIColor whiteColor]];
            }
            
            
            
            
            //选中的变蓝
            ChannelCell *cell2 = [tableView cellForRowAtIndexPath:indexPath];
            [cell2.channelId setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];
            [cell2.channelName setHighlightedTextColor:RGBA(0x60, 0xa3, 0xec, 1)];

            
            NSDictionary *indexPathdict =[[NSDictionary alloc] initWithObjectsAndKeys:indexPath,@"indexPathDic", nil];
               [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableFocusNotific" object:nil userInfo:indexPathdict];
            
        }else{//如果为空，什么都不执行
        }
        //        [self.socketView1  serviceTouch ];
    }
    
    
    NSLog(@"我被选中了，哈哈哈哈哈哈哈");
    
}
//节目播放点击
-(void)touchToSee :(NSDictionary* )dic DicWithRow:(NSInteger)row
{
    
    //    NSInteger row = [touchArr[2] intValue];
    //    NSDictionary * dic = touchArr [3];
    NSDictionary *dicNow =[[NSDictionary alloc] initWithObjectsAndKeys:dic,[NSString stringWithFormat:@"%ld",(long)row], nil];
    
    //将整形转换为number
    NSNumber * numIndex = [NSNumber numberWithInteger:row];
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dicNow,@"textTwo", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToViewController:_tvViewController animated:YES];
    //    [self.navigationController pushViewController:_tvViewController animated:YES];
    //    [self.tabBarController setSelectedIndex:1];
}

//音轨字幕点击
-(void)touchToSeeAudioSubt :(NSDictionary* )dic DicWithRow:(NSInteger)row audio:(NSInteger)audioIndex subt:(NSInteger)subtIndex
{
    
    //    NSInteger row = [touchArr[2] intValue];
    //    NSDictionary * dic = touchArr [3];
    NSDictionary *dicNow =[[NSDictionary alloc] initWithObjectsAndKeys:dic,[NSString stringWithFormat:@"%ld",(long)row], nil];
    
    NSLog(@"dicNow %@",dicNow);
    //将整形转换为number
    NSNumber * numIndex = [NSNumber numberWithInteger:row];
    
    NSNumber * audioNum = [NSNumber numberWithInteger:audioIndex];
    NSNumber * subtNum = [NSNumber numberWithInteger:subtIndex];
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dicNow,@"textTwo",audioNum,@"textThree",subtNum,@"textFour", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoificAudioSubt" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToViewController:_tvViewController animated:YES];
    //    [self.navigationController pushViewController:_tvViewController animated:YES];
    //    [self.tabBarController setSelectedIndex:1];
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


@end
