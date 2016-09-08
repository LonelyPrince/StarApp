//
//  UIViewController+BaseUISetting.h
//  EgogoWifi
//
//  Created by Loong on 14-4-30.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BaseUISetting)

- (void)configExtendedLayout;

+ (UIViewController *)getPreViewControllerOf:(UIViewController *)viewController fromNavigationController:(UINavigationController *)nav;
@end
