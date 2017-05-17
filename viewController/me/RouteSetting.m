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
#import "ASIFormDataRequest.h"

#define TEXTFIELDIMAGE_X 40
#define TEXTFIELDIMAGE_WIDTH  (SCREEN_WIDTH-2*40)

#define TEXTFIELD_X 40+80.5
#define NAMETEXTFIELDIMAGE_Y   145+64 //84+26+147

#define PSWTEXTFIELDIMAGE_Y   145+64+60 //84+26+147+55
#define IPTEXTFIELDIMAGE_Y  84+26+147+55+55
#define SAVEBTN_Y    145+64+60+72  //84+26+147+55+55+105-88
#define SAVEBTN_X    31.5
//#define NAMETEXTFIELD_Y 84+26+147
@interface RouteSetting ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSString * DMSIP;
}
@property(nonatomic,strong) UIButton * pswBtn;
@property(nonatomic,strong) UITextField *  pswText;
@property(nonatomic,assign) bool isOn ;
@property(nonatomic,strong) UIButton * saveBtn;

@property(nonatomic,strong) UIImageView * nameTextFieldImage;
@property(nonatomic,strong) UIImageView * pswTextFieldImage;
@property(nonatomic,strong)NSDictionary * wifiChangeDic;  //wifi 字典
//@property(nonatomic,strong)UIAlertController * alertViewPsw;  //对于密码的判断框
//@property(nonatomic,strong)UIAlertController * alertViewPswZero;  //对于密码的判断框
@property(nonatomic,strong)UIAlertView * alertViewPsw;  //对于密码的判断框
@property(nonatomic,strong)UIAlertView * alertViewPswZero;  //对于密码的判断框

@end

@implementation RouteSetting
@synthesize pswBtn;
@synthesize pswText;
@synthesize isOn;
@synthesize saveBtn;
@synthesize nameText;
@synthesize nameTextFieldImage;
@synthesize pswTextFieldImage;
@synthesize wifiChangeDic; //post返回的数据
@synthesize alertViewPsw;
@synthesize alertViewPswZero;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isOn = NO;
//    [self loadNav];
    
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
    
    //////////////////////////// 从socket返回数据
    //此处接收到路由器IP地址的消息
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getSocketIpInfoNotice" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSocketIpInfo:) name:@"getSocketIpInfoNotice" object:nil];

    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"socketGetIPAddressNotific" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
}
- (void)getSocketIpInfo:(NSNotification *)text{
    
    NSData * socketIPData = text.userInfo[@"socketIPAddress"];
    NSData * ipStrData ;
    NSLog(@"socketIPData :%@",socketIPData);
    
    if (socketIPData != NULL  && socketIPData != nil  &&  socketIPData.length > 0 ) {
        
        if (socketIPData.length >38) {
          
            ipStrData = [socketIPData subdataWithRange:NSMakeRange(1 + 37,socketIPData.length - 38)];
            NSLog(@"ipStrData %@",ipStrData);
            
            DMSIP =  [[NSString alloc] initWithData:ipStrData  encoding:NSUTF8StringEncoding];
            NSLog(@" DMSIP %@",DMSIP);
            
            [self loadNav];
        }
        
    }
    
    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    
    [self.view endEditing:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //限制文本的输入长度不得大于10个字符长度
    if (nameText.text.length < 6 ){  //|| pswText.text.length < 8
        
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"save-不可"] forState:UIControlStateNormal];
        //        //截取文本字符长度为10的内容
        //        textField.text = [textField.text substringToIndex:10];
        saveBtn.enabled = NO;
    }else
    {
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        //        //截取文本字符长度为10的内容
        //        textField.text = [textField.text substringToIndex:10];
        saveBtn.enabled = YES;
    }
    
}

