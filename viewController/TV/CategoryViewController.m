//
//  CategoryViewController.m
//  StarAPP
//
//  Created by xyz on 2016/12/5.
//
//

#import "CategoryViewController.h"

@interface CategoryViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView * scroll;
//@property(nonatomic,strong)UIButton * categoryBtns;
@property(nonatomic,strong)NSArray * categorysArr;

@end

@implementation CategoryViewController
@synthesize scroll;
//@synthesize categoryBtns;
@synthesize categorysArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"Category";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]}];

    [self initData];
    
}


-(void)initData
{
    scroll = [[UIScrollView alloc]init];
    
//    categoryBtns = [[UIButton alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [USER_DEFAULT setObject:@"NO" forKey:@"modeifyTVViewRevolve"];   //防止刚跳转到主页时就旋转到全屏
//    [scroll removeFromSuperview];
//    scroll = nil;
    categorysArr = [USER_DEFAULT objectForKey:@"categorysToCategoryView"];
    NSLog(@"categorysArr:--%@",categorysArr);
    [self loadScroll];
    [self loadBtn];
    [self TVViewAppear];

}
-(void)TVViewAppear
{
    [USER_DEFAULT setObject:@"YES" forKey:@"jumpFormOtherView"];//为TV页面存储方法
}
-(void)TVViewAppearNO
{
    [USER_DEFAULT setObject:@"NO" forKey:@"jumpFormOtherView"];//为TV页面存储方法
}
-(void)loadScroll
{

    
    
    
//    //加一个scrollview
    scroll.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49);
    scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scroll];
    
//        scroll.contentSize=CGSizeMake(SCREEN_WIDTH, 788);
    if (categorysArr.count%3 == 0) {
        scroll.contentSize = CGSizeMake(SCREEN_WIDTH, (categorysArr.count/3)*(SCREEN_WIDTH/3));
    }else
    {
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH, (categorysArr.count/3)*(SCREEN_WIDTH/3)+(SCREEN_WIDTH/3));
    }
    
//    scroll.contentSize=CGSizeMake(SCREEN_WIDTH, 614+105 - 216);
    //    scroll.pagingEnabled=YES;
    scroll.showsVerticalScrollIndicator=NO;
    scroll.showsHorizontalScrollIndicator=NO;
    scroll.delegate=self;
    scroll.bounces=YES;
}

-(void)loadBtn
{
    
    for (int i = 0 ; i < categorysArr.count; i++) {
        NSDictionary *item = categorysArr[i];
        NSString * tempStr;
        tempStr =item[@"category_name"];
        
//        [_titles addObject:tempArray];
  
        int a = i%3;
        int b = i/3;
    
        UIButton * categoryBtns = [UIButton buttonWithType:UIButtonTypeCustom];
        categoryBtns.frame = CGRectMake(a*(SCREEN_WIDTH/3),b*SCREEN_WIDTH/3, SCREEN_WIDTH/3, SCREEN_WIDTH/3);
    [categoryBtns setBackgroundColor:[UIColor whiteColor]];
        categoryBtns.tag = i;
        [categoryBtns addTarget:self action:@selector(categoryBtnsClick:) forControlEvents:UIControlEventTouchUpInside];
      //    [searchBtn setTitle:@"search" forState:UIControlStateNormal];
        //    [searchBtn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
        //    [self.categoryBtns setBackgroundImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
        //        [categoryBtns setTitle:tempStr forState:UIControlStateNormal  ];
        
        //    [topView bringSubviewToFront:self.searchBtn];
        [self.scroll addSubview:categoryBtns];
        
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/9, 25, SCREEN_WIDTH/9, SCREEN_WIDTH/9)];
        
//        imageView.image = [UIImage imageNamed:@"Religion"];
        [self judgeName:tempStr UIImageView:imageView];
        
        [categoryBtns addSubview:imageView];
        
        
        UILabel * namelab = [[UILabel alloc]init];
        namelab.text = tempStr;
        namelab.font = FONT(14);
        CGSize size = [namelab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT(14),NSFontAttributeName, nil]];
        CGFloat nameH = size.height;
        // 名字的W
        CGFloat nameW = size.width;
        namelab.frame = CGRectMake((SCREEN_WIDTH/3-nameW)/2, 88, nameW,nameH);
        namelab.tintColor = [UIColor blackColor];
        [categoryBtns addSubview:namelab];
    }
    
}

