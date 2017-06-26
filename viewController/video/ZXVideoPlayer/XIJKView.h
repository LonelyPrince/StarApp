//
//  XIJKView.h
//  ZXVideoPlayer
//
//  Created by xyz on 2017/6/20.
//  Copyright © 2017年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <IJKMediaFramework/IJKMediaFramework.h>
#import <IJKMediaFramework/IJKFFMoviePlayerController.h>

@interface XIJKView :  IJKFFMoviePlayerController //IJKFFMoviePlayerController//UIView

@property (nonatomic, retain) IJKFFMoviePlayerController *player;
@property (nonatomic, assign) CGRect frame1;
//

@property (atomic, retain) NSURL * url;

@property (nonatomic,retain) UIView *view;

- (instancetype)init:(CGRect)frame;
//-(void)initIJKPlayer:(NSURL * )url;

//-(void)createPlayer:(NSURL*) url ;

@end

