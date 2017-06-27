//
//  TextKitVC.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/14.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "TextKitVC.h"
#import "AnimationLabel.h"

@interface TextKitVC ()
{
    NSTimer *timer;
    NSArray *titles;
}
@end

@implementation TextKitVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"TextKit";
    
    titles = @[@"Steve jobs", @"I want to learn swift", @"hello world"];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 200)];
    bgView.image = [UIImage imageNamed:@"textKit_01"];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgView];
    
    AnimationLabel *animationLb = [[AnimationLabel alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 200)];
    animationLb.textAlignment = NSTextAlignmentCenter;
    animationLb.textColor = TDFRandomColor;
    animationLb.font = [UIFont boldSystemFontOfSize:35];
    animationLb.text = @"Steve jobs";
    [self.view addSubview:animationLb];
    
    __block NSInteger index = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        index++;
        if (index >= titles.count) {
            index = 0;
        }
        animationLb.text = titles[index];
    }];
}

@end
