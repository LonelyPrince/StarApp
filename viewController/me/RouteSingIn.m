//
//  RouteSingIn.m
//  StarAPP
//
//  Created by xyz on 2017/10/16.
//

#import "RouteSingIn.h"

#define emptyStr @"\n The PIN can not be empty \n\n"    //PIN码为空
#define lengthLessStr @"\n PIN Length 6-16 \n\n"    //PIN码长度短
#define specialStr @"\n PIN should be 6-16.Please enter letters,number,\"-\"or\"_\".\n\n"    //PIN码有特殊字符
#define errorStr @"\n incorrect PIN,please input again \n\n"    //PIN码有特殊字符
#define setNewRouteLabStr @"Please set your Router PIN.We recommend you \nto change the PIN to insure the security."    //PIN码有特殊字符

#define dontMatch @"The new PINs do not match \nplease try again"
#define code1 @"old pasword same new passwd!"
#define code2 @"login_passwd invalid params!"
#define code3 @"set login_passwd error!"
#define code4 @"old pasword not right!"
#define code0 @"reset password success!"


@interface RouteSingIn ()
{
    NSString * DMSIP;

    UIImageView * hudImage; //无网络图片
    MBProgressHUD *HUD; //网络加载HUD
    UILabel * hudLab ;//无网络文字
    NSString * deviceString;     //用于判断手机型号
}
@end

@implementation RouteSingIn

