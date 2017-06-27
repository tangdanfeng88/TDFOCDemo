//
//  SlideTabAnimationController.h
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/16.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TabOperationDirection) {
    left  = 0,
    right = 1,
};

@interface SlideTabAnimationController : NSObject
- (id)initWithDirection:(TabOperationDirection)direction;
@end
