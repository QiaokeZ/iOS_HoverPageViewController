//
//  Children1ViewController.swift
//  HoverDome
//
//  Created by admin on 2019/2/27.
//  Copyright © 2019 zhouqiao. All rights reserved.
//

import UIKit

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
        offsetY = -ViewController.headerViewHeight
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
            if isStopScroll == true{
                tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y), animated: false)
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: HoverPageViewController.HoverPageViewOffsetChange),
                                        object: self,
                                        userInfo: [HoverPageViewController.OffsetKey: scrollView.contentOffset])
        offsetY = scrollView.contentOffset.y
    }
}
