//
//  LBGetHttpRequest.h
//  Huangye
//
//  Created by mac on 14-7-30.
//  Copyright (c) 2014年 Super_Fy. All rights reserved.
//
//Cur_kSDLB_SYS_SERVER
#import "ASIHTTPRequest.h"
// 服务器地址
// 超时时间
#define kSDLB_SYS_TIMEOUT     10
@interface LBGetHttpRequest : ASIHTTPRequest<ASIHTTPRequestDelegate>

@property (nonatomic, assign) BOOL isNeedShowWaring;
@property (nonatomic, assign) BOOL isNeedHideHud;
//@property (nonatomic, retain) NSTimer * timerGetHMC;
//@property (nonatomic, retain) id(^LoadHMCServiceurl)();
- (id) initWithInterfaceName:(NSString *) interfaceName;
@end
