//
//  SDETabBarVCDelegate.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/16.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "SDETabBarVCDelegate.h"
#import "SlideTabAnimationController.h"

@interface SDETabBarVCDelegate ()<UITabBarControllerDelegate>

@end

@implementation SDETabBarVCDelegate
- (instancetype)init
{
    self = [super init];
    if (self) {
        _interactive = false;
        //交互控制器
        _interactionCotroller = [[UIPercentDrivenInteractiveTransition alloc] init];
    }
    return self;
}
- (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                               interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactive ? self.interactionCotroller : nil;
}
- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC
{
    NSInteger fromIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSInteger toIndex = [tabBarController.viewControllers indexOfObject:toVC];
    
    TabOperationDirection direction = toIndex<fromIndex ? left : right;
    
    return  (id <UIViewControllerAnimatedTransitioning>)[[SlideTabAnimationController alloc] initWithDirection:direction];
}

@end
