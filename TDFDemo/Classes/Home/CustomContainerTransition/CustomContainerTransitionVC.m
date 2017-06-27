//
//  CustomContainerTransitionVC.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/15.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "CustomContainerTransitionVC.h"
#import "SDEContainerTransitionDelegate.h"
#import "ContainerTransitionContext.h"
#import "CCDcVC.h"
#import "CCMarvelVC.h"
#import "CCDhcVC.h"
#import "CCImageVC.h"

@interface CustomContainerTransitionVC ()
{
    SDEContainerTransitionDelegate *ctDelegate;
    ContainerTransitionContext *context;
    NSMutableArray *topBtnsArr;
    NSInteger priorSelectedIndex;
    UIView *containerView;
    UIView *buttonTabBar;
}
@end

@implementation CustomContainerTransitionVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        ctDelegate = [[SDEContainerTransitionDelegate alloc] init];
        self.containerViewControllerDelegate = (id<ContainerViewControllerDelegate>)ctDelegate;
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(containerTransitionEndNotificationAction) name:SDEContainerTransitionEndNotification object:nil];
}
- (void)containerTransitionEndNotificationAction
{
    context = nil;
    buttonTabBar.userInteractionEnabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //顶部button
    [self setupTopButtons];
    //子Controllers
    [self setupSubControllers];

    priorSelectedIndex = 0;
    _selectedIndex = 0;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:panGesture];
}
- (void)setupTopButtons
{
    topBtnsArr = [NSMutableArray array];
    NSArray *titles = @[@"DC", @"Marvel", @"DHC", @"Image"];
    buttonTabBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 49)];
    buttonTabBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:buttonTabBar];
    
    CGFloat btnW = mainWidth/titles.count;
    for (int i=0; i<titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW*i, 0, btnW, 49)];
        [buttonTabBar addSubview:btn];
        [topBtnsArr addObject:btn];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        if (i==0) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [btn setExclusiveTouch:YES];
        
        btn.titleLabel.font = MAIN_FONT14;
        btn.tag = i;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)topBtnClick:(UIButton *)button
{
    if (button.tag != self.selectedIndex) {
        self.selectedIndex = button.tag;
    }
}
- (void)setupSubControllers
{
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.view.width, self.view.height-49)];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    
    CCDcVC *dc = [[CCDcVC alloc] init];
    dc.view.frame = CGRectMake(0, 0, mainWidth, containerView.height);
    dc.view.backgroundColor = TDFRandomColor;
    [self addChildViewController:dc];
    [containerView addSubview:dc.view];
    
    CCMarvelVC *marvel = [[CCMarvelVC alloc] init];
    CCDhcVC *dhc = [[CCDhcVC alloc] init];
    CCImageVC *image = [[CCImageVC alloc] init];
    
    self.viewControllers = @[dc, marvel, dhc, image];
    
    //适应屏幕旋转的最简单的办法，在转场开始前设置子 view 的尺寸为容器视图的尺寸。
//    for (UIViewController *childVC in self.viewControllers) {
//        childVC.view.translatesAutoresizingMaskIntoConstraints = YES;
//        childVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    }
}

//恢复上一次状态
- (void)restoreSelectedIndex
{
    _selectedIndex = priorSelectedIndex;
}
- (void)setSelectedVC:(UIViewController *)selectedVC
{
    if (selectedVC) {
        NSInteger index = [self.viewControllers indexOfObject:selectedVC];
        self.selectedIndex = index;
    }
}
- (UIViewController *)selectedVC
{
    if (!self.viewControllers || self.selectedIndex<0 || self.selectedIndex >= self.viewControllers.count) {
        nil;
    }
    return self.viewControllers[self.selectedIndex];
}
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    priorSelectedIndex = self.selectedIndex;
    _selectedIndex = selectedIndex;
    [self transitionVCFromIndex:priorSelectedIndex toIndex:selectedIndex];
}

