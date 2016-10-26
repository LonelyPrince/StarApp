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
//{
//    NSArray *data;
//    NSArray *filterData;
//    UISearchDisplayController *searchDisplayController;
//}
-(NSMutableArray *)getServiceArray;
@end
