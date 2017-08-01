//
//  XYZNavigationController.m
//  StarAPP
//
//  Created by xyz on 2017/8/1.
//
//

#import "XYZNavigationController.h"

@interface XYZNavigationController ()

@end

@implementation XYZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.topViewController.Animating) {
        NSLog(@"快速切换，可能造成崩溃");
        return;
    }
    
    self.topViewController.Animating = YES;
    viewController.Animating = YES;
    
    [super pushViewController:viewController animated:animated];
}
@end
