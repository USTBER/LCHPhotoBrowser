//
//  LCHScrollView.m
//  LCHPhotoBrowser
//
//  Created by LiChunxing on 16/4/5.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "LCHScrollView.h"
#import <Masonry.h>
#import "LCHGrobalConfig.pch"

@interface LCHScrollView ()

@property (nonatomic, copy) NSArray<LCHImageButton *> *imageButtons;
@property (nonatomic, assign) CGFloat buttonLength;
@property (nonatomic, strong) UIView *bottomView;

@end

static NSUInteger const rowCapacity = 3;
static CGFloat const paddingX = 20;
static CGFloat const paddingY = 25;

@implementation LCHScrollView

- (CGFloat)buttonLength{
    
    if(_buttonLength){
        return _buttonLength;
    }
    _buttonLength = (ScreenWidth - paddingX * (rowCapacity + 1)) / rowCapacity;
    return _buttonLength;
}


- (void)setImageButtons:(NSArray<LCHImageButton *> *)imageButtons{
    
    if(_imageButtons == imageButtons){
        return;
    }
    _imageButtons = imageButtons;
    NSUInteger buttonCount = imageButtons.count;
    if(!buttonCount){
        return;
    }
    
    for(int i = 0; i < buttonCount; i++){
        
        LCHImageButton *button = [imageButtons objectAtIndex:i];
        NSUInteger row = i / rowCapacity;
        NSUInteger column = i % rowCapacity;
        [self addSubview:button];
        WeakSelf(weakSelf);
        CGFloat top = row * (self.buttonLength + paddingY) + paddingY;
        CGFloat left = column * (self.buttonLength + paddingX) + paddingX;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(weakSelf.buttonLength);
            make.top.mas_equalTo(top);
            make.left.mas_equalTo(left);
        }];
        
        self.bottomView = [[UIView alloc] init];
        self.bottomView.layer.opacity = 0;
        [self addSubview:self.bottomView];
        if(i == buttonCount - 1){
            
            [self.bottomView  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_equalTo(weakSelf.buttonLength);
                make.top.mas_equalTo(top);
                make.left.mas_equalTo(left);
            }];
        }
        
    }
    
}


+ (instancetype)scrollViewWithImageButtons:(NSArray<LCHImageButton *> *)imageButtons{
    
    LCHScrollView *scrollView = [[LCHScrollView alloc] init];
    scrollView.backgroundColor = [UIColor yellowColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.bounces = YES;
    scrollView.scrollEnabled = YES;
    NSUInteger buttonCount = imageButtons.count;
    NSUInteger rowNum = (buttonCount % rowCapacity ? buttonCount / rowCapacity  + 1: buttonCount / rowCapacity + 2);
    NSLog(@"%lu", (unsigned long)rowNum);
    scrollView.imageButtons = imageButtons;
    return scrollView;
}

- (void)updateBottomConstrain{
    
    WeakSelf(weakSelf);
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.bottomView.mas_bottom).offset(paddingY * 2);
    }];
}

@end
