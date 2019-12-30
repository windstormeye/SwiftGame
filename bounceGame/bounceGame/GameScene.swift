//
//  GameScene.swift
//  bounceGame
//
//  Created by 翁培钧 on 2019/12/22.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentCreated = false
    
    override func didMove(to view: SKView) {
        if !contentCreated {
            createContent()
            contentCreated = true
        }
    }
    
    private func createContent() {
        for _ in 0..<10 {
            let ball = SKShapeNode(circleOfRadius: 10)
            ball.fillColor = .red
            addChild(ball)
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
            ball.physicsBody?.velocity = CGVector(dx: 200, dy: 200)
            ball.position = CGPoint(x: size.width / 2, y: 400)
        }
        
        let ground = SKSpriteNode(color: .gray, size: CGSize(width: size.width, height: 200))
        ground.position = CGPoint(x: size.width / 2, y: ground.size.height / 2)
        addChild(ground)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        
        let wall = SKNode()
        wall.position = CGPoint(x: 0, y: 0)
        wall.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        addChild(wall)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

