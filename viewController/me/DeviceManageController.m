//
//  DeviceManageController.m
//  StarAPP
//
//  Created by xyz on 2016/11/9.
//
//

#import "DeviceManageController.h"
#import "DeviceManageCell.h"
@interface DeviceManageController ()


@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation DeviceManageController
@synthesize avController;
@synthesize cgUpnpModel;
@synthesize scrollView;
@synthesize avCtrl;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Device management";
    
    [super viewDidLoad];
    
    self.dataSource = [NSArray array];
    avCtrl = [[CGUpnpAvController alloc] init];    ///进行搜索的对象
    avCtrl.delegate = self;
    
    [self loadNav];
    [self loadScroll];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(viewWillAppear:) userInfo:nil repeats:YES];
    NSLog(@"Device viewDidLoad");
    
    [self linkSocket];
}


//-(void)getCGData
//{
//    //如果有数据则直接展示
//    NSArray * DmsArr = [USER_DEFAULT objectForKey:@"DmsDevice"];
//    if (DmsArr) {
//        self.dataSource = DmsArr;
//    }
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        // 处理耗时操作的代码块...
//        //搜索
//
//        [avCtrl search];
//        self.avController = avCtrl;
//        //通知主线程刷新
//        NSLog(@"Device dispatch1");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //回调或者说是通知主线程刷新，
////            [self loadScroll];
//
////            [self loadUI];
//            [self viewWillAppear:YES];
//            NSLog(@"Device dispatch2");
//        });
//
//    });
//}

-(void)linkSocket
{
    
    self.socketView  = [[SocketView  alloc]init];
    [self.socketView viewDidLoad];
    
//    self.videoController.socketView1 = self.socketView;
//    [self.socketView  serviceTouch ];
}
-(void)loadNav
{
    
    self.navigationController.navigationBarHidden = NO;
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    //    [self getCGData];    //此处是获取数据
    [self loadUI];
    NSLog(@"Device ViewWillApper");
}


//- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceUpdated:(NSString *)deviceUdn {
//    NSLog(@"%@", deviceUdn);
//    self.avController = (CGUpnpAvController*)controlPoint;
//
//    //此处可能产生僵尸对象
//    self.dataSource =  [((CGUpnpAvController*)controlPoint) servers];
//
//    //    int dmsNum = 0;
//
//
////    [self loadUI];
//    [self viewWillAppear:YES];
//
//    NSLog(@"Device delegate");
//}

-(void) loadUI{
    
    self.dataSource = [USER_DEFAULT objectForKey:@"DmsDevice"];
    @synchronized (self.dataSource) {
        NSLog(@"datasource :%@",self.dataSource);
        for (int i = 0 ; i<self.dataSource.count; i++) {
            UIView * CGDeviceView = [[UIView alloc]initWithFrame:CGRectMake(20, 20 + 50* i , SCREEN_WIDTH - 40, 45)];
            CGDeviceView.layer.cornerRadius = 5.0;
            CGDeviceView.tag = i;
            CGDeviceView.backgroundColor = RGBA(0x60, 0xa3, 0xec, 1);
            
            [scrollView addSubview:CGDeviceView];
            [scrollView bringSubviewToFront:CGDeviceView];
            
            
            UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 200, 14)];
            nameLab.font = FONT(13);
            nameLab.textColor = [UIColor whiteColor];
            nameLab.text = [self.dataSource[i] objectForKey:@"dmsID"];
            [CGDeviceView addSubview:nameLab];
            
            
            
            
            //设置绿色切换按钮
            UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [changeBtn setFrame:CGRectMake(CGDeviceView.bounds.size.width -30,15 , 18, 18)];
            [changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [changeBtn setBackgroundImage:[UIImage imageNamed:@"nor"] forState:UIControlStateNormal];
            
            [CGDeviceView addSubview:changeBtn];
        }
    }
    
    
    
    
}
-(void)loadScroll
{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    [self.view addSubview:scrollView];
    
    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, 20+self.dataSource.count*50+115);
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.delegate=self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)changeBtnClick
{
    NSLog(@"点击了,进行切换");
}

@end
