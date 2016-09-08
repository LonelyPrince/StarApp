//
//  UINavigationController+PushSingleOne.m
//  Weiyitemai
//
//  Created by cocoa on 15/1/12.
//  Copyright (c) 2015年 HGG. All rights reserved.
//

#import "UINavigationController+PushSingleOne.h"

@implementation UINavigationController (PushSingleOne)

- (void)pushSingleViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *v = nil;
    for (UIViewController *vc in self.viewControllers)
    {
        if ([vc isKindOfClass:[viewController class]])
        {
            break;
        }
        v = vc;
    }
    if (v == nil)
    {
        [self popToRootViewControllerAnimated:animated];
        return;
    }
    [self popToViewController:v animated:NO];
    [self pushViewController:viewController animated:animated];
}

@end
