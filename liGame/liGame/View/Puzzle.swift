//
//  Puzzle.swift
//  liGame
//
//  Created by 翁培钧 on 2019/9/6.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit

class Puzzle: UIImageView {

    var longTapBegan: ((Int) -> ())?
    var longTapChange: ((CGPoint) -> ())?
    var longTapEnded: ((Int) -> ())?
    
    /// 是否为「拷贝」拼图元素
    private var isCopy = false
    private var rightPoint: CGFloat = 0
    private var leftaPoint: CGFloat = 0
    private var topPoint: CGFloat = 0
    private var bottomPoint: CGFloat = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(size: CGSize, isCopy: Bool) {
        self.init(frame: CGRect(x: -1000, y: -1000, width: size.width, height: size.height))
        self.isCopy = isCopy
        
        initView()
    }
    
    
    // MARK: Init
    
    private func initView() {
        contentMode = .scaleAspectFit
        
        if !isCopy {
            isUserInteractionEnabled = true
            
            let panGesture = UILongPressGestureRecognizer(target: self, action: .longTap)
            self.addGestureRecognizer(panGesture)
        } else {
            transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    
    func updateEdge() {
        if superview != nil {
            if !isCopy {
                topPoint = topSafeAreaHeight
                bottomPoint = superview!.bottom - bottomSafeAreaHeight
                rightPoint = superview!.width / 2
                leftaPoint = 0
            }
        } else {
            if superview != nil {
                topPoint = superview!.top
                bottomPoint = superview!.bottom
                rightPoint = superview!.width
                leftaPoint = superview!.width / 2
            }
        }
    }
    
}


extension Puzzle {
    @objc
    fileprivate func longTap(_ longTapGesture: UILongPressGestureRecognizer) {
        
        switch longTapGesture.state {
        case .began:
            longTapBegan?(tag)
        case .changed:
            var translation = longTapGesture.location(in: superview)
            
            let itemCount = 5
            if tag > itemCount {
                translation.x = translation.x - CGFloat(tag / itemCount * Int(screenWidth))
            }
            
            let point = CGPoint(x: translation.x, y: translation.y)
            longTapChange?(point)
        case .ended:
            longTapEnded?(tag)
        default: break
        }
        
        
//        let translation = panGesture.translation(in: superview)
//
//        switch panGesture.state {
//        case .began:
//            layer.borderColor = UIColor.white.cgColor
//            layer.borderWidth = 1
//        case .changed:
//            if right > rightPoint {
//                right = rightPoint
//            }
//            if left < leftaPoint {
//                left = leftaPoint
//            }
//            if top < topPoint {
//                top = topPoint
//            }
//            if bottom > bottomPoint {
//                bottom = bottomPoint
//            }
//
//        case .ended:
//            layer.borderWidth = 0
//        default: break
//        }
//
//        center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
//        panGesture.setTranslation(.zero, in: superview)
    }
}

private extension Selector {
    static let longTap = #selector(Puzzle.longTap(_:))
}
