//
//  OtherDevicePushService.h
//  StarAPP
//
//  Created by xyz on 2018/1/22.
//

#import <Foundation/Foundation.h>

@interface OtherDevicePushService : NSObject

@property (nonatomic, assign) uint32_t * service_tuner_type;
@property (nonatomic, assign) uint16_t * service_network_id;
@property (nonatomic, assign) uint16_t * service_ts_id;
@property (nonatomic, assign) uint16_t * service_service_id;
@property (nonatomic, assign) uint16_t * audio_pid;
@property (nonatomic, assign) uint16_t * subt_pid;



@property (nonatomic, strong) NSMutableArray *src_push_client_ip;
@property (nonatomic, assign) uint8_t  src_client_name_len;
@property (nonatomic, strong) NSString *src_client_name;




@end
