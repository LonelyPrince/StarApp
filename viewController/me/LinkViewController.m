//
//  LinkViewController.m
//  StarAPP
//
//  Created by xyz on 2016/11/7.
//
//

#import "LinkViewController.h"

@interface LinkViewController ()<UIAlertViewDelegate>
{
NSString * tel ;
}
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIScrollView * scrollView;

@end

@implementation LinkViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    [self loadNav];
    
}

-(void)loadNav
{
    self.navigationController.title = @"Help Center";
    self.title =  @"Help Center";

    [self loadScroll];
    
    UIImageView * imageView = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 930)];
    imageView.image = [UIImage imageNamed:@"con-"];
    [self.scrollView addSubview:imageView];
}
-(void)loadScroll
{
    //加一个scrollview
    self.scrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.scrollView ];
    
    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 930);
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
//    for (int i = 0; i<9; i++) {
//        UIButton * btn  = [[UIButton alloc]init];
////        btn.backgroundColor = [UIColor redColor];
////        btn.tag = i;
////        [btn addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
////        btn  = [UIButton buttonWithType:UIButtonTypeCustom];
////        [btn setTitle:@"i" forState:UIControlStateNormal];
////        [_scrollView addSubview:btn];
////        [_scrollView bringSubviewToFront:btn];
//        
//        
//        btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.tag = i;
//        btn.frame = CGRectMake(0, 20+97*i, SCREEN_WIDTH, 90);
//        btn.backgroundColor = [UIColor redColor];
//        [btn setTitle:@"DEL" forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
//        [_scrollView addSubview:btn];
//        
//    }
    
    UIButton * btn0  = [[UIButton alloc]init];
    btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn0.tag = 0;
    btn0.frame = CGRectMake(50, 40+97*0, 115, 66);
    btn0.backgroundColor = [UIColor clearColor];
    [btn0 setTitle:@"Tel" forState:UIControlStateNormal];
    [btn0 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn0];
    
    UIButton * btn1  = [[UIButton alloc]init];
    btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 1;
    btn1.frame = CGRectMake(60+btn0.bounds.size.width, 40+97*0, 110, 66);
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 setTitle:@"Tel" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn1];
    
    UIButton * btn2  = [[UIButton alloc]init];
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 2;
    btn2.frame = CGRectMake(15+btn0.bounds.size.width, 40+97*1, 180, 66);
    btn2.backgroundColor = [UIColor clearColor];
    [btn2 setTitle:@"Tel" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn2];
    
    UIButton * btn3  = [[UIButton alloc]init];
    btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.tag = 3;
    btn3.frame = CGRectMake(55, 40+97*2, 220, 66);
    btn3.backgroundColor = [UIColor clearColor];
    [btn3 setTitle:@"Tel" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn3];
    
    UIButton * btn4  = [[UIButton alloc]init];
    btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.tag = 4;
    btn4.frame = CGRectMake(15+btn0.bounds.size.width, 40+97*3, 180, 66);
    btn4.backgroundColor = [UIColor clearColor];
    [btn4 setTitle:@"Tel" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn4];
    
    UIButton * btn5  = [[UIButton alloc]init];
    btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.tag = 5;
    btn5.frame = CGRectMake(60, 40+97*4, 220, 66);
    btn5.backgroundColor = [UIColor clearColor];
    [btn5 setTitle:@"Tel" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn5];
    
    UIButton * btn6  = [[UIButton alloc]init];
    btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn6.tag = 6;
    btn6.frame = CGRectMake(115, 40+97*5, 210, 66);
    btn6.backgroundColor = [UIColor clearColor];
    [btn6 setTitle:@"Tel" forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn6];
    
    UIButton * btn7  = [[UIButton alloc]init];
    btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn7.tag = 7;
    btn7.frame = CGRectMake(60, 40+97*6, 100, 66);
    btn7.backgroundColor = [UIColor clearColor];
    [btn7 setTitle:@"Tel" forState:UIControlStateNormal];
    [btn7 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn7];
    
    UIButton * btn8  = [[UIButton alloc]init];
    btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn8.tag = 8;
    btn8.frame = CGRectMake(70+btn7.bounds.size.width, 40+97*6, 100, 66);
    btn8.backgroundColor = [UIColor clearColor];
    [btn8 setTitle:@"Tel" forState:UIControlStateNormal];
    [btn8 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn8];

    UIButton * btn9  = [[UIButton alloc]init];
    btn9 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn9.tag = 9;
    btn9.frame = CGRectMake(110, 40+97*7, 200, 66);
    btn9.backgroundColor = [UIColor clearColor];
    [btn9 setTitle:@"Tel" forState:UIControlStateNormal];
    [btn9 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn9];
    
    UIButton * btn10  = [[UIButton alloc]init];
    btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn10.tag = 10;
    btn10.frame = CGRectMake(55, 40+97*8, 110, 66);
    btn10.backgroundColor = [UIColor clearColor];
    [btn10 setTitle:@"Tel" forState:UIControlStateNormal];
    [btn10 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn10];
    
    UIButton * btn11  = [[UIButton alloc]init];
    btn11 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn11.tag = 11;
    btn11.frame = CGRectMake(65 + btn10.bounds.size.width, 40+97*8, 110, 66);
    btn11.backgroundColor = [UIColor clearColor];
    [btn11 setTitle:@"Tel" forState:UIControlStateNormal];
    [btn11 addTarget:self action:@selector(linkBtnClick :) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btn11];
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
            tel =   @"094618888";
            break;
        case 11:
            tel =   @"014618888";
            break;
        
        default:
            break;
    }
    
    
    UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",tel] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
    
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
