//
//  FilePushService.h
//  StarAPP
//
//  Created by xyz on 2018/1/17.
//

#import <Foundation/Foundation.h>

@interface FilePushService : NSObject


@property (nonatomic, assign) uint8_t  file_name_len;
@property (nonatomic, strong) NSString *file_name;
@property (nonatomic, assign) uint8_t  client_name_len;
@property (nonatomic, strong) NSString *client_name;
@property (nonatomic, assign) uint8_t  push_type;
@property (nonatomic, assign) uint8_t  client_count;
@property (nonatomic, strong) NSMutableArray *push_client_ip;



@end
