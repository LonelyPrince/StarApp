//
//  WLANSettingView.m
//  StarAPP
//
//  Created by xyz on 2017/10/19.
//

#import "WLANSettingView.h"

@interface WLANSettingView ()
{
    
    NSString * deviceString;     //用于判断手机型号
    NSString * DMSIP;
}
@end

@implementation WLANSettingView

@synthesize scrollView;
@synthesize WLANImageView;
@synthesize nameInputTextView;
@synthesize pswInputTextView;
@synthesize securityInputTextView;
@synthesize PINInputTextView;
@synthesize setNameText;
@synthesize setPswText;
@synthesize SecurityStatusLab;
@synthesize PINSwitch;
@synthesize isViewBtn;
@synthesize nameEidtImageView;
@synthesize pswEidtImageView;
@synthesize isOn;
@synthesize SecurityLab;
@synthesize PINLab;
@synthesize saveBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isOn = NO;
    deviceString = [GGUtil deviceVersion];
    
    [self initData];
    [self loadNav];
    [self loadScroll];
    [self loadUI];
}
-(void)viewWillAppear:(BOOL)animated
{
   
//    [self initData];
//    [self loadNav];
//    [self loadScroll];
//    [self loadUI];
//    [self getWifi];
}
-(void)loadNav
{
    self.title = @"WLAN Settings";
    self.tabBarController.tabBar.hidden = YES;
}
-(void)initData
{
    
    PINLab = [[UILabel alloc]init];
    SecurityLab = [[UILabel alloc]init];
    scrollView = [[UIScrollView alloc]init];
    WLANImageView = [[UIImageView alloc]init];
    nameInputTextView = [[UIView alloc]init];
    pswInputTextView = [[UIView alloc]init];
    securityInputTextView = [[UIView alloc]init];
    PINInputTextView = [[UIView alloc]init];
    
    setNameText = [[UITextField alloc]init];
    setPswText = [[UITextField alloc]init];
    SecurityStatusLab = [[UILabel alloc]init];
    PINSwitch = [[UISwitch alloc]init];
    isViewBtn = [[UIButton alloc]init];
    saveBtn = [[UIButton alloc]init];
    nameEidtImageView = [[UIImageView alloc]init];
    pswEidtImageView = [[UIImageView alloc]init];
}
-(void)loadUI
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [scrollView addGestureRecognizer:tapGesture];
    
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是4s的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+20 );
        
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-60 );
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-100 );
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-128 );
    }
    
    
    
  
}
-(void)loadScroll
{
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是4s的大小");
        
        
        //顶部图标
        WLANImageView.frame = CGRectMake(SCREEN_WIDTH/8*3, SCREEN_WIDTH/9, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
        WLANImageView.image = [UIImage imageNamed:@"顶部icon"];
        [scrollView addSubview:WLANImageView];
        
        nameInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH/5)/2, 2*SCREEN_WIDTH/5 , SCREEN_WIDTH/5*4, SCREEN_WIDTH/8)];
        nameInputTextView.layer.borderWidth = 1.0f;
        nameInputTextView.layer.cornerRadius = SCREEN_WIDTH/8/2;
        nameInputTextView.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
        
        setNameText.delegate = self;
        setNameText.autocorrectionType = UITextAutocorrectionTypeNo;
        setNameText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 280 - 50, 40)];
        setNameText.placeholder = @"";
        setNameText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
        
        //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
        //            inputText.image = [UIImage imageNamed:@"灰"];
        //            inputText.userInteractionEnabled = YES;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:setNameText];
        setNameText.secureTextEntry = YES;
        
        [scrollView addSubview:nameInputTextView];
        [nameInputTextView addSubview:setNameText];
        
        
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-60 );
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-100 );
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        //0 .顶部图标
        WLANImageView.frame = CGRectMake(SCREEN_WIDTH/3, SCREEN_WIDTH/10, SCREEN_WIDTH/3, SCREEN_WIDTH/3);
        WLANImageView.image = [UIImage imageNamed:@"顶部icon"];
        [scrollView addSubview:WLANImageView];
        
        
        //1.name输入
        nameInputTextView.frame = CGRectMake(SCREEN_WIDTH/9, 200 , SCREEN_WIDTH/5*4, SCREEN_WIDTH/10);
        nameInputTextView.layer.borderWidth = 1.0f;
        nameInputTextView.layer.cornerRadius = SCREEN_WIDTH/10/2;
        nameInputTextView.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
        [scrollView addSubview:nameInputTextView];
        
        nameEidtImageView.frame = CGRectMake(20, 10, 20, 20);
        nameEidtImageView.image = [UIImage imageNamed:@"SSID"];
        [nameInputTextView addSubview:nameEidtImageView];
        
        
        setNameText.delegate = self;
        setNameText.autocorrectionType = UITextAutocorrectionTypeNo;
        setNameText = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, 280 - 50, 40)];
        setNameText.placeholder = @"";
        setNameText.textColor = [UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:setNameText];
