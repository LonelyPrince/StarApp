//
//  AboutViewController.m
//  StarAPP
//
//  Created by xyz on 2016/11/8.
//
//

#import "AboutViewController.h"

@interface AboutViewController ()
{
    NSString * deviceString;
}
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"About";
    [self loadUI];
    
    
    
}
-(void)loadUI
{
    deviceString = [GGUtil deviceVersion];
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是5s和4s的大小");
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        //    imageView.image = [UIImage imageNamed:@"关于about"];
        imageView.image = [UIImage imageNamed:@"4关于"];
        [self.view addSubview:imageView];

      
        
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        //    imageView.image = [UIImage imageNamed:@"关于about"];
        imageView.image = [UIImage imageNamed:@"关于"];
        [self.view addSubview:imageView];
        
    }
    else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]  ) {
        NSLog(@"此刻是6的大小");
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        //    imageView.image = [UIImage imageNamed:@"关于about"];
        imageView.image = [UIImage imageNamed:@"关于"];
        [self.view addSubview:imageView];
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -7, SCREEN_WIDTH, SCREEN_HEIGHT+7)];
        
        //    imageView.image = [UIImage imageNamed:@"关于about"];
        imageView.image = [UIImage imageNamed:@"关于"];
        [self.view addSubview:imageView];
        
    }
    
    
    
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
