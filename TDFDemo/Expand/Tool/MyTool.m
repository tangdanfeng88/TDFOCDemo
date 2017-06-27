//
//  MyTool.m
//  FintechAdvisor
//
//  Created by 汤丹峰 on 2017/6/8.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "MyTool.h"
#import <AdSupport/AdSupport.h>
#import "AppDelegate.h"

@implementation MyTool
+ (void)removeValueforKey:(NSString *)str{
    if ([MyTool readValueForKey:str]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:str];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)writeValue:(id)value forKey:(NSString *)str{
    [[NSUserDefaults standardUserDefaults]  setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:str];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)readValueForKey:(NSString *)str{
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:str];
    if (!obj) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:obj];
}

+ (NSString *)getStringFromObj:(id)obj{
    return obj?[NSString stringWithFormat:@"%@",obj]:@"";
}

+ (NSString *)idfa{
    NSString *idfaStr;
    Class theClass=NSClassFromString(@"ASIdentifierManager");
    if (theClass)
    {
        idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }else{
        idfaStr = @"";
    }
    return idfaStr;
}

+ (UILabel *)setupLabelWithFrame:(CGRect)frame Title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = color;
    label.textAlignment = textAlignment;
    label.font = font;
    return label;
}

+ (float)getWidthWithStr:(NSString *)str andFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 9999, font.lineHeight)];
    label.text = str;
    label.font = font;
    [label sizeToFit];
    return label.size.width;
}
+ (CGSize)getSizeWithStr:(NSString *)str andFont:(UIFont *)font andMaxW:(CGFloat)maxW
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, maxW, font.lineHeight)];
    label.text = str;
    label.numberOfLines = 0;
    label.font = font;
    [label sizeToFit];
    return label.size;
}
+ (UIFont *)lightFontWithSize:(CGFloat)size{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Light" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

+ (UIFont *)regularFontWithSize:(CGFloat)size{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

+ (UIFont *)mediumFontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    if (!font) {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

+ (void)showToastWithStr:(NSString *)str{
    if (!str||[str isEqualToString:@""]||[str isEqualToString:@"网络异常"]) {
        return;
    }
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize strSize = [MyTool getSizeWithStr:str andFont:font andMaxW:mainWidth-40];
    
    UILabel *toastVeiw = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, strSize.width+20, strSize.height+20)];
    toastVeiw.textAlignment = NSTextAlignmentCenter;
    toastVeiw.clipsToBounds = YES;
    toastVeiw.numberOfLines = 0;
    toastVeiw.text = str;
    toastVeiw.font = font;
    toastVeiw.textColor = [UIColor whiteColor];
    toastVeiw.center = CGPointMake(mainWidth*0.5, mainHeight*0.5);
    toastVeiw.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    toastVeiw.layer.cornerRadius = 5;
    [[AppDelegate sharedAppDelegate].window addSubview:toastVeiw];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toastVeiw removeFromSuperview];
    });
}

@end
