//
//  ZXVideoPlayerControlView.m
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/21.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "ZXVideoPlayerControlView.h"
#import "ZXVideoPlayerController.h"


//#import "UIButton+EnlargeTouchArea.h"

static const CGFloat kVideoControlBarHeight = 50;  // 20.0 + 30.0;
static const CGFloat kVideoControlAnimationTimeInterval = 0.3;
static const CGFloat kVideoControlTimeLabelFontSize = 10.0;
static const CGFloat kVideoControlBarAutoFadeOutTimeInterval = 5.0;

@interface ZXVideoPlayerControlView ()
{
    BOOL showStatus;
    BOOL islockShowing;
    YFRollingLabel *_label;
    NSString * deviceString;
}
@property (nonatomic, strong) ZXVideoPlayerController *videoController;
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
//@property (nonatomic, strong) UIButton *shrinkScreenButton;
@property (nonatomic, strong) UIButton *shrinkScreenButton1; //new
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *eventnameLabel;

@property (nonatomic, strong)  UIImageView * bottomControllerImage;
@property (nonatomic, strong)  UIImageView * topControllerImage;
@property (nonatomic, strong)  UIImageView * rightControllerImage;
//@property (nonatomic, assign) BOOL isBarShowing;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;


////////
//上一个频道
//@property (nonatomic, strong) UIButton *lastChannelButton;
//////下一个频道
//@property (nonatomic, strong) UIButton *nextChannelButton;


@end


@implementation ZXVideoPlayerControlView

@synthesize isBarShowing;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topBar];
        [self addSubview:self.bottomBar];
        //        [self addSubview:self.rightView];
        
        self.rightView.hidden = YES;
        
        self.videoController.subAudioTableView.hidden = YES;
        
        //[self.bottomBar addSubview:self.playButton];
        //        [self.bottomBar addSubview:self.pauseButton];
        self.pauseButton.hidden = YES;
        [self.bottomBar addSubview:self.fullScreenButton];
        //        [self.bottomBar addSubview:self.shrinkScreenButton];
        [self.bottomBar addSubview:self.shrinkScreenButton1];
        [self.bottomBar addSubview:self.lastChannelButton];
        [self.bottomBar addSubview:self.nextChannelButton];
        [self.bottomBar addSubview:self.subtBtn];
        [self.bottomBar addSubview:self.audioBtn];
        [self.bottomBar addSubview:self.channelListBtn];
//        [self.bottomBar addSubview:self.eventTimeLab];
        [self.bottomBar addSubview:self.eventTimeLabNow];
        [self.bottomBar addSubview:self.eventTimeLabAll];
        
        
        
        [self.topBar addSubview:self.channelIdLab];
        [self.topBar addSubview:self.channelNameLab];
        [self.topBar addSubview:self.FulleventNameLab];
        [self.topBar addSubview:self.FullEventYFlabel];
        
        //        self.channelIdLab.hidden = YES;
        //        self.channelNameLab.hidden = YES;
        self.FulleventNameLab.hidden = YES;
        self.FullEventYFlabel.hidden = YES;
        
//        self.shrinkScreenButton.hidden = YES;
        self.shrinkScreenButton1.hidden = YES;
        self.lastChannelButton.hidden = YES;
        self.nextChannelButton.hidden = YES;
        self.subtBtn.hidden = YES;
        self.audioBtn.hidden =YES;
        self.channelListBtn.hidden = YES;
