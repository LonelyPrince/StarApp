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
//    [scroll removeFromSuperview];
//    scroll = nil;
    categorysArr = [USER_DEFAULT objectForKey:@"categorysToCategoryView"];
    NSLog(@"categorysArr:--%@",categorysArr);
    [self loadScroll];
    [self loadBtn];


}
-(void)loadScroll
{

    
    
    
//    //加一个scrollview
    scroll.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49);
    scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scroll];
    
        scroll.contentSize=CGSizeMake(SCREEN_WIDTH, 788);
//    scroll.contentSize=CGSizeMake(SCREEN_WIDTH, 614+105 - 216);
    //    scroll.pagingEnabled=YES;
    scroll.showsVerticalScrollIndicator=NO;
    scroll.showsHorizontalScrollIndicator=NO;
    scroll.delegate=self;
    scroll.bounces=NO;
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
        imageView.image = [UIImage imageNamed:@"Religion"];
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
    NSLog(@"点击了%ld",(long)sender.tag);
    
    NSNumber * currentIndex = [NSNumber numberWithInt:sender.tag];
    NSDictionary * dict =[[NSDictionary alloc] initWithObjectsAndKeys:currentIndex,@"currentIndex", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"categorysTouchToViews" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
      [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end