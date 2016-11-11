//
//  RouteManageViewController.h
//  StarAPP
//
//  Created by xyz on 2016/11/10.
//
//

#import <UIKit/UIKit.h>
#import "RouteCell.h"
@interface RouteManageViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIImageView *routeImage;
@property(nonatomic,strong)UILabel * routeNameLab;
@property(nonatomic,strong)UILabel * routeIPLab;
@property(nonatomic,strong)UIImageView *editImage;

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *centerGrayView;

@property(nonatomic,strong)UILabel * connectDevice;

@property(nonatomic,strong)UITableView * tableView;  //UItableview

@property(nonatomic,strong)NSDictionary * onlineDeviceDic;  //在线设备数


@end
