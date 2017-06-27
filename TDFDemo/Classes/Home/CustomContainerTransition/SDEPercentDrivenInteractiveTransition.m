//
//  SDEPercentDrivenInteractiveTransition.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/17.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "SDEPercentDrivenInteractiveTransition.h"
#import "ContainerTransitionContext.h"

@interface SDEPercentDrivenInteractiveTransition ()<UIViewControllerInteractiveTransitioning>
//为啥要弱引用
@property (nonatomic, weak) ContainerTransitionContext *transitionContext;
@end
@implementation SDEPercentDrivenInteractiveTransition
//遵守 UIViewControllerInteractiveTransitioning 协议，实现自己的交互控制器，用于控制交互动画的过程

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if ([transitionContext isKindOfClass:[ContainerTransitionContext class]]) {
        self.transitionContext = (ContainerTransitionContext *)transitionContext;
        [self.transitionContext activateInteractiveTransition];
    } else {
        DLog(@"%@ is not class or subclass of ContainerTransitionContext", transitionContext);
    }
}
- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    [self.transitionContext updateInteractiveTransition:percentComplete];
}
- (void)cancelInteractiveTransition
{
    [self.transitionContext cancelInteractiveTransition];
}
- (void)finishInteractiveTransition
{
    [self.transitionContext finishInteractiveTransition];
}
@end
