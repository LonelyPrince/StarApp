//
//  UIView+LayoutConstraintHelper.m
//  jiibao2
//
//  Created by Ron on 9/5/14.
//  Copyright (c) 2014 HGG. All rights reserved.
//

#import "UIView+LayoutConstraintHelper.h"

@implementation UIView (LayoutConstraintHelper)

- (NSLayoutConstraint*)widthConstraint
{
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth && !constraint.secondItem && constraint.relation == NSLayoutRelationEqual) {
            return constraint;
        }
    }
    return nil;
}

- (NSLayoutConstraint*)heightConstraint
{
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight && !constraint.secondItem && constraint.relation == NSLayoutRelationEqual) {
            return constraint;
        }
    }
    return nil;
}

- (NSLayoutConstraint*)top2SupviewConstraintWithTopLayoutGuideOwner:(UIViewController*)controller
{
    id topLayoutGuide;
    
    if ([controller respondsToSelector:@selector(topLayoutGuide)]) {
        topLayoutGuide = [controller topLayoutGuide];
    }
    
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if (([constraint.firstItem isEqual:self] && [constraint.secondItem isEqual:topLayoutGuide] && constraint.firstAttribute == NSLayoutAttributeTop && constraint.secondAttribute == NSLayoutAttributeBottom) || ([constraint.firstItem isEqual:self] && [constraint.secondItem isEqual:self.superview] && constraint.firstAttribute == NSLayoutAttributeTop && constraint.secondAttribute == NSLayoutAttributeTop)) {
            return constraint;
        }
    }
    return nil;
}

- (NSLayoutConstraint*)bottom2SupviewConstraintWithBottomLayoutGuideOwner:(UIViewController*)controller
{
    id bottomLayoutGuide;
    
    if ([controller respondsToSelector:@selector(bottomLayoutGuide)]) {
        bottomLayoutGuide = [controller bottomLayoutGuide];
    }
    
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if (([constraint.firstItem isEqual:bottomLayoutGuide] && [constraint.secondItem isEqual:self] && constraint.firstAttribute == NSLayoutAttributeTop && constraint.secondAttribute == NSLayoutAttributeBottom) || ([constraint.firstItem isEqual:self.superview] && [constraint.secondItem isEqual:self] && constraint.firstAttribute == NSLayoutAttributeBottom && constraint.secondAttribute == NSLayoutAttributeBottom)) {
            return constraint;
        }
    }
    return nil;
}

- (NSLayoutConstraint*)left2SupviewConstraint
{
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if ([constraint.firstItem isEqual:self] && [constraint.secondItem isEqual:self.superview] && constraint.firstAttribute == NSLayoutAttributeLeading && constraint.secondAttribute == NSLayoutAttributeLeading) {
            return constraint;
        }
    }
    return nil;
}

- (NSLayoutConstraint*)right2SupviewConstraint
{
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if ([constraint.firstItem isEqual:self.superview] && [constraint.secondItem isEqual:self] && constraint.firstAttribute == NSLayoutAttributeTrailing && constraint.secondAttribute == NSLayoutAttributeTrailing) {
            return constraint;
        }
    }
    return nil;
}

@end
