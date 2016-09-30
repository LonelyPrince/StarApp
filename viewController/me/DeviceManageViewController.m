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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
//    self.navigationController.navigationBarHidden = NO;
    [self initData];    //table表
    //搜索
    CGUpnpAvController* avCtrl = [[CGUpnpAvController alloc] init];
    avCtrl.delegate = self;
    [avCtrl search];
    self.avController = avCtrl;
    
    [self loadNav];
    [self initData];
    [self loadUI];

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    self.dataSource = [((CGUpnpAvController*)controlPoint) servers];
//    int dmsNum = 0;

    [self.table reloadData];
}
-(void) initData
{
    
    self.dataSource = [NSMutableArray array];
}
-(void) loadUI{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    //    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.table = table;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DeviceManageCell defaultCellHeight];
}
-(NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    DetailViewController *controller =[[DetailViewController alloc] init];
    //    controller.dataDic = self.dataSource[indexPath.row];
    //    [self.navigationController pushViewController:controller animated:YES];
}

@end
