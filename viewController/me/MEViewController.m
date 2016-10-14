//
//  MEViewController.m
//  starApp
//
//  Created by xyz on 16/8/1.
//  Copyright © 2016年 xyz. All rights reserved.
//

#import "MEViewController.h"

@interface MEViewController ()

@end

@implementation MEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationController.navigationBarHidden = NO;
//    UINavigationController * MENavController = [[UINavigationController alloc]initWithRootViewController:self];
//    MENavController.navigationBarHidden = YES;
    
    
    UIButton * deviceSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deviceSetBtn setFrame:CGRectMake(80, 80, 80, 80)];
    [deviceSetBtn addTarget:self action:@selector(deviceSetbtnClick) forControlEvents:UIControlEventTouchUpInside];
    [deviceSetBtn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:deviceSetBtn];
    
    //修改tabbar选中的图片颜色和字体颜色
    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = image;
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
}
-(void)deviceSetbtnClick
{

    DeviceManageViewController * deviceManageViewController = [[DeviceManageViewController alloc]init];
    [self.navigationController pushViewController:deviceManageViewController animated:YES];
    
    
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
