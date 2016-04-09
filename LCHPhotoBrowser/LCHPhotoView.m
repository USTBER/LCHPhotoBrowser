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

- (void)adjustFrame;
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
    [self.scrollView addSubview:_imageView];
    return _imageView;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [self randomColor];
    if(self){
        [self addSubview:_imageView];
        [self addGestureRecognizer:self.singleTap];
        [self addGestureRecognizer:self.doubleTap];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    
}

- (void)adjustFrame{
    
    self.scrollView.contentSize = self.bounds.size;
    WeakSelf(weakSelf);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.scrollView);
    }];
    
}

- (void)setImageWithURL:(NSURL *)imageURL placeHolderImage:(UIImage *)placeHolderImage{
    
    [self.imageView sd_setImageWithURL:imageURL placeholderImage:placeHolderImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
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
