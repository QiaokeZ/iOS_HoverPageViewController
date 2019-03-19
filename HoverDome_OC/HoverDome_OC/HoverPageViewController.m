//
//  HoverPageViewController.m
//  HoverDome_OC
//
//  Created by admin on 2019/3/20.
//  Copyright © 2019 com.etraffic.EasyCharging. All rights reserved.
//

#import "HoverPageViewController.h"

@interface HoverPageScrollView : UIScrollView<UIGestureRecognizerDelegate>

@end

@implementation HoverPageScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end

@interface HoverPageViewController ()
@property(nonatomic, strong) HoverPageScrollView *mainScrollView;
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

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

@end
