//
//  DeviceListCell.h
//  StarAPP
//
//  Created by xyz on 2017/10/30.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
#import "ServiceModel.h"

@interface DeviceListCell : UITableViewCell
{
    NSString * deviceString;     //用于判断手机型号
}
@property (weak, nonatomic) IBOutlet UIImageView *DeviceImage;
@property (weak, nonatomic) IBOutlet UILabel *DeviceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *DeviceIPLab;
@property (weak, nonatomic) IBOutlet UILabel *DeviceMACLab;


@property (nonatomic, strong) NSDictionary *dataDic;

+ (id)loadFromNib;

+ (NSString*)reuseIdentifier;

+ (CGFloat)defaultCellHeight;

@end
