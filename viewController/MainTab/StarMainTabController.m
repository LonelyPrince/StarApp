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
    
    tvVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Live" image:[UIImage imageNamed:@"live icon copy"] selectedImage:[UIImage imageNamed:@"live icon"]];
    
    
    
    MEViewController * meVC = [[MEViewController alloc]init];
    UINavigationController * meViewNav = [[UINavigationController alloc]initWithRootViewController:meVC];
    meVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Me" image:[UIImage imageNamed:@"me icon copy"] selectedImage:[UIImage imageNamed:@"me icon"]];
    
    MonitorViewController * monVC = [[MonitorViewController alloc]init];
    UINavigationController * monViewNav = [[UINavigationController alloc]initWithRootViewController:monVC];
    monVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Monitor" image:[UIImage imageNamed:@"more"] selectedImage:[UIImage imageNamed:@"more"]];
    
    
//     tvVC.backgroundColor=[UIColor whiteColor];
    
    
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
