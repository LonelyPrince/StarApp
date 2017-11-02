//
//  SecurityCenterView.m
//  StarAPP
//
//  Created by xyz on 2017/10/23.
//

#import "SecurityCenterView.h"
#import "MEViewController.h"

#define emptyStr @"\n The PIN can not be empty \n\n"    //PIN码为空
#define lengthLessStr @"PIN should be 6-16.Please enter letters,number,\"-\"or\"_\"."    //PIN码长度短
#define specialStr @"\n PIN should be 6-16.Please enter letters,number,\"-\"or\"_\".\n\n"    //PIN码有特殊字符
#define errorStr @"\n incorrect PIN,please input again \n\n"    //PIN码有特殊字符
#define setNewRouteLabStr @"Please set your Router PIN.We recommend you \nto change the PIN to insure the security."    //PIN码有特殊字符

#define dontMatch @"The new PINs do not match"
#define code1 @"The new PIN should not be the same as the original PIN"
#define code2 @"PIN should be 6-16.Please enter letters,numbers,\"-\" or \"_\""
#define code3 @"set login_passwd error!"
#define code4 @"Router PIN is incorrect"
#define code0 @"Save success"
@interface SecurityCenterView ()
{
    NSString * deviceString;     //用于判断手机型号
}

@property(nonatomic,strong)MEViewController * meViewController;
@end

@implementation SecurityCenterView

@synthesize scrollView;
@synthesize securityImageView;
@synthesize currentInputTextView;
@synthesize setNewInputTextView;
@synthesize ConfirmInputTextView;
@synthesize currentPINText;
@synthesize setNewRouteText;
@synthesize confirmText;
@synthesize saveBtn;
@synthesize registerPwdTip;

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    [self initNotific];
    deviceString = [GGUtil deviceVersion];
    [self initData];
    [self loadNav];
    [self loadUI];
    [self loadScroll];
    [self addToScroll];
    [self configRemoveUITextFieldEding];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"routeNetWorkError" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetWorkErrorView) name:@"routeNetWorkError" object:nil];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    
//    [self addHud];
//    [self getCurrentWifi];
//    [self getWifiInfo];  //用于获得WiFi信息，在Menu页面进行展示
}
-(void)configRemoveUITextFieldEding
{
    //此处销毁通知，防止一个通知被多次调用    // 1
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeUITextFieldEding" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeUITextFieldEding) name:@"removeUITextFieldEding" object:nil];
    
}

-(void)removeUITextFieldEding
{
    [self onTap];
}
-(void)loadNav
{
    self.title = @"Security Center";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
}
-(void)initData
{
    self.meViewController = [[MEViewController alloc]init];
    scrollView = [[UIScrollView alloc]init];
    registerPwdTip = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:code0] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confirm", nil];
//    securityImageView = [[UIImageView alloc]init];
//    currentInputTextView = [[UIView alloc]init];
//    setNewInputTextView = [[UIView alloc]init];
//    ConfirmInputTextView = [[UIView alloc]init];
//    currentPINText = [[UITextField alloc]init];
//    setNewRouteText = [[UITextField alloc]init];
//    confirmText = [[UITextField alloc]init];
//    saveBtn = [[UIButton alloc]init];
}

