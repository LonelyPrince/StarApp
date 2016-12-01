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
#define HISTORYBTNPIECE_HEIGHT  108
//#define HISTORY_BTN_WIDTH  124.5
//#define GRAYVIEW_Y  345

//#define SEETING_TITLE_Y  380
@interface MEViewController ()
{
    UIButton * historyBtnPiece1;
    UIButton * historyBtnPiece2;
    UIButton * historyBtnPiece3;
    UIButton * historyBtnPiece4;
    UIButton * historyBtnPiece5;
    UIButton * historyBtnPiece6;
    
    UILabel * historyNameLab1;
    UILabel * historyNameLab2;
    UILabel * historyNameLab3;
    UILabel * historyNameLab4;
    UILabel * historyNameLab5;
    UILabel * historyNameLab6;

    UIView * whiteView6;
    UIView * whiteView5;
    UIView * whiteView4;
    UIView * whiteView3;
    UIView * whiteView2;
    UIView * whiteView1;
    NSMutableArray *  historyArr;
    
    UIButton * btn;
    float historyBtn1_width ;
    float historyBtn2_width ;

}
@property (nonatomic,assign)float allHistoryBtnHeight;
@property (nonatomic,strong)UIScrollView * scroll;
@property (nonatomic,strong) UIButton * hisBtn;
@end


@implementation MEViewController
@synthesize scroll;
@synthesize hisBtn;
@synthesize linkView;
@synthesize deviceView;
@synthesize aboutView;
@synthesize routeManageView;

@synthesize DeviceConView; //test
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
    self.tabBarController.tabBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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

    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollsToTop = NO;
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.bounces=NO;
    self.tableView.bouncesZoom = NO;
  
//    scroll.alwaysBounceVertical = NO;
//    scroll.scrollsToTop = NO;
//    scroll.bouncesZoom = NO;
    
//    [self loadNav];
    

    
    //加载一些样式

    
    

}

-(void)deviceSetbtnClick
{

    DeviceManageViewController * deviceManageViewController = [[DeviceManageViewController alloc]init];
    [self.navigationController pushViewController:deviceManageViewController animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [scroll removeFromSuperview];
    scroll = nil;
    
    historyArr  =  (NSMutableArray *) [USER_DEFAULT objectForKey:@"historySeed"];
    
     if (historyArr.count>3)
    {
        _allHistoryBtnHeight = 216;
    }else if(historyArr.count>0 && historyArr.count <=3)
    {
        _allHistoryBtnHeight = 108;
    }else
    {
        _allHistoryBtnHeight = 0;
    }
    
    [self loadScroll];
   [self loadNav];
    [self loadTableview];
    self.tableView.scrollEnabled =NO;
}
-(void)loadScroll
{
    //加一个scrollview
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    [self.view addSubview:scroll];
    
    //    scroll.contentSize=CGSizeMake(SCREEN_WIDTH, 788);
    scroll.contentSize=CGSizeMake(SCREEN_WIDTH, 614+105 - 216 +_allHistoryBtnHeight);
    //    scroll.pagingEnabled=YES;
    scroll.showsVerticalScrollIndicator=NO;
    scroll.showsHorizontalScrollIndicator=NO;
    scroll.delegate=self;
    scroll.bounces=NO;

    
}
-(void)loadNav
{
    
    [self addHistoryBtn];
    
    
    //history
    hisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hisBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];

    [hisBtn addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchDown];
    [hisBtn addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchUpInside];
//    [hisBtn setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:hisBtn];
    [scroll addSubview:hisBtn];
//    [scroll bringSubviewToFront:hisBtn];
    
    
    UIImageView * historyImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, HISTORY_TITLE_Y, 6, 15)];
    historyImage.image = [UIImage imageNamed:@"Group 6"];
    [self.view addSubview:historyImage];
    [hisBtn addSubview:historyImage];
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
    [hisBtn addSubview:historyLab];
    
    UIImageView * historyMoreImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32, HISTORY_TITLE_Y+2.5, 6, 10)];
    historyMoreImage.image = [UIImage imageNamed:@"Back"];
    [self.view addSubview:historyMoreImage];
    [hisBtn addSubview:historyMoreImage];
    
    
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
//  hisBtn普通状态下的背景色
- (void)button1BackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = RGBA(0xF4,0xF4,0xF4,1);
}

