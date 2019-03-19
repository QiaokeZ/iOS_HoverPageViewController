//
//  HoverPageViewController.swift
//  HoverPageViewController <https://github.com/QiaokeZ/iOS_HoverPageViewController>
//
//  Created by admin on 2019/2/27
//  Copyright © 2019 zhouqiao. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import UIKit

protocol HoverChildViewControllerDelegate: NSObjectProtocol {
    func hoverChildViewController(_ viewController: HoverChildViewController, scrollViewDidScroll scrollView: UIScrollView)
}

protocol HoverPageViewControllerDelegate: NSObjectProtocol {
    func hoverPageViewController(_ viewController: HoverPageViewController, scrollViewDidScroll scrollView: UIScrollView)
}

class HoverChildViewController: UIViewController{
    public var offsetY: CGFloat = 0.0
    public var isCanScroll: Bool = false
    public weak var scrollDelegate:HoverChildViewControllerDelegate?
}

final class HoverPageScrollView: UIScrollView,UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class HoverPageViewController: UIViewController {
    
    weak var delegate:HoverPageViewControllerDelegate?
    private(set) var viewControllers = [HoverChildViewController]()
    private(set) var headerView: UIView!
    private(set) var pageTitleView: UIView!
    private var mainScrollView: HoverPageScrollView!
    private var pageScrollView: UIScrollView!
    private var currentIndex:Int = 0
    
    func move(to:Int, animated:Bool){
        viewControllers.forEach{$0.isCanScroll = true}
        pageScrollView.setContentOffset(CGPoint(x: CGFloat(to) * view.frame.width, y: 0), animated: animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.scrollViewDidEndDecelerating(self.pageScrollView)
        }
    }
    
    init(viewControllers: [HoverChildViewController],  headerView: UIView, pageTitleView: UIView) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        self.headerView = headerView
        self.pageTitleView = pageTitleView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainScrollView.frame = view.bounds
        mainScrollView.contentSize = CGSize(width: 0, height: mainScrollView.frame.height + headerView.frame.height)
        pageScrollView.frame.size = CGSize(width: view.frame.width, height: mainScrollView.contentSize.height - pageTitleView.frame.maxY)
        pageScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(viewControllers.count), height: 0)
    }
}

extension HoverPageViewController{
    
    private func prepareView(){
        mainScrollView = HoverPageScrollView()
        mainScrollView.delegate = self
        mainScrollView.bounces = false
        mainScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(mainScrollView)
        if #available(iOS 11.0, *) {
            mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false;
        };
        
        pageTitleView.frame.origin.y = headerView.frame.height
        mainScrollView.addSubview(headerView)
        mainScrollView.addSubview(pageTitleView)
        
        pageScrollView = UIScrollView()
        mainScrollView.showsVerticalScrollIndicator = false
        pageScrollView.frame.origin.y = pageTitleView.frame.maxY
        pageScrollView.isPagingEnabled = true
        pageScrollView.delegate = self
        mainScrollView.addSubview(pageScrollView)
        for i in 0..<viewControllers.count {
            let child = viewControllers[i]
            child.scrollDelegate = self
            child.view.frame.origin.x = CGFloat(i) * view.frame.width
            pageScrollView.addSubview(child.view)
            addChild(child)
        }
    }
}

extension HoverPageViewController:HoverChildViewControllerDelegate{
    
    func hoverChildViewController(_ viewController: HoverChildViewController, scrollViewDidScroll scrollView: UIScrollView) {
        if mainScrollView.contentOffset.y < headerView.frame.height, mainScrollView.contentOffset.y > 0{
            let vc = viewControllers[currentIndex];
            vc.offsetY = 0
        }
    }
}

extension HoverPageViewController:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageScrollView.isScrollEnabled = true
        mainScrollView.isScrollEnabled = true
        if scrollView == pageScrollView{
            currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5) % viewControllers.count
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView{
            pageScrollView.isScrollEnabled = false
            let vc = viewControllers[currentIndex];
            if vc.offsetY > 0 {
                scrollView.contentOffset = CGPoint(x: 0, y: headerView.frame.height)
            }else{
                viewControllers.forEach{$0.offsetY = 0}
            }
        }
        if scrollView == pageScrollView{
            mainScrollView.isScrollEnabled = false
            delegate?.hoverPageViewController(self, scrollViewDidScroll: scrollView)
        }
    }
}

