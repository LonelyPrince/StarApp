//
//  HistoryViewController.m
//  StarAPP
//
//  Created by xyz on 2016/10/27.
//
//

#import "HistoryViewController.h"

//#define ONEDAY 86400
#define ONEDAY    86400  //99999999 //81000
@interface HistoryViewController ()
{
    UIButton * editButton;
    NSMutableArray * dataArray;
    NSMutableArray * selectedArray;
    NSMutableArray * historyArr;
    
    int todayNum;
    int earilyNum;
    int aaaa;
}
@end

@implementation HistoryViewController
@synthesize tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Histoary";
    [tableView reloadData];
 historyArr  =   [[USER_DEFAULT objectForKey:@"historySeed"] mutableCopy];
    
//    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
//    [self setTableViewHeaderView];
    [self.view addSubview:tableView];
    
//    dataArray = [[NSMutableArray alloc]initWithObjects:@"大葫芦",@"大娃",@"二娃",@"三娃",@"四娃",@"五娃",@"六娃",@"七娃", nil];
//    selectedArray = [[NSMutableArray alloc]init]; //非ARC模式不能使用静态方法创建全局变量
//
//    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(reload) userInfo:nil repeats:YES];// 在longConnectToSock
   
    todayNum = 0;
    earilyNum = 0;
    for (int i = 0; i<historyArr.count; i++) {
        int diftime =[[GGUtil GetNowTimeString]intValue] - [historyArr[historyArr.count - i - 1][1]intValue];
        if (diftime >ONEDAY) {
            earilyNum++;
        }
        else{
            todayNum++;
        }
    }
}
//-(void)reload
//{
//    [tableView reloadData];
//}
-(void)viewWillAppear:(BOOL)animated
{
// [self addHeaderView];
}

