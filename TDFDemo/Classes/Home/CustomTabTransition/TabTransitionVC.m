//
//  TabTransitionVC.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/15.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "TabTransitionVC.h"
#import "TabTransWetVC.h"
#import "TabTransitionDisVC.h"
#import "TabTransitionMeVC.h"
#import "SDETabBarVCDelegate.h"

@interface TabTransitionVC ()
{
    SDETabBarVCDelegate *tabBarDelegate;
}
@end

@implementation TabTransitionVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    TabTransWetVC *message = [[TabTransWetVC alloc] init];
    [self addChildVc:message title:@"WeChat" image:@"tabtransition_mainframe" selectedImage:@"tabtransition_mainframeHL"];
    
    TabTransitionDisVC *discover = [[TabTransitionDisVC alloc] init];
    [self addChildVc:discover title:@"Discover" image:@"tabtransition_discover" selectedImage:@"tabtransition_discoverHL"];
    
    TabTransitionMeVC *profile = [[TabTransitionMeVC alloc] init];
    [self addChildVc:profile title:@"Me" image:@"tabtransition_me" selectedImage:@"tabtransition_meHL"];
    
    tabBarDelegate = [[SDETabBarVCDelegate alloc] init];
    self.delegate = (id<UITabBarControllerDelegate>)tabBarDelegate;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:panGesture];
}
/**
 *  在TabBarController里面，封装TabBarController的子控制器
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title;
    
    //设置子控制器图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x929292);
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = TDFColor(89, 218, 95);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    [self addChildViewController:childVc];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture
{
    //translationInView 手指在视图上移动的位置（x,y)，向下和向右为正，向上和向左为负
    CGFloat translationX = [panGesture translationInView:self.view].x;
    CGFloat translationAbs = translationX > 0 ? translationX : -translationX;
    CGFloat progress = translationAbs/self.view.width;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //更新交互状态
            tabBarDelegate.interactive = YES;
            
            //velocityInView 手指在视图上移动的速度（x,y）, 正负也是代表方向，值得一体的是在绝对值上|x| > |y| 水平移动， |y|>|x| 竖直移动
            CGFloat velocityX = [panGesture velocityInView:self.view].x;
            if (velocityX < 0) {
                if (self.selectedIndex < self.viewControllers.count - 1) {
                    self.selectedIndex += 1;
                }
            }
            else {
                if (self.selectedIndex > 0) {
                    self.selectedIndex -= 1;
                }
            }
            break;
        case UIGestureRecognizerStateChanged:
            [tabBarDelegate.interactionCotroller updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            /*这里有个小问题，转场结束或是取消时有很大几率出现动画不正常的问题。在8.1以上版本的模拟器中都有发现，7.x 由于缺乏条件尚未测试，
             但在我的 iOS 9.2 的真机设备上没有发现，而且似乎只在 UITabBarController 的交互转场中发现了这个问题。在 NavigationController 暂且没发现这个问题，
             Modal 转场尚未测试，因为我在 Demo 里没给它添加交互控制功能。

             解决手段是修改交互控制器的 completionSpeed 为1以下的数值，这个属性用来控制动画速度，我猜测是内部实现在边界判断上有问题。
             这里其修改为0.99，既解决了 Bug 同时尽可能贴近原来的动画设定。
             */
            if (progress > 0.3) {
                [tabBarDelegate.interactionCotroller setCompletionSpeed:0.99];
                [tabBarDelegate.interactionCotroller finishInteractiveTransition];
            } else {
                //转场取消后，UITabBarController 自动恢复了 selectedIndex 的值，不需要我们手动恢复。
                [tabBarDelegate.interactionCotroller setCompletionSpeed:0.99];
                 [tabBarDelegate.interactionCotroller cancelInteractiveTransition];
            }
            
            //无论转场的结果如何，恢复为非交互状态
            tabBarDelegate.interactive = false;
            break;
        default:
            //无论转场的结果如何，恢复为非交互状态
            tabBarDelegate.interactive = false;
            break;
    }
}

@end
