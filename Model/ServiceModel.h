//
//  ServiceModel.h
//  StarAPP
//
//  Created by xyz on 16/9/12.
//
//

#import <Foundation/Foundation.h>

@interface ServiceModel : NSObject

@property (nonatomic, strong) NSString * service_network_id;
@property (nonatomic, strong) NSString * service_ts_id;
@property (nonatomic, strong) NSString * service_service_id;
@property (nonatomic, strong) NSString * service_tuner_mode;
@property (nonatomic, strong) NSString * service_index;
@property (nonatomic, strong) NSString * service_play_flag;
@property (nonatomic, strong) NSString * service_type;
@property (nonatomic, strong) NSString * service_logic_number;
@property (nonatomic, strong) NSString * service_character;
@property (nonatomic, strong) NSString *service_name;

//audio
@property (nonatomic, strong) NSString * audio_pid;
@property (nonatomic, strong) NSString *audio_language;


//subt
@property (nonatomic, strong) NSString * subt_pid;
@property (nonatomic, strong) NSString *subt_language;

//epg
@property (nonatomic, strong) NSString * event_id;
@property (nonatomic, strong) NSString *event_name;
@property (nonatomic, strong) NSString * event_starttime;
@property (nonatomic, strong) NSString * event_endtime;
@end
