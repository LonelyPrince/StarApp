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




@class ZXVideo;
@interface TVViewController : UIViewController

@property (nonatomic, strong, readwrite) ZXVideo *video;

@property(nonatomic,strong) CategoryModel * categoryModel;
@property(nonatomic,strong) ServiceModel * serviceModel;
@property(nonatomic,strong) SocketView * socketView;


//**********
@property (nonatomic, retain) CGUpnpAvController* avController;
//**********

@end
