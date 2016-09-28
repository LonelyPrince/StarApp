


#define SCREEN_WIDTH_YLSLIDE  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT_YLSLIDE [UIScreen mainScreen].bounds.size.height
#define SET_COLOS_YLSLIDE(R,G,B) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:1.0]

#define __WEAK_SELF_YLSLIDE     __weak typeof(self) weakSelf = self;
#define __STRONG_SELF_YLSLIDE   __strong typeof(weakSelf) strongSelf = weakSelf;


typedef enum{
    CMD_PLAY_SERVICE = 12,
    CMD_EXIT_PLAY = 16,
    CMD_CHANGE_AUDIO = 14,
    CMD_CHANGE_SUBTITLE = 15,
    CMD_VERIFY_PASSWORD = 13,
    CMD_GET_RESOURCE_INFO = 17,
    EVENT_CHANNEL_LIST_CHANGE = 0,
    EVENT_CHANEL_LOCK = 22,
    EVENT_CA_CARD = 6,
    EVENT_CA_AUTHORIZE = 7,
    EVENT_CA_LOCK = 8,
    EVENT_TUNER_LOCK = 4,
    EVENT_TUNER_UNLOCK = 5,
    EVENT_SERVICE_STOP = 19,
    INVALID = 0xFF
//    MEDIA_DELIVERY_UPDATE_CHANNEL_LIST = 0,
//    MEDIA_DELIVERY_SERVICE_LOCK = 1,
//    MEDIA_DELIVERY_PASSWD_ERROR = 2,
//    MEDIA_DELIVERY_PASSWD_OK = 3,
//    MEDIA_DELIVERY_TUNER_LOCK = 4 ,
//    MEDIA_DELIVERY_TUNER_UNLOCK = 5,
//    MEDIA_DELIVERY_CA_CARD = 6,
//    MEDIA_DELIVERY_CA_ACCESS = 7,
//    MEDIA_DELIVERY_CA_MATURE_LOCK = 8,
//    MEDIA_DELIVERY_CA_PPV = 9,
//    MEDIA_DELIVERY_CA_PPV_ACCEPT = 10,
//    MEDIA_DELIVERY_CA_PPV_TOKEN = 11,
//    MEDIA_DELIVERY_PLAY_SERVICE = 12,
//    MEDIA_DELIVERY_PASSWD_CHECK = 13,
//    MEDIA_DELIVERY_CHANGE_AUDIO = 14,
//    MEDIA_DELIVERY_CHANGE_SUBT = 15,
//    MEDIA_DELIVERY_PLAY_EXIT = 16,
//    MEDIA_DELIVERY_GET_RESOURCE = 17,
//    MEDIA_DELIVERY_HEARTBEAT = 18,
//    MEDIA_DELIVERY_INVALID = 19
}service;


//typedef enum {
//    GGKeyboardStatusHide                    = 0,
//    GGKeyboardStatusShow                    = 1,
//} GGKeyboardStatus;

//typedef enum {
//    GGOrderStatusWaitForPaying                      = 1,//等待支付
//    GGOrderStatusWaitForReceiving                   = 2,//等待接收
//    GGOrderStatusWaitAlreadyDone                    = 3,//已经完成
//    GGOrderStatusAll                                = 0,
//} GGOrderStatus;
//


#define grobalTintColor RGB(249,249,249)
#define grobalTitleColor [UIColor whiteColor]
#define grobalItemTitleColor [UIColor whiteColor]
#define homeTintColor RGB(30, 152, 29)//RGB(38,176,127)
#define defaultGrayColor RGB(236,236,236)
#define grobalRedColor RGB(252,60,101)

