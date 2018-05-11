//
//  GGUtil.m
//  Ganguo
//
//  Created by gump on 11-5-13.
//  Copyright 2011年 f4 . All rights reserved.
//

#import "GGUtil.h"
#import <objc/runtime.h>
#import <MessageUI/MessageUI.h>
#import <SystemConfiguration/SystemConfiguration.h>
//#import <NSString+Helpers.h>
#import <netinet/in.h>
#import "sys/utsname.h" //获取设备版本信息时候要用

//获取ip地址：
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
static NSDateFormatter *g_dayDateFormatter;

@implementation GGUtil

+ (void)load
{
    g_dayDateFormatter = [[NSDateFormatter alloc] init];
}

+ (NSDateFormatter*)dateFormatter{
    return g_dayDateFormatter;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue:@YES
                                  forKey:NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        DLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

#pragma mark -
#pragma mark Image
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage *)imageMono:(UIImage *)originalImage{
    
    CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, originalImage.size.width, originalImage.size.height, 8, originalImage.size.width, colorSapce, kCGBitmapAlphaInfoMask);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, originalImage.size.width, originalImage.size.height), [originalImage CGImage]);
    
    CGImageRef bwImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSapce);
    
    UIImage *returnImage = [UIImage imageWithCGImage:bwImage]; // This is result B/W image.
    CGImageRelease(bwImage);
    
    
    return returnImage;
}

//+ (UIImage*)cropImage:(UIImage*)img withRect:(CGRect)rect{
//
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    // translated rectangle for drawing sub image
//    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
//
//    // clip to the bounds of the image context
//    // not strictly necessary as it will get clipped anyway?
//    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
//
//    // draw image
//    [img drawInRect:drawRect];
//
//    // grab image
//    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//    return subImage;
//}


+ (UIImage *)makeAShotWithView:(UIView*)aView
{
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, YES, [UIScreen mainScreen].scale);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *rtImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rtImage;
}


+(CGSize)getScaleRect:(CGSize)originSize targetSize:(CGSize)maxSize{
    CGFloat width=originSize.width;
    CGFloat height=originSize.height;
    
    CGFloat wSize=width/maxSize.width;
    CGFloat hSize=height/maxSize.height;
    
    CGFloat currSize= wSize > hSize ? wSize : hSize;
    
    CGFloat finelWidth=width/currSize;
    CGFloat finelHeight=height/currSize;
    
    return CGSizeMake(finelWidth, finelHeight);
}

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            //fprintf(stdout, "%s \n",attribute);
            if (attribute[1] == '@'){
                return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
            }
        }
    }
    return "";
}

+ (NSMutableDictionary *)getClassPropertys:(id)fromClass {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([fromClass class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        const char *propType = getPropertyType(property);
        if(propName) {
            
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = [NSString stringWithUTF8String:propType];
            if (propertyType) {
                [props setObject:propertyType forKey:propertyName];
            }
        }
    }
    free(properties);
    return props;
}

#pragma mark -
#pragma mark Color
+ (UIColor *)randomColor
{
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        srandom(time(NULL));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

#pragma mark -
#pragma mark Dictionary
+ (NSMutableDictionary *)stringToDictionary:(NSString *)sourceString withSeparator:(NSString *)separator{
    NSArray *chunks = [sourceString componentsSeparatedByString: separator];
    NSMutableDictionary *stringDict=[NSMutableDictionary dictionary];
    
    for(NSString *chunk in chunks){
        NSArray *keyValue=[chunk componentsSeparatedByString: @"="];
        DLog(@"key:%@", [keyValue objectAtIndex:0]);
        DLog(@"value:%@", [keyValue objectAtIndex:1]);
        [stringDict setValue:[keyValue objectAtIndex:1] forKey:[keyValue objectAtIndex:0]];
    }
    return stringDict;
}

#pragma mark -
#pragma mark System Check
+ (BOOL)canSendSMS{
    BOOL canSMS=NO;
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            canSMS=YES;
        } else {
            [GGUtil showAlert:NSLocalizedString(@"Device can not use SMS.",@"")
                        title:NSLocalizedString(@"Warning",@"")];
        }
    }
    return canSMS;
    
}

