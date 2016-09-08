//
//  UIView+Create.m
//  NissanApp
//
//  Created by Ron on 14-3-22.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import "UIView+Create.h"

@implementation UIView(Create)

+ (id)createByFrame:(CGRect)frame
{
    NSString *className = NSStringFromClass(self);
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] objectAtIndex:0];
    if (view) {
        if (!CGRectIsNull(frame)) {
            view.frame = frame;
        }
    }else {
        view = [[self alloc] initWithFrame:frame];
    }
    return view;
}

@end
