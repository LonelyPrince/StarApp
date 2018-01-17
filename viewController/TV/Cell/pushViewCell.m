//
//  pushViewCell.m
//  StarAPP
//
//  Created by xyz on 2018/1/15.
//

#import "pushViewCell.h"

@implementation pushViewCell
@synthesize pushTypeImage;
@synthesize pushDeviceLab;
@synthesize pushConfirmBtn;
@synthesize pushBtnImageView;
@synthesize isSelect;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
//设置接口数据
//-(void) setDataDic:(NSDictionary *)dataDic
//{
////    pushTypeImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 25, 25)];
////    pushTypeImage.image = [UIImage imageNamed:@"pushPhone"];
////    [cell addSubview:pushTypeImage];
////
////    pushDeviceLab = [[UILabel alloc]initWithFrame:CGRectMake(55, 21, 200, 10)];
////    pushDeviceLab.text = phonePushOtherArr[indexPath.row][2];
////    pushDeviceLab.font = FONT(13);
////    [cell addSubview:pushDeviceLab];
////
////    pushConfirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(250, 15, 20, 20)];
////    [pushConfirmBtn.layer setBorderWidth:2.0f];
////    [cell addSubview:pushConfirmBtn];
////    [pushConfirmBtn.layer setBorderWidth:0];
////
////    pushBtnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, pushConfirmBtn.frame.size.width, pushConfirmBtn.frame.size.height)];
////    [pushConfirmBtn addSubview:pushBtnImageView];
////    pushBtnImageView.image = [UIImage imageNamed:@"NoSelect"];
//
//}
@end
