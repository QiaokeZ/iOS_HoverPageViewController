//
//  ViewController.swift
//  HoverDome
//
//  Created by admin on 2019/2/27.
//  Copyright © 2019 zhouqiao. All rights reserved.
//

import UIKit

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
        let headerView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        headerView.contentSize = CGSize(width: view.frame.width * 4, height: 0)
        headerView.isPagingEnabled = true
        
        for i in 0..<4{
            let v = UILabel()
            v.text = "scrollView"
            v.textAlignment = .center
            v.backgroundColor = UIColor.random
            v.frame = CGRect(origin: CGPoint(x: CGFloat(i) * headerView.frame.width, y: 0), size: headerView.frame.size)
            headerView.addSubview(v)
        }
        
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
    
    func hoverPageViewController(_ viewController: HoverPageViewController, scrollViewDidEndDecelerating scrollView: UIScrollView)
    {
        
    }
    
}


extension UIColor {

    static var random: UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

