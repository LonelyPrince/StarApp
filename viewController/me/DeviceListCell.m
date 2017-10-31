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
    _dataDic = dataDic;
    self.userInteractionEnabled = NO;

    
//    self.deviceImage.image = [UIImage imageNamed:@"routenoKnow1"];
    //
    self.DeviceNameLab.text = [_dataDic objectForKey:@"hostname"];
    self.DeviceIPLab.text = [NSString stringWithFormat:@"IP:%@",[_dataDic objectForKey:@"ip"]] ;
    self.DeviceMACLab.text = [NSString stringWithFormat:@"MAC:%@",[_dataDic objectForKey:@"mac"]];
//    self.ip.text = @"ip:";
//    self.mac.text = @"mac:";
    
    self.DeviceNameLab.textColor = RGBA(148, 148, 148, 1);
    self.DeviceIPLab.textColor = RGBA(193, 193, 193, 1);
    self.DeviceMACLab.textColor = RGBA(193, 193, 193, 1);
    
//    self.ip.textColor = RGBA(193, 193, 193, 1);
//    self.mac.textColor = RGBA(193, 193, 193, 1);
}

@end
