//
//  BGPlayScene.swift
//  bouncesGame
//
//  Created by 翁培钧 on 2019/11/25.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import SpriteKit

class BGPlayScene: SKScene {
    var contentCreated = false
    
    override func didMove(to view: SKView) {
        if !contentCreated {
            createContent()
            contentCreated = true
        }
    }
    
    private func createContent() {
        backgroundColor = .blue
    }
}
