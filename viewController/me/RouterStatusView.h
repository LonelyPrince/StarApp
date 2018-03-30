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
@property(nonatomic,strong) IBOutlet UILabel * ManufacturerId;

@property(nonatomic,strong)NSDictionary * wifiDic;  //wifi 字典
@property(nonatomic,strong)NSDictionary * wifiName;  //wifi 名字
@property(nonatomic,strong)NSDictionary * wifiIP;  //wifi IP地址
@property(nonatomic,strong)NSDictionary * wifiPwd;  //wifi 密码

@property(nonatomic,strong)UIView * NetWorkErrorView;
@property(nonatomic,strong)UIImageView * NetWorkErrorImageView;
@property(nonatomic,strong)UILabel * NetWorkErrorLab;

@property (weak, nonatomic) IBOutlet UILabel *MHardVersion;
@property (weak, nonatomic) IBOutlet UILabel *MSoftwareVersion;
@property (weak, nonatomic) IBOutlet UILabel *MBuildData;
@property (weak, nonatomic) IBOutlet UILabel *MSerialNum;
@property (weak, nonatomic) IBOutlet UILabel *MMACAddress;
@property (weak, nonatomic) IBOutlet UILabel *MSubnetMask;
@property (weak, nonatomic) IBOutlet UILabel *MIPAddress;
@property (weak, nonatomic) IBOutlet UILabel *ManufacturerIdLab;


@end