@synthesize routeNameLab;
@synthesize routeIPLab;
@synthesize wifiDic;
@synthesize wifiName;
@synthesize wifiIP;
@synthesize wifiPwd;
@synthesize activeView;
@synthesize okBtn;
@synthesize inputText;
@synthesize saveBtn;
@synthesize setNewRouteText;
@synthesize confirmText;
@synthesize securityImageView;
@synthesize inputTextView;
@synthesize inputTextView1;
@synthesize inputTextView2;
@synthesize setNewRouteLab;
@synthesize registerPwdTip;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNotific];
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    [self initData];
    [self getCurrentWifi];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [inputText resignFirstResponder];
    [confirmText resignFirstResponder];
    [setNewRouteText resignFirstResponder];
}
-(void)initData
{
        self.title = @"Router Setting";
        deviceString = [GGUtil deviceVersion];
        self.routeMenuView = [[RouteMenuView alloc]init];
        registerPwdTip = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:code0] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confilm", nil];
    
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是4 的大小");
        
        if (securityImageView == NULL) {
            securityImageView   = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120)/2, 90, 120, 120)];
            securityImageView.image = [UIImage imageNamed:@"安全中心"];
            [self.view addSubview:securityImageView];
        }
        if (setNewRouteLab == NULL) {
            setNewRouteLab   = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 270)/2, 400, 280, 100)];
            setNewRouteLab.text = setNewRouteLabStr;
            setNewRouteLab.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            setNewRouteLab.font = FONT(12);
            setNewRouteLab.numberOfLines = 0;
            
            //            [self.view addSubview:securityImageView];
        }

        if (saveBtn == NULL) {
            saveBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            saveBtn.frame = CGRectMake((SCREEN_WIDTH - 280)/2, 380, 280, 40);
            //            [okBtn setBackgroundColor:RGB(0xf5, 0xf5, 0xf5)];
            [saveBtn setBackgroundColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
            [saveBtn setTitle:@"" forState:UIControlStateNormal];
            //            [okBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
            saveBtn.layer.cornerRadius = 20;
            
            UILabel * saveLab = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 80, 30 )];
            saveLab.text =@"SAVE";
            saveLab.font = FONT(16);
            [saveBtn addSubview:saveLab];
            saveLab.textColor = [UIColor whiteColor];
            //            [self.view addSubview:saveBtn];
        }
        if (inputText == NULL) {
            
            inputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 280)/2, securityImageView.frame.origin.y + 150, 280, 40)];
            inputTextView.layer.borderWidth = 1.0f;
            inputTextView.layer.cornerRadius = 20;
            inputTextView.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            
            inputText.delegate = self;
            inputText.autocorrectionType = UITextAutocorrectionTypeNo;
            inputText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 280 - 50, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            inputText.placeholder = @"Input Route PIN";
            inputText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:inputText];
            inputText.secureTextEntry = YES;
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (okBtn == NULL) {
            okBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            okBtn.frame = CGRectMake((SCREEN_WIDTH - 280)/2, inputTextView.frame.origin.y+70, 280, 40);
            //            [okBtn setBackgroundColor:RGB(0xf5, 0xf5, 0xf5)];
            [okBtn setBackgroundColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
            [okBtn setTitle:@"" forState:UIControlStateNormal];
            //            [okBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
            okBtn.layer.cornerRadius = 20;
            
            UILabel * okLab = [[UILabel alloc]initWithFrame:CGRectMake(140, 5, 80, 30 )];
            okLab.text =@"OK";
            okLab.font = FONT(16);
            [okBtn addSubview:okLab];
            okLab.textColor = [UIColor whiteColor];
            //                saveBtn.titleLabel.text = @"SAVE";
            //                [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
            //
            //                saveBtn.backgroundColor = RGBA(96, 163, 236, 1);
            //    saveBtn.layer.cornerRadius = 20.0;
            
            
            
            //        [pswTextFieldImage addSubview:pswBtn];
            //            [self.view addSubview:okBtn];
        }
        if (setNewRouteText == NULL) {
            
            inputTextView1 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 280)/2, securityImageView.frame.origin.y + 150 + 10, 280, 40)];
            inputTextView1.layer.borderWidth = 1.0f;
            inputTextView1.layer.cornerRadius = 20;
            inputTextView1.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            
            setNewRouteText.delegate = self;
            setNewRouteText.autocorrectionType = UITextAutocorrectionTypeNo;
            setNewRouteText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 280 - 50, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            setNewRouteText.placeholder = @"New";
            setNewRouteText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:setNewRouteText];
            setNewRouteText.secureTextEntry = YES;
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (confirmText == NULL) {
            
            inputTextView2 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 280)/2, securityImageView.frame.origin.y + 150 + 10+60, 280, 40)];
            inputTextView2.layer.borderWidth = 1.0f;
            inputTextView2.layer.cornerRadius = 20;
            inputTextView2.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            
            confirmText.delegate = self;
            confirmText.autocorrectionType = UITextAutocorrectionTypeNo;
            confirmText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 280 - 50, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            confirmText.placeholder = @"Comfirm";
            confirmText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:confirmText];
            confirmText.secureTextEntry = YES;
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        
        
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5 的大小");
        
        if (securityImageView == NULL) {
            securityImageView   = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 140)/2, 110, 140, 140)];
            securityImageView.image = [UIImage imageNamed:@"安全中心"];
            [self.view addSubview:securityImageView];
        }
        if (setNewRouteLab == NULL) {
            setNewRouteLab   = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 270)/2, 420, 280, 200)];
            setNewRouteLab.text = setNewRouteLabStr;
            setNewRouteLab.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            setNewRouteLab.font = FONT(12);
            setNewRouteLab.numberOfLines = 0;
            
            //            [self.view addSubview:securityImageView];
        }
        if (okBtn == NULL) {
            okBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            okBtn.frame = CGRectMake((SCREEN_WIDTH - 280)/2, 400, 280, 40);
            //            [okBtn setBackgroundColor:RGB(0xf5, 0xf5, 0xf5)];
            [okBtn setBackgroundColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
            [okBtn setTitle:@"" forState:UIControlStateNormal];
            //            [okBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
            okBtn.layer.cornerRadius = 20;
            
            UILabel * okLab = [[UILabel alloc]initWithFrame:CGRectMake(140, 5, 80, 30 )];
            okLab.text =@"OK";
            okLab.font = FONT(16);
            [okBtn addSubview:okLab];
            okLab.textColor = [UIColor whiteColor];
            //                saveBtn.titleLabel.text = @"SAVE";
            //                [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
            //
            //                saveBtn.backgroundColor = RGBA(96, 163, 236, 1);
            //    saveBtn.layer.cornerRadius = 20.0;
            
            
            
            //        [pswTextFieldImage addSubview:pswBtn];
            //            [self.view addSubview:okBtn];
        }
        if (saveBtn == NULL) {
            saveBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            saveBtn.frame = CGRectMake((SCREEN_WIDTH - 280)/2, 440, 280, 40);
            //            [okBtn setBackgroundColor:RGB(0xf5, 0xf5, 0xf5)];
            [saveBtn setBackgroundColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
            [saveBtn setTitle:@"" forState:UIControlStateNormal];
            //            [okBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
            saveBtn.layer.cornerRadius = 20;
            
            UILabel * saveLab = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 80, 30 )];
            saveLab.text =@"SAVE";
            saveLab.font = FONT(16);
            [saveBtn addSubview:saveLab];
            saveLab.textColor = [UIColor whiteColor];
            //            [self.view addSubview:saveBtn];
        }
        if (inputText == NULL) {
            
            inputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 280)/2, securityImageView.frame.origin.y + 150 + 50, 280, 40)];
            inputTextView.layer.borderWidth = 1.0f;
            inputTextView.layer.cornerRadius = 20;
            inputTextView.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            
            inputText.delegate = self;
            inputText.autocorrectionType = UITextAutocorrectionTypeNo;
            inputText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 280 - 50, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            inputText.placeholder = @"Input Route PIN";
            inputText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:inputText];
            inputText.secureTextEntry = YES;
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (setNewRouteText == NULL) {
            
            inputTextView1 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 280)/2, securityImageView.frame.origin.y + 150 + 30, 280, 40)];
            inputTextView1.layer.borderWidth = 1.0f;
            inputTextView1.layer.cornerRadius = 20;
            inputTextView1.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            
            setNewRouteText.delegate = self;
            setNewRouteText.autocorrectionType = UITextAutocorrectionTypeNo;
            setNewRouteText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 280 - 50, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            setNewRouteText.placeholder = @"New";
            setNewRouteText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:setNewRouteText];
            setNewRouteText.secureTextEntry = YES;
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (confirmText == NULL) {
            
            inputTextView2 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 280)/2, securityImageView.frame.origin.y + 150 + 50+40, 280, 40)];
            inputTextView2.layer.borderWidth = 1.0f;
            inputTextView2.layer.cornerRadius = 20;
            inputTextView2.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            
            confirmText.delegate = self;
            confirmText.autocorrectionType = UITextAutocorrectionTypeNo;
            confirmText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 280 - 50, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            confirmText.placeholder = @"Comfirm";
            confirmText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:confirmText];
            confirmText.secureTextEntry = YES;
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        
        
    }
    else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6 的大小");
        
        if (securityImageView == NULL) {
            securityImageView   = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 120, 150, 150)];
            securityImageView.image = [UIImage imageNamed:@"安全中心"];
            [self.view addSubview:securityImageView];
        }
        if (setNewRouteLab == NULL) {
            setNewRouteLab   = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 290)/2, 440, 300, 200)];
            setNewRouteLab.text = setNewRouteLabStr;
            setNewRouteLab.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            setNewRouteLab.font = FONT(13);
            setNewRouteLab.numberOfLines = 0;
            
            //            [self.view addSubview:securityImageView];
        }
        if (okBtn == NULL) {
            okBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            okBtn.frame = CGRectMake((SCREEN_WIDTH - 300)/2, 400, 300, 40);
            //            [okBtn setBackgroundColor:RGB(0xf5, 0xf5, 0xf5)];
            [okBtn setBackgroundColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
            [okBtn setTitle:@"" forState:UIControlStateNormal];
            //            [okBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
            okBtn.layer.cornerRadius = 20;
            
            UILabel * okLab = [[UILabel alloc]initWithFrame:CGRectMake(140, 5, 80, 30 )];
            okLab.text =@"OK";
            okLab.font = FONT(16);
            [okBtn addSubview:okLab];
            okLab.textColor = [UIColor whiteColor];
            //                saveBtn.titleLabel.text = @"SAVE";
            //                [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
            //
            //                saveBtn.backgroundColor = RGBA(96, 163, 236, 1);
            //    saveBtn.layer.cornerRadius = 20.0;
            
            
            
            //        [pswTextFieldImage addSubview:pswBtn];
            //            [self.view addSubview:okBtn];
        }
        if (saveBtn == NULL) {
            saveBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            saveBtn.frame = CGRectMake((SCREEN_WIDTH - 300)/2, 460, 300, 40);
            //            [okBtn setBackgroundColor:RGB(0xf5, 0xf5, 0xf5)];
            [saveBtn setBackgroundColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
            [saveBtn setTitle:@"" forState:UIControlStateNormal];
            //            [okBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
            saveBtn.layer.cornerRadius = 20;
            
            UILabel * saveLab = [[UILabel alloc]initWithFrame:CGRectMake(130, 5, 80, 30 )];
            saveLab.text =@"SAVE";
            saveLab.font = FONT(16);
            [saveBtn addSubview:saveLab];
            saveLab.textColor = [UIColor whiteColor];
            //            [self.view addSubview:saveBtn];
        }
        if (inputText == NULL) {
            
            inputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, securityImageView.frame.origin.y + 150 + 50, 300, 40)];
            inputTextView.layer.borderWidth = 1.0f;
            inputTextView.layer.cornerRadius = 20;
            inputTextView.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            
            inputText.delegate = self;
            inputText.autocorrectionType = UITextAutocorrectionTypeNo;
            inputText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 300 - 50, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            inputText.placeholder = @"Input Route PIN";
            inputText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:inputText];
            inputText.secureTextEntry = YES;
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (setNewRouteText == NULL) {
            
            inputTextView1 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, securityImageView.frame.origin.y + 150 + 50, 300, 40)];
            inputTextView1.layer.borderWidth = 1.0f;
            inputTextView1.layer.cornerRadius = 20;
            inputTextView1.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            
            setNewRouteText.delegate = self;
            setNewRouteText.autocorrectionType = UITextAutocorrectionTypeNo;
            setNewRouteText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 300 - 50, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            setNewRouteText.placeholder = @"New";
            setNewRouteText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:setNewRouteText];
            setNewRouteText.secureTextEntry = YES;
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (confirmText == NULL) {
            
            inputTextView2 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, securityImageView.frame.origin.y + 150 + 50+60, 300, 40)];
            inputTextView2.layer.borderWidth = 1.0f;
            inputTextView2.layer.cornerRadius = 20;
            inputTextView2.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            
            confirmText.delegate = self;
            confirmText.autocorrectionType = UITextAutocorrectionTypeNo;
            confirmText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 300 - 50, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            confirmText.placeholder = @"Comfirm";
            confirmText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:confirmText];
            confirmText.secureTextEntry = YES;
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        if (securityImageView == NULL) {
            securityImageView   = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 120, 150, 150)];
            securityImageView.image = [UIImage imageNamed:@"安全中心"];
            [self.view addSubview:securityImageView];
        }
        if (setNewRouteLab == NULL) {
            setNewRouteLab   = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 290)/2, 440, 300, 200)];
            setNewRouteLab.text = setNewRouteLabStr;
            setNewRouteLab.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            setNewRouteLab.font = FONT(13);
            setNewRouteLab.numberOfLines = 0;
            
