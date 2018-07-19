//
//  BackupRestoreView.m
//  StarAPP
//
//  Created by xyz on 2017/10/31.
//

#import "BackupRestoreView.h"
#import "MEViewController.h"
#define NOBackUP  @"No Backup information!"
#define NOBackUPAlert  @"No backup can be restored"
#define RestoreAlert  @"You will be to restore the backup"
#define BackUPAlert  @"You will be to make a backup"
#define BackUPTip  @"You can back up your settings now or restore the settings you backed up last time."


@interface BackupRestoreView ()<UIAlertViewDelegate>
{
    UIAlertView * backupAlert;
    UIAlertView * restoreAlert;
    NSDictionary * deviceDic;
    MBProgressHUD * HUD;
    MBProgressHUD * successHUD;
    MBProgressHUD * NoBackupHUD;
    UIView *  netWorkErrorView;
    
    NSString * DMSIP;
    NSString * hudType;
}
@property(nonatomic,strong)MEViewController * meViewController;
@end

@implementation BackupRestoreView

@synthesize wifiDic;

@synthesize BackupStatusString;
@synthesize imageView;
@synthesize backUPLab;
@synthesize backUPInfoLab;
@synthesize grayView;
@synthesize restoreBtn;
@synthesize backUpBtn;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNav];
    [self initData];
}
-(void)loadNav
{
    NSString * BackupRestoreLabel = NSLocalizedString(@"BackupRestoreLabel", nil);
    self.title = BackupRestoreLabel;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)initData
{
    NSString * CancelLabel = NSLocalizedString(@"CancelLabel", nil);
    NSString * MLRestoringBackupParameters = NSLocalizedString(@"MLRestoringBackupParameters", nil);
    NSString * MLBackingUp = NSLocalizedString(@"MLBackingUp", nil);
    
    imageView = [[UIImageView alloc]init];
    backUPLab = [[UILabel alloc]init];
    backUPInfoLab = [[UILabel alloc]init];
    grayView = [[UIView alloc]init];
    restoreBtn = [[UIButton alloc]init];
    backUpBtn = [[UIButton alloc]init];
    backupAlert = [[UIAlertView alloc]initWithTitle:nil message:MLBackingUp delegate:self cancelButtonTitle:@"OK" otherButtonTitles:CancelLabel, nil];
    restoreAlert = [[UIAlertView alloc]initWithTitle:nil message:MLRestoringBackupParameters delegate:self cancelButtonTitle:@"OK" otherButtonTitles:CancelLabel, nil];
    
    self.meViewController = [[MEViewController alloc]init];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"routeNetWorkError" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetWorkErrorView) name:@"routeNetWorkError" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    DMSIP = [USER_DEFAULT objectForKey:@"RouterPsw"];
    
    if (DMSIP != nil && DMSIP != NULL && DMSIP.length > 0) {
        //        [self getOnlineDevice];
        [self getBackupInfo];
//        [self getWifi];
    }
    [self showView];
    
}
-(void)getBackupInfo
{
    
    //获取数据的链接
    NSString * url =     [NSString stringWithFormat:@"http://%@/lua/backup",DMSIP];
    //    NSString *url = [NSString stringWithFormat:@"%@",G_device];
    //    NSString *url = [NSString stringWithFormat:@"%@",G_device];
    
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
    [request setNumberOfTimesToRetryOnTimeout:5];
    [request startAsynchronous ];
    
    
    [request setStartedBlock:^{
        //请求开始的时候调用
        //用转圈代替
        
        
        HUD.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        //如果设置此属性则当前的view置于后台
        
        [HUD showAnimated:YES];
        
        
        //设置对话框文字
        
        HUD.labelText = @"loading";
        //        NSLog(@"scroller : %@",scrollView);
        NSLog(@"HUD : %@",HUD);
        [self.view addSubview:HUD];
        
        
        NSLog(@"请求开始的时候调用");
    }];
    
    
    
    [request setCompletionBlock:^{
        
        NSArray *onlineDeviceDic = [request responseData].JSONValue;
        deviceDic = onlineDeviceDic;
        NSLog(@"deviceDic :%@",deviceDic);
        if (deviceDic.count == 0|| deviceDic ==NULL ) {
            
            NSLog(@"请求失败的时候调用");
            
            [HUD removeFromSuperview];
            HUD = nil;
            
            netWorkErrorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            UIImageView * hudImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 616/2)/2, 120, 616/2, 348/2)];
            hudImage.image = [UIImage imageNamed:@"网络无连接"];
            
            NSString * MLNetworkError = NSLocalizedString(@"MLNetworkError", nil);
            CGSize size = [GGUtil sizeWithText:MLNetworkError font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            UILabel * hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
            hudLab.text = MLNetworkError;
            hudLab.font = FONT(15);
            hudLab.textColor = [UIColor grayColor];
            
            //        [scrollView addSubview:netWorkErrorView];
            //            [scrollView addSubview:netWorkErrorView];
            [self.view addSubview:netWorkErrorView];
            [netWorkErrorView addSubview:hudImage];
            [netWorkErrorView addSubview:hudLab];
            
        }else
        {
            [HUD removeFromSuperview];
            HUD = nil;
            [netWorkErrorView removeFromSuperview];
            netWorkErrorView = nil;
            
            NSError *error = [request error ];
            assert (!error);
            // 如果请求成功，返回 Response
            NSLog ( @"request:%@" ,request);
            //            NSMutableArray * arrOnline = [[NSMutableArray alloc]init];
            //            NSArray * allDeviceArr = [request responseData].JSONValue;
            //            for (int i = 0 ; i<allDeviceArr.count ; i++) {
            //                NSLog(@"abcd %@",[allDeviceArr[i] objectForKey:@"online_flag"]);
            //                if ([[allDeviceArr[i] objectForKey:@"online_flag"] intValue]== 2) { //online_flag 为2代表在线
            //
            //                    [arrOnline addObject:allDeviceArr[i]];
            //                }
            //            }
            
            
            
            
            //        NSArray *onlineDeviceArr = [request responseData].JSONValue;
            //        deviceArr = onlineDeviceArr;
            //            deviceArr = [arrOnline copy];
            //            //        NSLog ( @"onlineDeviceArr:%@" ,onlineDeviceArr);
            //            NSLog ( @"deviceArr:%@" ,deviceArr);
            
            //            [self loadNav];
            //            [self loadScroll];
            //            [self loadUI];
            //            [self getWifi];
            //            [self loadTableView];
            BackupStatusString = @"";
            if ([deviceDic objectForKey:@"backup"] != NULL || [deviceDic objectForKey:@"backup"] != nil) {
                if (![[deviceDic objectForKey:@"backup"] isEqualToString:@"no backup data"] ) {
                    backUPLab.text = [deviceDic objectForKey:@"backup"];
                }else
                {
                    
                    NSString * MLNOBackupRestored = NSLocalizedString(@"MLNOBackupRestored", nil);
                    backUPLab.text = MLNOBackupRestored;
                }
                BackupStatusString = backUPLab.text;
                
            }
//            HardwareVersionLab.text = [deviceDic objectForKey:@"hardVersion"];
//            SortwareVersionLab.text = [deviceDic objectForKey:@"softVersion"];
//            SerialNumberLab.text = [deviceDic objectForKey:@"SNnum"];
//            BuildDataLab.text = [deviceDic objectForKey:@"releaseVersion"];
            
        }
    }];
    
    
    
    
    
    
    
}

