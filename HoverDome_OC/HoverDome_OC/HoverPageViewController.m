//
//  HoverPageViewController.m
//  HoverDome_OC
//
//  Created by admin on 2019/3/20.
//  Copyright © 2019 com.etraffic.EasyCharging. All rights reserved.
//

#import "HoverPageViewController.h"

@implementation HoverChildViewController
@end

@interface HoverPageScrollView : UIScrollView<UIGestureRecognizerDelegate>

@end

@implementation HoverPageScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end

@interface HoverPageViewController ()
@property(nonatomic, strong) HoverPageScrollView *mainScrollView;
@property(nonatomic, strong) UIScrollView *pageScrollView;
@end

@implementation HoverPageViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
                             headerView:(UIView *)headerView
                          pageTitleView:(UIView *)pageTitleView{
    if (self =  [super initWithNibName:nil bundle:nil]){
        _viewControllers = viewControllers;
        _headerView = headerView;
        _pageTitleView = pageTitleView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareVie{
    self.mainScrollView = [[HoverPageScrollView alloc]init];
    self.mainScrollView.bounces = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:_headerView];
    [self.mainScrollView addSubview:_pageTitleView];
    
    self.pageScrollView = [[UIScrollView alloc]init];
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    [self.mainScrollView addSubview:self.pageScrollView];
    for (HoverPageViewController *vc in self.viewControllers) {
        [self.pageScrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }
    if (@available(iOS 11.0, *)){
        self.mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.mainScrollView.frame = self.view.bounds;
    self.mainScrollView.contentSize = CGSizeMake(0, self.mainScrollView.frame.size.height + self.headerView.frame.size.height);
    _pageTitleView.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame),  _pageTitleView.frame.size.width,  _pageTitleView.frame.size.height);
    self.pageScrollView.frame = CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, self.mainScrollView.contentSize.height - CGRectGetMaxY(_pageTitleView.frame));
    self.pageScrollView.contentSize = CGSizeMake(self.view.frame.size.width * _viewControllers.count, 0);
    for (NSInteger i = 0; i < _viewControllers.count; i++) {
        HoverChildViewController *vc = [_viewControllers objectAtIndex:i];
        vc.view.frame = CGRectMake(i * self.view.frame.size.width, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }
}

@end
