//
//  MonitorCell.h
//  StarAPP
//
//  Created by xyz on 2016/11/20.
//
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
#import "ServiceModel.h"

@interface MonitorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *programeClass;
@property (weak, nonatomic) IBOutlet UIImageView *timeImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *channelImg;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImage1;


///数据源
@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) CategoryModel *categorymodel;
@property (nonatomic, strong) ServiceModel *servicemodel;

//@property(nonatomic,assign)NSInteger aa;
//@property(nonatomic,assign)NSInteger aaa;
+ (id)loadFromNib;

+ (NSString*)reuseIdentifier;

+ (CGFloat)defaultCellHeight;


@end

