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


////最后一个加入购物车  用于倒计时
//#define lastJoinShopCar @"lastJoinShopCar"
//
////本地加入购物车的数据中参与活动优惠信息
//#define LocalShopCarHasPromotion @"LocalShopCarHasPromotion"

#pragma mark
#pragma mark -------------------- 全局颜色 --------------------

//全局颜色
#define NewGlobeNavColor RGB(34, 202, 186)
#define ShopCarGrayColor RGB(245,245,245)
#define ShopCarLineColor [UIColor colorWithHexString:@"#e5e5e5"]//RGB(229,229,229)


#pragma mark
#pragma mark -------------------- 银联 --------------------

////银联的环境  01：测试环境  00:正式环境
//#define UnionPay_Mode @"00"


//#pragma mark
//#pragma mark -------------------- Piwik --------------------
//
////piwik统计-表类型
//#define PiwikVisitTable @"PiwikVisitTable"
//#define PiwikActionTable @"PiwikActionTable"
//
////piwik统计-visit表
//#define PiwikVisitUseridKeyName     @"userid"
//#define PiwikVisitUseridIndex       @"1"
//
//#define PiwikVisitRegisterKeyName   @"register"
//#define PiwikVisitRegisterIndex     @"3"
//
//#define PiwikVisitAppChannelKeyName @"app_channel"
//#define PiwikVisitAppChannelIndex   @"6"
//
//#define PiwikVisitAppVersionKeyName @"app_channel"
//#define PiwikVisitAppVersionIndex   @"7"

////piwik统计-action表
//#define PiwikActionUseridKeyName    @"userid"
//#define PiwikActionUseridIndex      @"1"
//
//#define PiwikActionShowIdKeyName    @"show_id"
//#define PiwikActionShowIdIndex      @"2"
//
////商品id
//#define PiwikActionGoodsIdKeyName     @"goods_id"
//#define PiwikActionGoodsIdIndex       @"3"
//
//#define PiwikActionCartGoodidKeyName  @"cart_goodid"
//#define PiwikActionCartGoodidIndex    @"4"
//
////
//#define PiwikActionPay_snKeyName      @"pay_sn"
//#define PiwikActionPay_snIndex        @"5"
//
//#define PiwikActionRegisterKeyName  @"page"
//#define PiwikActionRegisterIndex    @"6"

// 立即购买 默认值 buy
//#define PiwikActionBuyKeyName         @"page"
//#define PiwikActionBuyIndex           @"6"
//
////加入购物车 默认值car
//#define PiwikActionCarKeyName         @"page"
//#define PiwikActionCarIndex           @"6"

//
//#define PiwikActionButtonKeyName      @"module"
//#define PiwikActionButtonIndex        @"7"
//
//#define PiwikActionPaginNumberKeyName @"paging_number"
//#define PiwikActionPaginNumberIndex   @"8"
//
//#define PiwikActionPositon_1KeyName   @"position_1"
//#define PiwikActionPositon_1KeyIndex  @"9"
//
//#define PiwikActionCartPriceKeyIName  @"cart_price"
//#define PiwikActionCartPriceIndex     @"12"
//
//#define PiwikActionCartQtyKeyIName    @"cart_qty"
//#define PiwikActionCartQtyIndex       @"13"


#pragma mark -------------------- userDefault 信息 --------------------
 //modeifyTVViewRevolve   用于跳转到主页时，判断是否需要立即横屏
#endif
