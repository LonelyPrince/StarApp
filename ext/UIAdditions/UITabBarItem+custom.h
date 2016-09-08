//
//  UITabBarItem+custom.h
//  Weiyitemai
//
//  Created by Ron on 2/7/14.
//  Copyright (c) 2014 HGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (custom)

+ (UITabBarItem*)itemByTitle:(NSString*)text image:(UIImage*)img selectedImage:(UIImage*)sImg;

@end
