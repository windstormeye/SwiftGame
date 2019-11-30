//
//  ViewController.swift
//  bouncesGame
//
//  Created by 翁培钧 on 2019/11/20.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit
import SpriteKit
import GameController

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        playView.presentScene(BGPlayScene())
        
        for gcController in GCController.controllers() {
            gcController.extendedGamepad.bu
        }
    }
    
    lazy var playView: BGPlayView = {
        var pv = BGPlayView()
        pv.frame = self.view.frame
        pv.showsDrawCount = true
        pv.showsFPS = true
        pv.showsNodeCount = true
        
        view.addSubview(pv)
        return pv
    }()
}

