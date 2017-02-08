//
//  RouteCell.m
//  StarAPP
//
//  Created by xyz on 2016/11/10.
//
//

#import "RouteCell.h"

@implementation RouteCell

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

    
    self.deviceImage.image = [UIImage imageNamed:@"routenoKnow1"];
    //
        self.deviceNameLab.text = [_dataDic objectForKey:@"hostname"];
        self.deviceIPLab.text = [_dataDic objectForKey:@"ip"]  ;
        self.deviceMacLab.text = [_dataDic objectForKey:@"mac"];
        self.ip.text = @"ip:";
        self.mac.text = @"mac:";
    
        self.deviceNameLab.textColor = RGBA(148, 148, 148, 1);
        self.deviceIPLab.textColor = RGBA(193, 193, 193, 1);
        self.deviceMacLab.textColor = RGBA(193, 193, 193, 1);

        self.ip.textColor = RGBA(193, 193, 193, 1);
        self.mac.textColor = RGBA(193, 193, 193, 1);
}


@end