-(void)showView
{
    imageView.frame =CGRectMake(20, 19+64, 55/2, 48/2);
    imageView.image = [UIImage imageNamed:@"备份还原"];
    [self.view addSubview:imageView];
    
    backUPLab.frame =CGRectMake(20 + 15 +48/2, 19+64, SCREEN_WIDTH - 20-15-55/2, 48/2);
    backUPLab.font = FONT(16);
    [self.view addSubview:backUPLab];
    
    grayView.frame =CGRectMake(20, imageView.frame.origin.y + 48/2 + 19 , SCREEN_WIDTH - 40, 1);
    grayView.backgroundColor = [UIColor colorWithRed:0x87/255.0 green:0x87/255.0 blue:0x87/255.0 alpha:0.5];
    [self.view addSubview:grayView];
    
    backUPInfoLab.frame =CGRectMake(20 , grayView.frame.origin.y + 15, SCREEN_WIDTH - 40, 60);
    backUPInfoLab.font = FONT(15);
    backUPInfoLab.numberOfLines = 0;
    NSString * MLbackupRestore = NSLocalizedString(@"MLbackupRestore", nil);
    backUPInfoLab.text = MLbackupRestore;
    backUPInfoLab.textColor = [UIColor colorWithRed:0x87/255.0 green:0x87/255.0 blue:0x87/255.0 alpha:0.8];
    [self.view addSubview:backUPInfoLab];
    
    
    
    
    restoreBtn.frame =CGRectMake(40, SCREEN_HEIGHT - 200+64, SCREEN_WIDTH - 40 *2 , 43);
    restoreBtn.backgroundColor =[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1];
    restoreBtn.layer.cornerRadius = 43/2;
    NSString * MLRestore = NSLocalizedString(@"MLRestore", nil);
    [restoreBtn setTitle:MLRestore forState:UIControlStateNormal];
    restoreBtn.titleLabel.textColor = [UIColor whiteColor];
    [restoreBtn addTarget:self action:@selector(restoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: restoreBtn];
    
    backUpBtn.frame =CGRectMake(40, restoreBtn.frame.origin.y + 43+15 , SCREEN_WIDTH - 40 *2, 43);
    backUpBtn.backgroundColor =[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1];
    backUpBtn.layer.cornerRadius = 43/2;
    [backUpBtn setTitle:@"Backup" forState:UIControlStateNormal];
    backUpBtn.titleLabel.textColor = [UIColor whiteColor];
    [backUpBtn addTarget:self action:@selector(backUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: backUpBtn];
    
    
    
  
    
}
-(void)restoreBtnClick
{
    if (![BackupStatusString isEqualToString:@""] && ![BackupStatusString isEqualToString:NOBackUP]) {
        //弹窗提示
        
        restoreAlert.delegate = self;
        [restoreAlert show];
        
        
    }else
    {
        NSString * ConfirmLabel = NSLocalizedString(@"ConfirmLabel", nil);
        NSString * MLNOBackupRestored = NSLocalizedString(@"MLNOBackupRestored", nil);
        UIAlertView * noBackUPAlert = [[UIAlertView alloc]initWithTitle:nil message:MLNOBackupRestored delegate:self cancelButtonTitle:nil otherButtonTitles:ConfirmLabel, nil];
        
        
        [noBackUPAlert show];
        
    }
}
-(void)backUpBtnClick
{
 
    backupAlert.delegate = self;
    [backupAlert show];
        
   
}

#pragma mark - 弹窗点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    textField_Encrypt.delegate = self;
    //    textField_Encrypt.autocorrectionType = UITextAutocorrectionTypeNo;
    //    textField_Encrypt = [alertView textFieldAtIndex:0];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
    //                                                name:@"UITextFieldTextDidChangeNotification"
    //                                              object:textField_Encrypt];
    
    
    
    if ([alertView  isEqual: backupAlert]) {
        
        if(buttonIndex == 1)
        {
//            NSLog(@"charact  STB  验证");
//            NSLog(@"没有进行STB密码验证，所以不能播放");
//            //取消了
//            //1.先取消进度圈  2.弹出页面   3.将decoder PIN 的文字改成@"Please input your Decoder PIN";
//
//            NSNotification *notification =[NSNotification notificationWithName:@"configDecoderPINShowNotific" object:nil userInfo:nil];
//            //通过通知中心发送通知
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//
//            [self performSelector:@selector(changeSTBAlertTitle) withObject:nil afterDelay:0.3];//将decoder PIN 的文字改成@"Please input your Decoder PIN"
            
        }else{
//            NSLog(@"charact  STB  验证");
//            NSLog(@"character2txt  字符 ：%@",STBTextField_Encrypt.text);
//            if (STBTextField_Encrypt.text.length < 1) {
//                STBAlert.dontDisppear = YES;
//
//            }else
//            {
//                if (STBTextField_Encrypt.text.length <6) {
//
//                    [self performSelector:@selector(popSTBAlertViewFaild) withObject:nil afterDelay:0.8];
//                    //                [self popSTBAlertViewAgain];
//                }else
//                {
//                    [self.socketView passwordCheck:STBTextField_Encrypt.text passwordType:1];  //密码六位
//                }
//
//            }
//
            //验证
            [self sendServiceTobackUP];
            
            
        }
    }
    else if([alertView  isEqual: restoreAlert])
    {
        
        if(buttonIndex == 1)
        {
            
        }else{
        
            [self postRestoreService];
            
            
        }
    }
    
//    {
//        if(buttonIndex == 1)
//        {
//            //            //取消了
//            //            NSLog(@"charact  CA 验证");
//            //            NSLog(@"没有进行CA密码验证，所以不能播放");
//            NSLog(@"charact  CA 验证");
//            NSLog(@"没有进行CA密码验证，所以不能播放");
//            //取消了
//            //1.先取消进度圈  2.弹出页面   3.将decoder PIN 的文字改成@"Please input your Decoder PIN";
//
//            NSNotification *notification =[NSNotification notificationWithName:@"configCAPINShowNotific" object:nil userInfo:nil];
//            //通过通知中心发送通知
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//
//            [self performSelector:@selector(changeCAAlertTitle) withObject:nil afterDelay:0.3];//将CA PIN 的文字改成@"Please input your CA PIN"
//
//        }else{
//
//
//            NSLog(@"charact  CA 验证");
//            NSLog(@"character2txt  字符 ：%@",CATextField_Encrypt.text);
//            if (CATextField_Encrypt.text.length <1) {
//                CAAlert.dontDisppear = YES;
//            }else
//            {
//
//                if (CATextField_Encrypt.text.length <4) {
//
//                    [self performSelector:@selector(popCAAlertViewFaild) withObject:nil afterDelay:0.8];
//                    //                [self popSTBAlertViewAgain];
//                }else
//                {
//                    [self.socketView passwordCheck:CATextField_Encrypt.text passwordType:0]; //密码四位
//                }
//
//            }
//        }
//    }
    
    
    
}
-(void)sendServiceTobackUP
{
   

        NSString * serviceIp;
        if (DMSIP != NULL ) {
            serviceIp = [NSString stringWithFormat:@"http://%@/lua/backup",DMSIP];
        }else
        {
            //        serviceIp =@"http://192.168.1.55/cgi-bin/cgi_channel_list.cgi?";   //服务器地址
        }
        //获取数据的链接
        NSString *linkUrl = [NSString stringWithFormat:@"%@",serviceIp];
        //    SString *linkUrl = [NSString stringWithFormat:@"%@",P_devicepwd];
        
        NSURL *url = [NSURL URLWithString:linkUrl];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request setRequestMethod:@"POST"];
        //     NSString *parameterString = [NSString stringWithFormat:@"name=%@&password=%@",name,psw];
        //    NSData *data = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
        
//        NSDictionary *  detailDic =[NSDictionary dictionaryWithObjectsAndKeys:@"MGadmin",@"old_pwd",confirmText.text,@"new_pwd",nil];//创建多个键 多个值
//        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:detailDic options:0 error:nil];
//        //    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//
//        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
//
        [request setPostBody:NULL];
    //        [request startSynchronous];
    [request startAsynchronous];
    [request setCompletionBlock:^{
        NSError *error1 = [request error];
        if (!error1) {
            //        NSString *response = [request responseString];
            //        NSLog(@"Test：%@",response);
            //        [USER_DEFAULT setObject:nameText.text forKey:@"routeNameUSER"];
            //            NSString *response = [request responseString];
            
            NSData *data = [request responseData];
            if ([data isEqual:NULL] || data == nil ) {
                return;
            }
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"resDict %@",resDict);
            NSLog(@"[resDict objectForKey:] %@",[resDict objectForKey:@"code"]);
            if ([[resDict objectForKey:@"code"] isEqual:@1]) {//失败
                
                NSLog(@"备份失败");
                NSLog(@"code code 1");
                hudType = @"backup";
                [self showFailHUD];
                
                
            }
            else if ([[resDict objectForKey:@"code"] isEqual:@0]) //成功
            {
                
                
                
                
                UIView *  activeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                                     SCREEN_WIDTH,
                                                                     SCREEN_HEIGHT)];
                [self.view addSubview:activeView];    //等待loading的view
                MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:activeView];
                
                //如果设置此属性则当前的view置于后台
                
                [HUD showAnimated:YES];
                //设置对话框文字
                
                HUD.labelText = @"loading";
                activeView.backgroundColor = [UIColor clearColor];
                [activeView addSubview:HUD];
                
                
                
                
                
                
                
                
                double delayInSeconds = 6;
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, mainQueue, ^{
                    NSLog(@"备份成功");
                    NSLog(@"code code 0");
                    hudType = @"backup";
                    
                    [activeView removeFromSuperview];
                    
                    [self showSuccessHUD];
                   [self updateBackupInfo];
                });
                
            }
            
            
            
            
        }
    }];

   
    
    
}
- (void)showSuccessHUD {
    
    successHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:successHUD];
    
