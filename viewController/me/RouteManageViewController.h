//
//  RouteManageViewController.h
//  StarAPP
//
//  Created by xyz on 2016/11/10.
//
//

#import <UIKit/UIKit.h>
#import "RouteCell.h"
#import "RouteSetting.h"
@interface RouteManageViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIImageView *routeImage;
@property(nonatomic,strong)UILabel * routeNameLab;
@property(nonatomic,strong)UILabel * routeIPLab;
@property(nonatomic,strong)UIImageView *editImage;  // 此处需要修改为btn
@property(nonatomic,strong)UIButton *editBtn;


@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *centerGrayView;

@property(nonatomic,strong)UILabel * connectDevice;

@property(nonatomic,strong)UITableView * tableView;  //UItableview

@property(nonatomic,strong)NSDictionary * onlineDeviceDic;  //在线设备数

@property(nonatomic,strong)NSDictionary * wifiDic;  //wifi 字典
@property(nonatomic,strong)NSDictionary * wifiName;  //wifi 名字
@property(nonatomic,strong)NSDictionary * wifiIP;  //wifi IP地址
@property(nonatomic,strong)NSDictionary * wifiPwd;  //wifi 密码



@property(nonatomic,strong) RouteSetting * routeSetting;
@end
