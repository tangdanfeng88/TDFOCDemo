//
//  CircleLayout.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/28.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "CircleLayout.h"

@implementation CircleLayout
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
//每个元素的布局属性（包含cell、头视图、脚视图），范围更广
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attrs];
    }
    return array;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.size = CGSizeMake(50, 50);
    
    //圆的半径
    CGFloat circleRadius = 70;
    //圆的中心点
    CGPoint circleCenter = CGPointMake(self.collectionView.frame.size.width * 0.5, self.collectionView.frame.size.height * 0.5);
    //每个item之间的角度
    CGFloat angleDelta = M_PI * 2 / [self.collectionView numberOfItemsInSection:indexPath.section];
    //计算当前item的角度
    CGFloat angle = indexPath.item * angleDelta;
    
    attrs.center = CGPointMake(circleCenter.x + circleRadius * cosf(angle), circleCenter.y - circleRadius * sinf(angle));
    
    return attrs;
}
@end
