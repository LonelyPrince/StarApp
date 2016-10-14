


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




#define grobalTintColor RGB(249,249,249)
#define grobalTitleColor [UIColor whiteColor]
#define grobalItemTitleColor [UIColor whiteColor]
#define homeTintColor RGB(30, 152, 29)//RGB(38,176,127)
#define defaultGrayColor RGB(236,236,236)
#define grobalRedColor RGB(252,60,101)

#define lineBlackColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]
#define ProgressLineColor [UIColor colorWithRed:0xFF/255.0 green:0x2d/255.0 blue:0x55/255.0 alpha:1] 

#define MainColor [UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]
//[HXColor hx_colorWithHexRGBAString:@"#FF2D55"]//RGB(229,229,229)
//#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
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

