//
//  WaterFlowLayout.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/28.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "WaterFlowLayout.h"

@interface WaterFlowLayout ()
//这个字典用来存储每一列最大的Y值(每一列的高度)
@property (nonatomic, strong) NSMutableDictionary *maxYDict;
//存放所有的布局属性
@property (nonatomic, strong) NSMutableArray *attrsArray;
@end

@implementation WaterFlowLayout
- (NSMutableDictionary *)maxYDict
{
    if (!_maxYDict) {
        self.maxYDict = [[NSMutableDictionary alloc] init];
    }
    return _maxYDict;
}
- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        self.attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}
- (instancetype)init
{
    if (self = [super init]) {
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        self.columnsCount = 3;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
- (void)prepareLayout
{
    DLog(@"prepareLayout----");
    
    [super prepareLayout];
    
    //清空最大的Y值
    for (int i = 0; i < self.columnsCount; i++) {
        NSString *column = [NSString stringWithFormat:@"%d", i];
        self.maxYDict[column] = @(self.sectionInset.top);
    }
    
    //计算所有cell的属性
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"layoutAttributesForItemAtIndexPath----");
    
    //假设最短的那一列是第0列
    __block NSString *minColumn = @"0";
    // 找出最短的那一列
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * _Nonnull stop) {
        if ([maxY floatValue] < [self.maxYDict[minColumn] floatValue]) {
            minColumn = column;
        }
    }];
    
    //计算frame
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnsCount - 1) * self.columnMargin) / self.columnsCount;
    CGFloat height = [self.delegate waterflowLayout:self heightForWidth:width atIndexPath:indexPath];
    CGFloat x = self.sectionInset.left + (width + self.columnMargin) * [minColumn intValue];
    CGFloat y = [self.maxYDict[minColumn] floatValue] + self.rowMargin;
    
    //更新这一列的最大Y值
    self.maxYDict[minColumn] = @(y + height);
    
    //创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    
    return attrs;
}
//返回rect范围内的布局属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    DLog(@"layoutAttributesForElementsInRect----");
    
    return self.attrsArray;
}
//返回所有的尺寸
- (CGSize)collectionViewContentSize
{
    DLog(@"collectionViewContentSize----");
    
    __block NSString *maxColumn = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * _Nonnull stop) {
        if ([maxY floatValue] > [self.maxYDict[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    return CGSizeMake(0, [self.maxYDict[maxColumn] floatValue] + self.sectionInset.bottom);
}
@end
