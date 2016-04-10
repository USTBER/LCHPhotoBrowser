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
#import <WCAlertView.h>

@interface LCHModalBrowserController ()
<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSMutableArray *photoViews;
@property (nonatomic, assign, getter = hasShowModalImage) BOOL showModalImage;

- (void)adjustMasonrys;
- (void)configPhotoViewFrame;
- (void)showModalBrowser;
- (void)hideModalBrowser;
- (UIImage *)placeHolderImageForIndex:(NSInteger)index;
- (NSURL *)highQurityImageForIndex:(NSInteger)index;
- (CGRect)originImageRect;
- (void)setUpImageForIndex:(NSUInteger)index;
- (void)handleSaveButton:(UIButton *)sender;
- (void)saveImageToAlbumWithImage:(UIImage *)image error:(NSError *)error info:(void *)info;

@end

@implementation LCHModalBrowserController


#pragma 懒加载
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
    [_saveButton.layer setCornerRadius:5];
    [_saveButton.layer setBorderWidth:0.5];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_saveButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_saveButton addTarget:self action:@selector(handleSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    return _saveButton;
}


- (UILabel *)titleLabel{
    if(_titleLabel){
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setText:[NSString stringWithFormat:@"%lu/%lu", (unsigned long)(self.currentIndex + 1), (unsigned long)self.totalCount]];
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


#pragma viewController生命周期方法
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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.scrollView.contentOffset = CGPointZero;
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    [self configPhotoViewFrame];
}

- (void)viewDidAppear:(BOOL)animated{
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x += self.scrollView.width * self.currentIndex;
    self.currentIndex = NSUIntegerMax;
    [self.scrollView setContentOffset:contentOffset animated:NO];
    [self configPhotoViewFrame];
    [self setUpImageForIndex:self.currentIndex];
    
    if(!self.hasShowModalImage){
        [self showModalBrowser];
    }
}


#pragma 内部方法
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
        make.height.mas_equalTo(SaveButtonHeight);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(Padding);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.leading.mas_equalTo(weakSelf.view).offset(-ScrollMargin / 2);
        make.trailing.mas_equalTo(weakSelf.view).offset(ScrollMargin / 2);
        make.bottom.mas_equalTo(weakSelf.saveButton.mas_top).offset(-Padding);
    }];
    
    
}


- (void)showModalBrowser{
    
    CGRect targetRect = self.scrollView.frame;
    targetRect.origin.x += ScrollMargin / 2;
    targetRect.size.width -= ScrollMargin;
    
    UIImageView *temImageView = [[UIImageView alloc] initWithFrame:[self originImageRect]];
    [temImageView setContentMode:UIViewContentModeScaleAspectFit];
    temImageView.image = [self placeHolderImageForIndex:self.currentIndex];
    [self.view addSubview:temImageView];
    
    self.scrollView.hidden = YES;
    self.titleLabel.hidden = YES;
    self.saveButton.hidden = YES;
    
    
    [UIView animateWithDuration:0.4 animations:^{
        temImageView.frame = targetRect;
    } completion:^(BOOL finished) {
        [temImageView removeFromSuperview];
        self.scrollView.hidden = NO;
        self.titleLabel.hidden = NO;
        self.saveButton.hidden = NO;
    }];
}

- (void)hideModalBrowser{
    
    LCHPhotoView *photoView = self.photoViews[self.currentIndex];
    CGRect targetRect = [self originImageRect];;
    CGRect currentRect = self.scrollView.frame;
    UIImage *image = photoView.imageView.image;
    UIImageView *temImageView = [[UIImageView alloc] initWithFrame:currentRect];
    temImageView.image = image;
    temImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view.window addSubview:temImageView];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
    [UIView animateWithDuration:0.5 animations:^{
        temImageView.frame = targetRect;
    } completion:^(BOOL finished) {
        [temImageView removeFromSuperview];
    }];
}


- (void)setUpImageForIndex:(NSUInteger)index{
    
    
    LCHPhotoView *photoView = self.photoViews[index];
    if(!photoView){
        return;
    }
    if(photoView.isLoadingImage){
        return;
    }
    [photoView setImageWithURL:[self highQurityImageForIndex:index] placeHolderImage:[self placeHolderImageForIndex:index]];
    photoView.loadingImage = YES;
    
    
}

- (void)handleSaveButton:(UIButton *)sender{
    
    LCHPhotoView *photoView = self.photoViews[self.currentIndex];
    UIImage *image = photoView.imageView.image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(saveImageToAlbumWithImage:error:info:), NULL);
}

- (void)saveImageToAlbumWithImage:(UIImage *)image error:(NSError *)error info:(void *)info{
    
    NSString *title = @"谢谢您使用LCH壁纸";
    NSString *message;
    if (error) {
        message = @"壁纸保存失败，请检查是否同意保存到相册";
    }else{
        message = @"壁纸保存成功，祝您一天心情愉快";
    }
    
    [WCAlertView setDefaultStyle:WCAlertViewStyleWhite];
    [WCAlertView showAlertWithTitle:title message:message customizationBlock:^(WCAlertView *alertView) {
        
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
    } cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
}

- (void)show{
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self animated:NO completion:^{
        
    }];
}



#pragma 转屏触发事件
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    CGFloat scrollWidth = size.width + ScrollMargin;
    [self.scrollView setContentOffset:CGPointMake(scrollWidth * self.currentIndex, 0) animated:YES];
    
}

#pragma scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat currentX = scrollView.contentOffset.x;
    NSUInteger index = currentX / self.scrollView.width + 0.5;
    if(index == self.currentIndex){
        return;
    }
    self.currentIndex = index;
    [self.titleLabel setText:[NSString stringWithFormat:@"%lu/%lu", (unsigned long)(self.currentIndex + 1), (unsigned long)self.totalCount]];
    
    NSInteger before = index - 2;
    before = ((before < 0) ? 0 : before);
    NSInteger after = index + 2;
    after = (after > (self.totalCount - 1) ? self.totalCount - 1 : after);
    
    for(NSInteger i = before; i <= after; i++){
        [self setUpImageForIndex:i];
    }
}



#pragma 内部方法，调用LCHModalBrowserDataSource方法
- (UIImage *)placeHolderImageForIndex:(NSInteger)index{
    
    if([self.dataSource respondsToSelector:@selector(modalBrowser:placeHolderImageForIndex:)]){
        
        UIImage *image = [self.dataSource modalBrowser:self placeHolderImageForIndex:index];
        return image;
    }
    return nil;
    
}

- (NSURL *)highQurityImageForIndex:(NSInteger)index{
    
    if([self.dataSource respondsToSelector:@selector(modalBrowser:highQurityImageURLForIndex:)]){
        NSURL *imageURL = [self.dataSource modalBrowser:self highQurityImageURLForIndex:index];
        return imageURL;
    }
    return nil;
}

- (CGRect)originImageRect{
    
    if([self.dataSource respondsToSelector:@selector(originImageRectForModalBrowser:index:)]){
        
        CGRect rect = [self.dataSource originImageRectForModalBrowser:self index:self.currentIndex];
        return rect;
    }
    return CGRectZero;
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
