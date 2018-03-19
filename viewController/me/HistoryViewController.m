//
//  HistoryViewController.m
//  StarAPP
//
//  Created by xyz on 2016/10/27.
//
//

#import "HistoryViewController.h"

//#define  separatorViewTag  10456

#define ONEDAY 86400
//#define ONEDAY    5//86400  //99999999 //81000
@interface HistoryViewController ()
{
    UIButton * editButton;
    NSMutableArray * dataArray;
    NSMutableArray * selectedArray;
    NSMutableArray * historyArr;
    
    UIBarButtonItem *myButton;
    int todayNum;
    int earilyNum;
    
    BOOL delegateBtn ;   //是否是删除按钮
    BOOL isAllSelected ; //是否被选择
    UIButton * redDeleteBtn;
    
    UIView * noDataSourceView;
    NSString * deviceString;
    //
    //    UIView *customSeparatorView;
    //    CGFloat separatorHight;
    //
    
}
//@property (nonatomic,weak)UIView *originSeparatorView;
@end

@implementation HistoryViewController
@synthesize tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden  = YES;
    deviceString = [GGUtil deviceVersion];
    NSString * HistoryLabel = NSLocalizedString(@"HistoryLabel", nil);
    self.title = HistoryLabel;
    [tableView reloadData];
    historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];
    
    //
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.allowsSelection = YES;
    self.tableView.allowsMultipleSelection = NO;
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    
    
    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.scrollsToTop = NO;
    
    //    [self setTableViewHeaderView];
    [self.view addSubview:tableView];
    
    selectedArray = [[NSMutableArray alloc]init]; //非ARC模式不能使用静态方法创建全局变量
    
    todayNum = 0;
    earilyNum = 0;
    for (int i = 0; i<historyArr.count; i++) {
        int seedTime =[historyArr[historyArr.count - i - 1][1]intValue];
        NSLog(@"seedTime :%d",seedTime);
        int diftime =[[GGUtil GetNowTimeString]intValue] - seedTime; // [historyArr[historyArr.count - i - 1][1]intValue];
        if (diftime >ONEDAY) {
            earilyNum++;
        }
        else{
            todayNum++;
        }
    }
    
    [self loadBarRightItem];
    isAllSelected = NO;  //此时“All” 按钮是NO，证明没有选中全部
    [self initData];
    
}

-(void)initData
{
    noDataSourceView = [[UIView alloc]init];
    UIImageView * noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 505/2)/2, 120, 505/2, 149)];
    noDataImageView.image = [UIImage imageNamed:@"无历史"];
    //调用上面的方法，获取 字体的 Size
    
    NSString * MLNoViewingHistory = NSLocalizedString(@"MLNoViewingHistory", nil);
    CGSize size = [self sizeWithText: MLNoViewingHistory font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UILabel * noDataLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+10, size.width, size.height)];
    noDataLab.text = MLNoViewingHistory;
    noDataLab.font = FONT(15);
    noDataLab.textColor = [UIColor grayColor];
    
    [noDataSourceView addSubview:noDataImageView];
    [noDataSourceView addSubview:noDataLab];
    
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}



-(void)viewWillAppear:(BOOL)animated
{
    
    [self TVViewAppear];
    
    
}
-(void)TVViewAppear
{
    [USER_DEFAULT setObject:@"NO" forKey:@"jumpFormOtherView"];//为TV页面存储方法
}

#pragma mark -- 加载右上角的barItem，barItem的图片是一张“垃圾桶”的形状
-(void)loadBarRightItem
{
    delegateBtn = YES;
    myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Del"] style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAllBtn)];
    self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
    
    self.navigationItem.rightBarButtonItem = myButton;
}
#pragma mark - 点击“垃圾桶”按钮，进入删除全部的模式
-(void)deleteAllBtn
{
    [tableView reloadData];
//    [self testaaaa];
    if (self.tableView.editing) {
        NSLog(@"此时编辑状态，不能点击");
    }else
    {
        isAllSelected = NO; // “All” 按钮取消选中状态
        [self loadAllDeleteBtn];  //添加左上角“ALL”按钮
        if (delegateBtn == YES) {
            delegateBtn = NO;
            [self.tableView setEditing:YES animated:YES];
            //        [self setEditing:!self.editing animated:YES];
            myButton = nil;
            NSString * CancelLabel = NSLocalizedString(@"CancelLabel", nil);
            myButton = [[UIBarButtonItem alloc]initWithTitle:CancelLabel style:UIBarButtonItemStyleBordered target:self action:@selector(deleteBtnCancel)];
            self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
            
            self.navigationItem.rightBarButtonItem = myButton;
        }
        if(historyArr.count == 0 || historyArr == NULL)
        {
            [self deleteBtnCancelAndNOHistory];  //如果历史被删除完全了,显示无历史图片
        }
        
        NSLog(@"删除所有");
    
    }
   
}
#pragma  mark -- 右上角 “cancel” 按钮点击事件
-(void)deleteBtnCancel
{
    [tableView reloadData];
       isAllSelected = NO; // “All” 按钮取消选中状态
    
    [self loadAllDeleteBtn];
    delegateBtn = YES;
    [self.tableView setEditing:NO animated:YES];
    //    [self setEditing:!self.editing animated:YES];
    myButton = nil;
    myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Del"] style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAllBtn)];
    self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
    
    self.navigationItem.rightBarButtonItem = myButton;
    NSLog(@"取消删除");
    [selectedArray removeAllObjects]; //删除完或者取消删除之后
}
#pragma mark - 如果历史被删除完全了
-(void)deleteBtnCancelAndNOHistory
{
    [self loadAllDeleteBtn];
    delegateBtn = YES;
    [self.tableView setEditing:NO animated:YES];
    //    [self setEditing:!self.editing animated:YES];
    myButton = nil;
    myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Del"] style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAllBtn)];
    self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
    
    self.navigationItem.rightBarButtonItem = myButton;
    self.navigationItem.rightBarButtonItem=nil;  //勇于没有数据之后的隐藏
    NSLog(@"取消删除");
    
    [selectedArray removeAllObjects]; //删除完或者取消删除之后
    
}
#pragma mark - 添加左上角“ALL”按钮
/**
 *左侧删除的all按钮
 */
