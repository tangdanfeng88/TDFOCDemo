//
//  ContainerTransitionContext.h
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/17.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomContainerTransitionVC.h"

extern NSString * const SDEContainerTransitionEndNotification;

@interface ContainerTransitionContext : NSObject
- (id)initWithContainerViewController:(CustomContainerTransitionVC *)containerViewController containerView:(UIView *)containerView fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC;

- (void)startInteractiveTransitionWith:(id<ContainerViewControllerDelegate>)delegate;
- (void)startNonInteractiveTransitionWith:(id<ContainerViewControllerDelegate>)delegate;

- (void)activateInteractiveTransition;

- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)cancelInteractiveTransition;
- (void)finishInteractiveTransition;
@end
