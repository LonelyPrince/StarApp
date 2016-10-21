//
//  subtCell.h
//  StarAPP
//
//  Created by xyz on 2016/10/21.
//
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
#import "ServiceModel.h"
@interface subtCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel * languageLab;


///数据源
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) CategoryModel *categorymodel;
@property (nonatomic, strong) ServiceModel *servicemodel;





+ (id)loadFromNib;

+ (NSString*)reuseIdentifier;

+ (CGFloat)defaultCellHeight;

@end