-(void)loadScroll
{
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
    [self.view addSubview:scrollView];
    
    
    scrollView.showsVerticalScrollIndicator=YES;
    scrollView.showsHorizontalScrollIndicator=YES;
    scrollView.delegate=self;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor colorWithRed:0xf4/255.0 green:0xf5/255.0 blue:0xf9/255.0 alpha:1];
    
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是4s的大小");
        
        
        if (securityImageView == NULL) {
            securityImageView   = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 99)/2, 49, 99, 99)];
            securityImageView.image = [UIImage imageNamed:@"安全中心"];
            [self.view addSubview:securityImageView];
            [scrollView addSubview:securityImageView];
        }
        
        
        
        if (currentPINText == NULL) {
            
            currentInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 576/2)/2, securityImageView.frame.origin.y + 99 + 49, 576/2, 43)];
            currentInputTextView.layer.borderWidth = 1.0f;
            currentInputTextView.layer.cornerRadius = 43/2;
            currentInputTextView.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            
            currentPINText.delegate = self;
            currentPINText.autocorrectionType = UITextAutocorrectionTypeNo;
            currentPINText = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, currentInputTextView.frame.size.width - 20, 40)];
            
            currentPINText.placeholder = @"Current PIN";
            currentPINText.textColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1];
            
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:currentPINText];
            currentPINText.secureTextEntry = YES;
            [currentInputTextView addSubview:currentPINText];
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (setNewRouteText == NULL) {
            
            setNewInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 576/2)/2, currentInputTextView.frame.origin.y + 43 + 15, 576/2, 43)];
            setNewInputTextView.layer.borderWidth = 1.0f;
            setNewInputTextView.layer.cornerRadius = 43/2;
            setNewInputTextView.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            
            setNewRouteText.delegate = self;
            setNewRouteText.autocorrectionType = UITextAutocorrectionTypeNo;
            setNewRouteText = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, setNewInputTextView.frame.size.width - 20, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            setNewRouteText.placeholder = @"New PIN";
            setNewRouteText.textColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:setNewRouteText];
            setNewRouteText.secureTextEntry = YES;
            [setNewInputTextView addSubview:setNewRouteText];
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (confirmText == NULL) {
            
            ConfirmInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 576/2)/2, setNewInputTextView.frame.origin.y + 43 + 15, 576/2, 43)];
            ConfirmInputTextView.layer.borderWidth = 1.0f;
            ConfirmInputTextView.layer.cornerRadius = 43/2;
            ConfirmInputTextView.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            
            confirmText.delegate = self;
            confirmText.autocorrectionType = UITextAutocorrectionTypeNo;
            confirmText = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, ConfirmInputTextView.frame.size.width - 20, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            confirmText.placeholder = @"Confirm PIN";
            confirmText.textColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:confirmText];
            confirmText.secureTextEntry = YES;
            [ConfirmInputTextView addSubview:confirmText];
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        
        if (saveBtn == NULL) {
            saveBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            saveBtn.frame = CGRectMake((SCREEN_WIDTH - 576/2)/2, ConfirmInputTextView.frame.origin.y + 43 + 30, 576/2, 43);
            //            [okBtn setBackgroundColor:RGB(0xf5, 0xf5, 0xf5)];
            [saveBtn setBackgroundColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
            [saveBtn setTitle:@"" forState:UIControlStateNormal];
            //            [okBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
            saveBtn.layer.cornerRadius = 43/2;
            
            UILabel * saveLab = [[UILabel alloc]initWithFrame:CGRectMake(125, 7, 80, 30 )];
            saveLab.text =@"SAVE";
            saveLab.font = FONT(16);
            [saveBtn addSubview:saveLab];
            saveLab.textColor = [UIColor whiteColor];
            //            [self.view addSubview:saveBtn];
        }
        
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5的大小");
//        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-60 );
        if (securityImageView == NULL) {
            securityImageView   = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 99)/2, 49, 99, 99)];
            securityImageView.image = [UIImage imageNamed:@"安全中心"];
            [self.view addSubview:securityImageView];
            [scrollView addSubview:securityImageView];
        }
        
        
        
        if (currentPINText == NULL) {
            
            currentInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 576/2)/2, securityImageView.frame.origin.y + 99 + 49, 576/2, 43)];
            currentInputTextView.layer.borderWidth = 1.0f;
            currentInputTextView.layer.cornerRadius = 43/2;
            currentInputTextView.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            
            currentPINText.delegate = self;
            currentPINText.autocorrectionType = UITextAutocorrectionTypeNo;
            currentPINText = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, currentInputTextView.frame.size.width - 20, 40)];
            
            currentPINText.placeholder = @"Current PIN";
            currentPINText.textColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1];
            
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:currentPINText];
            currentPINText.secureTextEntry = YES;
            [currentInputTextView addSubview:currentPINText];
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (setNewRouteText == NULL) {
            
            setNewInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 576/2)/2, currentInputTextView.frame.origin.y + 43 + 15, 576/2, 43)];
            setNewInputTextView.layer.borderWidth = 1.0f;
            setNewInputTextView.layer.cornerRadius = 43/2;
            setNewInputTextView.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            
            setNewRouteText.delegate = self;
            setNewRouteText.autocorrectionType = UITextAutocorrectionTypeNo;
            setNewRouteText = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, setNewInputTextView.frame.size.width - 20, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            setNewRouteText.placeholder = @"New PIN";
            setNewRouteText.textColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:setNewRouteText];
            setNewRouteText.secureTextEntry = YES;
            [setNewInputTextView addSubview:setNewRouteText];
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (confirmText == NULL) {
            
            ConfirmInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 576/2)/2, setNewInputTextView.frame.origin.y + 43 + 15, 576/2, 43)];
            ConfirmInputTextView.layer.borderWidth = 1.0f;
            ConfirmInputTextView.layer.cornerRadius = 43/2;
            ConfirmInputTextView.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            
            confirmText.delegate = self;
            confirmText.autocorrectionType = UITextAutocorrectionTypeNo;
            confirmText = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, ConfirmInputTextView.frame.size.width - 20, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            confirmText.placeholder = @"Confirm PIN";
            confirmText.textColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:confirmText];
            confirmText.secureTextEntry = YES;
            [ConfirmInputTextView addSubview:confirmText];
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        
        if (saveBtn == NULL) {
            saveBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            saveBtn.frame = CGRectMake((SCREEN_WIDTH - 576/2)/2, ConfirmInputTextView.frame.origin.y + 43 + 30, 576/2, 43);
            //            [okBtn setBackgroundColor:RGB(0xf5, 0xf5, 0xf5)];
            [saveBtn setBackgroundColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
            [saveBtn setTitle:@"" forState:UIControlStateNormal];
            //            [okBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
            saveBtn.layer.cornerRadius = 43/2;
            
            UILabel * saveLab = [[UILabel alloc]initWithFrame:CGRectMake(125, 7, 80, 30 )];
            saveLab.text =@"SAVE";
            saveLab.font = FONT(16);
            [saveBtn addSubview:saveLab];
            saveLab.textColor = [UIColor whiteColor];
            //            [self.view addSubview:saveBtn];
        }
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6 的大小");
        
        if (securityImageView == NULL) {
            securityImageView   = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 99)/2, 49, 99, 99)];
            securityImageView.image = [UIImage imageNamed:@"安全中心"];
                        [self.view addSubview:securityImageView];
            [scrollView addSubview:securityImageView];
        }
       

        
        if (currentPINText == NULL) {
            
            currentInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 576/2)/2, securityImageView.frame.origin.y + 99 + 49, 576/2, 43)];
            currentInputTextView.layer.borderWidth = 1.0f;
            currentInputTextView.layer.cornerRadius = 43/2;
            currentInputTextView.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            
            currentPINText.delegate = self;
            currentPINText.autocorrectionType = UITextAutocorrectionTypeNo;
            currentPINText = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, currentInputTextView.frame.size.width - 20, 40)];
        
            currentPINText.placeholder = @"Current PIN";
            currentPINText.textColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1];
            

            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:currentPINText];
            currentPINText.secureTextEntry = YES;
            [currentInputTextView addSubview:currentPINText];
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (setNewRouteText == NULL) {
            
            setNewInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 576/2)/2, currentInputTextView.frame.origin.y + 43 + 15, 576/2, 43)];
            setNewInputTextView.layer.borderWidth = 1.0f;
            setNewInputTextView.layer.cornerRadius = 43/2;
            setNewInputTextView.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            
            setNewRouteText.delegate = self;
            setNewRouteText.autocorrectionType = UITextAutocorrectionTypeNo;
            setNewRouteText = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, setNewInputTextView.frame.size.width - 20, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            setNewRouteText.placeholder = @"New PIN";
            setNewRouteText.textColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:setNewRouteText];
            setNewRouteText.secureTextEntry = YES;
            [setNewInputTextView addSubview:setNewRouteText];
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (confirmText == NULL) {
            
            ConfirmInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 576/2)/2, setNewInputTextView.frame.origin.y + 43 + 15, 576/2, 43)];
            ConfirmInputTextView.layer.borderWidth = 1.0f;
            ConfirmInputTextView.layer.cornerRadius = 43/2;
            ConfirmInputTextView.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            
            confirmText.delegate = self;
            confirmText.autocorrectionType = UITextAutocorrectionTypeNo;
            confirmText = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, ConfirmInputTextView.frame.size.width - 20, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            confirmText.placeholder = @"Confirm PIN";
            confirmText.textColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:confirmText];
            confirmText.secureTextEntry = YES;
            [ConfirmInputTextView addSubview:confirmText];
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        
        if (saveBtn == NULL) {
            saveBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            saveBtn.frame = CGRectMake((SCREEN_WIDTH - 576/2)/2, ConfirmInputTextView.frame.origin.y + 43 + 30, 576/2, 43);
            //            [okBtn setBackgroundColor:RGB(0xf5, 0xf5, 0xf5)];
            [saveBtn setBackgroundColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
            [saveBtn setTitle:@"" forState:UIControlStateNormal];
            //            [okBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
            saveBtn.layer.cornerRadius = 43/2;
            
            UILabel * saveLab = [[UILabel alloc]initWithFrame:CGRectMake(125, 7, 80, 30 )];
            saveLab.text =@"SAVE";
            saveLab.font = FONT(16);
            [saveBtn addSubview:saveLab];
            saveLab.textColor = [UIColor whiteColor];
            //            [self.view addSubview:saveBtn];
        }
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        if (securityImageView == NULL) {
            securityImageView   = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 99*1.1)/2, 49, 99*1.1, 99*1.1)];
            securityImageView.image = [UIImage imageNamed:@"安全中心"];
            [self.view addSubview:securityImageView];
            [scrollView addSubview:securityImageView];
        }
        
        
        
        if (currentPINText == NULL) {
            
            currentInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 576/2*1.1)/2, securityImageView.frame.origin.y + 99 + 49+30, 576/2*1.1, 43*1.1)];
            currentInputTextView.layer.borderWidth = 1.0f;
            currentInputTextView.layer.cornerRadius = 43/2*1.1;
            currentInputTextView.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            
            currentPINText.delegate = self;
            currentPINText.autocorrectionType = UITextAutocorrectionTypeNo;
            currentPINText = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, currentInputTextView.frame.size.width - 20, 40)];
            
            currentPINText.placeholder = @"Current PIN";
            currentPINText.textColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1];
            
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:currentPINText];
            currentPINText.secureTextEntry = YES;
            [currentInputTextView addSubview:currentPINText];
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (setNewRouteText == NULL) {
            
            setNewInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 576/2*1.1)/2, currentInputTextView.frame.origin.y + 43 + 15, 576/2*1.1, 43*1.1)];
            setNewInputTextView.layer.borderWidth = 1.0f;
            setNewInputTextView.layer.cornerRadius = 43/2*1.1;
            setNewInputTextView.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            
            setNewRouteText.delegate = self;
            setNewRouteText.autocorrectionType = UITextAutocorrectionTypeNo;
            setNewRouteText = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, setNewInputTextView.frame.size.width - 20, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            setNewRouteText.placeholder = @"New PIN";
            setNewRouteText.textColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:setNewRouteText];
            setNewRouteText.secureTextEntry = YES;
            [setNewInputTextView addSubview:setNewRouteText];
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        if (confirmText == NULL) {
            
            ConfirmInputTextView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 576/2*1.1)/2, setNewInputTextView.frame.origin.y + 43 + 15, 576/2*1.1, 43*1.1)];
            ConfirmInputTextView.layer.borderWidth = 1.0f;
            ConfirmInputTextView.layer.cornerRadius = 43/2*1.1;
            ConfirmInputTextView.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            
            confirmText.delegate = self;
            confirmText.autocorrectionType = UITextAutocorrectionTypeNo;
            confirmText = [[UITextField alloc]initWithFrame:CGRectMake(20, 4, ConfirmInputTextView.frame.size.width - 20, 40)];
            //
            //            inputText.layer.borderWidth = 1.0f;
            //            inputText.layer.cornerRadius = 20;
            //            inputText.layer.borderColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1].CGColor;
            confirmText.placeholder = @"Confirm PIN";
            confirmText.textColor = [UIColor colorWithRed:0xcB/255.0 green:0xcB/255.0 blue:0xcB/255.0 alpha:1];
            
            //            inputText = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 300, 300, 40)];
            //            inputText.image = [UIImage imageNamed:@"灰"];
            //            inputText.userInteractionEnabled = YES;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:confirmText];
            confirmText.secureTextEntry = YES;
            [ConfirmInputTextView addSubview:confirmText];
            //            [self.view addSubview:inputTextView];
            //            [inputTextView addSubview:inputText];
            //            [inputText bringSubviewToFront:inputTextView];
        }
        
        if (saveBtn == NULL) {
            saveBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
            saveBtn.frame = CGRectMake((SCREEN_WIDTH - 576/2*1.1)/2, ConfirmInputTextView.frame.origin.y + 43 + 30+18, 576/2*1.1, 43*1.1);
            //            [okBtn setBackgroundColor:RGB(0xf5, 0xf5, 0xf5)];
            [saveBtn setBackgroundColor:[UIColor colorWithRed:0x60/255.0 green:0xa3/255.0 blue:0xec/255.0 alpha:1]];
            [saveBtn setTitle:@"" forState:UIControlStateNormal];
            //            [okBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
            [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
            saveBtn.layer.cornerRadius = 43/2*1.1;
            
            UILabel * saveLab = [[UILabel alloc]initWithFrame:CGRectMake(125*1.1, 9, 80, 30 )];
            saveLab.text =@"SAVE";
            saveLab.font = FONT(16);
            [saveBtn addSubview:saveLab];
            saveLab.textColor = [UIColor whiteColor];
            //            [self.view addSubview:saveBtn];
        }
        
    }
    
   
}
-(void)loadUI
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [scrollView addGestureRecognizer:tapGesture];
    
    if ( [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是4s的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-50 );
        
    }else if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"]) {
        NSLog(@"此刻是5的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-110 );
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]   || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-128 );
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-128 );
    }
    
    //    [self addWlanInfo];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.Animating = NO;
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    currentPINText.text = @"";
    setNewRouteText.text = @"";
    confirmText.text = @"";
    
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

