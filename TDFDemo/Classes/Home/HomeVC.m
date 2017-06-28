//
//  HomeVC.m
//  FintechAdvisor
//
//  Created by 汤丹峰 on 2017/6/8.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()
{
    NSMutableArray *btnArr;
    NSArray *itemArr;
}
@end

@implementation HomeVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (int i=0; i<btnArr.count; i++) {
        UIButton *btn = btnArr[i];
        btn.backgroundColor = TDFRandomColor;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    btnArr = [NSMutableArray array];
    itemArr = @[@{@"title" : @"mask属性", @"action" : @"MaskVC"},
                @{@"title" : @"循环滚动", @"action" : @"InfiniteScrollVC"},
                @{@"title" : @"Coretext", @"action" : @"CoretextVC"},
                @{@"title" : @"TextKit", @"action" : @"TextKitVC"},
                @{@"title" : @"Nav\n转场动画", @"action" : @"NavTransitionVC"},
                @{@"title" : @"Modal\n转场动画", @"action" : @"ModalTransitionVC"},
                @{@"title" : @"Tab\n转场动画", @"action" : @"TabTransitionVC"},
                @{@"title" : @"自定制VC\n转场动画", @"action" : @"CustomContainerTransitionVC"},
                @{@"title" : @"collection\n线性布局", @"action" : @"ColLineLayoutVC"},
                @{@"title" : @"collection\n堆布局", @"action" : @"ColStackLayoutVC"},
                @{@"title" : @"collection\n圆周布局", @"action" : @"ColCircleLayoutVC"},
                @{@"title" : @"collection\n瀑布流布局", @"action" : @"ColWaterFlowLayoutVC"}];
    
    [self setupSubViews];
}
- (void)setupSubViews
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight-64-49)];
    [self.view addSubview:scrollView];
    
    CGFloat dw = (mainWidth-40)*0.333;
    CGFloat dh = 50;
    for (int i=0; i<itemArr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10+(i%3)*(dw+10), 10+(i/3)*(dh+10), dw, dh)];
        btn.backgroundColor = TDFRandomColor;
        btn.tag = i;
        btn.titleLabel.font = MAIN_FONT14;
        btn.titleLabel.numberOfLines = 0;
        [btn setTitle:itemArr[i][@"title"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        [btnArr addObject:btn];
    }
}

- (void)btnClick:(UIButton *)button
{
    NSString *vcName = itemArr[button.tag][@"action"];
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
