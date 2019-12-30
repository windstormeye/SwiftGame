//
//  GameViewController.swift
//  bounceGame
//
//  Created by 翁培钧 on 2019/12/22.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            let scene = GameScene(size: view.frame.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
