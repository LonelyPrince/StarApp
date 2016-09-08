//
//  UIViewController+BaseUISetting.m
//  EgogoWifi
//
//  Created by Loong on 14-4-30.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import "UIViewController+BaseUISetting.h"

@implementation UIViewController (BaseUISetting)

- (void)configExtendedLayout {
    if (isGreaterOrEqualIOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

+ (UIViewController *)getPreViewControllerOf:(UIViewController *)viewController fromNavigationController:(UINavigationController *)nav {
    NSArray *childControllers = nav.childViewControllers;
    if ([childControllers containsObject:viewController]) {
        NSInteger index = [childControllers indexOfObject:viewController];
        if (index - 1 >= 0) {
            UIViewController *preViewController = [childControllers objectAtIndex:index - 1];
            return preViewController;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

@end
