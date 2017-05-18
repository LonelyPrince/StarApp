//
//  EarilyCell.m
//  StarAPP
//
//  Created by xyz on 2016/11/2.
//
//

#import "EarilyCell.h"

@implementation EarilyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
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
//设置接口数据
-(void) setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    
    
    self.backImage.image = [UIImage imageNamed:@"background"];
    UIImage * imageWithImage = [[UIImage alloc]init];
    
//    self.placeholderImage1.image = [UIImage imageNamed:@"placeholder"];
//    [self.channelImage sd_setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"service_logo_url"]]  placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        //[UIImage imageNamed:@"placeholder"]
//        
//        //[_dataDic objectForKey:@"epg_info"]
//        //        image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:30];
//        
//        self.channelImage.contentMode = UIViewContentModeScaleAspectFit;
//        self.channelImage.clipsToBounds = YES;
//        
//        
//        self.placeholderImage1.image = [UIImage imageNamed:@"placeholder"];
//        [self.backImage bringSubviewToFront:self.placeholderImage1];
//        if (self.channelImage.image == nil) {
//            self.placeholderImage1.alpha = 1;
//            NSLog(@"placeholderImage 为空");
//        }else
//        {
//            self.placeholderImage1.alpha = 0;
//            NSLog(@"placeholderImage 为空");
//        }
//        
//    }];
    [self.channelImage sd_setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"service_logo_url"]]  placeholderImage:[UIImage imageNamed:@"placeholder1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //[_dataDic objectForKey:@"epg_info"]
        //        image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:30];
        
        self.channelImage.contentMode = UIViewContentModeScaleAspectFit;
        
        
    }];
    
    
    
    
    
    
    
    
    self.logicLab.text = [_dataDic objectForKey:@"service_logic_number"];
    
    if(self.logicLab.text.length == 1)
    {
        self.logicLab.text = [NSString stringWithFormat:@"00%@", self.logicLab.text];
    }
    else if (self.logicLab.text.length == 2)
    {
        self.logicLab.text = [NSString stringWithFormat:@"0%@", self.logicLab.text];
    }
    else if (self.logicLab.text.length == 3)
    {
        self.logicLab.text = [NSString stringWithFormat:@"%@", self.logicLab.text];
    }
    else if (self.logicLab.text.length > 3)
    {
        self.logicLab.text = [ self.logicLab.text substringFromIndex: self.logicLab.text.length - 3];
    }
    
    
    
    
    
    self.nameLab.text = [_dataDic objectForKey:@"service_name"];
    ////    self.event_Img.image = [UIImage imageNamed:@"play"];
    ////    self.event_nextImg.image = [UIImage imageNamed:@"time"];
    //    //***
    //    NSDictionary * epgDic;
    //    NSDictionary * nextEpgDic;
    //    NSArray * epgArr;
    //    epgDic  = [[NSDictionary alloc]init];
    //    nextEpgDic = [[NSDictionary alloc]init];
    //    epgArr = [[NSArray alloc]init];
    //    //****
    //    epgArr = [_dataDic objectForKey:@"epg_info"];
    
    
    
    
    
    //    epgDic = epgArr[0];
    //
    ////    if (epgArr.count >1) {
    ////        nextEpgDic = epgArr[1];
    ////        NSLog(@"shijian时间：%@",[nextEpgDic  objectForKey:@"event_starttime"] );
    ////        self.event_nextTime.text = [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
    ////        NSLog(@"shijian时间：%@",self.event_nextTime.text);
    ////        self.event_nextNameLab.text = [nextEpgDic objectForKey:@"event_name"];
    ////    }
    ////    else
    ////    {
    ////        self.event_nextTime.text = [self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]];
    ////        self.event_nextNameLab.text = @"";
    ////    }
    ////
    //    self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
    //
    
    
    
    //字体设置
    self.logicLab.font = FONT(12);
    self.nameLab.font = FONT(12);
    
    
    
}
//时间戳转换
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    //    NSTimeInterval time=[timeString doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSTimeInterval time=[timeString doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    //     [dateFormatter setDateFormat:@"现在日期：yyyy年MM月dd日 \n 现在时刻： HH:mm:ss             "];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    //    // 格式化时间
    //    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    //    [formatter setDateStyle:NSDateFormatterMediumStyle];
    //    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@" HH:mm"];
    //
    //    // 毫秒值转化为秒
    //    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    //    NSString* dateString = [formatter stringFromDate:date];
    return currentDateStr;
}

//将两个图片叠加
- (UIImage *)addImage:(NSString *)imageName1 withImage:(NSString *)imageName2 {
    
    UIImage *image1 = [UIImage imageNamed:imageName1];
    UIImage *image2 = [UIImage imageNamed:imageName2];
    
    UIGraphicsBeginImageContext(image1.size);
    
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    [image2 drawInRect:CGRectMake((image1.size.width - image2.size.width)/2,(image1.size.height - image2.size.height)/48*19, image2.size.width, image2.size.height)]; //出去阴影部分居中
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}
@end
