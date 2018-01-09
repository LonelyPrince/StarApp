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
@property (nonatomic, strong) UILabel * copyrightLabShow;
@end


@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    NSString * AboutLabel = NSLocalizedString(@"AboutLabel", nil);
    self.title = AboutLabel;
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
        NSLog(@"此刻是4s的大小");
        
        //        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(89, 150, 148, 103)];
        
        //    imageView.image = [UIImage imageNamed:@"关于about"];
        imageView.image = [UIImage imageNamed:@"4关于"];
        [self.view addSubview:imageView];
        
        //新加版本信息
        self.verLabShow = [[UILabel alloc]init];
        _verLabShow.text = @"V1.0.3";
        CGSize sizeOfVerLabShow = [self sizeWithText:_verLabShow.text font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.verLabShow.frame = CGRectMake((SCREEN_WIDTH - sizeOfVerLabShow.width)/2, 276, sizeOfVerLabShow.width, sizeOfVerLabShow.height);
        self.verLabShow.font = FONT(14);
        self.verLabShow.textColor = RGB(0x32, 0x32, 0x32);
        [self.view addSubview:self.verLabShow];
        
        //新加版权信息
        self.copyrightLabShow = [[UILabel alloc]init];
        _copyrightLabShow.text = @"Copyright © 2017 StarTimes All Rights Reserved";
        CGSize sizeOfVerLabShow1 = [self sizeWithText:_copyrightLabShow.text font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.copyrightLabShow.frame = CGRectMake((SCREEN_WIDTH - sizeOfVerLabShow1.width)/2, SCREEN_HEIGHT - 35, sizeOfVerLabShow1.width, sizeOfVerLabShow1.height);
        self.copyrightLabShow.font = FONT(13);
        self.copyrightLabShow.textColor = RGB(0x6c, 0x6c, 0x6c);
        [self.view addSubview:self.copyrightLabShow];
        
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是5的大小");
        
        //        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(89, 170, 148, 103)];
        
        //    imageView.image = [UIImage imageNamed:@"关于about"];
        imageView.image = [UIImage imageNamed:@"关于"];
        [self.view addSubview:imageView];
        
        //新加版本信息
        self.verLabShow = [[UILabel alloc]init];
        _verLabShow.text = @"V1.0.3";
        CGSize sizeOfVerLabShow = [self sizeWithText:_verLabShow.text font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.verLabShow.frame = CGRectMake((SCREEN_WIDTH - sizeOfVerLabShow.width)/2, 300, sizeOfVerLabShow.width, sizeOfVerLabShow.height);
        self.verLabShow.font = FONT(15);
        self.verLabShow.textColor = RGB(0x32, 0x32, 0x32);
        [self.view addSubview:self.verLabShow];
        
        
        //新加版权信息
        self.copyrightLabShow = [[UILabel alloc]init];
        _copyrightLabShow.text = @"Copyright © 2017 StarTimes All Rights Reserved";
        CGSize sizeOfVerLabShow1 = [self sizeWithText:_copyrightLabShow.text font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.copyrightLabShow.frame = CGRectMake((SCREEN_WIDTH - sizeOfVerLabShow1.width)/2, SCREEN_HEIGHT - 32, sizeOfVerLabShow1.width, sizeOfVerLabShow1.height);
        self.copyrightLabShow.font = FONT(13);
        self.copyrightLabShow.textColor = RGB(0x6c, 0x6c, 0x6c);
        [self.view addSubview:self.copyrightLabShow];
    }
    else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"] || [deviceString isEqualToString:@"iPhone8"] || [deviceString isEqualToString:@"iPhoneX"] ) {
        NSLog(@"此刻是6的大小");
        
        //        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(117, 210, 148, 103)];
        
        //    imageView.image = [UIImage imageNamed:@"关于about"];
        imageView.image = [UIImage imageNamed:@"关于"];
        [self.view addSubview:imageView];
        
        
        //新加版本信息
        self.verLabShow = [[UILabel alloc]init];
        _verLabShow.text = @"V1.0.3";
        CGSize sizeOfVerLabShow = [self sizeWithText:_verLabShow.text font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.verLabShow.frame = CGRectMake((SCREEN_WIDTH - sizeOfVerLabShow.width)/2, 356, sizeOfVerLabShow.width, sizeOfVerLabShow.height);
        self.verLabShow.font = FONT(16);
        self.verLabShow.textColor = RGB(0x32, 0x32, 0x32);
        //        [imageView addSubview:self.verLabShow];
        [self.view addSubview:self.verLabShow];
        
        //新加版权信息
        self.copyrightLabShow = [[UILabel alloc]init];
        _copyrightLabShow.text = @"Copyright © 2017 StarTimes All Rights Reserved";
        CGSize sizeOfVerLabShow1 = [self sizeWithText:_copyrightLabShow.text font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.copyrightLabShow.frame = CGRectMake((SCREEN_WIDTH - sizeOfVerLabShow1.width)/2, SCREEN_HEIGHT - 35, sizeOfVerLabShow1.width, sizeOfVerLabShow1.height);
        self.copyrightLabShow.font = FONT(13);
        self.copyrightLabShow.textColor = RGB(0x6c, 0x6c, 0x6c);
        [self.view addSubview:self.copyrightLabShow];
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"]|| [deviceString isEqualToString:@"iPhone8 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        
        //        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -7, SCREEN_WIDTH, SCREEN_HEIGHT+7)];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(135, 238, 148, 103)];
        
        //    imageView.image = [UIImage imageNamed:@"关于about"];
        imageView.image = [UIImage imageNamed:@"关于"];
        [self.view addSubview:imageView];
        
        //新加版本信息
        self.verLabShow = [[UILabel alloc]init];
        _verLabShow.text = @"V1.0.3";
        CGSize sizeOfVerLabShow = [self sizeWithText:_verLabShow.text font:[UIFont systemFontOfSize:18] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.verLabShow.frame = CGRectMake((SCREEN_WIDTH - sizeOfVerLabShow.width)/2, 390, sizeOfVerLabShow.width, sizeOfVerLabShow.height);
        self.verLabShow.font = FONT(18);
        self.verLabShow.textColor = RGB(0x32, 0x32, 0x32);
        [self.view addSubview:self.verLabShow];
        
        //新加版权信息
        self.copyrightLabShow = [[UILabel alloc]init];
        _copyrightLabShow.text = @"Copyright © 2017 StarTimes All Rights Reserved";
        CGSize sizeOfVerLabShow1 = [self sizeWithText:_copyrightLabShow.text font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.copyrightLabShow.frame = CGRectMake((SCREEN_WIDTH - sizeOfVerLabShow1.width)/2, SCREEN_HEIGHT - 35, sizeOfVerLabShow1.width, sizeOfVerLabShow1.height);
        self.copyrightLabShow.font = FONT(13);
        self.copyrightLabShow.textColor = RGB(0x6c, 0x6c, 0x6c);
        [self.view addSubview:self.copyrightLabShow];
        
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

