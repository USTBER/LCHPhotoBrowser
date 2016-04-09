//
//  LCHPhotoView.m
//  LCHPhotoBrowser
//
//  Created by LiChunxing on 16/4/9.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "LCHPhotoView.h"
#import "LCHGrobalConfig.pch"
#import <UIImageView+WebCache.h>
#import <Masonry.h>


@interface LCHPhotoView ()
<UIScrollViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

- (void)handleSingleTap:(UITapGestureRecognizer *)singleTap;
- (void)handleDoubleTap:(UITapGestureRecognizer *)DoubleTap;
@end

@implementation LCHPhotoView

- (UIScrollView *)scrollView{
    if(_scrollView){
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc] init];
    return _scrollView;
}

- (UITapGestureRecognizer *)singleTap{
    
    if(_singleTap){
        return _singleTap;
    }
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    _singleTap.numberOfTapsRequired = 1;
    _singleTap.numberOfTouchesRequired = 1;
    [_singleTap requireGestureRecognizerToFail:self.doubleTap];
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap{
    
    if(_doubleTap){
        return _doubleTap;
    }
    _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    _doubleTap.numberOfTapsRequired = 2;
    _doubleTap.numberOfTouchesRequired = 1;
    return _doubleTap;
}


- (UIImageView *)imageView{
    
    if(_imageView){
        return _imageView;
    }
    _imageView = [[UIImageView alloc] init];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    _imageView.backgroundColor = [self randomColor];
    return _imageView;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        [self addGestureRecognizer:self.singleTap];
        [self addGestureRecognizer:self.doubleTap];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    WeakSelf(weakSelf);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(ScrollMargin / 2);
        make.top.offset(0);
        make.width.mas_equalTo(weakSelf.width - ScrollMargin);
        make.height.mas_equalTo(weakSelf.height);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.scrollView);
        make.size.equalTo(weakSelf.scrollView);
    }];
    
}

- (void)setImageWithURL:(NSURL *)imageURL placeHolderImage:(UIImage *)placeHolderImage{
    
    [self.imageView sd_setImageWithURL:imageURL placeholderImage:placeHolderImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.loadingImage = NO;
    }];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)singleTap{
    
    if(self.singleTapBlock){
        self.singleTapBlock(singleTap);
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)DoubleTap{
    
    
}


- (UIColor *)randomColor{
    
    CGFloat hue = (arc4random() % 256 / 256.0);
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
    
    UIColor *randomColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return randomColor;
}





@end
