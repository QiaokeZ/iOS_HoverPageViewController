//
//  HoverPageViewController.h
//  HoverDome_OC
//
//  Created by admin on 2019/3/20.
//  Copyright © 2019 com.etraffic.EasyCharging. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HoverChildViewController : UIViewController

@end

@interface HoverPageViewController : UIViewController

- (instancetype)initWithViewControllers:(NSArray<HoverChildViewController *> *)viewControllers headerView:(UIView *)headerView pageTitleView:(UIView *)pageTitleView;

@property(nonatomic, strong, readonly) NSArray<HoverChildViewController *> *viewControllers;
@property(nonatomic, strong, readonly) UIView *headerView;
@property(nonatomic, strong, readonly) UIView *pageTitleView;

@end

NS_ASSUME_NONNULL_END
