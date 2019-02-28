//
//  Children3ViewController.swift
//  HoverDome
//
//  Created by admin on 2019/2/27.
//  Copyright © 2019 zhouqiao. All rights reserved.
//

import UIKit

class Children3ViewController: HoverContainerViewController {

    private lazy var items: [String] = {
        var items = [String]()
        for i in 0..<100 {
            items.append("\(i)")
        }
        return items
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "aaa")
        collectionView.bounces = false
        collectionView.contentInset = UIEdgeInsets(top: ViewController.headerViewHeight, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        view.addSubview(collectionView)
    }

    override var offsetY: CGFloat {
        didSet {
            collectionView.contentOffset = CGPoint(x: 0, y: offsetY)
        }
    }

    override var isStopScroll: Bool {
        didSet {
            collectionView.setContentOffset(CGPoint(x: 0, y: collectionView.contentOffset.y), animated: false)
        }
    }
}

extension Children3ViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aaa", for: indexPath)
        cell.backgroundColor = UIColor.blue
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: HoverPageViewController.HoverPageViewOffsetChange), object: self, userInfo: [HoverPageViewController.OffsetKey: scrollView.contentOffset])
        offsetY = scrollView.contentOffset.y
    }
}
