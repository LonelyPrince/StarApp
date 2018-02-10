//
//  GetPushInfoAlertView.m
//  StarAPP
//
//  Created by xyz on 2018/1/18.
//

#import "GetPushInfoAlertView.h"
#import <QuartzCore/QuartzCore.h>
// 按钮默认高度
const static CGFloat kCustomAlertViewDefaultButtonHeight       = 50;
const static CGFloat kCustomAlertViewDefaultButtonSpacerHeight = 1;
const static CGFloat kCustomAlertViewCornerRadius              = 7;
const static CGFloat kCustomMotionEffectExtent                = 10.0;



@interface GetPushInfoAlertView ()
{
    CGFloat buttonHeight ;
    CGFloat buttonSpacerHeight ;
}
@end
@implementation GetPushInfoAlertView
 

- (id)initWithParentView: (UIView *)parentView
{
    self = [self init];
    if (parentView) {
        self.frame = parentView.frame;
        self.parentView = parentView;
    }
    buttonHeight = 0;
    buttonSpacerHeight = 0;
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

        _useMotionEffects = NO;
        _closeOnTouchUpOutside = NO;
        _buttonTitles = @[@"关闭"];
        _buttonSpace = 1;

        // 必须调用beginGeneratingDeviceOrientationNotifications方法后，此orientation属性才有效，否则一直是0。orientation用于判断设备的朝向，与应用UI方向无关
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
//
#pragma mark  - show
- (void)show
//- (void)show:(int)viewIndex
{
    // 1.UI
    _dialogView = [self createContainerView];

    _dialogView.layer.shouldRasterize = YES;
    _dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    

    // 2.animation
#if (defined(__IPHONE_7_0))
    if (_useMotionEffects) {
        [self applyMotionEffects];
    }
#endif

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    //层级叠加
    [self addSubview:_dialogView];
    
//    int intTemp = 1000;
//
//    intTemp = intTemp - viewIndex;
//
//
//    [self insertSubview:_dialogView atIndex:intTemp];

//    [self sendSubviewToBack:_dialogView];
    

    if (_parentView != NULL) {
        [_parentView addSubview:self];

    } else {

        // iOS7 计算位置
        if (floor(NSFoundationVersionNumber) <=NSFoundationVersionNumber_iOS_7_1) {

            UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            switch (interfaceOrientation) {
                case UIInterfaceOrientationLandscapeLeft:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                    break;

                case UIInterfaceOrientationLandscapeRight:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                    break;

                case UIInterfaceOrientationPortraitUpsideDown:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                    break;

                default:
                    break;
            }

            [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

            // On 8, just place the dialog in the middle
        } else {

            CGSize screenSize = [self countScreenSize];
            CGSize dialogSize = [self countDialogSize];
            CGSize keyboardSize = CGSizeMake(0, 0);

            _dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);

        }

        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }

    _dialogView.layer.opacity = 0.5f;
    _dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         _dialogView.layer.opacity = 1.0f;
                         _dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];

}

#pragma mark - 关闭按钮Action
- (void)closeAction:(id)sender
{

    if (_onButtonTouchUpInside != NULL) {
        _onButtonTouchUpInside(self, (int)[sender tag]);
    }
}

// 关闭
- (void)close
{
    NSLog(@"guanbi lelelelelelelelel");
   
    double delayInSeconds = 0.3;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, mainQueue, ^{
       
        NSNotification *notification =[NSNotification notificationWithName:@"reducePushSharingViewNotific" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    });
   
    
    CATransform3D currentTransform = _dialogView.layer.transform;

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[_dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);

        _dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }

    _dialogView.layer.opacity = 1.0f;

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         _dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         _dialogView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}


#pragma mark - setupUI
- (UIView *)createContainerView
{
    if (_containerView == NULL) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    }

    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];

    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];


    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];


    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       nil];

    CGFloat cornerRadius = kCustomAlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    [dialogContainer.layer insertSublayer:gradient atIndex:0];

    dialogContainer.layer.cornerRadius = cornerRadius;
    dialogContainer.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
    dialogContainer.layer.borderWidth = 1;
    dialogContainer.layer.shadowRadius = cornerRadius + 5;
    dialogContainer.layer.shadowOpacity = 0.1f;
    dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;


    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, dialogContainer.bounds.size.height - buttonHeight - buttonSpacerHeight, dialogContainer.bounds.size.width, buttonSpacerHeight)];
    lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
    [dialogContainer addSubview:lineView];


    [dialogContainer addSubview:_containerView];


    [self addButtonsToView:dialogContainer];

    return dialogContainer;
}


