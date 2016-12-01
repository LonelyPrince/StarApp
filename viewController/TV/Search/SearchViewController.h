//
//  SearchViewController.h
//  StarAPP
//
//  Created by xyz on 16/8/30.
//
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *dataList;
    NSMutableArray *showData;
}
@property (retain, nonatomic) NSMutableArray *showData;
@property (retain, nonatomic) NSMutableArray *dataList;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) NSDictionary *response;
@property (retain, nonatomic) TVViewController *tvViewController;

@property(strong,nonatomic) UITableView * historySearchTableview;
@property(strong,nonatomic) UIView * historySearchView;
@property(strong,nonatomic) UILabel * historySearchLab;
@property(strong,nonatomic) UIButton * historySearchDelBtn;
//@property (retain, nonatomic) UITextField *searchField;
//{
//    NSArray *data;
//    NSArray *filterData;
//    UISearchDisplayController *searchDisplayController;
//}
-(NSMutableArray *)getServiceArray;
@end