-(void)addToScroll
{
    [scrollView addSubview:securityImageView];
    [scrollView addSubview:saveBtn];
    [scrollView addSubview:currentInputTextView];
    [scrollView addSubview:setNewInputTextView];
    [scrollView addSubview:ConfirmInputTextView];
    
    currentPINText.delegate = self;
    setNewRouteText.delegate = self;
    confirmText.delegate = self;
}
-(void)onTap
{
    [currentPINText resignFirstResponder];
    [setNewRouteText resignFirstResponder];
    [confirmText resignFirstResponder];
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
-(void)saveBtnClick
{
    NSLog(@"点击了save按钮11");
    BOOL judgePINIsLegal =  [self judgePINIsLegal]; //判断输入框的PIN码是否和规定
    
    if (judgePINIsLegal == YES) {
        //
        //    NSString * DMSIP = [USER_DEFAULT objectForKey:@"HMC_DMSIP"];
        //        DMSIP = @"192.168.1.1";
        NSString * DMSIP = [USER_DEFAULT objectForKey:@"RouterPsw"];
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
        
        NSDictionary *  detailDic =[NSDictionary dictionaryWithObjectsAndKeys:currentPINText.text,@"old_pwd",confirmText.text,@"new_pwd",nil];//创建多个键 多个值
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:detailDic options:0 error:nil];
        //    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        
        [request setPostBody:tempJsonData];
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
                if ([[resDict objectForKey:@"code"] isEqual:@1]) {
                    //            registerPwdTip = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:code1] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confirm", nil];
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
                    //            registerPwdTip = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:code4] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confirm", nil];
                    [registerPwdTip show];
                }else if ([[resDict objectForKey:@"code"] isEqual:@0])
                {
                    [registerPwdTip setMessage:[NSString stringWithFormat:code0]];
                    [registerPwdTip show];
                    
                    //                [self judgeNextView];
                }
                
                
                
                
            }
        }];

    }
    
    
    
}
#pragma mark - 判断PIN码是否合规定
-(BOOL)judgePINIsLegal
{
    if (currentPINText.text.length == 0|| setNewRouteText.text.length == 0 || confirmText.text.length == 0) {
        //用户没有输入任何东西，弹窗提醒
        NSLog(@"输入的东西不能为空");
        UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:emptyStr] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confirm", nil];
        
        //    UIAlertView * linkAlert =   [[UIAlertView alloc] initWithTitle:@"Alert View"message:@"We Will Call" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSString stringWithFormat:@"22:%@",tel],[NSString stringWithFormat:@"00:%@",tel], nil];
        
        [linkAlert show];
    }else if(setNewRouteText.text.length < 6 || confirmText.text.length < 6)
    {
        UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:lengthLessStr] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confirm", nil];
        
        [linkAlert show];
        
    }else if (![setNewRouteText.text isEqualToString:confirmText.text])
    {
        UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:dontMatch] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confirm", nil];
        
        [linkAlert show];
        
    }else if ([setNewRouteText.text isEqualToString:@"MGadmin"])
    {
        UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:code1] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confirm", nil];
        
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
        //            UIAlertView * linkAlert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:specialStr] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Confirm", nil];
        //
        //            [linkAlert show];
        //        }else   //正确情况
        //        {
        //发送链接判断是不是正确
        return true;
        
    }
    //    }
    
}
#pragma mark - 防止textfield删除时，如果遇到密码模式，则单个删除，否则系统会一次全部删除
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    //得到输入框的内容
//    NSString * textfieldContent = [textField.text stringByReplacingCharactersInRange:range withString:string];
////    if (textField == currentPINText && textField.isSecureTextEntry && textField == setNewRouteText && textField == confirmText) {
//        textField.text = textfieldContent;
//        return NO;
////    }
////    return YES;
//}
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
    self.NetWorkErrorLab.text = @"NetWork Error";
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
@end
