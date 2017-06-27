//
//  BaseUINavigationController.m
//  FintechAdvisor
//
//  Created by 汤丹峰 on 2017/6/8.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "BaseUINavigationController.h"

@interface BaseUINavigationController ()

@end

@implementation BaseUINavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        //自动显示和隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"nav_back" highImage:@"nav_back_highlighted" target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:animated];
    viewController.navigationController.navigationBar.translucent = NO;
}
- (void)back
{
    [self popViewControllerAnimated:YES];
}
@end
