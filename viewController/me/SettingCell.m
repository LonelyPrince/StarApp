//
//  SettingCell.m
//  StarAPP
//
//  Created by xyz on 2016/10/26.
//
//

#import "SettingCell.h"

@implementation SettingCell

//awakeFromNib 从xib或者storyboard加载完毕就会调用
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    
    [self.blackLab setTextColor:RGBA(0x21, 0x21, 0x21, 1)];
     [self.grayLab setTextColor:RGBA(0x94, 0x94, 0x94, 1)];
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


@end
