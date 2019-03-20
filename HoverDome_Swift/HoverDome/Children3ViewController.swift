//
//  Children3ViewController.swift
//  HoverDome
//
//  Created by admin on 2019/2/27.
//  Copyright © 2019 zhouqiao. All rights reserved.
//

import UIKit

class Children3ViewController: HoverChildViewController {

    private var collectionView:UICollectionView!
    private lazy var items: [String] = {
        var items = [String]()
        for i in 0..<100 {
            items.append("\(i)")
        }
        return items
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "aaa")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    override var offsetY: CGFloat{
        set{
            collectionView.contentOffset = CGPoint(x: 0, y: newValue)
        }
        get{
            return collectionView.contentOffset.y
        }
    }
    
    override var isCanScroll: Bool{
        didSet{
            if isCanScroll{
                collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
            }
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
        scrollDelegate?.hoverChildViewController(self, scrollViewDidScroll: scrollView)
    }
}
