//
//  MyUITabBarController.m
//  FintechAdvisor
//
//  Created by 汤丹峰 on 2017/6/8.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "MyUITabBarController.h"
#import "HomeVC.h"
#import "MeVC.h"

@interface MyUITabBarController ()

@end

@implementation MyUITabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeVC *home = [[HomeVC alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_sel"];
    
    MeVC *profile = [[MeVC alloc] init];
    [self addChildVc:profile title:@"我的" image:@"tabbar_me" selectedImage:@"tabbar_me_sel"];
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
    selectedTextAttrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x4c90f2);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    BaseUINavigationController *tnc = [[BaseUINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:tnc];
}
@end
