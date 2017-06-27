//
//  BaseUIViewController.m
//  FintechAdvisor
//
//  Created by 汤丹峰 on 2017/6/8.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "BaseUIViewController.h"
#import <objc/runtime.h>
static char *btnClickAction;

@interface BaseUIViewController ()

@end

@implementation BaseUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
    // Do any additional setup after loading the view.
}

#pragma mark --- navAction
- (void)actionCustomLeftBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                  title:(NSString *)title
                                 action:(void(^)())btnClickBlock {
    self.navLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navLeftBtn setBackgroundColor:[UIColor clearColor]];
    objc_setAssociatedObject(self.navLeftBtn, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    [self actionCustomNavBtn:self.navLeftBtn nrlImage:nrlImage htlImage:hltImage title:title];
    [self.navLeftBtn setTitleColor:FONT_THEME_COLOR forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navLeftBtn];
}
- (void)actionCustomRightBtnWithNrlImage:(NSString *)nrlImage htlImage:(NSString *)hltImage
                                   title:(NSString *)title
                                  action:(void(^)())btnClickBlock {
    self.navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    objc_setAssociatedObject(self.navRightBtn, &btnClickAction, btnClickBlock, OBJC_ASSOCIATION_COPY);
    [self actionCustomNavBtn:self.navRightBtn nrlImage:nrlImage htlImage:hltImage title:title];
    [self.navRightBtn setTitleColor:FONT_THEME_COLOR forState:UIControlStateNormal];
    self.navRightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightBtn];
}
- (void)actionCustomNavBtn:(UIButton *)btn nrlImage:(NSString *)nrlImage
                  htlImage:(NSString *)hltImage
                     title:(NSString *)title {
    
    [btn setImage:[[UIImage imageNamed:nrlImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    if (hltImage) {
        [btn setImage:[[UIImage imageNamed:hltImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    } else {
        [btn setImage:[[UIImage imageNamed:nrlImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    if (title) {
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
    [btn sizeToFit];
    [btn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)actionBtnClick:(UIButton *)btn {
    void (^btnClickBlock) (void) = objc_getAssociatedObject(btn, &btnClickAction);
    btnClickBlock();
}


-(void)showLoad
{
    
}

-(void)cancelLoad
{
    
}
@end
