//
//  DeviceListView.m
//  StarAPP
//
//  Created by xyz on 2017/10/23.
//

#import "DeviceListView.h"

@interface DeviceListView ()

@end

@implementation DeviceListView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNav];
}
-(void)loadNav
{
    self.title = @"Device List";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
