//
//  RouterStatusView.h
//  StarAPP
//
//  Created by xyz on 2017/10/30.
//

#import <UIKit/UIKit.h>

@interface RouterStatusView : UIViewController

@property(nonatomic,strong) IBOutlet UILabel * HardwareVersionLab;
@property(nonatomic,strong) IBOutlet UILabel * SortwareVersionLab;
@property(nonatomic,strong) IBOutlet UILabel * BuildDataLab;
@property(nonatomic,strong) IBOutlet UILabel * SerialNumberLab;
@property(nonatomic,strong) IBOutlet UILabel * MacAddressLab;
@property(nonatomic,strong) IBOutlet UILabel * SubnetMaskLab;
@property(nonatomic,strong) IBOutlet UILabel * IPAddressLab;

@property(nonatomic,strong)NSDictionary * wifiDic;  //wifi 字典
@property(nonatomic,strong)NSDictionary * wifiName;  //wifi 名字
@property(nonatomic,strong)NSDictionary * wifiIP;  //wifi IP地址
@property(nonatomic,strong)NSDictionary * wifiPwd;  //wifi 密码

@property(nonatomic,strong)UIView * NetWorkErrorView;
@property(nonatomic,strong)UIImageView * NetWorkErrorImageView;
@property(nonatomic,strong)UILabel * NetWorkErrorLab;
@end
