//
//  NSData+JSONCategories.m
//  Huangye
//
//  Created by FY on 14-8-29.
//  Copyright (c) 2014年 Super_Fy. All rights reserved.
//

#import "NSData+JSONCategories.h"

@implementation NSData (JSONCategories)

-(id)JSONValue;
{
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end
