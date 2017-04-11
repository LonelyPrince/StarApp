//
//  ZXVideoPlayerControlView.h
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/21.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXVideoPlayerTimeIndicatorView.h"
#import "ZXVideoPlayerBrightnessView.h"
#import "ZXVideoPlayerVolumeView.h"
#import "ZXVideoPlayerBatteryView.h"
#import "YFRollingLabel.h"

#define kZXPlayerControlViewHideNotification @"ZXPlayerControlViewHideNotification"

@protocol ZXVideoPlayerControlViewDelegage <NSObject>

@optional
- (void)videoPlayerControlViewDidTapped;

@end

@interface ZXVideoPlayerControlView : UIView

@property (nonatomic, assign, readwrite) id<ZXVideoPlayerControlViewDelegage> delegate;

@property (nonatomic, strong, readonly) UIView *topBar;
@property (nonatomic, strong, readonly) UIView *bottomBar;
@property (nonatomic, strong, readonly) UIButton *playButton;
@property (nonatomic, strong, readonly) UIButton *pauseButton;
@property (nonatomic, strong, readonly) UIButton *fullScreenButton;
//@property (nonatomic, strong, readonly) UIButton *shrinkScreenButton;
@property (nonatomic, strong, readonly) UIButton *shrinkScreenButton1;
@property (nonatomic, strong, readonly) UISlider *progressSlider;
@property (nonatomic, strong, readonly) UILabel *timeLabel;

@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;

//@property (nonatomic, assign, readonly) BOOL isBarShowing;
@property (nonatomic, assign) BOOL isBarShowing;
/// 返回按钮
@property (nonatomic, strong, readwrite) UIButton *backButton;
/// 屏幕锁定按钮
@property (nonatomic, strong, readwrite) UIButton *lockButton;
/// 缓冲进度条
@property (nonatomic, strong, readwrite) UIProgressView *bufferProgressView;
/// 快进、快退指示器
@property (nonatomic, strong, readwrite) ZXVideoPlayerTimeIndicatorView *timeIndicatorView;
/// 亮度指示器
@property (nonatomic, strong, readwrite) ZXVideoPlayerBrightnessView *brightnessIndicatorView;
/// 音量指示器
@property (nonatomic, strong, readwrite) ZXVideoPlayerVolumeView *volumeIndicatorView;
/// 电池条
@property (nonatomic, strong, readwrite) ZXVideoPlayerBatteryView *batteryView;
/// 标题
@property (nonatomic, strong, readwrite) UILabel *titleLabel;

//**** 当前节目名称
@property (nonatomic, strong, readonly) UILabel *eventnameLabel;
//****
//上一个频道
@property (nonatomic, strong, readwrite) UIButton *lastChannelButton;
////下一个频道
@property (nonatomic, strong, readwrite) UIButton *nextChannelButton;

///字幕按钮
@property (nonatomic, strong, readwrite) UIButton *subtBtn;
////音轨按钮
@property (nonatomic, strong, readwrite) UIButton *audioBtn;
////列表频道按钮
@property (nonatomic, strong, readwrite) UIButton *channelListBtn;
////节目时长label
//@property (nonatomic, strong, readwrite) UILabel *eventTimeLab;
@property (nonatomic, strong, readwrite) UILabel *eventTimeLabNow; //当前时长
@property (nonatomic, strong, readwrite) UILabel *eventTimeLabAll;  //总时长

////频道号label
@property (nonatomic, strong, readwrite) UILabel *channelIdLab;

////频道名称label
@property (nonatomic, strong, readwrite) UILabel *channelNameLab;

////节目名称label   全屏
@property (nonatomic, strong, readwrite) UILabel *FulleventNameLab;
@property (nonatomic, strong, readwrite) YFRollingLabel *FullEventYFlabel;

////添加右侧tableview背景图片
@property (nonatomic, strong, readonly) UIView * rightView;





- (void)animateHide;
- (void)animateShow;
- (void)autoFadeOutControlBar;
- (void)cancelAutoFadeOutControlBar;

-(void)uiTableViewHidden;

-(void)autoFadeRightTableView;
@end
