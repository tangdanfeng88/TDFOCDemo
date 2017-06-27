//
//  NavPopVC.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/15.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "NavPopVC.h"
#import "SDENavigationDelegate.h"

@interface NavPopVC ()
{
    SDENavigationDelegate *navigationDelegate;
}
@end

@implementation NavPopVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"NavPop";
    self.view.backgroundColor = TDFRandomColor;
    
    //自定制UINavigationController的转场动画之后，push出的UIViewController Y坐标零点在状态栏下面而不是在navigationbar下面。
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((mainWidth-100)*0.5, (mainHeight-100-64)*0.5+64, 100, 100)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"Pop me" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] init];
    edgePanGesture.edges = UIRectEdgeLeft;
    [edgePanGesture addTarget:self action:@selector(edgePanGestureAction:)];
    [self.view addGestureRecognizer:edgePanGesture];
}
- (void)popBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)edgePanGestureAction:(UIScreenEdgePanGestureRecognizer *)gesture
{
    CGFloat translationX = [gesture translationInView:self.view].x;
    DLog(@"translationX---  %f", translationX);
    CGFloat translationBase = self.view.width;
    CGFloat translationAbs = translationX > 0 ? translationX : -translationX;
    CGFloat precent = translationAbs > translationBase ? 1.0 : translationAbs / translationBase;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            //转场开始前获取代理，一旦转场开始，VC 将脱离控制器栈，此后 self.navigationController 返回的是 nil
            navigationDelegate = (SDENavigationDelegate *)self.navigationController.delegate;
            //更新交互状态
            navigationDelegate.interactive = YES;
            //交互控制器没有 start 之类的方法，当下面这行代码执行后，转场开始
            //如果转场代理提供了交互控制器，它将从这时候开始接管转场过程
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:
            [navigationDelegate.interactionCotroller updateInteractiveTransition:precent];
            break;
        case UIGestureRecognizerStateEnded:
            if (precent > 0.5) {
                [navigationDelegate.interactionCotroller finishInteractiveTransition];
            } else {
                [navigationDelegate.interactionCotroller cancelInteractiveTransition];
            }
            //无论转场的结果如何，恢复为非交互状态
            navigationDelegate.interactive = false;
            break;
            
        default:
            //无论转场的结果如何，恢复为非交互状态
            navigationDelegate.interactive = false;
            break;
    }
}

@end
