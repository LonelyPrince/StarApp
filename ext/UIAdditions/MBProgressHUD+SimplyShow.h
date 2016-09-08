//
//  MBProgressHUD+SimplyShow.h
//  Weiyitemai
//
//  Created by cocoa on 14/12/26.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (SimplyShow)

//提示框，默认显示在window中
+ (MBProgressHUD *)showMessage:(NSString *)msg wait:(BOOL)wait;

+ (MBProgressHUD *)showMessage:(NSString *)msg inView:(UIView *)view wait:(BOOL)wait;





@end
