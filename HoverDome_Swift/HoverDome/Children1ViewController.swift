//
//  Children1ViewController.swift
//  HoverDome
//
//  Created by admin on 2019/2/27.
//  Copyright © 2019 zhouqiao. All rights reserved.
//

import UIKit

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
        scrollView = tableView
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
        let vc = UIViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.hoverChildViewController(self, scrollViewDidScroll: scrollView)
    }
}