////浅色字体
//#define grobalTextLightColor RGB(152,142,156)
////深色字体
//#define grobalTextDarkColor  RGB(108,99,111)
//
//#define grobalPageSize 20
//
//#define HTTP_REQUEST_TIMEOUTINTERVAL  20
////
//#define kNeedForceUpdateApplication @"NeedForceUpdateApplication"
//#define AppInstallURL @"https://itunes.apple.com/us/app/shen-ba-mu-ying-te-mai-gou/id997307636?l=zh&ls=1&mt=8"
//
////-----------------KEY------------------
//#define KEYCHAI_CURRENT_USER @"KEYCHAI_CURRENT_USER"
//#define KEYCHAI_ACCESSTOKEN @"KEYCHAI_ACCESSTOKEN"
//#define KEY_CODE @"code"
//#define KEY_SUCCESSFULL @"00000"
//#define kNotificationDidPayOrder @"NotificationDidPayOrder"
//#define kNotificationDidCancelPayOrder @"NotificationDidCancelPayOrder"
//
//typedef void (^NetworkErrorBlock)(NSError* error);
//typedef void (^ArrayBlock)(NSArray *records);
//typedef void (^DictBlock)(NSDictionary *record);
//
//#pragma mark - 友盟页面统计的ID
//
//#define PAGE_HOME                       @"page_home"                            // 首页
//#define PAGE_COMMODITY_DETAIL           @"page_commodity_detail"                // 商品详情页
//#define PAGE_CART                       @"page_cart"                            // 购物车
//#define PAGE_SETTLEACCOUNTS             @"page_settleaccounts"                  // 结算页
//#define PAGE_ORDER_ADDRESS              @"page_order_address"                   // 订单地址页
//#define PAGE_NEW_ADDRESS                @"page_new_address"                     // 新增地址页
//#define PAGE_PAY_TYPE                   @"page_pay_type"                        // 支付方式页
//#define PAGE_PAYSUCCESS                 @"Page_paysuccess"                      // 支付成功
//#define PAGE_PAYFAIL                    @"Page_payfail"                         // 支付失败页
//#define PAGE_USER_CENTER                @"page_user_center"                     // 个人中心
//#define PAGE_WAIT_PAY_ORDER             @"page_wait_pay_order"                  // 待支付订单页
//#define PAGE_WAIT_RECEIPT_ORDER  		@"page_wait_receipt_order"              // 待收货订单页
//#define PAGE_FINISHED_ORDER             @"page_finished_order"                  // 已完成订单页
//#define PAGE_ALL_ORDER                  @"page_all_order"                       // 所有订单页
//#define PAGE_ORDER_DETAIL               @"page_order_detail"                    // 订单详情页
//#define PAGE_ORDER_DETAIL_FREIGHT  		@"page_order_detail_freight"			// 订单物流详情页
//#define PAGE_COUPON                     @"page_coupon"                          // 优惠券
//#define PAGE_LOGIN                      @"page_login"                           // 登录页
//#define PAGE_REGISTER                   @"page_register"                        // 注册页
//#define PAGE_PRODUCT_LIST               @"page_product_list"                    // 宝贝列表
//#define PAGE_COMMODITY_COMMENT          @"page_commodity_comment"               // 商品评论
//#define PAGE_DISCOVERY                  @"page_discovery"                       // 发现
//#define PAGE_SETTING                    @"page_setting"                         // 设置页
//#define page_certification              @"page_certification"                   // 实名认证
//#define page_scan_code                  @"page_scan_code"                       // 扫一扫
//#define page_scan_help                  @"page_scan_help"                       // 扫码锦囊
//#define page_alipay_web                 @"page_alipay_web"                      // 支付宝网页支付
//#define page_forget_password            @"page_forget_password"                 // 忘记密码
//#define page_return_good                @"page_return_good"                     // 申请退货
//#define page_return_result              @"page_return_result"                   // 追踪退货
//#define page_sina_share                 @"page_sina_share"                      // 新浪微博分享
//#define page_sku_product                @"page_sku_product"                     // 商品SKU
//#define page_webview                    @"page_webview"                         // webview
//#define page_welcome                    @"page_welcome"                         // 引导页
//
//#define HOME_BUTTON_1                   @"home_button_1"                        // 奶粉
//#define HOME_BUTTON_2                   @"home_button_2"                        // 纸尿裤
//#define HOME_BUTTON_3                   @"home_button_3"                        // 羽绒棉服
//#define HOME_BUTTON_4                   @"home_button_4"                        // TOP榜
//#define HOME_BUTTON_5                   @"home_button_5"                        // 海外购
//#define HOME_BUTTON_6                   @"home_button_6"                        // 每日十件
//#define HOME_BUTTON_7                   @"home_button_7"                        // 搭配指南
//#define HOME_BUTTON_8                   @"home_button_8"                        // 益智成长
//#define HOME_BANNER_1                   @"home_banner_1"                 // banner1
//#define HOME_BANNER_2                   @"home_banner_2"                 // banner2
//#define HOME_BANNER_3                   @"home_banner_3"                 // banner3
//#define HOME_BANNER_4                   @"home_banner_4"                 // banner4
//#define HOME_BANNER_5                   @"home_banner_5"                 // banner5
//
//#define BUTTON_ACTIVITYPAY              @"button_activityPay"                   //点击支付
//#define BUTTON_ACTIVITYSHOPCART         @"button_activityshopcart"              //加入购物车
//#define BUTTON_ROB1                     @"button_rob1"                          //今日必抢坑位1
//#define BUTTON_ROB2                     @"button_rob2"                          //今日必抢坑位2
//#define BUTTON_ROB3                     @"button_rob3"                          //今日必抢坑位3
//
//#define button_recommend                @"button_recommend"                 //详情看了又看按键
//#define button_recommendClick           @"button_recommendClick"            //详情看了又看商品点击
//#define button_brandcate                @"button_brandcate"                 //详情专场入口
//#define button_gotoCart                 @"button_gotoCart"                  //详情购物车入口
//
//#define button_productClick             @"button_productClick"              //购物车点击商品
//#define button_gotoPay                  @"button_gotoPay"                   //购物车点击结算
//#define button_deleteProduct            @"button_deleteProduct"             //购物车删除商品
//
//#define EVENT_SELECT_COUPON             @"coupon_use"                           // 使用优惠券
//#define EVENT_ACTIVATE_COUPON           @"coupon_activate"                      // 激活优惠券
//
//#define EVENT_PAY_SUCCESS               @"pay_successed"                        //支付成功
//#define EVENT_PAY_FAILED                @"pay_failed"                           //支付失败
//
////--------- pay type ----------
//
//#define PAY_TYPE_ALIPAY_WAP @20
//#define PAY_TYPE_CASH @21
//#define PAY_TYPE_WECHAT @23
