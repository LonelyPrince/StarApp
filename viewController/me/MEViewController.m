//
//  MEViewController.m
//  starApp
//
//  Created by xyz on 16/8/1.
//  Copyright © 2016年 xyz. All rights reserved.
//

#import "MEViewController.h"


#define HISTORY_TITLE_Y  79
#define HISTORY_BTN_Y  109
//#define HISTORY_BTN_WIDTH  124.5
#define GRAYVIEW_Y  345

#define SEETING_TITLE_Y  380
@interface MEViewController ()

@property (nonatomic,assign)float allHistoryBtnHeight;
@end

@implementation MEViewController

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
    // Do any additional setup after loading the view.
  
//    self.view.backgroundColor = [UIColor grayColor];
    self.navigationController.navigationBarHidden = NO;
    UIFont *font = [UIFont fontWithName:@"Arial-ItalicMT" size:15];
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

    
    //加载一些样式
    [self loadNav];

}
-(void)deviceSetbtnClick
{

    DeviceManageViewController * deviceManageViewController = [[DeviceManageViewController alloc]init];
    [self.navigationController pushViewController:deviceManageViewController animated:YES];
    
}

-(void)loadNav
{
    
    //history
    UIButton * historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historyBtn.frame = CGRectMake(0, HISTORY_TITLE_Y, 6, 15);
    [historyBtn setBackgroundImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
    
    [self.view addSubview:historyBtn];
    
    UILabel * historyLab = [[UILabel alloc]initWithFrame:CGRectMake(17, HISTORY_TITLE_Y, 70, 18)];
    historyLab.text = @"History";
    historyLab.adjustsFontSizeToFitWidth = YES;
    historyLab.font = FONT(17);
    
    [historyLab setTextColor:RGBA(0x94, 0x94, 0x94, 1)];
    [self.view addSubview:historyLab];
    
    
    
    UIView * grayview = [[UIView alloc]initWithFrame:CGRectMake(0, GRAYVIEW_Y, SCREEN_WIDTH, 20)];
    grayview.backgroundColor = RGBA(0xF4,0xF4,0xF4,1);
    [self.view addSubview:grayview];
    
    //setting
    UIButton * settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(0, SEETING_TITLE_Y, 6, 15);
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"Group 6"] forState:UIControlStateNormal];
    
    [self.view addSubview:settingBtn];
    
    UILabel * settingLab = [[UILabel alloc]initWithFrame:CGRectMake(17, SEETING_TITLE_Y, 70, 18)];
    settingLab.text = @"Setting";
    settingLab.adjustsFontSizeToFitWidth = YES;
    settingLab.font = FONT(17);
    
    [settingLab setTextColor:RGBA(0x94, 0x94, 0x94, 1)];
    [self.view addSubview:settingLab];
    
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
