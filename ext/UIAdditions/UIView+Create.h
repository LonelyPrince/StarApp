//
//  UIView+Create.h
//  NissanApp
//
//  Created by Ron on 14-3-22.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(Create)


/**
 * create From Nib method , You can pass CGRectNull if you do not want to change the size of View in Nib
 *
 */
+ (id)createByFrame:(CGRect)frame;

@end
