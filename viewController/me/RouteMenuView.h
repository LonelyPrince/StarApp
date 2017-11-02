//
//  RouteMenuView.h
//  StarAPP
//
//  Created by xyz on 2017/10/17.
//

#import <UIKit/UIKit.h>
#import "WLANSettingView.h"
#import "SecurityCenterView.h"
#import "DeviceListView.h"
#import "RouterStatusView.h"
#import "BackupRestoreView.h"

@interface RouteMenuView : UIViewController<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UIImageView * colorView;  //顶部蓝色背景
@property(nonatomic,strong)UIImageView *routeImage; //盒子图标

@property(nonatomic,strong)UILabel * routeNameLab;
@property(nonatomic,strong)UILabel * secrityTypeLab;
@property(nonatomic,strong)UILabel * PINProtectionLab;


//分别为： ①WLAN setting 、 ②security center 、③devices List 、 ④Router status 、⑤backup&restore 、⑥rebot device
@property(nonatomic,strong)UIButton *btn1;
@property(nonatomic,strong)UIButton *btn2;
@property(nonatomic,strong)UIButton *btn3;
@property(nonatomic,strong)UIButton *btn4;
@property(nonatomic,strong)UIButton *btn5;
@property(nonatomic,strong)UIButton *btn6;

@property(nonatomic,strong)UIImageView *btnImageView1;
@property(nonatomic,strong)UIImageView *btnImageView2;
@property(nonatomic,strong)UIImageView *btnImageView3;
@property(nonatomic,strong)UIImageView *btnImageView4;
@property(nonatomic,strong)UIImageView *btnImageView5;
@property(nonatomic,strong)UIImageView *btnImageView6;

@property(nonatomic,strong)UILabel * btnLab1;
@property(nonatomic,strong)UILabel * btnLab2;
@property(nonatomic,strong)UILabel * btnLab3;
@property(nonatomic,strong)UILabel * btnLab4;
@property(nonatomic,strong)UILabel * btnLab5;
@property(nonatomic,strong)UILabel * btnLab6;

@property(nonatomic,strong)UILabel * generalSettingLab;

@property(nonatomic,strong)WLANSettingView  * wLANSettingView;
@property(nonatomic,strong)SecurityCenterView * securityCenterView;
@property(nonatomic,strong)DeviceListView * deviceListView;
@property(nonatomic,strong)RouterStatusView * routerStatusView;
@property(nonatomic,strong)BackupRestoreView * backupRestoreView;



@property(nonatomic,strong)UIView * NetWorkErrorView;
@property(nonatomic,strong)UIImageView * NetWorkErrorImageView;
@property(nonatomic,strong)UILabel * NetWorkErrorLab;
@end