-(void)loadNav
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UIColor *placeHolderColor = RGBA(192, 192, 192, 0.3);
    
    self.navigationItem.title = @"Router management";
    UIImageView * routeImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-83.5)/2, 89, 83.5, 83.5)];
    routeImageView.image = [UIImage imageNamed:@"luyou"];
    
    //    NSError *error = nil;
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    //
    //    NSData *data = [NSData dataWithContentsOfFile:filePath ];
    //    routeImageView.backgroundColor = [UIColor clearColor];
    //    routeImageView.image= [UIImage sd_animatedGIFWithData:data];
    [self.view addSubview:routeImageView];
    
    
    
    
    
    //name
    nameTextFieldImage = [[UIImageView alloc]initWithFrame:CGRectMake(TEXTFIELDIMAGE_X, NAMETEXTFIELDIMAGE_Y, (SCREEN_WIDTH-2*TEXTFIELDIMAGE_X), 40)];
    nameTextFieldImage.image = [UIImage imageNamed:@"灰"];
    nameTextFieldImage.userInteractionEnabled = YES;
    [self.view addSubview:nameTextFieldImage];
    
    
    
    nameText.delegate = self;
    nameText.autocorrectionType = UITextAutocorrectionTypeNo;
    nameText = [[UITextField alloc]initWithFrame:CGRectMake(TEXTFIELD_X-50, 2, TEXTFIELDIMAGE_WIDTH - 80.5-40, 36)];
    
    nameText.text = _nameString;
    nameText.textColor = RGBA(148, 148, 148, 1);
    [nameTextFieldImage addSubview:nameText];
    [nameTextFieldImage bringSubviewToFront:nameText];
    //    nameText.textColor = RGBA(58, 142, 233, 1);
    nameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Route Name" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    [nameText addTarget:self action:@selector(nameLimit:) forControlEvents:UIControlEventEditingChanged];
    [nameText addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventEditingDidBegin];
    [nameText addTarget:self action:@selector(endChange:) forControlEvents:UIControlEventEditingDidEnd];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:nameText];
    
    
    UIImageView * SnameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10.5, 17,17)];
    SnameImageView.image = [UIImage imageNamed:@"mingcheng"];
    SnameImageView.userInteractionEnabled = YES;
    [nameTextFieldImage addSubview:SnameImageView];
    
    
    
    
    //psw
    pswTextFieldImage = [[UIImageView alloc]initWithFrame:CGRectMake(TEXTFIELDIMAGE_X, PSWTEXTFIELDIMAGE_Y, (SCREEN_WIDTH-2*TEXTFIELDIMAGE_X), 40)];
    pswTextFieldImage.image = [UIImage imageNamed:@"灰"];
    pswTextFieldImage.userInteractionEnabled = YES;
    [self.view addSubview:pswTextFieldImage];
    
    
    pswText.delegate = self;
    pswText.autocorrectionType = UITextAutocorrectionTypeNo;
    pswText = [[UITextField alloc]initWithFrame:CGRectMake(TEXTFIELD_X-50, 2, TEXTFIELDIMAGE_WIDTH - 80.5-40, 36)];
    
    [pswTextFieldImage addSubview:pswText];
    [pswTextFieldImage bringSubviewToFront:pswText];
    pswText.textColor = RGBA(58, 142, 233, 1);
    pswText.secureTextEntry = YES;
    pswText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    [pswText addTarget:self action:@selector(limit:) forControlEvents:UIControlEventEditingChanged];
    [pswText addTarget:self action:@selector(onChangepsw:) forControlEvents:UIControlEventEditingDidBegin];
    [pswText addTarget:self action:@selector(endChangepsw:) forControlEvents:UIControlEventEditingDidEnd];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:pswText];
    
    UIImageView * SpswImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10.5, 15.5,19)];
    SpswImageView.image = [UIImage imageNamed:@"mima"];
    SpswImageView.userInteractionEnabled = YES;
    [pswTextFieldImage addSubview:SpswImageView];
    
    pswBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pswBtn.frame = CGRectMake(261-6, 3, 34, 34);
