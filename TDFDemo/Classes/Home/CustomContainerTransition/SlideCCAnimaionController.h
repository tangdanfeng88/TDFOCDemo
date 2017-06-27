//
//  SlideCCAnimaionController.h
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/17.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, CCTabOperationDirection) {
    CC_left  = 0,
    CC_right = 1,
};
@interface SlideCCAnimaionController : NSObject
- (id)initWithDirection:(CCTabOperationDirection)direction;
@end
