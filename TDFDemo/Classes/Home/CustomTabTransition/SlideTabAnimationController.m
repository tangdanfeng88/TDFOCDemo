//
//  SlideAnimationController.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/16.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "SlideTabAnimationController.h"

@interface SlideTabAnimationController ()<UIViewControllerAnimatedTransitioning>
{
    TabOperationDirection _direction;
}
@end
@implementation SlideTabAnimationController
- (id)initWithDirection:(TabOperationDirection)direction
{
    self = [super init];
    if (self) {
        _direction = direction;
    }
    return self;
}
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}
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
    
    CGFloat translation = fromView.width;
    CGAffineTransform toViewTransform = CGAffineTransformIdentity;
    CGAffineTransform fromViewTransform = CGAffineTransformIdentity;
    
    translation = _direction==left ? translation : -translation;
    toViewTransform = CGAffineTransformMakeTranslation(-translation, 0);
    fromViewTransform = CGAffineTransformMakeTranslation(translation, 0);
    
    [containerView addSubview:toView];
    
    toView.transform = toViewTransform;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.transform = fromViewTransform;
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
@end
