

#import "Children1ViewController.h"

@interface Children1ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation Children1ViewController

- (void)setOffsetY:(CGFloat)offsetY{
    self.tableView.contentOffset = CGPointMake(0, offsetY);
}

- (CGFloat)offsetY{
    return self.tableView.contentOffset.y;
}

- (void)setIsCanScroll:(BOOL)isCanScroll{
    if (isCanScroll == YES){
        [self.tableView setContentOffset:CGPointMake(0, self.offsetY) animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"123"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.scrollDelegate respondsToSelector:@selector(hoverChildViewController:scrollViewDidScroll:)]){
        [self.scrollDelegate hoverChildViewController:self scrollViewDidScroll:scrollView];
    }
}

@end
