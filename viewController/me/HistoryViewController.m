//
//  HistoryViewController.m
//  StarAPP
//
//  Created by xyz on 2016/10/27.
//
//

#import "HistoryViewController.h"

//#define  separatorViewTag  10456

//#define ONEDAY 86400
#define ONEDAY    86400  //99999999 //81000
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
    self.title = @"Histoary";
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
    isAllSelected = NO;
    [self initData];
    
}

-(void)initData
{
    noDataSourceView = [[UIView alloc]init];
    UIImageView * noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 505/2)/2, 120, 505/2, 149)];
    noDataImageView.image = [UIImage imageNamed:@"无历史"];
    //调用上面的方法，获取 字体的 Size
    
    CGSize size = [self sizeWithText: @"NO History" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    UILabel * noDataLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+10, size.width, size.height)];
    noDataLab.text = @"No History";
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

-(void)loadBarRightItem
{
    delegateBtn = YES;
    myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Del"] style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAllBtn)];
    self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
    
    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)deleteAllBtn
{
    [self loadAllDeleteBtn];
    if (delegateBtn == YES) {
        delegateBtn = NO;
        [self.tableView setEditing:YES animated:YES];
        //        [self setEditing:!self.editing animated:YES];
        myButton = nil;
        myButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteBtnCancel)];
        self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        
        self.navigationItem.rightBarButtonItem = myButton;
    }
    if(historyArr.count == 0 || historyArr == NULL)
    {
        [self deleteBtnCancelAndNOHistory];
    }
    
    NSLog(@"删除所有");
}
-(void)deleteBtnCancel
{
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
/**
 *左侧删除的all按钮
 */
-(void)loadAllDeleteBtn
{
    if (self.tableView.editing == NO) {
        
        UIBarButtonItem *allDelegateBtn = [[UIBarButtonItem alloc] initWithTitle:@" All "style:UIBarButtonItemStyleBordered target:self action:@selector(AllDeleteClick)];
        self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        
        self.navigationItem.leftBarButtonItem = allDelegateBtn;
        
        
        self.tabBarController.tabBar.hidden  = YES;
        
        
        [self loadRedDelegate];
        
        
        
        
    } else if (self.tableView.editing ==YES)
    {
        UIBarButtonItem *leftBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftBackBtnClick)];
        self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        
        self.navigationItem.leftBarButtonItem = leftBackBtn;
        
        self.tabBarController.tabBar.hidden = YES;
        
        
        [redDeleteBtn removeFromSuperview];
    }
    
}
-(void)loadRedDelegate
{
    
    redDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    redDeleteBtn.frame = CGRectMake(0, SCREEN_HEIGHT-51, SCREEN_WIDTH, 51);
    redDeleteBtn.backgroundColor = [UIColor redColor];
    [redDeleteBtn setTitle:@"DEL" forState:UIControlStateNormal];
    [redDeleteBtn addTarget:self action:@selector(deleteSeletions) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redDeleteBtn];
    
}
#pragma mark --红色的删除按钮点击删除
-(void)deleteSeletions
{
    if (selectedArray == 0) {
        
    }
    else{
        //此处多选删除选中的
        [self.tableView reloadData];
        [tableView beginUpdates];
        
        
        
        //刷新
        [tableView deleteRowsAtIndexPaths:selectedArray withRowAnimation:UITableViewRowAnimationFade];
        
        
        for (int i = 0; i< selectedArray.count; i++) {
            NSIndexPath * indexpath1 = selectedArray[i];
            if(indexpath1.section == 0)
            {
                if (todayNum > 0) {   //如果今天的数量大于0
                    todayNum = todayNum-1;
                    [historyArr removeObjectAtIndex:(historyArr.count -  indexpath1.row - 1 +i)];
                    [USER_DEFAULT setObject:[historyArr copy] forKey:@"historySeed"];
                    
//                    NSArray * abcd =[USER_DEFAULT objectForKey:@"historySeed"];
//                    NSLog(@"historyArr33 %@",historyArr);
                    if(todayNum == 0)
                    {
                        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexpath1.section] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    
                    
                }
                else   //只有早期的历史，没有今天的历史
                {
                    
                    [historyArr removeObjectAtIndex:(earilyNum -  indexpath1.row -1+i)];
                    earilyNum = earilyNum-1;
                    [USER_DEFAULT setObject:[historyArr copy] forKey:@"historySeed"];
                    
                    
                    if(earilyNum == 0)
                    {
                        [tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    
                }
                
                
                
            }
            else //section =1
            {
                
                [historyArr removeObjectAtIndex:earilyNum  - indexpath1.row -1+i];
                earilyNum = earilyNum -1;
                [USER_DEFAULT setObject:[historyArr copy] forKey:@"historySeed"];
                
                if(earilyNum == 0)
                {
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationLeft];
                }
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
        
        
        
    }
    
    //获得删除的数量
    
    [redDeleteBtn setTitle:[NSString stringWithFormat:@"DEL"] forState:UIControlStateNormal];
    
    if(historyArr.count == 0 || historyArr == NULL)
    {
        [self deleteBtnCancelAndNOHistory];
    }
}
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
                    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                    
                    //添加到删除数组
                    NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                    [selectedArray addObject:path];
                    
                }
                else
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i -todayNum inSection:1];
                    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                    
                    //添加到删除数组
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i -todayNum inSection:1];
                    [selectedArray addObject:path];
                }
                
                
                
            }else if (todayNum==0&&earilyNum>0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                
                //添加到删除数组
                [selectedArray addObject:indexPath];
            }else if (todayNum>0&&earilyNum==0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                
                //添加到删除数组
                [selectedArray addObject:indexPath];
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
                    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                    //添加到删除数组
                    [selectedArray removeObject:indexPath];
                }
                else
                {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i -todayNum inSection:1];
                    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                    //添加到删除数组
                    [selectedArray removeObject:indexPath];
                }
                
                
                
            }else if (todayNum==0&&earilyNum>0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                
                //添加到删除数组
                [selectedArray removeObject:indexPath];
            }else if (todayNum>0&&earilyNum==0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                
                //添加到删除数组
                [selectedArray removeObject:indexPath];
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
    [redDeleteBtn setTitle:[NSString stringWithFormat:@"DEL(%d)",didDeleteSelects] forState:UIControlStateNormal];
    
    
}
-(void)leftBackBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    if (tableView.editing) {
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    }
    else
    {
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
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    EarilyCell *earilyCell = [tableView dequeueReusableCellWithIdentifier:@"earilyCell"];
    
    if (cell == nil){
        cell = [HistoryCell loadFromNib];
        cell.backgroundColor=[UIColor clearColor];
        cell.tintColor = [UIColor redColor];
        //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x+20, cell.frame.origin.y+20, cell.frame.size.width, cell.frame.size.height-20)];
        //        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        
        //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setSeparatorColor:RGBA(193, 193, 193, 1)];
        
    }
    if (earilyCell == nil){
        earilyCell = [EarilyCell loadFromNib];
        earilyCell.backgroundColor=[UIColor clearColor];
        earilyCell.tintColor = [UIColor redColor];
        //        earilyCell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        earilyCell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(earilyCell.frame.origin.x, earilyCell.frame.origin.y+20, earilyCell.frame.size.width, earilyCell.frame.size.height-20)];
        //        earilyCell.selectedBackgroundView.backgroundColor = [UIColor redColor];
        
        //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setSeparatorColor:RGBA(193, 193, 193, 1)];
        
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
    
    //      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"section: %d,row %d ",indexPath.section,indexPath.row);
    NSLog(@"我被选中了，哈哈哈哈哈哈哈");
    
    
    
    //获得删除的数量
    NSInteger didDeleteSelects = tableView.indexPathsForSelectedRows.count;
    [redDeleteBtn setTitle:[NSString stringWithFormat:@"DEL(%d)",didDeleteSelects] forState:UIControlStateNormal];
    
    if (tableView.editing) {  //编辑模式下选中
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        [selectedArray addObject:path];
    }
    else //非编辑模式下使用
    {
        //无操作
        
        
        
        
        
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
//取消选择cell
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获得删除的数量
    NSInteger didDeleteSelects = tableView.indexPathsForSelectedRows.count;
    [redDeleteBtn setTitle:[NSString stringWithFormat:@"DEL(%d)",didDeleteSelects] forState:UIControlStateNormal];
    
    if (tableView.editing) {  //编辑模式下选中
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        [selectedArray removeObject:path];
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
    
    
    UILabel * todayLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, 50, 20)];
    todayLab.text = @"Today";
    [toadyView addSubview:todayLab];
    
    UILabel * earilyLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, 50, 20)];
    earilyLab.text = @"Early";
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
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if(indexPath.section == 0)
        {
            if (todayNum > 0) {
                todayNum = todayNum-1;
                [historyArr removeObjectAtIndex:(historyArr.count -  indexPath.row - 1)];
                [USER_DEFAULT setObject:[historyArr copy] forKey:@"historySeed"];
            }
            else
            {
                
                [historyArr removeObjectAtIndex:(earilyNum -  indexPath.row -1)];
                earilyNum = earilyNum-1;
                [USER_DEFAULT setObject:[historyArr copy] forKey:@"historySeed"];
            }
            
        }
        else //section =1
        {
            
            [historyArr removeObjectAtIndex:earilyNum  - indexPath.row -1];
            earilyNum = earilyNum -1;
            [USER_DEFAULT setObject:[historyArr copy] forKey:@"historySeed"];
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
        [tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    [tableView endUpdates];
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
                
                }else //正常播放的步骤
                {
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];

                [self.tabBarController setSelectedIndex:1];
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
            }
    
}


@end
