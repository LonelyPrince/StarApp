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
@property (strong,nonatomic) NSTimer * timerState;

@property (strong,nonatomic)KVO_NoDataPic *kvo_NoDataPic;  //KVO
@property (strong,nonatomic)UIImageView * kvo_NoDataImageview;  //底部节目列表为空，展示图片

-(void)touchSelectChannel :(NSInteger)row diction :(NSDictionary *)dic;


-(UIViewController*) currentViewController;
//-(void)timerStateInvalidate;
@end
