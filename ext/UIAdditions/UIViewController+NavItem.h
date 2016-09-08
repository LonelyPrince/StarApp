//
//  UIViewController+NavItem.h
//  Weiyitemai
//
//  Created by Ron on 5/8/14.
//  Copyright (c) 2014 HGG. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BackButtonImageName @"nav_back"
#define DefaultColorOfNavigationBar grobalTintColor
#define DefaultFontOfNavigationBarTitle [UIFont systemFontOfSize:17]
#define DefaultTextColorOfNavigationBarTitle grobalTitleColor
#define DefaultTextColorOfNavigationItem grobalItemTitleColor
@interface UIViewController (NavItem)

/**
 *  config back action of UINavigationItem
 *
 *  @param action block
 */
- (void)configNavigationBackAction:(voidBlock)action;
/**
 *  config left UINavigationItem, the object must be NSString or UIImage object
 *
 *  @param object must be NSString or UIImage object
 *  @param action block
 */
- (void)configNavigationLeftItemWith:(id)object andAction:(voidBlock)action;

/**
 *  config right UINavigationItem, the object must be NSString or UIImage object
 *
 *  @param object must be NSString or UIImage object
 *  @param action block
 */
- (void)configNavigationRightItemWith:(id)object andAction:(voidBlock)action;

/**
 *  config left UINavigationItem with text and font
 *
 *  @param text NSString object
 *  @param action block
 */
- (void)configNavigationLeftString:(NSString*)text textFont:(UIFont*)font andAction:(voidBlock)action;


/**
 *  config right UINavigationItem with text and font
 *
 *  @param text NSString object
 *  @param action block
 */
- (void)configNavigationRightString:(NSString*)text textFont:(UIFont*)font andAction:(voidBlock)action;

- (void)configNavigationBarTintColor:(UIColor*)color;

- (void)configNavigationBarTitleAppearance;

- (void)configDefaultNavigationBarStyle;

- (void)configNavigationItemWith:(id)object leftOrRight:(BOOL)left andAction:(voidBlock)action;

@end
