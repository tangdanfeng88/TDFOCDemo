//
//  ColShopCell.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/28.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "ColShopCell.h"
#import "UIImageView+WebCache.h"
#import "ColShopModel.h"

@interface ColShopCell ()
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *priceLabel;
@end

@implementation ColShopCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *priceLabel = [[UILabel alloc] init];
        // 改变背景透明度
        priceLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.textColor = [UIColor whiteColor];
        [self addSubview:priceLabel];
        self.priceLabel = priceLabel;
    }
    return self;
}

- (void)setShop:(ColShopModel *)shop
{
    _shop = shop;
    
    self.imageView.frame = self.bounds;
    
    CGFloat priceX = 0;
    CGFloat priceH = 25;
    CGFloat priceY = self.bounds.size.height - priceH;
    CGFloat priceW = self.bounds.size.width;
    self.priceLabel.frame = CGRectMake(priceX, priceY, priceW, priceH);
    
    self.priceLabel.text = shop.price;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            DLog(@"have image");
        }
    }];
}

@end