//        setNameText.secureTextEntry = YES;
        
        
        [nameInputTextView addSubview:setNameText];
        
        //2.密码输入
        pswInputTextView.frame = CGRectMake(SCREEN_WIDTH/9, 260 , SCREEN_WIDTH/5*4, SCREEN_WIDTH/10);
        pswInputTextView.layer.borderWidth = 1.0f;
        pswInputTextView.layer.cornerRadius = SCREEN_WIDTH/10/2;
        pswInputTextView.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
        [scrollView addSubview:pswInputTextView];
        
        pswEidtImageView.frame = CGRectMake(20, 10, 20, 20);
        pswEidtImageView.image = [UIImage imageNamed:@"密码"];
        [pswInputTextView addSubview:pswEidtImageView];
        
        
        isViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        isViewBtn.frame = CGRectMake(pswInputTextView.frame.size.width - 50, 13, 30, 20);
        //    [pswBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
//        [isViewBtn setImage:[UIImage imageNamed:@"密文"] forState:UIControlStateNormal];
        [isViewBtn setBackgroundImage:[UIImage imageNamed:@"密文"] forState:UIControlStateNormal];
        
        [isViewBtn addTarget:self action:@selector(pswBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [pswInputTextView addSubview:isViewBtn];
        

        
        setPswText.delegate = self;
        setPswText.autocorrectionType = UITextAutocorrectionTypeNo;
        setPswText = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, 280 - 50, 40)];
        setPswText.placeholder = @"";
        setPswText.textColor = [UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:setPswText];
        setPswText.secureTextEntry = YES;
        
        
        [pswInputTextView addSubview:setPswText];
        
        
        // 3. security Type
        securityInputTextView.frame = CGRectMake(SCREEN_WIDTH/9, 320 , SCREEN_WIDTH/5*4, SCREEN_WIDTH/10);
        securityInputTextView.layer.borderWidth = 1.0f;
        securityInputTextView.layer.cornerRadius = SCREEN_WIDTH/10/2;
        securityInputTextView.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
        [scrollView addSubview:securityInputTextView];
        
        SecurityStatusLab.frame = CGRectMake(securityInputTextView.frame.size.width - 50, 10, 50, 20);
        SecurityStatusLab.text = @"open";
        SecurityStatusLab.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
        [securityInputTextView addSubview:SecurityStatusLab];
        
        
        SecurityLab.frame = CGRectMake(30, 10, 200, 20);
        SecurityLab.text = @"Security Type";
        SecurityLab.textColor = [UIColor colorWithRed:0xcb/255.0 green:0xcb/255.0 blue:0xcb/255.0 alpha:1];
        [securityInputTextView addSubview:SecurityLab];
        
        
        // 4. PIN Protection
        PINInputTextView.frame = CGRectMake(SCREEN_WIDTH/9, 380 , SCREEN_WIDTH/5*4, SCREEN_WIDTH/10);
        PINInputTextView.layer.borderWidth = 1.0f;
        PINInputTextView.layer.cornerRadius = SCREEN_WIDTH/10/2;
        PINInputTextView.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
        [scrollView addSubview:PINInputTextView];
        
        PINSwitch.frame = CGRectMake(PINInputTextView.frame.size.width - 60, 5, 50, 20);
        
