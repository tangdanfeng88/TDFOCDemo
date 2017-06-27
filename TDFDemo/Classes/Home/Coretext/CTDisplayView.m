//
//  CTDisplayView.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/12.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "CTDisplayView.h"
#import "CoreTextLinkData.h"

@implementation CTDisplayView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupEvents];
    }
    return self;
}
- (void)setupEvents
{
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapGestureDetected:)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
}
//displayView点击事件
- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    
    //处理图片点击
    for (CoreTextImageData *imageData in self.data.imageArray) {
        // 翻转坐标系，因为 imageData 中的坐标是 CoreText 的坐标系
        CGRect imageRect = imageData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        if (CGRectContainsPoint(rect, point)) {
            //点击图片处理
            [MyTool showToastWithStr:@"图片点击了..."];
        }
    }
    
    //处理链接点击
    CoreTextLinkData *linkData = [self touchLinkInView:self atPoint:point data:self.data];
    if (linkData) {
        //点击链接处理
        [MyTool showToastWithStr:@"链接点击了..."];
    }
}
//处理链接点击
- (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data
{
    CTFrameRef textFrame = data.ctFrame;
    CFArrayRef links = CTFrameGetLines(textFrame);
    if (!links) {
        return nil;
    }
    CFIndex count = CFArrayGetCount(links);
    CoreTextLinkData *foundLink = nil;
    
    //获得每一行的 origin 坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    
    //翻转坐标系
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    for (int i=0; i<count; i++) {
        CGPoint linkPoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(links, i);
        //获得每一行的 CGRect 值
        CGRect flippedRect = [self getLineBounds:line point:linkPoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        if (CGRectContainsPoint(rect, point)) {
            //将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect), point.y-CGRectGetMinY(rect));
            //获得当前点击坐标对应的字符串偏移
            CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);
            //判断这个偏移是否在我们的链接列表中
            foundLink = [self linkAtIndex:idx linkArray:data.linkArray];
            return foundLink;
        }
    }
    return nil;
}
//获得每一行的 CGRect 值
- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point
{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y, width, height);
}
//判断这个偏移是否在我们的链接列表中
- (CoreTextLinkData *)linkAtIndex:(CFIndex)i linkArray:(NSArray *)linkArray
{
    CoreTextLinkData *link = nil;
    for (CoreTextLinkData *data in linkArray) {
        if (NSLocationInRange(i, data.range)) {
            link = data;
            break;
        }
    }
    return link;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.data == nil) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //对于底层的绘制引擎来说，屏幕的左下角是（0, 0）坐标。而对于上层的 UIKit 来说，左上角是 (0, 0) 坐标。所以我们为了之后的坐标系描述按 UIKit 来做，所以先在这里做一个坐标系的上下翻转操作。翻转之后，底层和上层的 (0, 0) 坐标就是重合的了
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CTFrameDraw(self.data.ctFrame, context);
    
    for (CoreTextImageData *imageData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
    }
}
@end
