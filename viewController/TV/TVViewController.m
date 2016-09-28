//
//  TVViewController.m
//  starApp
//
//  Created by xyz on 16/8/1.
//  Copyright © 2016年 xyz. All rights reserved.
//

#import "TVViewController.h"
#import "TVCell.h"
@interface TVViewController ()<YLSlideViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    YLSlideView * _slideView;
    NSArray *colors;
    NSArray *_testArray;
    NSMutableData * urlData;
    
}
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
//table的data
@property (strong,nonatomic) NSMutableArray *serviceTableData;

@property (nonatomic, assign) NSInteger category_index;
@property (strong,nonatomic)NSMutableDictionary * dicTemp;

//@property (strong,nonatomic) NSMutableArray *arrdata;

@end

@implementation TVViewController

@synthesize searchViewCon;
//@synthesize videoPlay;
- (void)viewDidLoad {
    [super viewDidLoad];
  
    //打开时开始连接socket并且发送心跳
    self.socketView  = [[SocketView  alloc]init];
    [self.socketView viewDidLoad];
    
    
    [self loadNav];
    
   //new
    [self initData];    //table表    
//    [self loadUI];              //加载table 和scroll
//    [self getTopCategory];
    [self getServiceData];    //获取表数据
    
//    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];//这个对象其实类似字典，着也是一个单例的例子
//    [userDef setObject:@"1111"forKey:@"data_service11"];
//    
//    [userDef synchronize];//把数据同步到本地
//    
    
    

    self.view.backgroundColor = [UIColor greenColor];
    
    //视频部分
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self playVideo];

    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars =NO;
    self.modalPresentationCapturesStatusBarAppearance =NO;
    self.navigationController.navigationBar.translucent =NO;
    
    colors = @[[UIColor redColor],[UIColor yellowColor],[UIColor blackColor],[UIColor redColor],[UIColor yellowColor],[UIColor blackColor],[UIColor redColor],[UIColor yellowColor],[UIColor blackColor]];
    //获取数据的链接
    NSString *url = [NSString stringWithFormat:@"%@",S_category];
    
    LBGetHttpRequest *request = CreateGetHTTP(url);
    
    
    
    [request startAsynchronous];
    
    WEAKGET
    [request setCompletionBlock:^{
        NSDictionary *response = httpRequest.responseString.JSONValue;
//        NSLog(@"response = %@",response);
        NSArray *data = response[@"category"];
        
        if (!isValidArray(data) || data.count == 0){
            return ;
        }
        self.categorys = (NSMutableArray *)data;
        
        //设置滑动条
        _slideView = [[YLSlideView alloc]initWithFrame:CGRectMake(0, searchBtnY+searchBtnHeight+kZXVideoPlayerOriginalHeight,
                                                                  SCREEN_WIDTH_YLSLIDE,
                                                                  SCREEN_HEIGHT_YLSLIDE-64)
                                             forTitles:self.categorys];
        
//        NSLog(@"category:%@",self.categorys);
        
        _slideView.backgroundColor = [UIColor whiteColor];
        _slideView.delegate        = self;
        
        [self.view addSubview:_slideView];
        
        
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
//1.line
//-(UIView *) lineView
//{
//    if (!_lineView){
//        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, SCREEN_WIDTH/5, 3)];
//        _lineView.backgroundColor = homeTintColor;
//        [self.topScroller addSubview:_lineView];
//    }
//    return _lineView;
//}
-(void) initData
{
    self.dicTemp = [[NSMutableDictionary alloc]init];
    self.dataSource = [NSMutableArray array];
}
//-(void) loadUI
//{
////    [self creatTopScroller];   //创建scroll
//}
////创建顶部滑动条
//-(void) creatTopScroller
//{
//    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 230, SCREEN_WIDTH, 44)];
//    scroller.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:scroller];
//    scroller.showsVerticalScrollIndicator = NO;
//    scroller.showsHorizontalScrollIndicator = NO;
//    self.topScroller = scroller;
//    [self.table  bringSubviewToFront:scroller];
//    

//}
////获取scroll
//-(void) getTopCategory
//{
//    //获取数据的链接
//    NSString *url = [NSString stringWithFormat:@"%@",S_category];
//    
//    LBGetHttpRequest *request = CreateGetHTTP(url);
//    
//    
//    [request startAsynchronous];
//    
//    WEAKGET
//    [request setCompletionBlock:^{
//        NSDictionary *response = httpRequest.responseString.JSONValue;
//        NSLog(@"response = %@",response);
//        NSArray *data = response[@"category"];
//        
//        if (!isValidArray(data) || data.count == 0){
//            return ;
//        }
//        self.categorys = (NSMutableArray *)data;
//        
//        
//        //[AppDelegate shareAppDelegate].leftVC.dataSource = self.categorys;
//        
//          [self.table reloadData];
//        [self refreshTopScroller];
//    }];
//    
//}

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
//        NSLog(@"response = %@",response);
        NSArray *data1 = response[@"service"];
        if (!isValidArray(data1) || data1.count == 0){
            return ;
        }
        self.serviceData = (NSMutableArray *)data1;
        
//        NSLog(@"--------%@",self.serviceData);
        
        [self.table reloadData];
       
    }];
    
}
-(void)loadNav
{
    //顶部搜索条
    self.navigationController.navigationBarHidden = YES;
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, -30, SCREEN_WIDTH, topViewHeight)];
    topView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:topView];
    
    //self.navigationController.navigationBar.barTintColor = UIStatusBarStyleDefault;
    
    //搜索按钮
    UIButton * searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(searchBtnX, searchBtnY, searchBtnWidth, searchBtnHeight)];
    [searchBtn setTitle:@"search" forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:[UIColor grayColor]];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    [topView bringSubviewToFront:searchBtn];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //视频播放
   //----直播源
    self.video = [[ZXVideo alloc] init];
    //    video.playUrl = @"http://baobab.wdjcdn.com/1451897812703c.mp4";
