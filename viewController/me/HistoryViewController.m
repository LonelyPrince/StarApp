//
//  HistoryViewController.m
//  StarAPP
//
//  Created by xyz on 2016/10/27.
//
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
{
    UIButton * editButton;
    NSMutableArray * dataArray;
    NSMutableArray * selectedArray;
    NSMutableArray * historyArr;
}
@end

@implementation HistoryViewController
@synthesize tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
 
 historyArr  =  (NSMutableArray *) [USER_DEFAULT objectForKey:@"historySeed"];
    
//    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
//    [self setTableViewHeaderView];
    [self.view addSubview:tableView];
//    dataArray = [[NSMutableArray alloc]initWithObjects:@"大葫芦",@"大娃",@"二娃",@"三娃",@"四娃",@"五娃",@"六娃",@"七娃", nil];
//    selectedArray = [[NSMutableArray alloc]init]; //非ARC模式不能使用静态方法创建全局变量
//    
}
//- (void)setTableViewHeaderView{
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
//    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    editButton.frame = CGRectMake(120, 5, 80, 50);
//    [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [editButton setTitle:@"delete" forState:UIControlStateNormal];
//    [editButton addTarget:self action:@selector(deleteSeletions:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:editButton];
//    self.tableView.tableHeaderView = view;
//}
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    
    return historyArr.count;
//    return 2;
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    if (cell == nil){
        cell = [HistoryCell loadFromNib];
        cell.backgroundColor=[UIColor clearColor];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    
  
    
    if (!ISEMPTY(historyArr)) {
        
        
        NSLog(@"history : %@",historyArr);
        
        cell.dataDic = historyArr[historyArr.count -  indexPath.row - 1];
        
//        [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    }else{//如果为空，什么都不执行
    }
    
    
    
    return cell;
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
         NSLog(@"我被选中了，哈哈哈哈哈哈哈");
    
}


@end