//        self.eventTimeLab.hidden = YES;
        self.eventTimeLabNow.hidden = YES;
        self.eventTimeLabAll.hidden = YES;
        
        //        [self.bottomBar addSubview:self.progressSlider];
        //        [self.bottomBar addSubview:self.timeLabel];
        [self addSubview:self.indicatorView];
        //****
        [self.bottomBar addSubview:self.eventnameLabel];
        //****
        // 返回按钮
        [self.topBar addSubview:self.backButton];
        self.backButton.hidden = YES;
        // 锁定按钮
        //        [self.topBar addSubview:self.lockButton];
             [self addSubview:self.lockButton];
        self.lockButton.hidden = YES;
        // 缓冲进度条
        //        [self.bottomBar insertSubview:self.bufferProgressView belowSubview:self.progressSlider];
        // 快进、快退指示器
        //        [self addSubview:self.timeIndicatorView];
        // 亮度指示器
        [self addSubview:self.brightnessIndicatorView];
        // 音量指示器
        [self addSubview:self.volumeIndicatorView];
        // 电池条
        //        [self.topBar addSubview:self.batteryView];
        // 标题
        // [self.topBar addSubview:self.titleLabel];
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapGesture];
        
        
        self.videoController = [[ZXVideoPlayerController alloc]init];
        
        showStatus = YES;
        islockShowing = YES;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lockButtonShow" object:nil];
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockButtonShow) name:@"lockButtonShow" object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lockButtonHide" object:nil];
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lockButtonHide) name:@"lockButtonHide" object:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.topBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds),  CGRectGetWidth(self.bounds), 100);//71  //43);
    NSLog(@"slef.x :%f",CGRectGetMinX(self.bounds));
    
    //  self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - 75,SCREEN_WIDTH, 75);
    
    self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - 75, CGRectGetWidth(self.bounds), 75);
    
    self.rightView.frame = CGRectMake(CGRectGetWidth(self.bounds) - 145, 0, 145, CGRectGetHeight(self.bounds));
    
    self.playButton.frame = CGRectMake(CGRectGetMinX(self.bottomBar.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.playButton.bounds)/2, CGRectGetWidth(self.playButton.bounds), CGRectGetHeight(self.playButton.bounds));
    
    self.pauseButton.frame = self.playButton.frame;
    
    self.fullScreenButton.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - 50,24, 50,50);
    
    
//    self.shrinkScreenButton.frame = self.fullScreenButton.frame;
    
    self.shrinkScreenButton1.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - 50,24, 48,52);
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(self.playButton.frame), 0, CGRectGetMinX(self.fullScreenButton.frame) - CGRectGetMaxX(self.playButton.frame), kVideoControlBarHeight);
    
    self.timeLabel.frame = CGRectMake(CGRectGetMidX(self.progressSlider.frame), CGRectGetHeight(self.bottomBar.bounds) - CGRectGetHeight(self.timeLabel.bounds) - 2.0, CGRectGetWidth(self.progressSlider.bounds)/2, CGRectGetHeight(self.timeLabel.bounds));
    
    self.indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // 返回按钮
    self.backButton.frame = CGRectMake(0, 25, 54, 56);
    // 锁定按钮
        self.lockButton.frame = CGRectMake(10, SCREEN_WIDTH/2 - 30, 60, 60);
    
    // 缓冲进度条a    self.bufferProgressView.bounds = CGRectMake(0, 0, self.progressSlider.bounds.size.width - 7, self.progressSlider.bounds.size.height);
    self.bufferProgressView.center = CGPointMake(self.progressSlider.center.x + 2, self.progressSlider.center.y);
    // 快进、快退指示器
    //  self.timeIndicatorView.center = self.indicatorView.center;
    // 亮度指示器
    self.brightnessIndicatorView.center = self.indicatorView.center;
    // 音量指示器
    self.volumeIndicatorView.center = self.indicatorView.center;
    // 电池条
    //    self.batteryView.frame = CGRectMake(CGRectGetMinX(self.lockButton.frame) - CGRectGetWidth(self.batteryView.bounds) - 10, CGRectGetMidY(self.topBar.bounds) - CGRectGetHeight(self.batteryView.bounds) / 2, CGRectGetWidth(self.batteryView.bounds), CGRectGetHeight(self.batteryView.bounds));
    // 标题
    //    self.titleLabel.frame = CGRectMake(CGRectGetWidth(self.backButton.bounds), 20, CGRectGetWidth(self.topBar.bounds) - CGRectGetWidth(self.backButton.bounds) - CGRectGetWidth(self.lockButton.bounds), kVideoControlBarHeight - 20);
    //    self.titleLabel.frame = CGRectMake(-55, 20, CGRectGetWidth(self.topBar.bounds) - CGRectGetWidth(self.backButton.bounds) - CGRectGetWidth(self.lockButton.bounds), kVideoControlBarHeight - 20);
    
    self.titleLabel.frame = CGRectMake(CGRectGetMinX(self.topBar.bounds)+20, 20, SCREEN_WIDTH, 9);
    //********
    //    self.eventnameLabel.frame =  CGRectMake(CGRectGetMinX(self.bottomBar.bounds)+CGRectGetWidth(self.playButton.bounds)+5, CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.playButton.bounds)/2, CGRectGetWidth(self.playButton.bounds)+70, CGRectGetHeight(self.playButton.bounds));;
    self.eventnameLabel.frame =  CGRectMake(20, 40, 200, 20);
    
    
    
    
    
    deviceString = [GGUtil deviceVersion];
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是5s和4s的大小");
        
