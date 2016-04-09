//
//  LCHImageButton.h
//  LCHPhotoBrowser
//
//  Created by LiChunxing on 16/4/5.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCHImageButton;

@protocol LCHImageButtonDelegate <NSObject>

@required

- (void)handleTap:(LCHImageButton *)sender;
- (void)replaceImage:(UIImage *)image tag:(NSInteger)tag;

@end

@interface LCHImageButton : UIButton

@property (nonatomic, weak) id<LCHImageButtonDelegate> delegate;

+ (instancetype)imageButtonWithImageURL:(NSURL *)imageURL tag:(NSInteger)tag;

@end

