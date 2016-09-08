//
//  NSObject+JSONCategories.m
//  WithBusiness
//
//  Created by maple on 14-1-24.
//  Copyright (c) 2014年 sinosoft. All rights reserved.
//

#import "NSObject+JSONCategories.h"

@implementation NSObject (JSONCategories)

-(NSString*)JSONString;
{
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                      encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}

-(NSData*)JSONData{
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}


@end