-(void)addHeaderView
{
//    UIView * todayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
//    todayView.backgroundColor = [UIColor redColor];
//    tableView.tableHeaderView = todayView;
}
- (void)setTableViewHeaderView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(120, 5, 80, 50);
    [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editButton setTitle:@"delete" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(deleteSeletions:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:editButton];
    self.tableView.tableHeaderView = view;
}
//#pragma mark - 删除按钮的监听事件
//- (void)deleteSeletions:(UIButton *)button{
//    NSString * title = self.tableView.editing ? @"delete" : @"ok";
//    [button setTitle:title forState:UIControlStateNormal];
//    self.tableView.editing = !self.tableView.editing;
//    int count = selectedArray.count;
//    if (count == 0) {
//        return;
//    }else {
//        //冒泡排序  将indexPath.row 进行从小到大排序,避免删除数据时出现数组越界的BUG
//        for (int i = 0 ; i < count - 1; i ++) {
//            for (int j = 0 ; j < count - 1 - i; j++) {
//                NSIndexPath * indexPath1 = [selectedArray objectAtIndex:j];
//                NSIndexPath * indexPath2 = [selectedArray objectAtIndex:j+1];
//                if (indexPath1.row > indexPath2.row) {
//                    [selectedArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
//                }
//            }
//        }
//        for (int i = count-1 ; i >= 0; i--) {  //从大到小删除对应的数据
//            NSIndexPath * indexPath = [selectedArray objectAtIndex:i];
//            [dataArray removeObjectAtIndex:indexPath.row];
//        }
//        [selectedArray removeAllObjects];
//        [self.tableView reloadData];
//    }
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return dataArray.count;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString * cellID = @"cellID";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
//    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
//    
//    return cell;
//}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
//}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
//#pragma mark - 选中单元格时方法
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([editButton.titleLabel.text isEqualToString:@"ok"]) {
//        [selectedArray addObject:indexPath];
//    }
//}
//#pragma mark - 取消选中单元格方法
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([editButton.titleLabel.text isEqualToString:@"ok"]) {
//        [selectedArray removeObject:indexPath];
//    }
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
// 
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (todayNum>0&&earilyNum>0) {
        return 2;
    }else if (todayNum==0&&earilyNum>0) {
    return 1;
    }else if (todayNum>0&&earilyNum==0) {
        return 1;
    }
    else if (todayNum==0&&earilyNum==0) {
        return 0;
    }
//    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (todayNum>0&&earilyNum>0) {
        if (section == 0) {
            return todayNum;
        }
        else
        {
            return earilyNum;
        }
    }else if (todayNum==0&&earilyNum>0) {
     
            return earilyNum;
        
    }else if (todayNum>0&&earilyNum==0) {
        return todayNum;
    }
    else if (todayNum==0&&earilyNum==0) {
        return 0;
    }
    
   
    
//    return historyArr.count;
//    return 2;
    
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 1) {
//        return @"today";
//    }
//    else
//    {
//        return @"Earily";
//    }
//}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    EarilyCell *earilyCell = [tableView dequeueReusableCellWithIdentifier:@"earilyCell"];
    if (cell == nil){
        cell = [HistoryCell loadFromNib];
        cell.backgroundColor=[UIColor clearColor];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    if (earilyCell == nil){
        earilyCell = [EarilyCell loadFromNib];
        earilyCell.backgroundColor=[UIColor clearColor];
        
        earilyCell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        earilyCell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        
        //&&&&
        
//        int diftime =[[GGUtil GetNowTimeString]intValue] - [historyArr[historyArr.count -  indexPath.row - 1][1]intValue];
//        if (diftime >ONEDAY) {
//            if (todayNum>0) {   //至少today这个表头是存在的，那么earily则排在第二
//                if (indexPath.section == 1) {
//                    earilyCell.dataDic = historyArr[historyArr.count -  indexPath.row + todayNum- 1][0];
//
//                    NSLog(@"当前是earily indexpath.row: %d",indexPath.row);
//                }
//            }else{
//                
//                if (indexPath.section == 0) {
//                    earilyCell.dataDic = historyArr[historyArr.count -  indexPath.row - 1][0];
//                }
//            }
//           
//
//          return  earilyCell;;
//        }
//       
//        else{
//            if(earilyNum>0)
//            {
//                if (earilyNum >= indexPath.row) {
////                    if (indexPath.section ==1) {
////                                                     earilyCell.textLabel.text =[NSString stringWithFormat:@"section:  %d row%d",indexPath.section,indexPath.row];
////                                                    }
////                
////                }
////                
////                if (indexPath.section == 0) {
////                      earilyCell.textLabel.text =[NSString stringWithFormat:@"section:  %d row%d",indexPath.section,indexPath.row];
//                    if (indexPath.section ==0) {
//                        earilyCell.dataDic = historyArr[historyArr.count -  indexPath.row  - 1][0];
//                    }
//                    
//                     cell.dataDic = historyArr[historyArr.count -  indexPath.row - 1][0];
////                                    cell.textLabel.text =[NSString stringWithFormat:@"section:  %d row%d",indexPath.section,indexPath.row];
//                }
//            }
//            
//            
////            if (indexPath.section == 0) {
//////                cell.dataDic = historyArr[historyArr.count -  indexPath.row - 1][0];
////                cell.textLabel.text =[NSString stringWithFormat:@"section:  %d row%d",indexPath.section,indexPath.row];
////                if(earilyNum >0)
////                {
////                    if (earilyNum >= indexPath.row) {
////                        if (indexPath.section ==1) {
////                             earilyCell.textLabel.text =[NSString stringWithFormat:@"section:  %d row%d",indexPath.section,indexPath.row];
////                        }
////                       
////                    }
////                }
////            }
////            else
////            {
//////               earilyCell.dataDic = historyArr[historyArr.count -  indexPath.row  - 1][0];
//
////            }
//         
//        }
//
//        NSLog(@"history : %@",historyArr);
//        
//        
//        aaaa ++;
////        cell.dataDic = historyArr[historyArr.count -  indexPath.row - 1][0];
//        
//    }else{//如果为空，什么都不执行
    }
    
    NSLog(@"aaaaa :%d",aaaa);
//    return  cell;
    
    
    
    
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
         NSLog(@"section: %d,row %d ",indexPath.section,indexPath.row);
         NSLog(@"我被选中了，哈哈哈哈哈哈哈");
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
    earilyLab.text = @"Earily";
    [earilyView addSubview:earilyLab];
    
    
//    if(section ==0)
//    {
//    return toadyView;
//    }
//    else
//    {
//        return earilyView;
//    }

    
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
        return 0;
    }
    
    
//    toadyView.backgroundColor = [UIColor greenColor];
//    return toadyView;
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @" Del ";
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 50;
}

////判断时间是否是earily
//-(void)

@end
