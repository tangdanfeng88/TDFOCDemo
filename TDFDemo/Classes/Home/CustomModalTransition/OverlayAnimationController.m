//
//  OverlayAnimationController.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/16.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "OverlayAnimationController.h"

@interface OverlayAnimationController ()<UIViewControllerAnimatedTransitioning>

@end
@implementation OverlayAnimationController
//返回动画时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}
//执行动画的地方，最核心的方法
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //transitionContext-->提供转场中需要的数据；遵守<UIViewControllerContextTransitioning>协议；由 UIKit 在转场开始前生成并提供给我们提交的 动画控制器 和 交互控制器 使用
    
    UIView *containerView = transitionContext.containerView;
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!fromVC || !toVC) {
        return;
    }
    
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    CGFloat duration = [self transitionDuration:transitionContext];
    
    if ([toVC isBeingPresented]) {
        [containerView addSubview:toView];
        
        CGFloat toViewW = containerView.width * 2/3;
        CGFloat toViewH = containerView.height * 2/3;
        toView.center = containerView.center;
        toView.bounds = CGRectMake(0, 0, 1, toViewH);
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toView.bounds = CGRectMake(0, 0, toViewW, toViewH);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    
    //  UIModalPresentationCustom 模式转场时， containerView 并不担任 presentingView 的父视图，后者由 UIKit 另行管理。在 presentation 后，fromView(presentingView) 未被移出视图结构，在 dismissal 中，注意不要像其他转场中那样将 toView(presentingView) 加入 containerView 中，否则本来可见的 presentingView 将会被移除出自身所处的视图结构消失不见。
    if ([fromVC isBeingDismissed]) {
        CGFloat fromViewH = fromView.height;
        [UIView animateWithDuration:duration animations:^{
            fromView.bounds = CGRectMake(0, 0, 1, fromViewH);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}
@end
