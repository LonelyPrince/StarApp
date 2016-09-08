//
//  UINavigationController+PushSingleOne.h
//  Weiyitemai
//
//  Created by cocoa on 15/1/12.
//  Copyright (c) 2015年 HGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (PushSingleOne)

/*
 如果堆栈中有这个这个类的对象则会pop到这个前后再push进去
 */
- (void)pushSingleViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