+ (BOOL)checkNetworkConnection
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}


#pragma mark -
#pragma mark Alert
+ (UIAlertView *) showAlert: (NSString *) theMessage title:(NSString *) theTitle{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:theTitle message:theMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"我知道了", @"") otherButtonTitles: nil];
    [av show];
    return av;
}

#pragma mark -
#pragma mark URL
+ (NSString *)urlAppendRetina:(NSMutableString *)urlString{
    if ( isRetina) {
        NSRange range = [urlString rangeOfString:@"?"];
        if (range.length == 0) {
            [urlString appendString:@"?hd=1"];
        } else {
            [urlString appendString:@"&hd=1"];
        }
    }
    return  urlString;
}


#pragma mark -
#pragma mark Badge
+ (void)storeBadge{
    NSString *path = [APP_DOCUMENT stringByAppendingString:@"/badge"];
    NSString *badge = [NSString stringWithFormat:@"%d", [[UIApplication sharedApplication] applicationIconBadgeNumber]];
    [badge writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (int)getStoredBadge{
    NSString *path = [APP_DOCUMENT stringByAppendingString:@"/badge"];
    int badge = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] intValue];
    return badge;
}

#pragma mark -
#pragma mark String
+ (BOOL)stringIsEmpty:(NSString *) aString {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    } else {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)stringIsEmpty:(NSString *) aString shouldCleanWhiteSpace:(BOOL)cleanWhileSpace {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    }
    
    if (cleanWhileSpace) {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    
    return NO;
}

//+ (NSString*)UUID {
//    CFUUIDRef uuidObj = CFUUIDCreate(nil);
//    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
//    CFRelease(uuidObj);
//    return [uuidString lowercaseString];
//}

#pragma mark -
#pragma mark Text
+ (NSString *)limitString:(NSString *)string withLength:(unsigned short)length{
    NSString* returnString=string;
    if([string length]>length) {
        returnString=[NSString stringWithFormat:@"%@...",[string substringToIndex:length-3]];
    }
    return returnString;
}



+ (NSString *)getDistanceText:(double)distance{
    NSString* distanceText=@"";
    if (distance<1000) {
        distanceText=[NSString stringWithFormat:@"%d00米", ((int)distance/100)+1];
    }else{
        distanceText=[NSString stringWithFormat:@"%dkm", ((int)distance/1000)];
    }
    return distanceText;
}

