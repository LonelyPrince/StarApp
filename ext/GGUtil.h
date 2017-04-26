//
//  GGGGUtil.h
//  Ganguo
//
//  Created by gump on 11-5-13.
//  Copyright 2011年 f4 . All rights reserved.
//


@interface GGUtil : NSObject

+ (NSDateFormatter*)dateFormatter;

+ (NSString *)urlAppendRetina:(NSMutableString *)urlString;

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageMono:(UIImage *)image ;


+ (CGSize)getScaleRect:(CGSize)originSize targetSize:(CGSize)maxSize;

+ (UIImage *)makeAShotWithView:(UIView*)aView;

+ (NSMutableDictionary *)getClassPropertys:(id)fromClass;

+ (UIColor *)randomColor;

+ (UIAlertView *) showAlert: (NSString *) theMessage title:(NSString *) theTitle;

+ (NSMutableDictionary *)stringToDictionary:(NSString *)sourceString withSeparator:(NSString *)separator;

+ (NSString *)getShowName:(NSString *)username
            withFirstName:(NSString *)firstName
             withLastName:(NSString *)lastName;

+ (BOOL)canSendSMS;

+ (BOOL)checkNetworkConnection;

+ (NSString *)getDistanceText:(double)distance;

+ (void)storeBadge;

+ (int)getStoredBadge;

+ (void)simulateMemoryWarning;

+ (NSString *)limitString:(NSString *)string withLength:(unsigned short)length;

+ (NSString *)timeToText:(NSDate *)time;

+ (NSString*)stringFromDate:(NSDate*)aDate format:(NSString*)dateFormat;

+ (NSString*)stringFromDate:(NSDate*)aDate format:(NSString*)dateFormat timeZone:(NSTimeZone*)timeZone dateLocale:(NSLocale*)locale;

+ (NSDate*)dateFromString:(NSString*) dateStr Format:(NSString*)dateFormat;

+ (NSDate*)dateFromString:(NSString*) dateStr format:(NSString*)dateFormat timeZone:(NSTimeZone*)timeZone dateLocale:(NSLocale*)locale;

+(BOOL)isValidateEmail:(NSString *)email;

+(BOOL)isValidateMobile:(NSString *)mobile;

+(BOOL)isValidateTelephone:(NSString*)telephone;

+ (BOOL)isValidZipcode:(NSString*)value;

//+ (NSString*)UUID;

//+ (NSUInteger)launchTimes;
//
//+ (BOOL)hasLaunchBeforeAtThisVersion;

+ (CGFloat)calculateHeightOfMultiLineLabelWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;

+ (CGFloat)calculateWidthOfMultiLineLabelWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font;

+ (UIView *)creatLineWithOrigin:(CGPoint)origin;

+ (UIView *)creatLineWithOrigin:(CGPoint)origin color:(UIColor *)color;

+ (NSString*)stringByPrice:(NSString*)price;

+ (NSString*)symbolStringByPrice:(NSString*)price;

+ (NSString *)getOpenUDIDFromUM;

+ (UITableViewCell *)emptyCellOfTabelView:(UITableView *)tableView;


//Data
+(NSMutableData *)convertNSDataToByte:(NSMutableData *)aData  bData:(NSMutableData *)bData ;
+ (NSString *)GetNowTimeString;

//+ (NSString *)getIPAddress;   //这个方法只能获取WiFi的IP地址，如果是流量的话获取不到
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (NSString*)deviceVersion;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
+(BOOL)isSTBDEncrypt :(NSString *)characterStr;
+(BOOL)isCADEncrypt :(NSString *)characterStr;
+(NSString *)judgeIsNeedSTBDecrypt :(NSInteger)row  serviceListDic :(NSDictionary *)dic;
+ (BOOL)judgeTwoEpgDicIsEqual: (NSDictionary *)firstDic TwoDic:(NSDictionary *)twoDic;
@end
