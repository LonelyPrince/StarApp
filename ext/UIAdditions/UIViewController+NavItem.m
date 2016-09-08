//
//  UIViewController+NavItem.m
//  Weiyitemai
//
//  Created by Ron on 5/8/14.
//  Copyright (c) 2014 HGG. All rights reserved.
//

#import "UIViewController+NavItem.h"
#import <objc/runtime.h>

static id leftBlockKey;
static id rightBlockKey;

@implementation UIViewController (NavItem)

- (void)configNavigationBackAction:(voidBlock)action
{
    if (self.navigationController.viewControllers[0] == self)
    {
        [self configNavigationItemWith:[UIImage imageNamed:BackButtonImageName] leftOrRight:YES andAction:action];
    }
}

- (void)configNavigationLeftItemWith:(id)object andAction:(voidBlock)action{
    [self configNavigationItemWith:object leftOrRight:YES andAction:action];
}

- (void)configNavigationRightItemWith:(id)object andAction:(voidBlock)action{
    [self configNavigationItemWith:object leftOrRight:NO andAction:action];
}

- (void)configNavigationLeftString:(NSString*)text textFont:(UIFont*)font andAction:(voidBlock)action{
    [self configNavigationItemString:text withFont:font leftOrRight:YES andAction:action];
}

- (void)configNavigationRightString:(NSString*)text textFont:(UIFont*)font andAction:(voidBlock)action{
    [self configNavigationItemString:text withFont:font leftOrRight:NO andAction:action];
}

- (void)configNavigationBarTintColor:(UIColor*)color{
    const CGFloat *designValues = CGColorGetComponents(color.CGColor);
    CGFloat *realValues = malloc( sizeof(CGFloat) * 3);
    for (int i = 0 ; i < 3; i++) {
        realValues[i] = (designValues[i] - 0.23) / 0.6;
    }
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:realValues[0] green:realValues[1] blue:realValues[2] alpha:1]];
    free(realValues);
}

- (void)configNavigationBarTitleAppearance{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    [self.navigationController.navigationBar setTintColor:DefaultTextColorOfNavigationItem];
    NSDictionary *attributes = @{ NSFontAttributeName: DefaultFontOfNavigationBarTitle,
                                  NSForegroundColorAttributeName: DefaultTextColorOfNavigationBarTitle,
                                  NSShadowAttributeName : shadow};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

- (void)configDefaultNavigationBarStyle
{
    if (isGreaterOrEqualIOS7)
    {
        [self configNavigationBarTintColor:[UIColor whiteColor]];
        [self configNavigationBarTitleAppearance];
    }
}

- (void)configNavigationItemString:(NSString*)text withFont:(UIFont*)font leftOrRight:(BOOL)left andAction:(voidBlock)action{
    NSCAssert([text isKindOfClass:[NSString class]], @"the text must be class of NSString");
    
    if (action) {
        objc_setAssociatedObject(self, left ? &leftBlockKey : &rightBlockKey,
                                 action,
                                 OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStyleDone target:self action:left ? @selector(pressLeft:) : @selector(pressRight:)];
    NSDictionary * attributes = @{NSFontAttributeName: font};
    [barButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [barButtonItem setTintColor:DefaultTextColorOfNavigationItem];
    if (left) {
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }else {
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
}

- (void)configNavigationItemWith:(id)object leftOrRight:(BOOL)left andAction:(voidBlock)action{
    
    NSCAssert([object isKindOfClass:[NSString class]] || [object isKindOfClass:[UIImage class]], @"the object must be class of NSString or UIImage");
    
    if ([object isKindOfClass:[UIImage class]]) {
        if (action) {
            objc_setAssociatedObject(self, left ? &leftBlockKey : &rightBlockKey,
                                     action,
                                     OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        UIImage *img = object;
        if (isGreaterOrEqualIOS7)
        {
            img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleDone
                                                                         target:self action:left ? @selector(pressLeft:) : @selector(pressRight:)];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil action:nil];
        [negativeSpacer setWidth:isGreaterOrEqualIOS7 ? -8 : 0];
//        self.navigationItem.leftBarButtonItems = @[negativeSpacer, barButtonItem];
        if (left) {
            self.navigationItem.leftBarButtonItems = @[negativeSpacer, barButtonItem];
//            self.navigationItem.leftBarButtonItem = barButtonItem;
        }else {
            self.navigationItem.rightBarButtonItem = barButtonItem;
        }
    }else {
        [self configNavigationItemString:object withFont:DefaultFontOfNavigationBarTitle leftOrRight:left andAction:action];
    }
}

#pragma mark -
#pragma mark -------------------- User Action ---------------------
- (void)pressLeft:(id)sender{
    voidBlock action = objc_getAssociatedObject(self, &leftBlockKey);
    if (action) {
        action();
    }
}

- (void)pressRight:(id)sender{
    voidBlock action = objc_getAssociatedObject(self, &rightBlockKey);
    if (action) {
        action();
    }
}

@end