+ (NSString *)getShowName:(NSString *)username withFirstName:(NSString *)firstName withLastName:(NSString *)lastName{
    if ((firstName && [firstName length]>0) ||  (lastName && [lastName length]>0 )) {
        return [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    }else{
        return username;
    }
}

+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+(BOOL)isValidateTelephone:(NSString*)telephone
{
    //    0\\d{2}\\d{8}|0\\d{2}\\d{7}|0\\d{3}\\d{7}|0\\d{3}\\d{8}
    NSString *phoneRegex = @"0\\d{2,3}-\\d{5,9}|0\\d{2,3}-\\d{5,9}";
    //    NSString *phoneRegex = @"(^(0\\d{2})-(\\d{8})$)|(^(0\\d{3})-(\\d{7})$)|(^(0\\d{2})-(\\d{8})-(\\d+)$)|(^(0\\d{3})-(\\d{7})-(\\d+)$)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:telephone];
}

+ (BOOL)isValidZipcode:(NSString*)value
{
    const char *cvalue = [value UTF8String];
    int len = strlen(cvalue);
    if (len != 6) {
        return NO;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark -
#pragma mark Date
+ (NSString *)timeToText:(NSDate *)time{
    NSString *timeText=@"";
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:(NSYearCalendarUnit |
                                                         NSMonthCalendarUnit |
                                                         NSDayCalendarUnit |
                                                         NSHourCalendarUnit |
                                                         NSMinuteCalendarUnit |
                                                         NSSecondCalendarUnit)
                                               fromDate:time
                                                 toDate:[NSDate date] options:0];
    
    [g_dayDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [g_dayDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    if ([components year]) {
        timeText = [[g_dayDateFormatter stringFromDate:time] substringToIndex:10];
    } else if ([components month]) {
        timeText = [[g_dayDateFormatter stringFromDate:time] substringToIndex:10];
    } else if ([components day]) {
        if ([components day] > 7) {
            timeText = [[g_dayDateFormatter stringFromDate:time] substringToIndex:10];
        } else {
            timeText = [NSString stringWithFormat:@"%d天前", [components day]];
        }
    } else if ([components hour]) {
        timeText = [NSString stringWithFormat:@"%d小时前", [components hour]];
    } else if ([components minute]) {
        if ([components minute] < 0) {
            timeText = @"刚刚";
        } else {
            timeText = [NSString stringWithFormat:@"%d分钟前", [components minute]];
        }
    } else if ([components second]) {
        if ([components second] < 0) {
            timeText = @"刚刚";
        } else {
            timeText = [NSString stringWithFormat:@"%d秒前", [components second]];
        }
    } else {
        timeText = @"刚刚";
    }
    return timeText;
}

+ (NSString*)stringFromDate:(NSDate*)aDate format:(NSString*)dateFormat
{
    return [GGUtil stringFromDate:aDate format:dateFormat timeZone:[NSTimeZone localTimeZone] dateLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
}

+ (NSString*)stringFromDate:(NSDate*)aDate format:(NSString*)dateFormat timeZone:(NSTimeZone*)timeZone dateLocale:(NSLocale*)locale
{
    g_dayDateFormatter.dateFormat = dateFormat;
    [g_dayDateFormatter setTimeZone:timeZone];
    [g_dayDateFormatter setLocale:locale];
    NSString *localDateString = [g_dayDateFormatter stringFromDate:aDate];
    return localDateString;
}

+ (NSDate*)dateFromString:(NSString*) dateStr Format:(NSString*)dateFormat
{
    return [GGUtil dateFromString:dateStr format:dateFormat timeZone:[NSTimeZone localTimeZone] dateLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
}

+ (NSDate*)dateFromString:(NSString*) dateStr format:(NSString*)dateFormat timeZone:(NSTimeZone*)timeZone dateLocale:(NSLocale*)locale
{
    [g_dayDateFormatter setDateFormat:dateFormat];
    [g_dayDateFormatter setTimeZone:timeZone];
    [g_dayDateFormatter setLocale:locale];
    NSDate *date = [g_dayDateFormatter dateFromString:dateStr];
    return date;
}

#pragma mark -
#pragma mark Memory
+ (void)simulateMemoryWarning
{
#if TARGET_IPHONE_SIMULATOR
#ifdef DEBUG
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                         (CFStringRef)@"UISimulatedMemoryWarningNotification", NULL, NULL, true);
#endif
#endif
}


#pragma mark -
#pragma mark URL
+ (NSString *)getLargeSinaAvatar:(NSString *)shortUrl{
    NSString *largeUrl=shortUrl;
    NSRange textRange = [shortUrl rangeOfString:@"sinaimg"];
    if(textRange.location != NSNotFound) {
        largeUrl = [shortUrl stringByReplacingOccurrencesOfString:@"/50/" withString:@"/180/"];
        DLog(@"short url:%@",shortUrl);
        DLog(@"large url:%@",largeUrl);
    }
    return largeUrl;
}



+ (CGFloat)calculateHeightOfMultiLineLabelWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font {
    if (!font) {
        font = [UIFont systemFontOfSize:14.0f];
    }
    CGFloat height = 0;
    height = [STRING_OR_EMPTY(text) boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.height;
    return height;
}

+ (CGFloat)calculateWidthOfMultiLineLabelWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font {
    if (!font) {
        font = [UIFont systemFontOfSize:14.0f];
    }
    CGFloat width = 0;
    width = [STRING_OR_EMPTY(text) boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.width;
    return width;
}

+ (UIView *)creatLineWithOrigin:(CGPoint)origin {
    UIView  *line = [self creatLineWithOrigin:origin color:RGB(225, 225, 225)];
    return line;
}

//+ (UIView *)creatLineWithOrigin:(CGPoint)origin color:(UIColor *)color {
//    UIView  *line = [[UIView alloc]init];
//    line.origin = origin;
//    line.height = 0.5f;
//    line.width = 320.f;
//    line.backgroundColor = color;
//    return line;
//}

+ (NSString*)stringByPrice:(NSString*)price{
    if(price){
        
        NSString *priceString = [NSString stringWithFormat:@"%.2f",[price floatValue]];
        if ([[priceString substringFromIndex:priceString.length - 1] isEqualToString:@"0"]) {
            priceString = [priceString substringToIndex:priceString.length - 1];
            
            if ([priceString rangeOfString:@".0"].location != NSNotFound) {
                priceString = [priceString substringToIndex:priceString.length - 2];
            }
            
        }
        
        return [priceString stringByAppendingString:@"元"];
    }
    return nil;
}

+ (NSString*)symbolStringByPrice:(NSString*)price{
    if(price){
        
        NSString *priceString = [NSString stringWithFormat:@"%.2f",[price floatValue]];
        if ([[priceString substringFromIndex:priceString.length - 1] isEqualToString:@"0"]) {
            priceString = [priceString substringToIndex:priceString.length - 1];
            
            if ([priceString rangeOfString:@".0"].location != NSNotFound) {
                priceString = [priceString substringToIndex:priceString.length - 2];
            }
            
        }
        
        return [@"￥" stringByAppendingString:priceString];
    }
    return nil;
}

+ (NSString *)getOpenUDIDFromUM {
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    DLog(@"{\"oid\": \"%@\"}", deviceID);
    return deviceID;
}

+ (UITableViewCell *)emptyCellOfTabelView:(UITableView *)tableView {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


//bNSData减去aNSData按字节获取---->指定字节数据NSMutableData
+(NSMutableData *)convertNSDataToByte:(NSMutableData *)aData  bData:(NSMutableData *)bData dataType:(NSString * )typeStr
{
    if ([typeStr isEqualToString:@"Live"]) {
        NSLog(@"aData :%@",aData);
        NSLog(@"bData :%@",bData);
        
        
        uint8_t byteArray[[bData length]];
        NSMutableData * byteToDatas;
        [bData getBytes:&byteArray length:[bData length]];
        int bReduceALength =bData.length-aData.length;
        
        uint8_t bReduceAbyteArray[bReduceALength];
        for (int i = 0; i <bReduceALength ; i++ ) {
            //转换
            bReduceAbyteArray[i] = byteArray[aData.length +i];
            //        NSLog(@"---byteArray2%x",bReduceAbyteArray[i]);
        }
        
        byteToDatas = [[NSMutableData alloc]init];
        byteToDatas =  [[NSMutableData alloc]initWithBytes:bReduceAbyteArray length:bReduceALength];
        NSLog(@"---urlDataGGUtil%@",byteToDatas);
        return byteToDatas;
        
    }else if([typeStr isEqualToString:@"REC"]){
        NSLog(@"aData :%@",aData);
        NSLog(@"bData :%@",bData);
        
        
        uint8_t byteArray[[bData length]];
        NSMutableData * byteToDatas;
        [bData getBytes:&byteArray length:[bData length]];
        int bReduceALength =bData.length-aData.length -1;
        
        uint8_t bReduceAbyteArray[bReduceALength];
        for (int i = 0; i <bReduceALength ; i++ ) {
            //转换
            bReduceAbyteArray[i] = byteArray[aData.length +1 +i];
            //        NSLog(@"---byteArray2%x",bReduceAbyteArray[i]);
        }
        
        byteToDatas = [[NSMutableData alloc]init];
        byteToDatas =  [[NSMutableData alloc]initWithBytes:bReduceAbyteArray length:bReduceALength];
        NSLog(@"---urlDataGGUtil%@",byteToDatas);
        return byteToDatas;
        
    }
    
}

//返回时间戳的string类型
+ (NSString *)GetNowTimeString

{
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];  //获取当前时间
    
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeInterval];
    
    return timeString;
    
}

+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
//获取设备的版本信息
+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    //    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone1G";
    //    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone3G";
    //    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone6S Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhoneSE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"] || [deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone8";
    if ([deviceString isEqualToString:@"iPhone10,2"] || [deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"])    return @"iPhoneX";
    
    
    if ([deviceString isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([deviceString isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    if ([deviceString isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    if ([deviceString isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])   return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    　return deviceString;
}
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
+(BOOL)isSTBDEncrypt :(NSString *)characterStr
{
    uint32_t character10 = [characterStr intValue];  //转换成10进制的数
    NSLog(@"character10 :%d",character10);
    
    uint32_t character2_And =  character10 &  0x02;
    NSLog(@"character2 与运算 %d",character2_And);
    
    if (character10 == 1) {
        return YES;
    }else if(character10 == 0)
    {
        return NO;
    }
    
    if (character2_And > 0) {
        // 此处代表需要记性机顶盒加密验证
        //弹窗
        //发送通知
        return YES;
        //        [self popSTBAlertView];
        //        [self popCAAlertView];
        
        
    }else
    {
        return NO;
    }
}
+(BOOL)isCADEncrypt :(NSString *)characterStr
{
    uint32_t character10 = [characterStr intValue];  //转换成10进制的数
    NSLog(@"character10 :%d",character10);
    
    uint32_t character2_And =  character10 &  0x04;
    NSLog(@"character2 与运算 %d",character2_And);
    
    
    if (character2_And > 0) {
        // 此处代表需要记性机顶盒加密验证
        //弹窗
        //发送通知
        return YES;
        //        [self popSTBAlertView];
        //        [self popCAAlertView];
        
        
    }else
    {
        return NO;
    }
}
+(NSString *)judgeIsNeedSTBDecrypt :(NSInteger)row  serviceListDic :(NSDictionary *)dic
{
    NSDictionary * videDicNow = [dic objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    NSString * characterStr ;
    if ([videDicNow isKindOfClass:[NSDictionary class]]){
        if (videDicNow.count > 14) { // 录制
            characterStr  = [videDicNow objectForKey:@"parent_lock"];
        }else
        {
            characterStr  = [videDicNow objectForKey:@"service_character"];
        }
    }
    
    return characterStr;
}
+ (BOOL) judgeTwoEpgDicIsEqual: (NSDictionary *)firstDic TwoDic:(NSDictionary *)twoDic
{
    
    if (firstDic.count > 17 && twoDic.count > 17) { //两个都是录制文件
        NSString * service_tuner_mode1 = [firstDic objectForKey:@"tuner_mode"];
        NSString * service_network_id1 = [firstDic objectForKey:@"network_id"];
        NSString * service_ts_id1 =      [firstDic objectForKey:@"ts_id"];
        NSString * service_service_id1 = [firstDic objectForKey:@"service_id"];
        NSString * service_file_name1 =  [firstDic objectForKey:@"file_name"];
        
        
        NSString * service_tuner_mode2 = [twoDic objectForKey:@"tuner_mode"];
        NSString * service_network_id2 = [twoDic objectForKey:@"network_id"];
        NSString * service_ts_id2 =      [twoDic objectForKey:@"ts_id"];
        NSString * service_service_id2 = [twoDic objectForKey:@"service_id"];
        NSString * service_file_name2 =  [twoDic objectForKey:@"file_name"];
        
        if ([service_tuner_mode1 isEqualToString:service_tuner_mode2] && [service_network_id1 isEqualToString:service_network_id2] && [service_ts_id1 isEqualToString:service_ts_id2] && [service_service_id1 isEqualToString:service_service_id2] && [service_file_name1 isEqualToString:service_file_name2]) {
            return YES;
        }else
        {
            return NO;
        }
    }else
    {
        NSString * service_network_id1 = [firstDic objectForKey:@"service_network_id"];
        NSString * service_ts_id1 = [firstDic objectForKey:@"service_ts_id"];
        NSString * service_service_id1 = [firstDic objectForKey:@"service_service_id"];
        
        
        NSString * service_network_id2 = [twoDic objectForKey:@"service_network_id"];
        NSString * service_ts_id2 = [twoDic objectForKey:@"service_ts_id"];
        NSString * service_service_id2 = [twoDic objectForKey:@"service_service_id"];
        
        
        if ([service_network_id1 isEqualToString:service_network_id2] && [service_ts_id1 isEqualToString:service_ts_id2] && [service_service_id1 isEqualToString:service_service_id2]) {
            return YES;
        }else
        {
            return NO;
        }
    }
    
    
    
}

+(int)judgePlayTypeClass
{
    /*
     1.先判断是那种类型，录制和直播节目是否同时存在
     2.根部不同的类别进行数据组合和最后的赋值
     **/
    //#define   RecAndLiveNotHave  @"0"      //录制和直播都不存在
    //#define   RecExit            @"1"      //录制存在直播不存在
    //#define   LiveExit           @"2"      //录制不存在直播存在
    //#define   RecAndLiveAllHave  @"3"      //录制直播都存在
    NSString * RECAndLiveType = [USER_DEFAULT objectForKey:@"RECAndLiveType"];
    NSLog(@"RECAndLiveType %@",RECAndLiveType);
    
    if ([RECAndLiveType isEqualToString:@"RecAndLiveNotHave"]) {  //都不存在
        return 0;
    }else if ([RECAndLiveType isEqualToString:@"RecExit"]){ //录制存在直播不存在
        return 1;
    }else if ([RECAndLiveType isEqualToString:@"LiveExit"]){ //录制不存在直播存在
        return 2;
    }else if([RECAndLiveType isEqualToString:@"RecAndLiveAllHave"]){//都存在
        return 3;
        
    }
    return 0;
}
//用于将时间戳转化为  时：分：秒
+ (NSString *)timeHMSWithTimeIntervalString:(NSString *)timeString
{
    //    NSTimeInterval time=[timeString doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSTimeInterval time=[timeString doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    if ([[detaildate description] isEqualToString:@"1970-01-01 00:00:00 +0000"]) {
        return @"--:--";
    }
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    //     [dateFormatter setDateFormat:@"现在日期：yyyy年MM月dd日 \n 现在时刻： HH:mm:ss             "];
    NSLog(@"dateFormatter:%@",dateFormatter);
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    NSLog(@"currentDateStr:%@",currentDateStr);
    //    // 格式化时间
    //    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    //    [formatter setDateStyle:NSDateFormatterMediumStyle];
    //    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@" HH:mm"];
    //
    //    // 毫秒值转化为秒
    //    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    //    NSString* dateString = [formatter stringFromDate:date];
    return currentDateStr;
}
//用于将时间戳转化为  YYMMDD 时：分
+ (NSString *)timeYMDHMWithTimeIntervalString:(NSString *)timeString
{
    //    NSTimeInterval time=[timeString doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSTimeInterval time=[timeString doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    if ([[detaildate description] isEqualToString:@"1970-01-01 00:00:00 +0000"]) {
        return @"--:--";
    }
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    //    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSLog(@"dateFormatter:%@",dateFormatter);
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    NSLog(@"currentDateStr:%@",currentDateStr);
    //    // 格式化时间
    //    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    //    [formatter setDateStyle:NSDateFormatterMediumStyle];
    //    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@" HH:mm"];
    //
    //    // 毫秒值转化为秒
    //    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    //    NSString* dateString = [formatter stringFromDate:date];
    return currentDateStr;
}
+(double)getSystemVersion
{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    double systemVersion =  [phoneVersion doubleValue];
    NSLog(@"CalendarIdentifierGregoria %f",systemVersion);
    return systemVersion;
}
///Data 的信息转换成IP
+(NSString *)switchDataToIp:(NSData *)data
{
    if (data.length > 3) {
        NSData * IPData1 = [data subdataWithRange:NSMakeRange(3, 1)];
        uint8_t IPInt1 = [SocketUtils uint8FromBytes:IPData1];
        
        NSData * IPData2 = [data subdataWithRange:NSMakeRange(2, 1)];
        uint8_t IPInt2 = [SocketUtils uint8FromBytes:IPData2];
        
        NSData * IPData3 = [data subdataWithRange:NSMakeRange(1, 1)];
        uint8_t IPInt3 = [SocketUtils uint8FromBytes:IPData3];
        
        NSData * IPData4 = [data subdataWithRange:NSMakeRange(0, 1)];
        uint8_t IPInt4 = [SocketUtils uint8FromBytes:IPData4];
        
        NSString * IPStr = [NSString stringWithFormat:@"%d.%d.%d.%d",IPInt1,IPInt2,IPInt3,IPInt4];
        NSLog(@"ipipipipstr : %@",IPStr);
        
        return IPStr;
    }
    return 0;
    
}


+ (void)getCurrentLanguage
{
    //    NSArray *languages = [NSLocale preferredLanguages];
    //    NSString *currentLanguage = [languages objectAtIndex:0];
    //    NSString *localeLanguageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    NSString* strLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if (strLanguage.length >=2) {
        NSString *str1 = [strLanguage substringToIndex:2];
        [USER_DEFAULT setObject:str1 forKey:@"systemLocalLanguage"];
    }
    //    NSLog( @"当前的语言%@" , localeLanguageCode);
    
}
+(void)addTVViewGuideView:(NSMutableArray*)paths
{
    NSString * MLRecording = NSLocalizedString(@"MLRecording", nil);
    
    if (MLRecording.length > 10) {
        [paths addObject:[[NSBundle mainBundle] pathForResource:@"法语引导页1" ofType:@"png"]];
        [paths addObject:[[NSBundle mainBundle] pathForResource:@"法语引导页2" ofType:@"png"]];
        [paths addObject:[[NSBundle mainBundle] pathForResource:@"法语引导页3" ofType:@"png"]];
        [paths addObject:[[NSBundle mainBundle] pathForResource:@"法语引导页4" ofType:@"png"]];
    }else
    {
        [paths addObject:[[NSBundle mainBundle] pathForResource:@"引导页1" ofType:@"png"]];
        [paths addObject:[[NSBundle mainBundle] pathForResource:@"引导页2" ofType:@"png"]];
        [paths addObject:[[NSBundle mainBundle] pathForResource:@"引导页3" ofType:@"png"]];
        [paths addObject:[[NSBundle mainBundle] pathForResource:@"引导页4" ofType:@"png"]];
    }
    
    
}

// TVViewNotific
+(void)showDeliveryStopIsNull
{
    NSNotification *notification =[NSNotification notificationWithName:@"cantDeliveryNotific" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    NSNotification *notification1 =[NSNotification notificationWithName:@"fullScreenBtnHidden" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
}
+(void)postfullScreenBtnShow
{
    NSNotification *notification1 =[NSNotification notificationWithName:@"fullScreenBtnShow" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
}
+ (void)postSTBDencryptNotific:(NSDictionary*)dic
{
    NSNotification *notification1 =[NSNotification notificationWithName:@"STBDencryptNotific" object:nil userInfo:dic];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
}
+ (void)postnoPlayShowNotic
{
    NSNotification *notification =[NSNotification notificationWithName:@"noPlayShowNotic" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
+ (void)postcantDeliveryNotific
{
    NSNotification *notification =[NSNotification notificationWithName:@"cantDeliveryNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
+ (void)postremoveConfigCAPINShowNotific
{
    NSNotification *notification1 =[NSNotification notificationWithName:@"removeConfigCAPINShowNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
}
+ (void)postnoPlayShowShutNotic
{
    NSNotification *notification1 =[NSNotification notificationWithName:@"noPlayShowShutNotic" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
}
+ (void)postIndicatorViewShowNotic
{
    NSNotification *notification =[NSNotification notificationWithName:@"IndicatorViewShowNotic" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
+ (void)postTimerOfEventTimeNotific
{
    NSNotification *notification =[NSNotification notificationWithName:@"TimerOfEventTimeNotific" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
+ (void)postsetChannelNameAndEventNameNotic:(NSDictionary*)dic
{
    NSNotification *notification22 =[NSNotification notificationWithName:@"setChannelNameAndEventNameNotic" object:nil userInfo:dic];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification22];
}
@end

