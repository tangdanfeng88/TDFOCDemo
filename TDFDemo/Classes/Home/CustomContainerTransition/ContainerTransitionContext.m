//
//  ContainerTransitionContext.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/17.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "ContainerTransitionContext.h"
#import "SDEPercentDrivenInteractiveTransition.h"

NSString * const SDEContainerTransitionEndNotification = @"Notification.ContainerTransitionEnd.seedante";

//遵守 UIViewControllerContextTransitioning 协议，实现自己的TransitionContext，供 动画控制器 和 交互控制器 使用
@interface ContainerTransitionContext ()<UIViewControllerContextTransitioning>
{
    id<UIViewControllerAnimatedTransitioning> animationController;
    UIViewController *privateFromViewController;
    UIViewController *privateToViewController;
    CustomContainerTransitionVC *privateContainerViewController;
    UIView *privateContainerView;
    CGFloat transitionDuration;//动画时间
    CGFloat transitionPercent;//动画进度
    BOOL isInteractive;
    BOOL isCancelled;
    NSInteger fromIndex;
    NSInteger toIndex;
}
@end
@implementation ContainerTransitionContext
//CAMediaTiming协议属性对动画的控制
// 1.speed --->作用类似于播放器上控制加速/减速播放，默认为1，以正常速度播放动画，为0时，动画将暂停
// 2.timeOffset --->类似于拖动进度条，对一个2秒的动画，该属性为1的话，动画将跳到中间的部分，但当动画从中间播放到预定的末尾时，会续上0秒到1秒的动画部分
// 3.beginTime --->动画相对于父 layer 延迟开始的时间
// 4.一次动画结束后 最好将以上各值设为初始值 speed=1 timeOffset=0 beginTime=0 否则可能导致一些错误
// 5.暂停动画实现
//    -(void)pauseLayer:(CALayer*)layer
//    {
//        CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
//        layer.speed = 0.0; //让CALayer的时间停止走动
//        layer.timeOffset = pausedTime; //让CALayer的时间停留在pausedTime这个时刻
//    }
// 6.恢复动画实现
//    -(void)resumeLayer:(CALayer*)layer
//    {
//        CFTimeInterval pausedTime = [layer timeOffset];
//        layer.speed = 1.0; //让CALayer的时间继续行走
//        layer.timeOffset = 0.0; //重设 timeOffset 和 beginTime 的目的是接下来调用convertTime:fromLayer:得到正确的值
//        layer.beginTime = 0.0;
//        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime; //计算暂停的时间
//        layer.beginTime = timeSincePause; //设置相对于父坐标系的开始时间
//    }
// 7.动画暂停和恢复的理解
/*
 核心动画的运行有一个媒体时间的概念，假设将一个旋转动画设置旋转一周用时60秒的话，那么当动画旋转90度后媒体时间就是15秒。如果此时要将动画暂停只需要让媒体时间偏移量设置为15秒即可，并把动画运行速度设置为0使其停止运动。类似的，如果又过了60秒后需要恢复动画（此时媒体时间为75秒），这时只要将动画开始，开始时间设置为当前媒体时间75秒减去暂停时的时间（也就是之前定格动画时的偏移量）15秒（开始时间=75-15=60秒），那么动画就会重新计算60秒后的状态再开始运行，与此同时将偏移量重新设置为0并且把运行速度设置1。这个过程中真正起到暂停动画和恢复动画的其实是动画速度的调整，媒体时间偏移量以及恢复时的开始时间设置主要为了让动画更加连贯。
 */


