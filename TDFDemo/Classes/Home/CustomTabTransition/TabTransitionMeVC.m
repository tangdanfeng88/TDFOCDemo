//
//  TabTransitionMe.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/16.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "TabTransitionMeVC.h"

@interface TabTransitionMeVC ()

@end

@implementation TabTransitionMeVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= TDFRandomColor;
    // Do any additional setup after loading the view.
}

@end
