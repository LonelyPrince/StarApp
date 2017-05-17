
//  AppApiConstants.h
//  Weiyitemai
//
//  Created by 神美 on 15/5/8.
//  Copyright (c) 2015年 VECN. All rights reserved.
//

#ifndef Weiyitemai_AppApiConstants_h

#define Weiyitemai_AppApiConstants_h


////环境切换
//#ifdef DEBUG
////测试环境
//#define DefaultHJ  ([[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultHJ"]==nil) ? @"" :[[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultHJ"]
//#else
////正式环境
//#define DefaultHJ  @""
//#endif

//#define APIModilePassPorts   [NSString stringWithFormat:@"http://%@passports.",DefaultHJ]
//#define APIModileHome        [NSString stringWithFormat:@"http://%@pc.",DefaultHJ]
//#define APIModileProduct     [NSString stringWithFormat:@"http://%@item.",DefaultHJ]
//#define APIModileCart        [NSString stringWithFormat:@"http://%@cart.",DefaultHJ]
//#define APIModileMy          [NSString stringWithFormat:@"http://%@my.",DefaultHJ]
//#define APIModileUpload      [NSString stringWithFormat:@"http://%@upload.",DefaultHJ]

//test feature


//常用链接
//#define kSDLB_SYS_SERVER @"http://www.jiajudaren.com/index.php?m=api&"
//  192.168.1.1
//#define kSDLB_SYS_SERVER @"http://192.168.1.55/cgi-bin/cgi_channel_list.cgi?"    //服务器地址


//#define kSDLB_SYS_SERVER @"http://192.168.1.226/cgi-bin/cgi_channel_list.cgi?"    //服务器地址
//#define k_image_ip @"http://www.jiajudaren.com"

//#define k_ZUIXIN @"a=getitems&p=%i&pg=33&sid=0&tid=0&o=0&keyword=&uid=0"
//
//#define k_ZUIRE @"a=getitems&p=%i&pg=33&sid=0&tid=0&o=1&keyword=&uid=0"


#define k_category @"a=gettags"

#define k_C_Alldata  @"a=getitems&p=%i&pg=33&sid=%@&tid=0&o=0&keyword=&uid=0"

#define k_category_data @"a=getitems&p=%i&pg=33&sid=0&tid=%@&o=0&keyword=&uid=0"

//new
#define S_category @"flag=0"      //参数


//get  online device

//#define G_device  @"http://192.168.1.183/test/online_devices" //@"http://www.tenbre.net/test/online_devices"//
//#define G_device  @"http://192.168.1.1/test/online_devices" //@"http://www.tenbre.net/test/online_devices"//
//get   online  device  pwd
//#define G_devicepwd    @"http://192.168.1.183/lua/settings/wifi" //  @"http://www.tenbre.net/lua/settings/wifi"  //
//#define G_devicepwd    @"http://192.168.1.1/lua/settings/wifi" //  @"http://www.tenbre.net/lua/settings/wifi"  //
//set(post) online device pwd
//#define P_devicepwd   @"http://192.168.1.183/lua/settings/wifi" //@"http://www.tenbre.net/lua/settings/wifi"//
//#define P_devicepwd   @"http://192.168.1.1/lua/settings/wifi" //@"http://www.tenbre.net/lua/settings/wifi"//
#endif

/**
 * 描述：判断字符串是否为空
 * 参数：字符串
 * 返回值：空为真，不空为假
 *
 */
CG_INLINE BOOL stringIsEmpty(NSString *string) {
    if([string isKindOfClass:[NSNull class]]){
        return YES;
    }
    NSString *text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([text length] == 0) {
        return YES;
    }
    return NO;
}
/**
 * 描述：从字符串中得到NSInteger类型数值
 * 参数：字符串
 * 返回值：NSInteger类型数值
 *
 */
CG_INLINE NSInteger getIntFromString(NSString *string) {
    if([string isKindOfClass:[NSNull class]]){
        return 0;
    }
    if(!string){
        return 0;
    }
    if([string isKindOfClass:[NSString class]]){
        if(stringIsEmpty(string)){
            return 0;
        }
    }
    if([string isKindOfClass:[NSString class]]){
        if([[string lowercaseString] isEqualToString:@"<null>"] || [[string lowercaseString] isEqualToString:@"null"]){
            return 0;
        }
    }
    return [string intValue];
}
/**
 * 描述：从字符串中得到CGFloat类型数值
 * 参数：字符串
 * 返回值：CGFloat类型数值
 *
 */
CG_INLINE CGFloat getFloatFromString(NSString *string) {
    if([string isKindOfClass:[NSNull class]]){
        return 0.0f;
    }
    if(!string){
        return 0.0f;
    }
    if([string isKindOfClass:[NSString class]]){
        if(stringIsEmpty(string)){
            return 0.0f;
        }
    }
    if([string isKindOfClass:[NSString class]]){
        if([[string lowercaseString] isEqualToString:@"<null>"] || [[string lowercaseString] isEqualToString:@"null"]){
            return 0.0f;
        }
    }
    return [string floatValue];
}

/**
 * 描述：从字符串中得到Double类型数值
 * 参数：字符串
 * 返回值：Double类型数值
 *
 */
CG_INLINE CGFloat getDoubleFromString(NSString *string) {
    if([string isKindOfClass:[NSNull class]]){
        return 0.0f;
    }
    if(!string){
        return 0.0f;
    }
    if([string isKindOfClass:[NSString class]]){
        if(stringIsEmpty(string)){
            return 0.0f;
        }
    }
    if([string isKindOfClass:[NSString class]]){
        if([[string lowercaseString] isEqualToString:@"<null>"] || [[string lowercaseString] isEqualToString:@"null"]){
            return 0.0f;
        }
    }
    return [string doubleValue];
}
//obj是否是 Null 或 Nil
#define ISEMPTY(obj) ((NSNull *)obj == [NSNull null]|| obj == nil)?YES:NO

//obj是否是 Null
#define ISNULL(obj) ((NSNull *)obj == [NSNull null])?YES:NO

//obj是否是 nil
#define ISNIL(obj) (obj == nil)?YES:NO

//obj是否是Class类型
#define ISCLASS(Class,obj)[obj isKindOfClass:[Class class]]

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)
//判断字符串是否合法
static inline BOOL isValidString(NSString *s)
{
    return (s && ISCLASS(NSString, s) && [s length]>0)?YES:NO;
}

//判断Number是否合法
static inline BOOL isValidNumber(id n)
{
    return (n && ISCLASS(NSNumber, n))?YES:NO;
}

//判断字典是否合法
static inline BOOL isValidDictionary(NSDictionary *d)
{
    return (d && ISCLASS(NSDictionary, d))?YES:NO;
}

//判断数组是否合法
static inline BOOL isValidArray(NSArray *a)
{
    return (a && ISCLASS(NSArray, a))?YES:NO;
}
