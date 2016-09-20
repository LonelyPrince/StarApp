//
//  SocketModel.h
//  StarAPP
//
//  Created by xyz on 16/9/19.
//
//

#import <Foundation/Foundation.h>
// 客户端向服务器发送的数据包
@interface Cs_20001 : NSObject

//@property (nonatomic, assign) uint8_t  sceneId;
//@property (nonatomic, assign) uint32_t line;
//@property (nonatomic, strong) NSString *message;

@property (nonatomic, assign) NSString *  package_tag;
@property (nonatomic, assign) uint32_t  CRC;

@property (nonatomic, assign) NSString *  module_name;
@property (nonatomic, assign) uint32_t  Ret;
@property (nonatomic, assign) uint32_t  Reserved;
@property (nonatomic, assign) NSArray *   client_ip;
//@property (nonatomic, assign) uint32_t  data_len;
//@property (nonatomic, assign) uint32_t  port;
//@property (nonatomic, strong) NSString  *pdata;     //此处放数据，但类型不确定

@end

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
