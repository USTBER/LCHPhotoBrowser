//
//  LCHImageButton.m
//  LCHPhotoBrowser
//
//  Created by LiChunxing on 16/4/5.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "LCHImageButton.h"
#import <UIButton+WebCache.h>

@implementation LCHImageButton

+ (instancetype)imageButtonWithImageURL:(NSURL *)imageURL tag:(NSInteger)tag{
    
    if(!imageURL)
        return nil;
    LCHImageButton *imageButton = [[LCHImageButton alloc] init];
    imageButton.tag = tag;
    imageButton.backgroundColor = [UIColor clearColor];
    imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageButton.clipsToBounds = YES;
    __weak typeof(imageButton) weakImageButton = imageButton;
    [imageButton sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if(!error){
            [weakImageButton.delegate replaceImage:image tag:weakImageButton.tag];
        }
    }];
    [imageButton addTarget:imageButton.delegate action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
    return imageButton;
}

@end
