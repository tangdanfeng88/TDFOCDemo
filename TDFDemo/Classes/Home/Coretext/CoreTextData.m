//
//  CoreTextData.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/12.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "CoreTextData.h"
#import "ContentModel.h"

@implementation CoreTextData
- (void)setCtFrame:(CTFrameRef)ctFrame
{
    if (_ctFrame != ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

-(void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    [self fillImagePosition];
}
//找到每张图片在绘制的位置
- (void)fillImagePosition
{
    if (self.imageArray.count == 0) {
        return;
    }
    
    //在CTFrame内部，是由多个CTLine来组成的，每个CTLine代表一行，每个CTLine又是由多个CTRun来组成，每个CTRun代表一组显示风格一致的文本
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    int lineCount = (int)[lines count];
    CGPoint lineOrigins[lineCount];
    //获取每个CTLine的CGPoint值
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int imgIndex = 0;
    CoreTextImageData *imageData = self.imageArray[0];
    
    for (int i=0; i<lineCount; i++) {
        if (imageData == nil) {
            return;
        }
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray *runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            
            NSDictionary *metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[ContentModel class]]) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            //获取每个CTRun的bounds信息，传 CFRangeMake(0, 0) 算整个CTRun的bounds
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            //可以根据ascent descent的值控制图片和文本上对齐 中间对齐 下对齐
            runBounds.size.height = ascent + descent;
            
            //获取CTRun在CTLine上的偏移
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            imageData.imagePosition = delegateBounds;
            imgIndex++;
            if (imgIndex == self.imageArray.count) {
                imageData = nil;
                break;
            } else {
                imageData = self.imageArray[imgIndex];
            }
        }
    }
}

- (void)dealloc
{
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}
@end
