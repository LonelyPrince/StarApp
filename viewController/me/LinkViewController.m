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
    self.navigationController.title = @"Help Center";
    self.title =  @"Help Center";
    
    [self loadScroll];
    
     if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是5s和4s的大小");
        
        imageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1224)];
        imageView.image = [UIImage imageNamed:@"联系我们"];
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        imageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1435)];
        imageView.image = [UIImage imageNamed:@"联系我们"];
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        imageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1584)];
        imageView.image = [UIImage imageNamed:@"联系我们"];
//        imageView.alpha = 0.3;
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
        
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 1224-48);
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]    || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 1435-48);
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 1584-48);
    }
    
//    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 1435-48);
    //    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 614+105 - 216 +_allHistoryBtnHeight);
    //    scroll.pagingEnabled=YES;
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
        btn0.frame = CGRectMake(55, 35+80*0, 90, 56);
        btn0.backgroundColor = [UIColor clearColor];
        //    [btn0 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn0 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn0];
        
        
        UIButton * btn1  = [[UIButton alloc]init];
        btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.tag = 1;
        btn1.frame = CGRectMake(60+btn0.bounds.size.width, 35+80*0, 85, 54);
        btn1.backgroundColor = [UIColor clearColor];
        //    [btn1 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn1];
        
        
        UIButton * btn2  = [[UIButton alloc]init];
        btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.tag = 2;
        btn2.frame = CGRectMake(25+btn0.bounds.size.width, 35+80*1, 150, 54);
        btn2.backgroundColor = [UIColor clearColor];
        //    [btn2 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn2];
        
        
        UIButton * btn3  = [[UIButton alloc]init];
        btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.tag = 3;
        btn3.frame = CGRectMake(55, 35+80*2, 180, 54);
        btn3.backgroundColor = [UIColor clearColor];
        //    [btn3 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn3];
        
        
        UIButton * btn4  = [[UIButton alloc]init];
        btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.tag = 4;
        btn4.frame = CGRectMake(35+btn0.bounds.size.width, 35+80*3, 130, 54);
        btn4.backgroundColor = [UIColor clearColor];
        [btn4 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn4];
        
        
        UIButton * btn5  = [[UIButton alloc]init];
        btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn5.tag = 5;
        btn5.frame = CGRectMake(60, 35+80*4, 170, 54);
        btn5.backgroundColor = [UIColor clearColor];
        [btn5 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn5];
        
        
        UIButton * btn6  = [[UIButton alloc]init];
        btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn6.tag = 6;
        btn6.frame = CGRectMake(100, 35+80*5, 160, 54);
        btn6.backgroundColor = [UIColor clearColor];
        [btn6 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn6];
        
        
        UIButton * btn7  = [[UIButton alloc]init];
        btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7.tag = 7;
        btn7.frame = CGRectMake(60, 35+80*6, 80, 54);
        btn7.backgroundColor = [UIColor clearColor];
        [btn7 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7];
        
        
        
        UIButton * btn8  = [[UIButton alloc]init];
        btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn8.tag = 8;
        btn8.frame = CGRectMake(62+btn7.bounds.size.width, 35+80*6, 85, 54);
        btn8.backgroundColor = [UIColor clearColor];
        [btn8 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn8];
        
        
        UIButton * btn9  = [[UIButton alloc]init];
        btn9 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn9.tag = 9;
        btn9.frame = CGRectMake(110, 35+80*7, 160, 54);
        btn9.backgroundColor = [UIColor clearColor];
        [btn9 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn9];
        
        
        UIButton * btn10  = [[UIButton alloc]init];
        btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn10.tag = 10;
        btn10.frame = CGRectMake(55, 35+80*8, 85, 54);
        btn10.backgroundColor = [UIColor clearColor];
        [btn10 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn10];
        
        UIButton * btn11  = [[UIButton alloc]init];
        btn11 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn11.tag = 11;
        btn11.frame = CGRectMake(65 + btn10.bounds.size.width, 35+80*8, 85, 54);
        btn11.backgroundColor = [UIColor clearColor];
        [btn11 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn11];
        
        UIButton * btn12  = [[UIButton alloc]init];
        btn12 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn12.tag = 12;
        btn12.frame = CGRectMake(20+btn0.bounds.size.width, 35+80*9, 140, 54);
        btn12.backgroundColor = [UIColor clearColor];
        [btn12 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn12];
        
        UIButton * btn13  = [[UIButton alloc]init];
        btn13 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn13.tag = 13;
        btn13.frame = CGRectMake(60, 35+80*10, 180, 54);
        btn13.backgroundColor = [UIColor clearColor];
        [btn13 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn13];
        
        UIButton * btn14  = [[UIButton alloc]init];
        btn14 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn14.tag = 14;
        btn14.frame = CGRectMake(btn0.bounds.size.width+20, 35+80*11, 160, 54);
        btn14.backgroundColor = [UIColor clearColor];
        [btn14 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn14];
        
        UIButton * btn15  = [[UIButton alloc]init];
        btn15 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn15.tag = 15;
        btn15.frame = CGRectMake(60, 35+80*12, 180, 54);
        btn15.backgroundColor = [UIColor clearColor];
        [btn15 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn15];
        
        UIButton * btn16  = [[UIButton alloc]init];
        btn16 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn16.tag = 16;
        btn16.frame = CGRectMake(btn0.bounds.size.width, 35+80*13, 180, 54);
        btn16.backgroundColor = [UIColor clearColor];
        [btn16 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn16];
        
        UIButton * btn17  = [[UIButton alloc]init];
        btn17 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn17.tag = 17;
        btn17.frame = CGRectMake(60, 35+80*14, 180, 54);
        btn17.backgroundColor = [UIColor clearColor];
        [btn17 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn17];
        
      
        
     
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]  ) {
        NSLog(@"此刻是6的大小");
        
        UIButton * btn0  = [[UIButton alloc]init];
        btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn0.tag = 0;
        btn0.frame = CGRectMake(50, 40+94*0, 115, 66);
        btn0.backgroundColor = [UIColor clearColor];
        //    [btn0 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn0 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn0];
        
        
        UIButton * btn1  = [[UIButton alloc]init];
        btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.tag = 1;
        btn1.frame = CGRectMake(60+btn0.bounds.size.width, 40+94*0, 110, 66);
        btn1.backgroundColor = [UIColor clearColor];
        //    [btn1 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn1];
        
        
        UIButton * btn2  = [[UIButton alloc]init];
        btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.tag = 2;
        btn2.frame = CGRectMake(15+btn0.bounds.size.width, 40+94*1, 180, 66);
        btn2.backgroundColor = [UIColor clearColor];
        //    [btn2 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn2];
        
        
        UIButton * btn3  = [[UIButton alloc]init];
        btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.tag = 3;
        btn3.frame = CGRectMake(55, 40+94*2, 220, 66);
        btn3.backgroundColor = [UIColor clearColor];
        //    [btn3 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn3];
        
        
        UIButton * btn4  = [[UIButton alloc]init];
        btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.tag = 4;
        btn4.frame = CGRectMake(15+btn0.bounds.size.width, 40+94*3, 180, 66);
        btn4.backgroundColor = [UIColor clearColor];
        [btn4 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn4];
        
        
        UIButton * btn5  = [[UIButton alloc]init];
        btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn5.tag = 5;
        btn5.frame = CGRectMake(60, 40+94*4, 220, 66);
        btn5.backgroundColor = [UIColor clearColor];
        [btn5 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn5];
        
        
        UIButton * btn6  = [[UIButton alloc]init];
        btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn6.tag = 6;
        btn6.frame = CGRectMake(115, 40+94*5, 210, 66);
        btn6.backgroundColor = [UIColor clearColor];
        [btn6 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn6];
        
        
        UIButton * btn7  = [[UIButton alloc]init];
        btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7.tag = 7;
        btn7.frame = CGRectMake(60, 40+94*6, 100, 66);
        btn7.backgroundColor = [UIColor clearColor];
        [btn7 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7];
        
        
        
        UIButton * btn8  = [[UIButton alloc]init];
        btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn8.tag = 8;
        btn8.frame = CGRectMake(70+btn7.bounds.size.width, 40+94*6, 100, 66);
        btn8.backgroundColor = [UIColor clearColor];
        [btn8 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn8];
        
        
        UIButton * btn9  = [[UIButton alloc]init];
        btn9 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn9.tag = 9;
        btn9.frame = CGRectMake(110, 40+94*7, 200, 66);
        btn9.backgroundColor = [UIColor clearColor];
        [btn9 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn9];
        
        
        UIButton * btn10  = [[UIButton alloc]init];
        btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn10.tag = 10;
        btn10.frame = CGRectMake(55, 40+94*8, 110, 66);
        btn10.backgroundColor = [UIColor clearColor];
        [btn10 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn10];
        
        UIButton * btn11  = [[UIButton alloc]init];
        btn11 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn11.tag = 11;
        btn11.frame = CGRectMake(65 + btn10.bounds.size.width, 40+94*8, 110, 66);
        btn11.backgroundColor = [UIColor clearColor];
        [btn11 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn11];
        
        UIButton * btn12  = [[UIButton alloc]init];
        btn12 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn12.tag = 12;
        btn12.frame = CGRectMake(15+btn0.bounds.size.width, 40+94*9, 180, 66);
        btn12.backgroundColor = [UIColor clearColor];
        [btn12 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn12];
        
        UIButton * btn13  = [[UIButton alloc]init];
        btn13 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn13.tag = 13;
        btn13.frame = CGRectMake(60, 40+94*10, 220, 66);
        btn13.backgroundColor = [UIColor clearColor];
        [btn13 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn13];
        
        UIButton * btn14  = [[UIButton alloc]init];
        btn14 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn14.tag = 14;
        btn14.frame = CGRectMake(btn0.bounds.size.width, 40+94*11, 185, 66);
        btn14.backgroundColor = [UIColor clearColor];
        [btn14 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn14];
        
        UIButton * btn15  = [[UIButton alloc]init];
        btn15 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn15.tag = 15;
        btn15.frame = CGRectMake(60, 40+94*12, 220, 66);
        btn15.backgroundColor = [UIColor clearColor];
        [btn15 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn15];
        
        UIButton * btn16  = [[UIButton alloc]init];
        btn16 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn16.tag = 16;
        btn16.frame = CGRectMake(btn0.bounds.size.width, 40+94*13, 185, 66);
        btn16.backgroundColor = [UIColor clearColor];
        [btn16 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn16];
        
        UIButton * btn17  = [[UIButton alloc]init];
        btn17 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn17.tag = 17;
        btn17.frame = CGRectMake(60, 40+94*14, 220, 66);
        btn17.backgroundColor = [UIColor clearColor];
        [btn17 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn17];
        
        
       
        
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6 plus的大小");
        
        UIButton * btn0  = [[UIButton alloc]init];
        btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn0.tag = 0;
        btn0.frame = CGRectMake(73, 45+102*0, 115, 66);
        btn0.backgroundColor = [UIColor clearColor];
        //    [btn0 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn0 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn0];
        
        
        UIButton * btn1  = [[UIButton alloc]init];
        btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.tag = 1;
        btn1.frame = CGRectMake(78+btn0.bounds.size.width, 45+102*0, 110, 66);
        btn1.backgroundColor = [UIColor clearColor];
        //    [btn1 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn1];
        
        
        UIButton * btn2  = [[UIButton alloc]init];
        btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.tag = 2;
        btn2.frame = CGRectMake(40+btn0.bounds.size.width, 50+102*1, 180, 66);
        btn2.backgroundColor = [UIColor clearColor];
        //    [btn2 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn2];
        
        
        UIButton * btn3  = [[UIButton alloc]init];
        btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.tag = 3;
        btn3.frame = CGRectMake(75, 50+102*2, 220, 66);
        btn3.backgroundColor = [UIColor clearColor];
        //    [btn3 setTitle:@"Tel" forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn3];
        
        
        UIButton * btn4  = [[UIButton alloc]init];
        btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.tag = 4;
        btn4.frame = CGRectMake(35+btn0.bounds.size.width, 50+102*3, 180, 66);
        btn4.backgroundColor = [UIColor clearColor];
        [btn4 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn4];
        
        
        UIButton * btn5  = [[UIButton alloc]init];
        btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn5.tag = 5;
        btn5.frame = CGRectMake(75, 50+102*4, 220, 66);
        btn5.backgroundColor = [UIColor clearColor];
        [btn5 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn5];
        
        
        UIButton * btn6  = [[UIButton alloc]init];
        btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn6.tag = 6;
        btn6.frame = CGRectMake(130, 50+103*5, 210, 66);
        btn6.backgroundColor = [UIColor clearColor];
        [btn6 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn6];
        
        
        UIButton * btn7  = [[UIButton alloc]init];
        btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn7.tag = 7;
        btn7.frame = CGRectMake(80, 50+103*6, 100, 66);
        btn7.backgroundColor = [UIColor clearColor];
        [btn7 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn7];
        
        
        
        UIButton * btn8  = [[UIButton alloc]init];
        btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn8.tag = 8;
        btn8.frame = CGRectMake(85+btn7.bounds.size.width, 50+103*6, 100, 66);
        btn8.backgroundColor = [UIColor clearColor];
        [btn8 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn8];
        
        
        UIButton * btn9  = [[UIButton alloc]init];
        btn9 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn9.tag = 9;
        btn9.frame = CGRectMake(130, 50+103*7, 200, 66);
        btn9.backgroundColor = [UIColor clearColor];
        [btn9 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn9];
        
        
        UIButton * btn10  = [[UIButton alloc]init];
        btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn10.tag = 10;
        btn10.frame = CGRectMake(75, 50+103*8, 110, 66);
        btn10.backgroundColor = [UIColor clearColor];
        [btn10 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn10];
        
        UIButton * btn11  = [[UIButton alloc]init];
        btn11 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn11.tag = 11;
        btn11.frame = CGRectMake(85 + btn10.bounds.size.width, 50+103*8, 110, 66);
        btn11.backgroundColor = [UIColor clearColor];
        [btn11 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn11];
        
        UIButton * btn12  = [[UIButton alloc]init];
        btn12 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn12.tag = 12;
        btn12.frame = CGRectMake(35+btn0.bounds.size.width, 50+103*9, 180, 66);
        btn12.backgroundColor = [UIColor clearColor];
        [btn12 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn12];
        
        UIButton * btn13  = [[UIButton alloc]init];
        btn13 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn13.tag = 13;
        btn13.frame = CGRectMake(80, 50+103*10, 220, 66);
        btn13.backgroundColor = [UIColor clearColor];
        [btn13 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn13];
        
        UIButton * btn14  = [[UIButton alloc]init];
        btn14 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn14.tag = 14;
        btn14.frame = CGRectMake(20+btn0.bounds.size.width, 50+103.5*11, 185, 66);
        btn14.backgroundColor = [UIColor clearColor];
        [btn14 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn14];
        
        UIButton * btn15  = [[UIButton alloc]init];
        btn15 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn15.tag = 15;
        btn15.frame = CGRectMake(80, 50+103.5*12, 220, 66);
        btn15.backgroundColor = [UIColor clearColor];
        [btn15 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn15];
        
        UIButton * btn16  = [[UIButton alloc]init];
        btn16 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn16.tag = 16;
        btn16.frame = CGRectMake(20+btn0.bounds.size.width, 50+103.5*13, 185, 66);
        btn16.backgroundColor = [UIColor clearColor];
        [btn16 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn16];
        
        UIButton * btn17  = [[UIButton alloc]init];
        btn17 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn17.tag = 17;
        btn17.frame = CGRectMake(80, 50+103.5*14, 220, 66);
        btn17.backgroundColor = [UIColor clearColor];
        [btn17 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn17];
        
        
        
        
//        btn0.backgroundColor = [UIColor redColor];
//        btn1.backgroundColor = [UIColor redColor];
//        btn2.backgroundColor = [UIColor redColor];
//        btn3.backgroundColor = [UIColor redColor];
//        btn4.backgroundColor = [UIColor redColor];
//        btn5.backgroundColor = [UIColor redColor];
//        btn6.backgroundColor = [UIColor redColor];
//        btn7.backgroundColor = [UIColor redColor];
//        btn8.backgroundColor = [UIColor redColor];
//        btn9.backgroundColor = [UIColor redColor];
//        btn10.backgroundColor = [UIColor redColor];
//        btn11.backgroundColor = [UIColor redColor];
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
        case 3:
            tel =   @"0719077077";
            break;
        case 4:
            tel =   @"0417117700";
            break;
        case 5:
            tel =   @"5033,0788156600";
            break;
        case 6:
            tel =   @"0996010000";
            break;
        case 7:
            tel =   @"22275929";
            break;
        case 8:
            tel =   @"22275930";
            break;
        case 9:
            tel =   @"21342400";
            break;
        case 10:
            tel =   @"655700700";
            break;
        case 11:
            tel =   @"664707070";
            break;
        case 12:
            tel =   @"86060";
            break;
        case 13:
            tel =   @"0302748188";
            break;
        case 14:
            tel =   @"2000";
            break;
        case 15:
            tel =   @"066474040";
            break;
        case 16:
            tel =   @"0860867827";
            break;
        case 17:
            tel =   @"0202220275";
            break;
            
        default:
            break;
    }
    
    
    UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",tel] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil];
    
    //    UIAlertView * linkAlert =   [[UIAlertView alloc] initWithTitle:@"Alert View"message:@"We Will Call" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSString stringWithFormat:@"22:%@",tel],[NSString stringWithFormat:@"00:%@",tel], nil];
    
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
