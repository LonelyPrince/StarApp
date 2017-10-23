//
//  SecurityCenterView.h
//  StarAPP
//
//  Created by xyz on 2017/10/23.
//

#import <UIKit/UIKit.h>

@interface SecurityCenterView : UIViewController<UITextFieldDelegate,UITextInputDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong) UIImageView *  securityImageView;    //顶部的安全图标


@property(nonatomic,strong)UIView * currentInputTextView;      //当前Route PIN的inputview
@property(nonatomic,strong)UIView * setNewInputTextView;
@property(nonatomic,strong)UIView * ConfirmInputTextView;

@property(nonatomic,strong) UITextField *  currentPINText;    //input route pin
@property(nonatomic,strong) UITextField *  setNewRouteText;    //New route pin
@property(nonatomic,strong) UITextField *  confirmText;    //confirm route pin
@property(nonatomic,strong) UIButton *  saveBtn;    //confirm route pin

@property(nonatomic,strong)UIAlertView * registerPwdTip;     //新注册密码时的提醒

//@property(nonatomic,strong)UILabel * setNewRouteLab;      //注册页面的Lab文字

//@property(nonatomic,strong) RouteMenuView * routeMenuView;  //route的主要操作界面
//
//@property(nonatomic,strong)UILabel * routeNameLab;
//@property(nonatomic,strong)UILabel * routeIPLab;
//
//@property(nonatomic,strong)NSDictionary * wifiDic;  //wifi 字典
//@property(nonatomic,strong)NSDictionary * wifiName;  //wifi 名字
//@property(nonatomic,strong)NSDictionary * wifiIP;  //wifi IP地址
//@property(nonatomic,strong)NSDictionary * wifiPwd;  //wifi 密码

@end
