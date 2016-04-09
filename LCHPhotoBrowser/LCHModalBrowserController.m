//
//  LCHModalBrowserController.m
//  LCHPhotoBrowser
//
//  Created by LiChunxing on 16/4/9.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "LCHModalBrowserController.h"
#import "LCHGrobalConfig.pch"
#import "LCHPhotoView.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>


@interface LCHModalBrowserController ()
<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSMutableArray *photoViews;

- (void)adjustMasonrys;
- (void)configPhotoViewFrame;
- (void)showModalBrowser;
- (void)hideModalBrowser;
@end

static CGFloat const Padding = 30;
static CGFloat const SaveButtonWidth = 60;
static CGFloat const TitleLabelWidth = 50;
static CGFloat const ScrollMargin = 20;

@implementation LCHModalBrowserController

- (UIScrollView *)scrollView{
    if(_scrollView){
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor greenColor];
    _scrollView.pagingEnabled = YES;
    return _scrollView;
}

- (UIButton *)saveButton{
    if(_saveButton){
        return _saveButton;
    }
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveButton setClipsToBounds:YES];
    [_saveButton.layer setCornerRadius:10];
    [_saveButton.layer setBorderWidth:0.5];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    return _saveButton;
}


- (UILabel *)titleLabel{
    if(_titleLabel){
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setText:@"1/9"];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    return _titleLabel;
}

- (NSMutableArray *)photoViews{
    
    if(_photoViews){
        return _photoViews;
    }
    _photoViews = [[NSMutableArray alloc] initWithCapacity:self.totalCount];
    return _photoViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.titleLabel];
    [self adjustMasonrys];
    
    [self.photoViews removeAllObjects];
    
    WeakSelf(weakSelf);
    for(int i = 0; i < self.totalCount; i++){
        
        LCHPhotoView *photoView = [[LCHPhotoView alloc] init];
        [self.scrollView addSubview:photoView];
        [self.photoViews addObject:photoView];
        photoView.singleTapBlock = ^(UITapGestureRecognizer *tap){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf hideModalBrowser];
        };
    }
    
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    [self configPhotoViewFrame];
}


- (void)configPhotoViewFrame{
    
    CGFloat scrollWidth = self.scrollView.width;
    CGFloat scrollHeight = self.scrollView.height;
    CGSize contentSize = CGSizeMake(scrollWidth * self.totalCount, scrollHeight);
    self.scrollView.contentSize = contentSize;
    [self.photoViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = CGRectMake(idx * scrollWidth, 0, scrollWidth, scrollHeight);
        LCHPhotoView *photoView = obj;
        photoView.frame = frame;
    }];
    
}

- (void)adjustMasonrys{
    
    WeakSelf(weakSelf);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(Padding).priorityHigh();
        make.width.mas_equalTo(TitleLabelWidth);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(weakSelf.saveButton.mas_height).multipliedBy(3).priorityLow();
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-Padding);
        make.left.mas_equalTo(Padding);
        make.width.mas_equalTo(SaveButtonWidth);
        make.width.mas_equalTo(weakSelf.saveButton.mas_height).multipliedBy(3).priorityLow();
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(Padding);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
//        make.width.mas_equalTo(weakSelf.view.width + ScrollMargin);
        make.leading.mas_equalTo(weakSelf.view).offset(-ScrollMargin / 2);
        make.trailing.mas_equalTo(weakSelf.view).offset(ScrollMargin / 2);
        make.bottom.mas_equalTo(weakSelf.saveButton.mas_top).offset(-Padding);
    }];
    
    
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)showModalBrowser{
    
    
}

- (void)hideModalBrowser{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)show{
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self animated:NO completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
