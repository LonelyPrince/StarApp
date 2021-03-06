//
//  BaseTabBarController.m
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/29.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "BaseTabBarController.h"
//#import "ViewController.h"
#import "TVViewController.h"


#import "TVViewController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate
{
    XYZNavigationController *nav = self.viewControllers[0];
    if ([nav.topViewController isKindOfClass:[TVViewController class]]) {
        return ![[[NSUserDefaults standardUserDefaults] objectForKey:@"ZXVideoPlayer_DidLockScreen"] boolValue];
    }
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    XYZNavigationController *nav = self.viewControllers[0];
    
    //new====
    //    NSString * isPreventFullScreenStr = [USER_DEFAULT objectForKey:@"modeifyTVViewRevolve"];//判断是否全屏界面下就跳转到首页面，容易出现界面混乱
    //
    //    if ([isPreventFullScreenStr isEqualToString:@"NO"]) {
    //        return UIInterfaceOrientationMaskPortrait;
    //    }else if(([isPreventFullScreenStr isEqualToString:@"YES"]))
    //    {
    //new====
    if ([nav.topViewController isKindOfClass:[TVViewController class]] && ![[USER_DEFAULT objectForKey:@"NOChannelDataDefault"] isEqualToString:@"YES"]) {
        //    if ([nav.topViewController isKindOfClass:[ViewController class]]) {
        NSLog(@"Interfac 全屏");
        return UIInterfaceOrientationMaskPortrait;
    }
        NSLog(@"Interfac 竖屏");
    return UIInterfaceOrientationMaskAllButUpsideDown;
    
    //new====
    //    }else
    //    {
    //    return UIInterfaceOrientationMaskPortrait;
    //    }
    //new====
}

@end
