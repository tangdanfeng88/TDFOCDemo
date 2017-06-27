//
//  ISCell.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/10.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "ISCell.h"
#import "ISModel.h"

@interface ISCell ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLb;

@end
@implementation ISCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        self.imageView = imageView;
        [self addSubview:imageView];
        
        UILabel *label = [MyTool setupLabelWithFrame:CGRectMake(0, 0, imageView.width, 30) Title:@"" font:[UIFont systemFontOfSize:18] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
        self.titleLb = label;
    }
    return self;
}
- (void)setNews:(ISModel *)news
{
    _news = news;
    
    self.imageView.image = [UIImage imageNamed:news.icon];
    self.titleLb.text = news.title;
}
@end
