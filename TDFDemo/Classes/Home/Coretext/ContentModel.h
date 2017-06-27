//
//  ContentModel.h
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/12.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *content;//文本
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *img;//图片
@property (nonatomic, copy) NSString *url;//链接
@end
