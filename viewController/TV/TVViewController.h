//
//  TVViewController.h
//  starApp
//
//  Created by xyz on 16/8/1.
//  Copyright © 2016年 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
#import "ServiceModel.h"
#import "SocketView.h"
#import "Singleton.h"

#import "FullScreenView.h"
//************
#import <CyberLink/UPnP.h>

#import "MasterViewController.h"
#import "ServerContentViewController.h"
#import "DetailViewController.h"
#import <CyberLink/UPnPAV.h>
@class CGUpnpAvServer;
@class CGUpnpAvObject;
@class CGUpnpAvRenderer;

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>
@class ServerContentViewController;
@class CGUpnpAvController;
#import "AppDelegate.h"
#import "THProgressView.h"
#import "MonitorViewController.h"
#import "CategoryViewController.h"
#import "KVO_NoDataPic.h"
#import "NowPlayChannelInfo.h"
#import "pushViewCell.h"
#import "YFRollingLabel.h"

@class ZXVideo;
@interface TVViewController : UIViewController<UITextFieldDelegate>


@property (nonatomic, strong, readwrite) ZXVideo *video;

@property(nonatomic,strong) CategoryModel * categoryModel;
@property(nonatomic,strong) ServiceModel * serviceModel;
@property(nonatomic,strong) SocketView * socketView;
@property(nonatomic,strong) MonitorViewController * monitorView;
@property(nonatomic,strong) CategoryViewController * categoryView;

@property (nonatomic, strong) FullScreenView * fullScreenView;
//**********
@property (nonatomic, retain) CGUpnpAvController* avController;
//**********
@property (strong,nonatomic)THProgressView *topProgressView;

@property (strong,nonatomic)UIView * activeView;
@property (strong,nonatomic)NSString * IPString;
@property (strong,nonatomic) UIView * topView;
@property (strong,nonatomic)NSMutableArray * allStartEpgTime;
//@property (strong,nonatomic) NSTimer * timerState;  //计时器，用来计时播放一个视频，看15秒内是否可以播放，如果不能播放，则显示sorry的提示语

@property (strong,nonatomic)KVO_NoDataPic *kvo_NoDataPic;  //KVO
@property (strong,nonatomic)UIImageView * NoDataImageview;  //底部节目列表为空，展示图片
@property (strong,nonatomic)UILabel * NoDataLabel;  //底部节目列表为空，展示图片
@property (strong,nonatomic)NowPlayChannelInfo *nowPlayChannelInfo;  //KVO
@property (strong,nonatomic)UITableView * pushTableView;  //KVO
@property (strong,nonatomic)pushViewCell * pushViewCell;
@property (strong,nonatomic)NSMutableArray * shareViewArr;

/// 跳转到其他的页面都自动停止播放，并且取消掉首页的20秒无法播放显示的字体
@property (nonatomic, copy) void(^TVViewStopVideoPlayAndCancelDealyFunctionBlock)();

-(void)touchSelectChannel :(NSInteger)row diction :(NSDictionary *)dic;
-(void)SetService_videoindex:(NSDictionary *)epgDicToSocket;

-(UIViewController*) currentViewController;
//-(void)timerStateInvalidate;
@end
