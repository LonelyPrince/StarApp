//
//  UITabBarItem+custom.m
//  Weiyitemai
//
//  Created by Ron on 2/7/14.
//  Copyright (c) 2014 HGG. All rights reserved.
//

#import "UITabBarItem+custom.h"

@implementation UITabBarItem (custom)

+ (UITabBarItem*)itemByTitle:(NSString*)text image:(UIImage*)img selectedImage:(UIImage*)sImg
{
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    sImg = [sImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
    tabBarItem.image = img;
    tabBarItem.selectedImage = sImg;
    tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    return tabBarItem;
}

@end
