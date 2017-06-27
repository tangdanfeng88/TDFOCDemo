//
//  AnimationLabel.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/14.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "AnimationLabel.h"

@interface AnimationLabel ()<NSLayoutManagerDelegate, CAAnimationDelegate>
{
    NSTextStorage *textStorage;
    NSLayoutManager *textLayoutManager;
    NSTextContainer *textContainer;
    NSMutableArray *oldTextLayers;
    NSMutableArray *newTextLayers;
    
    CALayer *disappearLayer;
}
@end

@implementation AnimationLabel
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        oldTextLayers = [NSMutableArray array];
        newTextLayers = [NSMutableArray array];
        
        textStorage = [[NSTextStorage alloc] initWithString:@""];
        textLayoutManager = [[NSLayoutManager alloc] init];
        textContainer = [[NSTextContainer alloc] init];
        
        [textStorage addLayoutManager:textLayoutManager];
        [textLayoutManager addTextContainer:textContainer];
        textLayoutManager.delegate = self;
        textContainer.size = self.bounds.size;
    }
    return self;
}
#pragma mark --- set方法
- (void)setText:(NSString *)text
{
    if (text && [text isKindOfClass:[NSString class]]) {
        self.attributedText = [self internalAttributedText:text];
    }
}
- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [self cleanOutOldTextLayers];
    oldTextLayers = [NSMutableArray arrayWithArray:newTextLayers];
    
    [textStorage setAttributedString:attributedText];
    
    [self disappearAnimation];
    [self appearAnimation];
}
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    textContainer.lineBreakMode = lineBreakMode;
    [super setLineBreakMode:lineBreakMode];
}
- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    textContainer.maximumNumberOfLines = numberOfLines;
    [super setNumberOfLines:numberOfLines];
}
#pragma mark --- 动画相关
- (void)disappearAnimation
{
    for (CATextLayer *textLayer in oldTextLayers) {
        CGFloat duration = (arc4random()%100)/125.0+0.5;
        CGFloat distance = arc4random()%80;
        CGFloat angle = arc4random()/M_PI_2 - M_PI_4;
        
        CATransform3D transform = CATransform3DMakeTranslation(0, distance, 0);
        transform = CATransform3DRotate(transform, angle, 0, 0, 1);
        
        CALayer *layer1 = [self animatableLayerCopy:textLayer];
        CALayer *layer2 = textLayer;
        disappearLayer = textLayer;
        
        //改变Layer的properties，同时关闭implicit animation
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        layer2.transform = transform;
        layer2.opacity = 0;
        [CATransaction commit];
        
        CAAnimationGroup *animationGroup = [self groupAnimationWithLayerChanges:layer1 newLayer:layer2];
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animationGroup.beginTime = CACurrentMediaTime();
        animationGroup.duration = duration;
        animationGroup.delegate = self;
        [textLayer addAnimation:animationGroup forKey:@"disappearAniamtionGroupKey"];
    }
}
- (void)appearAnimation
{
    for (CATextLayer *textLayer in newTextLayers) {
        CGFloat duration = (arc4random()%100)/125.0+0.5;
        
        CALayer *layer1 = [self animatableLayerCopy:textLayer];
        CALayer *layer2 = textLayer;
        
        //改变Layer的properties，同时关闭implicit animation
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        layer2.opacity = 1;
        [CATransaction commit];
        
        CAAnimationGroup *animationGroup = [self groupAnimationWithLayerChanges:layer1 newLayer:layer2];
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animationGroup.beginTime = CACurrentMediaTime();
        animationGroup.duration = duration;
        animationGroup.delegate = self;
        [textLayer addAnimation:animationGroup forKey:@"appearAniamtionGroupKey"];
    }
}
- (CAAnimationGroup *)groupAnimationWithLayerChanges:(CALayer *)oldLayer newLayer:(CALayer *)newLayer
{
    CAAnimationGroup *animationGroup;
    NSMutableArray *animations = [NSMutableArray array];
    
    if (!CGPointEqualToPoint(oldLayer.position, newLayer.position)) {
        CABasicAnimation *basic = [[CABasicAnimation alloc] init];
        basic.fromValue = [NSValue valueWithCGPoint:oldLayer.position];
        basic.toValue = [NSValue valueWithCGPoint:newLayer.position];
        basic.keyPath = @"position";
        [animations addObject:basic];
    }
    if (!CATransform3DEqualToTransform(oldLayer.transform, newLayer.transform)) {
        CABasicAnimation *basic = [[CABasicAnimation alloc] init];
        basic.fromValue = [NSValue valueWithCATransform3D:oldLayer.transform];
        basic.toValue = [NSValue valueWithCATransform3D:newLayer.transform];
        basic.keyPath = @"transform";
        [animations addObject:basic];
    }
    if (!CGRectEqualToRect(oldLayer.frame, newLayer.frame)) {
        CABasicAnimation *basic = [[CABasicAnimation alloc] init];
        basic.fromValue = [NSValue valueWithCGRect:oldLayer.frame];
        basic.toValue = [NSValue valueWithCGRect:newLayer.frame];
        basic.keyPath = @"frame";
        [animations addObject:basic];
    }
    if (!CGRectEqualToRect(oldLayer.frame, newLayer.frame)) {
        CABasicAnimation *basic = [[CABasicAnimation alloc] init];
        basic.fromValue = [NSValue valueWithCGRect:oldLayer.frame];
        basic.toValue = [NSValue valueWithCGRect:newLayer.frame];
        basic.keyPath = @"bounds";
        [animations addObject:basic];
    }
    if (oldLayer.opacity != newLayer.opacity) {
        CABasicAnimation *basic = [[CABasicAnimation alloc] init];
        basic.fromValue = @(oldLayer.opacity);
        basic.toValue = @(newLayer.opacity);
        basic.keyPath = @"opacity";
        [animations addObject:basic];
    }
    
    if (animations.count > 0) {
        animationGroup = [[CAAnimationGroup alloc] init];
        animationGroup.animations = animations;
    }
    return animationGroup;
}
- (CALayer *)animatableLayerCopy:(CALayer *)layer
{
    CALayer *layerCopy = [[CALayer alloc] init];
    layerCopy.opacity = layer.opacity;
    layerCopy.bounds = layer.bounds;
    layerCopy.transform = layer.transform;
    layerCopy.position = layer.position;
    return layerCopy;
}
#pragma mark --- 工具方法
- (void)cleanOutOldTextLayers
{
    for (CATextLayer *textLayer in oldTextLayers) {
        [textLayer removeFromSuperlayer];
    }
    [oldTextLayers removeAllObjects];
}
- (NSMutableAttributedString *)internalAttributedText:(NSString *)string
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, string.length);
    [attributedText addAttribute:NSForegroundColorAttributeName value:self.textColor range:range];
    [attributedText addAttribute:NSFontAttributeName value:self.font range:range];
    NSMutableParagraphStyle *paragraphyStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphyStyle.alignment = self.textAlignment;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphyStyle range:range];
    return attributedText;
}
- (void)calculateTextLayers
{
    [newTextLayers removeAllObjects];
    NSString *text = textStorage.string;
    NSRange wordRange = NSMakeRange(0, text.length);
    NSMutableAttributedString *attributedString = [self internalAttributedText:text];
    NSInteger index = wordRange.location;
    NSInteger totalLenth = NSMaxRange(wordRange);
    CGRect layoutRect = [textLayoutManager usedRectForTextContainer:textContainer];
    while (index < totalLenth) {
        //glyph 是表示一个 character 的具体样式，但他们却不是一一对应的关系，1个character可能对应多个glyph 1个glyph也可能对应多个character
        NSRange glyphRange = NSMakeRange(index, 1);
        NSRange characterRange = [textLayoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:nil];
        NSTextContainer *container = [textLayoutManager textContainerForGlyphAtIndex:index effectiveRange:nil];
        CGRect glypRect = [textLayoutManager boundingRectForGlyphRange:glyphRange inTextContainer:container];
        
        NSRange kerningRange = [textLayoutManager rangeOfNominallySpacedGlyphsContainingIndex:index];
        if (kerningRange.location == index && kerningRange.length > 1) {
            if (newTextLayers.count > 0) {
                //如果前一个textlayer的frame.size.width不变大的话，当前的textLayer会遮挡住字体的一部分。其实这种情况就是两个字符显示区域在x方向有重叠。
                CATextLayer *pre = newTextLayers[newTextLayers.count - 1];
                CGRect frame = pre.frame;
                frame.size.width += CGRectGetMaxX(glypRect) - CGRectGetMaxX(frame);//把前一个textLayer的宽度调整至新的glyphRect的最右边，保证前一个textLayer能正常显示。
                pre.frame = frame;
            }
        }
        
        //中间垂直
        glypRect.origin.y += (self.bounds.size.height/2) - (layoutRect.size.height/2);
        
        //创建textLayer
        CATextLayer *textLayer = [[CATextLayer alloc] init];
        textLayer.frame = glypRect;
        textLayer.string = [attributedString attributedSubstringFromRange:characterRange];
        textLayer.opacity = 0;
        textLayer.contentsScale = [UIScreen mainScreen].scale;//contentScale属性，用来决定图层内容应该以怎样的分辨率来渲染，不设置这个属性，字体会模糊
        
        [self.layer addSublayer:textLayer];
        [newTextLayers addObject:textLayer];
        
        index += characterRange.length;
    }
}
//NSLayoutManagerDelegate 协议方法
- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(nullable NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag
{
    [self calculateTextLayers];
}
//CAAnimationDelegate 协议方法
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (disappearLayer) {
        [disappearLayer removeFromSuperlayer];
    }
}
@end
