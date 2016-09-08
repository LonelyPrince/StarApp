//
//  NSObject+JSONCategories.h
//  WithBusiness
//  NSObject扩展类,用途将数据转化为json
//  Created by maple on 14-1-24.
//  Copyright (c) 2014年 sinosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSONCategories)

/**
 * 描述：将NSArray或者NSDictionary转化为NSData
 * 参数：
 * 返回值：转化后的NSData
 *
 */
-(NSData*)JSONData;

/**
 * 描述：将NSArray或者NSDictionary转化为NSString
 * 参数：
 * 返回值：转化后的NSString
 *
 */
-(NSString*)JSONString;

@end
