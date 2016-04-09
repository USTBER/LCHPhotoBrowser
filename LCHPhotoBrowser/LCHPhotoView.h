//
//  LCHPhotoView.h
//  LCHPhotoBrowser
//
//  Created by LiChunxing on 16/4/9.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^_Nonnull SingleTapBlock)(UITapGestureRecognizer *_Nonnull);

@interface LCHPhotoView : UIView

@property (nonatomic, assign, getter=isLoadingImage) BOOL loadingImage;
@property (nonatomic, strong, nullable) UIScrollView *scrollView;
@property (nonatomic, strong, nullable) UIImageView *imageView;
@property (nonatomic, copy) SingleTapBlock singleTapBlock;

- (void)setImageWithURL:(NSURL *_Nonnull)imageURL placeHolderImage:(UIImage *_Nonnull)placeHolderImage;
@end
