//
//  MEViewController.h
//  starApp
//
//  Created by xyz on 16/8/1.
//  Copyright © 2016年 xyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingCell.h"
#import "RouteSetting.h"
#import "HistoryViewController.h"
#import "LinkViewController.h"
@interface MEViewController : UIViewController<UITabBarDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) RouteSetting * routeView;
@property(nonatomic,strong) HistoryViewController * historyView;
@property(nonatomic,strong) LinkViewController* linkView;
@end
