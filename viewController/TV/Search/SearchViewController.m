//
//  SearchViewController.m
//  StarAPP
//
//  Created by xyz on 16/8/30.
//
//

#import "SearchViewController.h"


@interface SearchViewController ()
{
//    NSInteger historySearchViewHeight;  //搜索历史的高度
    NSMutableArray *  historySearchArr ;
}
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
@synthesize historySearchTableview;
@synthesize historySearchView;
@synthesize historySearchLab;
@synthesize historySearchDelBtn;
- (void)viewDidLoad
{
    [super viewDidLoad];    
//    [self getServiceArray];
    [self loadNav];
    [self initData];
//    self.dataList = [[NSMutableArray alloc]init];
    
//    [self.tableView reloadData];
    self.showData = [USER_DEFAULT objectForKey:@"showData"];
    NSLog(@"self.showData: %@",self.showData);

    NSLog(@"%lu",(unsigned long)[_dataList count]);
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
    
    self.historySearchTableview.dataSource = self;
    self.historySearchTableview.delegate = self;
//    self.tableView.backgroundColor = RGBA(108, 108, 108, 0.15);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    historySearchTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tableView.frame =  CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self.tableView reloadData];

}
-(void)loadNav
{
   
    self.tabBarController.tabBar.hidden = YES;

}
-(void)viewWillAppear:(BOOL)animated
{
    [self loadNav];
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    [searchField becomeFirstResponder];
    searchField.text = nil;
    searchField.backgroundColor =  RGBA(108, 108, 108, 0.3);
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
    
    
    //如果searchDataList完全为空，这里做一次添加
    if (self.dataList == NULL || self.dataList == nil || self.dataList.count == 0) {
        [self getServiceArray];
        NSLog(@"self.dataList原先为空，在这里重新获取一次。但是如果没有控制好获取次数，可能导致出错");
    }
    
    [self historySearchShow];
    
    NSLog(@"historySearchArr: %@",historySearchArr);
//    [historySearchTableview reloadData];
//    [self.tableView reloadData];
    
//    [historySearchView removeFromSuperview];
//    [self.view addSubview:historySearchView];
    
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
            
        
            NSString * LogicName = [NSString stringWithFormat:@"%@  %@",serviceLogic,serviceName];
            
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
    if ([tableView isEqual:self.tableView]) {
        return [_showData count]>0?[_showData count]:0;
    }else if ([tableView isEqual:self.historySearchTableview])
    {
        return historySearchArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *TableSampleIdentifier = @
    "TableSampleIdentifier";
   
    static NSString *historySearchIden = @
    "historycell";
//    historySearchTableview *historycell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    UITableViewCell *historycell = [tableView dequeueReusableCellWithIdentifier:
                             historySearchIden];
//   UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
   
      
        
        
        if ([tableView isEqual:self.historySearchTableview]) {
//        if (!ISEMPTY(historySearchArr)) {
            
            if (historycell == nil){
                historycell = [[UITableViewCell alloc]
                               initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:historySearchIden];
//                historycell.backgroundColor=[UIColor redColor];
//                historycell.tintColor = [UIColor redColor];
                //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x+20, cell.frame.origin.y+20, cell.frame.size.width, cell.frame.size.height-20)];
                //        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
                
                
                //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                [tableView setSeparatorColor:RGBA(193, 193, 193, 1)];
                
        }
            NSLog(@"indexPath.row： %ld",(long)indexPath.row);
            //因为这里展示的数据是倒叙排列的，所以在操作的时候都是 总数 - indexpath.row-1
            //&&&&
//            if (todayNum >0) {
//                if (indexPath.section == 0) {
                    NSDictionary * dataDic = [[NSDictionary alloc]init];
                
                NSInteger XXX ;
                XXX =historySearchArr.count -  indexPath.row -1;
                NSLog(@"XXX:%d",XXX);
                dataDic = historySearchArr[XXX][0];
                    NSString * historyTextString =   [dataDic objectForKey:@"service_name"];
                    NSString * historyLogicString = [dataDic objectForKey:@"service_logic_number"];
                    //historySearchArr.count  -
                    
                    
//                    for (int i = 0; i<data1.count; i++) {
                    
//                        NSString * serviceLogic = [data1[i] objectForKey:@"service_logic_number"]
//                        ;
//                        NSString * serviceName = [data1[i] objectForKey:@"service_name"]
//                        ;
                        if(historyLogicString.length == 1)
                        {
                            historyLogicString = [NSString stringWithFormat:@"00%@",historyLogicString];
                        }
                        else if (historyLogicString.length == 2)
                        {
                            historyLogicString = [NSString stringWithFormat:@"0%@",historyLogicString];
                        }
                        else if (historyLogicString.length == 3)
                        {
                            historyLogicString = [NSString stringWithFormat:@"%@",historyLogicString];
                        }
                        else if (historyLogicString.length > 3)
                        {
                            historyLogicString = [historyLogicString substringFromIndex:historyLogicString.length - 3];
                        }
                        
                        
                        NSString * LogicName = [NSString stringWithFormat:@"%@  %@",historyLogicString,historyTextString];
                    
                    historycell.textLabel.text = LogicName;
            NSLog(@"LogicName : %@ ",LogicName);
//                        [self.dataList addObject:LogicName];
//                    }
//                    historycell.dataDic =
                    return historycell;
                
            
//            }
//            else if (todayNum <= 0) {
//                earilyCell.dataDic = historyArr[historyArr.count -  indexPath.row - 1][0];
//                return earilyCell;
//            }
            
            
//        }
    
        
        
        
//            [historySearchTableview reloadData];
        return historycell;
        
    }
    
    
    if ([tableView isEqual:self.tableView]) {
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
        
        
//        cell.backgroundColor = RGBA(108, 108, 108, 0.01);
    
    
      
    }
        
        if (_showData != nil && _showData.count >0) {
            NSUInteger row = [indexPath row];
            cell.textLabel.text = [_showData objectAtIndex:row];
        }
        
        
//        NSLog(@"2222222222222222222");
//        [self.tableView reloadData];
        return cell;
        
    }
    
    
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger indexForTouch;//这里的indexForTouch 代表点击的数据是数组servie_index下的第几个，从0开始
    NSMutableDictionary * dicCategory = [[NSMutableDictionary alloc]init];
    NSArray *data2  = [[NSArray alloc]init];
    NSDictionary * serviceTouch = [[NSDictionary alloc]init];
 
    if ([tableView isEqual:self.tableView]) {
        //    NSLog(@"---->%@",[[self.LetterResultArr objectAtIndex: indexPath.section]objectAtIndex:indexPath.row]);
        int index1 = [self.dataList indexOfObject:self.showData[indexPath.row]];   //这里判断出是第几个service，下一步寻找这个index存在在那个category中
        
        NSArray * category1 = [self.response objectForKey:@"category"];   //category是所有的类别分类的数据
        
        for (int i = 0; i<category1.count; i++) {   //此时category下有6个分组，第一个分组是3个数据
            NSArray *  service_index = [category1[i] objectForKey:@"service_index"];//service_index是category分类下每个分组中service_index的数据
            for (int y = 0; y<service_index.count; y++) {
                NSLog(@"service_index[y] intValue ：%d",[service_index[y] intValue]);
                if ([service_index[y] intValue] - 1 == index1) {  //// 判断值是否等于行数，如果等于，那么i就是category中的序号，我们取第i个category的service_index数据。
                    
                    indexForTouch = y;    //这里的indexForTouch 代表点击的数据是数组servie_index下的第几个，从0开始
                    //                //获取不同类别下的节目，然后是节目下不同的cell值                10
                    for (int x = 0 ; x<service_index.count; x++) {
                        //
                        //indexCat 代表总的service下第几个
                        int indexCat ;
                        
                        indexCat =[service_index[x] intValue] ;
                        data2 = [self.response objectForKey: @"service" ];
                        NSLog(@"self.response: %@",self.response);
                        NSLog(@"data2--: %@",data2);
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
    }
    else if([tableView isEqual:self.historySearchTableview])
    {
        
//        int index1 = [self.dataList indexOfObject:self.showData[indexPath.row]];
        
//        NSInteger indexTeg = index1;
//        NSInteger indexTeg2 =  historySearchArr.count - index1 - 1;
                NSInteger indexTeg2 =  historySearchArr.count - indexPath.row - 1;
        
//        NSLog(@"indexTeg: %ld",(long)indexTeg);
        NSLog(@"indexTeg2: %ld",(long)indexTeg2);
        NSArray * touchArr = historySearchArr[indexTeg2];
        
        NSLog(@"touchArr：%@",touchArr);
//        [self touchToSee :touchArr];
        
        indexForTouch = [touchArr[2] intValue];
        dicCategory = touchArr [3];
        

    }

    
//    self.tvViewController = [[TVViewController alloc]init];
//    [self.tvViewController touchSelectChannel:index1 diction:dicCategory];
//    NSLog(@"当前点击了 ：%@",self.showData[indexPath.row]  );
    
    //将整形转换为number
    NSNumber * numIndex = [NSNumber numberWithInt:indexForTouch];
    
    NSLog(@"textTwo: %@",dicCategory);
    
    [self addHistorySearch:indexForTouch diction:dicCategory]; //将点击的节目加入搜索历史
    
//    [historySearchTableview reloadData];
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dicCategory,@"textTwo", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    NSLog(@"%lu",(unsigned long)[_dataList count]);
    if (searchText!=nil && searchText.length>0) {
        self.showData= [NSMutableArray array];
        for (NSString *tempStr in _dataList) {
            if ([tempStr rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
                [_showData addObject:tempStr];
                NSLog(@"%lu",(unsigned long)[_showData count]);
            }
        }
        [_tableView reloadData];
        historySearchView.frame =  CGRectMake(0, 64, SCREEN_WIDTH, 0);
        [historySearchView removeFromSuperview];
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
        [historySearchTableview reloadData];
    }
    else
    {
        self.showData = [NSMutableArray arrayWithArray:_dataList];
        
        if (historySearchArr.count >0) {
            historySearchView.frame =  CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.view addSubview:historySearchView ];
            self.tableView.frame = CGRectMake(0, 1500, SCREEN_WIDTH, SCREEN_HEIGHT);
            [_tableView reloadData];
            [historySearchTableview reloadData];
        }else{
            historySearchView.frame =  CGRectMake(0, 64, SCREEN_WIDTH, 0);
            [historySearchView removeFromSuperview];
            self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
            [_tableView reloadData];
            [historySearchTableview reloadData];
        }
      
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

-(void)initData
{
    historySearchView = [[UIView alloc]init];
    historySearchTableview = [[UITableView alloc]init];
    historySearchArr  =   [[USER_DEFAULT objectForKey:@"historySearchData"] mutableCopy];
    
    historySearchLab = [[UILabel alloc]init];
//    historySearchDelBtn = [[UIButton alloc]init];
    historySearchDelBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:historySearchView];
    
}
//搜索历史的展示
-(void)historySearchShow
{
    historySearchArr  =   [[USER_DEFAULT objectForKey:@"historySearchData"] mutableCopy];
    
    [historySearchView removeFromSuperview];
    if (historySearchArr == NULL || historySearchArr == nil || historySearchArr.count == 0) {
        
        historySearchView.frame =  CGRectMake(0, 64, SCREEN_WIDTH, 0);
        [historySearchView removeFromSuperview];
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view addSubview:self.tableView];
    }
    else
    {
        NSLog(@"historySearchArr===:%@",historySearchArr);
        historySearchView.frame =  CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.tableView.frame = CGRectMake(0, 1500, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        historySearchLab.frame = CGRectMake(16, 10, 100, 16);
        
        historySearchLab.text = @"History";
        historySearchLab.textColor = [UIColor grayColor];
        historySearchLab.font = FONT(17);
        [historySearchView addSubview:historySearchLab];
        
        
        
        
        [historySearchDelBtn setImage:[UIImage imageNamed:@"Del"] forState:UIControlStateNormal];
        [historySearchDelBtn addTarget:self action:@selector(deleteAllHistoryBtn) forControlEvents:UIControlEventTouchUpInside];
        
        historySearchDelBtn.frame = CGRectMake(SCREEN_WIDTH - 32, 10, 15, 15);
        
        [historySearchView addSubview:historySearchDelBtn];
        
        
        
        
        historySearchTableview.frame = CGRectMake(0, 36, SCREEN_WIDTH, SCREEN_HEIGHT);
//        self.tableView.frame = CGRectMake(0, 300, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [historySearchTableview reloadData];
        [historySearchView addSubview:historySearchTableview];
        [self.view addSubview:historySearchView];
    }
    
    
    
    
}
//加入搜索历史
-(void)addHistorySearch:(NSInteger)row diction :(NSDictionary *)dic
{
    // 1.获得点击的视频dictionary数据
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    NSLog(@"epgDicToSocket %@",epgDicToSocket);
    // 2. 初始化两个数组存放数据
    //     NSArray * historyArr = [[NSArray alloc]init];
    NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
    //3.获得以前的点击数据
    mutaArray = [[USER_DEFAULT objectForKey:@"historySearchData"]mutableCopy];
    
    //4.将点击的数据加入可变数组
    //此处进行判断看新添加的节目是否曾经添加过
    BOOL addNewData = YES;
    //    if (mutaArray.count == 0) {
    //         [mutaArray addObject:epgDicToSocket];
    //    }
    //    else{
    for (int i = 0; i <mutaArray.count ; i++) {
        //原始数据
        NSString * service_network =  [mutaArray[i][0] objectForKey:@"service_network_id"];
        NSString * service_ts =  [mutaArray[i][0] objectForKey:@"service_ts_id"];
        NSString * service_service =  [mutaArray[i][0] objectForKey:@"service_service_id"];
        NSString * service_tuner =  [mutaArray[i][0] objectForKey:@"service_tuner_mode"];
        NSString * service_logicName =  [mutaArray[i][0] objectForKey:@"service_logic_number"];
        
        //新添加的数据
        NSString * newservice_network =  [epgDicToSocket objectForKey:@"service_network_id"];
        NSString * newservice_ts =  [epgDicToSocket objectForKey:@"service_ts_id"];
        NSString * newservice_service =  [epgDicToSocket objectForKey:@"service_service_id"];
        NSString * newservice_tuner =  [epgDicToSocket objectForKey:@"service_tuner_mode"];
        NSString * newservice_logicName =  [epgDicToSocket objectForKey:@"service_logic_number"];
        
        if ([service_network isEqualToString:newservice_network] && [service_ts isEqualToString:newservice_ts] && [service_tuner isEqualToString:newservice_tuner] && [service_service isEqualToString:newservice_service] && [service_logicName isEqualToString:newservice_logicName]) {
            addNewData = NO;
            
            NSArray * equalArr = mutaArray[i];
            
            [mutaArray removeObjectAtIndex:i];
            [mutaArray  addObject:equalArr];
            
            
            
            break;
        }
        
        
    }
    //    }
    if (addNewData == YES) {
        NSString * seedNowTime = [GGUtil GetNowTimeString];
        NSNumber *aNumber = [NSNumber numberWithInteger:row];
        NSArray * seedNowArr = [NSArray arrayWithObjects:epgDicToSocket,seedNowTime,aNumber,dic,nil];
        
        
        if (seedNowArr.count > 0) {
            [mutaArray addObject:seedNowArr];
            
        }else
        {
            NSAssert(seedNowArr != NULL, @"提示: 此时seedNowArr.count < 0,证明其为空");
        }
        
        
        //     [mutaArray addObject:epgDicToSocket];
    }
    
    
    
    //5。两个数组相加
    //    [ mutaArray addObject:historyArr];
    NSArray *myArray = [NSArray arrayWithArray:mutaArray];
    [USER_DEFAULT setObject:myArray forKey:@"historySearchData"];
    
    NSLog(@"myArray--: %@",myArray);
    
    //    NSLog(@"myarray:%@",myArray[3]);
    //    NSLog(@"myarray:%@",myArray[2]);
    //    NSLog(@"myarray:%@",myArray[2][0]);
    
//    MEViewController * meview = [[MEViewController alloc]init];
//    [meview viewDidAppear:YES];
//    [meview viewDidLoad];

    

}
-(void)deleteAllHistoryBtn
{
    NSLog(@"historySearchArr11-- :%@",historySearchArr);
    
    [historySearchArr removeAllObjects];
    [USER_DEFAULT setObject:[historySearchArr copy] forKey:@"historySearchData"];
    NSLog(@"historySearchArr22-- :%@",historySearchArr);
    
    [historySearchTableview reloadData];
    
     historySearchView.frame =  CGRectMake(0, 64, SCREEN_WIDTH, 0);
    [historySearchView removeFromSuperview];
     self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
}

@end
