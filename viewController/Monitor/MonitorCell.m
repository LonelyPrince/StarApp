
/*2018.2.2*/

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
 
    
    self.channelImg.image = [UIImage imageNamed:@"bluePhoneIcon"];
    
    
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
    
    NSString * service_videoindexStr = [tunerDic objectForKey:@"service_logic_number"];
    UILabel * channel_idStr ;
    UILabel * channel_nameStr ;
    if(service_videoindexStr.length == 1)
    {
        channel_idStr = [ NSString stringWithFormat:@"00%@",service_videoindexStr];
    }
    else if (service_videoindexStr.length == 2)
    {
        channel_idStr = [NSString stringWithFormat:@"0%@",service_videoindexStr];
    }
    else if (service_videoindexStr.length == 3)
    {
        channel_idStr = [NSString stringWithFormat:@"%@",service_videoindexStr];
    }
    else if (service_videoindexStr.length > 3)
    {
        channel_idStr = [service_videoindexStr substringFromIndex:service_videoindexStr.length - 3];
    }

    channel_nameStr = [tunerDic objectForKey:@"service_name"];
    NSLog(@"self.channel_Name.text== %@",channel_nameStr);
//
    
    
    
    deviceString = [GGUtil deviceVersion];
    
    if ([deviceString isEqualToString:@"iPhone5"] || [deviceString isEqualToString:@"iPhone5S"] ||[deviceString isEqualToString:@"iPhoneSE"] || [deviceString isEqualToString:@"iPhone5C"] || [deviceString isEqualToString:@"iPhone4S"] || [deviceString isEqualToString:@"iPhone4"]) {
        NSLog(@"此刻是5s和4s的大小");
        
        self.nameLab.frame = CGRectMake(157, 20, 158, 15);
        self.timeLab.frame =CGRectMake (131, 49, 190, 15);
        
    }else if ([deviceString isEqualToString:@"iPhone6"] || [deviceString isEqualToString:@"iPhone6S"] || [deviceString isEqualToString:@"iPhone7"]  || [deviceString isEqualToString:@"iPhone8"] || [deviceString isEqualToString:@"iPhoneX"] || [deviceString isEqualToString:@"iPhone Simulator"]) {
        NSLog(@"此刻是6的大小");
        
        self.nameLab.frame = CGRectMake(157, 20, 170, 15);
        self.timeLab.frame =CGRectMake (131, 49, 205, 15);
        
    }else if ([deviceString isEqualToString:@"iPhone6 Plus"] || [deviceString isEqualToString:@"iPhone6S Plus"] || [deviceString isEqualToString:@"iPhone7 Plus"]|| [deviceString isEqualToString:@"iPhone8 Plus"] ) {
        NSLog(@"此刻是6 plus的大小");
        
        self.nameLab.frame = CGRectMake(157, 20, 240, 15);
        self.timeLab.frame =CGRectMake (131, 49, 245, 15);
        
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
    
 
    
    self.timeLab.text = [NSString stringWithFormat:@"%@ %@",channel_idStr,channel_nameStr];
    
    NSString * clientNameStr = [[NSString alloc]initWithData:clientNameData encoding:NSUTF8StringEncoding];
    
    NSLog(@"clientNameStr:%@",clientNameStr);
    
    
    
    
    if (type == LIVE_PLAY) { //        return 1;// @"直播";
        self.channelImg.image = [UIImage imageNamed:@"blueSTBIcon"];
        
        self.programeClass.image = [UIImage imageNamed:@"play"];
        NSString * MMLLive = NSLocalizedString(@"MMLLive", nil);
        NSLog(@"[epgDic objectForKey: %@",[epgDic objectForKey:@"event_name"]);
        if(![[epgDic objectForKey:@"event_name"] isEqualToString:@""] && [epgDic objectForKey:@"event_name"] != NULL)
        {
//            self.nameLab.text = [NSString stringWithFormat:@"%@--%@",MMLLive,[epgDic objectForKey:@"event_name"]];
            self.nameLab.text = [NSString stringWithFormat:@"%@",MMLLive];
        }else{
//            NSString * NOEventLabel = NSLocalizedString(@"NOEventLabel", nil);
//            NSString * NOEventLabelTemp = [NSString stringWithFormat:@"%@--%@",MMLLive,NOEventLabel];
            NSString * NOEventLabelTemp = [NSString stringWithFormat:@"%@",MMLLive];
            self.nameLab.text = NOEventLabelTemp;
        }
        
        
    }else if (type == LIVE_RECORD) //        return 2;//@"录制";
    {
        self.channelImg.image = [UIImage imageNamed:@"blueSTBIcon"];
        
        NSString * MLRecordingNOS = NSLocalizedString(@"MLRecordingNOS", nil);
        self.programeClass.image = [UIImage imageNamed:@"录制"];
        
        if(![[epgDic objectForKey:@"event_name"] isEqualToString:@""] && [epgDic objectForKey:@"event_name"] != NULL)
        {
//            self.nameLab.text = [NSString stringWithFormat:@"%@--%@",MLRecordingNOS,[epgDic objectForKey:@"event_name"]];
            
            self.nameLab.text = [NSString stringWithFormat:@"%@",MLRecordingNOS];
        }else{
//            NSString * NOEventLabel = NSLocalizedString(@"NOEventLabel", nil);
//            NSString * NOEventLabelTemp = [NSString stringWithFormat:@"%@--%@",MLRecordingNOS,NOEventLabel];
            
            NSString * NOEventLabelTemp = [NSString stringWithFormat:@"%@",MLRecordingNOS];
            
            self.nameLab.text = NOEventLabelTemp;
        }
        
        
        
    }
    
    else if (type == DELIVERY)
    {
        if (!ISNULL(clientNameStr)) {
            if ([[clientNameStr substringToIndex:3] caseInsensitiveCompare:@"HMC"] == NSOrderedSame ) {
                NSLog(@"HMC 设备");
                
            }else if([[clientNameStr substringToIndex:4] caseInsensitiveCompare:@"mini"] == NSOrderedSame )
            {
                NSLog(@"mini 设备");
                self.channelImg.image = [UIImage imageNamed:@"blueMiniIcon"];
            }else
            {
                self.channelImg.image = [UIImage imageNamed:@"bluePhoneIcon"];
            }
            
        }
        
        
        
        if (!ISNULL(clientNameStr)) {
            self.programeClass.image = [UIImage imageNamed:@"分发"];
            
            NSLog(@"self.nameLab.text :%@",[epgDic objectForKey:@"event_name"]);
            if([[epgDic objectForKey:@"event_name"] isEqualToString:@""] || [epgDic objectForKey:@"event_name"] == NULL)
            {
 
                self.nameLab.text = [NSString stringWithFormat:@"%@--Delivery",clientNameStr];
 
                if ([clientNameStr isEqualToString:deviceString]) {
                    self.nameLab.textColor = RGBA(0x60, 0xa3, 0xec, 1);
                    self.timeLab.textColor = RGBA(0x60, 0xa3, 0xec, 1);
                    self.programeClass.image = [UIImage imageNamed:@"Monitor_delivery"];
                }
                
            }
            
            
        }
        else
        {
            self.programeClass.image = [UIImage imageNamed:@"分发"];
            
            if(![[epgDic objectForKey:@"event_name"] isEqualToString:@""] && [epgDic objectForKey:@"event_name"] != NULL)
            {
                
                self.nameLab.text = [NSString stringWithFormat:@"No Device Name--%@",[epgDic objectForKey:@"event_name"]];
                
                if ([clientNameStr isEqualToString:deviceString]) {
                    self.nameLab.textColor = RGBA(0x60, 0xa3, 0xec, 1);
                    self.timeLab.textColor = RGBA(0x60, 0xa3, 0xec, 1);
                    self.programeClass.image = [UIImage imageNamed:@"Monitor_delivery"];
                }
                
            }else
            {
                NSString * NOEventLabel = NSLocalizedString(@"NOEventLabel", nil);
                NSString * NOEventLabelTemp = [NSString stringWithFormat:@"No Device Name--%@",NOEventLabel];
                self.nameLab.text = NOEventLabelTemp;
                
                
                if ([clientNameStr isEqualToString:deviceString]) {
                    self.nameLab.textColor = RGBA(0x60, 0xa3, 0xec, 1);
                    self.timeLab.textColor = RGBA(0x60, 0xa3, 0xec, 1);
                    self.programeClass.image = [UIImage imageNamed:@"Monitor_delivery"];
                }
            }
            
        }
        
        
        //        return 4;//@"分发";
    }else
    {
        //其他数值默认无效
        //        return 0;
    }
    
    
    
}
@end
