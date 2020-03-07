//
//  Ball.swift
//  bounceGame
//
//  Created by 翁培钧 on 2019/12/29.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import SpriteKit

class Ball: SKShapeNode {
    var isShot = false
    
    
    override init() {
        super.init()
        
        initObject()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initObject() {
        self.fillColor = .red
        self.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        self.physicsBody?.categoryBitMask = BitMask.Ball
        self.physicsBody?.contactTestBitMask = BitMask.Box | BitMask.Ground
        self.physicsBody?.collisionBitMask = BitMask.Box
        self.physicsBody?.usesPreciseCollisionDetection = true;
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.restitution = 1.0
    }
}
