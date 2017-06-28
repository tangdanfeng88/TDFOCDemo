//
//  ColImageCell.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/28.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "ColImageCell.h"

@interface ColImageCell ()
{
    UIImageView *imageView;
}
@end
@implementation ColImageCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.layer.borderWidth = 3;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.cornerRadius = 5;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
    }
    return self;
}

- (void)setImage:(NSString *)image
{
    _image = image;
    imageView.image = [UIImage imageNamed:image];
}

@end
