//
//  UICustomAlertView.m
//  DSE
//
//  Created by Rishikesh on 09/05/15.
//  Copyright (c) 2015 LetsIDev. All rights reserved.
//

#import "UICustomAlertView.h"

@implementation UICustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    
    NSLog(@"不一致，不弹窗。===或者将窗口取消掉44");
    if(self.dontDisppear && buttonIndex == 0)  //如果 dontDisppear == yes,并且用户点击了determine
        return;
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
