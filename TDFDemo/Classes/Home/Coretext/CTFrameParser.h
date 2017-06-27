//
//  CTFrameParser.h
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/12.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"

@interface CTFrameParser : NSObject
+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config;
@end