- (void)addButtonsToView: (UIView *)container
{
    if (_buttonTitles == NULL) { return; }

    CGFloat buttonWidth = (container.bounds.size.width - self.buttonSpace * (_buttonTitles.count - 1)) / [_buttonTitles count];

    for (int i=0; i<[_buttonTitles count]; i++) {

        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [closeButton setFrame:CGRectMake(i * (buttonWidth + self.buttonSpace), container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight)];

        [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];

        [closeButton setTitle:[_buttonTitles objectAtIndex:i] forState:UIControlStateNormal];

        if (self.buttonTitleColors.count > i && self.buttonTitleColors[i]) {

            [closeButton setTitleColor:self.buttonTitleColors[i] forState:UIControlStateNormal];
            [closeButton setTitleColor:self.buttonTitleColors[i] forState:UIControlStateHighlighted];

        }else{
            [closeButton setTitleColor:[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
            [closeButton setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];
        }

        [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        closeButton.titleLabel.numberOfLines = 0;
        closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        //        [closeButton.layer setCornerRadius:kCustomAlertViewCornerRadius];
        closeButton.backgroundColor = [UIColor whiteColor];


        if (self.buttonTitles.count > 1) {

            if (i == 0) {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:closeButton.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(kCustomAlertViewCornerRadius,kCustomAlertViewCornerRadius)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];        maskLayer.frame = closeButton.bounds;
                maskLayer.path = maskPath.CGPath;
                closeButton.layer.mask  = maskLayer;

            }else if(i == self.buttonTitles.count - 1){

                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:closeButton.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(kCustomAlertViewCornerRadius,kCustomAlertViewCornerRadius)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];        maskLayer.frame = closeButton.bounds;
                maskLayer.path = maskPath.CGPath;
                closeButton.layer.mask  = maskLayer;
            }
        }else{


            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:closeButton.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(kCustomAlertViewCornerRadius,kCustomAlertViewCornerRadius)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];        maskLayer.frame = closeButton.bounds;
            maskLayer.path = maskPath.CGPath;
            closeButton.layer.mask  = maskLayer;
        }


        [container addSubview:closeButton];
    }
}


- (CGSize)countDialogSize
{
    CGFloat dialogWidth = _containerView.frame.size.width;
    CGFloat dialogHeight = _containerView.frame.size.height + buttonHeight + buttonSpacerHeight;

    return CGSizeMake(dialogWidth, dialogHeight);
}

//// 计算
- (CGSize)countScreenSize
{
    if (_buttonTitles!=NULL && [_buttonTitles count] > 0) {
        buttonHeight       = kCustomAlertViewDefaultButtonHeight;
        buttonSpacerHeight =  kCustomAlertViewDefaultButtonSpacerHeight;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    // ios7
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }

    return CGSizeMake(screenWidth, screenHeight);
}

#if (defined(__IPHONE_7_0))
// Add motion effects
- (void)applyMotionEffects {


    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }

    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kCustomMotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kCustomMotionEffectExtent);

    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kCustomMotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kCustomMotionEffectExtent);

    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];

    [_dialogView addMotionEffect:motionEffectGroup];
}
#endif
//
//
//
//// iOS7
- (void)changeOrientationFor7 {

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;

    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;

        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;

        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;

        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         _dialogView.transform = rotation;

                     }
                     completion:nil
     ];

}

// iOS 8
- (void)changeOrientationFor8: (NSNotification *)notification {

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGSize dialogSize = [self countDialogSize];
                         CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                         self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                         _dialogView.frame = CGRectMake((screenWidth - dialogSize.width) / 2, (screenHeight - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];


}


- (void)deviceOrientationDidChange: (NSNotification *)notification
{

    if (_parentView != NULL) {
        return;
    }

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self changeOrientationFor7];
    } else {
        [self changeOrientationFor8:notification];
    }
}

- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         _dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         _dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                     }
                     completion:nil
     ];
}
//
//

@end
