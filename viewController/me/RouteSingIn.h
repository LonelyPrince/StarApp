//
//  RouteSingIn.h
//  StarAPP
//
//  Created by xyz on 2017/10/16.
//

#import <UIKit/UIKit.h>
#import "RouteMenuView.h"

@interface RouteSingIn : UIViewController<UITextFieldDelegate,UITextInputDelegate>

@property (strong,nonatomic)UIView * activeView;    //无网络的显示

@property(nonatomic,strong) UIImageView *  securityImageView;    //顶部的安全图标
//正常进入情况
@property(nonatomic,strong) UITextField *  inputText;    //input route pin
@property(nonatomic,strong) UIButton *  okBtn;    //confirm route pin

//第一次进入，需要新建一个PIN
@property(nonatomic,strong) UITextField *  setNewRouteText;    //New route pin
@property(nonatomic,strong) UITextField *  confirmText;    //confirm route pin
@property(nonatomic,strong) UIButton *  saveBtn;    //confirm route pin

@property(nonatomic,strong)UIView * inputTextView;      //登录页面的inputview
@property(nonatomic,strong)UIView * inputTextView1;      //登录页面的inputview
@property(nonatomic,strong)UIView * inputTextView2;      //登录页面的inputview

@property(nonatomic,strong)UILabel * setNewRouteLab;      //注册页面的Lab文字
@property(nonatomic,strong)UIAlertView * registerPwdTip;     //新注册密码时的提醒
@property(nonatomic,strong) RouteMenuView * routeMenuView;  //route的主要操作界面

@property(nonatomic,strong)UILabel * routeNameLab;
@property(nonatomic,strong)UILabel * routeIPLab;

@property(nonatomic,strong)NSDictionary * wifiDic;  //wifi 字典
@property(nonatomic,strong)NSDictionary * wifiName;  //wifi 名字
@property(nonatomic,strong)NSDictionary * wifiIP;  //wifi IP地址
@property(nonatomic,strong)NSDictionary * wifiPwd;  //wifi 密码


@end
