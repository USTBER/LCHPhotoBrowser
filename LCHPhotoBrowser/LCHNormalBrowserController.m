//
//  ViewController.m
//  LCHPhotoBrowser
//
//  Created by LiChunxing on 16/4/4.
//  Copyright © 2016年 Demo. All rights reserved.
//

#import "LCHNormalBrowserController.h"
#import "LCHScrollView.h"
#import "LCHImageButton.h"
#import <Masonry.h>
#import "LCHModalBrowserController.h"

@interface LCHNormalBrowserController ()
<LCHImageButtonDelegate, LCHModalBrowserDataSource>
@property (nonatomic, strong) LCHScrollView *scrollView;
@property (nonatomic, copy) NSArray<LCHImageButton *> *buttons;
@property (nonatomic, copy) NSArray *imageURLS;
@property (nonatomic, strong) NSMutableArray *mutableImages;
@property (nonatomic, assign) NSUInteger imageCount;
@property (nonatomic, assign) NSUInteger pressedImageIndex;
@end

@implementation LCHNormalBrowserController

- (LCHScrollView *)scrollView{
    
    if(_scrollView){
        return _scrollView;
    }
    _scrollView = [LCHScrollView scrollViewWithImageButtons:self.buttons];
    return _scrollView;
}

- (NSMutableArray *)mutableImages{
    
    if(_mutableImages){
        return _mutableImages;
    }
    _mutableImages = [[NSMutableArray alloc] initWithCapacity:self.imageCount];
    for(int i = 0; i < self.imageCount; i++){
        [_mutableImages addObject:[UIImage imageNamed:@"placeholderImage"]];
    }
    return _mutableImages;
}

- (NSArray *)buttons{
    
    if(_buttons){
        return _buttons;
    }
    NSInteger tag = 0;
    NSMutableArray *tem = [NSMutableArray array];
    for(NSString *urlString in self.imageURLS){
        NSURL *url = [NSURL URLWithString:urlString];
        LCHImageButton *imageButton = [LCHImageButton imageButtonWithImageURL:url tag:tag];
        tag ++;
        imageButton.delegate = self;
        [tem addObject:imageButton];
    };
    _buttons = [[NSArray alloc] initWithArray:tem];
    return _buttons;
}

- (NSArray *)imageURLS{
    
    if(_imageURLS){
        return _imageURLS;
    }
    NSDictionary *imageDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ImageURLS" ofType:@"plist"]];
    _imageURLS = [imageDic objectForKey:@"NormalBrowserImages"];
    self.imageCount = _imageURLS.count;
    return _imageURLS;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.scrollView];
    WeakSelf(weakSelf);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.scrollView updateBottomConstrain];
}

- (void)handleTap:(LCHImageButton *)sender{
    
    NSInteger tag = sender.tag;
    self.pressedImageIndex = tag;
    LCHModalBrowserController *modalBrowser = [[LCHModalBrowserController alloc] init];
    modalBrowser.dataSource = self;
    modalBrowser.currentIndex = tag;
    modalBrowser.totalCount = self.imageCount;
    [modalBrowser show];
}

- (void)replaceImage:(UIImage *)image tag:(NSInteger)tag{
    
    [self.mutableImages replaceObjectAtIndex:tag withObject:image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma LCHModalBrowserControllerDataSource

- (UIImage *)modalBrowser:(LCHModalBrowserController *)modalBrowser placeHolderImageForIndex:(NSUInteger)index{
    
    UIImage *image = [[self.mutableImages objectAtIndex:index] copy];
    return image;
}

- (NSURL *)modalBrowser:(LCHModalBrowserController *)modalBrowser highQurityImageURLForIndex:(NSUInteger)index{
    
    return [self.imageURLS objectAtIndex:index];
}

- (CGRect)originImageRectForModalBrowser:(LCHModalBrowserController *)modalBrowser index:(NSUInteger)index{
    LCHImageButton *imageButton = self.scrollView.imageButtons[index];
    CGRect rect = imageButton.frame;
    return rect;
}

@end
