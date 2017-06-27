//
//  UIImage+Extension.m
//  TDFSideSlideDemo
//
//  Created by 汤丹峰 on 15/12/4.
//  Copyright © 2015年 tangdanfeng. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
+ (instancetype)imageWithColor:(UIColor *)color
{
    CGFloat imageW = 100;
    CGFloat imageH = 100;
    
    // 1.开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}
@end
