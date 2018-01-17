//
//  pushViewCell.h
//  StarAPP
//
//  Created by xyz on 2018/1/15.
//

#import <UIKit/UIKit.h>

@interface pushViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) UIImageView * pushTypeImage;

@property (nonatomic, strong)  UILabel * pushDeviceLab;
  
@property (nonatomic, strong) UIButton * pushConfirmBtn ;
  
@property (nonatomic, strong) UIImageView * pushBtnImageView;

@property (nonatomic, assign) BOOL isSelect;

@end
