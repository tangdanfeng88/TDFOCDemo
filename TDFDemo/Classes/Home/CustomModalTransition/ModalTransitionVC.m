//
//  ModalTransitionVC.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/15.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "ModalTransitionVC.h"
#import "ModalPresentedVC.h"
#import "SDEModalTransitionDelegate.h"

@interface ModalTransitionVC ()
{
    SDEModalTransitionDelegate *modalDelegate;
}
@end

@implementation ModalTransitionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ModalTransition";
    self.view.backgroundColor = TDFRandomColor;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((mainWidth-100)*0.5, (mainHeight-100-64)*0.5, 100, 100)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"Present" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(presentBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)presentBtnClick
{
    ModalPresentedVC *vc = [[ModalPresentedVC alloc] init];
    
    //presenting present presented，必须给 presented 设置代理而不是 presenting。
    //必须在 present 出 presented 前给 presented 代理，不能再 presented 里面设置，不然时间点太晚。
    //PresentationStyle必须设置UIModalPresentationCustom模式才能定制modal转场动画
    //UIModalPresentationFullScreen模式也可以定制转场动画，但是存在问题(不支持UIPresentationController等)
    [vc setModalPresentationStyle:UIModalPresentationCustom];
    modalDelegate = [[SDEModalTransitionDelegate alloc] init];
    vc.transitioningDelegate = (id<UIViewControllerTransitioningDelegate>)modalDelegate;
    
    [self presentViewController:vc animated:YES completion:nil];
}
@end
