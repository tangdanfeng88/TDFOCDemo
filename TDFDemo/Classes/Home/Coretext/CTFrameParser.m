//
//  CTFrameParser.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/12.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "CTFrameParser.h"
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"
#import "ContentModel.h"
#import "CoreTextImageData.h"
#import "CoreTextLinkData.h"

@implementation CTFrameParser
+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config
{
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];
    NSAttributedString *content = [self loadTemplateFile:path config:config imageArray:imageArray linkArray:linkArray];
    CoreTextData *data = [self parseAttributedContent:content config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    return data;
}
+ (NSAttributedString *)loadTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config imageArray:(NSMutableArray *)imageArray linkArray:(NSMutableArray *)linkArray
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    NSArray *models = [ContentModel mj_objectArrayWithFilename:@"coretext.plist"];
    for (ContentModel *model in models) {
        if ([model.type isEqualToString:@"txt"]) {//处理文本
            NSAttributedString *as = [self parseAttributedContentFromModel:model config:config];
            [result appendAttributedString:as];
        } else if ([model.type isEqualToString:@"img"]) {//处理图片
            CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
            imageData.name = model.img;
            imageData.position = [result length];
            [imageArray addObject:imageData];
            
            // 创建空白占位符，并且设置它的 CTRunDelegate 信息
            NSAttributedString *as = [self parseImageDataFromModel:model config:config];
            [result appendAttributedString:as];
        } else if([model.type isEqualToString:@"link"]) {//链接
            NSUInteger startPos = result.length;
            NSAttributedString *as = [self parseAttributedContentFromModel:model config:config];
            [result appendAttributedString:as];
            
            // 创建 CoreTextLinkData
            NSUInteger length = result.length - startPos;
            NSRange linkRange = NSMakeRange(startPos, length);
            CoreTextLinkData *linkData = [[CoreTextLinkData alloc] init];
            linkData.title = model.content;
            linkData.url = model.url;
            linkData.range = linkRange;
            [linkArray addObject:linkData];
        }
    }
    return result;
}
//处理文本
+ (NSAttributedString *)parseAttributedContentFromModel:(ContentModel *)model config:(CTFrameParserConfig *)config
{
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    
    UIColor *color = [self colorFromTemplate:model.color];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    CGFloat fontSize = model.size.floatValue;
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    
    return [[NSAttributedString alloc] initWithString:model.content attributes:attributes];
}
//处理图片
+ (NSAttributedString *)parseImageDataFromModel:(ContentModel *)model config:(CTFrameParserConfig *)config
{
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(model));
    
    // 使用 0xFFFC 作为空白的占位符
    unichar objectReplacementChar = 0xfffc;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    
    CFRelease(delegate);
    return space;
}

static CGFloat ascentCallback(void *ref)
{
    return [[(__bridge ContentModel *)ref height] floatValue];
}
static CGFloat descentCallback(void *ref)
{
    return 0;
}
static CGFloat widthCallback(void *ref)
{
    return [[(__bridge ContentModel *)ref width] floatValue];
}

+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParserConfig *)config
{
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor *textColor = config.textColor;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)(fontRef);
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    
    return dict;
}
+ (UIColor *)colorFromTemplate:(NSString *)name
{
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([name isEqualToString:@"black"]) {
        return [UIColor blackColor];
    } else {
        return nil;
    }
}
+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config
{
    //创建 CTFramesetterRef
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    //获得要缓制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    //生成 CTFrameRef
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    //将生成好的 CTFrameRef 实例和计算好的缓制高度保存到 CoreTextData 实例中，最后返回 CoreTextData 实例
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    // 释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}
+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter config:(CTFrameParserConfig *)config height:(CGFloat)height
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}
@end