-(void)loadAllDeleteBtn
{
    if (self.tableView.editing == NO) {
        
        NSString * MLAll = NSLocalizedString(@"MLAll", nil);
        
        UIBarButtonItem *allDelegateBtn = [[UIBarButtonItem alloc] initWithTitle:MLAll style:UIBarButtonItemStyleBordered target:self action:@selector(AllDeleteClick)];
        self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        
        self.navigationItem.leftBarButtonItem = allDelegateBtn;
        
        
        self.tabBarController.tabBar.hidden  = YES;
        
        
        [self loadRedDelete];
        
        
        
        
    } else if (self.tableView.editing ==YES)
    {
        UIBarButtonItem *leftBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftBackBtnClick)];
        self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        
        self.navigationItem.leftBarButtonItem = leftBackBtn;
        
        self.tabBarController.tabBar.hidden = YES;
        
        
        [redDeleteBtn removeFromSuperview];
    }
    
}
#pragma  mark - 加载底部红色删除按钮
-(void)loadRedDelete
{
    
    redDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redDeleteBtn.frame = CGRectMake(0, SCREEN_HEIGHT-51, SCREEN_WIDTH, 51);
    redDeleteBtn.backgroundColor = [UIColor redColor];
    
    NSString * DeleteLabel = NSLocalizedString(@"DeleteLabel", nil);
    [redDeleteBtn setTitle:DeleteLabel forState:UIControlStateNormal];
    [redDeleteBtn addTarget:self action:@selector(deleteSeletions) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redDeleteBtn];
    
}
#pragma mark --红色的删除按钮点击删除
-(void)deleteSeletions
{//selectedArray 被选中的数组
    
    isAllSelected = NO; // “All” 按钮取消选中状态
    
    int eairlyNameByReduce = 0;            //早期历史
    int todayNameByReduce = 0;          //今天的历史
    int eairlyNameByReduceForOnly = 0;   //只有早期历史
    
    int lastTodayReduceIndex = 0;    //保存上一个删除的today节目row值
    int lastEairlyReduceIndex = 0;    //保存上一个删除的eairly节目row值
    
    int lastByReduceNum = 0;        //截止到上一次一共删除了多少数据，因为如果上一次删除的数据在这次要删除的数据前面，那么每删除一次，indexpath.row 便会往前缩进一个
    int lastEairlyByReduceNum = 0;
    
    NSMutableArray * onlyHaveSectionOneArr = [[NSMutableArray alloc]init];
    NSMutableArray * HaveSectionOneAndTwoArr = [[NSMutableArray alloc]init];
    if (selectedArray.count == 0) {
        NSLog(@"selectedArray  的 数量为空");
    }
    else{
        //此处多选删除选中的
        [self.tableView reloadData];
        [tableView beginUpdates];
        
        
        NSLog(@"selectedArray11 %@",selectedArray);
        //刷新
        [tableView deleteRowsAtIndexPaths:selectedArray withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"tableView11 %@",tableView);
        NSLog(@"selectedArray22 %@",selectedArray);
        for (int i = 0; i< selectedArray.count; i++) {
            
            NSIndexPath * indexpath1 = selectedArray[i];
            
            NSIndexPath * lastIndexpath;
         
            //存储上一个信息
            if(indexpath1.section == 0)
            {
                NSNumber * tempNumber = [NSNumber numberWithInteger:indexpath1.row];
                [onlyHaveSectionOneArr addObject:tempNumber];
                if (i == 0) {
                    //证明是第一个要删除的，保存下信息
                    //                lastReduceIndex = indexpath1.row;
                }
                if (i  < selectedArray.count && i > 0) {
                    lastIndexpath = selectedArray[i - 1];    //趁上一个信息还没删除前保存上一个信息
                    lastTodayReduceIndex = lastIndexpath.row;
                    
                }else
                {
                    // 没有下一个,再就越界了
                }
            }
            else
            {
                NSNumber * tempNumber = [NSNumber numberWithInteger:indexpath1.row];
                [HaveSectionOneAndTwoArr addObject:tempNumber];
//                if (indexpath1.row == 0) {
//                    //证明是第一个要删除的，保存下信息
//                    //                lastReduceIndex = indexpath1.row;
//                }
//                if (indexpath1.row  < selectedArray.count && indexpath1.row > 0) {
////                    lastIndexpath = selectedArray[i - 1];    //趁上一个信息还没删除前保存上一个信息
////                    lastEairlyReduceIndex = lastIndexpath.row;
//                    
//                }else
//                {
//                    // 没有下一个,再就越界了
//                }
            }
   
            
            
            
            if(indexpath1.section == 0)
            {
                
               
                
                
                
                
                
                if (todayNum > 0) {   //如果今天的数量大于0
                    todayNum = todayNum-1;
                    NSLog(@"historyArr.count3 %lu",(unsigned long)historyArr.count);
                    NSLog(@"indexpath1.row %ld",(long)indexpath1.row);
                    
                    //做倒序删除==
                    NSMutableArray* reversedArrayToday = [[historyArr reverseObjectEnumerator] allObjects];
                   
                    
                    if (i == 0) {
                        [reversedArrayToday removeObjectAtIndex:indexpath1.row];
                    }else
                    {
                        
                        int numsBiggerThanNowIndex = [self calculateNumsBiggerThanNowRow:onlyHaveSectionOneArr NowIndexPath:indexpath1];
                        if (numsBiggerThanNowIndex) {
                            
                            NSLog(@"吱吱吱3 ： %ld",(long)indexpath1.row - lastByReduceNum - 1);
                            NSLog(@" numsBiggerThanNowIndex %d",numsBiggerThanNowIndex);
                            [reversedArrayToday removeObjectAtIndex:indexpath1.row - numsBiggerThanNowIndex];
                            
                            lastByReduceNum = lastByReduceNum + 1 ;
                        }else
                        {
                        
//                            if (reversedArrayToday.count < indexpath1.row - todayNameByReduce ) {
//                                [tableView endUpdates];
//                                return;  //防止删除时数组数量不对称的bug
//                            }else
//                            {
                                [reversedArrayToday removeObjectAtIndex:indexpath1.row ];
//                            }
                        }
                        
                        
                        
                    
                      
                    }
                    
                        
                    
                    
                    
                    
                    
                  
                    
                    //                    [historyArr removeObjectAtIndex:(historyArr.count -  indexpath1.row - 1 +i)];
                    [historyArr removeAllObjects];
                    historyArr = [[reversedArrayToday reverseObjectEnumerator] allObjects]; //先删除，再赋值
                    //做倒序删除==
                    [USER_DEFAULT setObject:[historyArr copy] forKey:@"historySeed"];
                    
                    //                    NSArray * abcd =[USER_DEFAULT objectForKey:@"historySeed"];
                    //                    NSLog(@"historyArr33 %@",historyArr);
                    if(todayNum == 0)
                    {
                        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexpath1.section] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    
//                    todayNameByReduce = todayNameByReduce +1;
                }
                else   //只有早期的历史，没有今天的历史
                {
                    NSLog(@"historyArr.count1 %d",historyArr.count);
                    //                    [historyArr removeObjectAtIndex:(earilyNum -  indexpath1.row -1+i)];
                    //做倒序删除==
                    NSMutableArray* reversedArrayToday = [[historyArr reverseObjectEnumerator] allObjects];
                    
                    

                    if (i == 0) {
                        [reversedArrayToday removeObjectAtIndex:indexpath1.row];
                    }else
                    {
                        int numsBiggerThanNowIndex = [self calculateNumsBiggerThanNowRow:onlyHaveSectionOneArr NowIndexPath:indexpath1];
                        if (numsBiggerThanNowIndex) {
                            
                            NSLog(@"吱吱吱2 ： %ld",(long)indexpath1.row - lastByReduceNum - 1);
                            NSLog(@" numsBiggerThanNowIndex %d",numsBiggerThanNowIndex);
                            [reversedArrayToday removeObjectAtIndex:indexpath1.row - numsBiggerThanNowIndex ];
                            
                            lastByReduceNum = lastByReduceNum + 1 ;
                        }else
                        {
                            
                            //                            if (reversedArrayToday.count < indexpath1.row - todayNameByReduce ) {
                            //                                [tableView endUpdates];
                            //                                return;  //防止删除时数组数量不对称的bug
                            //                            }else
                            //                            {
                            [reversedArrayToday removeObjectAtIndex:indexpath1.row ];
                            //                            }
                        }
                        
                        
                        
                        
                        
                    }
//                    if (reversedArrayToday.count < indexpath1.row - eairlyNameByReduceForOnly ) {
//                        [tableView endUpdates];
//                        return;  //防止删除时数组数量不对称的bug
//                    }else
//                    {
//                        [reversedArrayToday removeObjectAtIndex:indexpath1.row - eairlyNameByReduceForOnly];
//                    }
                    
                    
                    
                    
                    [historyArr removeAllObjects];
                    historyArr = [[reversedArrayToday reverseObjectEnumerator] allObjects]; //先删除，再赋值
                    //做倒序删除==
                    earilyNum = earilyNum-1;
                    [USER_DEFAULT setObject:[historyArr copy] forKey:@"historySeed"];
                    
                    
                    if(earilyNum == 0)
                    {
                        [tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    eairlyNameByReduceForOnly = eairlyNameByReduceForOnly +1;
                    
                }
                
                
                
            }
            else //section =1
            {
                //与上面方法类似，首先单独提取出来一个eaily
                NSMutableArray * eairlyHistoryArr = [[historyArr subarrayWithRange:NSMakeRange(0, earilyNum)] mutableCopy];
                
                
                
                
                
                
                if (earilyNum > 0) {   //如果今天的数量大于0
                    earilyNum = earilyNum-1;
                    NSLog(@"historyArr.count3 %lu",(unsigned long)eairlyHistoryArr.count);
                    NSLog(@"indexpath1.row %ld",(long)indexpath1.row);
                    
                    //做倒序删除==
                    NSMutableArray* reversedArrayEairly = [[eairlyHistoryArr reverseObjectEnumerator] allObjects];
                    
                    
                    if (indexpath1.row == 0) {
                        [reversedArrayEairly removeObjectAtIndex:indexpath1.row];
                    }else
                    {
                        
                        int numsBiggerThanNowIndex = [self calculateNumsBiggerThanNowRow:HaveSectionOneAndTwoArr NowIndexPath:indexpath1];
                        if (numsBiggerThanNowIndex) { //需要注意修改
                            
                            NSLog(@"吱吱吱1 ： %ld",(long)indexpath1.row - lastEairlyByReduceNum - 1);
                            NSLog(@" numsBiggerThanNowIndex %d",numsBiggerThanNowIndex);
                            [reversedArrayEairly removeObjectAtIndex:indexpath1.row - numsBiggerThanNowIndex ];
                            
                            lastEairlyByReduceNum = lastEairlyByReduceNum + 1 ;
                        }else
                        {
                            
                            //                            if (reversedArrayToday.count < indexpath1.row - todayNameByReduce ) {
                            //                                [tableView endUpdates];
                            //                                return;  //防止删除时数组数量不对称的bug
                            //                            }else
                            //                            {
                            [reversedArrayEairly removeObjectAtIndex:indexpath1.row ];
                            //                            }
                        }
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    //                    [historyArr removeObjectAtIndex:(historyArr.count -  indexpath1.row - 1 +i)];
                    [eairlyHistoryArr removeAllObjects];
                    eairlyHistoryArr = [[reversedArrayEairly reverseObjectEnumerator] allObjects]; //先删除，再赋值
                    
                    
                    [historyArr replaceObjectsInRange:NSMakeRange(0,earilyNum + 1 ) withObjectsFromArray:[eairlyHistoryArr copy]];
                    
                    
                    //做倒序删除==
                    [USER_DEFAULT setObject:[historyArr copy] forKey:@"historySeed"];
                    
                    
                    if(earilyNum == 0)
                    {
                        [tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    
                    //                    todayNameByReduce = todayNameByReduce +1;
                }
                
                
                
                
                
//                NSLog(@"earilyNum %d",earilyNum);
//                NSLog(@"indexpath1.row %d",indexpath1.row);
//                NSInteger removeNum = earilyNum  - indexpath1.row -1 + eairlyNameByReduce;
//                NSLog(@"removeNum %d",removeNum);
//                NSLog(@"historyArr.count2 %d",historyArr.count);
//                if (historyArr.count < removeNum ) {
//                    [tableView endUpdates];
//                    return;  //防止删除时数组数量不对称的bug
//                }else
//                {
//                    [historyArr removeObjectAtIndex:removeNum];
//                }
//                earilyNum = earilyNum -1;
//                [USER_DEFAULT setObject:[historyArr copy] forKey:@"historySeed"];
//                
//                if(earilyNum == 0)
//                {
//                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
//                }
//                eairlyNameByReduce = eairlyNameByReduce +1;
            }
            
            //        if (historyArr.count == 0)
            //
            //        {
            //
            //            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexpath1.section] withRowAnimation:UITableViewRowAnimationLeft];
            ////                       deleteSections:[NSIndexSet
            ////                                       indexSetWithIndex:indexPath.section]
            ////                     withRowAnimation:UITableViewRowAnimationLeft];
            //
            //        }
            
        }
        
        
        [tableView endUpdates];
        [tableView reloadData];
        
        [selectedArray removeAllObjects]; //删除完之后
        [onlyHaveSectionOneArr  removeAllObjects];
        [HaveSectionOneAndTwoArr removeAllObjects];
        
        
      /////////============
        [tableView reloadData];
        isAllSelected = NO; // “All” 按钮取消选中状态
        
        [self loadAllDeleteBtn];
        delegateBtn = YES;
        [self.tableView setEditing:NO animated:YES];
        //    [self setEditing:!self.editing animated:YES];
        myButton = nil;
        myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Del"] style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAllBtn)];
        self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        
        self.navigationItem.rightBarButtonItem = myButton;
        NSLog(@"取消删除");
        [selectedArray removeAllObjects]; //删除完或者取消删除之后
        
        
        
            UIBarButtonItem *leftBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftBackBtnClick)];
            self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
            
            self.navigationItem.leftBarButtonItem = leftBackBtn;
            
            self.tabBarController.tabBar.hidden = YES;
            
            
            [redDeleteBtn removeFromSuperview];
        
    }
    
    
//    double delayInSeconds = 0.5;
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, mainQueue, ^{
//
        //获得删除的数量
    if(historyArr.count == 0 || historyArr == NULL)
    {
        delegateBtn = YES;
        [self.tableView setEditing:NO animated:YES];
        //    [self setEditing:!self.editing animated:YES];
        myButton = nil;
        myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Del"] style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAllBtn)];
        self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        
        self.navigationItem.rightBarButtonItem = myButton;
        self.navigationItem.rightBarButtonItem=nil;  //勇于没有数据之后的隐藏
        NSLog(@"取消删除");
        
        [selectedArray removeAllObjects]; //删除完或者取消删除之后
    }else
    {
        NSString * DeleteLabel = NSLocalizedString(@"DeleteLabel", nil);
        [redDeleteBtn setTitle:[NSString stringWithFormat:DeleteLabel] forState:UIControlStateNormal];
        
        if(historyArr.count == 0 || historyArr == NULL)
        {
            [self deleteBtnCancelAndNOHistory];
        }
    }
    
//
//    });
   
}

#pragma mark - “ALL”按钮点击
/**
 *左侧删除的all 按钮全选事件
 */
-(void)AllDeleteClick //点击all 按钮响应的事件
{   //全选
    if (isAllSelected == NO) {
        [selectedArray removeAllObjects];
        isAllSelected = YES;
        for (int i = 0; i<historyArr.count; i++) {
            
            if (todayNum>0&&earilyNum>0) {
                
                if (i< todayNum) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    
                    
                    if ([self.tableView numberOfRowsInSection:0] > i ) {
                       
                        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                        
                        //添加到删除数组
                        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                        [selectedArray addObject:path];

                    }else
                    {
                        NSLog(@" 1 越界了，会报错 %ld %d",(long)[self.tableView numberOfRowsInSection:0],i);
                    }
                    
                    
                    
                }
                else
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i -todayNum inSection:1];
//                    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                    
                    if ([self.tableView numberOfRowsInSection:1] > i - todayNum ) {
                        
                         [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                        
                        //添加到删除数组
                        NSIndexPath *path = [NSIndexPath indexPathForRow:i -todayNum inSection:1];
                        [selectedArray addObject:path];
                    }else
                    {
                        NSLog(@" 2 越界了，会报错 %ld %d todayNUm :%d",(long)[self.tableView numberOfRowsInSection:1], i , todayNum);
                    }
                    
                   
                }
                
                
                
            }else if (todayNum==0&&earilyNum>0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                
                if ([self.tableView numberOfRowsInSection:0] > i  ) {
                    
                    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                    
                    //添加到删除数组
                    [selectedArray addObject:indexPath];
                }else
                {
                    NSLog(@" 3 越界了，会报错 %ld %d ",(long)[self.tableView numberOfRowsInSection:0], i );
                }
                
                
            }else if (todayNum>0&&earilyNum==0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                
                if ([self.tableView numberOfRowsInSection:0] > i  ) {
                    
                    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                    
                    //添加到删除数组
                    [selectedArray addObject:indexPath];
                }else
                {
                    NSLog(@" 4 越界了，会报错 %ld %d ",(long)[self.tableView numberOfRowsInSection:0], i );
                }
                
               
            }
            else if (todayNum==0&&earilyNum==0) {
                [self.view addSubview:noDataSourceView];
                myButton = nil;
                self.navigationItem.rightBarButtonItem=nil;
            }
            
        }
    }
    else  //取消全选
    {
        isAllSelected = NO;
        for (int i = 0; i<historyArr.count; i++) {
            
            if (todayNum>0&&earilyNum>0) {
                
                if (i< todayNum) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                    if ([self.tableView numberOfRowsInSection:0] > i  ) {
                        
                        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                        
                        //添加到删除数组
                        [selectedArray removeObject:indexPath];
                    }else
                    {
                        NSLog(@" 5 越界了，会报错 %ld %d ",(long)[self.tableView numberOfRowsInSection:0], i );
                    }
                    
                    
                }
                else
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i -todayNum inSection:1];
//                    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    if ([self.tableView numberOfRowsInSection:1] > i - todayNum  ) {
                        
                        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                        
                        //添加到删除数组
                        [selectedArray removeObject:indexPath];
                    }else
                    {
                        NSLog(@" 6 越界了，会报错 %ld %d today %d",(long)[self.tableView numberOfRowsInSection:1], i ,todayNum);
                    }
                    
                  
                }
                
                
                
            }else if (todayNum==0&&earilyNum>0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                if ([self.tableView numberOfRowsInSection:0] > i  ) {
                    
                    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                    //添加到删除数组
                    [selectedArray removeObject:indexPath];
                }else
                {
                    NSLog(@" 7 越界了，会报错 %ld %d ",(long)[self.tableView numberOfRowsInSection:0], i );
                }
                
               
            }else if (todayNum>0&&earilyNum==0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                
                if ([self.tableView numberOfRowsInSection:0] > i  ) {
                    
                    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                    //添加到删除数组
                    [selectedArray removeObject:indexPath];
                }else
                {
                    NSLog(@" 8 越界了，会报错 %ld %d ",(long)[self.tableView numberOfRowsInSection:0], i );
                }
                
              
            }
            else if (todayNum==0&&earilyNum==0) {
                [self.view addSubview:noDataSourceView];
                myButton = nil;
                self.navigationItem.rightBarButtonItem=nil;
            }
            
        }
    }
    
    
    //获得删除的数量
    NSInteger didDeleteSelects = tableView.indexPathsForSelectedRows.count;
    [redDeleteBtn setTitle:[NSString stringWithFormat:@"Delete(%d)",didDeleteSelects] forState:UIControlStateNormal];
    
    
}
-(void)leftBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    if (tableView.editing) {
        NSLog(@" tableView.editing 11= %d",tableView.editing);
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    }
    else
    {
        NSLog(@" tableView.editing 22= %d",tableView.editing);
        return UITableViewCellEditingStyleDelete;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (todayNum>0&&earilyNum>0) {
        return 2;
    }else if (todayNum==0&&earilyNum>0) {
        return 1;
    }else if (todayNum>0&&earilyNum==0) {
        return 1;
    }
    else if (todayNum<=0&&earilyNum<=0) {
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:noDataSourceView];
        myButton = nil;
        self.navigationItem.rightBarButtonItem=nil;
        return 0;
    }
    //    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (todayNum>0&&earilyNum>0) {
        if (section == 0) {
            [noDataSourceView removeFromSuperview];
            //            noDataSourceView = nil;
            return todayNum;
        }
        else
        {
            [noDataSourceView removeFromSuperview];
            //            noDataSourceView = nil;
            return earilyNum;
        }
    }else if (todayNum==0&&earilyNum>0) {
        [noDataSourceView removeFromSuperview];
        //        noDataSourceView = nil;
        return earilyNum;
        
    }else if (todayNum>0&&earilyNum==0) {
        [noDataSourceView removeFromSuperview];
        //        noDataSourceView = nil;
        return todayNum;
    }
    else if (todayNum<=0&&earilyNum<=0) {
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:noDataSourceView];
        myButton = nil;
        self.navigationItem.rightBarButtonItem=nil;
        return 0;
    }
    
    
    
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] || [deviceString isEqualToString:@"iPhone8 Plus"]) {
        NSLog(@"此刻是6 plus的大小");
        
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    }else
    {
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
//    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    EarilyCell *earilyCell = [tableView dequeueReusableCellWithIdentifier:@"earilyCell"];
    
    if (cell == nil){
        cell = [HistoryCell loadFromNib];
        cell.backgroundColor=[UIColor clearColor];
        cell.tintColor = [UIColor redColor];
        //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x+20, cell.frame.origin.y+20, cell.frame.size.width, cell.frame.size.height-20)];
        //        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        
        //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        if (tableView.editing == YES) {
            
            CGRect frame = cell.frame;
            
            UIView *backView = [[UIView alloc] initWithFrame:frame];
            backView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = backView;
        }else
        {
            cell.selectionStyle = UIAccessibilityTraitNone;
        }
        
        [tableView setSeparatorColor:RGBA(193, 193, 193, 1)];
        
    }
    if (earilyCell == nil){
        earilyCell = [EarilyCell loadFromNib];
        earilyCell.backgroundColor=[UIColor clearColor];
        earilyCell.tintColor = [UIColor redColor];
       
        
        if (tableView.editing == YES) {
//            earilyCell.selectionStyle = UITableViewCellSelectionStyleGray;
//            earilyCell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
            CGRect frame = earilyCell.frame;
            
            UIView *backView = [[UIView alloc] initWithFrame:frame];
            backView.backgroundColor = [UIColor whiteColor];
            earilyCell.selectedBackgroundView = backView;
        }else
        {
            earilyCell.selectionStyle = UIAccessibilityTraitNone;
        }
        
        
////        earilyCell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
////        earilyCell.selectedBackgroundView.backgroundColor =  [UIColor whiteColor];
//        earilyCell.selectionStyle = UIAccessibilityTraitNone;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//
////                earilyCell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(earilyCell.frame.origin.x+20, earilyCell.frame.origin.y+2, earilyCell.frame.size.width, earilyCell.frame.size.height-2)];
//        view.backgroundColor = [UIColor blueColor];
////                earilyCell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(earilyCell.frame.origin.x+20, earilyCell.frame.origin.y+2, earilyCell.frame.size.width, earilyCell.frame.size.height-2)];
//        earilyCell.selectedBackgroundView = view;
////                earilyCell.selectedBackgroundView.backgroundColor = [UIColor redColor];
//
////        tableView.separatorColor = [UIColor redColor];
////                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//
//        [tableView setSeparatorColor:RGBA(193, 193, 193, 1)];
        
        
        
 
        
        
    }
    
    
    
    if (!ISEMPTY(historyArr)) {
        
        //因为这里展示的数据是倒叙排列的，所以在操作的时候都是 总数 - indexpath.row-1
        //&&&&
        if (todayNum >0) {
            if (indexPath.section == 0) {
                cell.dataDic = historyArr[historyArr.count -  indexPath.row - 1][0];
                return cell;
            }
            else
            {
                earilyCell.dataDic = historyArr[ earilyNum  - indexPath.row - 1][0];
                NSLog(@"history dddddd : %@",historyArr[historyArr.count -  indexPath.row - 1][0]);
                NSLog(@"history historyArr.count : %d",historyArr.count);
                NSLog(@"history indexrow : %d",indexPath.row);
                
                return earilyCell;
            }
        }
        else if (todayNum <= 0) {
            earilyCell.dataDic = historyArr[historyArr.count -  indexPath.row - 1][0];
            return earilyCell;
        }
        
        
    }
    
    
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //每次播放前，都先把 @"deliveryPlayState" 状态重置，这个状态是用来判断视频断开分发后，除非用户点击
    [USER_DEFAULT setObject:@"beginDelivery" forKey:@"deliveryPlayState"];

    
    //      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"section: %d,row %d ",indexPath.section,indexPath.row);
    NSLog(@"我被选中了，哈哈哈哈哈哈哈");
    
    
    
    //获得删除的数量
    NSInteger didDeleteSelects = tableView.indexPathsForSelectedRows.count;
    [redDeleteBtn setTitle:[NSString stringWithFormat:@"Delete(%d)",didDeleteSelects] forState:UIControlStateNormal];
    
    if (tableView.editing) {  //编辑模式下选中
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        [selectedArray addObject:path];
        
        
        
    }
    else //非编辑模式下使用
    {
        //无操作
        
        
        NSNotification *notification2 =[NSNotification notificationWithName:@"setSliderViewAlphaConfig" object:nil userInfo:nil];
        //        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification2];
        
        
        //______________
        
        
        if(indexPath.section == 0)
        {
            if (todayNum > 0) {   //如果今天的数量大于0
                
                NSArray * touchArr = historyArr[historyArr.count - indexPath.row - 1];
                
                NSLog(@"touchArr：%@",touchArr);
                [self touchToSee :touchArr];
                
            }
            else   //只有早期的历史，没有今天的历史
            {
                NSArray * touchArr = historyArr[earilyNum -  indexPath.row -1];
                NSLog(@"touchArr：%@",touchArr);
                [self touchToSee:touchArr];
            }
            
            
            
        }
        else //section =1
        {
            NSArray * touchArr = historyArr[earilyNum -  indexPath.row -1];
            NSLog(@"touchArr：%@",touchArr);
            [self touchToSee:touchArr];
        }
        
        
        //        }
        
        
        
        //_____________
    }
    
    
}
#pragma marl - 取消tableViewCell选中时触发的方法
//取消选择cell
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获得删除的数量
    NSInteger didDeleteSelects = tableView.indexPathsForSelectedRows.count;
    NSLog(@"didDeleteSelects %d",didDeleteSelects);
    [redDeleteBtn setTitle:[NSString stringWithFormat:@"Delete(%d)",didDeleteSelects] forState:UIControlStateNormal];
    
    if (tableView.editing) {  //编辑模式下选中
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        [selectedArray removeObject:path];
        NSLog(@"selectedArray.count %d",selectedArray.count);
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    
    UIView *toadyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];//
    
    toadyView.backgroundColor = [UIColor whiteColor];
    
    
    UIView *earilyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];//
    
    earilyView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * todayImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 26, 7, 7)];
    todayImg.image = [UIImage imageNamed:@"dian"];
    [toadyView addSubview:todayImg];
    UIImageView * earilyImg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 26, 7, 7)];
    earilyImg.image = [UIImage imageNamed:@"lan"];
    [earilyView addSubview:earilyImg];
    
    
    UILabel * todayLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, 100, 20)];
    NSString * TodayLabel = NSLocalizedString(@"TodayLabel", nil);
    todayLab.text = TodayLabel;
    [toadyView addSubview:todayLab];
    
    UILabel * earilyLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, 100, 20)];
    NSString * EarlyLabel = NSLocalizedString(@"EarlyLabel", nil);
    earilyLab.text = EarlyLabel;
    [earilyView addSubview:earilyLab];
    
    
    
    
    if (todayNum>0&&earilyNum>0) {
        if (section == 0) {
            return toadyView;
        }
        else
        {
            return earilyView;
        }
    }else if (todayNum==0&&earilyNum>0) {
        
        return earilyView;
        
    }else if (todayNum>0&&earilyNum==0) {
        return toadyView;
    }
    else if (todayNum==0&&earilyNum==0) {
        [self.view addSubview:noDataSourceView];
        myButton = nil;
        self.navigationItem.rightBarButtonItem=nil;
        return 0;
    }
    
    
    
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @" DEL ";
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if(indexPath.section == 0)
        {
            if (todayNum > 0) {
                todayNum = todayNum-1;
                [historyArr removeObjectAtIndex:(historyArr.count -  indexPath.row - 1)];
                [USER_DEFAULT setObject:[historyArr copy] forKey:@"historySeed"];
                
                if(todayNum == 0)
                {
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
                }
            }
            else
            {
                
                [historyArr removeObjectAtIndex:(earilyNum -  indexPath.row -1)];
                earilyNum = earilyNum-1;
                [USER_DEFAULT setObject:[historyArr copy] forKey:@"historySeed"];
                
                if(earilyNum == 0)
                {
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
                }
            }
            
        }
        else //section =1
        {
            
            [historyArr removeObjectAtIndex:earilyNum  - indexPath.row -1];
            earilyNum = earilyNum -1;
            [USER_DEFAULT setObject:[historyArr copy] forKey:@"historySeed"];
            
            if(earilyNum == 0)
            {
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
            }
        }
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
        
        if(historyArr.count == 0)
        {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
            [self.view addSubview:noDataSourceView];
            myButton = nil;
            self.navigationItem.rightBarButtonItem=nil;
        }
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    [tableView endUpdates];
    [tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 50;
}