//            [self.view addSubview:securityImageView];
        }
        if (okBtn == NULL) {
            okBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            okBtn.frame = CGRectMake((SCREEN_WIDTH - 300)/2, 400, 300, 40);
//            [okBtn setBackgroundColor:RGB(0xf5, 0xf5, 0xf5)];
            [okBtn setBackgroundColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
            [okBtn setTitle:@"" forState:UIControlStateNormal];
            //            [okBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
            okBtn.layer.cornerRadius = 20;
            
            UILabel * okLab = [[UILabel alloc]initWithFrame:CGRectMake(140, 5, 80, 30 )];
            okLab.text =@"OK";
            okLab.font = FONT(16);
            [okBtn addSubview:okLab];
            okLab.textColor = [UIColor whiteColor];
//                saveBtn.titleLabel.text = @"SAVE";
//                [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
//
//                saveBtn.backgroundColor = RGBA(96, 163, 236, 1);
            //    saveBtn.layer.cornerRadius = 20.0;
            
            
            
            //        [pswTextFieldImage addSubview:pswBtn];
//            [self.view addSubview:okBtn];
        }
        if (saveBtn == NULL) {
            saveBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            saveBtn.frame = CGRectMake((SCREEN_WIDTH - 300)/2, 460, 300, 40);
            //            [okBtn setBackgroundColor:RGB(0xf5, 0xf5, 0xf5)];
            [saveBtn setBackgroundColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
            [saveBtn setTitle:@"" forState:UIControlStateNormal];
            //            [okBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
            saveBtn.layer.cornerRadius = 20;
            
            UILabel * saveLab = [[UILabel alloc]initWithFrame:CGRectMake(138, 5, 80, 30 )];
            saveLab.text =@"SAVE";
            saveLab.font = FONT(16);
            [saveBtn addSubview:saveLab];
            saveLab.textColor = [UIColor whiteColor];
//            [self.view addSubview:saveBtn];
        }
        if (inputText == NULL) {
            
            inputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, securityImageView.frame.origin.y + 150 + 50, 300, 40)];
            inputTextView.layer.borderWidth = 1.0f;
            inputTextView.layer.cornerRadius = 20;
            inputTextView.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            
            inputText.delegate = self;
            inputText.autocorrectionType = UITextAutocorrectionTypeNo;
            inputText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 300 - 50, 40)];
