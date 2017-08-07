//
//  UITextField+NOPasteTextField.m
//  StarAPP
//
//  Created by xyz on 2017/8/7.
//
//

#import "UITextField+NOPasteTextField.h"

@implementation UITextField (NOPasteTextField)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//        if (action == @selector(paste:))//禁止粘贴
//            return NO;
//        if (action == @selector(select:))// 禁止选择
//            return NO;
//        if (action == @selector(selectAll:))// 禁止全选
//            return NO;
//        if (action == @selector(cut:))// 禁止剪切
//            return NO;
//        if (action == @selector(copy:))// 禁止复制
//            return NO;
//        return [super canPerformAction:action withSender:sender];
//    
//    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    if (menuController)
//    {
//        [UIMenuController sharedMenuController].menuVisible = NO;
//    }
    return NO;
}
@end
