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

    var moveBegin: ((Puzzle) -> Void)?
    var moveChanged: ((CGPoint) -> Void)?
    var moveEnd: ((Puzzle) -> Void)?
    
    var tempPuzzle: Puzzle?
    var collectionView: LiBottomCollectionView?
    var longPressView: UIView?
    
    private var rightPoint: CGFloat = 0
    private var leftaPoint: CGFloat = 0
    private var topPoint: CGFloat = 0
    private var bottomPoint: CGFloat = 0
    
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
        
        topPoint = topSafeAreaHeight
        bottomPoint = screenHeight - bottomSafeAreaHeight
        rightPoint = screenWidth / 2
        leftaPoint = 0
        
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
            // 补上游戏索引 tag
            tempPuzzle.tag = $0.tag
            tempPuzzle.image = $0.image
            tempPuzzle.center = center
            tempPuzzle.y += self.top
            self.tempPuzzle = tempPuzzle
            
            self.moveBegin?(tempPuzzle)
        }
        collectionView!.longTapChange = {
            guard let tempPuzzle = self.tempPuzzle else { return }
            tempPuzzle.center = CGPoint(x: $0.x, y: $0.y + self.top)

            if tempPuzzle.right > self.rightPoint {
                tempPuzzle.right = self.rightPoint
            }
            if tempPuzzle.left < self.leftaPoint {
                tempPuzzle.left = self.leftaPoint
            }
            if tempPuzzle.top < self.topPoint {
                tempPuzzle.top = self.topPoint
            }
            if tempPuzzle.bottom > self.bottomPoint {
                tempPuzzle.bottom = self.bottomPoint
            }
            
            self.moveChanged?(tempPuzzle.center)
        }
        collectionView!.longTapEnded = {
            guard let tempPuzzle = self.tempPuzzle else { return }
            self.moveEnd?(tempPuzzle)
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
