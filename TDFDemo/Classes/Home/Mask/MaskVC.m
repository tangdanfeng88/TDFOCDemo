//
//  MaskVC.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/9.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "MaskVC.h"

@interface MaskVC ()
{
    NSTimer *pTimer;
    CGFloat precent;
    UIView *bgView;
}
@end

@implementation MaskVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (pTimer) {
        [pTimer invalidate];
        pTimer = nil;
    }
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
    self.title = @"Mask属性";
    
    
    /**
     *  A.mask=B, B中非透明(内容或背景不透明)的位置A可以显示， B中透明的位置A不可显示(A此时跟透明效果一样，A下层的vie是可以照常显示的)
     */
    
    //渐变色进度条
    CAGradientLayer *pLayer = [[CAGradientLayer alloc] init];
    pLayer.frame = CGRectMake(50, 50, 200, 20);
    pLayer.colors = @[(id)[UIColorFromRGB(0xFF6347) CGColor],
                             (id)[UIColorFromRGB(0xFFEC8B) CGColor],
                             (id)[UIColorFromRGB(0xEEEE00) CGColor],
                             (id)[UIColorFromRGB(0x7FFF00) CGColor]];
    pLayer.locations = @[@0.3, @0.5, @0.7, @1];
    pLayer.startPoint = CGPointMake(0, 0);
    pLayer.endPoint = CGPointMake(1, 0);
    pLayer.cornerRadius = 10;
    pLayer.masksToBounds = YES;
    [self.view.layer addSublayer:pLayer];
    
    precent = 0.0;
    CAShapeLayer *pMaskLayer = [[CAShapeLayer alloc] init];
    pMaskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    pMaskLayer.frame = CGRectMake(0, 0, precent/200, 20);
    pLayer.mask = pMaskLayer;
    
    CAGradientLayer *bgLayer = [[CAGradientLayer alloc] init];
    bgLayer.frame = CGRectMake(50, 90, 200, 20);
    bgLayer.colors = @[(id)[UIColorFromRGB(0xFF6347) CGColor],
                      (id)[UIColorFromRGB(0xFFEC8B) CGColor],
                      (id)[UIColorFromRGB(0xEEEE00) CGColor],
                      (id)[UIColorFromRGB(0x7FFF00) CGColor]];
    bgLayer.locations = @[@0.3, @0.5, @0.7, @1];
    bgLayer.startPoint = CGPointMake(0, 0);
    bgLayer.endPoint = CGPointMake(1, 0);
    [self.view.layer addSublayer:bgLayer];
    
    UILabel *precentLb = [MyTool setupLabelWithFrame:CGRectMake(0, 0, 50, 20) Title:@"0%" font:MAIN_FONT14 textColor:FONT_THEME_COLOR textAlignment:NSTextAlignmentLeft];
    precentLb.backgroundColor = [UIColor clearColor];
    bgLayer.mask = precentLb.layer;
    
    pTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        precent++;
        pMaskLayer.frame = CGRectMake(0, 0, 200*precent/100, 20);
        precentLb.text = [NSString stringWithFormat:@"%.f%%", precent];
        CGFloat dw = [MyTool getWidthWithStr:precentLb.text andFont:MAIN_FONT14];
        CGFloat dx = (200-dw)*precent/100;
        precentLb.frame = CGRectMake(dx, 0, dw, 20);
        if (precent>=100) {
            precent = -1;
            if (timer) {
                [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
            }
        }
    }];
    [[NSRunLoop currentRunLoop] addTimer:pTimer forMode:NSRunLoopCommonModes];
    
    
    
    /**
     *  UIBezierPath 有个原生的方法- (void)appendPath:(UIBezierPath *)bezierPath，这个方法作用是俩个路径有叠加的部分则会镂空。
     *  这个方法实现原理应该是path的FillRule，默认是FillRuleEvenOdd(CALayer 有一个fillRule属性的规则就有kCAFillRuleEvenOdd)，而EvenOdd是一个奇偶规则，奇数则显示，偶数则不显示，叠加则是偶数故不显示。
     */
    
    //镂空效果
    UIButton *lkBtn = [[UIButton alloc] initWithFrame:CGRectMake((mainWidth-80)*0.5, 300, 80, 50)];
    [lkBtn setTitle:@"镂空" forState:UIControlStateNormal];
    lkBtn.backgroundColor = TDFRandomColor;
    [lkBtn setTitleColor:FONT_THEME_COLOR forState:UIControlStateNormal];
    lkBtn.titleLabel.font = MAIN_FONT14;
    [lkBtn addTarget:self action:@selector(lkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lkBtn];
}
- (void)lkBtnClick
{
    bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [bgView addGestureRecognizer:tap];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    bgView.frame = window.bounds;
    [window addSubview:bgView];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bgView.bounds];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(mainWidth*0.5, 200) radius:100 startAngle:0 endAngle:2*M_PI clockwise:NO];
    [path appendPath:path1];
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.backgroundColor = [UIColor whiteColor].CGColor;
    shapeLayer.path = path.CGPath;
    bgView.layer.mask = shapeLayer;
}
- (void)tapAction
{
    [bgView removeFromSuperview];
}
@end
