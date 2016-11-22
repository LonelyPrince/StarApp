//
//  DeviceManageController.h
//  StarAPP
//
//  Created by xyz on 2016/11/9.
//
//

#import <UIKit/UIKit.h>
#import "CGUpnpDeviceModel.h"
@interface DeviceManageController : UIViewController<CGUpnpControlPointDelegate,UIScrollViewDelegate>


@property (nonatomic, retain) CGUpnpAvController* avController;
@property (nonatomic, retain) CGUpnpDeviceModel* cgUpnpModel;   //model
@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic, retain) CGUpnpAvController* avCtrl; //搜索的类


@property(nonatomic,strong) SocketView * socketView;   //这里获取tuner信息
@property(nonatomic,assign) NSInteger isDmsNum;
@end
