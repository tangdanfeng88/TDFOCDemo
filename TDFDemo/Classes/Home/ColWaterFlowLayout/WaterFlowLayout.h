//
//  WaterFlowLayout.h
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/28.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFlowLayout;
@protocol WaterFlowLayoutDelegate <NSObject>

- (CGFloat)waterflowLayout:(WaterFlowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;
@end
@interface WaterFlowLayout : UICollectionViewLayout
@property (nonatomic, weak) id<WaterFlowLayoutDelegate> delegate;

//section离四边的间距
@property (nonatomic, assign) UIEdgeInsets sectionInset;
//每一列之间的间距
@property (nonatomic, assign) CGFloat columnMargin;
//每一行之间的间距
@property (nonatomic, assign) CGFloat rowMargin;
//显示多少列
@property (nonatomic, assign) int columnsCount;
@end
