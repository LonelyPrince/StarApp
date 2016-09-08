//
//  TVCell.m
//  StarAPP
//
//  Created by xyz on 16/9/7.
//
//

#import "TVCell.h"



@implementation TVCell

//awakeFromNib 从xib或者storyboard加载完毕就会调用
- (void)awakeFromNib {
    [super awakeFromNib];
    self.channelImg.clipsToBounds = YES;
    self.channelImg.contentMode = UIViewContentModeScaleAspectFill;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (id)loadFromNib
{
    NSString *xibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] firstObject];
}
+ (NSString*)reuseIdentifier
{
    return NSStringFromClass([self class]);
}
+ (CGFloat)defaultCellHeight
{
    return 80;
}



//设置接口数据
-(void) setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    self.channelImg.image = [UIImage imageNamed:@"11"];

    self.event_Img.image = [UIImage imageNamed:@"11"];
    self.event_nextImg.image = [UIImage imageNamed:@"11"];
  
//    if(dataDic[@"epg_info"][0][@"event_name"] ==NULL  )
//    {
        self.event_nameLab.text = @"namenamename";
//    }
//    else
//    {
//        self.event_nameLab.text = dataDic[@"epg_info"][0][@"event_name"];
//    }
    
    
    
    self.event_nextTime.text = @"11:00";
    self.event_nextNameLab.text = @"nextnamename";
    
    //    self.event_next_nameLab = dataDic
    
    
    //    NSArray *images = dataDic[@"front_cover_image_list"];
    //    images[0];
    //    [self.channelImg sd_setImageWithURL:[NSURL URLWithString:images[0]]];
    //    NSString *address = [NSString stringWithFormat:@"%@.%@",self.dataDic[@"address"],self.dataDic[@"poi_name"]];
    
    //    self.event_nameLab.text = dataDic[@"title"];
    //    self.event_next_timeLab.text = address;
}
@end
