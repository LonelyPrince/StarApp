//
//  OtherDevicePushLive.h
//  StarAPP
//
//  Created by xyz on 2018/1/23.
//

#import <Foundation/Foundation.h>

@interface OtherDevicePushLive : NSObject

@property (nonatomic, assign) uint8_t  file_name_len;
@property (nonatomic, strong) NSString *file_name;

@property (nonatomic, strong) NSMutableArray *src_push_client_ip;

@property (nonatomic, assign) uint8_t  src_client_name_len;
@property (nonatomic, strong) NSString *src_client_name;


@end
