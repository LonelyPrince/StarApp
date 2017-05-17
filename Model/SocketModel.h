//
//  SocketModel.h
//  StarAPP
//
//  Created by xyz on 16/9/19.
//
//

#import <Foundation/Foundation.h>



//111111111
// 客户端向服务器发送的心跳数据包
@interface Cs_Hearbeat : NSObject


//@property (nonatomic, strong) NSString *  package_tag;
//@property (nonatomic, assign) uint32_t  CRC;

@property (nonatomic, strong) NSString *  module_name;
@property (nonatomic, assign) uint32_t  Ret;
@property (nonatomic, assign) uint32_t  Reserved;
@property (nonatomic, strong) NSArray *   client_ip;
@property (nonatomic, assign) uint32_t  data_len;
//@property (nonatomic, assign) uint32_t  port;
//@property (nonatomic, strong) NSString  *pdata;     //此处放数据，但类型不确定

@end


//22222222
// 客户端向服务器发送节目信息获取数据包
@interface Cs_Service : NSObject

//@property (nonatomic, assign) uint8_t  sceneId;
//@property (nonatomic, assign) uint32_t line;
//@property (nonatomic, strong) NSString *message;

//@property (nonatomic, assign) NSString *  package_tag;
//@property (nonatomic, assign) uint32_t  CRC;

@property (nonatomic, strong) NSString *  module_name;
@property (nonatomic, assign) uint32_t  Ret;
@property (nonatomic, assign) uint32_t  Reserved;
@property (nonatomic, strong) NSArray *   client_ip;
@property (nonatomic, assign) uint32_t  data_len;

//data区域
@property (nonatomic, assign) uint32_t  client_port;
@property (nonatomic, assign) uint32_t  unique_id;        //系统时间  唯一标识
@property (nonatomic, assign) uint8_t  command_type;       //类型枚举
@property (nonatomic, assign) uint32_t  tuner_type;        //http请求获得的   tuner_mode
@property (nonatomic, assign) uint16_t  network_id;        //http请求获得的
@property (nonatomic, assign) uint16_t  ts_id;             //http请求获得的
@property (nonatomic, assign) uint16_t  service_id;        //http请求获得的
@property (nonatomic, assign) uint16_t  audio_index;       //http请求获得的，有可能获取多个，此处可以任选一个
@property (nonatomic, assign) uint16_t  subt_index;      //http请求获得的，此处可能为空默认0
@property (nonatomic, assign) uint8_t  data_len_name;   //client_name的长度
@property (nonatomic, strong) NSString *  client_name;  //phone+型号
@property (nonatomic, assign) uint8_t  data_len_m3u8;  //m3u8的长度 ，此处默认为0

//@property (nonatomic, assign) uint32_t  data_len;




@end
//33333333333
//// 客户端向服务器发送退出视频分发
@interface Cs_PlayExit : NSObject

@property (nonatomic, strong) NSString *  module_name;
@property (nonatomic, assign) uint32_t  Ret;
@property (nonatomic, assign) uint32_t  Reserved;
@property (nonatomic, strong) NSArray *   client_ip;
@property (nonatomic, assign) uint32_t  data_len;

//data区域
@property (nonatomic, assign) uint32_t  client_port;
@property (nonatomic, assign) uint32_t  unique_id;        //系统时间  唯一标识
@property (nonatomic, assign) uint8_t  command_type;       //类型枚举


@end

//444444444
// 客户端向服务器发送密码校验
@interface Cs_PasswordCheck : NSObject

@property (nonatomic, strong) NSString *  module_name;
@property (nonatomic, assign) uint32_t  Ret;
@property (nonatomic, assign) uint32_t  Reserved;
@property (nonatomic, strong) NSArray *   client_ip;
@property (nonatomic, assign) uint32_t  data_len;

//data区域
@property (nonatomic, assign) uint32_t  client_port;
@property (nonatomic, assign) uint32_t  unique_id;        //系统时间  唯一标识
@property (nonatomic, assign) uint8_t  command_type;       //类型枚举
@property (nonatomic, assign) uint8_t  passwd_type;       //密码类型
@property (nonatomic, strong) NSString *  passwd_string;    //4位或者6位长度的密码
//还有个passwd_string
@end


