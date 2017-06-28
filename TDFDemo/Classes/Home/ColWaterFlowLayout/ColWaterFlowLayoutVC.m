//
//  ColWaterFlowLayoutVC.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/28.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "ColWaterFlowLayoutVC.h"
#import "WaterFlowLayout.h"
#import "ColShopModel.h"
#import "ColShopCell.h"

static NSString * const ID = @"shop";

@interface ColWaterFlowLayoutVC () <UICollectionViewDataSource, UICollectionViewDelegate, WaterFlowLayoutDelegate>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *shops;
@end

@implementation ColWaterFlowLayoutVC
- (NSMutableArray *)shops
{
    if (_shops == nil) {
        self.shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"COL瀑布流";
    
    //创建数据源
    [self createShops];
    //创建collectionView
    [self createCollectionView];
}

- (void)createShops
{
    NSArray *shopArray = [ColShopModel mj_objectArrayWithFilename:@"collection.plist"];
    [self.shops addObjectsFromArray:shopArray];
}
- (void)createCollectionView
{
    WaterFlowLayout *waterFlowLayout = [[WaterFlowLayout alloc] init];
    waterFlowLayout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight-64) collectionViewLayout:waterFlowLayout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerClass:[ColShopCell class] forCellWithReuseIdentifier:ID];
}
#pragma mark - UICollectionViewDataSource 协议方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

{
    ColShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.shop = self.shops[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate 协议方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.shops removeObjectAtIndex:indexPath.item];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}
#pragma mark - WaterFlowLayoutDelegate 协议方法
- (CGFloat)waterflowLayout:(WaterFlowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    ColShopModel *shop = self.shops[indexPath.item];
    return shop.h / shop.w * width;
}
@end
