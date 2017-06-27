//
//  InfiniteScrollVC.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/10.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "InfiniteScrollVC.h"
#import "ISModel.h"
#import "ISCell.h"

#define TDF_MAX_SECTIONS    100
#define TDF_CELL_IDENTIFIER @"news"

@interface InfiniteScrollVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *newses;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation InfiniteScrollVC
- (NSArray *)newses
{
    if (!_newses) {
        self.newses = [ISModel mj_objectArrayWithFilename:@"newses.plist"];
        self.pageControl.numberOfPages = self.newses.count;
    }
    return _newses;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"循环滚动";

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *cView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 130) collectionViewLayout:flowLayout];
    [self.view addSubview:cView];
    self.collectionView = cView;
    cView.delegate = self;
    cView.dataSource = self;
    [cView registerClass:[ISCell class] forCellWithReuseIdentifier:TDF_CELL_IDENTIFIER];
    cView.pagingEnabled = YES;
    cView.showsHorizontalScrollIndicator = NO;
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 115, mainWidth, 5)];
    self.pageControl = pageControl;
    [self.view addSubview:pageControl];
    
    // 默认显示中间那组
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:TDF_MAX_SECTIONS / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    [self addTimer];
}

- (void)removeTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)addTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (NSIndexPath *)resetIndexPath
{
    // 当前正在展示的位置
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    // 马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:TDF_MAX_SECTIONS / 2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    return currentIndexPathReset;
}
- (void)nextPage
{
    // 马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathReset = [self resetIndexPath];
    // 计算出下一个需要展示的位置
    NSInteger nextItem = currentIndexPathReset.item + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.newses.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    // 通过动画滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}
#pragma mark - UICollectionViewDataSource 协议方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.newses.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ISCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TDF_CELL_IDENTIFIER forIndexPath:indexPath];
    cell.news = self.newses[indexPath.item];
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return TDF_MAX_SECTIONS;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger page = (NSUInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.newses.count;
    self.pageControl.currentPage = page;
}
@end
