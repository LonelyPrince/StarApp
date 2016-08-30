//
//  TVViewController.m
//  starApp
//
//  Created by xyz on 16/8/1.
//  Copyright © 2016年 xyz. All rights reserved.
//

#import "TVViewController.h"





@interface TVViewController ()
@property (nonatomic, strong) ZXVideoPlayerController *videoController;
@property(nonatomic,strong)SearchViewController * searchViewCon;
@end

@implementation TVViewController

@synthesize searchViewCon;
//@synthesize videoPlay;
- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    [self loadNav];
//    self.view.frame.origin.y = CGRectGetMaxY(44)
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
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, topViewHeight)];
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
        };
        
        [self.videoController showInView:self.view];
    }
    

    
    self.videoController.video = self.video;
    NSLog(@"video:%@",self.videoController.video);
}

-(void)searchBtnClick
{
    searchViewCon = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchViewCon animated:YES];
}

@end
