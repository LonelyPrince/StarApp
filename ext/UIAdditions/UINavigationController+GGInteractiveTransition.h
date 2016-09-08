//
//  UINavigationController+GGInteractiveTransition.h
//  StartUp4iOS
//
//  Created by Ron1 on 21/5/14.
//  Copyright (c) 2014 HGG. All rights reserved.
//

@interface UINavigationController (GGInteractiveTransition)


/**
 *  用于iOS7时，是否允许全屏幕范围手势UINavigationControllerPop
 *
 *  @param enable 允许
 */
- (void)fullScreenInteractiveTransitionEnable:(BOOL)enable NS_AVAILABLE_IOS(7_0);

@end
