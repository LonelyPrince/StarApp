//
//  LinkViewController.m
//  StarAPP
//
//  Created by xyz on 2016/11/7.
//
//

#import "LinkViewController.h"
#import "GGUtil.h"
@interface LinkViewController ()<UIAlertViewDelegate>
{
    NSString * tel ;
    UIImageView * imageView;
    NSString * deviceString;
}
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIScrollView * scrollView;

@end

@implementation LinkViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.tabBarController.tabBar.hidden = YES;
    deviceString = [GGUtil deviceVersion];
    
    [self loadNav];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)loadNav
{
    
    NSString * ContactUsLabel = NSLocalizedString(@"ContactUsLabel", nil);
    self.navigationController.title = ContactUsLabel;
    self.title =  ContactUsLabel;
    
    [self loadScroll];
    
    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是5s和4s的大小");
        
        imageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1570 - 48-48-48-150)];
        imageView.image = [UIImage imageNamed:@"联系我们"];
        
//        imageView.alpha = 0.5;
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"] || [deviceString isEqualToString:@"iPhone8"] || [deviceString isEqualToString:@"iPhoneX"]  || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        imageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1435+40)];
        imageView.image = [UIImage imageNamed:@"联系我们"];
//        imageView.alpha = 0.5;
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"]|| [deviceString isEqualToString:@"iPhone8 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        imageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1584+90)];
        imageView.image = [UIImage imageNamed:@"联系我们"];
//                imageView.alpha = 0.3;
    }
    
    
    [self.scrollView addSubview:imageView];
}
-(void)loadScroll
{
    //加一个scrollview
    self.scrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.scrollView ];
    
    
    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"] ) {
        NSLog(@"此刻是5s和4s 的大小");
        
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 1570-48-48-48-48-170 );
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]  || [deviceString isEqualToString:@"iPhone8"]  || [deviceString isEqualToString:@"iPhoneX"] || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 1435+40-48);
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] || [deviceString isEqualToString:@"iPhone8 Plus"]) {
        NSLog(@"此刻是6 plus的大小");
        
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 1584-48+90+30);
    }
    
    self.scrollView.showsVerticalScrollIndicator=NO;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.delegate=self;
    self.scrollView.bounces=NO;
    
    [self.view addSubview:_scrollView];
    [self loadLinkBtn];
    
    
}