//        self.eventTimeLab.frame = CGRectMake(128-10+5, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17, 180, 17);
        self.eventTimeLabNow.frame = CGRectMake(128-10+5, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17, 90, 17);
        self.eventTimeLabAll.frame = CGRectMake(128-10+5+66, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17, 90, 17);
        self.lastChannelButton.frame = CGRectMake(20-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 - 17-13, 44, 44);
        
        self.nextChannelButton.frame = CGRectMake(72-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17-13, 44, 44);
        self.subtBtn.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - 221.5-2+10+5, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17-13, 44, 44);
        self.audioBtn.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) -329/2-2+10, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17 -13, 44, 44);
        self.channelListBtn.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds)-215/2-2+5, CGRectGetHeight(self.bottomBar.bounds) -16.5-17-13, 44, 44);
        
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        self.eventTimeLabNow.frame = CGRectMake(134, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17, 90, 17);
        self.eventTimeLabAll.frame = CGRectMake(134+77, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17, 90, 17);
        self.lastChannelButton.frame = CGRectMake(20-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 - 17-13, 44, 44);
        
        self.nextChannelButton.frame = CGRectMake(77-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17-13, 44, 44);
        self.subtBtn.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - 221.5-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17-13, 44, 44);
        self.audioBtn.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) -329/2-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17 -13, 44, 44);
        self.channelListBtn.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds)-215/2-7, CGRectGetHeight(self.bottomBar.bounds) -16.5-17-13, 44, 44);
        
    }
    else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]  ) {
        NSLog(@"此刻是6的大小");
        
        self.eventTimeLabNow.frame = CGRectMake(134, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17, 90, 17);
        self.eventTimeLabAll.frame = CGRectMake(134+80, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17, 90, 17);
        self.lastChannelButton.frame = CGRectMake(20-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 - 17-13, 44, 44);
        
        self.nextChannelButton.frame = CGRectMake(77-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17-13, 44, 44);
        self.subtBtn.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - 221.5-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17-13, 44, 44);
        self.audioBtn.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) -329/2-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17 -13, 44, 44);
        self.channelListBtn.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds)-215/2-7, CGRectGetHeight(self.bottomBar.bounds) -16.5-17-13, 44, 44);
        
    }else{
//    self.eventTimeLab.frame = CGRectMake(134, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17, 180, 17);
        self.eventTimeLabNow.frame = CGRectMake(134, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17, 90, 17);
        self.eventTimeLabAll.frame = CGRectMake(134+81, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17, 90, 17);
        self.lastChannelButton.frame = CGRectMake(20-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 - 17-13, 44, 44);
        
        self.nextChannelButton.frame = CGRectMake(77-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17-13, 44, 44);
        self.subtBtn.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - 221.5-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17-13, 44, 44);
        self.audioBtn.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) -329/2-7, CGRectGetHeight(self.bottomBar.bounds) -16.5 -17 -13, 44, 44);
        self.channelListBtn.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds)-215/2-7, CGRectGetHeight(self.bottomBar.bounds) -16.5-17-13, 44, 44);
    }
    
    
    
    
    //*********
    self.channelIdLab.frame = CGRectMake(20, 10, 28, 18);
    self.channelNameLab.frame = CGRectMake(56, 10, 120, 18);
    self.FulleventNameLab.frame = CGRectMake(293, 10, 200, 18);
    self.FullEventYFlabel.frame = CGRectMake(293, 40, 200, 18);
    
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.isBarShowing = YES;
}

#pragma mark - Public Method

