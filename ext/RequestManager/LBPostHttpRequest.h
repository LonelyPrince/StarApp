//
//  LBDataManager.h
//  TestDemo
//
//  Created by mac on 14-6-30.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
// 服务器地址
// 超时时间
//#define kSDLB_SYS_TIMEOUT     60
@interface LBPostHttpRequest : ASIFormDataRequest<ASIHTTPRequestDelegate>


@property (nonatomic, assign) BOOL isNeedShowWaring;
@property (nonatomic, assign) BOOL isNeedHideHud;

- (id) initWithInterfaceName:(NSString *) interfaceName ApiModule:(NSString *) apimodule;

- (id) initWithInterfaceName:(NSString *) interfaceName ApiModule:(NSString *) apimodule WithOutApiString:(BOOL)apiState;

+ (NSArray *) getDataCounters;
+ (NSString *)generateURLwithOriginUrl:(NSString *)url withParamters:(NSDictionary *)paramters;
@end
