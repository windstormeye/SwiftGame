//
//  LiBottomView.swift
//  liGame
//
//  Created by pjhubs on 2019/9/8.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit

class LiBottomView: UIView {
    var viewModels = [Puzzle]() {
        didSet { collectionView!.viewModels = viewModels }
    }
    
    var moveCell: ((Int, CGPoint) -> Void)?
    var moveBegin: ((Int) -> Void)?
    var moveEnd: (() -> Void)?
    
    var tempPuzzle: Puzzle?
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
        addSubview(collectionView!)
        collectionView!.longTapBegan = {
            let center = $1
            let tempPuzzle = Puzzle(size: $0.frame.size, isCopy: false)
            tempPuzzle.image = $0.image
            tempPuzzle.center = center
            tempPuzzle.y += self.top
            self.tempPuzzle = tempPuzzle
            
            self.superview!.addSubview(tempPuzzle)
        }
        collectionView!.longTapChange = {
            guard let tempPuzzle = self.tempPuzzle else { return }
            
            tempPuzzle.center = CGPoint(x: $0.x, y: $0.y + self.top)
        }
    }
}

extension LiBottomView {
    @objc
    fileprivate func pan(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: superview)
        panGesture.view!.center = CGPoint(x: panGesture.view!.center.x + translation.x,
                                          y: panGesture.view!.center.y + translation.y)
        panGesture.setTranslation(.zero, in: superview)
    }
}

private extension Selector {
    static let pan = #selector(LiBottomView.pan(_:))
}


//extension LiBottomView: LiBottomCollectionViewDelegate {
//    func collectionViewCellLongPress(_ cellIndex: Int) {
//
//    }
//}