- (void)animateHide
{
    if (!self.isBarShowing) {
        return;
    }
  
    if (self.FullEventYFlabel) {
        [self.FullEventYFlabel removeFromSuperview];
        self.FullEventYFlabel = nil;
        [self.FullEventYFlabel stopTimer];
        
        NSLog(@"跑马灯销毁 1 animatehide");
    }
    
    
//    _FullEventYFlabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake(20, 30+26, 20, 40)  textArray:@[@123] font:[UIFont systemFontOfSize:11] textColor:[UIColor whiteColor]];
//    [_FullEventYFlabel initArr:@[@"123"]];
//    [self addSubview:_FullEventYFlabel];
//    _label.speed = 3;
//    
//    
//    [self.FullEventYFlabel removeFromSuperview];
//    self.FullEventYFlabel = nil;
//    [self.FullEventYFlabel stopTimer];

    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kZXPlayerControlViewHideNotification object:nil];
    
    [UIView animateWithDuration:kVideoControlAnimationTimeInterval animations:^{
       BOOL lockButtonIsClick =  [USER_DEFAULT boolForKey:@"lockedFullScreen"];
        if (lockButtonIsClick) { //如果锁屏按钮已经点击
         
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(lockButtonHide) object:nil];
            [self performSelector:@selector(lockButtonHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeInterval];
//            [self lockButtonHide];
        }else
        {
            [self lockButtonHide];
        }
        
        self.topBar.alpha = 0.0;
        self.bottomBar.alpha = 0.0;
        self.rightView.alpha = 0.0;
        
        //
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        showStatus = NO;
[self prefersStatusBarHidden];
                //
        
        NSLog(@"123123123123123123123123=====-----");
        
        self.videoController.subAudioTableView = nil;
        
//        //全屏页面右侧列表隐藏
//        NSNotification *notification1 =[NSNotification notificationWithName:@"tableviewHidden" object:nil userInfo:nil];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification1];
//        
        
        
        
        //        /////// 加入通知
        int show = 1;
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",show],@"boolBarShow",nil];
        NSNotification *notification =[NSNotification notificationWithName:@"fixprogressView" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    } completion:^(BOOL finished) {
        self.isBarShowing = NO;
    }];
    [USER_DEFAULT setBool:NO forKey:@"isBarIsShowNow"]; //阴影此时是隐藏
}

