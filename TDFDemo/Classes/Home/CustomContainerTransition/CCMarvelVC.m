//
//  CCMarvelVC.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/17.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "CCMarvelVC.h"

@interface CCMarvelVC ()

@end

@implementation CCMarvelVC

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
    // Do any additional setup after loading the view.
    self.title = @"Marvel";
    self.view.backgroundColor = TDFRandomColor;
    
    UILabel *label = [MyTool setupLabelWithFrame:CGRectMake((mainWidth-100)*0.5, (mainHeight-64-50)*0.5, 100, 50) Title:@"Marvel" font:MAIN_FONT14 textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
}


@end
