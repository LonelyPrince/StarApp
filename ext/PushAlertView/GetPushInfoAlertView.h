//
//  GetPushInfoAlertView.h
//  StarAPP
//
//  Created by xyz on 2018/1/18.
//

#import <UIKit/UIKit.h>

@interface GetPushInfoAlertView : UIView

@property (nonatomic, strong) UIView *parentView;    // 要添加的父视图
@property (nonatomic, strong) UIView *dialogView;    // 内容的会话View
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray <NSString *>*buttonTitles;// 按钮文字
/*！可以不全部设置颜色，默认是蓝色 */
@property (nonatomic, strong) NSArray <UIColor *>*buttonTitleColors;// 按钮文字颜色
@property (nonatomic, assign) CGFloat buttonSpace; // 按钮间距 Default：1
@property (nonatomic, assign) BOOL useMotionEffects; // 是否视差效果
@property (nonatomic, assign) BOOL closeOnTouchUpOutside;

@property (copy) void (^onButtonTouchUpInside)(GetPushInfoAlertView *alertView, int buttonIndex) ;

- (id)init;


- (id)initWithParentView: (UIView *)parentView __attribute__ ((deprecated));

- (void)show;
- (void)close;

- (void)setOnButtonTouchUpInside:(void (^)(GetPushInfoAlertView *alertView, int buttonIndex))onButtonTouchUpInside;

- (void)deviceOrientationDidChange: (NSNotification *)notification;

@end
