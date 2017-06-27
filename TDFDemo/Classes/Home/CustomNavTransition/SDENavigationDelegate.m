//
//  SDENavigationDelegate.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/15.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "SDENavigationDelegate.h"
#import "SlideAnimationController.h"

@interface SDENavigationDelegate ()<UINavigationControllerDelegate>

@end

@implementation SDENavigationDelegate
//自定义转场的第一步便是提供转场代理，告诉系统使用我们提供的代理而不是系统的默认代理来执行转场, 遵守<UINavigationControllerDelegate>协议

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

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    //如果需要自己控制交互动画的过程，需要提供一个交互控制器
    //如果在转场代理中提供了交互控制器，而转场发生时并没有方法来驱动转场进程(比如手势)，转场过程将一直处于开始阶段无法结束，应用界面也会失去响应。
    //所以在手势触发的时候才提供交互控制器，手势完后不提供，走默认的动画，而不是交互动画。
    return self.interactive ? self.interactionCotroller : nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    return (id <UIViewControllerAnimatedTransitioning>)[[SlideAnimationController alloc] initWithOperation:operation];
}
@end
