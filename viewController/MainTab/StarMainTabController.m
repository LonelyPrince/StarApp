//
//  StarMainTabController.m
//  starApp
//
//  Created by xyz on 16/8/1.
//  Copyright © 2016年 xyz. All rights reserved.
//

#import "StarMainTabController.h"

@interface StarMainTabController ()

@end

@implementation StarMainTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadTab];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadTab
{

    
    TVViewController * tvVC = [[TVViewController alloc]init];
    UINavigationController * tvViewNav = [[UINavigationController alloc]initWithRootViewController:tvVC];
   
    tvVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"TV" image:[UIImage imageNamed:@"hot"] selectedImage:[UIImage imageNamed:@"hot"]];
    
    
    
    MEViewController * meVC = [[MEViewController alloc]init];
    UINavigationController * meViewNav = [[UINavigationController alloc]initWithRootViewController:meVC];
    meVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"me" image:[UIImage imageNamed:@"like_btn"] selectedImage:[UIImage imageNamed:@"like_btn_selected"]];
    
    MonitorViewController * monVC = [[MonitorViewController alloc]init];
    UINavigationController * monViewNav = [[UINavigationController alloc]initWithRootViewController:monVC];
    monVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"mon" image:[UIImage imageNamed:@"more"] selectedImage:[UIImage imageNamed:@"more"]];
    
    
   
    
    [self setViewControllers:@[monVC,tvViewNav,meViewNav]];
    
    
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