////    self.video.playUrl = @"http://192.168.32.66/vod/mp4:151463.mp4/playlist.m3u8";
//self.video.playUrl = @"http://192.168.1.1/segment_delivery/delivery_0/play_tv2ip_0.m3u8";
    //  http://192.168.1.1/segment_delivery/delivery_0/play_tv2ip_0.m3u8
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

//搜索按钮
-(void)searchBtnClick
{
//    searchViewCon = [[SearchViewController alloc]init];
//    [self.navigationController pushViewController:searchViewCon animated:YES];
    
    //停止播放
    [self.socketView  deliveryPlayExit];
    
    //密码校验
//    [self.socketView passwordCheck];
}





//************************************************
//table可以滑动的次数
- (NSInteger)columnNumber{
 //   return colors.count;
    return self.categorys.count;
}

- (TVTable *)slideView:(YLSlideView *)slideView
     cellForRowAtIndex:(NSUInteger)index{
    
    TVTable * cell = [slideView dequeueReusableCell];
    
    if (!cell) {
        cell = [[TVTable alloc]initWithFrame:CGRectMake(0, 0, 320, 500)
                                       style:UITableViewStylePlain];
        cell.delegate   = self;
        cell.dataSource = self;
    }
    
    //    cell.backgroundColor = colors[index];
    
   
    
    
//     NSLog(@"index --------:%@ ",@(index));
    return cell;
}
- (void)slideVisibleView:(TVTable *)cell forIndex:(NSUInteger)index{
    
    NSLog(@"index :%@ ",@(index));
    
    
    //self.categorys[i]                          不同类别
    //self.categoryModel.service_indexArr        类别的索引数组
    //self.categoryModel.service_indexArr.count
    //给不同的table赋值
//    for (int i = 0 ; i<self.categorys.count; i++) {
        NSDictionary *item = self.categorys[index];   //当前页面类别下的信息
    self.categoryModel = [[CategoryModel alloc]init];
    
    self.categoryModel.service_indexArr = item[@"service_index"];   //当前类别下包含的节目索引  0--9

        //获取EPG信息 展示
        //时间戳转换
        
              //获取不同类别下的节目，然后是节目下不同的cell值                10
                for (int i = 0 ; i<self.categoryModel.service_indexArr.count; i++) {
        
                    int indexCat ;
                 //   NSString * str;
                    indexCat =[self.categoryModel.service_indexArr[i] intValue];
                    //cell.tabledataDic = self.serviceData[indexCat -1];
                    
                    [self.dicTemp setObject:self.serviceData[indexCat -1] forKey:[NSString stringWithFormat:@"%d",i] ];     //将EPG字典放一起

                   
                }
//        cell.tabledataDic =  self.categorys[index];
//    }
    
//    self.a = index;
//    NSLog(@"index  self.a--------:%@ ",@(index));
    [cell reloadData]; //刷新TableView
    //    NSLog(@"刷新数据");
}

- (void)slideViewInitiatedComplete:(TVTable *)cell forIndex:(NSUInteger)index{
    
    //可以在这里做数据的预加载（缓存数据）
    NSLog(@"缓存数据 %@",@(index));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell reloadData];
        
    });
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)self.serviceData.count);
    
    return self.categoryModel.service_indexArr.count;

}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TVCell defaultCellHeight];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TVCell"];
    if (cell == nil){
        cell = [TVCell loadFromNib];
    }
    
  
    
//    
//    TVTable * table = [[TVTable alloc]init];
//    cell.dataDic = table.tabledataDic;

    
    cell.aa =  self.category_index;
    cell.aaa =self.categoryModel.service_indexArr.count;
//     NSLog(@"index  cell.aa--------:%d",cell.aa);
    
    cell.dataDic = [self.dicTemp objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    DetailViewController *controller =[[DetailViewController alloc] init];
    //    controller.dataDic = self.dataSource[indexPath.row];
    //    [self.navigationController pushViewController:controller animated:YES];
    
    //被选择时播放视频
    
    //此处销毁通知，防止一个通知被多次调用
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataService:) name:@"notice" object:nil];
    
    [self.socketView  serviceTouch ];
    
        
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    

}

- (void)getDataService:(NSNotification *)text{
    NSLog(@"%@",text.userInfo[@"playdata"]);
    NSLog(@"－－－－－接收到通知------");
    
    //NSData --->byte[]-------NSData----->NSString

    NSMutableData * byteDatas;
    byteDatas = [[NSMutableData alloc]init];

    //调用GGutil的方法
    byteDatas =  [GGUtil convertNSDataToByte:[USER_DEFAULT objectForKey:@"data_service"] bData:[USER_DEFAULT objectForKey:@"data_service11"]];
    
    NSLog(@"---urlData%@",byteDatas);
    self.video.playUrl = [@"h"stringByAppendingString:[[NSString alloc] initWithData:byteDatas encoding:NSUTF8StringEncoding]];
    [self playVideo];
    NSLog(@"---urlData%@",self.video.playUrl);
    
 
    NSString * str = [NSString stringWithFormat:@"%@",self.video.playUrl];

    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"data信息"message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertview show];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
