//
//  UIViewController+Ex.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// 添加一个全屏的子视图控制器
    ///
    /// - Parameter child: 要添加的子视图控制器
    public func addFullScreen(childViewController child: UIViewController) {
        guard child.parent == nil else {
            return
        }
        
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: child.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: child.view.trailingAnchor),
            view.topAnchor.constraint(equalTo: child.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: child.view.bottomAnchor)
        ].compactMap { $0 })
        
        child.didMove(toParent: self)
    }

    /// 移除子视图控制器的视图
    ///
    /// - Parameter child: 要移除的子视图控制器
    public func remove(childViewController child: UIViewController) {
        guard child.parent != nil else { return }
        
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
