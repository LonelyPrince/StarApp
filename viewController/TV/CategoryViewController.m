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
    
    categorysArr = [self titleArrReplace:[USER_DEFAULT objectForKey:@"categorysToCategoryView"]];
    NSLog(@"categorysArr:--%@",categorysArr);
    [self loadScroll];
    [self loadBtn];
    [self TVViewAppear];
 
    [USER_DEFAULT setObject:@"0" forKey:@"viewISTVView"];  //如果是TV页面，则再用户按home键后再次进入，需要重新播放 , 0 代表不是TV页面， 1 代表是TV页面
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
        if ([item isEqual:@"Recordings" ]) {
            tempStr = @"Recordings";
        }else
        {
                tempStr =item[@"category_name"];
        }
        
        
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
        CGFloat nameW;
        if (size.width > (SCREEN_WIDTH/3) - 5) {
            nameW = (SCREEN_WIDTH/3) - 5;
        }else
        {
            nameW = size.width;
        }
        
        namelab.frame = CGRectMake((SCREEN_WIDTH/3-nameW)/2, 88, nameW,nameH);
        namelab.tintColor = [UIColor blackColor];
        [categoryBtns addSubview:namelab];
    }
    
}

-(void)categoryBtnsClick :(UIButton *)sender
{
    [self TVViewAppear];
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
    if ([name isEqualToString:@"Entertainment"] || [name isEqualToString:@"entertainment"] || [name isEqualToString:@"Ent"] || [name isEqualToString:@"ent"] || [name isEqualToString:@"GEC"] || [name isEqualToString:@"gEC"]) {  //OK1
        imageView.image = [UIImage imageNamed:@"Entertainment"];
    }
    else if ([name isEqualToString:@"Chinese Channel"] ||[name isEqualToString:@"chinese Channel"] || [name isEqualToString:@"chinese channel"] || [name isEqualToString:@"Chinese channel"] || [name isEqualToString:@"Chinese_Channel"] ||[name isEqualToString:@"chinese_Channel"] || [name isEqualToString:@"chinese_channel"] || [name isEqualToString:@"Chinese _channel"] || [name isEqualToString:@"Chinese"] || [name isEqualToString:@"chinese"]  )  //OK1
    {
        imageView.image = [UIImage imageNamed:@"Chinese Channel"];
    }
    else if ([name isEqualToString:@"Doc"] || [name isEqualToString:@"Documentary"] || [name isEqualToString:@"doc"] || [name isEqualToString:@"documentary"])  //OK1
    {
        imageView.image = [UIImage imageNamed:@"Documentary"];
    }
    else if ([name isEqualToString:@"kids"] ||[name isEqualToString:@"Kids"] || [name isEqualToString:@"Children's/Youth Programmes"] || [name isEqualToString:@"Children's"] || [name isEqualToString:@"children's"]  || [name isEqualToString:@"Youth Programmes"] || [name isEqualToString:@"youth programmes"] || [name isEqualToString:@"Youth_Programmes"] || [name isEqualToString:@"youth_programmes"])  //OK1
    {
        imageView.image = [UIImage imageNamed:@"kids"];
    }
    else if ([name isEqualToString:@"Life Style"] || [name isEqualToString:@"life Style"] || [name isEqualToString:@"life style"] || [name isEqualToString:@"Life style"]  || [name isEqualToString:@"Life_Style"] || [name isEqualToString:@"life_Style"] || [name isEqualToString:@"life_style"] || [name isEqualToString:@"Life_style"]|| [name isEqualToString:@"Life-style"]) //OK1
    {
        imageView.image = [UIImage imageNamed:@"Life Style"];
    }
    else if ([name isEqualToString:@"Local"] || [name isEqualToString:@"local"])  //OK1
    {
        imageView.image = [UIImage imageNamed:@"Local"];
    }
    else if ([name isEqualToString:@"Movies"] || [name isEqualToString:@"movies"])  //OK1
    {
        imageView.image = [UIImage imageNamed:@"Movies"];
    }
    else if ([name isEqualToString:@"Movies & Series"] || [name isEqualToString:@"Movies and Series"] || [name isEqualToString:@"movies & series"] || [name isEqualToString:@"movies and series"] || [name isEqualToString:@"Movies & series"] || [name isEqualToString:@"Movies and series"] || [name isEqualToString:@"movies & Series"] || [name isEqualToString:@"movies and Series"]) //OK
    {
        imageView.image = [UIImage imageNamed:@"Movies & Series"];
    }
    else if ([name isEqualToString:@"News"] || [name isEqualToString:@"news"]  || [name isEqualToString:@"Current Affairs"] || [name isEqualToString:@"current Affairs"] || [name isEqualToString:@"Current affairs"] || [name isEqualToString:@"current affairs"] || [name isEqualToString:@"Current_Affairs"] || [name isEqualToString:@"current_Affairs"] || [name isEqualToString:@"Current_affairs"] || [name isEqualToString:@"current_affairs"]|| [name isEqualToString:@"Economics"] || [name isEqualToString:@"economics"] )  //OK1
    {
        imageView.image = [UIImage imageNamed:@"News"];
    }
    else if ([name isEqualToString:@"Religion"] || [name isEqualToString:@"religion"])  //OK1
    {
        imageView.image = [UIImage imageNamed:@"Religion"];
    }
    else if ([name isEqualToString:@"South African"] || [name isEqualToString:@"South african"] || [name isEqualToString:@"south African"] || [name isEqualToString:@"south african"] || [name isEqualToString:@"South_African"] || [name isEqualToString:@"South_african"] || [name isEqualToString:@"south_African"] || [name isEqualToString:@"south_african"]) //OK1
    {
        imageView.image = [UIImage imageNamed:@"South African"];
    }
    else if ([name isEqualToString:@"Special Characteristics"] || [name isEqualToString:@"special Characteristics"] || [name isEqualToString:@"Special characteristics"] || [name isEqualToString:@"special characteristics"] || [name isEqualToString:@"Special_Characteristics"] || [name isEqualToString:@"special_Characteristics"] || [name isEqualToString:@"Special_characteristics"] || [name isEqualToString:@"special_characteristics"])  //OK1
    {
        imageView.image = [UIImage imageNamed:@"Special Characteristics"];
    }
    else if ([name isEqualToString:@"Sports"] || [name isEqualToString:@"sports"]  || [name isEqualToString:@"Sport"] || [name isEqualToString:@"sport"])  //OK1
    {
        imageView.image = [UIImage imageNamed:@"Sports"];
    }
    else if ([name isEqualToString:@"Factual"] || [name isEqualToString:@"factual"] )  //OK1
    {
        imageView.image = [UIImage imageNamed:@"Factual"];
    }
    else if ([name isEqualToString:@"Education"] || [name isEqualToString:@"education"] )  //OK1
    {
        imageView.image = [UIImage imageNamed:@"Education"];
    }
    else if ([name isEqualToString:@"Music"] || [name isEqualToString:@"music"] )  //OK1
    {
        imageView.image = [UIImage imageNamed:@"Music"];
    }
    else if ([name isEqualToString:@"Series"] || [name isEqualToString:@"series"])  //OK1
    {
        imageView.image = [UIImage imageNamed:@"Series"];
    }
    else if ([name isEqualToString:@"Guide"] || [name isEqualToString:@"guide"])  //OK1
    {
        imageView.image = [UIImage imageNamed:@"Guide"];
    }
    else if ([name isEqualToString:@"Recordings"] || [name isEqualToString:@"Recording"])  //OK1
    {
        imageView.image = [UIImage imageNamed:@"录制带色"];
    }
    else if ([name isEqualToString:@"Indian"] || [name isEqualToString:@"indian"])  //OK1
    {
        imageView.image = [UIImage imageNamed:@"Indian"];
    }
    else if ([name isEqualToString:@"ALL"] || [name isEqualToString:@"all"] || [name isEqualToString:@"All Channel"] || [name isEqualToString:@"all Channel"] || [name isEqualToString:@"All channel"] || [name isEqualToString:@"all channel"] || [name isEqualToString:@"All_Channel"] || [name isEqualToString:@"all_Channel"] || [name isEqualToString:@"All_channel"] || [name isEqualToString:@"all_channel"] || [name isEqualToString:@"All Channels"] || [name isEqualToString:@"all Channels"] || [name isEqualToString:@"All channels"] || [name isEqualToString:@"all channels"] || [name isEqualToString:@"All_Channels"] || [name isEqualToString:@"all_Channels"] || [name isEqualToString:@"All_channels"] || [name isEqualToString:@"all_channels"])  //OK1
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

-(NSMutableArray *)titleArrReplace:(NSMutableArray*)titles
{
    NSMutableArray * tempTitlesArr = [[NSMutableArray alloc]init];
    /*
     1.先判断是那种类型，录制和直播节目是否同时存在
     2.根部不同的类别进行数据组合和最后的赋值
     **/
    //#define   RecAndLiveNotHave  @"0"      //录制和直播都不存在
    //#define   RecExit            @"1"      //录制存在直播不存在
    //#define   LiveExit           @"2"      //录制不存在直播存在
    //#define   RecAndLiveAllHave  @"3"      //录制直播都存在
    NSString * RECAndLiveType = [USER_DEFAULT objectForKey:@"RECAndLiveType"];
    NSLog(@"RECAndLiveType %@",RECAndLiveType);
    
    if ([RECAndLiveType isEqualToString:@"RecAndLiveNotHave"]) {  //都不存在
        
    }else if ([RECAndLiveType isEqualToString:@"RecExit"]){ //录制存在直播不存在
        
        [tempTitlesArr insertObject:@"Recordings" atIndex:0];
    }else if ([RECAndLiveType isEqualToString:@"LiveExit"]){ //录制不存在直播存在
        
        tempTitlesArr =titles[0];
        
    }else if([RECAndLiveType isEqualToString:@"RecAndLiveAllHave"]){//都存在
        if (titles.count == 2 ) {   //正常情况
            tempTitlesArr =[titles[0] mutableCopy];
            
            [tempTitlesArr insertObject:@"Recordings" atIndex:1];
            NSLog(@"_titles %@",tempTitlesArr);
        }else if(titles.count == 1 )  //异常刷新，数组中只有一个元素
        {
            tempTitlesArr =titles[0];
        }
        
    }
    
 
    return tempTitlesArr;
}

@end
