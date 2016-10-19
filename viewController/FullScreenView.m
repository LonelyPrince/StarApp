//
//  FullScreenView.m
//  StarAPP
//
//  Created by xyz on 2016/10/18.
//
//

#import "FullScreenView.h"

@implementation FullScreenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    return self;
}



@end
