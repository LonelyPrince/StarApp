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
    
 
    if (_dataDic.count > 14) {
        
        NSString * urlTemp = [NSString stringWithFormat:@"http://%@%@",[USER_DEFAULT objectForKey:@"HMC_DMSIP"],[_dataDic objectForKey:@"service_logo_url"]];
        [self.channelImage sd_setImageWithURL:[NSURL URLWithString:urlTemp]  placeholderImage:[UIImage imageNamed:@"RECPlaceholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            
            self.channelImage.contentMode = UIViewContentModeScaleAspectFit;
            
            
        }];
    }else
    {
        
        NSString * urlTemp = [NSString stringWithFormat:@"http://%@%@",[USER_DEFAULT objectForKey:@"HMC_DMSIP"],[_dataDic objectForKey:@"service_logo_url"]];
        [self.channelImage sd_setImageWithURL:[NSURL URLWithString:urlTemp]  placeholderImage:[UIImage imageNamed:@"placeholder1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            
            self.channelImage.contentMode = UIViewContentModeScaleAspectFit;
            
            
        }];
    }
    
    
    
    
    
    
    
    self.logicLab.text = [_dataDic objectForKey:@"service_logic_number"];
    self.nameLab.text = [_dataDic objectForKey:@"service_name"];
    
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
    }else
    {
        self.nameLab.text = [_dataDic objectForKey:@"file_name"];
        [self.logicLab setAlpha:0];
        self.nameLab.frame = CGRectMake(162, 29, 200, 21);
    }
    
    
  
    
    
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
