//
//  ContainerTransitionDelegate.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/17.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "SDEContainerTransitionDelegate.h"
#import "CustomContainerTransitionVC.h"
#import "SlideCCAnimaionController.h"

@interface SDEContainerTransitionDelegate ()<ContainerViewControllerDelegate>

@end

@implementation SDEContainerTransitionDelegate
- (instancetype)init
{
    self = [super init];
    if (self) {
        //交互控制器
        _interactionCotroller = [[SDEPercentDrivenInteractiveTransition alloc] init];
    }
    return self;
}
- (nullable id <UIViewControllerInteractiveTransitioning>)containerController:(CustomContainerTransitionVC *)containerController
                               interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController
{
    return (id<UIViewControllerInteractiveTransitioning>)self.interactionCotroller;
}
- (nullable id <UIViewControllerAnimatedTransitioning>)containerController:(CustomContainerTransitionVC *)containerController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC
{
    NSInteger fromIndex = [containerController.viewControllers indexOfObject:fromVC];
    NSInteger toIndex = [containerController.viewControllers indexOfObject:toVC];
    
    CCTabOperationDirection direction = toIndex<fromIndex ? CC_left : CC_right;
    
    return  (id <UIViewControllerAnimatedTransitioning>)[[SlideCCAnimaionController alloc] initWithDirection:direction];
}

@end
