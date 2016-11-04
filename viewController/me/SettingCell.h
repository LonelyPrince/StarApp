//
//  SettingCell.h
//  StarAPP
//
//  Created by xyz on 2016/10/26.
//
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UIImageView *settingImage;
@property (weak, nonatomic) IBOutlet UILabel *blackLab;
@property (weak, nonatomic) IBOutlet UILabel *grayLab;


+ (id)loadFromNib;


+ (NSString*)reuseIdentifier;

@end