- (void)animateShow
{
    
    
    if (self.isBarShowing) {
        return;
    }

    
    [UIView animateWithDuration:kVideoControlAnimationTimeInterval animations:^{
      
        BOOL isFullScreenMode =[USER_DEFAULT boolForKey:@"isFullScreenMode"];
        if (isFullScreenMode) {   //如果是全屏模式并且topbar展示时才初始化新建一个跑马灯
            NSNotification *notification =[NSNotification notificationWithName:@"abctest" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            
        }
        //--
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(lockButtonHide) object:nil];
        [self performSelector:@selector(lockButtonHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeInterval];
        //--
        self.topBar.alpha = 1.0;
        self.bottomBar.alpha = 1.0;
        //        self.bottomBar.userInteractionEnabled = YES;
        
        //
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        showStatus = YES;
        [self prefersStatusBarHidden];
        //
        NSLog(@"123123123123123123123123=====");
        self.videoController.subAudioTableView.alpha = 0;
        self.videoController.subAudioTableView = nil;
        /////// 加入通知
        int show = 2;
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",show],@"boolBarShow",nil];
        NSNotification *notification =[NSNotification notificationWithName:@"fixprogressView" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    } completion:^(BOOL finished) {
        self.isBarShowing = YES;
        [self autoFadeOutControlBar];
    }];
    
    [USER_DEFAULT setBool:YES forKey:@"isBarIsShowNow"]; //阴影此时是显示
}

- (void)autoFadeOutControlBar
{
    if (!self.isBarShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeInterval];
    
    
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}

- (void)autoFadeRightTableView{
//    if (!self.rightView) {
//        return;
//    }
    NSLog(@"右侧列表消失111");
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rightTableViewHide) object:nil];
    [self performSelector:@selector(rightTableViewHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeInterval];
    
    
}
-(void)rightTableViewHide
{
    NSLog(@"右侧列表消失222");
    [UIView animateWithDuration:kVideoControlAnimationTimeInterval animations:^{
    //全屏页面右侧列表隐藏
    NSNotification *notification1 =[NSNotification notificationWithName:@"tableviewHidden" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    }];


}
//右侧的tableView的滑动事件隐藏
-(void)uiTableViewHidden
{
    [self animateHide];
    [self rightView];
    
}

#pragma mark - Tap Detection

- (void)onTap:(UITapGestureRecognizer *)gesture
{
//    [self rightTableViewHide];
    //第一步先判断是不是按了锁
    if ([USER_DEFAULT boolForKey:@"lockedFullScreen"]) {
        //锁住状态下判断是否点击
        if (islockShowing == YES) {
            //将锁隐藏
            
            self.lockButton.hidden =YES;
            islockShowing = NO;
            
        }else
        {
        //将其显示
            
//            self.lockButton.hidden = NO;
//            islockShowing = YES;
            [self lockButtonShow];
        }
        
        
        
    }else   //没有锁住🔐
    {
        int show;
        if (gesture.state == UIGestureRecognizerStateRecognized) {
            if (self.isBarShowing) {
                [self animateHide];
                [self rightTableViewHide];
                show = 1;
                _topBar.userInteractionEnabled = YES;
                _bottomBar.userInteractionEnabled = YES;
                NSLog(@"**%hhd",self.isBarShowing);
                NSLog(@"点击了一下");
               
                BOOL isFullScreenMode =[USER_DEFAULT boolForKey:@"isFullScreenMode"];
                if (islockShowing == YES && isFullScreenMode ) {
                    //将锁隐藏
                    [self lockButtonHide];
//                    self.lockButton.hidden =YES;
//                    islockShowing = NO;
                    
                }
                [USER_DEFAULT setBool:NO forKey:@"isBarIsShowNow"]; //阴影此时是隐藏
            } else {
                [USER_DEFAULT setBool:YES forKey:@"isBarIsShowNow"]; //阴影此时是显示
                [self animateShow];
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                show = 2;
                _topBar.userInteractionEnabled = YES;
                _bottomBar.userInteractionEnabled = YES;
                NSLog(@"**%hhd",self.isBarShowing);
                NSLog(@"点击了第二下");
                
                BOOL isFullScreenMode =[USER_DEFAULT boolForKey:@"isFullScreenMode"];
//                if (isFullScreenMode) {   //如果是全屏模式并且topbar展示时才初始化新建一个跑马灯
//                    NSNotification *notification =[NSNotification notificationWithName:@"abctest" object:nil userInfo:nil];
//                    [[NSNotificationCenter defaultCenter] postNotification:notification];
//                    
//
//                }
                if (islockShowing == NO&& isFullScreenMode)  {
                    //将其显示
                    
                    [self lockButtonShow];
//                    self.lockButton.hidden = NO;
//                    islockShowing = YES;
                    
                   
                }
                
            }
        }
    }

    //    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",show],@"boolBarShow",nil];
    //    NSNotification *notification =[NSNotification notificationWithName:@"fixTopBottomImage" object:nil userInfo:dict];
    //    //通过通知中心发送通知
    //    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)lockButtonHide
{
    if (!islockShowing) {
        return;
    }
    
    self.lockButton.hidden =YES;
    islockShowing = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(lockButtonHide) object:nil];
//    [self performSelector:@selector(lockButtonShow) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeInterval];
}
-(void)lockButtonShow
{
    if (islockShowing) {
        return;
    }
    self.lockButton.hidden = NO;
    islockShowing = YES;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(lockButtonHide) object:nil];
    [self performSelector:@selector(lockButtonHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeInterval];
}
#pragma mark - getters

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.accessibilityIdentifier = @"TopBar";
        
        
        _topControllerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Overlay"]];
        _topControllerImage.frame =  CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, 43);
        
        
        [_topBar addSubview:_topControllerImage];
        
        
        
    }
    return _topBar;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        
        _bottomBar.accessibilityIdentifier = @"bottomBar";
        //此处销毁通知，防止一个通知被多次调用
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fixTopBottomImage" object:nil];
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fixTopBottomImage:) name:@"fixTopBottomImage" object:nil];
        
        
        _bottomControllerImage  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Group 16"]];
        _bottomControllerImage.frame =  CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 75);
        
        
        [_bottomBar addSubview:_bottomControllerImage];
    }
    return _bottomBar;
}

