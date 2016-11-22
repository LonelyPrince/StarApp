//
//  MonitorCell.m
//  StarAPP
//
//  Created by xyz on 2016/11/20.
//
//

#import "MonitorCell.h"

@implementation MonitorCell

//awakeFromNib 从xib或者storyboard加载完毕就会调用
- (void)awakeFromNib {
    [super awakeFromNib];
//    self.channelImg.clipsToBounds = YES;
//    self.channelImg.contentMode = UIViewContentModeScaleAspectFill;
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
-(void) setDataArr:(NSArray *)dataArr
{
    
    NSDictionary *  tunnerCellData = dataArr[0];
    NSLog(@"tunnerCellData:%@",tunnerCellData);
    NSData * typedata = dataArr[1];
    NSData * clientNameData = dataArr[2];
    
    
    
    //图片和叠加图片
    UIImage * imageWithImage = [[UIImage alloc]init];
    imageWithImage = [self addImage:@"background" withImage:@"zOOm-Logo"];
    
    self.channelImageView.image = imageWithImage; //两张图片叠加
    //判断tuner类型 并且设置类别的图片
    [self judgeTunerClass:typedata tunerDic:tunnerCellData clientName:clientNameData];
//    self.programeClass.image = [UIImage imageNamed:@"play"];
    self.timeImage.image = [UIImage imageNamed:@"时间"];
    
    
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

-(void)judgeTunerClass:(NSData * )typeData tunerDic:(NSDictionary *)tunerDic  clientName:(NSData*)clientNameData
{
    
    int type;
    //[typeData getBytes: &type length: sizeof(type)];
    type =  [SocketUtils uint16FromBytes: typeData];
    
    ///////////////
    NSDictionary * epgDic;
    NSDictionary * nextEpgDic;
    NSArray * epgArr;
    epgDic  = [[NSDictionary alloc]init];
    nextEpgDic = [[NSDictionary alloc]init];
    epgArr = [[NSArray alloc]init];
    
    epgArr = [tunerDic objectForKey:@"epg_info"];
    epgDic = epgArr[0];
    self.timeLab.text = [NSString stringWithFormat:@"%@/%@",[self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]],[self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_endtime"]]];
    
    NSString * clientNameStr = [[NSString alloc]initWithData:clientNameData encoding:NSUTF8StringEncoding];
    
    

    
    if (type == LIVE_PLAY) {
        self.programeClass.image = [UIImage imageNamed:@"play"];
       
        if (ISNULL(clientNameStr)) {
            self.nameLab.text = [NSString stringWithFormat:@"%@--%@",[epgDic objectForKey:@"event_name"],clientNameStr];
        }
        else
        {
            self.nameLab.text = [NSString stringWithFormat:@"%@",[epgDic objectForKey:@"event_name"]];
        }
        
        
        //        return 1;// @"直播";
    }else if (type == LIVE_RECORD)
    {
        self.programeClass.image = [UIImage imageNamed:@"录制"];
         self.nameLab.text = [NSString stringWithFormat:@"%@--Recoding",[epgDic objectForKey:@"event_name"]];
//        return 2;//@"录制";
    }else if (type == LIVE_TIME_SHIFT)
    {
           self.programeClass.image = [UIImage imageNamed:@"时移"];
        self.nameLab.text = [NSString stringWithFormat:@"%@--Time Shift",[epgDic objectForKey:@"event_name"]];
//        return 3;//@"时移";
    }else if (type == DELIVERY)
    {
           self.programeClass.image = [UIImage imageNamed:@"分发"];
        self.nameLab.text = [NSString stringWithFormat:@"%@--Recoding",[epgDic objectForKey:@"Distribute"]];
//        return 4;//@"分发";
    }else
    {
        //其他数值默认无效
//        return 0;
    }
 
   
    
}
@end
