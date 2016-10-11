// -------------------- Common Function --------------------------
#pragma mark - Common Function
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//rgb converter（hex->dec）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define FONT(x) [UIFont systemFontOfSize:x]

//AppDelegate
#define THAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)





// 判断网络是否可用
#define CheckNetWorkAvailable  ([[Reachability reachabilityWithHostname:@"http://www.baidu.com"] currentReachabilityStatus] == NotReachable) ? NO : YES
//[GiFHUD show];
//[GiFHUD dismiss]
// 开始请求
#define StartRequest  [MBProgressHUD showLoading:@"请稍后..." toView:[[GGAppDelegate shareAppDelegate] window]]

// 结束请求
#define StopRequest   [MBProgressHUD hideAllHUDsForView:[[AppDelegate shareAppDelegate] window] animated:YES]

#define AddHudSuccessNotice(NoticeText)   [MBProgressHUD showSuccess:NoticeText toView:[[AppDelegate shareAppDelegate] window]];

#define AddHudFailureNotice(NoticeText)     [MBProgressHUD showError:NoticeText toView:[[GGAppDelegate shareAppDelegate] window]];

// 创建HTTP请求
#define CreateGetHTTP(interfaceName) [[LBGetHttpRequest alloc] initWithInterfaceName:interfaceName]

#define CreatPostHttp(interfaceName,apimodule) [[LBPostHttpRequest alloc] initWithInterfaceName:interfaceName ApiModule: apimodule]

#define CreatNewPostHttp(interfaceName,apimodule,apiState) [[LBPostHttpRequest alloc] initWithInterfaceName:interfaceName ApiModule: apimodule WithOutApiString:apiState]





//NSString
#define STRING_OR_EMPTY(A)  ({ __typeof__(A) __a = (A); __a ? __a : @""; })

//NSLocalizedString
#define LS(string) NSLocalizedString(string,nil)

//NSUserDefault
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//[NSFileManager defaultManager]
#define FileManager [NSFileManager defaultManager]

//ReachNetWork
#define isInWifi [[Reachability reachabilityForInternetConnection] isReachableViaWiFi]
#define isOnline [[Reachability reachabilityForInternetConnection] isReachable]

//documents structure of application
#define APP_DOCUMENT                [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_LIBRARY                 [NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define APP_CACHES_PATH             [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#pragma mark - Device Information

//#define is4Inches ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//#define isPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define isRetina [UIScreen mainScreen].scale > 1
#define DeviceIsPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)
#define NavigationBar_HEIGHT 44

#pragma mark - System Information

#define CurrentAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define isGreaterOrEqualIOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")


//UI heights
#define STATUSBAR_HEIGHT 20.0
#define NAVBAR_HEIGHT 44.0
#define STATUS_NAV_HEIGHT 64.0


// -------------------- Debug Function --------------------------
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [File %s: Line %d] " fmt), __PRETTY_FUNCTION__, __FILE__, __LINE__, ##__VA_ARGS__)
#   define DLogRect(rect)  DLog(@"%@", NSStringFromCGRect(rect))
#   define DLogPoint(pt) DLog(@"%@", NSStringFromCGPoint(pt))
#   define DLogSize(size) DLog(@"%@", NSStringFromCGSize(size))
#   define DLogColor(_COLOR) DLog(@"%s h=%f, s=%f, v=%f", #_COLOR, _COLOR.hue, _COLOR.saturation, _COLOR.value)
#   define DLogSuperViews(_VIEW) { for (UIView* view = _VIEW; view; view = view.superview) { GBLog(@"%@", view); } }
#   define DLogSubViews(_VIEW) \
{ for (UIView* view in [_VIEW subviews]) { GBLog(@"%@", view); } }
#   else
#   define NSLog(...) {}
#   define DLog(...)
#   define DLogRect(rect)
#   define DLogPoint(pt)
#   define DLogSize(size)
#   define DLogColor(_COLOR)
#   define DLogSuperViews(_VIEW)
#   define DLogSubViews(_VIEW)
#   endif


#define SCREEN_WIDTH MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)

#define SCREEN_HEIGHT MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)

#define SCREEN_STATUSHEIGHT  [[UIApplication sharedApplication] statusBarFrame].size.height
//weakself
#define WEAKSELF   __weak __typeof(&*self)weakSelf = self;
#define WEAKPOST   __weak LBPostHttpRequest *httpRequest = request;
#define WEAKGET    __weak LBGetHttpRequest  *httpRequest = request;

//Block
typedef void(^voidBlock)();
typedef void(^stringBlock)(NSString *result);
typedef void(^boolBlock)(BOOL boolen);
typedef void(^indexBlock)(NSUInteger index);
typedef void(^errorBlock)(NSError *error);
typedef void(^numberBlock)(NSNumber *result);
typedef void(^arrayWithErrorBlock)(NSArray *results,NSError *error);
typedef void(^arrayBlock)(NSArray *results);
typedef void(^dictionaryBlock)(NSDictionary *results);



//new
//----TVViewController.m
#define searchBtnX 15
//#define searchBtnY 10+NavigationBar_HEIGHT
#define searchBtnY 20+7.5    //一共27.5pt
#define searchBtnWidth   SCREEN_WIDTH-2*searchBtnX
#define searchBtnHeight  29

#define VIDEOHEIGHT  64+0.5

#define topViewHeight  50
