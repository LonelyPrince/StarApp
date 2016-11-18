//
//  ChannelCell.m
//  StarAPP
//
//  Created by xyz on 2016/10/21.
//
//

#import "ChannelCell.h"

@implementation ChannelCell

//awakeFromNib 从xib或者storyboard加载完毕就会调用
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
+ (CGFloat)defaultCellHeight
{
    return 45;
}

//设置接口数据
-(void) setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSLog(@"sub _dataDic : %@",_dataDic);
    
    
    
    
    self.channelId.text = [_dataDic objectForKey:@"service_logic_number"];
    
//    self.channelId.text = @"aaa";
//    self.channelName.text = @"bbb";
    

    if(self.channelId.text.length == 1)
    {
        self.channelId.text  = [NSString stringWithFormat:@"00%@",self.channelId.text];
    }
    else if (self.channelId.text.length == 2)
    {
        self.channelId.text  = [NSString stringWithFormat:@"0%@",self.channelId.text];
    }
    else if (self.channelId.text.length == 3)
    {
        self.channelId.text  = [NSString stringWithFormat:@"%@",self.channelId.text];
    }
    else if (self.channelId.text.length > 3)
    {
        self.channelId.text  = [self.channelId.text substringFromIndex:self.channelId.text.length - 3];
    }
    self.channelName.text = [_dataDic objectForKey:@"service_name"];
    
    
    

    

//    //字体设置
    self.channelId.font = FONT(13);
    self.channelName.font = FONT(13);
    
    self.channelId.textColor = [UIColor whiteColor];
    self.channelId.tintColor = [UIColor whiteColor];
    
    self.channelName.textColor = [UIColor whiteColor];
    self.channelName.tintColor = [UIColor whiteColor];
    
}

@end
