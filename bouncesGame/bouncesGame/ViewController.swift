//
//  ViewController.swift
//  bouncesGame
//
//  Created by 翁培钧 on 2019/11/20.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var animator: UIDynamicAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: view)
        let redView = UIView(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
        redView.backgroundColor = .red
        view.addSubview(redView)
        let gravity = UIGravityBehavior(items: [redView])
        animator?.addBehavior(gravity)
        
        let collision = UICollisionBehavior(items: [redView])
        collision.translatesReferenceBoundsIntoBoundary = true
        self.animator?.addBehavior(collision)
        
//        collision.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
        
        let anchor = CGPoint(x: self.view.bounds.width / 2, y: 400)
        let attachment = UIAttachmentBehavior(item: redView, attachedToAnchor: anchor)
        self.animator?.addBehavior(attachment)
    }


}