-(void)loadLinkBtn
{
    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是5s和4s的大小");
        
        UIButton * btn0  = [[UIButton alloc]init];
        btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn0.tag = 0;
        btn0.frame = CGRectMake(65, 35+80*1 - 10, 95, 35);
        btn0.backgroundColor = [UIColor clearColor];
        //    [btn0 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn0 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn0];
        
        
        UIButton * btn1  = [[UIButton alloc]init];
        btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.tag = 1;
        btn1.frame = CGRectMake(65, 35+80*1 + 25, 95, 35);
        btn1.backgroundColor = [UIColor clearColor];
        //    [btn1 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn1];
        
        
        UIButton * btn2  = [[UIButton alloc]init];
        btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.tag = 2;
        btn2.frame = CGRectMake(25+btn0.bounds.size.width+30, 35+80*2 - 18, 105, 35);
        btn2.backgroundColor = [UIColor clearColor];
        //    [btn2 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn2];
        
        
        UIButton * btn2_1  = [[UIButton alloc]init];
        btn2_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2_1.tag = 1021;
        btn2_1.frame = CGRectMake(25+btn0.bounds.size.width+30, 35+80*2 + 18, 105, 35);
        btn2_1.backgroundColor = [UIColor clearColor];
        //    [btn3 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn2_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn2_1];
        
        btn2_1.backgroundColor = [UIColor blackColor];
        
        
        UIButton * btn3  = [[UIButton alloc]init];
        btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.tag = 3;
        btn3.frame = CGRectMake(60, 35+80*3 - 18, 105, 35);
        btn3.backgroundColor = [UIColor clearColor];
        //    [btn3 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn3];
        
        
        UIButton * btn3_1  = [[UIButton alloc]init];
        btn3_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3_1.tag = 1031;
        btn3_1.frame = CGRectMake(60, 35+80*3 + 18, 105, 35);
        btn3_1.backgroundColor = [UIColor clearColor];
        //    [btn3 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn3_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn3_1];
       
        btn3_1.backgroundColor = [UIColor redColor];
        
        UIButton * btn4  = [[UIButton alloc]init];
        btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.tag = 4;
        btn4.frame = CGRectMake(35+btn0.bounds.size.width, 35+80*4 -20, 130, 54);
        btn4.backgroundColor = [UIColor clearColor];
        [btn4 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn4];
        
        
        UIButton * btn5  = [[UIButton alloc]init];
        btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn5.tag = 5;
        btn5.frame = CGRectMake(60, 35+80*5 - 25, 110, 40);
        btn5.backgroundColor = [UIColor clearColor];
        [btn5 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn5];
        
        UIButton * btn5_1  = [[UIButton alloc]init];
        btn5_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn5_1.tag = 1051;
        btn5_1.frame = CGRectMake(60, 35+80*5 +5, 110, 35);
        btn5_1.backgroundColor = [UIColor clearColor];
        [btn5_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn5_1];
        
        btn5_1.backgroundColor = [UIColor redColor];
        
        
        UIButton * btn6  = [[UIButton alloc]init];
        btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn6.tag = 6;
        btn6.frame = CGRectMake(150, 35+80*6 - 35, 110, 35);
        btn6.backgroundColor = [UIColor clearColor];
        [btn6 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn6];
        
        UIButton * btn6_1  = [[UIButton alloc]init];
        btn6_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn6_1.tag = 1061;
        btn6_1.frame = CGRectMake(150, 35+80*6+2, 110, 40);
        btn6_1.backgroundColor = [UIColor clearColor];
        [btn6_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn6_1];
        
        btn6_1.backgroundColor = [UIColor redColor];
        
        UIButton * btn7  = [[UIButton alloc]init];
        btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7.tag = 7;
        btn7.frame = CGRectMake(80, 35+80*7-30, 70, 35);
        btn7.backgroundColor = [UIColor clearColor];
        [btn7 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7];
        
        UIButton * btn7_1  = [[UIButton alloc]init];
        btn7_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7_1.tag = 1071;
        btn7_1.frame = CGRectMake(150, 35+80*7-30, 70, 35);
        btn7_1.backgroundColor = [UIColor clearColor];
        [btn7_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7_1];
        
        btn7_1.backgroundColor = [UIColor redColor];
        
        UIButton * btn7_2  = [[UIButton alloc]init];
        btn7_2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7_2.tag = 1072;
        btn7_2.frame = CGRectMake(80, 35+80*7, 70, 35);
        btn7_2.backgroundColor = [UIColor clearColor];
        [btn7_2 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7_2];
        
        btn7_2.backgroundColor = [UIColor blueColor];
        
        UIButton * btn7_3  = [[UIButton alloc]init];
        btn7_3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7_3.tag = 1073;
        btn7_3.frame = CGRectMake(150, 35+80*7, 70, 35);
        btn7_3.backgroundColor = [UIColor clearColor];
        [btn7_3 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7_3];
        
        btn7_3.backgroundColor = [UIColor blackColor];
        
        
        UIButton * btn8  = [[UIButton alloc]init];
        btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn8.tag = 8;
        btn8.frame = CGRectMake(75+btn7.bounds.size.width+10, 35+80*8 - 35, 100, 54);
        btn8.backgroundColor = [UIColor clearColor];
        [btn8 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn8];
        
        
        UIButton * btn9  = [[UIButton alloc]init];
        btn9 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn9.tag = 9;
        btn9.frame = CGRectMake(80, 35+80*9 - 40, 80, 35);
        btn9.backgroundColor = [UIColor clearColor];
        [btn9 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn9];
        
        UIButton * btn9_1  = [[UIButton alloc]init];
        btn9_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn9_1.tag = 1091;
        btn9_1.frame = CGRectMake(80, 35+80*9 - 10, 80, 35);
        btn9_1.backgroundColor = [UIColor clearColor];
        [btn9_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn9_1];
        
        btn9_1.backgroundColor = [UIColor blackColor];
        
        UIButton * btn9_2  = [[UIButton alloc]init];
        btn9_2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn9_2.tag = 1092;
        btn9_2.frame = CGRectMake(160, 35+80*9- 40, 80, 35);
        btn9_2.backgroundColor = [UIColor clearColor];
        [btn9_2 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn9_2];
        
        btn9_2.backgroundColor = [UIColor redColor];
        
        UIButton * btn10  = [[UIButton alloc]init];
        btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn10.tag = 10;
        btn10.frame = CGRectMake(160, 35+80*10 - 48, 85, 35);
        btn10.backgroundColor = [UIColor clearColor];
        [btn10 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn10];
        
        UIButton * btn10_1  = [[UIButton alloc]init];
        btn10_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn10_1.tag = 10101;
        btn10_1.frame = CGRectMake(160, 35+80*10 - 15, 110, 35);
        btn10_1.backgroundColor = [UIColor clearColor];
        [btn10_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn10_1];
        
        btn10_1.backgroundColor = [UIColor blackColor];
        
        UIButton * btn11  = [[UIButton alloc]init];
        btn11 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn11.tag = 11;
        btn11.frame = CGRectMake(65 , 35+80*11 - 40, 110, 54);
        btn11.backgroundColor = [UIColor clearColor];
        [btn11 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn11];
        
        UIButton * btn12  = [[UIButton alloc]init];
        btn12 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn12.tag = 12;
        btn12.frame = CGRectMake(20+btn0.bounds.size.width + 40, 35+80*12 - 50, 100, 35);
        btn12.backgroundColor = [UIColor clearColor];
        [btn12 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn12];
        
        UIButton * btn12_1  = [[UIButton alloc]init];
        btn12_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn12_1.tag = 10121;
        btn12_1.frame = CGRectMake(20+btn0.bounds.size.width + 40, 35+80*12 - 23, 100, 35);
        btn12_1.backgroundColor = [UIColor clearColor];
        [btn12_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn12_1];
        
        btn12_1.backgroundColor = [UIColor blueColor];
        
        UIButton * btn13  = [[UIButton alloc]init];
        btn13 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn13.tag = 13;
        btn13.frame = CGRectMake(60, 35+80*13 - 50, 110, 54);
        btn13.backgroundColor = [UIColor clearColor];
        [btn13 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn13];
        
        UIButton * btn14  = [[UIButton alloc]init];
        btn14 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn14.tag = 14;
        btn14.frame = CGRectMake(btn0.bounds.size.width+40, 35+80*14 - 60, 120, 54);
        btn14.backgroundColor = [UIColor clearColor];
        [btn14 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn14];
        
        UIButton * btn15  = [[UIButton alloc]init];
        btn15 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn15.tag = 15;
        btn15.frame = CGRectMake(60, 35+80*15 - 70, 120, 54);
        btn15.backgroundColor = [UIColor clearColor];
        [btn15 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn15];
        
//        UIButton * btn16  = [[UIButton alloc]init];
//        btn16 = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn16.tag = 16;
//        btn16.frame = CGRectMake(btn0.bounds.size.width, 35+80*16, 120, 54);
//        btn16.backgroundColor = [UIColor clearColor];
//        [btn16 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
//        [_scrollView addSubview:btn16];
//
//        UIButton * btn17  = [[UIButton alloc]init];
//        btn17 = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn17.tag = 17;
//        btn17.frame = CGRectMake(60, 35+80*17, 120, 54);
//        btn17.backgroundColor = [UIColor clearColor];
//        [btn17 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
//        [_scrollView addSubview:btn17];
        
        
        
//        btn0.backgroundColor = [UIColor redColor];
//        btn1.backgroundColor = [UIColor greenColor];
//        btn2.backgroundColor = [UIColor blueColor];
//        btn3.backgroundColor = [UIColor grayColor];
//        btn4.backgroundColor = [UIColor redColor];
//        btn5.backgroundColor = [UIColor greenColor];
//        btn6.backgroundColor = [UIColor blueColor];
//        btn7.backgroundColor = [UIColor grayColor];
//        btn8.backgroundColor = [UIColor redColor];
//        btn9.backgroundColor = [UIColor greenColor];
//        btn10.backgroundColor = [UIColor blueColor];
//        btn11.backgroundColor = [UIColor grayColor];
//        btn12.backgroundColor = [UIColor redColor];
//        btn13.backgroundColor = [UIColor redColor];
//        btn14.backgroundColor = [UIColor redColor];
//        btn15.backgroundColor = [UIColor redColor];
//        btn16.backgroundColor = [UIColor redColor];
//        btn17.backgroundColor = [UIColor redColor];
        
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"] || [deviceString isEqualToString:@"iPhone8"] || [deviceString isEqualToString:@"iPhoneX"] ) {
        NSLog(@"此刻是6s和6的大小");
        
        UIButton * btn0  = [[UIButton alloc]init];
        btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn0.tag = 0;
        btn0.frame = CGRectMake(65 + 25, 35+80*1 - 10+ 20, 95, 35);
        btn0.backgroundColor = [UIColor clearColor];
        //    [btn0 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn0 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn0];
        
        
        UIButton * btn1  = [[UIButton alloc]init];
        btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.tag = 1;
        btn1.frame = CGRectMake(65+ 25, 35+80*1 + 25+ 20, 95, 35);
        btn1.backgroundColor = [UIColor clearColor];
        //    [btn1 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn1];
        
        
        UIButton * btn2  = [[UIButton alloc]init];
        btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.tag = 2;
        btn2.frame = CGRectMake(25+btn0.bounds.size.width+30+40, 35+80*2 - 18+35, 105, 35);
        btn2.backgroundColor = [UIColor clearColor];
        //    [btn2 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn2];
        
        
        UIButton * btn2_1  = [[UIButton alloc]init];
        btn2_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2_1.tag = 1021;
        btn2_1.frame = CGRectMake(25+btn0.bounds.size.width+30+40, 35+80*2 + 18+35, 105, 35);
        btn2_1.backgroundColor = [UIColor clearColor];
        //    [btn3 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn2_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn2_1];
        
        btn2_1.backgroundColor = [UIColor blackColor];
        
        
        UIButton * btn3  = [[UIButton alloc]init];
        btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.tag = 3;
        btn3.frame = CGRectMake(60+ 40, 35+80*3 - 18 + 40, 105, 35);
        btn3.backgroundColor = [UIColor clearColor];
        //    [btn3 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn3];
        
        
        UIButton * btn3_1  = [[UIButton alloc]init];
        btn3_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3_1.tag = 1031;
        btn3_1.frame = CGRectMake(60+ 40, 35+80*3 + 18+ 40, 105, 35);
        btn3_1.backgroundColor = [UIColor clearColor];
        //    [btn3 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn3_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn3_1];
        
        btn3_1.backgroundColor = [UIColor redColor];
        
        UIButton * btn4  = [[UIButton alloc]init];
        btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.tag = 4;
        btn4.frame = CGRectMake(35+btn0.bounds.size.width+ 50, 35+80*4 -20+ 60, 130, 54);
        btn4.backgroundColor = [UIColor clearColor];
        [btn4 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn4];
        
        
        UIButton * btn5  = [[UIButton alloc]init];
        btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn5.tag = 5;
        btn5.frame = CGRectMake(60+ 40, 35+80*5 - 25+ 70, 110, 40);
        btn5.backgroundColor = [UIColor clearColor];
        [btn5 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn5];
        
        UIButton * btn5_1  = [[UIButton alloc]init];
        btn5_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn5_1.tag = 1051;
        btn5_1.frame = CGRectMake(60+ 40, 35+80*5 +5+ 70, 110, 35);
        btn5_1.backgroundColor = [UIColor clearColor];
        [btn5_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn5_1];
        
        btn5_1.backgroundColor = [UIColor redColor];
        
        
        UIButton * btn6  = [[UIButton alloc]init];
        btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn6.tag = 6;
        btn6.frame = CGRectMake(150+50, 35+80*6 - 35+85, 110, 35);
        btn6.backgroundColor = [UIColor clearColor];
        [btn6 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn6];
        
        UIButton * btn6_1  = [[UIButton alloc]init];
        btn6_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn6_1.tag = 1061;
        btn6_1.frame = CGRectMake(150+50, 35+80*6+2+80, 110, 40);
        btn6_1.backgroundColor = [UIColor clearColor];
        [btn6_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn6_1];
        
        btn6_1.backgroundColor = [UIColor redColor];
        
        UIButton * btn7  = [[UIButton alloc]init];
        btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7.tag = 7;
        btn7.frame = CGRectMake(80+22, 35+80*7-30+93, 70, 35);
        btn7.backgroundColor = [UIColor clearColor];
        [btn7 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7];
        
        UIButton * btn7_1  = [[UIButton alloc]init];
        btn7_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7_1.tag = 1071;
        btn7_1.frame = CGRectMake(150+22, 35+80*7-30+93, 80, 35);
        btn7_1.backgroundColor = [UIColor clearColor];
        [btn7_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7_1];
        
        btn7_1.backgroundColor = [UIColor redColor];
        
        UIButton * btn7_2  = [[UIButton alloc]init];
        btn7_2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7_2.tag = 1072;
        btn7_2.frame = CGRectMake(80+22, 35+80*7+93, 70, 35);
        btn7_2.backgroundColor = [UIColor clearColor];
        [btn7_2 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7_2];
        
        btn7_2.backgroundColor = [UIColor blueColor];
        
        UIButton * btn7_3  = [[UIButton alloc]init];
        btn7_3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7_3.tag = 1073;
        btn7_3.frame = CGRectMake(150+22, 35+80*7+93, 80, 35);
        btn7_3.backgroundColor = [UIColor clearColor];
        [btn7_3 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7_3];
        
        btn7_3.backgroundColor = [UIColor blackColor];
        
        
        UIButton * btn8  = [[UIButton alloc]init];
        btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn8.tag = 8;
        btn8.frame = CGRectMake(75+btn7.bounds.size.width+10+50, 35+80*9 - 15, 100, 54);
        btn8.backgroundColor = [UIColor clearColor];
        [btn8 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn8];
        
        
        UIButton * btn9  = [[UIButton alloc]init];
        btn9 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn9.tag = 9;
        btn9.frame = CGRectMake(80+23, 35+80*11 - 40-60+15, 80, 35);
        btn9.backgroundColor = [UIColor clearColor];
        [btn9 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn9];
        
        UIButton * btn9_1  = [[UIButton alloc]init];
        btn9_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn9_1.tag = 1091;
        btn9_1.frame = CGRectMake(80+23, 35+80*11 - 10-60+15, 80, 35);
        btn9_1.backgroundColor = [UIColor clearColor];
        [btn9_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn9_1];
        
        btn9_1.backgroundColor = [UIColor blackColor];
        
        UIButton * btn9_2  = [[UIButton alloc]init];
        btn9_2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn9_2.tag = 1092;
        btn9_2.frame = CGRectMake(160+23, 35+80*11- 40 -60+15, 80, 35);
        btn9_2.backgroundColor = [UIColor clearColor];
        [btn9_2 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn9_2];
        
        btn9_2.backgroundColor = [UIColor redColor];
        
        UIButton * btn10  = [[UIButton alloc]init];
        btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn10.tag = 10;
        btn10.frame = CGRectMake(160+30, 35+80*12 - 48- 30, 85, 35);
        btn10.backgroundColor = [UIColor clearColor];
        [btn10 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn10];
        
        UIButton * btn10_1  = [[UIButton alloc]init];
        btn10_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn10_1.tag = 10101;
        btn10_1.frame = CGRectMake(160+30, 35+80*12 - 15- 30, 110, 35);
        btn10_1.backgroundColor = [UIColor clearColor];
        [btn10_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn10_1];
        
        btn10_1.backgroundColor = [UIColor blackColor];
        
        UIButton * btn11  = [[UIButton alloc]init];
        btn11 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn11.tag = 11;
        btn11.frame = CGRectMake(65+17 , 35+80*13 - 63, 110, 54);
        btn11.backgroundColor = [UIColor clearColor];
        [btn11 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn11];
        
        UIButton * btn12  = [[UIButton alloc]init];
        btn12 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn12.tag = 12;
        btn12.frame = CGRectMake(60+btn0.bounds.size.width + 40, 35+80*14 - 60, 100, 35);
        btn12.backgroundColor = [UIColor clearColor];
        [btn12 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn12];
        
        UIButton * btn12_1  = [[UIButton alloc]init];
        btn12_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn12_1.tag = 10121;
        btn12_1.frame = CGRectMake(60+btn0.bounds.size.width + 40, 35+80*14 - 33, 100, 35);
        btn12_1.backgroundColor = [UIColor clearColor];
        [btn12_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn12_1];
        
        btn12_1.backgroundColor = [UIColor blueColor];
        
        UIButton * btn13  = [[UIButton alloc]init];
        btn13 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn13.tag = 13;
        btn13.frame = CGRectMake(80, 35+80*15 - 50, 110, 54);
        btn13.backgroundColor = [UIColor clearColor];
        [btn13 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn13];
        
        UIButton * btn14  = [[UIButton alloc]init];
        btn14 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn14.tag = 14;
        btn14.frame = CGRectMake(btn0.bounds.size.width+80, 35+80*16 - 40, 120, 54);
        btn14.backgroundColor = [UIColor clearColor];
        [btn14 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn14];
        
        UIButton * btn15  = [[UIButton alloc]init];
        btn15 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn15.tag = 15;
        btn15.frame = CGRectMake(80, 35+80*17 - 40, 120, 54);
        btn15.backgroundColor = [UIColor clearColor];
        [btn15 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn15];
        
        //        UIButton * btn16  = [[UIButton alloc]init];
        //        btn16 = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btn16.tag = 16;
        //        btn16.frame = CGRectMake(btn0.bounds.size.width, 35+80*16, 120, 54);
        //        btn16.backgroundColor = [UIColor clearColor];
        //        [btn16 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        //        [_scrollView addSubview:btn16];
        //
        //        UIButton * btn17  = [[UIButton alloc]init];
        //        btn17 = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btn17.tag = 17;
        //        btn17.frame = CGRectMake(60, 35+80*17, 120, 54);
        //        btn17.backgroundColor = [UIColor clearColor];
        //        [btn17 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        //        [_scrollView addSubview:btn17];
        
        
        
//        btn0.backgroundColor = [UIColor redColor];
//        btn1.backgroundColor = [UIColor greenColor];
//        btn2.backgroundColor = [UIColor blueColor];
//        btn3.backgroundColor = [UIColor grayColor];
//        btn4.backgroundColor = [UIColor redColor];
//        btn5.backgroundColor = [UIColor greenColor];
//        btn6.backgroundColor = [UIColor blueColor];
//        btn7.backgroundColor = [UIColor grayColor];
//        btn8.backgroundColor = [UIColor redColor];
//        btn9.backgroundColor = [UIColor greenColor];
//        btn10.backgroundColor = [UIColor blueColor];
//        btn11.backgroundColor = [UIColor grayColor];
//        btn12.backgroundColor = [UIColor redColor];
//        btn13.backgroundColor = [UIColor redColor];
//        btn14.backgroundColor = [UIColor redColor];
//        btn15.backgroundColor = [UIColor redColor];
        //        btn16.backgroundColor = [UIColor redColor];
        //        btn17.backgroundColor = [UIColor redColor];
        
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] || [deviceString isEqualToString:@"iPhone8 Plus"]  || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6P的大小");
        
        UIButton * btn0  = [[UIButton alloc]init];
        btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn0.tag = 0;
        btn0.frame = CGRectMake(65+20, 35+80*1 - 10+40, 95+30, 35);
        btn0.backgroundColor = [UIColor clearColor];
        //    [btn0 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn0 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn0];
        
        
        UIButton * btn1  = [[UIButton alloc]init];
        btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.tag = 1;
        btn1.frame = CGRectMake(65+20, 35+80*1 + 25+40, 95+30, 35);
        btn1.backgroundColor = [UIColor clearColor];
        //    [btn1 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn1];
        
        
        UIButton * btn2  = [[UIButton alloc]init];
        btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.tag = 2;
        btn2.frame = CGRectMake(25+btn0.bounds.size.width+30+40, 35+80*2 - 18+70, 105+30, 35);
        btn2.backgroundColor = [UIColor clearColor];
        //    [btn2 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn2];
        
        
        UIButton * btn2_1  = [[UIButton alloc]init];
        btn2_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2_1.tag = 1021;
        btn2_1.frame = CGRectMake(25+btn0.bounds.size.width+30+40, 35+80*2 + 18+70, 105+30, 35);
        btn2_1.backgroundColor = [UIColor clearColor];
        //    [btn3 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn2_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn2_1];
        
        btn2_1.backgroundColor = [UIColor blackColor];
        
        
        UIButton * btn3  = [[UIButton alloc]init];
        btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.tag = 3;
        btn3.frame = CGRectMake(90, 35+80*3 - 18+90, 135, 35);
        btn3.backgroundColor = [UIColor clearColor];
        //    [btn3 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn3];
        
        
        UIButton * btn3_1  = [[UIButton alloc]init];
        btn3_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3_1.tag = 1031;
        btn3_1.frame = CGRectMake(90, 35+80*3 + 18+90, 135, 35);
        btn3_1.backgroundColor = [UIColor clearColor];
        //    [btn3 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn3_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn3_1];
        
        btn3_1.backgroundColor = [UIColor redColor];
        
        UIButton * btn4  = [[UIButton alloc]init];
        btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.tag = 4;
        btn4.frame = CGRectMake(75+btn0.bounds.size.width, 75+80*5 -20, 130, 54);
        btn4.backgroundColor = [UIColor clearColor];
        [btn4 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn4];
        
        
        UIButton * btn5  = [[UIButton alloc]init];
        btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn5.tag = 5;
        btn5.frame = CGRectMake(60+40, 35+80*7 - 25-20, 130, 40);
        btn5.backgroundColor = [UIColor clearColor];
        [btn5 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn5];
        
        UIButton * btn5_1  = [[UIButton alloc]init];
        btn5_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn5_1.tag = 1051;
        btn5_1.frame = CGRectMake(60+40, 35+80*7 +5 -20, 130, 35);
        btn5_1.backgroundColor = [UIColor clearColor];
        [btn5_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn5_1];
        
        btn5_1.backgroundColor = [UIColor redColor];
        
        
        UIButton * btn6  = [[UIButton alloc]init];
        btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn6.tag = 6;
        btn6.frame = CGRectMake(200, 35+80*8 - 35+5, 170, 35);
        btn6.backgroundColor = [UIColor clearColor];
        [btn6 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn6];
        
        UIButton * btn6_1  = [[UIButton alloc]init];
        btn6_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn6_1.tag = 1061;
        btn6_1.frame = CGRectMake(200, 35+80*8+7, 170, 40);
        btn6_1.backgroundColor = [UIColor clearColor];
        [btn6_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn6_1];
        
        btn6_1.backgroundColor = [UIColor redColor];
        
        UIButton * btn7  = [[UIButton alloc]init];
        btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7.tag = 7;
        btn7.frame = CGRectMake(80+40, 35+80*9-30+20, 85, 35);
        btn7.backgroundColor = [UIColor clearColor];
        [btn7 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7];
        
        UIButton * btn7_1  = [[UIButton alloc]init];
        btn7_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7_1.tag = 1071;
        btn7_1.frame = CGRectMake(160+40, 35+80*9-30+20, 85, 35);
        btn7_1.backgroundColor = [UIColor clearColor];
        [btn7_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7_1];
        
        btn7_1.backgroundColor = [UIColor redColor];
        
        UIButton * btn7_2  = [[UIButton alloc]init];
        btn7_2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7_2.tag = 1072;
        btn7_2.frame = CGRectMake(80+40, 35+80*9+20, 85, 35);
        btn7_2.backgroundColor = [UIColor clearColor];
        [btn7_2 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7_2];
        
        btn7_2.backgroundColor = [UIColor blueColor];
        
        UIButton * btn7_3  = [[UIButton alloc]init];
        btn7_3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7_3.tag = 1073;
        btn7_3.frame = CGRectMake(160+40, 35+80*9+20, 85, 35);
        btn7_3.backgroundColor = [UIColor clearColor];
        [btn7_3 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7_3];
        
        btn7_3.backgroundColor = [UIColor blackColor];
        
        
        UIButton * btn8  = [[UIButton alloc]init];
        btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn8.tag = 8;
        btn8.frame = CGRectMake(75+btn7.bounds.size.width+50, 45+80*10, 120, 54);
        btn8.backgroundColor = [UIColor clearColor];
        [btn8 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn8];
        
        
        UIButton * btn9  = [[UIButton alloc]init];
        btn9 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn9.tag = 9;
        btn9.frame = CGRectMake(80+30, 35+80*12 - 40-5, 90, 35);
        btn9.backgroundColor = [UIColor clearColor];
        [btn9 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn9];
        
        UIButton * btn9_1  = [[UIButton alloc]init];
        btn9_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn9_1.tag = 1091;
        btn9_1.frame = CGRectMake(80+30, 35+80*12 - 10-5, 90, 35);
        btn9_1.backgroundColor = [UIColor clearColor];
        [btn9_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn9_1];
        
        btn9_1.backgroundColor = [UIColor blackColor];
        
        UIButton * btn9_2  = [[UIButton alloc]init];
        btn9_2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn9_2.tag = 1092;
        btn9_2.frame = CGRectMake(160+45, 35+80*12- 40-5, 90, 35);
        btn9_2.backgroundColor = [UIColor clearColor];
        [btn9_2 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn9_2];
        
        btn9_2.backgroundColor = [UIColor redColor];
        
        UIButton * btn10  = [[UIButton alloc]init];
        btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn10.tag = 10;
        btn10.frame = CGRectMake(160+30, 35+80*13 - 28, 95, 35);
        btn10.backgroundColor = [UIColor clearColor];
        [btn10 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn10];
        
        UIButton * btn10_1  = [[UIButton alloc]init];
        btn10_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn10_1.tag = 10101;
        btn10_1.frame = CGRectMake(160+30, 35+80*13 +5, 140, 35);
        btn10_1.backgroundColor = [UIColor clearColor];
        [btn10_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn10_1];
        
        btn10_1.backgroundColor = [UIColor blackColor];
        
        UIButton * btn11  = [[UIButton alloc]init];
        btn11 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn11.tag = 11;
        btn11.frame = CGRectMake(85 , 35+80*14 - 5, 130, 54);
        btn11.backgroundColor = [UIColor clearColor];
        [btn11 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn11];
        
        UIButton * btn12  = [[UIButton alloc]init];
        btn12 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn12.tag = 12;
        btn12.frame = CGRectMake(50+btn0.bounds.size.width + 40, 45+80*15, 110, 35);
        btn12.backgroundColor = [UIColor clearColor];
        [btn12 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn12];
        
        UIButton * btn12_1  = [[UIButton alloc]init];
        btn12_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn12_1.tag = 10121;
        btn12_1.frame = CGRectMake(50+btn0.bounds.size.width + 40, 100+80*15 - 23, 110, 35);
        btn12_1.backgroundColor = [UIColor clearColor];
        [btn12_1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn12_1];
        
        btn12_1.backgroundColor = [UIColor blueColor];
        
        UIButton * btn13  = [[UIButton alloc]init];
        btn13 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn13.tag = 13;
        btn13.frame = CGRectMake(80, 35+80*17 - 50, 130, 54);
        btn13.backgroundColor = [UIColor clearColor];
        [btn13 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn13];
        
        UIButton * btn14  = [[UIButton alloc]init];
        btn14 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn14.tag = 14;
        btn14.frame = CGRectMake(btn0.bounds.size.width+80, 35+80*18 - 30, 120, 54);
        btn14.backgroundColor = [UIColor clearColor];
        [btn14 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn14];
        
        UIButton * btn15  = [[UIButton alloc]init];
        btn15 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn15.tag = 15;
        btn15.frame = CGRectMake(80, 35+80*20 - 90, 140, 54);
        btn15.backgroundColor = [UIColor clearColor];
        [btn15 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn15];
        
        //        UIButton * btn16  = [[UIButton alloc]init];
        //        btn16 = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btn16.tag = 16;
        //        btn16.frame = CGRectMake(btn0.bounds.size.width, 35+80*16, 120, 54);
        //        btn16.backgroundColor = [UIColor clearColor];
        //        [btn16 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        //        [_scrollView addSubview:btn16];
        //
        //        UIButton * btn17  = [[UIButton alloc]init];
        //        btn17 = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btn17.tag = 17;
        //        btn17.frame = CGRectMake(60, 35+80*17, 120, 54);
        //        btn17.backgroundColor = [UIColor clearColor];
        //        [btn17 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        //        [_scrollView addSubview:btn17];
        
        
        
