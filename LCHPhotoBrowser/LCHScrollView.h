//
//  LCHScrollView.h
//  LCHPhotoBrowser
//
//  Created by LiChunxing on 16/4/5.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCHImageButton.h"
#import "LCHGrobalConfig.pch"

@interface LCHScrollView : UIScrollView

- (void)updateBottomConstrain;

+ (instancetype)scrollViewWithImageButtons:(NSArray<LCHImageButton *> *)imageButtons;

@end
