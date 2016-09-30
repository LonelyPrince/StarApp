//
//  DeviceManageCell.m
//  StarAPP
//
//  Created by xyz on 16/9/29.
//
//

#import "DeviceManageCell.h"


@interface DeviceManageCell()
@end

@implementation DeviceManageCell
+ (id)loadFromNib
{
    NSString *xibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] firstObject];
}

+ (NSString*)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

+ (CGFloat)defaultCellHeight
{
    return 100;
}
- (void)awakeFromNib {
    [super awakeFromNib];
   
    // Initialization code
}
-(void) setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    
//    NSString *address = [NSString stringWithFormat:@"%@.%@",self.dataDic[@"address"],self.dataDic[@"poi_name"]];
//    
   // self.name.text = dataDic[@"title"];
   
    self.deviceName.text = @"1";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
