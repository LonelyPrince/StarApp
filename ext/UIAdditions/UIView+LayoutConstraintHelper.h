//
//  UIView+LayoutConstraintHelper.h
//  jiibao2
//
//  Created by Ron on 9/5/14.
//  Copyright (c) 2014 HGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LayoutConstraintHelper)

- (NSLayoutConstraint*)widthConstraint;

- (NSLayoutConstraint*)heightConstraint;

- (NSLayoutConstraint*)top2SupviewConstraintWithTopLayoutGuideOwner:(UIViewController*)controller;

- (NSLayoutConstraint*)bottom2SupviewConstraintWithBottomLayoutGuideOwner:(UIViewController*)controller;

- (NSLayoutConstraint*)left2SupviewConstraint;

- (NSLayoutConstraint*)right2SupviewConstraint;

@end
