//
//  Cs_serviceREC.h
//  StarAPP
//
//  Created by xyz on 2017/11/15.
//

#import <Foundation/Foundation.h>

@interface Cs_serviceREC : NSObject

@property (nonatomic, strong) NSString *  module_name;
@property (nonatomic, assign) uint32_t  Ret;
@property (nonatomic, assign) uint32_t  Reserved;
@property (nonatomic, strong) NSArray *   client_ip;
@property (nonatomic, assign) uint32_t  data_len;

//data区域
@property (nonatomic, assign) uint32_t  client_port;
@property (nonatomic, assign) uint32_t  unique_id;        //系统时间  唯一标识
@property (nonatomic, assign) uint8_t  command_type;       //类型枚举

@property (nonatomic, assign) uint8_t  client_name_len;   //client_name的长度
@property (nonatomic, strong) NSString *  client_name;  //phone+型号
@property (nonatomic, assign) uint8_t  file_name_len;  //
@property (nonatomic, strong) NSString *  file_name;  //
//@property (nonatomic, assign) uint32_t  data_len;

@end
// 客户端向服务器发送播放录制文件