- (void)transitionVCFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (!self.viewControllers || fromIndex==toIndex
        || fromIndex<0 || toIndex<0
        || fromIndex>=self.viewControllers.count
        || toIndex>=self.viewControllers.count) {
        return;
    }
    
    UIViewController *oldVC = self.viewControllers[fromIndex];
    UIViewController *newVC = self.viewControllers[toIndex];
    if (_containerViewControllerDelegate != nil) {
        buttonTabBar.userInteractionEnabled = NO;
        
        context = [[ContainerTransitionContext alloc] initWithContainerViewController:self containerView:containerView fromViewController:oldVC toViewController:newVC];
        if (self.interactive) {
            [context startInteractiveTransitionWith:self.containerViewControllerDelegate];
        } else {
            [context startNonInteractiveTransitionWith:self.containerViewControllerDelegate];
            [self changeTabButtonAppearAtIndex:toIndex];
        }
    } else {
        newVC.view.frame = CGRectMake(0, 0, mainWidth, containerView.height);
        
        [self addChildViewController:newVC];
        [self transitionFromViewController:oldVC toViewController:newVC duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            if (finished) {
                [newVC didMoveToParentViewController:self];
                [oldVC willMoveToParentViewController:nil];
                [oldVC removeFromParentViewController];
                self.selectedVC = newVC;
            } else {
                self.selectedVC = oldVC;
            }
        }];
        [self changeTabButtonAppearAtIndex:toIndex];
    }
}
- (void)changeTabButtonAppearAtIndex:(NSInteger)selectedIndex
{
    [topBtnsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        if (idx == selectedIndex) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }];
}

//交互动画使用
- (void)graduallyChangeTabButtonAppearWith:(NSInteger)fromIndex toIndex:(NSInteger)toIndex percent:(CGFloat)percent
{
    UIButton *fromButton = topBtnsArr[fromIndex];
    UIButton *toButton = topBtnsArr[toIndex];
    
    [fromButton setTitleColor:[UIColor colorWithRed:1 green:percent blue:percent alpha:1] forState:UIControlStateNormal];
    [toButton setTitleColor:[UIColor colorWithRed:1 green:1-percent blue:1-percent alpha:1] forState:UIControlStateNormal];
}
//手势
- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture
{
    if (!self.viewControllers
        || self.viewControllers.count<2
        || !self.containerViewControllerDelegate
        || ![self.containerViewControllerDelegate isKindOfClass:[SDEContainerTransitionDelegate class]]) {
        return;
    }
    
    //translationInView 手指在视图上移动的位置（x,y)，向下和向右为正，向上和向左为负
    CGFloat translationX = [panGesture translationInView:self.view].x;
    CGFloat translationAbs = translationX > 0 ? translationX : -translationX;
    CGFloat progress = translationAbs/self.view.width;
    
    SDEContainerTransitionDelegate *delegate = (SDEContainerTransitionDelegate *)self.containerViewControllerDelegate;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //更新交互状态
            self.interactive = YES;
            
            //velocityInView 手指在视图上移动的速度（x,y）, 正负也是代表方向，值得一体的是在绝对值上|x| > |y| 水平移动， |y|>|x| 竖直移动
            CGFloat velocityX = [panGesture velocityInView:self.view].x;
            if (velocityX < 0) {
                if (self.selectedIndex < self.viewControllers.count - 1) {
                    self.selectedIndex += 1;
                }
            }
            else {
                if (self.selectedIndex > 0) {
                    self.selectedIndex -= 1;
                }
            }
            break;
        case UIGestureRecognizerStateChanged:
            [delegate.interactionCotroller updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:

            if (progress > 0.5) {
                [delegate.interactionCotroller finishInteractiveTransition];
            } else {
                [delegate.interactionCotroller cancelInteractiveTransition];
            }
            
            //无论转场的结果如何，恢复为非交互状态
            self.interactive = false;
            break;
        default:
            //无论转场的结果如何，恢复为非交互状态
            self.interactive = false;
            break;
    }
}
@end