//5555555
// 客户端向服务器发送更新频道列表
@interface Cs_UpdateChannel : NSObject

@property (nonatomic, strong) NSString *  module_name;
@property (nonatomic, assign) uint32_t  Ret;
@property (nonatomic, assign) uint32_t  Reserved;
@property (nonatomic, strong) NSArray *   client_ip;
@property (nonatomic, assign) uint32_t  data_len;

//data区域
@property (nonatomic, assign) uint32_t  client_port;
@property (nonatomic, assign) uint32_t  unique_id;        //系统时间  唯一标识
@property (nonatomic, assign) uint8_t  command_type;       //类型枚举
@property (nonatomic, assign) uint8_t  update_flag;       //密码类型

@end


//6666666
// 客户端向服务器发送ca控制节目输pin码
@interface Cs_CAMatureLock : NSObject

@property (nonatomic, strong) NSString *  module_name;
@property (nonatomic, assign) uint32_t  Ret;
@property (nonatomic, assign) uint32_t  Reserved;
@property (nonatomic, strong) NSArray *   client_ip;
@property (nonatomic, assign) uint32_t  data_len;

//data区域
@property (nonatomic, assign) uint32_t  client_port;
@property (nonatomic, assign) uint32_t  unique_id;        //系统时间  唯一标识
@property (nonatomic, assign) uint8_t  command_type;       //类型枚举
@property (nonatomic, assign) uint16_t  network_id;        //http请求获得的
@property (nonatomic, assign) uint16_t  ts_id;             //http请求获得的
@property (nonatomic, assign) uint16_t  service_id;        //http请求获得的
//@property (nonatomic, assign) uint8_t    num;       //http请求获得的，有可能获取多个，此处可以任选一个


@end


//777777
// 客户端向服务器发送获取资源信息
@interface Cs_GetResource : NSObject

@property (nonatomic, strong) NSString *  module_name;
@property (nonatomic, assign) uint32_t  Ret;
@property (nonatomic, assign) uint32_t  Reserved;
@property (nonatomic, strong) NSArray *   client_ip;
@property (nonatomic, assign) uint32_t  data_len;

//data区域
@property (nonatomic, assign) uint32_t  client_port;
@property (nonatomic, assign) uint32_t  unique_id;        //系统时间  唯一标识
@property (nonatomic, assign) uint8_t  command_type;       //类型枚举
//@property (nonatomic, assign) uint16_t  network_id;        //http请求获得的
//@property (nonatomic, assign) uint16_t  ts_id;             //http请求获得的
//@property (nonatomic, assign) uint16_t  service_id;        //http请求获得的
//@property (nonatomic, assign) uint8_t    num;       //http请求获得的，有可能获取多个，此处可以任选一个

@end




//8888888
// 客户端向服务器发送获取路由IP地址  枚举类型： DTV_SERVICE_MD_GET_ROUTE_IP  大概是24
@interface Cs_GetRouteIPAddress : NSObject

@property (nonatomic, strong) NSString *  module_name;
@property (nonatomic, assign) uint32_t  Ret;
@property (nonatomic, assign) uint32_t  Reserved;
@property (nonatomic, strong) NSArray *   client_ip;
@property (nonatomic, assign) uint32_t  data_len;

//data区域
@property (nonatomic, assign) uint32_t  client_port;
@property (nonatomic, assign) uint32_t  unique_id;        //系统时间  唯一标识
@property (nonatomic, assign) uint8_t  command_type;       //类型枚举

@end




////////////////////////////////////
// 服务器向客户端返回的数据包
@interface Sc_20001 : NSObject

@property (nonatomic, assign) uint32_t  CRC;
@property (nonatomic, assign) NSString *  package_tag;
@property (nonatomic, assign) NSString *  module_name;
@property (nonatomic, assign) uint32_t  Ret;
@property (nonatomic, assign) uint32_t  Reserved;
@property (nonatomic, assign) NSString *  client_ip;
@property (nonatomic, assign) uint32_t  data_len;
@property (nonatomic, assign) uint32_t  port;
@property (nonatomic, strong) NSString  *pdata;     //此处放数据，但类型不确定
@end