//        btn0.backgroundColor = [UIColor redColor];
//        btn1.backgroundColor = [UIColor greenColor];
//        btn2.backgroundColor = [UIColor blueColor];
//        btn3.backgroundColor = [UIColor grayColor];
//        btn4.backgroundColor = [UIColor redColor];
//        btn5.backgroundColor = [UIColor greenColor];
//        btn6.backgroundColor = [UIColor blueColor];
//        btn7.backgroundColor = [UIColor grayColor];
//        btn8.backgroundColor = [UIColor redColor];
//        btn9.backgroundColor = [UIColor greenColor];
//        btn10.backgroundColor = [UIColor blueColor];
//        btn11.backgroundColor = [UIColor grayColor];
//        btn12.backgroundColor = [UIColor redColor];
//        btn13.backgroundColor = [UIColor redColor];
//        btn14.backgroundColor = [UIColor redColor];
//        btn15.backgroundColor = [UIColor redColor];
        //        btn16.backgroundColor = [UIColor redColor];
        //        btn17.backgroundColor = [UIColor redColor];
        
        
    }
    
    
    
}

-(void)linkBtnClick : (id)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSLog(@"tag %d ",button.tag);
    [self setAlertView:button.tag];
    
}
-(void)setAlertView :(NSInteger)linkBtnTag
{
    
    switch (linkBtnTag) {
        case 0:
            tel =   @"094618888";
            break;
        case 1:
            tel =   @"014618888";
            break;
        case 2:
            tel =   @"0764700800";
            break;
        case 1021:
            tel =   @"0677700800";
            break;
        case 3:
            tel =   @"0719077077";
            break;
        case 1031:
            tel =   @"0719077000";
            break;
        case 4:
            tel =   @"0317117700";
            break;
        case 5:
            tel =   @"5033";
            break;
        case 1051:
            tel =   @"0788156600";
            break;
        case 6:
            tel =   @"0996010000";
            break;
        case 1061:
            tel =   @"0856710000";
            break;
        case 7:
            tel =   @"22275929";
            break;
        case 1071:
            tel =   @"22275931";
            break;
        case 1072:
            tel =   @"22275930";
            break;
        case 1073:
            tel =   @"22279661";
            break;
        case 8:
            tel =   @"822171400";
            break;
        case 9:
            tel =   @"655700700";
            break;
        case 1091:
            tel =   @"664707070";
            break;
        case 1092:
            tel =   @"624979760";
            break;
        case 10:
            tel =   @"2000";
            break;
        case 10101:
            tel =   @"0967000220";
            break;
        case 11:
            tel =   @"0242437888";
            break;
        case 12:
            tel =   @"86060";
            break;
        case 10121:
            tel =   @"22026060";
            break;
        case 13:
            tel =   @"066474040";
            break;
        case 14:
            tel =   @"0115829988";
            break;
        case 15:
            tel =   @"0202220275";
            break;
            
            
        default:
            break;
    }
    
    NSString * CancelLabel = NSLocalizedString(@"CancelLabel", nil);
    NSString * CallLabel = NSLocalizedString(@"CallLabel", nil);
    UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",tel] delegate:self cancelButtonTitle:CancelLabel otherButtonTitles:CallLabel, nil];
    
    [linkAlert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL * telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]];
        [[UIApplication sharedApplication]openURL:telUrl];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


