//
//  UINavigationController+GGInteractiveTransition.m
//  StartUp4iOS
//
//  Created by Ron1 on 21/5/14.
//  Copyright (c) 2014 HGG. All rights reserved.
//

#import "UINavigationController+GGInteractiveTransition.h"
#import <objc/runtime.h>

static id NavigationTransitionController;

const static NSTimeInterval RSTransitionVendorAnimationDuration = 0.4;

@interface GGNavigationTransitionController : NSObject<UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL isInteractive;

@property (nonatomic) UINavigationControllerOperation opperation;
@property (nonatomic, weak) UINavigationController * parentNavigationController;
@property (nonatomic) UIPercentDrivenInteractiveTransition * percentDrivenInteractiveTransition;
@property (nonatomic, strong) UIPanGestureRecognizer *panGR;

@end

@implementation GGNavigationTransitionController

- (id)init
{
    self = [super init];
    return self;
}

- (UIPanGestureRecognizer*)panGR
{
    if (!_panGR) {
        _panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanBack:)];
    }
    return _panGR;
}

- (id)initWithParentNavigationController:(UINavigationController *)parentNavigationController;
{
    self = [super init];
    if (self)
    {
        NSCAssert([parentNavigationController isKindOfClass:[UINavigationController class]], @"it must be class of UINavigationController");
        
        parentNavigationController.delegate = self;
        
        _parentNavigationController = parentNavigationController;
        
        [_parentNavigationController.view addGestureRecognizer:self.panGR];
        
        UIPercentDrivenInteractiveTransition * interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        
        interactiveTransition.completionCurve = UIViewAnimationCurveEaseInOut;
        interactiveTransition.completionSpeed = 0.99;
        
        self.percentDrivenInteractiveTransition = interactiveTransition;
    }
    return self;
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (!self.isInteractive)
    {
        return nil;
    }
    
    return self.percentDrivenInteractiveTransition;
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (self.opperation == UINavigationControllerOperationPop && !self.isInteractive) {
        return nil;
    }
    self.opperation = operation;    
    return self;
}

- (void)didPanBack:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if ([panGestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        self.isInteractive = YES;
        [self.parentNavigationController popViewControllerAnimated:YES];
    }
    
    if (!self.isInteractive)
    {
        return;
    }
    
    switch ([panGestureRecognizer state])
    {
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
            
            CGFloat distanceMovedAcross = translation.x;
            CGFloat totalViewWidth = panGestureRecognizer.view.frame.size.width;
            
            CGFloat percentagePanned = distanceMovedAcross / totalViewWidth;
            if (percentagePanned < 0) percentagePanned = 0;
            
            [self.percentDrivenInteractiveTransition updateInteractiveTransition:percentagePanned];
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            CGPoint velocity = ([panGestureRecognizer velocityInView:panGestureRecognizer.view]);
            CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
            CGFloat distanceMovedAcross = translation.x;
            CGFloat totalViewWidth = panGestureRecognizer.view.frame.size.width;
            
            CGFloat projectedXPositionAfterShortTime = distanceMovedAcross + velocity.x * 0.2;
            
            if ([panGestureRecognizer state] != UIGestureRecognizerStateCancelled &&
                projectedXPositionAfterShortTime >= totalViewWidth / 2)
            {
                [self.percentDrivenInteractiveTransition finishInteractiveTransition];
            }
            else
            {
                [self.percentDrivenInteractiveTransition cancelInteractiveTransition];
            }
            
            self.isInteractive = NO;
            break;
        }
            
        default:
            break;
    }
}

- (void)animationEnded:(BOOL) transitionCompleted
{
    self.opperation = UINavigationControllerOperationNone;
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return RSTransitionVendorAnimationDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    CGRect finalToViewControllerFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect initialFromViewControllerFrame = [transitionContext initialFrameForViewController:fromViewController];
    
    CGFloat toViewStartX;
    CGFloat fromViewEndX;
    
    CGFloat width = self.parentNavigationController.view.bounds.size.width;
    
    if (self.opperation == UINavigationControllerOperationPush)
    {
        toViewStartX = width;
        fromViewEndX = -width;
    }
    else
    {
        toViewStartX = -width;
        fromViewEndX = width;
    }
    
    CGRect finalFromViewControllerFrame = CGRectMake(fromViewEndX, 0,
                                                     finalToViewControllerFrame.size.width,
                                                     finalToViewControllerFrame.size.height);
    
    CGRect initalToViewControllerFrame = CGRectMake(toViewStartX, 0,
                                                    finalToViewControllerFrame.size.width,
                                                    finalToViewControllerFrame.size.height);
    
    toViewController.view.frame = initalToViewControllerFrame;
    fromViewController.view.frame = initialFromViewControllerFrame;
    
    [UIView animateWithDuration:RSTransitionVendorAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        toViewController.view.frame = finalToViewControllerFrame;
        fromViewController.view.frame = finalFromViewControllerFrame;
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


@end


@implementation UINavigationController(GGInteractiveTransition)

- (void)fullScreenInteractiveTransitionEnable:(BOOL)enable
{
    GGNavigationTransitionController *transitionController = objc_getAssociatedObject(self, &NavigationTransitionController);
    if (enable) {
        if (!transitionController) {
            transitionController = [[GGNavigationTransitionController alloc] initWithParentNavigationController:self];
            objc_setAssociatedObject(self, &NavigationTransitionController,
                                     transitionController,
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
        }
    }else {
        if (transitionController) {
            [transitionController.parentNavigationController.view removeGestureRecognizer:transitionController.panGR];
            transitionController.parentNavigationController.delegate = nil;
            transitionController.parentNavigationController = nil;
            objc_setAssociatedObject(self, &NavigationTransitionController, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

@end
