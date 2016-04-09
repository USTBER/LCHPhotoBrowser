//
//  LCHModalBrowserController.h
//  LCHPhotoBrowser
//
//  Created by LiChunxing on 16/4/9.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCHModalBrowserController;
@protocol LCHModalBrowserDataSource <NSObject>

@required
- (UIImage *_Nonnull)modalBrowser:(LCHModalBrowserController *_Nonnull)modalBrowser placeHolderImageForIndex:(NSUInteger)index;

- (NSURL *_Nonnull)modalBrowser:(LCHModalBrowserController *_Nonnull)modalBrowser highQurityImageURLForIndex:(NSUInteger)index;

@end

@interface LCHModalBrowserController : UIViewController

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) NSUInteger totalCount;
@property (nonatomic, weak) id<LCHModalBrowserDataSource> dataSource;
@property (nonatomic, weak) UIView *currentImageSourceViewSuperView;

- (void)show;

@end
