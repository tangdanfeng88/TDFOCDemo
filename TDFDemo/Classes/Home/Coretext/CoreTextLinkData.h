//
//  CoreTextLinkData.h
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/13.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextLinkData : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSRange range;
@end