//    successHUD.labelText = @"Backup Success";
    if ([hudType isEqualToString: @"backup"]) {
         NSString * MLBackupsuccess = NSLocalizedString(@"MLBackupsuccess", nil);
        successHUD.labelText = MLBackupsuccess;
    }else if ([hudType isEqualToString: @"restore"])
    {
        NSString * MLRestoresuccess = NSLocalizedString(@"MLRestoresuccess", nil);
        successHUD.labelText = MLRestoresuccess;
    }else
    {
        successHUD.labelText = @"Success";
    }
    
    successHUD.mode = MBProgressHUDModeCustomView;
    
//    successHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
    
    [successHUD showAnimated:YES whileExecutingBlock:^{
    
        NSLog(@"waitwaitwaitwaitwaitwait");
        sleep(2);
        
    } completionBlock:^{
        
        [successHUD removeFromSuperview];
        successHUD = nil;
        
    }];
    
}
-(void)showNoBackupHUD
{
    
    NoBackupHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:NoBackupHUD];
    
//    if ([hudType isEqualToString: @"backup"]) {
//        NSString * MLBackupFailure = NSLocalizedString(@"MLBackupFailure", nil);
//        successHUD.labelText = MLBackupFailure;
//    }else if ([hudType isEqualToString: @"restore"])
//    {
//        NSString * MLRestoreFailure = NSLocalizedString(@"MLRestoreFailure", nil);
//        successHUD.labelText = MLRestoreFailure;
//    }else
//    {
//        successHUD.labelText = @"Failed";
//    }
    
    NSString * MLNOBackupRestored = NSLocalizedString(@"MLNOBackupRestored", nil);
    NoBackupHUD.labelText = MLNOBackupRestored;
    
    NoBackupHUD.mode = MBProgressHUDModeCustomView;
    
    //    successHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
    
    [NoBackupHUD showAnimated:YES whileExecutingBlock:^{
        
        NSLog(@"waitwaitwaitwaitwaitwait");
        sleep(2);
        
    } completionBlock:^{
        
        [NoBackupHUD removeFromSuperview];
        NoBackupHUD = nil;
        
    }];
    
}
-(void)showFailHUD
{
    
    successHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:successHUD];
    
    if ([hudType isEqualToString: @"backup"]) {
        NSString * MLBackupFailure = NSLocalizedString(@"MLBackupFailure", nil);
        successHUD.labelText = MLBackupFailure;
    }else if ([hudType isEqualToString: @"restore"])
    {
        NSString * MLRestoreFailure = NSLocalizedString(@"MLRestoreFailure", nil);
        successHUD.labelText = MLRestoreFailure;
    }else
    {
        successHUD.labelText = @"Failed";
    }
    
    
    successHUD.mode = MBProgressHUDModeCustomView;
    
    //    successHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]] autorelease];
    
    [successHUD showAnimated:YES whileExecutingBlock:^{
        
        NSLog(@"waitwaitwaitwaitwaitwait");
        sleep(2);
        
    } completionBlock:^{
        
        [successHUD removeFromSuperview];
        successHUD = nil;
        
    }];
    
}
//restore
-(void)postRestoreService
{
    
    
    NSString * serviceIp;
    if (DMSIP != NULL ) {
        serviceIp = [NSString stringWithFormat:@"http://%@/lua/recover",DMSIP];
    }else
    {
        //        serviceIp =@"http://192.168.1.55/cgi-bin/cgi_channel_list.cgi?";   //服务器地址
    }
    //获取数据的链接
    NSString *linkUrl = [NSString stringWithFormat:@"%@",serviceIp];
    //    SString *linkUrl = [NSString stringWithFormat:@"%@",P_devicepwd];
    
    NSURL *url = [NSURL URLWithString:linkUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
   
    [request setPostBody:NULL];
    //        [request startSynchronous];
    [request startAsynchronous];
    [request setCompletionBlock:^{
        NSError *error1 = [request error];
        if (!error1) {
            //        NSString *response = [request responseString];
            //        NSLog(@"Test：%@",response);
            //        [USER_DEFAULT setObject:nameText.text forKey:@"routeNameUSER"];
            //            NSString *response = [request responseString];
            
            NSData *data = [request responseData];
            if ([data isEqual:NULL] || data == nil ) {
                return;
            }
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"resDict %@",resDict);
            NSLog(@"[resDict objectForKey:] %@",[resDict objectForKey:@"code"]);
            if ([[resDict objectForKey:@"code"] isEqual:@1]) {//失败
                
                NSString * MLNOBackupRestored = NSLocalizedString(@"MLNOBackupRestored", nil);
                if ([backUPLab.text isEqualToString:MLNOBackupRestored]) {
                    NSLog(@"没有备份信息，无法还原");
                    NSLog(@"code code 0");
                    [self showNoBackupHUD];
                }else
                {
                    NSLog(@"备份失败");
                    NSLog(@"code code 1");
                    hudType = @"restore";
                    [self showFailHUD];
                }
                
            }
            else if ([[resDict objectForKey:@"code"] isEqual:@0]) //成功
            {
                NSString * MLNOBackupRestored = NSLocalizedString(@"MLNOBackupRestored", nil);
                if ([backUPLab.text isEqualToString:MLNOBackupRestored]) {
                    NSLog(@"没有备份信息，无法还原");
                    NSLog(@"code code 0");
                    [self showNoBackupHUD];
                }else
                {
                    
                    NSLog(@"备份成功");
                    NSLog(@"code code 0");
                    hudType = @"restore";
                    [self showSuccessHUD];
                    
                    //                [self updateBackupInfo];
                }
                
                
            }
            else if ([[resDict objectForKey:@"code"] isEqual:@10]) //成功
            {
                
                NSString * MLNOBackupRestored = NSLocalizedString(@"MLNOBackupRestored", nil);
                if ([backUPLab.text isEqualToString:MLNOBackupRestored]) {
                    NSLog(@"没有备份信息，无法还原");
                    NSLog(@"code code 0");
                    [self showNoBackupHUD];
                }else
                {
                    
                    NSLog(@"备份busy  ,请等一会");
                    NSLog(@"code code 1");
                    hudType = @"restore";
                    [self showFailHUD];
                }
            }
            
            
            
            
        }
    }];
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 加载无网络图
-(void)showNetWorkErrorView
{
    NSLog(@"showNetWorkErroshowNetWorkErrorVasdadsads");
    //1.取消掉加载圈
    //    [self hudHidden];
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self.timerForASIHttp invalidate];
    //        self.timerForASIHttp = nil;
    //
    //    });
    
    if (self.NetWorkErrorView == nil) {
        self.NetWorkErrorView = [[UIView alloc]init];
    }
    if (self.NetWorkErrorImageView == nil) {
        self.NetWorkErrorImageView = [[UIImageView alloc]init];
    }
    if (self.NetWorkErrorLab == nil) {
        self.NetWorkErrorLab = [[UILabel alloc]init];
    }
    self.NetWorkErrorView.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.NetWorkErrorView.backgroundColor = [UIColor whiteColor];
    
    
    self.NetWorkErrorImageView.frame =CGRectMake((SCREEN_WIDTH - 139*0.5)/2, (SCREEN_HEIGHT - 90)/2, 139*0.5, 110*0.5);
    self.NetWorkErrorImageView.image = [UIImage imageNamed:@"路由无网络"];
    
    
    self.NetWorkErrorLab.frame = CGRectMake((SCREEN_WIDTH - 90)/2, self.NetWorkErrorImageView.frame.origin.y+60, 150, 50);
    NSString * MLNetworkError = NSLocalizedString(@"MLNetworkError", nil);
    self.NetWorkErrorLab.text = MLNetworkError;
    self.NetWorkErrorLab.font = FONT(15);
    
    
    
    
    
    [self.view addSubview:self.NetWorkErrorView];
    [self.NetWorkErrorView addSubview:self.NetWorkErrorImageView];
    [self.NetWorkErrorView addSubview:self.NetWorkErrorLab];
    
    
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
    
    
    self.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
    self.navigationItem.leftBarButtonItem = myButton;
}

