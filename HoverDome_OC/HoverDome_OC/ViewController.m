

#import "ViewController.h"
#import "HoverPageViewController.h"
#import "Children1ViewController.h"
#import "Children2ViewController.h"
#import "Children3ViewController.h"
@interface ViewController ()<HoverPageViewControllerDelegate>
@property(nonatomic, strong) UIView *indicator;
@property(nonatomic, strong) HoverPageViewController *hoverPageViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"悬停";
    
    UILabel *headerView = [UILabel new];
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    headerView.text = @"可上下滑动头部";
    headerView.textColor = [UIColor whiteColor];
    headerView.backgroundColor = [UIColor  redColor];
    headerView.textAlignment = NSTextAlignmentCenter;
    
    /// 指示器
    UIView *pageTitleView = [UIView new];
    pageTitleView.backgroundColor = [UIColor lightGrayColor];
    pageTitleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    
    /// 添加3个按钮
    CGSize buttonSize = CGSizeMake(self.view.frame.size.width / 3, pageTitleView.frame.size.height);
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton new];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(i * buttonSize.width, 0, buttonSize.width, buttonSize.height);
        [button setTitle:@"控制器" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [pageTitleView addSubview:button];
    }
    
    UIButton *button = pageTitleView.subviews.firstObject;
    [button layoutIfNeeded];
    
    /// 指示器底部
    self.indicator = [UIView new];
    self.indicator.frame = CGRectMake(0, buttonSize.height - 3, buttonSize.width, 3);
    self.indicator.backgroundColor = [UIColor yellowColor];
    [pageTitleView addSubview: self.indicator];
    
    /// 添加子控制器
    NSMutableArray *viewControllers = [NSMutableArray array];
    HoverChildViewController *vc1 = [[Children1ViewController alloc]init];
    HoverChildViewController *vc2 = [[Children2ViewController alloc]init];
    HoverChildViewController *vc3 = [[Children3ViewController alloc]init];
    [viewControllers addObject:vc1];
    [viewControllers addObject:vc2];
    [viewControllers addObject:vc3];
    
    /// 计算导航栏高度
    CGFloat barHeight = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;

     /// 添加分页控制器
    self.hoverPageViewController = [HoverPageViewController viewControllers:viewControllers headerView:headerView pageTitleView:pageTitleView];
    self.hoverPageViewController.view.frame = CGRectMake(0, barHeight, self.view.frame.size.width, self.view.frame.size.height - barHeight);
    self.hoverPageViewController.delegate = self;
    [self addChildViewController:self.hoverPageViewController];
    [self.view addSubview:self.hoverPageViewController.view];
}

- (void)buttonClick:(UIButton *)btn{
    [self.hoverPageViewController moveToAtIndex:btn.tag animated:YES];
}

- (void)hoverPageViewController:(HoverPageViewController *)ViewController scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat progress = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.indicator.frame = CGRectMake(self.indicator.frame.size.width * progress, self.indicator.frame.origin.y, self.indicator.frame.size.width, self.indicator.frame.size.height);

}

@end