//  hisBtn高亮状态下的背景色
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    
//    self.tableView.editing = YES;
    //跳转到历史界面
    self.historyView = [[HistoryViewController alloc]init];
    //        [self presentModalViewController:self.routeView animated:YES];
    [self.navigationController pushViewController:self.historyView animated:YES];
   
    
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
    self.historyView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
    
    self.historyView.navigationItem.leftBarButtonItem = myButton;
}
////test
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
//}
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
        cell.grayLab.text = @"About management";
        
    }

        return cell;
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
//        deviceView = [[DeviceManageViewController alloc]init];
//        [self.navigationController pushViewController:deviceView animated:YES];
//        
//        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
//        self.deviceView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
//        self.deviceView.navigationItem.leftBarButtonItem = myButton;
        DeviceConView = [[DeviceManageController alloc]init];
        [self.navigationController pushViewController:DeviceConView animated:YES];
        
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
        self.DeviceConView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        self.DeviceConView.navigationItem.leftBarButtonItem = myButton;
    }
    if (indexPath.row == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
//        self.routeView = [[RouteSetting alloc]init];
////        [self presentModalViewController:self.routeView animated:YES];
//        [self.navigationController pushViewController:self.routeView animated:YES];
// 
//        
//        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
//        self.routeView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
//        
//        
////        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
//        self.routeView.navigationItem.leftBarButtonItem = myButton;
        
        self.routeManageView = [[RouteManageViewController alloc]init];
        //        [self presentModalViewController:self.routeView animated:YES];
        [self.navigationController pushViewController:self.routeManageView animated:YES];
        
        
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
        self.routeManageView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        
        
        self.routeManageView.navigationItem.leftBarButtonItem = myButton;
        
   
    
    }  else   if (indexPath.row == 2) {
        

        linkView = [[LinkViewController alloc]init];
      [self.navigationController pushViewController:linkView animated:YES];
        
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
        self.linkView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        self.linkView.navigationItem.leftBarButtonItem = myButton;
    }
    else   if (indexPath.row == 3) {
        
        
        aboutView = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutView animated:YES];
        
        UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
        self.aboutView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
        self.aboutView.navigationItem.leftBarButtonItem = myButton;
    }
    
    
      
    NSLog(@"我被选中了，哈哈哈哈哈哈哈");
    
}
-(void)clickEvent
{

    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
////    if (scrollView.contentOffset.y <= 0)
////    {
////        CGPoint offset = scrollView.contentOffset;
////        offset.y = 0;
////        scrollView.contentOffset = offset;
////    }
////    if (scrollView.contentOffset.y > self.scroll.bounds.size.height)
////    {
////        CGPoint offset = scrollView.contentOffset;
////        offset.y =self.scroll.bounds.size.height ;
////        scrollView.contentOffset = offset;
////    }
//    
//
////    [hisBtn setFrame:CGRectMake(0, 64 - scrollView.contentOffset.y, SCREEN_WIDTH, 45)];
//}

-(void)addHistoryBtn
{
     historyBtn1_width = (SCREEN_WIDTH+1)/3 - 0.5;
     historyBtn2_width = (SCREEN_WIDTH+1)/3;
    
    
    
    [self addFirstBtn];
    [self addSecondBtn];
    [self addThirdBtn];
    [self addFourBtn];
    [self addFiveBtn];
    [self addSixBtn];
    [self addWhiteView];
    
    
 
    
   
    
    
    UIImage * image = [UIImage imageNamed:@"zOOm-Logo"];
    UIImageView * channelImage = [[UIImageView alloc]initWithFrame:CGRectMake((125-image.size.width)/2, (50 - image.size.height), image.size.width, image.size.height)];
    channelImage.image = image;
    

    UIImageView * channelImage2 = [[UIImageView alloc]initWithFrame:CGRectMake((125-image.size.width)/2, (50 - image.size.height), image.size.width, image.size.height)];
    channelImage2.image = image;
    UIImageView * channelImage3 = [[UIImageView alloc]initWithFrame:CGRectMake((125-image.size.width)/2, (50 - image.size.height), image.size.width, image.size.height)];
    channelImage3.image = image;
    UIImageView * channelImage4 = [[UIImageView alloc]initWithFrame:CGRectMake((125-image.size.width)/2, (50 - image.size.height), image.size.width, image.size.height)];
    channelImage4.image = image;
    UIImageView * channelImage5 = [[UIImageView alloc]initWithFrame:CGRectMake((125-image.size.width)/2, (50 - image.size.height), image.size.width, image.size.height)];
    channelImage5.image = image;
    
    
  //6
    if (historyArr.count >5) {
        
        NSDictionary * historyDic1 = historyArr[historyArr.count - 1 - 0][0];
        NSDictionary * historyDic2 = historyArr[historyArr.count - 1 - 1][0];
        NSDictionary * historyDic3 = historyArr[historyArr.count - 1 - 2][0];
        NSDictionary * historyDic4 = historyArr[historyArr.count - 1 - 3][0];
        NSDictionary * historyDic5 = historyArr[historyArr.count - 1 - 4][0];
        
        NSString * service_logic_number1 = [self getlogicNmuber:[historyDic1 objectForKey:@"service_logic_number"] ];
        NSString * service_name1 = [historyDic1 objectForKey:@"service_name"];
        
        NSString * service_logic_number2 = [self getlogicNmuber:[historyDic2 objectForKey:@"service_logic_number"] ];
        NSString * service_name2 = [historyDic2 objectForKey:@"service_name"];
        
        NSString * service_logic_number3 = [self getlogicNmuber:[historyDic3 objectForKey:@"service_logic_number"] ];
        NSString * service_name3 = [historyDic3 objectForKey:@"service_name"];
        
        NSString * service_logic_number4 = [self getlogicNmuber:[historyDic4 objectForKey:@"service_logic_number"] ];
        NSString * service_name4 = [historyDic4 objectForKey:@"service_name"];
        
        NSString * service_logic_number5 = [self getlogicNmuber:[historyDic5 objectForKey:@"service_logic_number"] ];
        NSString * service_name5 = [historyDic5 objectForKey:@"service_name"];
        
        
        historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        [historyBtnPiece1 addSubview:channelImage];
        
        historyNameLab2.text = [NSString stringWithFormat:@"%@ %@",service_logic_number2,service_name2];
        [historyBtnPiece2 addSubview:channelImage2];
        
        historyNameLab3.text = [NSString stringWithFormat:@"%@ %@",service_logic_number3,service_name3];
        [historyBtnPiece3 addSubview:channelImage3];
        
        historyNameLab4.text = [NSString stringWithFormat:@"%@ %@",service_logic_number4,service_name4];
        [historyBtnPiece4 addSubview:channelImage4];
        
        historyNameLab5.text = [NSString stringWithFormat:@"%@ %@",service_logic_number5,service_name5];
        [historyBtnPiece5 addSubview:channelImage5];
        //        [historyBtnPiece6 addSubview:channelImage];
        
        [scroll addSubview:historyBtnPiece6];
        //        [scroll addSubview:whiteView6];
        [scroll addSubview:historyBtnPiece5];
        [scroll addSubview:historyBtnPiece4];
        [scroll addSubview:historyBtnPiece3];
        [scroll addSubview:historyBtnPiece2];
        [scroll addSubview:historyBtnPiece1];
        
    }
    
    if (historyArr.count ==5) {
        
        NSDictionary * historyDic1 = historyArr[historyArr.count - 1 - 0][0];
        NSDictionary * historyDic2 = historyArr[historyArr.count - 1 - 1][0];
        NSDictionary * historyDic3 = historyArr[historyArr.count - 1 - 2][0];
        NSDictionary * historyDic4 = historyArr[historyArr.count - 1 - 3][0];
        NSDictionary * historyDic5 = historyArr[historyArr.count - 1 - 4][0];
        
        NSString * service_logic_number1 = [self getlogicNmuber:[historyDic1 objectForKey:@"service_logic_number"] ];
        NSString * service_name1 = [historyDic1 objectForKey:@"service_name"];
        
        NSString * service_logic_number2 = [self getlogicNmuber:[historyDic2 objectForKey:@"service_logic_number"] ];
        NSString * service_name2 = [historyDic2 objectForKey:@"service_name"];
        
        NSString * service_logic_number3 = [self getlogicNmuber:[historyDic3 objectForKey:@"service_logic_number"] ];
        NSString * service_name3 = [historyDic3 objectForKey:@"service_name"];
        
        NSString * service_logic_number4 = [self getlogicNmuber:[historyDic4 objectForKey:@"service_logic_number"] ];
        NSString * service_name4 = [historyDic4 objectForKey:@"service_name"];
        
        NSString * service_logic_number5 = [self getlogicNmuber:[historyDic5 objectForKey:@"service_logic_number"] ];
        NSString * service_name5 = [historyDic5 objectForKey:@"service_name"];
        
        
        historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        [historyBtnPiece1 addSubview:channelImage];
        
        historyNameLab2.text = [NSString stringWithFormat:@"%@ %@",service_logic_number2,service_name2];
        [historyBtnPiece2 addSubview:channelImage2];
        
        historyNameLab3.text = [NSString stringWithFormat:@"%@ %@",service_logic_number3,service_name3];
        [historyBtnPiece3 addSubview:channelImage3];
        
        historyNameLab4.text = [NSString stringWithFormat:@"%@ %@",service_logic_number4,service_name4];
        [historyBtnPiece4 addSubview:channelImage4];
        
        historyNameLab5.text = [NSString stringWithFormat:@"%@ %@",service_logic_number5,service_name5];
        [historyBtnPiece5 addSubview:channelImage5];
//        [historyBtnPiece6 addSubview:channelImage];
        [historyBtnPiece6 removeFromSuperview];
//         [scroll addSubview:historyBtnPiece6];
//        [scroll addSubview:whiteView6];
        [scroll addSubview:whiteView6];
         [scroll addSubview:historyBtnPiece5];
         [scroll addSubview:historyBtnPiece4];
         [scroll addSubview:historyBtnPiece3];
         [scroll addSubview:historyBtnPiece2];
         [scroll addSubview:historyBtnPiece1];
    
    }
    if (historyArr.count ==4) {
        NSLog(@"historyArr: %@",historyArr);
//        NSArray * testArr1 = historyArr[historyArr.count - 1 - 0];
//        NSLog(@"testArr1:%@",testArr1);
        NSDictionary * historyDic1 = historyArr[historyArr.count - 1 - 0][0];
        NSDictionary * historyDic2 = historyArr[historyArr.count - 1 - 1][0];
        NSDictionary * historyDic3 = historyArr[historyArr.count - 1 - 2][0];
        NSDictionary * historyDic4 = historyArr[historyArr.count - 1 - 3][0];
//        NSDictionary * historyDic5 = historyArr[historyArr.count - 1 - 4];
        
        NSString * service_logic_number1 = [self getlogicNmuber:[historyDic1 objectForKey:@"service_logic_number"] ];
        NSString * service_name1 = [historyDic1 objectForKey:@"service_name"];
        
        NSString * service_logic_number2 = [self getlogicNmuber:[historyDic2 objectForKey:@"service_logic_number"] ];
        NSString * service_name2 = [historyDic2 objectForKey:@"service_name"];
        
        NSString * service_logic_number3 = [self getlogicNmuber:[historyDic3 objectForKey:@"service_logic_number"] ];
        NSString * service_name3 = [historyDic3 objectForKey:@"service_name"];
        
        NSString * service_logic_number4 = [self getlogicNmuber:[historyDic4 objectForKey:@"service_logic_number"] ];
        NSString * service_name4 = [historyDic4 objectForKey:@"service_name"];
        
//        NSString * service_logic_number5 = [self getlogicNmuber:[historyDic5 objectForKey:@"service_logic_number"] ];
//        NSString * service_name5 = [historyDic5 objectForKey:@"service_name"];
        
        
        historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        [historyBtnPiece1 addSubview:channelImage];
        
        historyNameLab2.text = [NSString stringWithFormat:@"%@ %@",service_logic_number2,service_name2];
        [historyBtnPiece2 addSubview:channelImage2];
        
        historyNameLab3.text = [NSString stringWithFormat:@"%@ %@",service_logic_number3,service_name3];
        [historyBtnPiece3 addSubview:channelImage3];
        
        historyNameLab4.text = [NSString stringWithFormat:@"%@ %@",service_logic_number4,service_name4];
        [historyBtnPiece4 addSubview:channelImage4];

        
        
        
        

        
        [historyBtnPiece5 removeFromSuperview];
        [historyBtnPiece6 removeFromSuperview];
//
//        historyBtnPiece6 = nil;
//        historyBtnPiece5 = nil;
  
//        [self addSixBtn];
//        [self addFiveBtn];
        //       historyBtnPiece6 = nil;
    
//        historyBtnPiece6.frame = historyBtnPiece5.frame;
//        historyBtnPiece6.bounds = historyBtnPiece5.bounds;
      
        
        [scroll addSubview:whiteView6];
        [scroll addSubview:whiteView5];
//        [scroll addSubview:historyBtnPiece6];
//        [scroll addSubview:historyBtnPiece5];
        [scroll addSubview:historyBtnPiece4];
        [scroll addSubview:historyBtnPiece3];
        [scroll addSubview:historyBtnPiece2];
        [scroll addSubview:historyBtnPiece1];
        
        
    }
    if (historyArr.count ==3) {
        
        NSDictionary * historyDic1 = historyArr[historyArr.count - 1 - 0][0];
        NSDictionary * historyDic2 = historyArr[historyArr.count - 1 - 1][0];
        NSDictionary * historyDic3 = historyArr[historyArr.count - 1 - 2][0];
//        NSDictionary * historyDic4 = historyArr[historyArr.count - 1 - 3];
        //        NSDictionary * historyDic5 = historyArr[historyArr.count - 1 - 4];
        
        NSString * service_logic_number1 = [self getlogicNmuber:[historyDic1 objectForKey:@"service_logic_number"] ];
        NSString * service_name1 = [historyDic1 objectForKey:@"service_name"];
        
        NSString * service_logic_number2 = [self getlogicNmuber:[historyDic2 objectForKey:@"service_logic_number"] ];
        NSString * service_name2 = [historyDic2 objectForKey:@"service_name"];
        
        NSString * service_logic_number3 = [self getlogicNmuber:[historyDic3 objectForKey:@"service_logic_number"] ];
        NSString * service_name3 = [historyDic3 objectForKey:@"service_name"];

        
        historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
                [historyBtnPiece1 addSubview:channelImage];
        
        historyNameLab2.text = [NSString stringWithFormat:@"%@ %@",service_logic_number2,service_name2];
                [historyBtnPiece2 addSubview:channelImage2];
        
        historyNameLab3.text = [NSString stringWithFormat:@"%@ %@",service_logic_number3,service_name3];
                [historyBtnPiece3 addSubview:channelImage3];
        
        
        
        [historyBtnPiece5 removeFromSuperview];
        [historyBtnPiece4 removeFromSuperview];
        [historyBtnPiece6 removeFromSuperview];
        [whiteView6 removeFromSuperview];
        [whiteView5 removeFromSuperview];
        
//        
//        historyBtnPiece6.frame = historyBtnPiece4.frame;
//        historyBtnPiece6.bounds = historyBtnPiece4.bounds;

        
        [scroll addSubview:whiteView6];
        [scroll addSubview:whiteView5];
        [scroll addSubview:whiteView4];

        [scroll addSubview:historyBtnPiece3];
        [scroll addSubview:historyBtnPiece2];
        [scroll addSubview:historyBtnPiece1];
       
        
    }
    if (historyArr.count ==2) {
        
        NSDictionary * historyDic1 = historyArr[historyArr.count - 1 - 0][0];
        NSDictionary * historyDic2 = historyArr[historyArr.count - 1 - 1][0];
       
        
        NSString * service_logic_number1 = [self getlogicNmuber:[historyDic1 objectForKey:@"service_logic_number"] ];
        NSString * service_name1 = [historyDic1 objectForKey:@"service_name"];
        
        NSString * service_logic_number2 = [self getlogicNmuber:[historyDic2 objectForKey:@"service_logic_number"] ];
        NSString * service_name2 = [historyDic2 objectForKey:@"service_name"];

        
        historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
                [historyBtnPiece1 addSubview:channelImage];
        
        historyNameLab2.text = [NSString stringWithFormat:@"%@ %@",service_logic_number2,service_name2];
        [historyBtnPiece2 addSubview:channelImage2];

        
////        dispatch_queue_t mainQueue = dispatch_get_main_queue();
//        dispatch_queue_t mainQueue = dispatch_get_main_queue();
//        dispatch_async(mainQueue,^{
////            NSLog("MainQueue");
//            [historyBtnPiece5 removeFromSuperview];
//            [historyBtnPiece4 removeFromSuperview];
//            [historyBtnPiece6 removeFromSuperview];
//            [historyBtnPiece3 removeFromSuperview];
//        });
        [historyBtnPiece5 removeFromSuperview];
        [historyBtnPiece4 removeFromSuperview];
        [historyBtnPiece6 removeFromSuperview];
        [historyBtnPiece3 removeFromSuperview];
        [whiteView6 removeFromSuperview];
        [whiteView5 removeFromSuperview];
        [whiteView4 removeFromSuperview];
        
//        historyBtnPiece6.frame = historyBtnPiece3.frame;
//        historyBtnPiece6.bounds = historyBtnPiece3.bounds;
        
        [scroll addSubview:whiteView6];
        [scroll addSubview:whiteView5];
        [scroll addSubview:whiteView4];
        [scroll addSubview:whiteView3];
//        [scroll addSubview:historyBtnPiece6];
//        [scroll addSubview:historyBtnPiece5];
//        [scroll addSubview:historyBtnPiece4];
//        [scroll addSubview:historyBtnPiece3];
        [scroll addSubview:historyBtnPiece2];
        [scroll addSubview:historyBtnPiece1];
//        [historyBtnPiece3 removeFromSuperview];
        
    }if (historyArr.count ==1) {
        
        NSDictionary * historyDic1 = historyArr[historyArr.count - 1 - 0][0];
        
        NSString * service_logic_number1 = [self getlogicNmuber:[historyDic1 objectForKey:@"service_logic_number"] ];
        NSString * service_name1 = [historyDic1 objectForKey:@"service_name"];
        
        
        
        historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
        [historyBtnPiece1 addSubview:channelImage];
    
        
        [historyBtnPiece5 removeFromSuperview];
        [historyBtnPiece4 removeFromSuperview];
        [historyBtnPiece3 removeFromSuperview];
        [historyBtnPiece2 removeFromSuperview];
        [historyBtnPiece6 removeFromSuperview];
        
        [whiteView6 removeFromSuperview];
        [whiteView5 removeFromSuperview];
        [whiteView4 removeFromSuperview];
        [whiteView3 removeFromSuperview];
//        historyBtnPiece6.frame = historyBtnPiece2.frame;
//        historyBtnPiece6.bounds = historyBtnPiece2.bounds;
//        [scroll addSubview:historyBtnPiece6];
        
        [scroll addSubview:whiteView6];
        [scroll addSubview:whiteView5];
        [scroll addSubview:whiteView4];
        [scroll addSubview:whiteView3];
        [scroll addSubview:whiteView2];
//        [scroll addSubview:historyBtnPiece6];
//        [scroll addSubview:historyBtnPiece5];
//        [scroll addSubview:historyBtnPiece4];
//        [scroll addSubview:historyBtnPiece3];
//        [scroll addSubview:historyBtnPiece2];
        [scroll addSubview:historyBtnPiece1];
      
    }
    
    if (historyArr.count ==0) {
        
//        NSDictionary * historyDic1 = historyArr[historyArr.count - 1 - 0];
//        
//        NSString * service_logic_number1 = [self getlogicNmuber:[historyDic1 objectForKey:@"service_logic_number"] ];
//        NSString * service_name1 = [historyDic1 objectForKey:@"service_name"];
//        
//        
//        
//        historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
//        [historyBtnPiece1 addSubview:channelImage];
        
        
//        historyBtnPiece6.frame = historyBtnPiece1.frame;
        [historyBtnPiece6 removeFromSuperview];
        [historyBtnPiece5 removeFromSuperview];
        [historyBtnPiece4 removeFromSuperview];
        [historyBtnPiece3 removeFromSuperview];
        [historyBtnPiece2 removeFromSuperview];
        [historyBtnPiece1 removeFromSuperview];
        [whiteView6 removeFromSuperview];
        [whiteView5 removeFromSuperview];
        [whiteView4 removeFromSuperview];
        [whiteView3 removeFromSuperview];
        [whiteView2 removeFromSuperview];
        
        [scroll addSubview:whiteView6];
        [scroll addSubview:whiteView5];
        [scroll addSubview:whiteView4];
        [scroll addSubview:whiteView3];
        [scroll addSubview:whiteView2];
        [scroll addSubview:whiteView1];
//        [scroll addSubview:historyBtnPiece6];
        //        [scroll addSubview:historyBtnPiece5];
        //        [scroll addSubview:historyBtnPiece4];
        //        [scroll addSubview:historyBtnPiece3];
        //        [scroll addSubview:historyBtnPiece2];
//        [scroll addSubview:historyBtnPiece1];
    }
}
//1
-(void)addFirstBtn
{
    
      historyBtnPiece1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtnPiece1 setFrame:CGRectMake(0, 45, historyBtn1_width, HISTORYBTNPIECE_HEIGHT)];
    [historyBtnPiece1 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtnPiece1 setBackgroundImage:[UIImage imageNamed:@"矩形1"] forState:UIControlStateNormal];
    historyBtnPiece1.tag = 1;
//    [scroll addSubview:historyBtnPiece1];
    
    
      historyNameLab1= [[UILabel alloc]initWithFrame:CGRectMake(15, 70, 95, 13)];
    //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
    historyNameLab1.textColor = [UIColor whiteColor];
    historyNameLab1.font = FONT(12);
    historyNameLab1.textAlignment = NSTextAlignmentCenter;
    [historyBtnPiece1 addSubview:historyNameLab1];
}
//2
-(void)addSecondBtn
{
      historyBtnPiece2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtnPiece2 setFrame:CGRectMake(historyBtn1_width + 0.5, 45, historyBtn2_width, HISTORYBTNPIECE_HEIGHT)];
    [historyBtnPiece2 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtnPiece2 setBackgroundImage:[UIImage imageNamed:@"矩形2"] forState:UIControlStateNormal];
    historyBtnPiece2.tag = 2;
