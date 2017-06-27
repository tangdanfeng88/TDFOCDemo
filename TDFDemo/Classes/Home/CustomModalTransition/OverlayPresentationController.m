//
//  OverlayPresentationController.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/16.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "OverlayPresentationController.h"

@interface OverlayPresentationController ()
{
    UIView *dimmingView;
}
@end
@implementation OverlayPresentationController
//presentingView 和 presentedView 的转场动画放在动画控制器 OverlayAnimationController 中处理
//其他相关view的处理放在 OverlayPresentationController 中

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(nullable UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentedViewController];
    if (self) {
        dimmingView = [[UIView alloc] init];
    }
    return self;
}

- (void)presentationTransitionWillBegin
{
    [self.containerView addSubview:dimmingView];
    
    CGFloat dimmingViewW = self.containerView.width * 2/3;
    CGFloat dimmingViewH = self.containerView.height * 2/3;
    dimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    dimmingView.center = self.containerView.center;
    dimmingView.bounds = CGRectMake(0, 0, dimmingViewW, dimmingViewH);
    
    //transitionCoordinator--转场协调器，一个与当前转场有关的对象，作用是可以，与动画控制器中的转场动画同步，执行其他动画
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        dimmingView.bounds = self.containerView.bounds;
    } completion:nil];
}
- (void)dismissalTransitionWillBegin
{
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        dimmingView.alpha = 0.0;
    } completion:nil];
}

//Custom 模式的 Modal 转场里，presentingView 不会被移除，但通过 UIPresentationController 的下面这个方法可以决定presentingView 是否在 presentation 转场结束后被移除，返回 true 时，presentation 结束后 presentingView 被移除，在 dimissal 结束后 UIKit 会自动将 presentingView 恢复到原来的视图结构中。
- (BOOL)shouldRemovePresentersView
{
    return NO;
}

//在 Modal 转场中如果提供了UIPresentationController，则由UIPresentationController负责UIViewController的尺寸变化和屏幕旋转，最终的布局机会也在UIPresentationController。重写以下方法来调整视图布局以及应对屏幕旋
- (void)containerViewWillLayoutSubviews
{
    dimmingView.center = self.containerView.center;
    dimmingView.bounds = self.containerView.bounds;
    
    CGFloat W = self.containerView.width * 2/3;
    CGFloat H = self.containerView.height * 2/3;
    self.presentedView.center = self.containerView.center;
    self.presentedView.bounds = CGRectMake(0, 0, W, H);
}

@end
