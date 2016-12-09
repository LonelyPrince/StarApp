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
-(UIViewController*) findBestViewController:(UIViewController*)vc {
    
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}

-(UIViewController*) currentViewController {
    
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
    
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
    monVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Monitor" image:[UIImage imageNamed:@"monitor"] selectedImage:[UIImage imageNamed:@"monitor-jd"]];
    
    
//     tvVC.backgroundColor=[UIColor whiteColor];
    
    
    [self setViewControllers:@[monVC,tvViewNav,meViewNav]];
    
    
    
}



- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIViewController * viewNow = [self currentViewController];
//    if ([nav isKindOfClass:[TVViewController class]]) {
            if ([viewNow isKindOfClass:[TVViewController class]]) {
                if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStartTransform"]){
                    NSLog(@"第一次启动旋转");
                  
                    NSLog(@"第一次启动");
               return UIInterfaceOrientationMaskPortrait;
                }
                
//        return UIInterfaceOrientationMaskPortrait;
     return UIInterfaceOrientationMaskAllButUpsideDown;
    }
     return UIInterfaceOrientationMaskPortrait;
    
}
@end