- (void)fixTopBottomImage:(NSNotification *)text{
    
    float Imagewidth = [text.userInfo[@"noewWidth"]floatValue];
    NSLog(@"Imagewidth :%f",Imagewidth);
    NSLog(@"SCREEN_HEIGHT :%f",SCREEN_HEIGHT);
    if (Imagewidth > SCREEN_WIDTH) {  //全屏
        _topControllerImage.frame =  CGRectMake(0, 0,Imagewidth, 100);
        _bottomControllerImage.frame =  CGRectMake(0, 0,Imagewidth, 100);
        
        _topControllerImage.image = [UIImage imageNamed:@"顶背景"];
        _bottomControllerImage.image = [UIImage imageNamed:@"底背景"];
        _topBar.frame =CGRectMake(0, 0,Imagewidth, 100);
        _bottomBar.frame =  CGRectMake(0, 0,Imagewidth, 100);
        
    }else  //竖屏
    {
        _topControllerImage.frame =  CGRectMake(0, 0,Imagewidth, 43);
        _bottomControllerImage.frame =  CGRectMake(0, 0,Imagewidth, 75);
        
        _topControllerImage.image = [UIImage imageNamed:@"Overlay"];
        _bottomControllerImage.image = [UIImage imageNamed:@"Group 16"];
        _topBar.frame =CGRectMake(0, 0,Imagewidth, 43);
        _bottomBar.frame =  CGRectMake(0, 0,Imagewidth, 75);
    }
    
    
    _bottomBar.userInteractionEnabled = YES;
    _topBar.userInteractionEnabled = YES;
    //    if (Imagewidth>500) {
    //        self.topBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds)+20, Imagewidth, 43);
    //    }
    
}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [UIView new];
        _rightView.accessibilityIdentifier = @"RightView";
        
        //        _rightControllerImage  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"渐变"]];
        //        _rightControllerImage.frame =  CGRectMake([UIScreen mainScreen].bounds.size.width - 145, 0, 145, [UIScreen mainScreen].bounds.size.height);
        //
        //
        //        [_rightView addSubview:_rightControllerImage];
        
        
        _rightView.backgroundColor = [UIColor whiteColor];
        
    }
    return _rightView;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"kr-video-player-play"] forState:UIControlStateNormal];
        _playButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"kr-video-player-pause"] forState:UIControlStateNormal];
        _pauseButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _pauseButton;
}



///全屏
- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"Group 5"] forState:UIControlStateNormal];
        _fullScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
        
//        [_fullScreenButton setEnlargeEdgeWithTop:20 right:15 bottom:15 left:20];
    }
    return _fullScreenButton;
}

////退出全屏
//- (UIButton *)shrinkScreenButton
//{
//    if (!_shrinkScreenButton) {
//        _shrinkScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_shrinkScreenButton setImage:[UIImage imageNamed:@"小窗"] forState:UIControlStateNormal];
//        _shrinkScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
//        
////        [_shrinkScreenButton setEnlargeEdgeWithTop:20 right:15 bottom:15 left:20];
//    }
//    return _shrinkScreenButton;
//}

