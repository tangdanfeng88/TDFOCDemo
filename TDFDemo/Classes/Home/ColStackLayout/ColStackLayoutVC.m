//
//  ColStackLayoutVC.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/28.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "ColStackLayoutVC.h"
#import "StackLayout.h"
#import "ColImageCell.h"

static NSString * const ID = @"image";

@interface ColStackLayoutVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation ColStackLayoutVC
- (NSMutableArray *)images
{
    if (!_images) {
        self.images = [[NSMutableArray alloc] init];
        for (int i = 0; i < 20; i++) {
            [self.images addObject:[NSString stringWithFormat:@"col_%d", i + 1]];
        }
        
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"COL堆布局";
    
    StackLayout *lineLayout = [[StackLayout alloc] init];
    UICollectionView *col = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 200) collectionViewLayout:lineLayout];
    [self.view addSubview:col];
    self.collectionView = col;
    col.delegate = self;
    col.dataSource = self;
    [col registerClass:[ColImageCell class] forCellWithReuseIdentifier:ID];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [col setContentOffset:CGPointMake(1, 0)];
    });
}

#pragma mark - UICollectionViewDataSource 协议方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.image = self.images[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate 协议方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.images removeObjectAtIndex:indexPath.item];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}
@end