//    [scroll addSubview:historyBtnPiece2];
    
    
      historyNameLab2= [[UILabel alloc]initWithFrame:CGRectMake(15, 70, 95, 13)];
    //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
    historyNameLab2.textColor = [UIColor whiteColor];
    historyNameLab2.font = FONT(12);
    historyNameLab2.textAlignment = NSTextAlignmentCenter;
    [historyBtnPiece2 addSubview:historyNameLab2];

}
//3
-(void)addThirdBtn
{
      historyBtnPiece3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtnPiece3 setFrame:CGRectMake(historyBtn1_width + 1 +historyBtn2_width, 45, historyBtn1_width, HISTORYBTNPIECE_HEIGHT)];
    [historyBtnPiece3 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtnPiece3 setBackgroundImage:[UIImage imageNamed:@"矩形3"] forState:UIControlStateNormal];
    historyBtnPiece3.tag = 3;
//    [scroll addSubview:historyBtnPiece3];
    
      historyNameLab3= [[UILabel alloc]initWithFrame:CGRectMake(15, 70, 95, 13)];
    //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
    historyNameLab3.textColor = [UIColor whiteColor];
    historyNameLab3.font = FONT(12);
    historyNameLab3.textAlignment = NSTextAlignmentCenter;
    [historyBtnPiece3 addSubview:historyNameLab3];
    
  
   
}
//4
-(void)addFourBtn
{
      historyBtnPiece4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtnPiece4 setFrame:CGRectMake(0, 45+ 0.5+HISTORYBTNPIECE_HEIGHT, historyBtn1_width, HISTORYBTNPIECE_HEIGHT)];
    [historyBtnPiece4 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtnPiece4 setBackgroundImage:[UIImage imageNamed:@"矩形4"] forState:UIControlStateNormal];
    historyBtnPiece4.tag = 4;
