//
//  ServiceModel.h
//  StarAPP
//
//  Created by xyz on 16/9/12.
//
//

#import <Foundation/Foundation.h>

@interface ServiceModel : NSObject

@property (nonatomic, assign) NSString * service_network_id;
@property (nonatomic, assign) NSString * service_ts_id;
@property (nonatomic, assign) NSString * service_service_id;
@property (nonatomic, assign) NSString * service_tuner_mode;
@property (nonatomic, assign) NSString * service_index;
@property (nonatomic, assign) NSString * service_play_flag;
@property (nonatomic, assign) NSString * service_type;
@property (nonatomic, assign) NSString * service_logic_number;
@property (nonatomic, assign) NSString * service_character;
@property (nonatomic, strong) NSString *service_name;

//audio
@property (nonatomic, assign) NSString * audio_pid;
@property (nonatomic, strong) NSString *audio_language;


//subt
@property (nonatomic, assign) NSString * subt_pid;
@property (nonatomic, strong) NSString *subt_language;

//epg
@property (nonatomic, assign) NSString * event_id;
@property (nonatomic, strong) NSString *event_name;
@property (nonatomic, assign) NSString * event_starttime;
@property (nonatomic, assign) NSString * event_endtime;
@end
