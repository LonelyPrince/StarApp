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
    //***
    NSDictionary * epgDic;
    NSDictionary * nextEpgDic;
    NSArray * epgArr;
    epgDic  = [[NSDictionary alloc]init];
    nextEpgDic = [[NSDictionary alloc]init];
    epgArr = [[NSArray alloc]init];
    //****
    epgArr = [_dataDic objectForKey:@"epg_info"];
    epgDic = epgArr[0];
    
    if (epgArr.count >1) {
        nextEpgDic = epgArr[1];
        self.event_nextTime.text = [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
        self.event_nextNameLab.text = [nextEpgDic objectForKey:@"event_name"];
    }
    else
    {
        self.event_nextTime.text = [self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]];
        self.event_nextNameLab.text = @"";
    }
    
    self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
    
    
 
  
    //字体设置
    self.event_nameLab.font = FONT(12);
    self.event_nextTime.font = FONT(12);
    self.event_nextNameLab.font = FONT(12);
    
    
    //    self.event_next_nameLab = dataDic
    
    
    //    NSArray *images = dataDic[@"front_cover_image_list"];
    //    images[0];
    //    [self.channelImg sd_setImageWithURL:[NSURL URLWithString:images[0]]];
    //    NSString *address = [NSString stringWithFormat:@"%@.%@",self.dataDic[@"address"],self.dataDic[@"poi_name"]];
    
    //    self.event_nameLab.text = dataDic[@"title"];
    //    self.event_next_timeLab.text = address;
}
//时间戳转换
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@" HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
