//
//  ModalPresentedVC.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/16.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "ModalPresentedVC.h"
#import "SDEModalTransitionDelegate.h"

@interface ModalPresentedVC ()
{
    UIButton *dismissBtn;
}
@end

@implementation ModalPresentedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ModalTransition";
    self.view.backgroundColor = TDFRandomColor;
    
    dismissBtn = [[UIButton alloc] init];
    [self.view addSubview:dismissBtn];
    dismissBtn.backgroundColor = [UIColor whiteColor];
    dismissBtn.layer.cornerRadius = 6;
    dismissBtn.layer.masksToBounds = YES;
    [dismissBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewDidAppear:(BOOL)animated
{
    dismissBtn.frame = CGRectMake((self.view.width-1)*0.5, (self.view.height-50)*0.5, 1, 50);
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        dismissBtn.frame = CGRectMake((self.view.width-150)*0.5, (self.view.height-50)*0.5, 150, 50);
        [dismissBtn setTitle:@"dismiss" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissBtnClick
{
    [UIView animateWithDuration:0.3 animations:^{
        dismissBtn.frame = CGRectMake((self.view.width-0)*0.5, (self.view.height-50)*0.5, 0, 50);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
@end
