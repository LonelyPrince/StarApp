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

@property (nonatomic, strong) UILabel * verLabShow;
@end


@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"About";
    [self loadUI];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
self.tabBarController.tabBar.hidden = YES;
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
        
        //新加版本信息
        self.verLabShow = [[UILabel alloc]init];
        _verLabShow.text = @"StarTimes App iOS V1.0.3";
        CGSize sizeOfVerLabShow = [self sizeWithText:_verLabShow.text font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.verLabShow.frame = CGRectMake((SCREEN_WIDTH - sizeOfVerLabShow.width)/2, 276, sizeOfVerLabShow.width, sizeOfVerLabShow.height);
        self.verLabShow.font = FONT(14);
        self.verLabShow.textColor = RGB(0x32, 0x32, 0x32);
        [imageView addSubview:self.verLabShow];
        
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        //    imageView.image = [UIImage imageNamed:@"关于about"];
        imageView.image = [UIImage imageNamed:@"关于"];
        [self.view addSubview:imageView];
        
        //新加版本信息
        self.verLabShow = [[UILabel alloc]init];
        _verLabShow.text = @"StarTimes App iOS V1.0.3";
        CGSize sizeOfVerLabShow = [self sizeWithText:_verLabShow.text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.verLabShow.frame = CGRectMake((SCREEN_WIDTH - sizeOfVerLabShow.width)/2, 300, sizeOfVerLabShow.width, sizeOfVerLabShow.height);
        self.verLabShow.font = FONT(15);
        self.verLabShow.textColor = RGB(0x32, 0x32, 0x32);
        [imageView addSubview:self.verLabShow];
        
        
    }
    else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]  ) {
        NSLog(@"此刻是6的大小");
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        //    imageView.image = [UIImage imageNamed:@"关于about"];
        imageView.image = [UIImage imageNamed:@"关于"];
        [self.view addSubview:imageView];
        
        
        //新加版本信息
        self.verLabShow = [[UILabel alloc]init];
        _verLabShow.text = @"StarTimes App iOS V1.0.3";
        CGSize sizeOfVerLabShow = [self sizeWithText:_verLabShow.text font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.verLabShow.frame = CGRectMake((SCREEN_WIDTH - sizeOfVerLabShow.width)/2, 356, sizeOfVerLabShow.width, sizeOfVerLabShow.height);
        self.verLabShow.font = FONT(16);
        self.verLabShow.textColor = RGB(0x32, 0x32, 0x32);
        [imageView addSubview:self.verLabShow];
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -7, SCREEN_WIDTH, SCREEN_HEIGHT+7)];
        
        //    imageView.image = [UIImage imageNamed:@"关于about"];
        imageView.image = [UIImage imageNamed:@"关于"];
        [self.view addSubview:imageView];
        
        //新加版本信息
        self.verLabShow = [[UILabel alloc]init];
        _verLabShow.text = @"StarTimes App iOS V1.0.3";
        CGSize sizeOfVerLabShow = [self sizeWithText:_verLabShow.text font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.verLabShow.frame = CGRectMake((SCREEN_WIDTH - sizeOfVerLabShow.width)/2, 390, sizeOfVerLabShow.width, sizeOfVerLabShow.height);
        self.verLabShow.font = FONT(18);
        self.verLabShow.textColor = RGB(0x32, 0x32, 0x32);
        [imageView addSubview:self.verLabShow];
        
    }
    
    
    
    
 
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
