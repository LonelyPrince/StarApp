//
//  SearchViewController.m
//  StarAPP
//
//  Created by xyz on 16/8/30.
//
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end
//UITableView* tableView;
//// 保存原始表格数据的NSArray对象。
//NSArray * tableData;
//// 保存搜索结果数据的NSArray对象。
//NSArray* searchData;
//// 是否搜索变量
//bool isSearch;
//
//
//@implementation SearchViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//}
@implementation SearchViewController
@synthesize dataList = _dataList;
@synthesize showData = _showData;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self getServiceArray];
   
    
//    self.dataList = [[NSMutableArray alloc]init];
    
    [self.tableView reloadData];
    self.showData = [USER_DEFAULT objectForKey:@"showData"];
//    self.showData  = [NSArray arrayWithObjects:@"Java讲义",
//                      @"轻量级Java EE企业应用实战",
//                      @"Android讲义",
//                      @"Ajax讲义",
//                      @"HTML5/CSS3/JavaScript讲义",
//                      @"iOS讲义",
//                      @"XML讲义",
//                      @"经典Java EE企业应用实战"
//                      @"Java入门与精通",
//                      @"Java基础教程",
//                      @"学习Java",
//                      @"Objective-C基础" ,
//                      @"Ruby入门与精通",
//                      @"iOS开发教程" ,  nil];
    NSLog(@"%d",[_dataList count]);
//    self.showData = [NSMutableArray arrayWithArray:_dataList];
    
    [self.searchBar setPlaceholder:@"Search"];
    
    // 显示Cancel按钮
    self.searchBar.showsCancelButton = true;
    // 设置代理
    self.searchBar.delegate = self;
    
//    self.searchBar.layer.cornerRadius = 15;
//    self.searchBar.layer.masksToBounds = YES;
    
//    self.searchBar.backgroundColor = [UIColor whiteColor];
       [_searchBar setBackgroundColor:[UIColor redColor]];
    
    self.searchBar.backgroundImage = [UIImage imageNamed:@"white"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
self.tableView.backgroundColor = RGBA(108, 108, 108, 0.15);
    
    
    [self.tableView reloadData];

}

-(void)viewWillAppear:(BOOL)animated
{
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    
    searchField.backgroundColor =  RGBA(108, 108, 108, 0.2);
    if (searchField) {
        
//        [searchField setBackgroundColor:RGBA(108, 108, 108, 0.2)];
        
        
        searchField.layer.cornerRadius = 14.0f;
        
//        searchField.layer.borderColor = [UIColor colorWithRed:247/255.0 green:75/255.0 blue:31/255.0 alpha:1].CGColor;
        
//        searchField.layer.borderWidth = 1;
        
        searchField.layer.masksToBounds = YES;
        
        searchField.textColor = RGBA(248, 248, 248, 1);
        
    }
    
    for(UIView *view in  [[[self.searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
//            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            cancel.tintColor = [UIColor blackColor];
            
        }
    }
    
    
}
//获取table
-(NSMutableArray *) getServiceArray
{
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
    
    
    [request startAsynchronous];
    
    WEAKGET
    [request setCompletionBlock:^{
       self.response = httpRequest.responseString.JSONValue;
        //        NSLog(@"response = %@",response);
        NSArray *data1 = self.response[@"service"];
        if (!isValidArray(data1) || data1.count == 0){
            return ;
        }
       
        
        for (int i = 0; i<data1.count; i++) {

            NSString * serviceLogic = [data1[i] objectForKey:@"service_logic_number"]
            ;
            NSString * serviceName = [data1[i] objectForKey:@"service_name"]
            ;
            if(serviceLogic.length == 1)
            {
                serviceLogic = [NSString stringWithFormat:@"00%@",serviceLogic];
            }
            else if (serviceLogic.length == 2)
            {
                serviceLogic = [NSString stringWithFormat:@"0%@",serviceLogic];
            }
            else if (serviceLogic.length == 3)
            {
                serviceLogic = [NSString stringWithFormat:@"%@",serviceLogic];
            }
            else if (serviceLogic.length > 3)
            {
                serviceLogic = [serviceLogic substringFromIndex:serviceLogic.length - 3];
            }
            
        
            NSString * LogicName = [NSString stringWithFormat:@"%@ %@",serviceLogic,serviceName];
            
            [self.dataList addObject:LogicName];
        }
        
        
       
        
        [self.tableView reloadData];
        
    }];
    
    [self.tableView reloadData];
    return self.dataList ;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_showData count]>0?[_showData count]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @
    "TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    if (_showData != nil && _showData.count >0) {
        NSUInteger row = [indexPath row];
        cell.textLabel.text = [_showData objectAtIndex:row];
    }
    NSLog(@"2222222222222222222");
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary * dicCategory = [[NSMutableDictionary alloc]init];
    NSArray *data2  = [[NSArray alloc]init];
    NSDictionary * serviceTouch = [[NSDictionary alloc]init];
    //    NSLog(@"---->%@",[[self.LetterResultArr objectAtIndex: indexPath.section]objectAtIndex:indexPath.row]);
    int index1 = [self.dataList indexOfObject:self.showData[indexPath.row]];
    
    NSLog(@"%d",index1);
    NSArray * category1 = [self.response objectForKey:@"category"];
    for (int i = 0; i<category1.count; i++) {
        NSArray *  service_index = [category1[i] objectForKey:@"service_index"];
        for (int y = 0; y<service_index.count; y++) {
            if ([service_index[y] intValue] == index1) {  //// 判断值是否等于行数

            
//                //获取不同类别下的节目，然后是节目下不同的cell值                10
                for (int x = 0 ; x<service_index.count; x++) {
//
                    int indexCat ;
                    //   NSString * str;
                    indexCat =[service_index[x] intValue];
                     data2 = self.response[@"service"];
                      serviceTouch  = data2[indexCat-1];
//                    //cell.tabledataDic = self.serviceData[indexCat -1];
//
                    [dicCategory setObject:serviceTouch forKey:[NSString stringWithFormat:@"%d",x]];
//                    [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起
//                    
//                    
                }
            
            
            
            
            }
        }
    }
    
    self.tvViewController = [[TVViewController alloc]init];
    [self.tvViewController touchSelectChannel:index1 diction:dicCategory];
    NSLog(@"当前点击了 ：%@",self.showData[indexPath.row]  );

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    NSLog(@"%i",[_dataList count]);
    if (searchText!=nil && searchText.length>0) {
        self.showData= [NSMutableArray array];
        for (NSString *tempStr in _dataList) {
            if ([tempStr rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
                [_showData addObject:tempStr];
                NSLog(@"%d",[_showData count]);
            }
        }
        [_tableView reloadData];
    }
    else
    {
        self.showData = [NSMutableArray arrayWithArray:_dataList];
        [_tableView reloadData];
    }
    
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchBar:self.searchBar textDidChange:nil];
    [_searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchBar:self.searchBar textDidChange:nil];
    [_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
