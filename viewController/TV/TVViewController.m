//
//  TVViewController.m
//  starApp
//
//  Created by xyz on 16/8/1.
//  Copyright © 2016年 xyz. All rights reserved.
//

#import "TVViewController.h"





@interface TVViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ZXVideoPlayerController *videoController;
@property(nonatomic,strong)SearchViewController * searchViewCon;

//new  scroll table
@property (nonatomic, strong) NSMutableArray *dataSource;    //
@property (nonatomic, strong) UITableView *table;   // table表
@property (nonatomic, strong) UIScrollView *topScroller;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *categorys;

@property (nonatomic, assign) NSInteger currentIndex;

@property (strong,nonatomic) NSMutableArray *serviceData;


@end

@implementation TVViewController

@synthesize searchViewCon;
//@synthesize videoPlay;
- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    [self loadNav];
    
   //new
    [self initData];    //table表
    
    [self loadUI];              //加载table 和scroll
    [self getTopCategory];
    [self getServiceData];    //获取表数据
    

    

    self.view.backgroundColor = [UIColor greenColor];
    
    //视频部分
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self playVideo];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
//1.line
-(UIView *) lineView
{
    if (!_lineView){
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, SCREEN_WIDTH/5, 3)];
        _lineView.backgroundColor = homeTintColor;
        [self.topScroller addSubview:_lineView];
    }
    return _lineView;
}
-(void) initData
{
    self.dataSource = [NSMutableArray array];
}
-(void) loadUI
{
    [self creatTopScroller];   //创建scroll
    
    
    //创建table表
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 270, SCREEN_WIDTH, SCREEN_HEIGHT-300) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    //    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.table = table;
//
}
//创建顶部滑动条
-(void) creatTopScroller
{
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 44)];
    scroller.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scroller];
    scroller.showsVerticalScrollIndicator = NO;
    scroller.showsHorizontalScrollIndicator = NO;
    self.topScroller = scroller;
    [self.table  bringSubviewToFront:scroller];
}
//获取scroll
-(void) getTopCategory
{
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
    
    [request startAsynchronous];
    
    WEAKGET
    [request setCompletionBlock:^{
        NSDictionary *response = httpRequest.responseString.JSONValue;
        NSLog(@"response = %@",response);
        NSArray *data = response[@"category"];
        
        if (!isValidArray(data) || data.count == 0){
            return ;
        }
        self.categorys = (NSMutableArray *)data;
        
        
        //[AppDelegate shareAppDelegate].leftVC.dataSource = self.categorys;
        
        //  [self.collectionView reloadData];
        [self refreshTopScroller];
    }];
    
}

//获取table
-(void) getServiceData
{
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
    
    
    [request startAsynchronous];
    
    WEAKGET
    [request setCompletionBlock:^{
        NSDictionary *response = httpRequest.responseString.JSONValue;
        NSLog(@"response = %@",response);
        NSArray *data1 = response[@"service"];
        if (!isValidArray(data1) || data1.count == 0){
            return ;
        }
        self.serviceData = (NSMutableArray *)data1;
        
        NSLog(@"--------%@",self.serviceData);
        
        [self.table reloadData];
       
    }];
    
}
-(void) refreshTopScroller
{
    for (int i = 0 ; i < self.categorys.count; i++) {
        NSDictionary *item = self.categorys[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH/5*i, 0, SCREEN_WIDTH/5, 44);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitle:item[@"category_name"] forState:UIControlStateNormal];
        [btn setTitleColor:homeTintColor forState:UIControlStateNormal];
        [self.topScroller addSubview:btn];
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            self.currentIndex = i;
            [UIView animateWithDuration:0.2 animations:^{
                self.lineView.frame = CGRectMake(i*SCREEN_WIDTH/5, 36, SCREEN_WIDTH/5, 3);
            }];
            [UIView animateWithDuration:0.2 animations:^{
                //self.collectionView.contentOffset = CGPointMake(SCREEN_WIDTH*i, 0);
            }];
        }];
    }
    self.lineView.hidden = NO;
    self.topScroller.contentSize = CGSizeMake(SCREEN_WIDTH/5*self.categorys.count, 44);
    
}
-(void)loadNav
{

    //设置右边按钮
//    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 70, 30);
//    [rightBtn setImage:[UIImage imageNamed:@"category"] forState:UIControlStateNormal];
//    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = item;
    
    //顶部搜索条
    self.navigationController.navigationBarHidden = YES;
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -30, SCREEN_WIDTH, topViewHeight)];
    topView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:topView];
    
    //self.navigationController.navigationBar.barTintColor = UIStatusBarStyleDefault;
    
    //搜索按钮
    UIButton * searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight)];
    [searchBtn setTitle:@"search" forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:[UIColor blackColor]];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    [topView bringSubviewToFront:searchBtn];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //视频播放
   //----直播源
    self.video = [[ZXVideo alloc] init];
    //    video.playUrl = @"http://baobab.wdjcdn.com/1451897812703c.mp4";
    self.video.playUrl = @"http://192.168.32.66/vod/mp4:151463.mp4/playlist.m3u8";
   self.video.title = @"Rollin'Wild 圆滚滚的";
    
    NSLog(@"----%@",self.video.playUrl);
    NSLog(@"----%@",self.video.title);
    

  }

- (void)playVideo
{
    if (!self.videoController) {
        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, searchBtnY+searchBtnHeight, kZXVideoPlayerOriginalWidth, kZXVideoPlayerOriginalHeight)];
        
        __weak typeof(self) weakSelf = self;
        self.videoController.videoPlayerGoBackBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
            [strongSelf.navigationController setNavigationBarHidden:NO animated:YES];
            
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
            
            strongSelf.videoController = nil;
        };
        
        self.videoController.videoPlayerWillChangeToOriginalScreenModeBlock = ^(){
            NSLog(@"切换为竖屏模式");
        };
        self.videoController.videoPlayerWillChangeToFullScreenModeBlock = ^(){
            NSLog(@"切换为全屏模式");
           self.tabBarController.tabBar.hidden = YES;
        };
        
        [self.videoController showInView:self.view];
    }
    

    
    self.videoController.video = self.video;
    NSLog(@"video:%@",self.videoController.video.title);
    NSLog(@"video:%@",self.videoController.video.playUrl);
}

-(void)searchBtnClick
{
    searchViewCon = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchViewCon animated:YES];
}


/**
 创建表的deklegate方法
 
 */
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"````````````%lu",(unsigned long)self.serviceData.count);
    return self.serviceData.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TVCell defaultCellHeight];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    TVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TVCell"];
    if (cell == nil){
        cell = [TVCell loadFromNib];
    }
    
    cell.dataDic = self.serviceData[indexPath.row];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    DetailViewController *controller =[[DetailViewController alloc] init];
    //    controller.dataDic = self.dataSource[indexPath.row];
    //    [self.navigationController pushViewController:controller animated:YES];
    
    //被选择时播放视频并高亮
    
}


@end
