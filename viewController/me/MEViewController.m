//
//  MEViewController.m
//  starApp
//
//  Created by xyz on 16/8/1.
//  Copyright © 2016年 xyz. All rights reserved.
//

#import "MEViewController.h"


#define HISTORY_TITLE_Y  15 //79  15
#define HISTORY_BTN_Y  109
//#define HISTORY_BTN_WIDTH  124.5
//#define GRAYVIEW_Y  345

//#define SEETING_TITLE_Y  380
@interface MEViewController ()

@property (nonatomic,assign)float allHistoryBtnHeight;
@property (nonatomic,strong)UIScrollView * scroll;
@end


@implementation MEViewController
@synthesize scroll;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // self.title = NSLocalizedString(@"Detail", @"Detail");
//        self.title = @"ME";
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    self.navigationController.navigationBarHidden = NO;
//    UIFont *font = [UIFont fontWithName:@"SFUIText-Light" size:15];
    UIFont *font = FONT(15);
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSForegroundColorAttributeName: [UIColor blackColor]};
    self.navigationController.navigationBar.titleTextAttributes =dic;
    self.navigationItem.title = @"ME";
    
//    UINavigationController * MENavController = [[UINavigationController alloc]initWithRootViewController:self];
//    MENavController.navigationBarHidden = YES;
    
 
    /**** 此处是设备搜索按钮
    UIButton * deviceSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deviceSetBtn setFrame:CGRectMake(80, 80, 80, 80)];
    [deviceSetBtn addTarget:self action:@selector(deviceSetbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [deviceSetBtn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:deviceSetBtn];
    */
    //修改tabbar选中的图片颜色和字体颜色
    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = image;
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];

    _allHistoryBtnHeight = 216;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    //加一个scrollview
     scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    [self.view addSubview:scroll];
    
//    scroll.contentSize=CGSizeMake(SCREEN_WIDTH, 788);
        scroll.contentSize=CGSizeMake(SCREEN_WIDTH, 614);
    scroll.pagingEnabled=YES;
    scroll.showsVerticalScrollIndicator=NO;
    scroll.showsHorizontalScrollIndicator=NO;
    scroll.delegate=self;
    scroll.bounces=NO;
    [self loadNav];
    

    
    //加载一些样式

    [self loadTableview];
    

}
-(void)deviceSetbtnClick
{

    DeviceManageViewController * deviceManageViewController = [[DeviceManageViewController alloc]init];
    [self.navigationController pushViewController:deviceManageViewController animated:YES];
    
}

-(void)loadNav
{
    
    
    
    
    //history
    
    UIImageView * historyImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, HISTORY_TITLE_Y, 6, 15)];
    historyImage.image = [UIImage imageNamed:@"Group 6"];
    [self.view addSubview:historyImage];
    [scroll addSubview:historyImage];
//    UIButton * historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    historyBtn.frame = CGRectMake(0, HISTORY_TITLE_Y, 6, 15);
//    [historyBtn setBackgroundImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
//    
//    [self.view addSubview:historyBtn];
    
    UILabel * historyLab = [[UILabel alloc]initWithFrame:CGRectMake(17, HISTORY_TITLE_Y, 70, 18)];
    historyLab.text = @"History";
    historyLab.adjustsFontSizeToFitWidth = YES;
    historyLab.font = FONT(17);
    
    [historyLab setTextColor:RGBA(0x94, 0x94, 0x94, 1)];
    [self.view addSubview:historyLab];
    [scroll addSubview:historyLab];
    
    
    UIView * grayview = [[UIView alloc]initWithFrame:CGRectMake(0, HISTORY_TITLE_Y +30 +20 + _allHistoryBtnHeight, SCREEN_WIDTH, 20)];
    grayview.backgroundColor = RGBA(0xF4,0xF4,0xF4,1);
    [self.view addSubview:grayview];
    [scroll addSubview:grayview];
    

    //setting
    
    
    UIImageView * settingImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, HISTORY_TITLE_Y +30 +20 + _allHistoryBtnHeight+35, 6, 15)];
    settingImage.image = [UIImage imageNamed:@"Group 6"];
    [self.view addSubview:settingImage];
    [scroll addSubview:settingImage];
    
    
    UILabel * settingLab = [[UILabel alloc]initWithFrame:CGRectMake(17,  HISTORY_TITLE_Y +30 +20 + _allHistoryBtnHeight+35, 70, 18)];
    settingLab.text = @"Setting";
    settingLab.adjustsFontSizeToFitWidth = YES;
    settingLab.font = FONT(17);
    
    [settingLab setTextColor:RGBA(0x94, 0x94, 0x94, 1)];
    [self.view addSubview:settingLab];
    [scroll addSubview:settingLab];
    
    
}


-(void)loadTableview
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HISTORY_TITLE_Y +30 +20 + _allHistoryBtnHeight+65 , SCREEN_WIDTH, 155*2) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    [scroll  addSubview:self.tableView];
}
/////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    
    return 4;
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77.5;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
        SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        if (cell == nil){
            cell = [SettingCell loadFromNib];
            cell.backgroundColor=[UIColor clearColor];
            
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = RGBA(0xf8, 0xf8, 0xf8, 1);
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    
    if(indexPath.row == 0)
    {
        cell.settingImage.image = [UIImage imageNamed:@"Group 8 Copy 2"];
        cell.blackLab.text = @"Equipment management";
        cell.grayLab.text = @"Equipment management";
        
    }  else  if(indexPath.row == 1)
    {
        cell.settingImage.image = [UIImage imageNamed:@"Group 10 Copy 2"];
        cell.blackLab.text = @"Route setting";
        cell.grayLab.text = @"Equipment management";
        
    } else  if(indexPath.row == 2)
    {
        cell.settingImage.image = [UIImage imageNamed:@"Group 12 Copy 2"];
        cell.blackLab.text = @"Contact us";
        cell.grayLab.text = @"Equipment management";
        
    }else  if(indexPath.row == 3)
    {
        cell.settingImage.image = [UIImage imageNamed:@"Group 15 Copy 2"];
        cell.blackLab.text = @"About";
        cell.grayLab.text = @"Equipment management";
        
    }

    
    

    
    
        return cell;
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        
        self.routeView = [[RouteSetting alloc]init];
//        [self presentModalViewController:self.routeView animated:YES];
        [self.navigationController pushViewController:self.routeView animated:YES];
 
        
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
        self.routeView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        
//        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
        self.routeView.navigationItem.leftBarButtonItem = myButton;
        

    
    }
    
    
      
    NSLog(@"我被选中了，哈哈哈哈哈哈哈");
    
}
-(void)clickEvent
{

    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y <= 0)
//    {
//        CGPoint offset = scrollView.contentOffset;
//        offset.y = 0;
//        scrollView.contentOffset = offset;
//    }
//    if (scrollView.contentOffset.y > self.scroll.bounds.size.height)
//    {
//        CGPoint offset = scrollView.contentOffset;
//        offset.y =self.scroll.bounds.size.height ;
//        scrollView.contentOffset = offset;
//    }
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
