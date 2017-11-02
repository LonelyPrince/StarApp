//
//  WLANSettingView.h
//  StarAPP
//
//  Created by xyz on 2017/10/19.
//

#import <UIKit/UIKit.h>

@interface WLANSettingView : UIViewController<UITextFieldDelegate,UITextInputDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIImageView * WLANImageView;

@property(nonatomic,strong)UIView * nameInputTextView;
@property(nonatomic,strong)UIView * pswInputTextView;
@property(nonatomic,strong)UIView * securityInputTextView;
@property(nonatomic,strong)UIView * PINInputTextView;

@property(nonatomic,strong) UITextField *  setNameText;
@property(nonatomic,strong) UITextField *  setPswText;

@property(nonatomic,strong) UIImageView *  nameEidtImageView;
@property(nonatomic,strong) UIImageView *  pswEidtImageView;
@property(nonatomic,strong) UILabel *  SecurityLab;
@property(nonatomic,strong) UILabel *  PINLab;
@property(nonatomic,strong) UILabel *  SecurityStatusLab;   //security状态Lab

@property(nonatomic,strong) UISwitch *  PINSwitch;  //PIN的开关锁

@property(nonatomic,strong) UIButton *  isViewBtn;  //密码是否可见的button
@property(nonatomic,strong) UIScrollView *  scrollView; 

@property(nonatomic,strong) UIButton *  saveBtn;  
@property(nonatomic,assign) bool isOn ;

@property(nonatomic,strong)UIView * NetWorkErrorView;
@property(nonatomic,strong)UIImageView * NetWorkErrorImageView;
@property(nonatomic,strong)UILabel * NetWorkErrorLab;

@end
