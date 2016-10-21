//
//  subtCell.m
//  StarAPP
//
//  Created by xyz on 2016/10/21.
//
//

#import "subtCell.h"

@implementation subtCell

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
    return 90;
}

//设置接口数据
-(void) setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSLog(@"sub _dataDic : %@",_dataDic);
    
    self.languageLab.text = [_dataDic objectForKey:@"subt_language"];
    
    
    //字体设置
    self.languageLab.font = FONT(13);
    
    self.languageLab.textColor = [UIColor redColor];
    self.languageLab.tintColor = [UIColor redColor];
    
}


@end
