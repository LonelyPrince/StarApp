//
//  DeviceManageCell.h
//  StarAPP
//
//  Created by xyz on 16/9/29.
//
//

#import <UIKit/UIKit.h>

@interface DeviceManageCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *deviceName;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (weak, nonatomic) IBOutlet UILabel *IPAddress;
@property (weak, nonatomic) IBOutlet UILabel *UUID;

+ (id)loadFromNib;

+ (NSString*)reuseIdentifier;

+ (CGFloat)defaultCellHeight;

@end
