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
@property(nonatomic,strong)UIAlertView * alertView;  //对于密码的判断框
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
@synthesize alertView;

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
    [self addWlanInfo];
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
//    alertView = [[UIAlertView alloc]init];
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
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-120 );
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-128 );
    }
    
//    [self addWlanInfo];
    
  
}
-(void)addWlanInfo
{
    NSDictionary * tempDic =  [USER_DEFAULT objectForKey:@"WiFiInfo"];
    setNameText.text = [tempDic objectForKey:@"name"];
//    setPswText.text = [tempDic objectForKey:@"password"];
    if (![[tempDic objectForKey:@"password"] isEqualToString:@"none"]) {
        setPswText.text = [tempDic objectForKey:@"password"];
//        SecurityStatusLab.text =[tempDic objectForKey:@"encryption"] ;
//        PINProtectionLab.text = @"PIN Protection:ON";
        SecurityStatusLab.text =@"WPA2-PSK" ;
        [PINSwitch setOn:YES];
        SecurityStatusLab.font = FONT(12);
        SecurityStatusLab.frame =  CGRectMake(securityInputTextView.frame.size.width - 85, 8, 100, 20);

    }else
    {
        [setPswText setEnabled:NO];
        setPswText.text = @"";
        SecurityStatusLab.text = @"Open";
//        PINProtectionLab.text = @"PIN Protection:OFF";
        [PINSwitch setOn:NO];
    }
    
}
-(void)loadScroll
{
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"])
//    {
//        NSLog(@"此刻是4s的大小");
//        
//        
//        //顶部图标
//        WLANImageView.frame = CGRectMake(SCREEN_WIDTH/8*3, SCREEN_WIDTH/9, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
//        WLANImageView.image = [UIImage imageNamed:@"顶部icon"];
//        [scrollView addSubview:WLANImageView];
//        
//        nameInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH/5)/2, 2*SCREEN_WIDTH/5 , SCREEN_WIDTH/5*4, SCREEN_WIDTH/8)];
//        nameInputTextView.layer.borderWidth = 1.0f;
//        nameInputTextView.layer.cornerRadius = SCREEN_WIDTH/8/2;
//        nameInputTextView.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
//        
//        setNameText.delegate = self;
//        setNameText.autocorrectionType = UITextAutocorrectionTypeNo;
//        setNameText.frame = CGRectMake(20, 0, 280 - 50, 40);
//        setNameText.placeholder = @"";
//        setNameText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
//        
//        //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
//        //            inputText.image = [UIImage imageNamed:@"灰"];
//        //            inputText.userInteractionEnabled = YES;
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
//                                                    name:@"UITextFieldTextDidChangeNotification"
//                                                  object:setNameText];
//        setNameText.secureTextEntry = YES;
//        
//        [scrollView addSubview:nameInputTextView];
//        [nameInputTextView addSubview:setNameText];
//        
//        
        //    }
    {
        NSLog(@"此刻是4s的大小");
    
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
    
    nameEidtImageView.frame = CGRectMake(20, 8, 20, 20);
    nameEidtImageView.image = [UIImage imageNamed:@"SSID"];
    [nameInputTextView addSubview:nameEidtImageView];
    
    
    setNameText.delegate = self;
    setNameText.autocorrectionType = UITextAutocorrectionTypeNo;
    setNameText.frame = CGRectMake(50, 0, 250 - 50, 35);
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
    
    pswEidtImageView.frame = CGRectMake(20, 8, 20, 20);
    pswEidtImageView.image = [UIImage imageNamed:@"密码"];
    [pswInputTextView addSubview:pswEidtImageView];
    
    
    isViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    isViewBtn.frame = CGRectMake(pswInputTextView.frame.size.width - 40, 11, 25, 15);
    //    [pswBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    //        [isViewBtn setImage:[UIImage imageNamed:@"密文"] forState:UIControlStateNormal];
    [isViewBtn setBackgroundImage:[UIImage imageNamed:@"密文"] forState:UIControlStateNormal];
    
    [isViewBtn addTarget:self action:@selector(pswBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pswInputTextView addSubview:isViewBtn];
    
    
    
    setPswText.delegate = self;
    setPswText.autocorrectionType = UITextAutocorrectionTypeNo;
    setPswText.frame = CGRectMake(50, 0, 200, 35);
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
    
    SecurityStatusLab.frame = CGRectMake(securityInputTextView.frame.size.width - 50, 6, 50, 20);
    SecurityStatusLab.text = @"open";
    SecurityStatusLab.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
    [securityInputTextView addSubview:SecurityStatusLab];
    
    
    SecurityLab.frame = CGRectMake(30, 6, 200, 20);
    SecurityLab.text = @"Security Type";
    SecurityLab.font = FONT(15);
    SecurityLab.textColor = [UIColor colorWithRed:0xcb/255.0 green:0xcb/255.0 blue:0xcb/255.0 alpha:1];
    [securityInputTextView addSubview:SecurityLab];
    
    
    // 4. PIN Protection
    PINInputTextView.frame = CGRectMake(SCREEN_WIDTH/9, 380 , SCREEN_WIDTH/5*4, SCREEN_WIDTH/10);
    PINInputTextView.layer.borderWidth = 1.0f;
    PINInputTextView.layer.cornerRadius = SCREEN_WIDTH/10/2;
    PINInputTextView.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
    [scrollView addSubview:PINInputTextView];
    
    PINSwitch.frame = CGRectMake(PINInputTextView.frame.size.width - 60, 1, 35, 10);
    PINSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    //        [PINSwitch setTintColor:HEXCOLOR(0x99999)];
//    [PINSwitch setOnTintColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
//    [PINSwitch setThumbTintColor:[UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1]];
//    [PINSwitch setBackgroundColor:[UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1]];
//    PINSwitch.layer.cornerRadius = 10.0f;
    [PINSwitch setOnTintColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
    [PINSwitch setThumbTintColor:[UIColor whiteColor]];
    [PINSwitch setBackgroundColor:[UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1]];
    [PINSwitch setTintColor:[UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1]];
    PINSwitch.layer.cornerRadius = 33/2;

    PINSwitch.layer.masksToBounds = YES;
    [PINSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    [PINInputTextView addSubview:PINSwitch];
    
    
    PINLab.frame = CGRectMake(30, 6, 200, 20);
    PINLab.text = @"PIN Protection";
    PINLab.font = FONT(15);
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
    saveLab.frame = CGRectMake(110, 7, 80, 20);
    [saveBtn addSubview:saveLab];
    
}
    else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString
                                                                                                        isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5的大小");
        
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
        
        nameEidtImageView.frame = CGRectMake(20, 8, 20, 20);
        nameEidtImageView.image = [UIImage imageNamed:@"SSID"];
        [nameInputTextView addSubview:nameEidtImageView];
        
        
        setNameText.delegate = self;
        setNameText.autocorrectionType = UITextAutocorrectionTypeNo;
        setNameText.frame = CGRectMake(50, 0, 250 - 50, 35);
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
        
        pswEidtImageView.frame = CGRectMake(20, 8, 20, 20);
        pswEidtImageView.image = [UIImage imageNamed:@"密码"];
        [pswInputTextView addSubview:pswEidtImageView];
        
        
        isViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        isViewBtn.frame = CGRectMake(pswInputTextView.frame.size.width - 40, 11, 25, 15);
        //    [pswBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        //        [isViewBtn setImage:[UIImage imageNamed:@"密文"] forState:UIControlStateNormal];
        [isViewBtn setBackgroundImage:[UIImage imageNamed:@"密文"] forState:UIControlStateNormal];
        
        [isViewBtn addTarget:self action:@selector(pswBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [pswInputTextView addSubview:isViewBtn];
        
        
        
        setPswText.delegate = self;
        setPswText.autocorrectionType = UITextAutocorrectionTypeNo;
        setPswText.frame = CGRectMake(50, 0, 200, 35);
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
        
        SecurityStatusLab.frame = CGRectMake(securityInputTextView.frame.size.width - 50, 6, 50, 20);
        SecurityStatusLab.text = @"open";
        SecurityStatusLab.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
        [securityInputTextView addSubview:SecurityStatusLab];
        
        
        SecurityLab.frame = CGRectMake(30, 6, 200, 20);
        SecurityLab.text = @"Security Type";
        SecurityLab.font = FONT(15);
        SecurityLab.textColor = [UIColor colorWithRed:0xcb/255.0 green:0xcb/255.0 blue:0xcb/255.0 alpha:1];
        [securityInputTextView addSubview:SecurityLab];
        
        
        // 4. PIN Protection
        PINInputTextView.frame = CGRectMake(SCREEN_WIDTH/9, 380 , SCREEN_WIDTH/5*4, SCREEN_WIDTH/10);
        PINInputTextView.layer.borderWidth = 1.0f;
        PINInputTextView.layer.cornerRadius = SCREEN_WIDTH/10/2;
        PINInputTextView.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
        [scrollView addSubview:PINInputTextView];
        
        PINSwitch.frame = CGRectMake(PINInputTextView.frame.size.width - 60, 1, 35, 10);
        PINSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
        
//        [PINSwitch setOnTintColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
//        [PINSwitch setThumbTintColor:[UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1]];
//        PINSwitch.layer.cornerRadius = 10.0f;
        [PINSwitch setOnTintColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
        [PINSwitch setThumbTintColor:[UIColor whiteColor]];
        [PINSwitch setBackgroundColor:[UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1]];
        [PINSwitch setTintColor:[UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1]];
        PINSwitch.layer.cornerRadius = 33/2;
        
        PINSwitch.layer.masksToBounds = YES;
        [PINSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        [PINInputTextView addSubview:PINSwitch];
        
        
        PINLab.frame = CGRectMake(30, 6, 200, 20);
        PINLab.text = @"PIN Protection";
        PINLab.font = FONT(15);
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
        saveLab.frame = CGRectMake(110, 7, 80, 20);
        [saveBtn addSubview:saveLab];
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6 的大小");
        
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
        setNameText.frame = CGRectMake(50, 0, 250 - 50, 40);
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
        isViewBtn.frame = CGRectMake(pswInputTextView.frame.size.width - 40, 11, 25, 15);
        //    [pswBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        //        [isViewBtn setImage:[UIImage imageNamed:@"密文"] forState:UIControlStateNormal];
        [isViewBtn setBackgroundImage:[UIImage imageNamed:@"密文"] forState:UIControlStateNormal];
        
        [isViewBtn addTarget:self action:@selector(pswBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [pswInputTextView addSubview:isViewBtn];
        
        
        
        setPswText.delegate = self;
        setPswText.autocorrectionType = UITextAutocorrectionTypeNo;
        setPswText.frame = CGRectMake(50, 0, 200, 40);
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
        
        SecurityStatusLab.frame = CGRectMake(securityInputTextView.frame.size.width - 50, 8, 50, 20);
        SecurityStatusLab.text = @"open";
        SecurityStatusLab.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
        [securityInputTextView addSubview:SecurityStatusLab];
        
        
        SecurityLab.frame = CGRectMake(30, 10, 200, 20);
        SecurityLab.text = @"Security Type";
        SecurityLab.font = FONT(15);
        SecurityLab.textColor = [UIColor colorWithRed:0xcb/255.0 green:0xcb/255.0 blue:0xcb/255.0 alpha:1];
        [securityInputTextView addSubview:SecurityLab];
        
        
        // 4. PIN Protection
        PINInputTextView.frame = CGRectMake(SCREEN_WIDTH/9, 380 , SCREEN_WIDTH/5*4, SCREEN_WIDTH/10);
        PINInputTextView.layer.borderWidth = 1.0f;
        PINInputTextView.layer.cornerRadius = SCREEN_WIDTH/10/2;
        PINInputTextView.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
        [scrollView addSubview:PINInputTextView];
        
        PINSwitch.frame = CGRectMake(PINInputTextView.frame.size.width - 60, 3, 35, 10);
        PINSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        //        [PINSwitch setTintColor:HEXCOLOR(0x99999)];
        [PINSwitch setOnTintColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
        [PINSwitch setThumbTintColor:[UIColor whiteColor]];
        [PINSwitch setBackgroundColor:[UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1]];
        [PINSwitch setTintColor:[UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1]];
//        PINSwitch.tintColor = [UIColor redColor];
//        PINSwitch.onTintColor = [UIColor blackColor];
//        PINSwitch.thumbTintColor = [UIColor yellowColor];
//        PINSwitch.backgroundColor = [UIColor purpleColor];

        PINSwitch.layer.cornerRadius = 33/2;
        PINSwitch.layer.masksToBounds = YES;
        [PINSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        [PINInputTextView addSubview:PINSwitch];
        
        
        PINLab.frame = CGRectMake(30, 10, 200, 20);
        PINLab.text = @"PIN Protection";
        PINLab.font = FONT(15);
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
        saveLab.frame = CGRectMake(130, 10, 80, 20);
        [saveBtn addSubview:saveLab];
        
        
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
        setNameText.frame = CGRectMake(50, 0, 280 - 50, 40);
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
        isViewBtn.frame = CGRectMake(pswInputTextView.frame.size.width - 50, 2, pswInputTextView.frame.size.height, 40);
        //    [pswBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        [isViewBtn setImage:[UIImage imageNamed:@"密文"]  forState:UIControlStateNormal];
//        isViewBtn.bounds = CGRectMake(0, 0, 30, 30);
//        [isViewBtn setBackgroundImage:[UIImage imageNamed:@"密文"] forState:UIControlStateNormal];
//        UIImage * titleimage = [UIImage imageNamed:@"密文@3x"];
//        [isViewBtn setImage:[titleimage transformWidth:90 height:125] forState:UIControlStateNormal];

        [isViewBtn addTarget:self action:@selector(pswBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [pswInputTextView addSubview:isViewBtn];
        

        
        setPswText.delegate = self;
        setPswText.autocorrectionType = UITextAutocorrectionTypeNo;
        setPswText.frame = CGRectMake(50, 0, 280 - 50, 40);
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
        
//        [PINSwitch setOnTintColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
//        [PINSwitch setThumbTintColor:[UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1]];
//        PINSwitch.layer.cornerRadius = 10.0f;
        [PINSwitch setOnTintColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
        [PINSwitch setThumbTintColor:[UIColor whiteColor]];
        [PINSwitch setBackgroundColor:[UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1]];
        [PINSwitch setTintColor:[UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1]];
        PINSwitch.layer.cornerRadius = 33/2;
        
        PINSwitch.layer.masksToBounds = YES;
        [PINSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
 
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
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"开啊开开");
        [setPswText setEnabled:YES];
    }else {
        [setPswText setEnabled:NO];
        setPswText.text = @"";
        
        NSLog(@"管管管‘’‘’");
    }
}
-(void)saveBtnClick
{
    if (setNameText.text.length<6) {
        alertView = [[UIAlertView alloc]initWithTitle:nil message:@"SSID Length 6-16" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView addButtonWithTitle:@"Confirm"];
        [alertView show];
    }else if (setPswText.text.length < 8 && PINSwitch.on){
        alertView = [[UIAlertView alloc]initWithTitle:nil message:@"PIN Length 8-16" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView addButtonWithTitle:@"Confirm"];
        [alertView show];

    }else{
    NSLog(@"点击了保存按钮");
    NSString * DMSIP = [USER_DEFAULT objectForKey:@"RouterPsw"];
    NSString * serviceIp;
    if (DMSIP != NULL ) {
        serviceIp = [NSString stringWithFormat:@"http://%@/lua/settings/wifi",DMSIP];
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
    
    
    
    NSLog(@"setPswText.text %@",setPswText.text);
    NSLog(@"setNameText %@",setNameText.text);
    NSDictionary *  detailDic =[NSDictionary dictionaryWithObjectsAndKeys:setNameText.text,@"name",setPswText.text,@"password",nil];//创建多个键 多个值
    NSLog(@"detailDic %@",detailDic);
        
        if(![NSJSONSerialization isValidJSONObject:detailDic]){
            NSLog(@"it is not a JSONObject!");
            NSLog(@"222detailDic %@",detailDic);
            return ;
        }
        
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:detailDic options:0 error:nil];
        NSLog(@"jsonData %@",jsonData);
    //    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    
    [request setPostBody:tempJsonData];
    [request startSynchronous];
    NSError *error1 = [request error];
    
    
    
    
    NSData *data = [request responseData];
        NSLog(@" data--data %@",data);
//        if(![NSJSONSerialization isValidJSONObject:data]){
//            NSLog(@"it is not a JSONdata!");
//            NSLog(@"222detailDic %@",data);
//            return ;
//        }
        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //            NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

       NSString * str = [resDict objectForKey:@"result"];
        if ([str isEqualToString:@"failed"]) {
            alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Save faild" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView addButtonWithTitle:@"Confirm"];
            [alertView show];
        }else if ([str isEqualToString:@"success"])
        {
            alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Save success" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView addButtonWithTitle:@"Confirm"];
            [alertView show];
        }
        
            NSLog(@"[strstrstrstr %@",[resDict objectForKey:@"code"]);
//    if (!error1) {
//        //        NSString *response = [request responseString];
//        //        NSLog(@"Test：%@",response);
//        //        [USER_DEFAULT setObject:nameText.text forKey:@"routeNameUSER"];
//        //            NSString *response = [request responseString];
//
//        NSData *data = [request responseData];
//
//        NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//
//        NSLog(@"resDictresDict %@",resDict);
//        NSLog(@"strstrstrstrstr %@",str);
//        NSLog(@"[strstrstrstr %@",[resDict objectForKey:@"code"]);
////        if ([[resDict objectForKey:@"code"] isEqual:@1]) {
////            //            registerPwdTip = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:code1] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confirm", nil];
////            [registerPwdTip setMessage:[NSString stringWithFormat:code1]];
////            [registerPwdTip show];
////
////        }else if ([[resDict objectForKey:@"code"] isEqual:@2])
////        {
////            [registerPwdTip setMessage:[NSString stringWithFormat:code2]];
////            [registerPwdTip show];
////        }else if ([[resDict objectForKey:@"code"] isEqual:@3])
////        {
////            [registerPwdTip setMessage:[NSString stringWithFormat:code3]];
////            [registerPwdTip show];
////        }else if ([[resDict objectForKey:@"code"] isEqual:@4])
////        {
////            [registerPwdTip setMessage:[NSString stringWithFormat:code4]];
////            //            registerPwdTip = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:code4] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confirm", nil];
////            [registerPwdTip show];
////        }else if ([[resDict objectForKey:@"code"] isEqual:@0])
////        {
////            //                [registerPwdTip setMessage:[NSString stringWithFormat:code0]];
////            //                [registerPwdTip show];
////
////            [self judgeNextView];
////        }
//
//
//
//
//    }else
//    {
//
//    }

    }
}
-(void)pswBtnClick
{
    if (isOn == YES) {
        isOn = NO;
        setPswText.secureTextEntry = YES;
        //        [pswBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        [isViewBtn setImage:[UIImage imageNamed:@"密文"] forState:UIControlStateNormal];
        isViewBtn.bounds = CGRectMake(0, 0, 30, 30);
//        [isViewBtn setBackgroundImage:[UIImage imageNamed:@"密文"] forState:UIControlStateNormal];
    }
    else if (isOn == NO)
    {
        isOn = YES;
        setPswText.secureTextEntry = NO;
        //        [pswBtn setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
        [isViewBtn setImage:[UIImage imageNamed:@"明文显示"] forState:UIControlStateNormal];
        isViewBtn.bounds = CGRectMake(0, 0, 30, 30);
//        [isViewBtn setBackgroundImage:[UIImage imageNamed:@"明文显示"] forState:UIControlStateNormal];
    }
    
    NSLog(@"点击了眼睛按钮");
}
-(BOOL)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    
    
    
        NSUInteger lengthOfString = toBeString.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [toBeString characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}  ;  -  45  _95
            if (character < 45)
            {
    
                textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
                return NO; // 48 unichar for 0..
            }
    
            if (character > 45 && character < 48)
            {
    
                textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
                return NO; // 48 unichar for 0..
            }
            if (character > 57 && character < 65)
            {
                textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
                return NO; //
            }
            if (character > 90 && character < 95)
            {
                textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
                return NO; //
            }
            if (character > 95 && character < 97)
            {
                textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
                return NO; //
            }
            if (character > 122)
            {
                textField.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
                return NO; //
            }
    
    
        }
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