-(void)categoryBtnsClick :(UIButton *)sender
{
    [self TVViewAppearNO];
    NSLog(@"点击了%ld",(long)sender.tag);
    
    NSNumber * currentIndex = [NSNumber numberWithInt:sender.tag];
    NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndex,@"currentIndex", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
      [self.navigationController popViewControllerAnimated:YES];
}

-(void)judgeName:(NSString *)name  UIImageView: (UIImageView *)imageView
{
    if ([name isEqualToString:@"Entertainment"] || [name isEqualToString:@"Ent"] || [name isEqualToString:@"GEC"]) {  //OK
       imageView.image = [UIImage imageNamed:@"Entertainment"];
    }
    else if ([name isEqualToString:@"Chinese Channel"] || [name isEqualToString:@"Chinese"])  //OK
    {
       imageView.image = [UIImage imageNamed:@"Chinese Channel"];
    }
    else if ([name isEqualToString:@"Doc"] || [name isEqualToString:@"Documentary"])  //OK
    {
        imageView.image = [UIImage imageNamed:@"Documentary"];
    }
    else if ([name isEqualToString:@"kids"] || [name isEqualToString:@"Children's/Youth Programmes"])  //OK
    {
        imageView.image = [UIImage imageNamed:@"kids"];
    }
    else if ([name isEqualToString:@"Life Style"] || [name isEqualToString:@"Life-style"]) //OK
    {
        imageView.image = [UIImage imageNamed:@"Life Style"];
    }
    else if ([name isEqualToString:@"Local"])  //OK
    {
        imageView.image = [UIImage imageNamed:@"Local"];
    }
    else if ([name isEqualToString:@"Movies"])  //OK
    {
        imageView.image = [UIImage imageNamed:@"Movies"];
    }
    else if ([name isEqualToString:@"Movies & Series"] || [name isEqualToString:@"Movies and Series"]) //OK
    {
        imageView.image = [UIImage imageNamed:@"Movies & Series"];
    }
    else if ([name isEqualToString:@"News"]  || [name isEqualToString:@"Current Affairs"] || [name isEqualToString:@"Economics"] )  //OK
    {
        imageView.image = [UIImage imageNamed:@"News"];
    }
    else if ([name isEqualToString:@"Religion"])  //OK
    {
        imageView.image = [UIImage imageNamed:@"Religion"];
    }
    else if ([name isEqualToString:@"South African"]) //OK
    {
        imageView.image = [UIImage imageNamed:@"South African"];
    }
    else if ([name isEqualToString:@"Special Characteristics"])  //OK
    {
        imageView.image = [UIImage imageNamed:@"Special Characteristics"];
    }
    else if ([name isEqualToString:@"Sports"]  || [name isEqualToString:@"Sport"])  //OK
    {
        imageView.image = [UIImage imageNamed:@"Sports"];
    }
    else if ([name isEqualToString:@"Factual"] )  //OK
    {
        imageView.image = [UIImage imageNamed:@"Factual"];
    }
    else if ([name isEqualToString:@"Education"] )  //OK 
    {
        imageView.image = [UIImage imageNamed:@"Education"];
    }
    else if ([name isEqualToString:@"Music"] )  //OK
    {
        imageView.image = [UIImage imageNamed:@"Music"];
    }
    else if ([name isEqualToString:@"Series"])  //OK
    {
        imageView.image = [UIImage imageNamed:@"Series"];
    }
    else if ([name isEqualToString:@"Guide"])  //OK 
    {
        imageView.image = [UIImage imageNamed:@"Guide"];
    }
    else if ([name isEqualToString:@"Indian"])  //OK
    {
        imageView.image = [UIImage imageNamed:@"Indian"];
    }
    else if ([name isEqualToString:@"ALL"] || [name isEqualToString:@"All Channel"] || [name isEqualToString:@"All Channels"])  //OK
    {
        imageView.image = [UIImage imageNamed:@"All Channel"];
    }
//    else if ([name isEqualToString:@"dtt"])  //test
//    {
//        imageView.image = [UIImage imageNamed:@"abcd"];
//    }
//    else if ([name isEqualToString:@"radio"])  //test
//    {
//        imageView.image = [UIImage imageNamed:@"music1"];
//    }
//    else if ([name isEqualToString:@"dth"])  //test
//    {
//        imageView.image = [UIImage imageNamed:@"Indian"];
//    }
    else
    {
        imageView.image = [UIImage imageNamed:@"Startimes"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
