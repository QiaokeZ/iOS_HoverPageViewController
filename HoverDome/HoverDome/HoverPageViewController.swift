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

class HoverContainerViewController: UIViewController {

    public var offsetY: CGFloat = 0.0
    public var isStopScroll: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

protocol HoverPageViewControllerDelegate: NSObjectProtocol {
    func hoverPageViewController(_ viewController: HoverPageViewController,  scrollViewDidScroll:UIScrollView)
}

final class HoverPageViewController: UIViewController {

    static let HoverPageViewOffsetChange = "HoverPageViewOffsetChange"
    static let OffsetKey = "OffsetKey"

    weak var delegate:HoverPageViewControllerDelegate?
    private(set) var viewControllers = [HoverContainerViewController]()
    private(set) var headerView: UIView!
    private(set) var pageTitleView: UIView!

    private var offset: CGPoint = .zero
    private var scrollView: UIScrollView!

    var selectedIndex: Int = 0 {
        willSet {
            if newValue != selectedIndex {
                for child in viewControllers {
                    child.isStopScroll = true
                }
                scrollView.setContentOffset(CGPoint(x: CGFloat(newValue) * view.frame.width, y: 0), animated: true)
            }
        }
    }

    init(viewControllers: [HoverContainerViewController], selectedIndex: Int = 0, headerView: UIView, pageTitleView: UIView) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        self.selectedIndex = selectedIndex
        self.headerView = headerView
        self.pageTitleView = pageTitleView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()

        NotificationCenter.default.addObserver(self,
            selector: #selector(HoverPageViewController.pageViewControllerOffsetYChange),
            name: NSNotification.Name(rawValue: HoverPageViewController.HoverPageViewOffsetChange),
            object: nil)
    }
}

extension HoverPageViewController {

    private func prepareView() {
        scrollView = UIScrollView()
        scrollView.frame.origin.y = pageTitleView.frame.height
        scrollView.frame.size = CGSize(width: view.frame.width, height: view.frame.height - pageTitleView.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(viewControllers.count), height: 0)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self

        for i in 0..<viewControllers.count {
            let child = viewControllers[i]
            child.view.frame.origin.x = CGFloat(i) * view.frame.width
            scrollView.addSubview(child.view)
            addChild(child)
        }

        view.addSubview(scrollView)
        view.addSubview(headerView)

        offset = CGPoint(x: 0, y: -headerView.frame.height)
        pageTitleView.frame.origin.y = headerView.frame.maxY
        view.addSubview(pageTitleView)
    }

    @objc private func pageViewControllerOffsetYChange(notification: Notification) {
        if let info = notification.userInfo,
            let value = info[HoverPageViewController.OffsetKey] as? CGPoint {
            offset.y = value.y
            headerView.frame.origin.y = -(offset.y + headerView.frame.height)
            if offset.y >= 0 {
                pageTitleView.frame.origin.y = 0
            } else {
                pageTitleView.frame.origin.y = -offset.y
            }
        }
    }
}

extension HoverPageViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectedIndex = Int(scrollView.contentOffset.x / scrollView.frame.width + 0.5) % viewControllers.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.hoverPageViewController(self, scrollViewDidScroll: scrollView)
        for child in viewControllers {
            if offset.y >= 0 {
                if child.offsetY < 0 {
                    child.offsetY = 0
                }
            } else {
                child.offsetY = offset.y
            }
        }
    }
}

