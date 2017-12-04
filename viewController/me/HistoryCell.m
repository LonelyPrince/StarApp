//
//  HistoryCell.m
//  StarAPP
//
//  Created by xyz on 2016/10/28.
//
//

#import "HistoryCell.h"

@implementation HistoryCell

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
        [self.channelImage sd_setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"service_logo_url"]]  placeholderImage:[UIImage imageNamed:@"RECPlaceholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            
            self.channelImage.contentMode = UIViewContentModeScaleAspectFit;
            
            
        }];
    }else
    {
        [self.channelImage sd_setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"service_logo_url"]]  placeholderImage:[UIImage imageNamed:@"placeholder1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            
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
    
   
    return currentDateStr;
}


@end