//    [scroll addSubview:historyBtnPiece4];
    
      historyNameLab4= [[UILabel alloc]initWithFrame:CGRectMake(15, 70, 95, 13)];
    //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
    historyNameLab4.textColor = [UIColor whiteColor];
    historyNameLab4.font = FONT(12);
    historyNameLab4.textAlignment = NSTextAlignmentCenter;
    [historyBtnPiece4 addSubview:historyNameLab4];
    
  
}
//5
-(void)addFiveBtn
{
      historyBtnPiece5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtnPiece5 setFrame:CGRectMake(historyBtn1_width + 0.5, 45+ 0.5+HISTORYBTNPIECE_HEIGHT, historyBtn1_width, HISTORYBTNPIECE_HEIGHT)];
    [historyBtnPiece5 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtnPiece5 setBackgroundImage:[UIImage imageNamed:@"矩形5"] forState:UIControlStateNormal];
    historyBtnPiece5.tag = 5;
//    [scroll addSubview:historyBtnPiece5];
    
      historyNameLab5= [[UILabel alloc]initWithFrame:CGRectMake(15, 70, 95, 13)];
    //    historyNameLab1.text = [NSString stringWithFormat:@"%@ %@",service_logic_number1,service_name1];
    historyNameLab5.textColor = [UIColor whiteColor];
    historyNameLab5.font = FONT(12);
    historyNameLab5.textAlignment = NSTextAlignmentCenter;
    [historyBtnPiece5 addSubview:historyNameLab5];
    
    
}
//6
-(void)addSixBtn
{
      historyBtnPiece6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtnPiece6 setFrame:CGRectMake(historyBtn1_width + 1 +historyBtn2_width, 45+ 0.5+HISTORYBTNPIECE_HEIGHT, historyBtn1_width, HISTORYBTNPIECE_HEIGHT)];
    [historyBtnPiece6 addTarget:self action:@selector(touchToSee:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtnPiece6 setBackgroundImage:[UIImage imageNamed:@"矩形6"] forState:UIControlStateNormal];
    historyBtnPiece6.tag = 6;
//    [scroll addSubview:historyBtnPiece6];
    
      historyNameLab6= [[UILabel alloc]initWithFrame:CGRectMake(0, 45,historyBtnPiece6.bounds.size.width, 20)];
    historyNameLab6.text = @"more";
    historyNameLab6.textColor = [UIColor whiteColor];
    historyNameLab6.font = FONT(16);
    historyNameLab6.textAlignment = NSTextAlignmentCenter;
    [historyBtnPiece6 addSubview:historyNameLab6];

    
    
}
-(void)addWhiteView
{
    whiteView6 = [[UIView alloc]init];
    whiteView6.frame = historyBtnPiece6.frame;
    whiteView6.backgroundColor = [UIColor whiteColor];

    
    whiteView5 = [[UIView alloc]init];
    whiteView5.frame = historyBtnPiece5.frame;
    whiteView5.backgroundColor = [UIColor whiteColor];
    
    whiteView4 = [[UIView alloc]init];
    whiteView4.frame = historyBtnPiece4.frame;
    whiteView4.backgroundColor = [UIColor whiteColor];
    
    whiteView3 = [[UIView alloc]init];
    whiteView3.frame = historyBtnPiece3.frame;
    whiteView3.backgroundColor = [UIColor whiteColor];
    
    whiteView2 = [[UIView alloc]init];
    whiteView2.frame = historyBtnPiece2.frame;
    whiteView2.backgroundColor = [UIColor whiteColor];
    
    whiteView1 = [[UIView alloc]init];
    whiteView1.frame = historyBtnPiece1.frame;
    whiteView1.backgroundColor = [UIColor whiteColor];
    
    
    
    
}
-(NSString * )getlogicNmuber : (NSString *)astring
{
  
    if(astring.length == 1)
    {
        astring = [NSString stringWithFormat:@"00%@", astring];
    }
    else if (astring.length == 2)
    {
        astring = [NSString stringWithFormat:@"0%@", astring];
    }
    else if (astring.length == 3)
    {
        astring = [NSString stringWithFormat:@"%@", astring];
    }
    else if (astring.length > 3)
    {
        astring = [ astring substringFromIndex: astring.length - 3];
    }
    return astring;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)historyBtnPieceClick
{
    self.historyView = [[HistoryViewController alloc]init];
    //        [self presentModalViewController:self.routeView animated:YES];
    [self.navigationController pushViewController:self.historyView animated:YES];
    
    
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
    self.historyView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
    
    self.historyView.navigationItem.leftBarButtonItem = myButton;
}

//点击观看历史直接播放
-(void)touchToSee :(id)sender   //(NSArray* )touchArr
{
    NSInteger tagIndex = [sender tag];
    
    NSArray * touchArr = historyArr[historyArr.count - tagIndex];
    NSLog(@"touchArr：%@",touchArr);
//    [self touchToSee :touchArr];
    
    
    NSInteger row = [touchArr[2] intValue];
    NSDictionary * dic = touchArr [3];
    
    
    //    self.tvViewController = [[TVViewController alloc]init];
    //    [self.tvViewController touchSelectChannel:row diction:dic];
    ////    NSLog(@"当前点击了 ：%@",self.showData[indexPath.row]  );
    //将整形转换为number
    NSNumber * numIndex = [NSNumber numberWithInt:row];
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numIndex,@"textOne",dic,@"textTwo", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"VideoTouchNoific" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToViewController:_tvViewController animated:YES];
    //    [self.navigationController pushViewController:_tvViewController animated:YES];
    [self.tabBarController setSelectedIndex:1];
}

@end
