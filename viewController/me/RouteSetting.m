//
//  RouteSetting.m
//  StarAPP
//
//  Created by xyz on 2016/10/26.
//
//

#import "RouteSetting.h"
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImage+GIF.h"

#define TEXTFIELDIMAGE_X 40
#define TEXTFIELDIMAGE_WIDTH  (SCREEN_WIDTH-2*40)

#define TEXTFIELD_X 40+80.5
#define NAMETEXTFIELDIMAGE_Y  84+26+147

#define PSWTEXTFIELDIMAGE_Y  84+26+147+55
#define IPTEXTFIELDIMAGE_Y  84+26+147+55+55
#define SAVEBTN_Y  84+26+147+55+55+105
#define SAVEBTN_X    31.5
//#define NAMETEXTFIELD_Y 84+26+147
@interface RouteSetting ()
@property(nonatomic,strong) UIButton * pswBtn;
@property(nonatomic,strong) UITextField *  pswText;
@property(nonatomic,assign) bool isOn ;
@property(nonatomic,strong) UIButton * saveBtn;
@end

@implementation RouteSetting
@synthesize pswBtn;
@synthesize pswText;
@synthesize isOn;
@synthesize saveBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isOn = NO;
    [self loadNav];
}


-(void)loadNav
{
    
    UIColor *placeHolderColor = RGBA(192, 192, 192, 0.3);
    
    self.navigationItem.title = @"Roter management";
    UIImageView * routeImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-147)/2, 84, 147, 147)];
    routeImageView.image = [UIImage imageNamed:@"组-55"];

//    NSError *error = nil;
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
//    
//    NSData *data = [NSData dataWithContentsOfFile:filePath ];
//    routeImageView.backgroundColor = [UIColor clearColor];
//    routeImageView.image= [UIImage sd_animatedGIFWithData:data];
    [self.view addSubview:routeImageView];
    
  
 
    

    //name
    UIImageView * nameTextFieldImage = [[UIImageView alloc]initWithFrame:CGRectMake(TEXTFIELDIMAGE_X, NAMETEXTFIELDIMAGE_Y, (SCREEN_WIDTH-2*TEXTFIELDIMAGE_X), 40)];
    nameTextFieldImage.image = [UIImage imageNamed:@"组-54"];
    nameTextFieldImage.userInteractionEnabled = YES;
    [self.view addSubview:nameTextFieldImage];
    
    
   
    
    UITextField *  nameText = [[UITextField alloc]initWithFrame:CGRectMake(TEXTFIELD_X-40, 2, TEXTFIELDIMAGE_WIDTH - 80.5-60, 36)];
    
    [nameTextFieldImage addSubview:nameText];
    [nameTextFieldImage bringSubviewToFront:nameText];
    nameText.textColor = RGBA(58, 142, 233, 1);
    nameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Route Name" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    
    UIImageView * SnameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10.5, 19,19)];
    SnameImageView.image = [UIImage imageNamed:@"Edit-256"];
    SnameImageView.userInteractionEnabled = YES;
    [nameTextFieldImage addSubview:SnameImageView];
    
    
    
    
    //psw
    UIImageView * pswTextFieldImage = [[UIImageView alloc]initWithFrame:CGRectMake(TEXTFIELDIMAGE_X, PSWTEXTFIELDIMAGE_Y, (SCREEN_WIDTH-2*TEXTFIELDIMAGE_X), 40)];
    pswTextFieldImage.image = [UIImage imageNamed:@"组-54"];
    pswTextFieldImage.userInteractionEnabled = YES;
    [self.view addSubview:pswTextFieldImage];
    
    
    pswText = [[UITextField alloc]initWithFrame:CGRectMake(TEXTFIELD_X-40, 2, TEXTFIELDIMAGE_WIDTH - 80.5-60, 36)];
    
    [pswTextFieldImage addSubview:pswText];
    [pswTextFieldImage bringSubviewToFront:pswText];
    pswText.textColor = RGBA(58, 142, 233, 1);
    pswText.secureTextEntry = YES;
    pswText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
      [pswText addTarget:self action:@selector(limit:) forControlEvents:UIControlEventEditingChanged];
    
    
    UIImageView * SpswImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10.5, 19,19)];
    SpswImageView.image = [UIImage imageNamed:@"password"];
    SpswImageView.userInteractionEnabled = YES;
    [pswTextFieldImage addSubview:SpswImageView];
    
    pswBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pswBtn.frame = CGRectMake(261, 13, 19, 12.5);
    [pswBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    [pswBtn addTarget:self action:@selector(pswBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pswTextFieldImage addSubview:pswBtn];
    
    
    //IP
    UIImageView * ipTextFieldImage = [[UIImageView alloc]initWithFrame:CGRectMake(TEXTFIELDIMAGE_X, IPTEXTFIELDIMAGE_Y, (SCREEN_WIDTH-2*TEXTFIELDIMAGE_X), 40)];
    ipTextFieldImage.image = [UIImage imageNamed:@"组-54"];
    ipTextFieldImage.userInteractionEnabled = YES;
    [self.view addSubview:ipTextFieldImage];
    
    
    UITextField *  ipText = [[UITextField alloc]initWithFrame:CGRectMake(TEXTFIELD_X-40, 2, TEXTFIELDIMAGE_WIDTH - 80.5-60, 36)];
    [ipTextFieldImage addSubview:ipText];
    [ipTextFieldImage bringSubviewToFront:ipText];
    ipText.textColor = RGBA(58, 142, 233, 1);
//    ipText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"IP Address" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    ipText.text = @"192.168.1.1";
    ipText.enabled = NO;
    
    
    UIImageView * SipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10.5, 19,19)];
    SipImageView.image = [UIImage imageNamed:@"ip"];
    SipImageView.userInteractionEnabled = YES;
    [ipTextFieldImage addSubview:SipImageView];
    
    //save
    
      saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(SAVEBTN_X, SAVEBTN_Y, (SCREEN_WIDTH-2*SAVEBTN_X), 58);
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
       [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    saveBtn.titleLabel.text = @"SAVE";
//    [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
//    saveBtn.titleLabel.font = FONT(15);
//    saveBtn.backgroundColor = RGBA(96, 163, 236, 1);
//    saveBtn.layer.cornerRadius = 20.0;
    
    [self.view addSubview:saveBtn];
     
   
}


-(void)saveBtnClick
{
    NSLog(@"点击了save按钮");
}
-(void)pswBtnClick
{
    if (isOn == YES) {
        isOn = NO;
        pswText.secureTextEntry = YES;
        [pswBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    }
    else if (isOn == NO)
    {
        isOn = YES;
        pswText.secureTextEntry = NO;
        [pswBtn setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
    }
    
    NSLog(@"点击了眼睛按钮");
}
//限制密码文本框的输入内容和文本的长度
- (void)limit:(UITextField *)textField{
    
    //限制文本的输入长度不得大于10个字符长度
    if (textField.text.length < 8){
 
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"save-不可@3x"] forState:UIControlStateNormal];
//        //截取文本字符长度为10的内容
//        textField.text = [textField.text substringToIndex:10];
    }
    if (textField.text.length >= 8){
        
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        //        //截取文本字符长度为10的内容
        //        textField.text = [textField.text substringToIndex:10];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
