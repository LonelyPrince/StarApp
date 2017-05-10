//
//  AppDelegate.h
//  DLNASample
//
//  Created by 健司 古山 on 12/05/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarMainTabController.h"
#import "CGUpnpDeviceModel.h"
#import "Reachability.h"  //判断网络连接状态用
#import <arpa/inet.h>

@class CGUpnpAvRenderer;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CGUpnpControlPointDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic, retain)CGUpnpAvRenderer* avRenderer;

@property(strong,nonatomic) StarMainTabController * starMainTab;



//**  此处进行dms搜索用
@property (nonatomic, retain) CGUpnpAvController* avController;
@property (nonatomic, retain) CGUpnpDeviceModel* cgUpnpModel;   //model
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, retain) CGUpnpAvController* avCtrl; //搜索的类
//******

+ (AppDelegate *)shareAppDelegate;

//设置nstimer
@property (nonatomic, retain) NSTimer * timerCheckIP;
@property (nonatomic, retain) NSString * ipString;

@property (nonatomic, assign) NSInteger * openfirst;

@property (nonatomic, strong) Reachability *routerReachability;  //判断网络连接状态用
@property (nonatomic, strong) Reachability *hostReachability; //判断网络连接状态用
@end
