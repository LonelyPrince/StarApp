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

/// 播放器视图
@property (nonatomic, strong) ZXVideoPlayerControlView *videoControl;
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

@property (nonatomic, strong) UITableView *subAudioTableView;

//cell的判断条件
@property (nonatomic, strong) NSString * cellStr;

//@property (nonatomic, strong) id * TableScollTimer;
@end

@implementation ZXVideoPlayerController

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
        
        self.rightViewShowing = NO;
        
    }
    return self;
}

#pragma mark -
#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    // UISlider & UIButton & topBar 不需要响应手势
    if([touch.view isKindOfClass:[UISlider class]] || [touch.view isKindOfClass:[UIButton class]] || [touch.view.accessibilityIdentifier isEqualToString:@"TopBar"]) {
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
    [self.videoControl.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
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
    
    if (self.playbackState == MPMoviePlaybackStatePlaying) {
        self.videoControl.pauseButton.hidden = NO;
        self.videoControl.playButton.hidden = YES;
        [self startDurationTimer];
        
        [self.videoControl.indicatorView stopAnimating];
        [self.videoControl autoFadeOutControlBar];
    } else {
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
    
    if (self.loadState & MPMovieLoadStateStalled) {
        [self.videoControl.indicatorView startAnimating];
    }
}

/// 视频显示状态改变
- (void)onMPMoviePlayerReadyForDisplayDidChangeNotification
{
    NSLog(@"MPMoviePlayer  ReadyForDisplayDidChange  Notification");
}

/// 确定了媒体播放时长
- (void)onMPMovieDurationAvailableNotification
{
    NSLog(@"MPMovie  DurationAvailable  Notification");
    [self startDurationTimer];
    [self setProgressSliderMaxMinValues];
    
    self.videoControl.fullScreenButton.hidden = NO;
    self.videoControl.shrinkScreenButton.hidden = YES;
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

/// 设置监听设备旋转通知
- (void)configDeviceOrientationObserver
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationDidChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

/// 设备旋转方向改变
- (void)onDeviceOrientationDidChange
{
    UIDeviceOrientation orientation = self.getDeviceOrientation;
    
    if (!self.isLocked)
    {
        switch (orientation) {
            case UIDeviceOrientationPortrait: {           // Device oriented vertically, home button on the bottom
                NSLog(@"home键在 下");
                [self restoreOriginalScreen];
            }
                break;
            case UIDeviceOrientationPortraitUpsideDown: { // Device oriented vertically, home button on the top
                NSLog(@"home键在 上");
            }
                break;
            case UIDeviceOrientationLandscapeLeft: {      // Device oriented horizontally, home button on the right
                NSLog(@"home键在 右");
                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeLeft];
            }
                break;
            case UIDeviceOrientationLandscapeRight: {     // Device oriented horizontally, home button on the left
                NSLog(@"home键在 左");
                [self changeToFullScreenForOrientation:UIDeviceOrientationLandscapeRight];
            }
                break;
                
            default:
                break;
        }
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
    self.videoControl.bottomBar.userInteractionEnabled = YES;
    self.isFullscreenMode = YES;
    self.videoControl.fullScreenButton.hidden = YES;
    self.videoControl.shrinkScreenButton.hidden = NO;
    self.videoControl.shrinkScreenButton1.hidden = NO;
    self.videoControl.lastChannelButton.hidden = NO;
    self.videoControl.nextChannelButton.hidden = NO;
    self.videoControl.subtBtn.hidden = NO;
    self.videoControl.audioBtn.hidden = NO;
    self.videoControl.channelListBtn.hidden = NO;
    self.videoControl.eventTimeLab.hidden = NO;
    self.videoControl.backButton.hidden = NO;
    
    
//     self.videoControl.channelIdLab.hidden = NO;
//     self.videoControl.channelNameLab.hidden = NO;
     self.videoControl.FulleventNameLab.hidden = NO;
    self.videoControl.eventnameLabel.hidden = YES;
    
    self.videoControl.channelIdLab.font =[UIFont systemFontOfSize:18];
    self.videoControl.channelNameLab.font =[UIFont systemFontOfSize:18];
    self.videoControl.channelIdLab.frame = CGRectMake(48, 10, 55, 18);
    self.videoControl.channelNameLab.frame = CGRectMake(113, 10, 120, 18);
    
    self.videoControl.FulleventNameLab.text = self.videoControl.eventnameLabel.text;
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
    self.videoControl.shrinkScreenButton.hidden = YES;
    self.videoControl.shrinkScreenButton1.hidden = YES;
    self.videoControl.backButton.hidden = YES;
//     self.videoControl.channelIdLab.hidden = YES;
//     self.videoControl.channelNameLab.hidden = YES;
     self.videoControl.FulleventNameLab.hidden = YES;
    
    self.videoControl.lastChannelButton.hidden = YES;
    self.videoControl.nextChannelButton.hidden = YES;
    self.videoControl.subtBtn.hidden = YES;
    self.videoControl.audioBtn.hidden = YES;
    self.videoControl.channelListBtn.hidden = YES;
    self.videoControl.eventTimeLab.hidden = YES;
    self.videoControl.eventnameLabel.hidden = NO;
    
    
    self.videoControl.channelIdLab.frame = CGRectMake(20, 10, 25, 18);
    self.videoControl.channelNameLab.frame = CGRectMake(56, 10, 120, 18);
    self.videoControl.channelIdLab.font =[UIFont systemFontOfSize:12];
    self.videoControl.channelNameLab.font =[UIFont systemFontOfSize:12];
    
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
}
- (void)nextChannelButtonClick
{
    NSLog(@"下一个节目");
}
- (void)subtBtnClick
{
    NSLog(@"sub字幕");
    _cellStr = @"subt";
    if (self.rightViewShowing == YES)
    {
        [self rightViewHidden];
       
     
    }else if(self.rightViewShowing ==NO)
    {
     [self rightViewshow];
    
    }
    
    
}
-(void)rightViewshow
{
    self.videoControl.rightView.hidden = NO;
    self.videoControl.rightView.alpha = 1;
    self.rightViewShowing = YES;
    
    self.videoControl.topBar.alpha = 0;
    self.videoControl.bottomBar.alpha = 0;
    
    //////tableview
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 145, CGRectGetHeight(self.videoControl.rightView.bounds)) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    //    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.videoControl.rightView addSubview:table];
    self.subAudioTableView = table;
    
    self.subAudioDic = [[NSMutableDictionary alloc]init];
    self.subAudioDic = self.video.dicSubAudio;
    
    
    self.channelDic= [[NSMutableDictionary alloc]init];
    self.channelDic = self.video.dicChannl;
    
   
    
}
-(void)rightViewHidden
 { self.videoControl.rightView.hidden = YES;
    self.videoControl.rightView.alpha = 0;
    self.rightViewShowing = NO;
}

- (void)audioBtnClick
{
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

/// 锁屏按钮点击
- (void)lockButtonClick:(UIButton *)lockBtn
{
    lockBtn.selected = !lockBtn.selected;
    
    if (lockBtn.selected) { // 锁定
        self.isLocked = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"ZXVideoPlayer_DidLockScreen"];
    } else { // 解除锁定
        self.isLocked = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
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
}

/// 返回竖屏按钮点击
- (void)shrinkScreenButtonClick
{
    
    
    if (!self.isFullscreenMode) {
        return;
    }
    
    if (self.isLocked) { // 解锁
        [self lockButtonClick:self.videoControl.lockButton];
    }
    
    [self changeToOrientation:UIDeviceOrientationPortrait];
}

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
    [self play];
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

    self.videoControl.channelIdLab.text = self.video.channelId;
    
    self.videoControl.channelNameLab.text = self.video.channelName;
    
    
//    self.subAudioDic = [[NSMutableDictionary alloc]init];
//    self.subAudioDic = self.video.dicSubAudio;
//    NSLog(@"self.video.dicSubAudio:%@",self.video.dicSubAudio);
//    NSLog(@"self.video.dicSubAudio:%@",self.subAudioDic);
    //self.video.dicSubAudio;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setEventTime) userInfo:nil repeats:YES];
    
    
}

-(void)setEventTime
{
    float aa1 = [self.video.endTime intValue]  - [self.video.startTime intValue];
    NSString * aa = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%f",aa1]];
   

    
    
    int bb1 = [[GGUtil GetNowTimeString] intValue]  - [self.video.startTime intValue];
    NSString * nowTime = [self timeWithTimeIntervalString:[NSString  stringWithFormat:@"%d",bb1]];

    self.videoControl.eventTimeLab.text = [NSString stringWithFormat:@"%@ | %@",nowTime,aa];
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
        return subtarr.count;
    }
    else if ([_cellStr isEqualToString:@"audio"]) {
        NSArray * audioarr =[self.subAudioDic  objectForKey:@"subt_info"];
        return audioarr.count;
        
    }
    else if ([_cellStr isEqualToString:@"channel"]) {
        return self.video.channelCount;
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
        
        NSLog(@"cell.dataDic:%@",cell.dataDic);
        
        return cell;
    }
    else if ([_cellStr isEqualToString:@"audio"]) {
        AudioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioCell"];
        if (cell == nil){
            cell = [AudioCell loadFromNib];
            cell.languageLab.textAlignment = UITextAlignmentCenter;
            
        }
        
        
        
        if (!ISEMPTY(self.video.dicSubAudio)) {
            
            NSArray * audioArr = [[NSArray alloc]init];
            
            audioArr  =[self.subAudioDic  objectForKey:@"audio_info"];
            
            cell.dataDic = audioArr[indexPath.row];
            
            
            //上下两个都可以试一下
            //        cell.dataDic =self.subAudioDic;
        }else{//如果为空，什么都不执行
        }
        
        NSLog(@"cell.dataDic:%@",cell.dataDic);
        
        return cell;
    }
    
    else if ([_cellStr isEqualToString:@"channel"]) {
         ChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell"];
        if (cell == nil){
            cell = [ChannelCell loadFromNib];
            cell.channelId.textAlignment = UITextAlignmentCenter;
            cell.channelName.textAlignment = UITextAlignmentCenter;
            
        }
        
        
        
        if (!ISEMPTY(self.video.dicChannl)) {
            
            cell.dataDic = [self.video.dicChannl objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
          
        }else{//如果为空，什么都不执行
        }
        
        NSLog(@"cell.dataDic:%@",cell.dataDic);
        
        return cell;
    }


    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    NSLog(@"我被选中了，哈哈哈哈哈哈哈");
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(TableViewHidden) object:nil];
    
    [self performSelector:@selector(TableViewHidden) withObject:nil afterDelay:5];
    
    NSIndexPath *path =  [self.subAudioTableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    
    NSLog(@"这是第%i行",path.row);
    

    
}

-(void)TableViewHidden
{
    [self.videoControl uiTableViewHidden];
}

@end
