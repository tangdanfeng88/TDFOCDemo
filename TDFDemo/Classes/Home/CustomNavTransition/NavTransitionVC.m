//
//  NavTransitionVC.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/15.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "NavTransitionVC.h"
#import "NavPopVC.h"
#import "SDENavigationDelegate.h"

@interface NavTransitionVC ()
{
    SDENavigationDelegate *navDelegate;
}
@end

@implementation NavTransitionVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"NavTransition";
    self.view.backgroundColor = TDFRandomColor;
    
    navDelegate = [[SDENavigationDelegate alloc] init];
    
    //在这里设置delegate有风险，因为这时候控制器可能尚未进入 NavigationController 的控制器栈，self.navigationController返回的可能是 nil
    //self.navigationController.delegate = (id<UINavigationControllerDelegate>)navDelegate;
    
    //下面这种方式设置代理不成功。必须让当前控制器对navDelegate有个强引用。否则当前函数执行完。delegate引用的对象就销毁了。
    //self.navigationController.delegate = (id<UINavigationControllerDelegate>)[[SDENavigationDelegate alloc] init];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((mainWidth-100)*0.5, (mainHeight-100-64)*0.5, 100, 100)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"Push" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)pushBtnClick
{
    NavPopVC *vc = [[NavPopVC alloc] init];
    //在这里设置delegate，保证self.navigationController返回肯定不为nil
    self.navigationController.delegate = (id<UINavigationControllerDelegate>)navDelegate;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
