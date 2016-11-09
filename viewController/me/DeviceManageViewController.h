//
//  DeviceManageViewController.h
//  StarAPP
//
//  Created by xyz on 16/9/29.
//
//

#import <UIKit/UIKit.h>
#import "CGUpnpDeviceModel.h"

@interface DeviceManageViewController : UIViewController<CGUpnpControlPointDelegate,UIScrollViewDelegate>

@property (nonatomic, retain) CGUpnpAvController* avController;
@property (nonatomic, retain) CGUpnpDeviceModel* cgUpnpModel;
@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic, retain) CGUpnpAvController* avCtrl;
@end