//    [pswBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    [pswBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    
    [pswBtn addTarget:self action:@selector(pswBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pswTextFieldImage addSubview:pswBtn];
    
    
    //IP
    //    UIImageView * ipTextFieldImage = [[UIImageView alloc]initWithFrame:CGRectMake(TEXTFIELDIMAGE_X, IPTEXTFIELDIMAGE_Y, (SCREEN_WIDTH-2*TEXTFIELDIMAGE_X), 40)];
    //    ipTextFieldImage.image = [UIImage imageNamed:@"组-54"];
    //    ipTextFieldImage.userInteractionEnabled = YES;
    //    [self.view addSubview:ipTextFieldImage];
    //
    //
    //    UITextField *  ipText = [[UITextField alloc]initWithFrame:CGRectMake(TEXTFIELD_X-40, 2, TEXTFIELDIMAGE_WIDTH - 80.5-60, 36)];
    //    [ipTextFieldImage addSubview:ipText];
    //    [ipTextFieldImage bringSubviewToFront:ipText];
    //    ipText.textColor = RGBA(58, 142, 233, 1);
    ////    ipText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"IP Address" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    //    ipText.text = @"192.168.1.1";
    //    ipText.enabled = NO;
    
    
    //    UIImageView * SipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10.5, 19,19)];
    //    SipImageView.image = [UIImage imageNamed:@"ip"];
    //    SipImageView.userInteractionEnabled = YES;
    //    [ipTextFieldImage addSubview:SipImageView];
    
    //save
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(SAVEBTN_X, SAVEBTN_Y, (SCREEN_WIDTH-2*SAVEBTN_X), 58);
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"save-不可"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    saveBtn.titleLabel.text = @"SAVE";
    //    [saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
    //    saveBtn.titleLabel.font = FONT(15);
    //    saveBtn.backgroundColor = RGBA(96, 163, 236, 1);
    //    saveBtn.layer.cornerRadius = 20.0;
    saveBtn.enabled = NO;
    [self.view addSubview:saveBtn];
    
    
    
}


-(void)saveBtnClick
{
    if (pswText.text.length == 0) {
        alertViewPswZero = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you do not set the router password?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil];
//        [alertViewPswZero addButtonWithTitle:@"OK"];
        [alertViewPswZero show];
        
        
        //==========
//        alertViewPswZero = [UIAlertController alertControllerWithTitle:nil  message:@"Are you sure you do not set the router password?" preferredStyle:UIAlertControllerStyleAlert];
//        
//        
//        NSMutableAttributedString *alertMessageStr = [[NSMutableAttributedString alloc] initWithString:@"Are you sure you do not set the router password?"];
//        [alertMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, [[alertMessageStr string] length])];
//        [alertMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [[alertMessageStr string] length])];
//        [alertViewPswZero setValue:alertMessageStr forKey:@"attributedMessage"];
//        //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
//        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        //            [defaultAction setValue:[UIColor blueColor] forKey:@"_titleTextColor"];
//        
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//        //
//        //            [cancelAction setValue:[UIColor greenColor] forKey:@"_titleTextColor"];
//        
//        [alertViewPswZero addAction:defaultAction];
//        [alertViewPswZero addAction:cancelAction];
//        
//        [self presentViewController:alertViewPswZero animated:YES completion:nil];
        

        return;
    }
    if (pswText.text.length<8 &&pswText.text.length>=1) {
          alertViewPsw = [[UIAlertView alloc]initWithTitle:@"" message:@"Please enter 8 to 16 passwords" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertViewPsw addButtonWithTitle:@"OK"];
        [alertViewPsw show];
        
        //====
//        alertViewPsw = [UIAlertController alertControllerWithTitle:nil  message:@"Please enter 8 to 16 passwords" preferredStyle:UIAlertControllerStyleAlert];
//        
//        
//        NSMutableAttributedString *alertMessageStr = [[NSMutableAttributedString alloc] initWithString:@"Please enter 8 to 16 passwords"];
//        [alertMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, [[alertMessageStr string] length])];
//        [alertMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [[alertMessageStr string] length])];
//        [alertViewPsw setValue:alertMessageStr forKey:@"attributedMessage"];
//        //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
//        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        //            [defaultAction setValue:[UIColor blueColor] forKey:@"_titleTextColor"];
//        
//        //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//        //
//        //            [cancelAction setValue:[UIColor greenColor] forKey:@"_titleTextColor"];
//        
//        [alertViewPsw addAction:defaultAction];
//        //            [alertController addAction:cancelAction];
//        
//        [self presentViewController:alertViewPsw animated:YES completion:nil];
//        
        return;
    }else{
    NSLog(@"点击了save按钮11");
//
//    NSString * DMSIP = [USER_DEFAULT objectForKey:@"HMC_DMSIP"];
//        DMSIP = @"192.168.1.1";
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
    //     NSString *parameterString = [NSString stringWithFormat:@"name=%@&password=%@",name,psw];
    //    NSData *data = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *  detailDic =[NSDictionary dictionaryWithObjectsAndKeys:nameText.text,@"name",pswText.text,@"password",nil];//创建多个键 多个值
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:detailDic options:0 error:nil];
    //    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    
    [request setPostBody:tempJsonData];
    [request startSynchronous];
    NSError *error1 = [request error];
    if (!error1) {
        NSString *response = [request responseString];
        NSLog(@"Test：%@",response);
        [USER_DEFAULT setObject:nameText.text forKey:@"routeNameUSER"];
    }
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == alertViewPswZero) {
        if (buttonIndex ==1) {
            //执行确定操作
            
            NSLog(@"点击了save按钮");
            
//            NSString * DMSIP = @"192.168.1.1";
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
            //     NSString *parameterString = [NSString stringWithFormat:@"name=%@&password=%@",name,psw];
            //    NSData *data = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
            
//            pswText.text = @"12345678";
//            pswText.text = @"none";
            NSDictionary *  detailDic =[NSDictionary dictionaryWithObjectsAndKeys:nameText.text,@"name",@"none",@"password",nil];//创建多个键 多个值
            
            
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:detailDic options:0 error:nil];
            
            //    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
            
            [request setPostBody:tempJsonData];
            [request startSynchronous];
            NSError *error1 = [request error];
            if (!error1) {
                NSString *response = [request responseString];
                NSLog(@"Test：%@",response);
                [USER_DEFAULT setObject:nameText.text forKey:@"routeNameUSER"];
            }
        }
        else
        {
           //执行否定操作
        }
    }
}

