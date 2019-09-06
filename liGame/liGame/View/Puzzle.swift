//
//  Puzzle.swift
//  liGame
//
//  Created by 翁培钧 on 2019/9/6.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit

class Puzzle: UIView {

    /// 是否为「拷贝」拼图元素
    private var isCopy = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, isCopy: Bool) {
        self.init(frame: frame)
        self.isCopy = isCopy
        
        initView()
    }
    
    // MARK: Init
    
    private func initView() {
        backgroundColor = .red
        isUserInteractionEnabled = true
        
        if !isCopy {
            let panGesture = UIPanGestureRecognizer(target: self, action: .pan)
            self.addGestureRecognizer(panGesture)
        }
    }

}


extension Puzzle {
    @objc
    fileprivate func pan(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: superview)
        center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
        panGesture.setTranslation(.zero, in: superview)
    }
}

private extension Selector {
    static let pan = #selector(Puzzle.pan(_:))
}
