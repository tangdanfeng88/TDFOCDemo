//
//  UIBarButtonItem+Extension.h
//  FintechAdvisor
//
//  Created by 汤丹峰 on 2017/6/8.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
/**
 *  通过button创建一个UIBarButtonItem，有 普通状态 和 高亮状态 两张背景图片
 */
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
