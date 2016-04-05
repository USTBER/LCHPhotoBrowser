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

@interface LCHNormalBrowserController ()
<LCHImageButtonDelegate>
@property (nonatomic, strong) LCHScrollView *scrollView;
@property (nonatomic, copy) NSArray<LCHImageButton *> *buttons;
@property (nonatomic, copy) NSArray *imageURLS;

@end

@implementation LCHNormalBrowserController

- (LCHScrollView *)scrollView{
    
    if(_scrollView){
        return _scrollView;
    }
    _scrollView = [LCHScrollView scrollViewWithImageButtons:self.buttons];
    return _scrollView;
}

- (NSArray *)buttons{
    
    if(_buttons){
        return _buttons;
    }
    NSMutableArray *tem = [NSMutableArray array];
    for(NSString *urlString in self.imageURLS){
        NSURL *url = [NSURL URLWithString:urlString];
        LCHImageButton *imageButton = [LCHImageButton imageButtonWithImageURL:url];
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
    
    NSLog(@"我确实被点到了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
