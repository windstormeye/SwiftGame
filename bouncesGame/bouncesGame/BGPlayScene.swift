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
//        let sprite = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
//        sprite.position = CGPoint(x: 100, y: 100)
//        addChild(sprite)
        
        
        let topSky = SKSpriteNode(color: .red, size: CGSize(width: frame.width , height: 0.67 * frame.height))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        topSky.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
        
        addChild(topSky)
    }
}
