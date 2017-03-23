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


//loadnum
@property(nonatomic,strong) UILabel * liveNumLab;
@property(nonatomic,strong) UILabel * recoderLab;
@property(nonatomic,strong) UILabel * timeShiftLab;
@property(nonatomic,strong) UILabel * distributeLab;
@property(nonatomic,strong) UILabel * liveNum_Lab;
@property(nonatomic,strong) UILabel * recoder_Lab;
@property(nonatomic,strong) UILabel * timeShift_Lab;
@property(nonatomic,strong) UILabel * distribute_Lab;


//loadColor Cicle
@property(nonatomic,strong) UIImageView * cicleClearImageView;
@property(nonatomic,strong) UIImageView * cicleBlueImageView;
@property(nonatomic,strong) UIImageView * nineImage;
@property(nonatomic,strong) UIImageView * numImage;
@property(nonatomic,strong) UIImageView * labImage;

@property(nonatomic,assign) BOOL isRefreshScroll;
@end
