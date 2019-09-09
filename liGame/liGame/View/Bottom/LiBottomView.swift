//
//  LiBottomView.swift
//  liGame
//
//  Created by pjhubs on 2019/9/8.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit

class LiBottomView: UIView {
    var viewModel: [Puzzle]? {
        didSet { collectionView?.viewModels = viewModel! }
    }
    var moveCell: ((Int, CGPoint) -> Void)?
    var moveBegin: ((Int) -> Void)?
    var moveEnd: (() -> Void)?
    var collectionView: LiBottomCollectionView?
    var longPressView: UIView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, longPressView: UIView?) {
        self.init(frame: frame)
        self.longPressView = self
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        backgroundColor = .clear
        isUserInteractionEnabled = true
        
        let effect = UIBlurEffect(style: .extraLight)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        addSubview(effectView)
        
        insertRoundingCorners()
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = 50
        let innerW = (screenWidth - 5 * 50) / 5
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        collectionViewLayout.minimumLineSpacing = innerW
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = UIEdgeInsets.init(top: 0, left: innerW / 2, bottom: 0, right: innerW / 2)
        
        
        collectionView = LiBottomCollectionView(frame: CGRect(x: 0, y: 0, width: width, height: height), collectionViewLayout: collectionViewLayout)
//        collectionView!.viewDelegate = self
        addSubview(collectionView!)
        
//        collectionView!.moveCell = { [weak self] cellIndex, centerPoint in
//            guard let self = `self` else { return }
//            self.moveCell?(cellIndex, centerPoint)
//        }
//
//        collectionView?.moveBegin = { [weak self] cellIndex in
//            guard let self = `self` else { return }
//            self.moveBegin?(cellIndex)
//        }
//
//        collectionView?.moveEnd = { [weak self] in
//            guard let self = `self` else { return }
//            self.moveEnd?()
//            self.viewModel = self.collectionView?.viewModels
//        }
    }
}


//extension LiBottomView: LiBottomCollectionViewDelegate {
//    func collectionViewCellLongPress(_ cellIndex: Int) {
//
//    }
//}
