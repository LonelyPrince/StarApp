//
//  HistoryViewController.h
//  StarAPP
//
//  Created by xyz on 2016/10/27.
//
//

#import <UIKit/UIKit.h>
#import "HistoryCell.h"
#import "EarilyCell.h"
@interface HistoryViewController : UIViewController<UITabBarDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
//@property(nonatomic,strong)UIView * separatorLine;
@property(nonatomic,strong)TVViewController* tvViewController;
@end
