//
//  RouteCell.h
//  StarAPP
//
//  Created by xyz on 2016/11/10.
//
//

#import <UIKit/UIKit.h>

@interface RouteCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIImageView *deviceImage;

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *deviceIPLab;

@property (weak, nonatomic) IBOutlet UILabel *deviceMacLab;
@property (weak, nonatomic) IBOutlet UILabel *ip;
@property (weak, nonatomic) IBOutlet UILabel *mac;


+ (id)loadFromNib;

+ (NSString*)reuseIdentifier;

+ (CGFloat)defaultCellHeight;

@end
