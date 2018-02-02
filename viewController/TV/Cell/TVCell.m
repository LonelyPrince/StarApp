/*2018.2.2*/


////
////  TVCell.m
////  StarAPP
////
////  Created by xyz on 16/9/7.
////
////
//
//#import "TVCell.h"
//#import "UIImageView+WebCache.h"
//
//
//@implementation TVCell
//
////awakeFromNib 从xib或者storyboard加载完毕就会调用
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    self.channelImg.clipsToBounds = YES;
//    self.channelImg.contentMode = UIViewContentModeScaleAspectFill;
//    // Initialization code
//
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//
//+ (id)loadFromNib
//{
//    NSString *xibName = NSStringFromClass([self class]);
//    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] firstObject];
//}
//+ (NSString*)reuseIdentifier
//{
//    return NSStringFromClass([self class]);
//}
//+ (CGFloat)defaultCellHeight
//{
//    return 80;
//}
//
//
//
////设置接口数据
//-(void) setDataDic:(NSDictionary *)dataDic
//{
//    NSString * NOEventLabel = NSLocalizedString(@"NOEventLabel", nil);
//    _dataDic = dataDic;
//
//    if (dataDic.count <= 14) { //直播
//
//
//        //    NSLog(@"_dataDic %@",_dataDic);
//        //
//        // if dataDic 包含某个标记，则使用AA 显示,否则使用BB 显示
//
//        self.backImage.image = [UIImage imageNamed:@"background"];
//        UIImage * imageWithImage = [[UIImage alloc]init];
//        imageWithImage = [self addImage:@"background" withImage:@"zOOm-Logo"];
//
//
//        NSString * urlTemp = [NSString stringWithFormat:@"http://%@%@",[USER_DEFAULT objectForKey:@"HMC_DMSIP"],[_dataDic objectForKey:@"service_logo_url"]];
//        NSLog(@"urlTemp===== %@",urlTemp);
//        [self.channelImg sd_setImageWithURL:[NSURL URLWithString:urlTemp]  placeholderImage:[UIImage imageNamed:@"placeholder1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//            //[_dataDic objectForKey:@"epg_info"]
//            //        image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:30];
//
//            self.channelImg.contentMode = UIViewContentModeScaleAspectFit;
//
//
//        }];
//
//        self.event_Img.image = [UIImage imageNamed:@"play"];
//        self.event_nextImg.image = [UIImage imageNamed:@"time"];
//
//        //***
//        NSDictionary * epgDic;
//        NSDictionary * nextEpgDic;
//        NSArray * epgArr;
//        epgDic  = [[NSDictionary alloc]init];
//        nextEpgDic = [[NSDictionary alloc]init];
//        epgArr = [[NSArray alloc]init];
//        //****
//        epgArr = [_dataDic objectForKey:@"epg_info"];
//        if (epgArr.count >0) {
//            epgDic = epgArr[0];
//
//
//            //判断第一个数据是不是没有时间戳，或者时间戳是不是比当前时间还要打，如果是，则要将数据后移
//            NSString * firstDicStartTime = [epgDic objectForKey:@"event_starttime"]; //获得第一个epg的开始时间
//            //    NSLog(@"firstDicStartTime %@",firstDicStartTime);
//            //    NSLog(@"firstDicStartTime_nowTimeStr %@",_nowTimeStr);
//            if([firstDicStartTime intValue] >[_nowTimeStr intValue])
//            {
//
//                self.event_nameLab.text =NOEventLabel;  //设置第一个epg 信息为空
//
//                if (epgArr.count >1) {
//                    nextEpgDic = epgArr[0];
//                    //        NSLog(@"shijian时间：%@",[nextEpgDic  objectForKey:@"event_starttime"] );
//                    NSString * startTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
//
//                    if (![startTimeisHas isEqualToString:@""]) {
//                        self.event_nextTime.text = [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
//                    }else{
//                        self.event_nextTime.text =@"--:--";
//                    }
//
//
//
//                    //        NSLog(@"shijian时间：%@",self.event_nextTime.text);
//                    if (![[nextEpgDic objectForKey:@"event_name"] isEqualToString:@""]) {
//                        self.event_nextNameLab.text = [nextEpgDic objectForKey:@"event_name"];
//                    }else
//                    {
//                        self.event_nextNameLab.text =NOEventLabel;
//                    }
//
//                }
//                else
//                {
//                    NSString * endTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
//                    if(![endTimeisHas isEqualToString:@""])
//                    {
//                        self.event_nextTime.text = [self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]];
//                    }else{
//                        self.event_nextTime.text = @"--:--";
//                    }
//
//
//                    self.event_nextNameLab.text = NOEventLabel;
//                }
//
//
//                //        if (![[epgDic objectForKey:@"event_name"] isEqualToString:@""]) {
//                //            self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
//                //        }else
//                //        {
//                //            self.event_nameLab.text =@"No Event";
//                //        }
//            }
//
//            //====================
//            else
//            {
//                if (epgArr.count >1) {
//                    nextEpgDic = epgArr[1];
//                    //        NSLog(@"shijian时间：%@",[nextEpgDic  objectForKey:@"event_starttime"] );
//                    NSString * startTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
//
//                    if (![startTimeisHas isEqualToString:@""]) {
//                        self.event_nextTime.text = [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
//                    }else{
//                        self.event_nextTime.text =@"--:--";
//                    }
//
//
//
//                    //        NSLog(@"shijian时间：%@",self.event_nextTime.text);
//                    if (![[nextEpgDic objectForKey:@"event_name"] isEqualToString:@""]) {
//                        self.event_nextNameLab.text = [nextEpgDic objectForKey:@"event_name"];
//                    }else
//                    {
//
//                        self.event_nextNameLab.text =NOEventLabel;
//                    }
//
//                }
//                else
//                {
//                    NSString * endTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
//                    if(![endTimeisHas isEqualToString:@""])
//                    {
//                        self.event_nextTime.text = [self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]];
//                    }else{
//                        self.event_nextTime.text = @"--:--";
//                    }
//
//                    self.event_nextNameLab.text = NOEventLabel;
//                }
//
//                //    self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
//                if (![[epgDic objectForKey:@"event_name"] isEqualToString:@""]) {
//                    self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
//                }else
//                {
//                    self.event_nameLab.text =NOEventLabel;
//                }
//            }
//
//        }else
//        {
//            self.event_nameLab.text = NOEventLabel;
//            self.event_nextNameLab.text = NOEventLabel;
//        }
//    }else //录播
//    {
//        NSLog(@"lubo 录播");
//
//        //    NSLog(@"_dataDic %@",_dataDic);
//        //
//        // if dataDic 包含某个标记，则使用AA 显示,否则使用BB 显示
//
//        self.backImage.image = [UIImage imageNamed:@"background"];
//        UIImage * imageWithImage = [[UIImage alloc]init];
//        imageWithImage = [self addImage:@"background" withImage:@"zOOm-Logo"];
//
//        NSString * urlTemp = [NSString stringWithFormat:@"http://%@%@",[USER_DEFAULT objectForKey:@"HMC_DMSIP"],[_dataDic objectForKey:@"service_logo_url"]];
//        [self.channelImg sd_setImageWithURL:[NSURL URLWithString:urlTemp]  placeholderImage:[UIImage imageNamed:@"placeholder1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//            //[_dataDic objectForKey:@"epg_info"]
//            //        image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:30];
//
//            self.channelImg.contentMode = UIViewContentModeScaleAspectFit;
//
//
//        }];
//
//        self.event_Img.image = [UIImage imageNamed:@"play"];
//        self.event_nextImg.image = [UIImage imageNamed:@"time"];
//
//
////        NSString * serviceName = [dataDic objectForKey:@"service_name"];
//        NSString * serviceName = [dataDic objectForKey:@"file_name"];
//        NSString * recordTime = [dataDic objectForKey:@"record_time"];
//        NSString * durationTime = [dataDic objectForKey:@"duration"];
//
//        NSLog(@"serviceName %@",serviceName);
//        NSLog(@"recordTime %@",recordTime);
//        NSLog(@"durationTime %@",durationTime);
//
//        //节目名称
//        if (serviceName != NULL && ![serviceName isEqualToString:@""]) {
//            self.event_nameLab.text =serviceName;
//        }else
//        {
//            self.event_nameLab.text =NOEventLabel;
//        }
//
//        //总时间
//        if (durationTime != NULL && ![durationTime isEqualToString:@""]) {
//
//            //[durationTime doubleValue]   此处的时间不会大于24小时
//            double timeTemp = [durationTime doubleValue] - 28800;
//            NSString * timeTempStr = [NSString stringWithFormat:@"%f",timeTemp];
//            self.event_nextTime.text =[GGUtil  timeHMSWithTimeIntervalString:timeTempStr];
//
//            self.event_nextTime.frame = CGRectMake(157, 49, 60, 14);
//            self.event_nextNameLab.frame = CGRectMake(220, 49, 112, 14);
//
//        }else
//        {
//            self.event_nextTime.text =@"--:--";
//        }
//
//        //开始时间
//        if (recordTime != NULL  && ![recordTime isEqualToString:@""]) {
//
////            NSString * timeTempStr = [NSString stringWithFormat:@"%@",recordTime];
//            self.event_nextNameLab.text = [GGUtil  timeYMDHMWithTimeIntervalString:recordTime];
//        }else
//        {
//            self.event_nextNameLab.text =NOEventLabel;
//        }
//
//
//        //***
//        NSDictionary * epgDic;
//        NSDictionary * nextEpgDic;
//        NSArray * epgArr;
//        epgDic  = [[NSDictionary alloc]init];
//        nextEpgDic = [[NSDictionary alloc]init];
//        epgArr = [[NSArray alloc]init];
//        //****
//        epgArr = [_dataDic objectForKey:@"epg_info"];
//        if (epgArr.count >0) {
//            epgDic = epgArr[0];
//
//
//            //判断第一个数据是不是没有时间戳，或者时间戳是不是比当前时间还要打，如果是，则要将数据后移
//            NSString * firstDicStartTime = [epgDic objectForKey:@"event_starttime"]; //获得第一个epg的开始时间
//            //    NSLog(@"firstDicStartTime %@",firstDicStartTime);
//            //    NSLog(@"firstDicStartTime_nowTimeStr %@",_nowTimeStr);
//            if([firstDicStartTime intValue] >[_nowTimeStr intValue])
//            {
//                self.event_nameLab.text =@"No Event";  //设置第一个epg 信息为空
//
//                if (epgArr.count >1) {
//                    nextEpgDic = epgArr[0];
//                    //        NSLog(@"shijian时间：%@",[nextEpgDic  objectForKey:@"event_starttime"] );
//                    NSString * startTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
//
//                    if (![startTimeisHas isEqualToString:@""]) {
//                        self.event_nextTime.text = [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
//                    }else{
//                        self.event_nextTime.text =@"--:--";
//                    }
//
//
//
//                    //        NSLog(@"shijian时间：%@",self.event_nextTime.text);
//                    if (![[nextEpgDic objectForKey:@"event_name"] isEqualToString:@""]) {
//                        self.event_nextNameLab.text = [nextEpgDic objectForKey:@"event_name"];
//                    }else
//                    {
//                        self.event_nextNameLab.text =NOEventLabel;
//                    }
//
//                }
//                else
//                {
//                    NSString * endTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
//                    if(![endTimeisHas isEqualToString:@""])
//                    {
//                        self.event_nextTime.text = [self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]];
//                    }else{
//                        self.event_nextTime.text = @"--:--";
//                    }
//
//                    self.event_nextNameLab.text = NOEventLabel;
//                }
//
//
//                //        if (![[epgDic objectForKey:@"event_name"] isEqualToString:@""]) {
//                //            self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
//                //        }else
//                //        {
//                //            self.event_nameLab.text =@"No Event";
//                //        }
//            }
//
//            //====================
//            else
//            {
//                if (epgArr.count >1) {
//                    nextEpgDic = epgArr[1];
//                    //        NSLog(@"shijian时间：%@",[nextEpgDic  objectForKey:@"event_starttime"] );
//                    NSString * startTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
//
//                    if (![startTimeisHas isEqualToString:@""]) {
//                        self.event_nextTime.text = [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
//                    }else{
//                        self.event_nextTime.text =@"--:--";
//                    }
//
//
//
//                    //        NSLog(@"shijian时间：%@",self.event_nextTime.text);
//                    if (![[nextEpgDic objectForKey:@"event_name"] isEqualToString:@""]) {
//                        self.event_nextNameLab.text = [nextEpgDic objectForKey:@"event_name"];
//                    }else
//                    {
//                        self.event_nextNameLab.text =NOEventLabel;
//                    }
//
//                }
//                else
//                {
//                    NSString * endTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
//                    if(![endTimeisHas isEqualToString:@""])
//                    {
//                        self.event_nextTime.text = [self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]];
//                    }else{
//                        self.event_nextTime.text = @"--:--";
//                    }
//
//                    self.event_nextNameLab.text = NOEventLabel;
//                }
//
//                //    self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
//                if (![[epgDic objectForKey:@"event_name"] isEqualToString:@""]) {
//                    self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
//                }else
//                {
//                    self.event_nameLab.text =NOEventLabel;
//                }
//            }
//
//        }
//    }
//
//
//
//
//    //字体设置
//    self.event_nameLab.font = FONT(12);
//    self.event_nextTime.font = FONT(12);
//    self.event_nextNameLab.font = FONT(12);
//
//
//    self.event_nameLab.textColor = CellBlackColor;
//    self.event_nextTime.textColor = CellGrayColor;
//    self.event_nextNameLab.textColor = CellGrayColor;
//}
////时间戳转换
//- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
//{
//    //    NSTimeInterval time=[timeString doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
//    NSTimeInterval time=[timeString doubleValue];//因为时差问题要加8小时 == 28800 sec
//    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//    if ([[detaildate description] isEqualToString:@"1970-01-01 00:00:00 +0000"]) {
//        return @"--:--";
//    }
//    NSLog(@"date:%@",[detaildate description]);
//    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"HH:mm"];
//    //     [dateFormatter setDateFormat:@"现在日期：yyyy年MM月dd日 \n 现在时刻： HH:mm:ss             "];
//    NSLog(@"dateFormatter:%@",dateFormatter);
//    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//    NSLog(@"currentDateStr:%@",currentDateStr);
//    //    // 格式化时间
//    //    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    //    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
//    //    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    //    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    //    [formatter setDateFormat:@" HH:mm"];
//    //
//    //    // 毫秒值转化为秒
//    //    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
//    //    NSString* dateString = [formatter stringFromDate:date];
//    return currentDateStr;
//}
//
////将两个图片叠加
//- (UIImage *)addImage:(NSString *)imageName1 withImage:(NSString *)imageName2 {
//
//    UIImage *image1 = [UIImage imageNamed:imageName1];
//    UIImage *image2 = [UIImage imageNamed:imageName2];
//
//    UIGraphicsBeginImageContext(image1.size);
//
//    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
//
//    [image2 drawInRect:CGRectMake((image1.size.width - image2.size.width)/2,(image1.size.height - image2.size.height)/48*19, image2.size.width, image2.size.height)]; //出去阴影部分居中
//
//    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//    return resultingImage;
//}
//@end