//退出全屏1
- (UIButton *)shrinkScreenButton1
{
    
    if (!_shrinkScreenButton1) {
        _shrinkScreenButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkScreenButton1 setImage:[UIImage imageNamed:@"小窗"] forState:UIControlStateNormal];
        _shrinkScreenButton1.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
        
//         [_shrinkScreenButton1 setEnlargeEdgeWithTop:20 right:15 bottom:15 left:20];
    }
    return _shrinkScreenButton1;
}
///上一个频道
- (UIButton *)lastChannelButton
{
    
    if (!_lastChannelButton) {
        _lastChannelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastChannelButton setImage:[UIImage imageNamed:@"上一频道"] forState:UIControlStateNormal];
        _lastChannelButton.bounds = CGRectMake(0, 0, 17, 17);
        
//        [_lastChannelButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:20];
    }
    return _lastChannelButton;
}
///下一个频道
- (UIButton *)nextChannelButton
{
    
    if (!_nextChannelButton) {
        _nextChannelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextChannelButton setImage:[UIImage imageNamed:@"下一频道"] forState:UIControlStateNormal];
        _nextChannelButton.bounds = CGRectMake(0, 0, 17, 17);
        
//        [_nextChannelButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:20];
    }
    return _nextChannelButton;
    
}
///字幕
- (UIButton *)subtBtn
{
    
    if (!_subtBtn) {
        _subtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subtBtn setImage:[UIImage imageNamed:@"字幕"] forState:UIControlStateNormal];
        _subtBtn.bounds = CGRectMake(0, 0, 17, 17);
        
//        [_subtBtn setEnlargeEdgeWithTop:20 right:15 bottom:15 left:20];
    }
    return _subtBtn;
    
}
///音轨
- (UIButton *)audioBtn
{
    
    if (!_audioBtn) {
        _audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_audioBtn setImage:[UIImage imageNamed:@"音轨"] forState:UIControlStateNormal];
        _audioBtn.bounds = CGRectMake(0, 0, 17, 17);
        
//         [_audioBtn setEnlargeEdgeWithTop:20 right:15 bottom:15 left:20];
    }
    return _audioBtn;
    
}
///频道列表
- (UIButton *)channelListBtn
{
    
    if (!_channelListBtn) {
        _channelListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_channelListBtn setImage:[UIImage imageNamed:@"频道列表"] forState:UIControlStateNormal];
        _channelListBtn.bounds = CGRectMake(0, 0, 17, 17);
        
//        [_channelListBtn setEnlargeEdgeWithTop:20 right:15 bottom:15 left:20];
    }
    return _channelListBtn;
    
}
/////节目时间
//- (UILabel *)eventTimeLab
//{
//    
//    if (!_eventTimeLab) {
//        _eventTimeLab = [[UILabel alloc] init];
//        //        _eventTimeLab.lineBreakMode = NSLineBreakByTruncatingTail;
//        _eventTimeLab.text = @"08:00 | 30:00 " ;
//        _eventTimeLab.textColor =[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
//        
//        deviceString = [GGUtil deviceVersion];
//        if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
//            NSLog(@"此刻是5s和4s的大小");
//            
//        _eventTimeLab.font = [UIFont systemFontOfSize:15];
//            
//        }else{
//        _eventTimeLab.font = [UIFont systemFontOfSize:18];
//        }
//        
//        
//        
//    }
//    return _eventTimeLab;
//    
//}
///节目时间
- (UILabel *)eventTimeLabNow
{
    
    if (!_eventTimeLabNow) {
        _eventTimeLabNow = [[UILabel alloc] init];
        //        _eventTimeLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _eventTimeLabNow.text = @"08:00 " ;
        _eventTimeLabNow.textColor =[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
        
        deviceString = [GGUtil deviceVersion];
        if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
            NSLog(@"此刻是5s和4s的大小");
            
            _eventTimeLabNow.font = [UIFont systemFontOfSize:15];
            
        }else{
            _eventTimeLabNow.font = [UIFont systemFontOfSize:18];
        }
        
        
        
    }
    return _eventTimeLabNow;
    
}
///节目时间
- (UILabel *)eventTimeLabAll
{
    
    if (!_eventTimeLabAll) {
        _eventTimeLabAll = [[UILabel alloc] init];
        //        _eventTimeLab.lineBreakMode = NSLineBreakByTruncatingTail;
        _eventTimeLabAll.text = @"| 30:00 " ;
        _eventTimeLabAll.textColor =[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
        
        deviceString = [GGUtil deviceVersion];
        if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
            NSLog(@"此刻是5s和4s的大小");
            
            _eventTimeLabAll.font = [UIFont systemFontOfSize:15];
            
        }else{
            _eventTimeLabAll.font = [UIFont systemFontOfSize:18];
        }
        
        
        
    }
    return _eventTimeLabAll;
    
}
///频道号
- (UILabel *)channelIdLab
{
    
    if (!_channelIdLab) {
        _channelIdLab = [[UILabel alloc] init];
        //        _eventTimeLab.lineBreakMode = NSLineBreakByTruncatingTail;
        //        _channelIdLab.text = @"02900 " ;
        _channelIdLab.textColor =[UIColor colorWithRed:255 green:255 blue:255 alpha:1];
        _channelIdLab.font = [UIFont systemFontOfSize:12];
        
    }
    return _channelIdLab;
    
}
///频道名称
- (UILabel *)channelNameLab
{
    
    if (!_channelNameLab) {
        _channelNameLab = [[UILabel alloc] init];
        //        _eventTimeLab.lineBreakMode = NSLineBreakByTruncatingTail;
        //        _channelNameLab.text = @" ZOOM MOON  " ;
        _channelNameLab.textColor =[UIColor colorWithRed:255 green:255 blue:255 alpha:1];
        _channelNameLab.font = [UIFont systemFontOfSize:12];
        
    }
    return _channelNameLab;
    
}
///节目名称 全屏
- (UILabel *)FulleventNameLab
{
    
    if (!_FulleventNameLab) {
        _FulleventNameLab = [[UILabel alloc] init];
        //        _eventTimeLab.lineBreakMode = NSLineBreakByTruncatingTail;
//        _FulleventNameLab.text = @"Despicble Me And TOT LAL MOM " ;
        _FulleventNameLab.textColor =[UIColor colorWithRed:255 green:255 blue:255 alpha:1];
        _FulleventNameLab.font = [UIFont systemFontOfSize:11];
        
    }
    return _FulleventNameLab;
    
}

