//
//  HistoryCell.h
//  StarAPP
//
//  Created by xyz on 2016/10/28.
//
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
#import "ServiceModel.h"
@interface HistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *channelImage;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImage1;
@property (weak, nonatomic) IBOutlet UILabel *logicLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (nonatomic, strong) NSDictionary *dataDic;


@property (nonatomic, strong) CategoryModel *categorymodel;
@property (nonatomic, strong) ServiceModel *servicemodel;


+ (id)loadFromNib;

+ (NSString*)reuseIdentifier;

+ (CGFloat)defaultCellHeight;
@end
