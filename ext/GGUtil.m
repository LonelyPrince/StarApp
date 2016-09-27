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
+(NSMutableData *)convertNSDataToByte:(NSMutableData *)aData  bData:(NSMutableData *)bData
{
    
    uint8_t byteArray[[bData length]];
    NSMutableData * byteToDatas;
    [bData getBytes:&byteArray length:[bData length]];
    int bReduceALength =bData.length-aData.length;
    
    uint8_t bReduceAbyteArray[bReduceALength];
    for (int i = 0; i <bReduceALength ; i++ ) {
        //转换
        bReduceAbyteArray[i] = byteArray[aData.length +i];
        NSLog(@"---byteArray2%x",bReduceAbyteArray[i]);
    }
    
    byteToDatas = [[NSMutableData alloc]init];
    byteToDatas =  [[NSMutableData alloc]initWithBytes:bReduceAbyteArray length:bReduceALength];
    NSLog(@"---urlData%@",byteToDatas);
    return byteToDatas;
    
}




@end