-(void)clickEvent
{
    
    NSLog(@"self.navigationController %@",self.navigationController.viewControllers);
    
    //遍历看是否有MEViewcontroller这个页面
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[self.meViewController class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }
    
    
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)updateBackupInfo
{
    
    //获取数据的链接
    NSString * url =     [NSString stringWithFormat:@"http://%@/lua/backup",DMSIP];
    //    NSString *url = [NSString stringWithFormat:@"%@",G_device];
    //    NSString *url = [NSString stringWithFormat:@"%@",G_device];
    
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
    [request setNumberOfTimesToRetryOnTimeout:5];
    [request startAsynchronous ];
    
    
    [request setStartedBlock:^{
        //请求开始的时候调用
        //用转圈代替
        
        
        HUD.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        //如果设置此属性则当前的view置于后台
        
        [HUD showAnimated:YES];
        
        
        //设置对话框文字
        
        HUD.labelText = @"loading";
        //        NSLog(@"scroller : %@",scrollView);
        NSLog(@"HUD : %@",HUD);
        [self.view addSubview:HUD];
        
        
        NSLog(@"请求开始的时候调用");
    }];
    
    
    
    [request setCompletionBlock:^{
        
        NSArray *onlineDeviceDic = [request responseData].JSONValue;
        deviceDic = onlineDeviceDic;
        NSLog(@"deviceDic :%@",deviceDic);
        if (deviceDic.count == 0|| deviceDic ==NULL ) {
            
            NSLog(@"请求失败的时候调用");
            
            [HUD removeFromSuperview];
            HUD = nil;
            
            netWorkErrorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            UIImageView * hudImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 616/2)/2, 120, 616/2, 348/2)];
            hudImage.image = [UIImage imageNamed:@"网络无连接"];
            NSString * MLNetworkError = NSLocalizedString(@"MLNetworkError", nil);
            CGSize size = [GGUtil sizeWithText:MLNetworkError font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            UILabel * hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
            hudLab.text = MLNetworkError;
            hudLab.font = FONT(15);
            hudLab.textColor = [UIColor grayColor];
           
            [self.view addSubview:netWorkErrorView];
            [netWorkErrorView addSubview:hudImage];
            [netWorkErrorView addSubview:hudLab];
            
        }else
        {
            [HUD removeFromSuperview];
            HUD = nil;
            [netWorkErrorView removeFromSuperview];
            netWorkErrorView = nil;
            
            NSError *error = [request error ];
            assert (!error);
            // 如果请求成功，返回 Response
            NSLog ( @"request:%@" ,request);
            
            BackupStatusString = @"";
            if ([deviceDic objectForKey:@"backup"] != NULL || [deviceDic objectForKey:@"backup"] != nil) {
                if (![[deviceDic objectForKey:@"backup"] isEqualToString:@"no backup data"] ) {
                    backUPLab.text = [deviceDic objectForKey:@"backup"];
                }else
                {
                    NSString * MLNOBackupRestored = NSLocalizedString(@"MLNOBackupRestored", nil);
                    backUPLab.text = MLNOBackupRestored;
                }
                BackupStatusString = backUPLab.text;
                NSLog(@"ksksksksksk === %@",BackupStatusString);
            }
            
            
        }
    }];

    
}
@end
