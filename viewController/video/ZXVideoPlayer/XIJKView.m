//
//  XIJKView.m
//  StarAPP
//
//  Created by xyz on 2017/6/19.
//
//

#import "XIJKView.h"


@implementation XIJKView
@synthesize view;
@synthesize player;
- (instancetype)init:(CGRect)frame
{
    //    self = [super initWithFrame:frame];
    self = [super init];
    if (self) {
        
        //        self.view = [[UIView alloc]init ];
        [self initViews:frame];
        self.frame1 = frame;
        //        self.view = [[UIView alloc]initWithFrame:frame];
        //        self.view.backgroundColor = [UIColor redColor];
        
        
        //        [self addSubview:self.view];
        
        
    }
    return self;
}
-(void)initViews:(CGRect)frame
{
    self.view = [[UIView alloc]initWithFrame:frame];
    self.view.backgroundColor = [UIColor blueColor];
    
}





@end
