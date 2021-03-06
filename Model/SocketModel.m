//
//  SocketModel.m
//  StarAPP
//
//  Created by xyz on 16/9/19.
//
//

#import "SocketModel.h"

//1.心跳
@implementation Cs_Hearbeat

@end



//2.获取节目信息
@implementation Cs_Service

@end


//3.退出视频分发
@implementation Cs_PlayExit

@end

//4.客户端向服务器发送密码校验
@implementation Cs_PasswordCheck
@end

// 5.客户端向服务器发送更新频道列表
@implementation Cs_UpdateChannel
@end



//6.客户端向服务器发送ca控制节目输pin码
@implementation Cs_CAMatureLock
@end

//7.客户端向服务器发送获取资源信息
@implementation Cs_GetResource
@end

//8.客户端向服务器发送获取路由IP地址 
@implementation Cs_GetRouteIPAddress
@end

//9.获取投屏设备列表信息
@implementation Cs_GetPushDeviceInfo
@end

//10.手机投电视直播
@implementation Cs_MDPushService
@end

//11.手机投电视录制
@implementation Cs_MDPushFile
@end

//12.电视直播投手机
@implementation Sc_MDOtherPushService
@end

//13.电视录制投手机
@implementation Sc_MDOtherPushLive
@end

//14.卡级别
@implementation Sc_MDGetCardType
@end