-(void)touchToSee :(NSArray* )touchArr
{
    
    NSInteger row = [touchArr[2] intValue];
    NSDictionary * dic = touchArr [3];
    
    
    //    self.tvViewController = [[TVViewController alloc]init];
    //    [self.tvViewController touchSelectChannel:row diction:dic];
    ////    NSLog(@"当前点击了 ：%@",self.showData[indexPath.row]  );
    //将整形转换为number
    NSNumber * numIndex = [NSNumber numberWithInt:row];
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
    
    //这里需要进行一次判断，看是不是需要弹出机顶盒加锁密码框
    NSDictionary * epgDicToSocket = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    
    NSString * characterStr = [epgDicToSocket objectForKey:@"service_character"]; //新加了一个service_character
    
    
    if (characterStr != NULL && characterStr != nil) {
        
        BOOL judgeIsSTBDecrypt = [GGUtil isSTBDEncrypt:characterStr];
        if (judgeIsSTBDecrypt == YES) {
            // 此处代表需要记性机顶盒加密验证
            //弹窗
            //发送通知
            
            //        [self popSTBAlertView];
            //        [self popCAAlertView];
            NSDictionary *dict_STBDecrypt =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", @"otherTouch",@"textThree",nil];
            //创建通知
            NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dict_STBDecrypt];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification1];
            
            [self.tabBarController setSelectedIndex:1];
            [self.navigationController popViewControllerAnimated:YES];
        }else //正常播放的步骤
        {

            
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self.tabBarController setSelectedIndex:1];
            [self.navigationController popViewControllerAnimated:YES];

        }
        
        
    }else //正常播放的步骤
    {
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        //    [self.navigationController popViewControllerAnimated:YES];
        //    [self.navigationController popToViewController:_tvViewController animated:YES];
        //    [self.navigationController pushViewController:_tvViewController animated:YES];
        [self.tabBarController setSelectedIndex:1];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//计算算法，看正在删除的这个前面有几个比他小的
-(int)calculateNumsBiggerThanNowRow :(NSMutableArray *)selectArr NowIndexPath :(NSIndexPath *) nowIndexPath
{
    NSNumber * tempNumber = [NSNumber numberWithInteger:nowIndexPath.row];
//    [selectArr addObject:tempNumber];
    
   NSArray *sortedNumbers = [selectArr sortedArrayUsingSelector:@selector(compare:)];
    
    NSLog(@"sortedNumbers %@",sortedNumbers);
    
    int tempIndex =   [sortedNumbers indexOfObject:tempNumber];
    
//    [selectArr removeObject:tempNumber];
    
    
    return  tempIndex;
    
}

@end