//        [PINSwitch setTintColor:HEXCOLOR(0x99999)];
        [PINSwitch setOnTintColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
        [PINSwitch setThumbTintColor:[UIColor whiteColor]];
        PINSwitch.layer.cornerRadius = 10.0f;
        PINSwitch.layer.masksToBounds = YES;
//        [PINSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
 
        [PINInputTextView addSubview:PINSwitch];
        
        
        PINLab.frame = CGRectMake(30, 10, 200, 20);
        PINLab.text = @"PIN Protection";
        PINLab.textColor = [UIColor colorWithRed:0xcb/255.0 green:0xcb/255.0 blue:0xcb/255.0 alpha:1];
        [PINInputTextView addSubview:PINLab];
        
        // 4. save BTN
        saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(SCREEN_WIDTH/9, 440 , SCREEN_WIDTH/5*4, SCREEN_WIDTH/10);
        [saveBtn setBackgroundColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
        saveBtn.layer.cornerRadius =SCREEN_WIDTH/20;
        
        [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:saveBtn];
        
        UILabel * saveLab = [[UILabel alloc]init];
        saveLab.text = @"SAVE";
        saveLab.textColor = [UIColor whiteColor];
        saveLab.frame = CGRectMake(140, 10, 80, 20);
        [saveBtn addSubview:saveLab];
        
        
    }
    
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
    [self.view addSubview:scrollView];
    
    
    scrollView.showsVerticalScrollIndicator=YES;
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.delegate=self;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor colorWithRed:0xf4/255.0 green:0xf5/255.0 blue:0xf9/255.0 alpha:1];
}
-(void)saveBtnClick
{
    NSLog(@"点击了保存按钮");
    
}
-(void)pswBtnClick
{
    if (isOn == YES) {
        isOn = NO;
        setPswText.secureTextEntry = YES;
        //        [pswBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
//        [isViewBtn setImage:[UIImage imageNamed:@"密文"] forState:UIControlStateNormal];
        [isViewBtn setBackgroundImage:[UIImage imageNamed:@"密文"] forState:UIControlStateNormal];
    }
    else if (isOn == NO)
    {
        isOn = YES;
        setPswText.secureTextEntry = NO;
        //        [pswBtn setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
//        [isViewBtn setImage:[UIImage imageNamed:@"明文显示"] forState:UIControlStateNormal];
        [isViewBtn setBackgroundImage:[UIImage imageNamed:@"明文显示"] forState:UIControlStateNormal];
    }
    
    NSLog(@"点击了眼睛按钮");
}
-(BOOL)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    
    
    //    NSUInteger lengthOfString = toBeString.length;  //lengthOfString的值始终为1
    //    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
    //        unichar character = [toBeString characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
    //        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}  ;  -  45  _95
    //        if (character < 45)
    //        {
    //
    //            textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
    //            return NO; // 48 unichar for 0..
    //        }
    //
    //        if (character > 45 && character < 48)
    //        {
    //
    //            textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
    //            return NO; // 48 unichar for 0..
    //        }
    //        if (character > 57 && character < 65)
    //        {
    //            textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
    //            return NO; //
    //        }
    //        if (character > 90 && character < 95)
    //        {
    //            textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
    //            return NO; //
    //        }
    //        if (character > 95 && character < 97)
    //        {
    //            textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
    //            return NO; //
    //        }
    //        if (character > 122)
    //        {
    //            textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
    //            return NO; //
    //        }
    //
    //
    //    }
    // Check for total length
    NSUInteger proposedNewLength = textField.text.length ;//- range.length + string.length;
    if (proposedNewLength > 16) {
        textField.text = [toBeString substringToIndex:16];
        return NO;//限制长度
    }
    return YES;
    
    
}
-(void)clickEvent
{
    
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.Animating = NO;
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    
    [super  viewDidDisappear:animated];
    self.Animating = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)scrollTap:(id)sender {
//    [self.view endEditing:YES];
//    [setPswText resignFirstResponder];
//    [setNameText resignFirstResponder];
//}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//    [setPswText resignFirstResponder];
//    [setNameText resignFirstResponder];
//}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
////    [super touchesBegan:toucheswithEvent:event];
//    [[self nextResponder] touchesEnded:touches withEvent:event];
//    [super touchesEnded:touches withEvent:event];
//    [setPswText resignFirstResponder];
//    [setNameText resignFirstResponder];
//}

-(void)onTap
{
    [setPswText resignFirstResponder];
    [setNameText resignFirstResponder];
}

//-(void)getWifi
//{
//    
//    //获取数据的链接
//    NSString * url =     [NSString stringWithFormat:@"http://%@/lua/settings/wifi",DMSIP];
//    //    NSString *url = [NSString stringWithFormat:@"%@",G_devicepwd];
//    
//    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
//    
//    [request startAsynchronous ];
//    
//    //    NSError *error = [request error ];
//    //    assert (!error);
//    // 如果请求成功，返回 Response
//    
//    
//    [request setCompletionBlock:^{
//        NSLog ( @"request:%@" ,request);
//        NSDictionary *onlineWifi = [request responseData].JSONValue;
//        NSLog ( @"onlineDeviceArr:%@" ,onlineWifi);
////        wifiDic = [[NSDictionary alloc]init];
////        wifiDic = onlineWifi;
////
////
////        routeNameLab.text = [wifiDic objectForKey:@"name"];
////
////        //        routeIPLab.text =  @"IP:192.168.1.1" ;//[wifiDic objectForKey:@"ip"];
////        routeIPLab.text = [NSString stringWithFormat:@"IP:%@",DMSIP];
//    }];
//    
//    
//    
//    
//}
//#pragma mark - 初始化创建不同的通知
//-(void)initNotific
//{
//    //////////////////////////// 从socket返回数据
//    //此处接收到路由器IP地址的消息
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getSocketIpInfoNotice" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSocketIpInfo:) name:@"getSocketIpInfoNotice" object:nil];
//    
//    //获取网络链接的通知
//    NSNotification *notification =[NSNotification notificationWithName:@"socketGetIPAddressNotific" object:nil userInfo:nil];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    
//    ///创建通知，用于判断网络是否正常
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"routeNetWorkError" object:nil];
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeNetWorkError) name:@"getSocketIpInfoNotice" object:nil];
//    
//}
//- (void)getSocketIpInfo:(NSNotification *)text{
//    
//    NSData * socketIPData = text.userInfo[@"socketIPAddress"];
//    NSData * ipStrData ;
//    NSLog(@"socketIPData :%@",socketIPData);
//    
//    if (socketIPData != NULL  && socketIPData != nil  &&  socketIPData.length > 0 ) {
//        
//        if (socketIPData.length >38) {
//            
//            if ([socketIPData length] >= 1 + 37 + socketIPData.length - 38) {
//                ipStrData = [socketIPData subdataWithRange:NSMakeRange(1 + 37,socketIPData.length - 38)];
//            }else
//            {
//                return;
//            }
//            
//            NSLog(@"ipStrData %@",ipStrData);
//            
//            DMSIP =  [[NSString alloc] initWithData:ipStrData  encoding:NSUTF8StringEncoding];
//            NSLog(@" DMSIP %@",DMSIP);
//            
//            //            [self loadNav];
//            [self viewWillAppear:YES];
//        }
//        
//    }
//    
//    
//}
////-(void)getCurrentWifi
////{
////
////    //获取数据的链接
////    NSString * url =     [NSString stringWithFormat:@"http://%@/lua/settings/getLoginPasswd",DMSIP];
////    //    NSString *url = [NSString stringWithFormat:@"%@",G_devicepwd];
////
////    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
////
////    [request startAsynchronous ];
////
////    //    NSError *error = [request error ];
////    //    assert (!error);
////    // 如果请求成功，返回 Response
////
////
////    [request setCompletionBlock:^{
////        NSLog ( @"request:%@" ,request);
////        NSDictionary *pwdDic = [request responseData].JSONValue;
////        NSLog ( @"onlineDeviceArr:%@" ,pwdDic);
////
////        NSString * pwdStr =[pwdDic objectForKey:@"pwd"];
////
////        if ([pwdStr isEqualToString:@"MGadmin"] || [pwdStr isEqualToString:@""] || pwdStr == NULL) {
////            NSLog(@"需要展示修改密码的界面");
////            [self showPwdRegistrView];
////
////        }else
////        {
////            NSLog(@"用户输入PIN 进入");
////            [self showLoginView];
////            //            [self showPwdRegistrView];
////        }
////        //        wifiDic = [[NSDictionary alloc]init];
////        //        wifiDic = onlineWifi;
////        //
////        //
////        //        routeNameLab.text = [wifiDic objectForKey:@"name"];
////        //
////        //        //        routeIPLab.text =  @"IP:192.168.1.1" ;//[wifiDic objectForKey:@"ip"];
////        //        routeIPLab.text = [NSString stringWithFormat:@"IP:%@",DMSIP];
////    }];
////
////
////
////
////}
@end
