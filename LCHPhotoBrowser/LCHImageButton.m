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

+ (instancetype)imageButtonWithImageURL:(NSURL *)imageURL{
    
    if(!imageURL)
        return nil;
    LCHImageButton *imageButton = [[LCHImageButton alloc] init];
    imageButton.backgroundColor = [UIColor clearColor];
    imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageButton.clipsToBounds = YES;
    [imageButton sd_setImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    [imageButton addTarget:imageButton.delegate action:@selector(handleTap:) forControlEvents:UIControlEventTouchUpInside];
    return imageButton;
}

@end