-(void)pswBtnClick
{
    if (isOn == YES) {
        isOn = NO;
        pswText.secureTextEntry = YES;
//        [pswBtn setBackgroundImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        [pswBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    }
    else if (isOn == NO)
    {
        isOn = YES;
        pswText.secureTextEntry = NO;
//        [pswBtn setBackgroundImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
        [pswBtn setImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
    }
    
    NSLog(@"点击了眼睛按钮");
}
//限制密码文本框的输入内容和文本的长度
- (void)limit:(UITextField *)textField{
    
    //限制文本的输入长度不得大于10个字符长度
    if ( nameText.text.length < 6){ //textField.text.length < 8 ||
        
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"save-不可"] forState:UIControlStateNormal];
        //        //截取文本字符长度为10的内容
        //        textField.text = [textField.text substringToIndex:10];
        saveBtn.enabled = NO;
    }
    if (nameText.text.length>=6 ){ //textField.text.length >= 8  &&
        
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        //        //截取文本字符长度为10的内容
        //        textField.text = [textField.text substringToIndex:10];
        
        saveBtn.enabled = YES;
    }
}

//限制名字
-(void)nameLimit:(UITextField *)textField{
    
    
    //限制文本的输入长度不得大于10个字符长度
    if (textField.text.length < 6 ){  //|| pswText.text.length < 8
        
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"save-不可"] forState:UIControlStateNormal];
        //        //截取文本字符长度为10的内容
        //        textField.text = [textField.text substringToIndex:10];
        saveBtn.enabled = NO;
    }
    if (textField.text.length >= 6   ){ //&&pswText.text.length>=8
        
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        //        //截取文本字符长度为10的内容
        //        textField.text = [textField.text substringToIndex:10];
        saveBtn.enabled = YES;
    }
    
}
-(void)onChange:(UITextField *)textField{
    nameText.textColor = RGBA(58, 142, 233, 1);
    nameTextFieldImage.image = [UIImage imageNamed:@"组-54"];
    
}
-(void)endChange:(UITextField *)textField{
    
    nameTextFieldImage.image = [UIImage imageNamed:@"灰"];
    nameText.textColor = RGBA(148, 148, 148, 1);
}
-(void)onChangepsw:(UITextField *)textField{
    pswText.textColor = RGBA(58, 142, 233, 1);
    pswTextFieldImage.image = [UIImage imageNamed:@"组-54"];
    
}
-(void)endChangepsw:(UITextField *)textField{
    pswText.textColor = RGBA(148, 148, 148, 1);
    pswTextFieldImage.image = [UIImage imageNamed:@"灰"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//6--16
//8--16


@end
