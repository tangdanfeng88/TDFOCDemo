//
//  CoreTextData.h
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/12.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextImageData.h"

@interface CoreTextData : NSObject
@property (nonatomic, assign)CTFrameRef ctFrame;
@property (nonatomic, assign) CGFloat height;
//图片信息
@property (nonatomic, strong) NSArray *imageArray;
//链接数据
@property (nonatomic, strong) NSArray *linkArray;
@end
