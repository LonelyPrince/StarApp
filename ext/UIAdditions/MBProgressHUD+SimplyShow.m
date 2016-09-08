//
//  MBProgressHUD+SimplyShow.m
//  Weiyitemai
//
//  Created by cocoa on 14/12/26.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import "MBProgressHUD+SimplyShow.h"

@implementation MBProgressHUD (SimplyShow)

+ (MBProgressHUD *)showMessage:(NSString *)msg wait:(BOOL)wait;
{
    return [self showMessage:msg inView:[[UIApplication sharedApplication] keyWindow] wait:wait];
}

+ (MBProgressHUD *)showMessage:(NSString *)msg inView:(UIView *)view wait:(BOOL)wait;
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.userInteractionEnabled = wait;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = msg;
    if (!wait)
    {
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.5];
    }
    [hud show:YES];
    return hud;
}

@end
