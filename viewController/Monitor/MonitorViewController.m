//
//  MonitorViewController.m
//  StarAPP
//
//  Created by xyz on 16/8/29.
//
//

#import "MonitorViewController.h"

@interface MonitorViewController ()

@end

@implementation MonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //修改tabbar选中的图片颜色和字体颜色
    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = image;
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
    
    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    UILabel * shadowLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 230, 30)];
    shadowLab.text = @"测试案例";
    shadowLab.shadowColor = RGBA(30, 30, 30, 0.5) ;//设置文本的阴影色彩和透明度。
     shadowLab.shadowOffset = CGSizeMake(2.0f, 2.0f);     //设置阴影的倾斜角度。
    UILabel * shadowLab1 = [[UILabel alloc]initWithFrame:CGRectMake(210, 120, 230, 30)];
    shadowLab1.text = @"123123213123";
    
    shadowLab1.shadowColor = RGBA(130, 130, 30, 0.5);    //设置文本的阴影色彩和透明度。
    shadowLab1.shadowOffset = CGSizeMake(2.0f, 2.0f);     //设置阴影的倾斜角度。
    
    [self.view addSubview:shadowLab];
    [self.view addSubview:shadowLab1];
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
