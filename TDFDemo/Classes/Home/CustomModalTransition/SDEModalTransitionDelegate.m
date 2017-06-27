//
//  SDEModalTransitionDelegate.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/16.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "SDEModalTransitionDelegate.h"
#import "OverlayAnimationController.h"
#import "OverlayPresentationController.h"

@interface SDEModalTransitionDelegate ()<UIViewControllerTransitioningDelegate>

@end
@implementation SDEModalTransitionDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return (id <UIViewControllerAnimatedTransitioning>)[[OverlayAnimationController alloc] init];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return (id <UIViewControllerAnimatedTransitioning>)[[OverlayAnimationController alloc] init];
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    return [[OverlayPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

@end