- (id)initWithContainerViewController:(CustomContainerTransitionVC *)containerViewController containerView:(UIView *)containerView fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self = [super init];
    if (self) {
        privateContainerViewController = containerViewController;
        privateFromViewController = fromVC;
        privateToViewController = toVC;
        privateContainerView = containerView;
        fromIndex = [containerViewController.viewControllers indexOfObject:fromVC];
        toIndex = [containerViewController.viewControllers indexOfObject:toVC];
        
        //每次转场开始前都会生成这个对象，调整 toView 的尺寸适用屏幕
        privateToViewController.view.frame = privateContainerView.bounds;
    }
    return self;
}
- (void)startInteractiveTransitionWith:(id<ContainerViewControllerDelegate>)delegate
{
    animationController = [delegate containerController:privateContainerViewController animationControllerForTransitionFromViewController:privateFromViewController toViewController:privateToViewController];
    transitionDuration = [animationController transitionDuration:self];
    if (privateContainerViewController.interactive) {
        id<UIViewControllerInteractiveTransitioning> interactionController = [delegate containerController:privateContainerViewController interactionControllerForAnimationController:animationController];
        if (interactionController) {
            [interactionController startInteractiveTransition:self];
        } else {
            [MyTool showToastWithStr:@"Need interaction controller for interactive transition."];
        }
        
    } else {
        [MyTool showToastWithStr:@"ContainerTransitionContext's Property 'interactive' must be true before starting interactive transiton"];
    }
}
- (void)startNonInteractiveTransitionWith:(id<ContainerViewControllerDelegate>)delegate
{
    animationController = [delegate containerController:privateContainerViewController animationControllerForTransitionFromViewController:privateFromViewController toViewController:privateToViewController];
    transitionDuration = [animationController transitionDuration:self];
    [self activateNonInteractiveTransition];
}
//交互控制器将调用这方法
- (void)activateInteractiveTransition
{
    isInteractive = YES;
    isCancelled = NO;
    [privateContainerViewController addChildViewController:privateToViewController];
    //交互时，开始动画前将 speed 设为0，动画将停留在开始的时候，然后通过 updateInteractiveTransition: 方法控制动画 timeOffset 来控制动画进度
    privateContainerView.layer.speed = 0;
    [animationController animateTransition:self];
}
- (void)activateNonInteractiveTransition
{
    isInteractive = NO;
    isCancelled = NO;
    [privateContainerViewController addChildViewController:privateToViewController];
    [animationController animateTransition:self];
}
#pragma mark -- UIViewControllerContextTransitioning 协议方法
- (UIView *)containerView
{
    return privateContainerView;
}
- (BOOL)isAnimated
{
    return animationController != nil;
}
- (BOOL)isInteractive
{
    return isInteractive;
}
- (BOOL)transitionWasCancelled
{
    return isCancelled;
}
- (UIModalPresentationStyle)presentationStyle
{
    return UIModalPresentationCustom;
}
- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    if (animationController && isInteractive) {
        transitionPercent = percentComplete;
        privateContainerView.layer.timeOffset = (NSTimeInterval)percentComplete * transitionDuration; //timeOffset 来控制动画进度
        [privateContainerViewController graduallyChangeTabButtonAppearWith:fromIndex toIndex:toIndex percent:percentComplete];
    }
}
- (void)finishInteractiveTransition
{
    isInteractive = NO;
    NSTimeInterval pausedTime = privateContainerView.layer.timeOffset;
    privateContainerView.layer.speed = 1.0;
    privateContainerView.layer.timeOffset = 0.0;
    privateContainerView.layer.beginTime = 0.0;
    NSTimeInterval timeSincePause = [privateContainerView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    privateContainerView.layer.beginTime = timeSincePause;
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(finishChangeButtonAppear:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    //当 CustomContainerTransitionVC 作为一个子 VC 内嵌在其他容器 VC 内，比如 NavigationController 里时，在 CustomContainerTransitionVC 内完成一次交互转场后
    //在外层的 NavigationController push 其他 VC 然后 pop 返回时，且仅限于交互控制，会出现 containerView 不见的情况，pop 完成后就恢复了。
    //根源在于此时 beginTime 被修改了，在转场结束后恢复为 0 就可以了。解决灵感来自于如果没有一次完成了交互转场而全部是中途取消的话就不会出现这个 Bug。
    NSTimeInterval remainingTime = (NSTimeInterval)(1-transitionPercent)*transitionDuration;
    [self performSelector:@selector(fixBeginTimeBug) withObject:nil afterDelay:remainingTime];
}
- (void)cancelInteractiveTransition
{
    isInteractive = NO;
    isCancelled = YES;
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(reverseCurrentAnimation:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
- (void)pauseInteractiveTransition
{
    
}
- (void)completeTransition:(BOOL)didComplete
{
    if (didComplete) {
        [privateToViewController didMoveToParentViewController:privateContainerViewController];
        
        [privateFromViewController willMoveToParentViewController:nil];
        [privateFromViewController.view removeFromSuperview];
        [privateFromViewController removeFromParentViewController];
    } else {
        [privateToViewController didMoveToParentViewController:privateContainerViewController];
        
        [privateToViewController willMoveToParentViewController:nil];
        [privateToViewController.view removeFromSuperview];
        [privateToViewController removeFromParentViewController];
    }
    [self transitionEnd];
}
- (UIViewController *)viewControllerForKey:(UITransitionContextViewControllerKey)key
{
    if ([key isEqualToString:UITransitionContextFromViewControllerKey]) {
        return privateFromViewController;
    } else if ([key isEqualToString:UITransitionContextToViewControllerKey]) {
        return privateToViewController;
    } else {
        return nil;
    }
}
- (UIView *)viewForKey:(UITransitionContextViewKey)key
{
    if ([key isEqualToString:UITransitionContextFromViewKey]) {
        return privateFromViewController.view;
    } else if ([key isEqualToString:UITransitionContextToViewKey]) {
        return privateToViewController.view;
    } else {
        return nil;
    }
}
- (CGAffineTransform)targetTransform
{
    return CGAffineTransformIdentity;
}
- (CGRect)initialFrameForViewController:(UIViewController *)vc
{
    return CGRectZero;
}
- (CGRect)finalFrameForViewController:(UIViewController *)vc
{
    return  vc.view.frame;
}
#pragma mark --- 私有方法
- (void)finishChangeButtonAppear:(CADisplayLink *)displayLink
{
    CGFloat percentFrame = 1 / (transitionDuration * 60);
    transitionPercent += percentFrame;
    if (transitionPercent < 1.0) {
        [privateContainerViewController graduallyChangeTabButtonAppearWith:fromIndex toIndex:toIndex percent:transitionPercent];
    } else {
        [privateContainerViewController graduallyChangeTabButtonAppearWith:fromIndex toIndex:toIndex percent:1.0];
        [displayLink invalidate];
    }
}
- (void)reverseCurrentAnimation:(CADisplayLink *)displayLink
{
    CGFloat timeOffset = privateContainerView.layer.timeOffset - displayLink.duration;
    if (timeOffset > 0) {
        privateContainerView.layer.timeOffset = timeOffset;
        transitionPercent = (CGFloat)(timeOffset / transitionDuration);
        [privateContainerViewController graduallyChangeTabButtonAppearWith:fromIndex toIndex:toIndex percent:transitionPercent];
    } else {
        [displayLink invalidate];
        privateContainerView.layer.timeOffset = 0;
        privateContainerView.layer.speed = 1;
        [privateContainerViewController graduallyChangeTabButtonAppearWith:fromIndex toIndex:toIndex percent:0];
        
        //修复闪屏Bug: speed 恢复为1后，动画会立即跳转到它的最终状态，而 fromView 的最终状态是移动到了屏幕之外，因此在这里添加一个假的掩人耳目。
        //为何不等 completion block 中恢复 fromView 的状态后再恢复 containerView.layer.speed，事实上那样做无效，原因未知。
        
        //snapshotViewAfterScreenUpdates 获取当前uiview的屏幕快照，no表示立马获取该视图现在状态的快照，yes表示所有效果应用在视图上了以后再获取快照。
        UIView *fakeFromView = [privateContainerView snapshotViewAfterScreenUpdates:NO];
        [privateContainerView addSubview:fakeFromView];
        [self performSelector:@selector(removeFakeFromView:) withObject:fakeFromView afterDelay:1/60];
    }
}
- (void)removeFakeFromView:(UIView *)fakeView
{
    [fakeView removeFromSuperview];
}
- (void)transitionEnd
{
    if (animationController && [animationController respondsToSelector:@selector(animationEnded:)]) {
        [animationController animationEnded:!isCancelled];
    }
    //如果交互取消，恢复数据
    if (isCancelled) {
        [privateContainerViewController restoreSelectedIndex];
        isCancelled = NO;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SDEContainerTransitionEndNotification object:nil];
}
- (void)fixBeginTimeBug
{
    privateContainerView.layer.beginTime = 0.0;
}
@end
