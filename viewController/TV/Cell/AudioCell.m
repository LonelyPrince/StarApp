//
//  AudioCell.m
//  StarAPP
//
//  Created by xyz on 2016/10/21.
//
//

#import "AudioCell.h"

@implementation AudioCell


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
    
    self.languageLab.text = [_dataDic objectForKey:@"audio_language"];
    
    
    //字体设置
    self.languageLab.font = FONT(13);
    
    self.languageLab.textColor = [UIColor whiteColor];
    self.languageLab.tintColor = [UIColor whiteColor];
    
}


@end
