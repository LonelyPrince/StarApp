//
//  MonitorViewController.h
//  StarAPP
//
//  Created by xyz on 16/8/29.
//
//

#import <UIKit/UIKit.h>
#import "MonitorCell.h"
#import "SocketUtils.h"

@interface MonitorViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)void(^blocktest)(NSDictionary * dic);
@property(nonatomic,strong) UIScrollView * scrollView;
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) UIView * colorView;
@property(nonatomic,strong) UIImageView *colorImageView;
@property(nonatomic,strong) NSDictionary *TVhttpDic;
@property(nonatomic,strong) NSMutableDictionary *monitorTableDic;
@property(nonatomic,strong) NSMutableArray *monitorTableArr;
@property(nonatomic,strong) SocketUtils *socketUtils;


@end