/////节目名称 全屏222
//- (YFRollingLabel *)FullEventYFlabel
//{
//    
//    if (!_FullEventYFlabel) {
////        _FullEventYFlabel = [[YFRollingLabel alloc] init];
//        
////        _FullEventYFlabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake(20, 30+26, 20, 40)  textArray:@[@"123123123123"] font:[UIFont systemFontOfSize:11] textColor:[UIColor whiteColor]];
////        
//        
//    }
//    return _FullEventYFlabel;
//    
//}

///进度条
- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"kr-video-player-point"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_progressSlider setMaximumTrackTintColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.4]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

///时间
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlTimeLabelFontSize);
    }
    return _timeLabel;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_indicatorView stopAnimating];
    }
    return _indicatorView;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 48, 56)];
        [_backButton setImage:[UIImage imageNamed:@"Back Arrow Blue"] forState:UIControlStateNormal];
//        Back Arrow Blue@3x
        //        UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(3,3, 6, 10)];
        //        backImageView.image = [UIImage imageNamed:@"Back Arrow Blue"];
        //        [_backButton addSubview:backImageView];
        //[_backButton setBackgroundImage:[UIImage imageNamed:@"Back Arrow Blue"] forState:UIControlStateNormal];
        
//         [_backButton setEnlargeEdgeWithTop:20 right:15 bottom:30 left:20];
    }
    return _backButton;
}

- (UIButton *)lockButton
{
    if (!_lockButton) {
        _lockButton =[[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 60)];
        [_lockButton setImage:[UIImage imageNamed:@"未加锁 "] forState:UIControlStateNormal];
        [_lockButton setImage:[UIImage imageNamed:@"加锁 "] forState:UIControlStateHighlighted];
        [_lockButton setImage:[UIImage imageNamed:@"加锁 "] forState:UIControlStateSelected];
//        _lockButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    return _lockButton;
}

- (UIProgressView *)bufferProgressView
{
    if (!_bufferProgressView) {
        _bufferProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _bufferProgressView.progressTintColor = [UIColor colorWithWhite:1 alpha:0.3];
        _bufferProgressView.trackTintColor = [UIColor clearColor];
    }
    return _bufferProgressView;
}

- (ZXVideoPlayerTimeIndicatorView *)timeIndicatorView
{
    if (!_timeIndicatorView) {
        _timeIndicatorView = [[ZXVideoPlayerTimeIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kVideoTimeIndicatorViewSide, kVideoTimeIndicatorViewSide)];
    }
    return _timeIndicatorView;
}

- (ZXVideoPlayerBrightnessView *)brightnessIndicatorView
{
    if (!_brightnessIndicatorView) {
        _brightnessIndicatorView = [[ZXVideoPlayerBrightnessView alloc] initWithFrame:CGRectMake(0, 0, kVideoBrightnessIndicatorViewSide, kVideoBrightnessIndicatorViewSide)];
    }
    return _brightnessIndicatorView;
}

- (ZXVideoPlayerVolumeView *)volumeIndicatorView
{
    if (!_volumeIndicatorView) {
        _volumeIndicatorView = [[ZXVideoPlayerVolumeView alloc] initWithFrame:CGRectMake(0, 0, kVideoVolumeIndicatorViewSide, kVideoVolumeIndicatorViewSide)];
    }
    return _volumeIndicatorView;
}

- (ZXVideoPlayerBatteryView *)batteryView
{
    if (!_batteryView) {
        _batteryView = [[ZXVideoPlayerBatteryView alloc] initWithFrame:CGRectMake(0, 0, kVideoBatteryViewWidth, kVideoBatteryViewHeight)];
    }
    return _batteryView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textColor =[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _titleLabel;
}
//****
///
- (UILabel *)eventnameLabel
{
    if (!_eventnameLabel) {
        _eventnameLabel = [[UILabel alloc] init];
        _eventnameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _eventnameLabel.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
        _eventnameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _eventnameLabel;
}
- (BOOL)prefersStatusBarHidden
{
    if (showStatus == YES) {
        return NO;
    }
    if (showStatus == NO) {
        return YES;
    }
    
    //    return UIStatusBarStyleLightContent;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
