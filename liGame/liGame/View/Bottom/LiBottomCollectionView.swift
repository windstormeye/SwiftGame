//
//  LiBottomCollectionView.swift
//  liGame
//
//  Created by pjhubs on 2019/9/8.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit

class LiBottomCollectionView: UICollectionView {

    let cellIdentifier = "PJLineCollectionViewCell"
    
    var viewDelegate: LiBottomCollectionViewDelegate?
    var viewModelIndexs: [Int]?
    var viewModels: [Puzzle]? { didSet { reloadData() }}
    var currentCellIndex: Int?
    var longPressView: UIView?
    
    var moveCell: ((Int, CGPoint) -> Void)?
    var moveBegin: ((Int) -> Void)?
    var moveEnd: (() -> Void)?
    
    
    override init(frame: CGRect,
                  collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame,
                   collectionViewLayout: layout)
        initView()
    }
    
    convenience init(frame: CGRect,
                     collectionViewLayout layout: UICollectionViewLayout,
                     longPressView: UIView?) {
        self.init(frame: frame,
                  collectionViewLayout: layout)
        self.longPressView = longPressView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        
        delegate = self
        dataSource = self
        
        let longPress = UILongPressGestureRecognizer(target: self,
                                                     action: .longPress)
        addGestureRecognizer(longPress)
        
        register(LiBottomCollectionViewCell.self,
                 forCellWithReuseIdentifier: "LiBottomCollectionViewCell")
    }
    
    // MARK: Actions
    @objc
    fileprivate func cellLongPress(longPressGesture: UILongPressGestureRecognizer) {
        switch longPressGesture.state {
        case .began:
            let cellIndexPath = self.indexPathForItem(at: longPressGesture.location(in: self))
            if cellIndexPath != nil {
                currentCellIndex = cellIndexPath!.row
                moveBegin?(currentCellIndex!)
                
                viewModelIndexs!.remove(at: currentCellIndex!)
            }
            
        case .changed:
            guard let currentCellIndex = currentCellIndex else { return }
            guard let longPressView = longPressView else { return }
            
            moveCell?(currentCellIndex,
                      longPressGesture.location(in: longPressView))
            
        case .ended:
            viewModels!.remove(at: currentCellIndex!)
            reloadData()
            moveEnd?()
            
        default: break
        }
    }
}

extension LiBottomCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension LiBottomCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let viewModels = viewModels else { return 0 }
        
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiBottomCollectionViewCell",
                                                      for: indexPath) as! LiBottomCollectionViewCell
        cell.clearSubView()
        cell.index = viewModelIndexs![indexPath.row]
        cell.viewModel = viewModels![indexPath.row]
        return cell
    }
}


fileprivate extension Selector {
    static let longPress = #selector(LiBottomCollectionView.cellLongPress(longPressGesture:))
}

protocol LiBottomCollectionViewDelegate {
    func collectionViewCellLongPress(_ cellIndex: Int)
}

extension LiBottomCollectionViewDelegate {
    func collectionViewCellLongPress(_ cellIndex: Int) {}
}




