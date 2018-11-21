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
    NSLog(@"vc.viewController222== %@",vc);
    NSLog(@"vc.presentedViewController   %@",vc.presentedViewController);
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
        
    } else if ([vc isKindOfClass:[XYZNavigationController class]]) {
        
        // Return top view
        XYZNavigationController* svc = (XYZNavigationController*) vc;
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
        
    }else if ([vc.presentedViewController isKindOfClass:[UIAlertController class]]) {
        return vc;
    }
    
    else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
    
}

-(UIViewController*) currentViewController {
    
    // Find best view controller
    //    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController* viewController = appdelegate.window.rootViewController;
    NSLog(@"[self findBestViewController:viewController] :%@",[self findBestViewController:viewController]) ;// [self findBestViewController:viewController];;
    return [self findBestViewController:viewController];
    
}

-(void)loadTab
{
    
    
    TVViewController * tvVC = [[TVViewController alloc]init];
    XYZNavigationController * tvViewNav = [[XYZNavigationController alloc]initWithRootViewController:tvVC];
    
    NSString * LiveLabel = NSLocalizedString(@"LiveLabel", nil);
    tvVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:LiveLabel image:[UIImage imageNamed:@"live icon copy"] selectedImage:[UIImage imageNamed:@"live icon"]];
    
    
    
    
    MEViewController * meVC = [[MEViewController alloc]init];
    XYZNavigationController * meViewNav = [[XYZNavigationController alloc]initWithRootViewController:meVC];
    
    NSString * MutilMELabel = NSLocalizedString(@"MutilMELabel", nil);
    meVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:MutilMELabel image:[UIImage imageNamed:@"me icon copy"] selectedImage:[UIImage imageNamed:@"me icon"]];
    
    MonitorViewController * monVC = [[MonitorViewController alloc]init];
    XYZNavigationController * monViewNav = [[XYZNavigationController alloc]initWithRootViewController:monVC];
    NSString * MLMonitor = NSLocalizedString(@"MLMonitor", nil);
    monVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:MLMonitor image:[UIImage imageNamed:@"monitor"] selectedImage:[UIImage imageNamed:@"monitor-jd"]];
    
    
    //     tvVC.backgroundColor=[UIColor whiteColor];
    
    
    [self setViewControllers:@[monVC,tvViewNav,meViewNav]];
    
    
    
}



- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIViewController * viewNow = [self currentViewController];
    NSLog(@"vc.viewNow== %@",viewNow);
    //    if ([nav isKindOfClass:[TVViewController class]]) {
    
    //new====
    //    NSString * isPreventFullScreenStr = [USER_DEFAULT objectForKey:@"modeifyTVViewRevolve"];//判断是否全屏界面下就跳转到首页面，容易出现界面混乱
    //
    //    if ([isPreventFullScreenStr isEqualToString:@"NO"]) {
    //        return UIInterfaceOrientationMaskPortrait;
    //    }else if(([isPreventFullScreenStr isEqualToString:@"YES"]))
    //    {
    //new====
    
    NSLog(@"NOChannelDataDefault == aa %@ ",[USER_DEFAULT objectForKey:@"NOChannelDataDefault"]);
    if ([viewNow isKindOfClass:[TVViewController class]] && ![[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"YES"]) {
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStartTransform"]){
            NSLog(@"第一次启动旋转");
            
            NSLog(@"第一次启动");
            NSLog(@"Interfac 竖屏");
            return UIInterfaceOrientationMaskPortrait;   //不旋转
        }
        
        //        return UIInterfaceOrientationMaskPortrait;
        //                [USER_DEFAULT setBool:YES forKey:@"lockedFullScreen"];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"lockedFullScreen"]) {
            
            //                    [USER_DEFAULT objectForKey:@"orientationBHor"];
            UIDeviceOrientation orientationBHor12 =[USER_DEFAULT integerForKey:@"orientationBHor"];
            UIDeviceOrientation orientationAVer12 =[USER_DEFAULT integerForKey:@"orientationAVer"];
            
            switch (orientationAVer12) {
                case UIDeviceOrientationPortrait: {           // Device oriented vertically, home button on the bottom
                    NSLog(@"此时 home键4在 下");
                    //                            [self restoreOriginalScreen];
                    //                            return UIInterfaceOrientationMaskLandscapeLeft;
                }
                    break;
                case UIDeviceOrientationPortraitUpsideDown: { // Device oriented vertically, home button on the top
                    NSLog(@"此时 home键4在 上");
                }
                    break;
                case UIDeviceOrientationLandscapeLeft: {      // Device oriented horizontally, home button on the right
                    NSLog(@"此时 home键4在 右");
                    //                            return UIInterfaceOrientationMaskLandscapeLeft;
                    return UIInterfaceOrientationMaskLandscapeRight;
                }
                    break;
                case UIDeviceOrientationLandscapeRight: {     // Device oriented horizontally, home button on the left
                    NSLog(@"此时 home键4在 左");
                    return UIInterfaceOrientationMaskLandscapeLeft;
                    
                }
                    break;
                    
                default:
                    break;
            }
            //                    NSLog(@"asdahsdhk:%d",UIInterfaceOrientationMaskLandscapeLeft);
            //                    NSLog(@"asdahsdhk11:%d",UIInterfaceOrientationLandscapeRight);
            //                    NSLog(@"asdahsdhk11:%d",UIInterfaceOrientationPortraitUpsideDown);
            NSLog(@"Interfac 全屏 33");
            return UIInterfaceOrientationMaskLandscapeRight;
    
        }else
        {
            NSLog(@"Interfac 全屏11");
            [USER_DEFAULT setObject:@"Full" forKey:@"FullScreenJudge" ];
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }
        
    }
        NSLog(@"Interfac 全屏 22");
    [USER_DEFAULT setObject:@"NOFull" forKey:@"FullScreenJudge" ];
    return UIInterfaceOrientationMaskPortrait;    //不旋转
   
}
@end
