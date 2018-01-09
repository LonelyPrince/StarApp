//
//  DeviceListCell.m
//  StarAPP
//
//  Created by xyz on 2017/10/30.
//

#import "DeviceListCell.h"

@implementation DeviceListCell

+ (id)loadFromNib
{
    NSString *xibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] firstObject];
}
+ (NSString*)reuseIdentifier
{
    return NSStringFromClass([self class]);
}
//设置接口数据
-(void) setDataDic:(NSDictionary *)dataDic
{
    deviceString = [GGUtil deviceVersion];
    
    if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"] || [deviceString isEqualToString:@"iPhone8 Plus"]) {
        self.DeviceNameLab.font = FONT(16);
        self.DeviceIPLab.font = FONT(14);
        self.DeviceMACLab.font = FONT(14);
        self.DeviceIPLab.frame = CGRectMake(63, 40, 130, 21);
        self.DeviceMACLab.frame = CGRectMake(230, 40, 200, 21);
        self.DeviceImage.frame = CGRectMake(19, 24, 31, 31);
    }
    _dataDic = dataDic;
    self.userInteractionEnabled = NO;
    
    
    //    self.deviceImage.image = [UIImage imageNamed:@"routenoKnow1"];
    //
    self.DeviceNameLab.text = [_dataDic objectForKey:@"hostname"];
    self.DeviceIPLab.text = [NSString stringWithFormat:@"IP:%@",[_dataDic objectForKey:@"ip"]] ;
    self.DeviceMACLab.text = [NSString stringWithFormat:@"MAC:%@",[_dataDic objectForKey:@"mac"]];
    //    self.ip.text = @"ip:";
    //    self.mac.text = @"mac:";
    
    self.DeviceNameLab.textColor = RGBA(0x46, 0x46, 0x46, 1);
    self.DeviceIPLab.textColor = RGBA(193, 193, 193, 1);
    self.DeviceMACLab.textColor = RGBA(193, 193, 193, 1);
    
    //    self.ip.textColor = RGBA(193, 193, 193, 1);
    //    self.mac.textColor = RGBA(193, 193, 193, 1);
}

@end

