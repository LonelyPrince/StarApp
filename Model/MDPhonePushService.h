//
//  MDPhonePushService.h
//  StarAPP
//
//  Created by xyz on 2018/1/12.
//

#import <Foundation/Foundation.h>

@interface MDPhonePushService : NSObject

@property (nonatomic, strong) NSString * service_tuner_type;
@property (nonatomic, strong) NSString * service_network_id;
@property (nonatomic, strong) NSString * service_ts_id;
@property (nonatomic, strong) NSString * service_service_id;
@property (nonatomic, strong) NSString * audio_pid;
@property (nonatomic, strong) NSString * subt_pid;


@property (nonatomic, strong) NSString * service_index;
@property (nonatomic, strong) NSString * service_play_flag;
@property (nonatomic, strong) NSString * service_type;
@property (nonatomic, strong) NSString * service_logic_number;
@property (nonatomic, strong) NSString * service_character;
@property (nonatomic, strong) NSString *service_name;
@property (nonatomic, assign) uint8_t  client_name_len;
@property (nonatomic, strong) NSString *client_name;
@property (nonatomic, assign) uint8_t  push_type;
@property (nonatomic, assign) uint8_t  client_count;
@property (nonatomic, strong) NSMutableArray *push_client_ip;

@end
