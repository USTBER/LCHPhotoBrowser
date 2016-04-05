//
//  UIView+LCHProperty.m
//  LCHPhotoBrowser
//
//  Created by LiChunxing on 16/4/5.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "UIView+LCHProperty.h"

@implementation UIView (LCHProperty)

- (CGFloat)x{
    
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x{
    
    CGRect reFrame = self.frame;
    reFrame.origin.x = x;
    self.frame = reFrame;
}

- (CGFloat)y{
    
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y{
    
    CGRect reFrame = self.frame;
    reFrame.origin.y = y;
}

- (CGFloat)width{
    
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width{
    
    CGRect reFrame = self.frame;
    reFrame.size.width = width;
    self.frame = reFrame;
}

- (CGFloat)height{
    
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height{
    
    CGRect reFrame = self.frame;
    reFrame.size.height = height;
    self.frame = reFrame;
}

- (CGFloat)centerX{
    
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX{
    
    CGPoint reCenter = self.center;
    reCenter.x = centerX;
    self.center = reCenter;
    
}

- (CGFloat)centerY{
    
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY{
    
    CGPoint reCenter = self.center;
    reCenter.y = centerY;
    self.center = reCenter;
    
}




@end
