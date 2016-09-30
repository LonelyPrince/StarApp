//
//  DeviceManageViewController.h
//  StarAPP
//
//  Created by xyz on 16/9/29.
//
//

#import <UIKit/UIKit.h>

@interface DeviceManageViewController : UIViewController<CGUpnpControlPointDelegate>

@property (nonatomic, retain) CGUpnpAvController* avController;

@end