/*2018.2.2*/

//
//  TVCell.m
//  StarAPP
//
//  Created by xyz on 16/9/7.
//
//

#import "TVCell.h"
#import "UIImageView+WebCache.h"


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
    NSString * NOEventLabel = NSLocalizedString(@"NOEventLabel", nil);
    _dataDic = dataDic;
    
    if (dataDic.count <= 14) { //直播
        
        
        //    NSLog(@"_dataDic %@",_dataDic);
        //
        // if dataDic 包含某个标记，则使用AA 显示,否则使用BB 显示
        
        self.backImage.image = [UIImage imageNamed:@"background"];
        UIImage * imageWithImage = [[UIImage alloc]init];
        imageWithImage = [self addImage:@"background" withImage:@"zOOm-Logo"];
        
        [self.channelImg sd_setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"service_logo_url"]]  placeholderImage:[UIImage imageNamed:@"placeholder1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //[_dataDic objectForKey:@"epg_info"]
            //        image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:30];
            
            self.channelImg.contentMode = UIViewContentModeScaleAspectFit;
            
            
        }];
        
        self.event_Img.image = [UIImage imageNamed:@"play"];
        self.event_nextImg.image = [UIImage imageNamed:@"time"];
        
        //***
        NSDictionary * epgDic;
        NSDictionary * nextEpgDic;
        NSArray * epgArr;
        epgDic  = [[NSDictionary alloc]init];
        nextEpgDic = [[NSDictionary alloc]init];
        epgArr = [[NSArray alloc]init];
        //****
        epgArr = [_dataDic objectForKey:@"epg_info"];
        if (epgArr.count >0) {
            epgDic = epgArr[0];
            
            
            //判断第一个数据是不是没有时间戳，或者时间戳是不是比当前时间还要打，如果是，则要将数据后移
            NSString * firstDicStartTime = [epgDic objectForKey:@"event_starttime"]; //获得第一个epg的开始时间
            //    NSLog(@"firstDicStartTime %@",firstDicStartTime);
            //    NSLog(@"firstDicStartTime_nowTimeStr %@",_nowTimeStr);
            if([firstDicStartTime intValue] >[_nowTimeStr intValue])
            {
                
                self.event_nameLab.text =NOEventLabel;  //设置第一个epg 信息为空
                
                if (epgArr.count >1) {
                    nextEpgDic = epgArr[0];
                    //        NSLog(@"shijian时间：%@",[nextEpgDic  objectForKey:@"event_starttime"] );
                    NSString * startTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
                    
                    if (![startTimeisHas isEqualToString:@""]) {
                        self.event_nextTime.text = [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
                    }else{
                        self.event_nextTime.text =@"--:--";
                    }
                    
                    
                    
                    //        NSLog(@"shijian时间：%@",self.event_nextTime.text);
                    if (![[nextEpgDic objectForKey:@"event_name"] isEqualToString:@""]) {
                        self.event_nextNameLab.text = [nextEpgDic objectForKey:@"event_name"];
                    }else
                    {
                        self.event_nextNameLab.text =NOEventLabel;
                    }
                    
                }
                else
                {
                    NSString * endTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
                    if(![endTimeisHas isEqualToString:@""])
                    {
                        self.event_nextTime.text = [self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]];
                    }else{
                        self.event_nextTime.text = @"--:--";
                    }
                    
                    
                    self.event_nextNameLab.text = NOEventLabel;
                }
                
                
                //        if (![[epgDic objectForKey:@"event_name"] isEqualToString:@""]) {
                //            self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
                //        }else
                //        {
                //            self.event_nameLab.text =@"No Event";
                //        }
            }
            
            //====================
            else
            {
                if (epgArr.count >1) {
                    nextEpgDic = epgArr[1];
                    //        NSLog(@"shijian时间：%@",[nextEpgDic  objectForKey:@"event_starttime"] );
                    NSString * startTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
                    
                    if (![startTimeisHas isEqualToString:@""]) {
                        self.event_nextTime.text = [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
                    }else{
                        self.event_nextTime.text =@"--:--";
                    }
                    
                    
                    
                    //        NSLog(@"shijian时间：%@",self.event_nextTime.text);
                    if (![[nextEpgDic objectForKey:@"event_name"] isEqualToString:@""]) {
                        self.event_nextNameLab.text = [nextEpgDic objectForKey:@"event_name"];
                    }else
                    {
                        
                        self.event_nextNameLab.text =NOEventLabel;
                    }
                    
                }
                else
                {
                    NSString * endTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
                    if(![endTimeisHas isEqualToString:@""])
                    {
                        self.event_nextTime.text = [self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]];
                    }else{
                        self.event_nextTime.text = @"--:--";
                    }
                    
                    self.event_nextNameLab.text = NOEventLabel;
                }
                
                //    self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
                if (![[epgDic objectForKey:@"event_name"] isEqualToString:@""]) {
                    self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
                }else
                {
                    self.event_nameLab.text =NOEventLabel;
                }
            }
            
        }else
        {
            self.event_nameLab.text = NOEventLabel;
            self.event_nextNameLab.text = NOEventLabel;
        }
    }else //录播
    {
        NSLog(@"lubo 录播");
        
        //    NSLog(@"_dataDic %@",_dataDic);
        //
        // if dataDic 包含某个标记，则使用AA 显示,否则使用BB 显示
        
        self.backImage.image = [UIImage imageNamed:@"background"];
        UIImage * imageWithImage = [[UIImage alloc]init];
        imageWithImage = [self addImage:@"background" withImage:@"zOOm-Logo"];
        
        [self.channelImg sd_setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"service_logo_url"]]  placeholderImage:[UIImage imageNamed:@"placeholder1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            //[_dataDic objectForKey:@"epg_info"]
            //        image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:30];
            
            self.channelImg.contentMode = UIViewContentModeScaleAspectFit;
            
            
        }];
        
        self.event_Img.image = [UIImage imageNamed:@"play"];
        self.event_nextImg.image = [UIImage imageNamed:@"time"];
        
        
        //        NSString * serviceName = [dataDic objectForKey:@"service_name"];
        NSString * serviceName = [dataDic objectForKey:@"file_name"];
        NSString * recordTime = [dataDic objectForKey:@"record_time"];
        NSString * durationTime = [dataDic objectForKey:@"duration"];
        
        NSLog(@"serviceName %@",serviceName);
        NSLog(@"recordTime %@",recordTime);
        NSLog(@"durationTime %@",durationTime);
        
        //节目名称
        if (serviceName != NULL && ![serviceName isEqualToString:@""]) {
            self.event_nameLab.text =serviceName;
        }else
        {
            self.event_nameLab.text =NOEventLabel;
        }
        
        //总时间
        if (durationTime != NULL && ![durationTime isEqualToString:@""]) {
            
            //[durationTime doubleValue]   此处的时间不会大于24小时
            double timeTemp = [durationTime doubleValue] - 28800;
            NSString * timeTempStr = [NSString stringWithFormat:@"%f",timeTemp];
            self.event_nextTime.text =[GGUtil  timeHMSWithTimeIntervalString:timeTempStr];
            
            self.event_nextTime.frame = CGRectMake(157, 49, 60, 14);
            self.event_nextNameLab.frame = CGRectMake(220, 49, 112, 14);
            
        }else
        {
            self.event_nextTime.text =@"--:--";
        }
        
        //开始时间
        if (recordTime != NULL  && ![recordTime isEqualToString:@""]) {
            
            //            NSString * timeTempStr = [NSString stringWithFormat:@"%@",recordTime];
            self.event_nextNameLab.text = [GGUtil  timeYMDHMWithTimeIntervalString:recordTime];
        }else
        {
            self.event_nextNameLab.text =NOEventLabel;
        }
        
        
        //***
        NSDictionary * epgDic;
        NSDictionary * nextEpgDic;
        NSArray * epgArr;
        epgDic  = [[NSDictionary alloc]init];
        nextEpgDic = [[NSDictionary alloc]init];
        epgArr = [[NSArray alloc]init];
        //****
        epgArr = [_dataDic objectForKey:@"epg_info"];
        if (epgArr.count >0) {
            epgDic = epgArr[0];
            
            
            //判断第一个数据是不是没有时间戳，或者时间戳是不是比当前时间还要打，如果是，则要将数据后移
            NSString * firstDicStartTime = [epgDic objectForKey:@"event_starttime"]; //获得第一个epg的开始时间
            //    NSLog(@"firstDicStartTime %@",firstDicStartTime);
            //    NSLog(@"firstDicStartTime_nowTimeStr %@",_nowTimeStr);
            if([firstDicStartTime intValue] >[_nowTimeStr intValue])
            {
                self.event_nameLab.text =@"No Event";  //设置第一个epg 信息为空
                
                if (epgArr.count >1) {
                    nextEpgDic = epgArr[0];
                    //        NSLog(@"shijian时间：%@",[nextEpgDic  objectForKey:@"event_starttime"] );
                    NSString * startTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
                    
                    if (![startTimeisHas isEqualToString:@""]) {
                        self.event_nextTime.text = [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
                    }else{
                        self.event_nextTime.text =@"--:--";
                    }
                    
                    
                    
                    //        NSLog(@"shijian时间：%@",self.event_nextTime.text);
                    if (![[nextEpgDic objectForKey:@"event_name"] isEqualToString:@""]) {
                        self.event_nextNameLab.text = [nextEpgDic objectForKey:@"event_name"];
                    }else
                    {
                        self.event_nextNameLab.text =NOEventLabel;
                    }
                    
                }
                else
                {
                    NSString * endTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
                    if(![endTimeisHas isEqualToString:@""])
                    {
                        self.event_nextTime.text = [self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]];
                    }else{
                        self.event_nextTime.text = @"--:--";
                    }
                    
                    self.event_nextNameLab.text = NOEventLabel;
                }
                
                
                //        if (![[epgDic objectForKey:@"event_name"] isEqualToString:@""]) {
                //            self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
                //        }else
                //        {
                //            self.event_nameLab.text =@"No Event";
                //        }
            }
            
            //====================
            else
            {
                if (epgArr.count >1) {
                    nextEpgDic = epgArr[1];
                    //        NSLog(@"shijian时间：%@",[nextEpgDic  objectForKey:@"event_starttime"] );
                    NSString * startTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
                    
                    if (![startTimeisHas isEqualToString:@""]) {
                        self.event_nextTime.text = [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
                    }else{
                        self.event_nextTime.text =@"--:--";
                    }
                    
                    
                    
                    //        NSLog(@"shijian时间：%@",self.event_nextTime.text);
                    if (![[nextEpgDic objectForKey:@"event_name"] isEqualToString:@""]) {
                        self.event_nextNameLab.text = [nextEpgDic objectForKey:@"event_name"];
                    }else
                    {
                        self.event_nextNameLab.text =NOEventLabel;
                    }
                    
                }
                else
                {
                    NSString * endTimeisHas =  [self timeWithTimeIntervalString:[nextEpgDic  objectForKey:@"event_starttime"]];
                    if(![endTimeisHas isEqualToString:@""])
                    {
                        self.event_nextTime.text = [self timeWithTimeIntervalString:[epgDic  objectForKey:@"event_starttime"]];
                    }else{
                        self.event_nextTime.text = @"--:--";
                    }
                    
                    self.event_nextNameLab.text = NOEventLabel;
                }
                
                //    self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
                if (![[epgDic objectForKey:@"event_name"] isEqualToString:@""]) {
                    self.event_nameLab.text = [epgDic objectForKey:@"event_name"];
                }else
                {
                    self.event_nameLab.text =NOEventLabel;
                }
            }
            
        }
    }
    
    
    
    
    //字体设置
    self.event_nameLab.font = FONT(12);
    self.event_nextTime.font = FONT(12);
    self.event_nextNameLab.font = FONT(12);
    
    
    self.event_nameLab.textColor = CellBlackColor;
    self.event_nextTime.textColor = CellGrayColor;
    self.event_nextNameLab.textColor = CellGrayColor;
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

