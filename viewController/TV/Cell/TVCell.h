//
//  TVCell.h
//  StarAPP
//
//  Created by xyz on 16/9/7.
//
//

#import <UIKit/UIKit.h>

@interface TVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *channelImg;

@property (weak, nonatomic) IBOutlet UIImageView *event_Img;
@property (weak, nonatomic) IBOutlet UIImageView *event_nextImg;

@property (weak, nonatomic) IBOutlet UILabel *event_nameLab;
@property (weak, nonatomic) IBOutlet UILabel *event_nextTime;

@property (weak, nonatomic) IBOutlet UILabel *event_nextNameLab;

///数据源
@property (nonatomic, strong) NSDictionary *dataDic;

+ (id)loadFromNib;

+ (NSString*)reuseIdentifier;

+ (CGFloat)defaultCellHeight;


@end
