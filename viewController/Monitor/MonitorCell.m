//
//  MonitorCell.m
//  StarAPP
//
//  Created by xyz on 2016/11/20.
//
//

#import "MonitorCell.h"



@implementation MonitorCell
@synthesize deviceString;

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
    
    NSLog(@"clientNameData:%@",clientNameData);
    
    self.backImage.image = [UIImage imageNamed:@"background"];
    
    //    [self.channelImg sd_setImageWithURL:[NSURL URLWithString:[tunnerCellData objectForKey:@"service_logo_url"]]  placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //
    //        //[_dataDic objectForKey:@"epg_info"]
    //        //        image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:30];
    //
    //        self.channelImg.contentMode = UIViewContentModeScaleAspectFit;
    //        self.channelImg.clipsToBounds = YES;
    //
    //
    //        self.placeholderImage1.image = [UIImage imageNamed:@"placeholder"];
    //        [self.backImage bringSubviewToFront:self.placeholderImage1];
    //        if (self.channelImg.image == nil) {
    //            self.placeholderImage1.alpha = 1;
    //            NSLog(@"placeholderImage 为空");
    //        }else
    //        {
    //            self.placeholderImage1.alpha = 0;
    //            NSLog(@"placeholderImage 为空");
    //        }
    //
    //
    //    }];
    [self.channelImg sd_setImageWithURL:[NSURL URLWithString:[tunnerCellData objectForKey:@"service_logo_url"]]  placeholderImage:[UIImage imageNamed:@"placeholder1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //[_dataDic objectForKey:@"epg_info"]
        //        image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:30];
        
        self.channelImg.contentMode = UIViewContentModeScaleAspectFit;
        
        
    }];
    
    //    //图片和叠加图片
    //    UIImage * imageWithImage = [[UIImage alloc]init];
    //    imageWithImage = [self addImage:@"background" withImage:@"zOOm-Logo"];
    
    //    self.channelImageView.image = imageWithImage; //两张图片叠加
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
    if ([[detaildate description] isEqualToString:@"1970-01-01 00:00:00 +0000"]) {
        return @"--:--";
    }
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    //     [dateFormatter setDateFormat:@"现在日期：yyyy年MM月dd日 \n 现在时刻： HH:mm:ss             "];
    NSLog(@"dateFormatter:%@",dateFormatter);
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    NSLog(@"currentDateStr:%@",currentDateStr);
    
    
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
    deviceString = [GGUtil deviceVersion];
    
    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是5s和4s的大小");
        
        self.nameLab.frame = CGRectMake(157, 20, 158, 15);
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]  || [deviceString isEqualToString:@"iPhone8"] || [deviceString isEqualToString:@"iPhoneX"] || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        self.nameLab.frame = CGRectMake(157, 20, 166, 15);
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"]|| [deviceString isEqualToString:@"iPhone8 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        self.nameLab.frame = CGRectMake(157, 20, 192, 15);
        
    }
    
    int type;
    //[typeData getBytes: &type length: sizeof(type)];
    type =  [SocketUtils uint16FromBytes: typeData];
    NSLog(@"typedata :%@",typeData);
    ///////////////
    NSDictionary * epgDic;
    NSDictionary * nextEpgDic;
    NSArray * epgArr;
    epgDic  = [[NSDictionary alloc]init];
    nextEpgDic = [[NSDictionary alloc]init];
    epgArr = [[NSArray alloc]init];
    
    epgArr = [tunerDic objectForKey:@"epg_info"];
    if (epgDic.count < 1) {
        //没有数据不执行
    }else
    {
        epgDic = epgArr[0];
    }
    
    
    NSString * startTime1 =  [self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]];
    NSString * endTime1 =  [self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_endtime"]];
    
    if (![startTime1 isEqualToString:@""] && ![endTime1 isEqualToString:@""]) {
        self.timeLab.text = [NSString stringWithFormat:@"%@/%@",[self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]],[self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_endtime"]]];
    }else if(![startTime1 isEqualToString:@""] && [endTime1 isEqualToString:@""]){
        
        self.timeLab.text = [NSString stringWithFormat:@"%@/--:--",[self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]]];
    }else if([startTime1 isEqualToString:@""] && ![endTime1 isEqualToString:@""]){
        
        self.timeLab.text = [NSString stringWithFormat:@"--:--/%@",[self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_endtime"]]];
    }else {
        
        self.timeLab.text = [NSString stringWithFormat:@"--:--/--:--"];
    }
    
    //    self.timeLab.text = [NSString stringWithFormat:@"%@/%@",[self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]],[self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_endtime"]]];
    
    NSString * clientNameStr = [[NSString alloc]initWithData:clientNameData encoding:NSUTF8StringEncoding];
    
    NSLog(@"clientNameStr:%@",clientNameStr);
    
    
    
    
    if (type == LIVE_PLAY) { //        return 1;// @"直播";
        
        self.programeClass.image = [UIImage imageNamed:@"play"];
        NSString * MMLLive = NSLocalizedString(@"MMLLive", nil);
        NSLog(@"[epgDic objectForKey: %@",[epgDic objectForKey:@"event_name"]);
        if(![[epgDic objectForKey:@"event_name"] isEqualToString:@""] && [epgDic objectForKey:@"event_name"] != NULL)
        {
            self.nameLab.text = [NSString stringWithFormat:@"%@--%@",MMLLive,[epgDic objectForKey:@"event_name"]];
        }else{
            NSString * NOEventLabel = NSLocalizedString(@"NOEventLabel", nil);
            NSString * NOEventLabelTemp = [NSString stringWithFormat:@"%@--%@",MMLLive,NOEventLabel];
            self.nameLab.text = NOEventLabelTemp;
        }
        
        
    }else if (type == LIVE_RECORD) //        return 2;//@"录制";
    {
        NSString * MLRecording = NSLocalizedString(@"MLRecording", nil);
        self.programeClass.image = [UIImage imageNamed:@"录制"];
        
        if(![[epgDic objectForKey:@"event_name"] isEqualToString:@""] && [epgDic objectForKey:@"event_name"] != NULL)
        {
            self.nameLab.text = [NSString stringWithFormat:@"%@--%@",MLRecording,[epgDic objectForKey:@"event_name"]];
        }else{
            NSString * NOEventLabel = NSLocalizedString(@"NOEventLabel", nil);
            NSString * NOEventLabelTemp = [NSString stringWithFormat:@"%@--%@",MLRecording,NOEventLabel];
            self.nameLab.text = NOEventLabelTemp;
        }
        
        
        
    }
    //        else if (type == LIVE_TIME_SHIFT) //        return 3;//@"时移";
    //    {
    //        self.programeClass.image = [UIImage imageNamed:@"时移"];
    //
    //
    //        if([[epgDic objectForKey:@"event_name"] isEqualToString:@""])
    //        {
    //            self.nameLab.text = [NSString stringWithFormat:@"Time Shift--%@",[epgDic objectForKey:@"event_name"]];
    //        }else{
    //            self.nameLab.text = [NSString stringWithFormat:@"Time Shift--No Event"];
    //        }
    //
    //
    //    }
    else if (type == DELIVERY)
    {
        
        if (!ISNULL(clientNameStr)) {
            self.programeClass.image = [UIImage imageNamed:@"分发"];
            
            NSLog(@"self.nameLab.text :%@",[epgDic objectForKey:@"event_name"]);
            if([[epgDic objectForKey:@"event_name"] isEqualToString:@""] || [epgDic objectForKey:@"event_name"] == NULL)
            {
                NSLog(@"epgdic %@",[epgDic objectForKey:@"event_name"]);
                
                
                self.nameLab.text = [NSString stringWithFormat:@"%@--No Event",NSLocalizedString(@"NOEventLabel", nil)];
                NSLog(@"self.nameLab.text 22 :%@",self.nameLab.text);
                
            }else
            {
                self.nameLab.text = [NSString stringWithFormat:@"%@--%@",clientNameStr,[epgDic objectForKey:@"event_name"]];
                NSLog(@"self.nameLab.text :%@",self.nameLab.text
                      );
                
            }
            
            
        }
        else
        {
            self.programeClass.image = [UIImage imageNamed:@"分发"];
            
            if(![[epgDic objectForKey:@"event_name"] isEqualToString:@""] && [epgDic objectForKey:@"event_name"] != NULL)
            {
                
                self.nameLab.text = [NSString stringWithFormat:@"No Device Name--%@",[epgDic objectForKey:@"event_name"]];
                
            }else
            {
                NSString * NOEventLabel = NSLocalizedString(@"NOEventLabel", nil);
                NSString * NOEventLabelTemp = [NSString stringWithFormat:@"No Device Name--%@",NOEventLabel];
                self.nameLab.text = NOEventLabelTemp;
                
            }
            //
            //           self.nameLab.text = [NSString stringWithFormat:@"No Device Name"];
            //            NSLog(@"epgDic :%@",epgDic);
        }
        
        
        //        return 4;//@"分发";
    }else
    {
        //其他数值默认无效
        //        return 0;
    }
    
    
    
}
@end
