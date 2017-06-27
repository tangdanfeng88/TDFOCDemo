//
//  CustomContainerTransitionVC.h
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/15.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "BaseUIViewController.h"

@class CustomContainerTransitionVC;

@protocol ContainerViewControllerDelegate <NSObject>
@optional

- (id <UIViewControllerInteractiveTransitioning>)containerController:(CustomContainerTransitionVC *)containerController
                                  interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController;
- (id <UIViewControllerAnimatedTransitioning>)containerController:(CustomContainerTransitionVC *)containerController
                        animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                          toViewController:(UIViewController *)toVC;
@end

@interface CustomContainerTransitionVC : BaseUIViewController
@property (nonatomic, weak) id<ContainerViewControllerDelegate> containerViewControllerDelegate;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIViewController *selectedVC;
@property (nonatomic, assign) BOOL interactive;//是否交互

//恢复上一次状态
- (void)restoreSelectedIndex;
//交互动画使用;
- (void)graduallyChangeTabButtonAppearWith:(NSInteger)fromIndex toIndex:(NSInteger)toIndex percent:(CGFloat)percent;
@end
