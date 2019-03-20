# HoverPageViewController
### 简书(https://www.jianshu.com/p/ae1b84b107ea)


 ![image](https://github.com/QiaokeZ/iOS_HoverPageViewController/blob/master/HoverDome_Swift/HoverDome/hover.gif)

### 主控制器
```swift
class ViewController: UIViewController {
    
    var hoverPageViewController:HoverPageViewController!
    let indicator = UIView()
    var indicatorMargin:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "悬停"
        prepareView()
    }
}

extension ViewController {

    private func prepareView() {
        let headerView = UILabel()
        headerView.frame.size = CGSize(width: view.frame.width, height: 200)
        headerView.backgroundColor = UIColor.red
        headerView.text = "可上下滑动头部"
        headerView.textColor = UIColor.white
        headerView.textAlignment = .center
        
        /// 指示器
        let pageTitleView = UIView()
        pageTitleView.frame.size = CGSize(width: view.frame.width, height: 40)

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
        var viewControllers = [HoverChildViewController]()
        let vc1 = Children1ViewController()
        let vc2 = Children2ViewController()
        let vc3 = Children3ViewController()
        viewControllers.append(vc1)
        viewControllers.append(vc2)
        viewControllers.append(vc3)
        
        /// 计算导航栏高度
        var barHeight = UIApplication.shared.statusBarFrame.height
        if let bar = navigationController?.navigationBar{
            barHeight+=bar.frame.height
        }
        
        /// 添加分页控制器 
        hoverPageViewController = HoverPageViewController(viewControllers: viewControllers, headerView: headerView, pageTitleView: pageTitleView)
        hoverPageViewController.delegate = self
        hoverPageViewController.view.frame = CGRect(x: 0, y: barHeight, width: view.frame.width, height: view.frame.height - barHeight)
        addChild(hoverPageViewController)
        view.addSubview(hoverPageViewController.view)
    }

    @objc func buttonClick(btn: UIButton) {
        hoverPageViewController.move(to: btn.tag, animated: true)
    }
}

extension ViewController:HoverPageViewControllerDelegate{
    
    func hoverPageViewController(_ viewController: HoverPageViewController, scrollViewDidScroll scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.frame.width
        indicator.frame.origin.x = ((indicator.frame.width + (indicatorMargin * 2)) * progress) + indicatorMargin
    }
}

```
### 子控制器
```swift
class Children1ViewController: HoverChildViewController {

    private var tableView:UITableView!
    private lazy var items: [String] = {
        var items = [String]()
        for i in 0..<100 {
            items.append("\(i)")
        }
        return items
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "aaaa")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    override var offsetY: CGFloat{
        set{
            tableView.contentOffset = CGPoint(x: 0, y: newValue)
        }
        get{
            return tableView.contentOffset.y
        }
    }
    
    override var isCanScroll: Bool{
        didSet{
            if isCanScroll{
                tableView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
            }
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
        scrollDelegate?.hoverChildViewController(self, scrollViewDidScroll: scrollView)
    }
}
```
