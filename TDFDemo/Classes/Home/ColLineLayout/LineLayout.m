//
//  LineLayout.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/28.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "LineLayout.h"
#import "ColImageCell.h"

//cell大小
static const CGFloat itemWH = 110;
//缩放因素: 值越大, item就会越大
static const CGFloat  scaleFactor = 0.6;
//有效距离:当item的中间x距离屏幕的中间x在activeDistance以内,才会开始放大, 其它情况都是缩小
static const CGFloat  activeDistance = 200;

@implementation LineLayout
/**
 *  只要显示的边界发生改变就重新布局:
 *  内部会重新调用prepareLayout和layoutAttributesForElementsInRect方法获得所有cell的
 *  布局属性
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//一些初始化工作最好在这里实现
- (void)prepareLayout
{
    [super prepareLayout];
    
    //cell大小
    self.itemSize = CGSizeMake(itemWH, itemWH);
    CGFloat inset = (self.collectionView.frame.size.width - itemWH) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    //水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;
}
/**
 *  返回rect区域内所有cell的布局属性，rect默认包含collectionView中所有的cell
 *  每一个cell(item)都有自己的UICollectionViewLayoutAttributes
 *
 *  @return rect区域内所有cell的布局属性
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //计算可见的矩形框
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    //取得默认的cell的UICollectionViewLayoutAttributes
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    //计算屏幕中间的x
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    //遍历所有的布局属性
    CGFloat preScale = 0;
    UICollectionViewCell *preCell;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        //如果不在屏幕上，直接跳过
        if (!CGRectIntersectsRect(visiableRect, attrs.frame)) {
            continue;
        }
        //每一个item的中点x
        CGFloat itemCenterX = attrs.center.x;
        //差距越小，缩放比例越大
        //根据跟屏幕最中间的距离计算缩放比例
        CGFloat scale = 1 + scaleFactor * (0.6 - (ABS(itemCenterX - centerX) / activeDistance));
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
        
        //大的item显示在最上面
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:attrs.indexPath];
        if (scale > preScale) {
            [cell.superview bringSubviewToFront:cell];
        } else {
            [cell.superview insertSubview:cell belowSubview:preCell];
        }
        preCell = cell;
        preScale = scale;
    }
    return array;
}
/**
 *  用来设置collectionView停止滚动那一刻的位置
 *
 *  @param proposedContentOffset 原本collectionView停止滚动那一刻的位置
 *  @param velocity              滚动速度
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //计算出collectionView最后会停留的范围
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    //计算屏幕最中间的x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    //取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    //遍历所有属性
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(attrs.center.x - centerX) < ABS(adjustOffsetX)) {
            adjustOffsetX = attrs.center.x - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}
@end
