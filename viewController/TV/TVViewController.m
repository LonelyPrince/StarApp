//
//  TVViewController.m
//  starApp
//
//  Created by xyz on 16/8/1.
//  Copyright © 2016年 xyz. All rights reserved.
//

#import "TVViewController.h"


#define searchBtnX 30
#define searchBtnY 10+NavigationBar_HEIGHT
#define searchBtnWidth   SCREEN_WIDTH-2*searchBtnX
#define searchBtnHeight  35

@interface TVViewController ()

@property(nonatomic,strong)SearchViewController * searchViewCon;
@end

@implementation TVViewController

@synthesize searchViewCon;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadNav];
//    self.view.frame.origin.y = CGRectGetMaxY(44)
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadNav
{

    //设置右边按钮
//    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 70, 30);
//    [rightBtn setImage:[UIImage imageNamed:@"category"] forState:UIControlStateNormal];
//    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = item;
    
    //顶部搜索条
    self.navigationController.navigationBarHidden = YES;
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, 50)];
    topView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:topView];
    
    //self.navigationController.navigationBar.barTintColor = UIStatusBarStyleDefault;
    
    //搜索按钮
    UIButton * searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight)];
    [searchBtn setTitle:@"search" forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:[UIColor blackColor]];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    [topView bringSubviewToFront:searchBtn];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    

    
    
    //    self.view.frame = CGRectMake(0, 0, 640 , 1136);
//    NSLog(@"%@",[UIScreen mainScreen].bounds);
    
}

-(void)searchBtnClick
{
    searchViewCon = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchViewCon animated:YES];
}

@end
