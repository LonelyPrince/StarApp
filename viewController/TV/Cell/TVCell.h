//
//  TVCell.h
//  StarAPP
//
//  Created by xyz on 16/9/7.
//
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
#import "ServiceModel.h"
#import "YFRollingLabel.h"


@interface TVCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UIImageView *event_Img;
@property (weak, nonatomic) IBOutlet UIImageView *event_nextImg;

@property (weak, nonatomic) IBOutlet UILabel *event_nameLab;
@property (weak, nonatomic) IBOutlet UILabel *event_nextTime;

@property (weak, nonatomic) IBOutlet UILabel *event_nextNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *channelImg;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImage1;


@property (weak, nonatomic) IBOutlet UILabel *channel_id;
@property (weak, nonatomic) IBOutlet UILabel *channel_Name;

@property (nonatomic, strong, readwrite) YFRollingLabel *YFRunLabel;
///数据源
@property (nonatomic, strong) NSString *nowTimeStr;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *RECAndLiveDataArr;

@property (nonatomic, strong) CategoryModel *categorymodel;
@property (nonatomic, strong) ServiceModel *servicemodel;

//@property(nonatomic,assign)NSInteger aa;
//@property(nonatomic,assign)NSInteger aaa;
+ (id)loadFromNib;

+ (NSString*)reuseIdentifier;

+ (CGFloat)defaultCellHeight;


@end
