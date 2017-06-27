//
//  SDEPercentDrivenInteractiveTransition.h
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/17.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDEPercentDrivenInteractiveTransition : NSObject
- (void)updateInteractiveTransition:(CGFloat)percentComplete;
- (void)cancelInteractiveTransition;
- (void)finishInteractiveTransition;
@end
