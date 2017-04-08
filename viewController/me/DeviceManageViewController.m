//
//  DeviceManageViewController.m
//  StarAPP
//
//  Created by xyz on 16/9/29.
//
//

#import "DeviceManageCell.h"
#import "DeviceManageViewController.h"



@interface DeviceManageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation DeviceManageViewController
@synthesize avController;
@synthesize cgUpnpModel;
@synthesize scrollView;
@synthesize avCtrl;
- (void)viewDidLoad {
    self.title = @"Equipment management";
    
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    avCtrl = [[CGUpnpAvController alloc] init];    ///进行搜索的对象
    
    avCtrl.delegate = self;
    //    [self initData];    //table表
    
    //1.通过搜索获取数据
    //2.没有连接的设备显示数据
    //3.已经连接的设备通过socket连接获取详细数据
    
    
//    //搜索
//    CGUpnpAvController* avCtrl = [[CGUpnpAvController alloc] init];
//    avCtrl.delegate = self;
//    [avCtrl search];
//    self.avController = avCtrl;
//    
    [self loadNav];

//    [self loadUI];

    
//    [self getCGData];    //此处是获取数据
    
NSLog(@"Device viewDidLoad");
}
-(void)getCGData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        //搜索
        
        
        [avCtrl search];
        self.avController = avCtrl;
        //通知主线程刷新
        NSLog(@"Device dispatch1");
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
//            [self loadNav];

            
//            [self getDmsNum];   //获取dms设备数量
            [self loadScroll];
//            [self performSelector:@selector(loadUI) withObject:nil afterDelay:4.0f];
            [self loadUI];
            NSLog(@"Device dispatch2");
        });
        
    });
}



-(void)loadNav
{

    self.navigationController.navigationBarHidden = NO;

}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.dataSource = ;
    //self.dataSource 取值
    
    [self getCGData];    //此处是获取数据
    [self loadUI];
    NSLog(@"Device ViewWillApper");
}

- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceUpdated:(NSString *)deviceUdn {
    NSLog(@"%@", deviceUdn);
    self.avController = (CGUpnpAvController*)controlPoint;
    
    //self.dataSource = [controlPoint devices];
    
    //    NSArray* renderers = [((CGUpnpAvController*)controlPoint) renderers];
    //    if ([renderers count] > 0) {
    //        for (CGUpnpAvRenderer* renderer in renderers) {
    //            NSLog(@"avRendererUDN:%@", [renderer udn]);
    //        }
    //    }
    
    //此处可能产生僵尸对象
    self.dataSource = (NSMutableArray *) [((CGUpnpAvController*)controlPoint) servers];
    
    //    int dmsNum = 0;

//    [self.table reloadData];
    
    [self loadUI];
    [self viewWillAppear:YES];
    
    NSLog(@"Device delegate");
}

-(void) loadUI{
//    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStylePlain];
//    table.delegate = self;
//    table.dataSource = self;
//    //    table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:table];
//    self.table = table;

  
//    scrollView.bounces=NO;
    
    NSLog(@"datasource :%@",self.dataSource);
    for (int i = 0 ; i<self.dataSource.count; i++) {
        UIView * CGDeviceView = [[UIView alloc]initWithFrame:CGRectMake(20, 20 + 50* i , SCREEN_WIDTH - 40, 45)];
        CGDeviceView.layer.cornerRadius = 5.0;
        CGDeviceView.tag = i;
        CGDeviceView.backgroundColor = [UIColor redColor];
        
        [scrollView addSubview:CGDeviceView];
        [scrollView bringSubviewToFront:CGDeviceView];
    }
    
    

}
-(void)loadScroll
{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    [self.view addSubview:scrollView];
    
    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.delegate=self;
}
//-(NSInteger)getDmsNum
//{
// return self.dataSource.count;
//}
//-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.dataSource.count;
//}
//-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [DeviceManageCell defaultCellHeight];
//}




-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    DeviceManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell"];
    if (cell == nil){
        cell = [DeviceManageCell loadFromNib];
    }
    
    CGUpnpDevice *dev = [self.dataSource objectAtIndex:indexPath.row];
//    cell.textLabel.text = [dev friendlyName];
//    cell.detailTextLabel.text = [dev ipaddress];
    
    cell.deviceName.text =[dev friendlyName];
    cell.UUID.text = [dev udn];
    cell.IPAddress.text = [dev ipaddress];
//    cell.dataDic = self.dataSource[indexPath.row];
    
    return cell;
}

//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //    DetailViewController *controller =[[DetailViewController alloc] init];
//    //    controller.dataDic = self.dataSource[indexPath.row];
//    //    [self.navigationController pushViewController:controller animated:YES];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
