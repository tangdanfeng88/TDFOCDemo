//
//  MyTool.h
//  FintechAdvisor
//
//  Created by 汤丹峰 on 2017/6/8.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

// deviceToken
#define device_Token @"device_Token"

@interface MyTool : NSObject
/**
 *  以后公用工具类里面添加的方法 尽量写个注释
 */

//plist存储操作
+ (void)removeValueforKey:(NSString *)str;
+ (void)writeValue:(id)value forKey:(NSString *)str;
+ (id)readValueForKey:(NSString *)str;

//判断nil处理
+ (NSString *)getStringFromObj:(id)obj;

//获取idfa
+ (NSString *)idfa;

//创建label
+ (UILabel *)setupLabelWithFrame:(CGRect)frame Title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment;

//计算string尺寸
+ (float)getWidthWithStr:(NSString *)str andFont:(UIFont *)font;
+ (CGSize)getSizeWithStr:(NSString *)str andFont:(UIFont *)font andMaxW:(CGFloat)maxW;


// 设置字体
// 平方 细体
+ (UIFont *)lightFontWithSize:(CGFloat)size;

// 平方 粗体
+ (UIFont *)mediumFontWithSize:(CGFloat)size;

// 平方 常规
+ (UIFont *)regularFontWithSize:(CGFloat)size;

//提示
+ (void)showToastWithStr:(NSString *)str;
@end
