//
//  UIViewController+animationView.m
//  StarAPP
//
//  Created by xyz on 2017/8/1.
//
//

#import "UIViewController+animationView.h"
#import <objc/runtime.h>

//static const void *kName = "name";
static const void *kHasAnimating = @"Animating";
//static const void *kBackgroundImage = @"backgroundImage";

@implementation UIViewController (Information)

//#pragma mark - 字符串类型的动态绑定
//- (NSString *)name {
//    return objc_getAssociatedObject(self, kName);
//}
//
//- (void)setName:(NSString *)name {
//    objc_setAssociatedObject(self, kName, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

#pragma mark - BOOL类型的动态绑定
- (BOOL)Animating {
    return [objc_getAssociatedObject(self, kHasAnimating) boolValue];
}

- (void)setAnimating:(BOOL)Animating {
    objc_setAssociatedObject(self, kHasAnimating, [NSNumber numberWithBool:Animating], OBJC_ASSOCIATION_ASSIGN);
}

//#pragma mark - 类类型的动态绑定
//- (UIImage *)backgroundImage {
//    return objc_getAssociatedObject(self, kBackgroundImage);
//}
//
//- (void)setBackgroundImage:(UIImage *)backgroundImage {
//    objc_setAssociatedObject(self, kBackgroundImage, backgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
@end
