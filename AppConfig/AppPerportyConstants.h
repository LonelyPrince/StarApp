//
//  AppPerportyConstants.h
//  Weiyitemai
//
//  Created by 神美 on 15/5/8.
//  Copyright (c) 2015年 VECN. All rights reserved.
//

#ifndef Weiyitemai_AppPerportyConstants_h
#define Weiyitemai_AppPerportyConstants_h

#pragma mark
#pragma mark -------------------- 用户信息 --------------------

#define CurName  [[NSUserDefaults standardUserDefaults] objectForKey:@"CurName"]


#define IsLogin [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]



#define userPath @"userPath"


#pragma mark
#pragma mark -------------------- 全局颜色 --------------------

//全局颜色
#define NewGlobeNavColor RGB(34, 202, 186)
#define ShopCarGrayColor RGB(245,245,245)
#define ShopCarLineColor [UIColor colorWithHexString:@"#e5e5e5"]//RGB(229,229,229)


#pragma mark -------------------- userDefault 信息 --------------------
 //modeifyTVViewRevolve   用于跳转到主页时，判断是否需要立即横屏
#endif
