//
//  BackupRestoreView.h
//  StarAPP
//
//  Created by xyz on 2017/10/31.
//

#import <UIKit/UIKit.h>

@interface BackupRestoreView : UIViewController


@property(nonatomic,strong)NSDictionary * wifiDic;  //wifi 字典
@property(nonatomic,strong)NSString * BackupStatusString;

@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,strong)UILabel * backUPLab;
@property(nonatomic,strong)UILabel * backUPInfoLab;
@property(nonatomic,strong)UIView * grayView;
@property(nonatomic,strong)UIButton * restoreBtn;
@property(nonatomic,strong)UIButton * backUpBtn;

@property(nonatomic,strong)UIView * NetWorkErrorView;
@property(nonatomic,strong)UIImageView * NetWorkErrorImageView;
@property(nonatomic,strong)UILabel * NetWorkErrorLab;
@end