//
//            inputText.layer.borderWidth = 1.0f;
//            inputText.layer.cornerRadius = 20;
//            inputText.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            inputText.placeholder = @"Input Route PIN";
            inputText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];

            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
//            inputText.image = [UIImage imageNamed:@"灰"];
//            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:inputText];
            inputText.secureTextEntry = YES;
//            [self.view addSubview:inputTextView];
//            [inputTextView addSubview:inputText];
//            [inputText bringSubviewToFront:inputTextView];
        }
        if (setNewRouteText == NULL) {
            
            inputTextView1 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, securityImageView.frame.origin.y + 150 + 50, 300, 40)];
            inputTextView1.layer.borderWidth = 1.0f;
            inputTextView1.layer.cornerRadius = 20;
            inputTextView1.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            
            setNewRouteText.delegate = self;
            setNewRouteText.autocorrectionType = UITextAutocorrectionTypeNo;
            setNewRouteText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 300 - 50, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            setNewRouteText.placeholder = @"New";
            setNewRouteText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:setNewRouteText];
            setNewRouteText.secureTextEntry = YES;
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (confirmText == NULL) {
            
            inputTextView2 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, securityImageView.frame.origin.y + 150 + 50+60, 300, 40)];
            inputTextView2.layer.borderWidth = 1.0f;
            inputTextView2.layer.cornerRadius = 20;
            inputTextView2.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            
            confirmText.delegate = self;
            confirmText.autocorrectionType = UITextAutocorrectionTypeNo;
            confirmText = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 300 - 50, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1].CGColor;
            confirmText.placeholder = @"Comfirm";
            confirmText.textColor = [UIColor colorWithRed:0xc8/255.0 green:0xc8/255.0 blue:0xc8/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:confirmText];
            confirmText.secureTextEntry = YES;
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        

    }
    
    
    
    
    
    
    
    
    //    //  [self loadNav];
    //    scrollView = [[UIScrollView alloc]init];
    //    routeImage = [[UIImageView alloc]init];
    
    routeNameLab = [[UILabel alloc]init];
    //    routeIPLab = [[UILabel alloc]init];
    //    centerGrayView = [[UIView alloc]init];
    //    connectDevice = [[UILabel alloc]init];
    //
    //    HUD = [[MBProgressHUD alloc]init];
    //    netWorkErrorView = [[UIView alloc]init];
    //    tableView = [[UITableView alloc]init];
}
#pragma mark - 初始化创建不同的通知
-(void)initNotific
{
    //////////////////////////// 从socket返回数据
    //此处接收到路由器IP地址的消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getSocketIpInfoNotice" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSocketIpInfo:) name:@"getSocketIpInfoNotice" object:nil];
    
    //获取网络链接的通知
    NSNotification *notification =[NSNotification notificationWithName:@"socketGetIPAddressNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    ///创建通知，用于判断网络是否正常
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"routeNetWorkError" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeNetWorkError) name:@"getSocketIpInfoNotice" object:nil];
    
}
//显示无网络的状态图
-(void)routeNetWorkError
{
    //xianshi
    [self temp];
    
    [self.activeView removeFromSuperview];
    [HUD removeFromSuperview];
    HUD = nil;
    self.activeView.backgroundColor = [UIColor whiteColor];
    [self.activeView addSubview:hudImage];
    [self.activeView addSubview:hudLab];
    [self.view addSubview:activeView];

    
}
-(void)temp
{
    hudImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 616/2)/2, 120, 616/2, 348/2)];
    hudImage.image = [UIImage imageNamed:@"网络无连接"];
    //调用上面的方法，获取 字体的 Size
    
    CGSize size = [GGUtil sizeWithText: @"Network Error" font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    hudLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - size.width)/2, 120+149+50, size.width, size.height)];
    hudLab.text = @"Network Error";
    hudLab.font = FONT(15);
    hudLab.textColor = [UIColor grayColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getSocketIpInfo:(NSNotification *)text{
    
    NSData * socketIPData = text.userInfo[@"socketIPAddress"];
    NSData * ipStrData ;
    NSLog(@"socketIPData :%@",socketIPData);
    
    if (socketIPData != NULL  && socketIPData != nil  &&  socketIPData.length > 0 ) {
        
        if (socketIPData.length >38) {
            
            if ([socketIPData length] >= 1 + 37 + socketIPData.length - 38) {
                ipStrData = [socketIPData subdataWithRange:NSMakeRange(1 + 37,socketIPData.length - 38)];
            }else
            {
                return;
            }
            
            NSLog(@"ipStrData %@",ipStrData);
            
            DMSIP =  [[NSString alloc] initWithData:ipStrData  encoding:NSUTF8StringEncoding];
            NSLog(@" DMSIP %@",DMSIP);
            
            //            [self loadNav];
            [self viewWillAppear:YES];
        }
        
    }
    
    
}
-(void)getCurrentWifi
{
    
    //获取数据的链接
    NSString * url =     [NSString stringWithFormat:@"http://%@/lua/settings/getLoginPasswd",DMSIP];
    //    NSString *url = [NSString stringWithFormat:@"%@",G_devicepwd];
    
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
    
    [request startAsynchronous ];
    
    //    NSError *error = [request error ];
    //    assert (!error);
    // 如果请求成功，返回 Response
    
    
    [request setCompletionBlock:^{
        NSLog ( @"request:%@" ,request);
        NSDictionary *pwdDic = [request responseData].JSONValue;
        NSLog ( @"onlineDeviceArr:%@" ,pwdDic);
        
        NSString * pwdStr =[pwdDic objectForKey:@"pwd"];
        
        if ([pwdStr isEqualToString:@"MGadmin"] || [pwdStr isEqualToString:@""] || pwdStr == NULL) {
            NSLog(@"需要展示修改密码的界面");
            [self showPwdRegistrView];
            
        }else
        {
            NSLog(@"用户输入PIN 进入");
            [self showLoginView];
//            [self showPwdRegistrView];
        }
//        wifiDic = [[NSDictionary alloc]init];
//        wifiDic = onlineWifi;
//
//
//        routeNameLab.text = [wifiDic objectForKey:@"name"];
//
//        //        routeIPLab.text =  @"IP:192.168.1.1" ;//[wifiDic objectForKey:@"ip"];
//        routeIPLab.text = [NSString stringWithFormat:@"IP:%@",DMSIP];
    }];
    
    
    
    
}

#pragma mark - 确认按钮点击
-(void)okBtnClick
{
    if (inputText.text.length == 0) {
        //用户没有输入任何东西，弹窗提醒
        NSLog(@"输入的东西不能为空");
        UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:emptyStr] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confilm", nil];
        
        //    UIAlertView * linkAlert =   [[UIAlertView alloc] initWithTitle:@"Alert View"message:@"We Will Call" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSString stringWithFormat:@"22:%@",tel],[NSString stringWithFormat:@"00:%@",tel], nil];
        
        [linkAlert show];
    }else if(inputText.text.length < 6)
    {
        UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:lengthLessStr] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confilm", nil];
        
        [linkAlert show];
        
    }else
    {
        NSString *toBeString = inputText.text;
        BOOL temp = YES;
            NSUInteger lengthOfString = toBeString.length;  //lengthOfString的值始终为1
            for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
                unichar character = [toBeString characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
                // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}  ;  -  45  _95
                if (character < 45)
                {
                    temp = NO;
//                    inputText.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
//                    return NO; // 48 unichar for 0..
                }
        
                if (character > 45 && character < 48)
                {
                    temp = NO;
//                    inputText.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
//                    return NO; // 48 unichar for 0..
                }
                if (character > 57 && character < 65)
                {
                    temp = NO;
//                    inputText.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
//                    return NO; //
                }
                if (character > 90 && character < 95)
                {
                    temp = NO;
//                    inputText.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
//                    return NO; //
                }
                if (character > 95 && character < 97)
                {
                    temp = NO;
//                    inputText.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
//                    return NO; //
                }
                if (character > 122)
                {
                    temp = NO;
//                    inputText.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
//                    return NO; //
                }
                
        
        
            }
        
        if (temp == NO) {
            UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:specialStr] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confilm", nil];
            
            [linkAlert show];
        }else   //正确情况
        {
            //发送链接判断是不是正确
            [self judgeIsTrue];
            
        }
    }
    
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
-(void)judgeIsTrue{
    
    //获取数据的链接
    NSString * url =     [NSString stringWithFormat:@"http://%@/lua/settings/admin?pwd=%@",DMSIP,inputText.text];
    //    NSString *url = [NSString stringWithFormat:@"%@",G_devicepwd];
    
    ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :[NSURL URLWithString:url]];
    
    [request startAsynchronous ];
    
    //    NSError *error = [request error ];
    //    assert (!error);
    // 如果请求成功，返回 Response
    
    
    [request setCompletionBlock:^{
        NSLog ( @"request:%@" ,request);
        NSDictionary *resultDic = [request responseData].JSONValue;
        NSLog ( @"onlineDeviceArr1:%@" ,resultDic);
        
        NSString * resultStr =[resultDic objectForKey:@"result"];
        
        if ([resultStr isEqualToString:@"success"]) {
            NSLog(@"用户输入成功");
            
            
            [self judgeNextView];
            
        }else
        {
            NSLog(@"用户输入失败");
            UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:errorStr] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confilm", nil];
            
            [linkAlert show];
        }
        //        wifiDic = [[NSDictionary alloc]init];
        //        wifiDic = onlineWifi;
        //
        //
        //        routeNameLab.text = [wifiDic objectForKey:@"name"];
        //
        //        //        routeIPLab.text =  @"IP:192.168.1.1" ;//[wifiDic objectForKey:@"ip"];
        //        routeIPLab.text = [NSString stringWithFormat:@"IP:%@",DMSIP];
    }];
    
    
    
    
}
-(void)clickEvent
{
    
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = NO;
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
#pragma mark - 用户第一次连接盒子时，需要进行也一次密码设定
-(void)showPwdRegistrView
{
    //把登录界面的样式隐藏
    [okBtn removeFromSuperview];
    [inputTextView removeFromSuperview];
    [inputText removeFromSuperview];
    
    
    [self.view addSubview:saveBtn];
    
    [self.view addSubview:inputTextView1];
    [inputTextView1 addSubview:setNewRouteText];
    [setNewRouteText bringSubviewToFront:inputTextView1];
    
    [self.view addSubview:inputTextView2];
    [inputTextView2 addSubview:confirmText];
    [confirmText bringSubviewToFront:inputTextView2];
    [self.view addSubview:setNewRouteLab];
}
#pragma mark - 用户登录界面
-(void)showLoginView
{
    
    [saveBtn removeFromSuperview];
    [inputTextView1 removeFromSuperview];
    [inputTextView2 removeFromSuperview];
    [setNewRouteText removeFromSuperview];
    [confirmText removeFromSuperview];
    [setNewRouteLab removeFromSuperview];
    
    [self.view addSubview:okBtn];
    
    [self.view addSubview:inputTextView];
    [inputTextView addSubview:inputText];
    [inputText bringSubviewToFront:inputTextView];
    
    
}
-(void)saveBtnClick
{
    NSLog(@"点击了save按钮11");
    BOOL judgePINIsLegal =  [self judgePINIsLegal]; //判断输入框的PIN码是否和规定
    
    if (judgePINIsLegal == YES) {
        //
        //    NSString * DMSIP = [USER_DEFAULT objectForKey:@"HMC_DMSIP"];
        //        DMSIP = @"192.168.1.1";
        NSString * serviceIp;
        if (DMSIP != NULL ) {
            serviceIp = [NSString stringWithFormat:@"http://%@/lua/settings/admin",DMSIP];
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
        
        NSDictionary *  detailDic =[NSDictionary dictionaryWithObjectsAndKeys:@"MGadmin",@"old_pwd",confirmText.text,@"new_pwd",nil];//创建多个键 多个值
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:detailDic options:0 error:nil];
        //    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        
        [request setPostBody:tempJsonData];
        [request startSynchronous];
        NSError *error1 = [request error];
        if (!error1) {
            //        NSString *response = [request responseString];
            //        NSLog(@"Test：%@",response);
            //        [USER_DEFAULT setObject:nameText.text forKey:@"routeNameUSER"];
            //            NSString *response = [request responseString];
            
            NSData *data = [request responseData];
            
            NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"resDict %@",resDict);
            NSLog(@"[resDict objectForKey:] %@",[resDict objectForKey:@"code"]);
            if ([[resDict objectForKey:@"code"] isEqual:@1]) {
                //            registerPwdTip = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:code1] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confilm", nil];
                [registerPwdTip setMessage:[NSString stringWithFormat:code1]];
                [registerPwdTip show];
                
            }else if ([[resDict objectForKey:@"code"] isEqual:@2])
            {
                [registerPwdTip setMessage:[NSString stringWithFormat:code2]];
                [registerPwdTip show];
            }else if ([[resDict objectForKey:@"code"] isEqual:@3])
            {
                [registerPwdTip setMessage:[NSString stringWithFormat:code3]];
                [registerPwdTip show];
            }else if ([[resDict objectForKey:@"code"] isEqual:@4])
            {
                [registerPwdTip setMessage:[NSString stringWithFormat:code4]];
                //            registerPwdTip = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:code4] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confilm", nil];
                [registerPwdTip show];
            }else if ([[resDict objectForKey:@"code"] isEqual:@0])
            {
//                [registerPwdTip setMessage:[NSString stringWithFormat:code0]];
//                [registerPwdTip show];
             
                [self judgeNextView];
            }
            
            
            
            
        }
    }
   

    
}
#pragma mark - 判断PIN码是否合规定
-(BOOL)judgePINIsLegal
{
    if (setNewRouteText.text.length == 0 || confirmText.text.length == 0) {
        //用户没有输入任何东西，弹窗提醒
        NSLog(@"输入的东西不能为空");
        UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:emptyStr] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confilm", nil];
        
        //    UIAlertView * linkAlert =   [[UIAlertView alloc] initWithTitle:@"Alert View"message:@"We Will Call" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSString stringWithFormat:@"22:%@",tel],[NSString stringWithFormat:@"00:%@",tel], nil];
        
        [linkAlert show];
    }else if(setNewRouteText.text.length < 6 || confirmText.text.length < 6)
    {
        UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:lengthLessStr] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confilm", nil];
        
        [linkAlert show];
        
    }else if (![setNewRouteText.text isEqualToString:confirmText.text])
    {
        UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:dontMatch] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confilm", nil];
        
        [linkAlert show];
        
    }
    else
    {
//        NSString *toBeString = setNewRouteText.text;
//        BOOL temp = YES;
//        NSUInteger lengthOfString = toBeString.length;  //lengthOfString的值始终为1
//        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
//            unichar character = [toBeString characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
//            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}  ;  -  45  _95
//            if (character < 45)
//            {
//                temp = NO;
//                //                    inputText.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
//                //                    return NO; // 48 unichar for 0..
//            }
//
//            if (character > 45 && character < 48)
//            {
//                temp = NO;
//                //                    inputText.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
//                //                    return NO; // 48 unichar for 0..
//            }
//            if (character > 57 && character < 65)
//            {
//                temp = NO;
//                //                    inputText.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
//                //                    return NO; //
//            }
//            if (character > 90 && character < 95)
//            {
//                temp = NO;
//                //                    inputText.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
//                //                    return NO; //
//            }
//            if (character > 95 && character < 97)
//            {
//                temp = NO;
//                //                    inputText.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
//                //                    return NO; //
//            }
//            if (character > 122)
//            {
//                temp = NO;
//                //                    inputText.text = [NSString  stringWithFormat:@"%@%@",[toBeString substringToIndex:loopIndex],[toBeString substringWithRange:NSMakeRange(loopIndex+1, lengthOfString-loopIndex-1)]];
//                //                    return NO; //
//            }
//
//
//
//        }
//
//        if (temp == NO) {
//            UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:specialStr] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confilm", nil];
//
//            [linkAlert show];
//        }else   //正确情况
//        {
            //发送链接判断是不是正确
            return true;
            
        }
//    }
    
}
#pragma mark -跳转到下一个页面
-(void)judgeNextView
{
    
    if(![self.navigationController.topViewController isKindOfClass:[self.routeMenuView class]]) {
        [self.navigationController pushViewController:self.routeMenuView animated:YES];
    }else
    {
        NSLog(@"此处可能会由于页面跳转过快报错");
    }
    NSLog(@"self.navigationController %@",self.navigationController );
    //    [self.navigationController pushViewController:self.routeSetting animated:YES];
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Arrow"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
    //    self.routeSetting.nameText = [[UITextField alloc]init];
    //    self.routeSetting.nameText.text =routeNameLab.text;
    
    self.routeMenuView.navigationController.navigationBar.tintColor = RGBA(0x94, 0x94, 0x94, 1);
    self.routeMenuView.navigationItem.leftBarButtonItem = myButton;
}
@end
