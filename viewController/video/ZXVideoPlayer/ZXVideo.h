//
//  ZXVideo.h
//  ZXVideoPlayer
//
//  Created by Shawn on 16/6/22.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "THProgressView.h"

@interface ZXVideo : NSObject

/// 标题
@property (nonatomic, copy, readwrite) NSString *title;
/// 播放地址
@property (nonatomic, copy, readwrite) NSString *playUrl;

/// 播放节目名称
@property (nonatomic, copy, readwrite) NSString *playEventName;

///频道号
@property (nonatomic, copy, readwrite) NSString *channelId;
///频道名称
@property (nonatomic, copy, readwrite) NSString *channelName;

//开始时间
@property (nonatomic, copy, readwrite) NSString *startTime;
//结束时间
@property (nonatomic, copy, readwrite) NSString *endTime;

/*
 字幕 音轨
 */
//@property (nonatomic, strong) NSMutableArray *subAudioData;
@property (strong,nonatomic)NSMutableDictionary * dicSubAudio;

@property (strong,nonatomic)NSMutableDictionary * dicChannl;

@property (assign,nonatomic)int channelCount;

//@property (strong,nonatomic)NSMutableDictionary * dicAudio;

@end
