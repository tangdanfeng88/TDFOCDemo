//
//  CoreTextImageData.h
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/13.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextImageData : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat position;
// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic, assign) CGRect imagePosition;
@end
