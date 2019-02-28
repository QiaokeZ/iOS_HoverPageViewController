# HoverPageViewController

<img src="https://ws1.sinaimg.cn/large/006tKfTcgy1g0m5u5mmgtg30c20kuqva.gif" width="30%" height="50%"/>

### 主控制器
```swift
class ViewController: UIViewController {

    /// 可根据业务需求更改
    static let headerViewHeight: CGFloat = 200
    static let pageTitleViewHeight: CGFloat = 40
    
    var hoverPageViewController:HoverPageViewController!
    let indicator = UIView()
    var indicatorMargin:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor.white
        title = "悬停"
        prepareView()
    }
}

extension ViewController {

    private func prepareView() {
        let headerView = UILabel()
        headerView.frame.size = CGSize(width: view.frame.width, height: ViewController.headerViewHeight)
        headerView.backgroundColor = UIColor.red
        headerView.text = "我是头部"
        headerView.textAlignment = .center
        
        /// 指示器
        let pageTitleView = UIView()
        pageTitleView.frame.size = CGSize(width: view.frame.width, height: ViewController.pageTitleViewHeight)

        /// 添加3个按钮
        let buttonSize = CGSize(width: view.frame.width / 3, height: pageTitleView.frame.height)
        for i in 0..<3 {
            let button = UIButton()
            button.tag = i
            button.frame.size = buttonSize
            button.backgroundColor = UIColor.lightGray
            button.frame.origin.x = CGFloat(i) * buttonSize.width
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitle("控制器", for: .normal)
            button.addTarget(self, action: #selector(ViewController.buttonClick), for: .touchUpInside)
            pageTitleView.addSubview(button)
        }
        
        let button = pageTitleView.subviews[0] as! UIButton
        button.layoutIfNeeded()
        indicator.frame.size = CGSize(width: (button.titleLabel?.frame.width)!, height: 3)
        indicator.backgroundColor = UIColor.yellow
        indicator.center.x = button.center.x
        indicator.frame.origin.y = button.frame.height - indicator.frame.height
        indicatorMargin = indicator.frame.origin.x
        pageTitleView.addSubview(indicator)
        
        /// 添加子控制器
        var viewControllers = [HoverContainerViewController]()
        let vc1 = Children1ViewController()
        let vc2 = Children2ViewController()
        let vc3 = Children3ViewController()
        viewControllers.append(vc1)
        viewControllers.append(vc2)
        viewControllers.append(vc3)
        
         
        hoverPageViewController = HoverPageViewController(viewControllers: viewControllers, headerView: headerView, pageTitleView: pageTitleView)
        hoverPageViewController.delegate = self
        addChild(hoverPageViewController)
        view.addSubview(hoverPageViewController.view)
    }

    @objc func buttonClick(btn: UIButton) {
        hoverPageViewController.selectedIndex = btn.tag
    }
}

extension ViewController:HoverPageViewControllerDelegate{
    
    func hoverPageViewController(_ viewController: HoverPageViewController, scrollViewDidScroll: UIScrollView) {
        let progress = scrollViewDidScroll.contentOffset.x / scrollViewDidScroll.frame.width
        indicator.frame.origin.x = ((indicator.frame.width + (indicatorMargin * 2)) * progress) + indicatorMargin
    }
}
```
### 子控制器
```swift
class Children1ViewController: HoverContainerViewController {

    private lazy var items: [String] = {
        var items = [String]()
        for i in 0..<100 {
            items.append("\(i)")
        }
        return items
    }()

    private lazy var tableView: UITableView = {
        let inset = UIEdgeInsets(top: ViewController.headerViewHeight, left: 0, bottom: 0, right: 0)
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "aaaa")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.bounces = false
        tableView.contentInset = UIEdgeInsets(top: ViewController.headerViewHeight, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        view.addSubview(tableView)

    }

    override var offsetY: CGFloat {
        didSet {
            tableView.contentOffset = CGPoint(x: 0, y: offsetY)
        }
    }

    override var isStopScroll: Bool {
        didSet {
            tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y), animated: false)
        }
    }
}

extension Children1ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aaaa", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: HoverPageViewController.HoverPageViewOffsetChange),
                                        object: self,
                                        userInfo: [HoverPageViewController.OffsetKey: scrollView.contentOffset])
        offsetY = scrollView.contentOffset.y
    }
}
```