//
//  SDENavigationDelegate.h
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/15.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDENavigationDelegate : NSObject
@property (nonatomic, assign) BOOL interactive;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionCotroller;
@end
