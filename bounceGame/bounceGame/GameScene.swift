//
//  GameScene.swift
//  bounceGame
//
//  Created by 翁培钧 on 2019/12/22.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    private var balls = [Ball]()
    private var contactGroundBalls = [Ball]()
    
    
    private var isBegin = false
    
    
    private var ground = SKSpriteNode()
    private var firstDownBall: Ball?
    
    
    
    
    override init(size: CGSize) {
        super.init(size: size)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        physicsWorld.contactDelegate = self
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
        ground = SKSpriteNode(color: .gray, size: CGSize(width: size.width, height: 120))
        ground.position = CGPoint(x: size.width / 2, y: ground.size.height / 2)
        addChild(ground)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.collisionBitMask = BitMask.Ball
        ground.physicsBody?.categoryBitMask = BitMask.Ground
        ground.physicsBody?.contactTestBitMask = BitMask.Ball
        
        let wall = SKNode()
        wall.position = CGPoint(x: 0, y: 0)
        wall.physicsBody?.friction = 0
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.restitution = 1.0
        wall.physicsBody?.collisionBitMask = BitMask.Wall
        wall.physicsBody?.categoryBitMask = BitMask.Wall
        wall.physicsBody?.contactTestBitMask = BitMask.Wall
        wall.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        addChild(wall)
        
        for _ in 0..<5 {
            let ball = Ball(circleOfRadius: 10)
            balls.append(ball)
            addChild(ball)
            ball.physicsBody?.isDynamic = false
            ball.position = CGPoint(x: size.width / 2, y: ground.frame.size.height + ball.frame.size.height / 2)
        }
        
        for row in 1...5 {
            let box = Box(rectOf: CGSize(width: 50, height: 50))
            box.position = CGPoint(x: 50 + (row * 50 + 20), y: (800 - row * 50 + 20))
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
            box.physicsBody?.categoryBitMask = BitMask.Box
            box.physicsBody?.contactTestBitMask = BitMask.Ball
            box.physicsBody?.collisionBitMask = BitMask.Box
            box.physicsBody?.linearDamping = 0
            box.physicsBody?.restitution = 1.0
            box.physicsBody?.isDynamic = false
            box.fillColor = .red
            
            let label = Label(text: "\(row)")
            label.fontSize = 22
            label.typoTag = 666
            label.fontName = "Arial-BoldMT"
            label.color = .white
            label.position = CGPoint(x: 0, y: -label.frame.size.height / 2)
            box.addChild(label)
            
            addChild(box)
        }
    }
}

extension GameScene {
    private func shot() {
        for (index, ball) in balls.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(index)) {
                ball.physicsBody?.isDynamic = true
                if (!self.children.contains(ball)) {
                    self.addChild(ball)
                }
                ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
                ball.physicsBody?.applyTorque(1.8)
//                ball.physicsBody?.applyForce(CGVector(dx: 400 + CGFloat(index) * 0.1, dy: 800))
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                    ball.isShot = true
                    
                    if (index == self.balls.count - 1) {
                        self.firstDownBall?.removeFromParent()
                        self.firstDownBall = nil
                    }
                }
            }
        }
    }
}

extension GameScene {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        shot()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        print("\(contact.bodyA.contactTestBitMask) == \(contact.bodyB.contactTestBitMask)")
        
        
        
        switch contact.bodyA.categoryBitMask {
        case BitMask.Box:
            checkNodeIsBox(contact.bodyA.node)
            checkNodeIsWall(contact.bodyB.node)
        case BitMask.Wall:
            checkNodeIsWall(contact.bodyB.node)
        case BitMask.Ground:
            checkNodeIsGround(contact.bodyB.node)
        default:
            break
        }
        
        switch contact.bodyB.categoryBitMask {
        case BitMask.Box:
            checkNodeIsBox(contact.bodyB.node)
            checkNodeIsWall(contact.bodyA.node)
        case BitMask.Wall:
            checkNodeIsWall(contact.bodyA.node)
        case BitMask.Ground:
            checkNodeIsGround(contact.bodyA.node)
        default:
            break
        }
    }
}

extension GameScene {
    private func checkNodeIsBox(_ node: SKNode?) {
        guard let box = node else { return }
        
        if box.physicsBody?.categoryBitMask == BitMask.Box {
            let label = box.children.first! as! Label
            var tag = Int(label.text!)!
            if (tag > 1) {
                tag -= 1
                label.text = "\(tag)"
            } else {
                box.removeFromParent()
            }
        }
    }
    
    private func checkNodeIsWall(_ node: SKNode?) {
        guard let ball = node as? Ball else { return }
           
        ball.isShot = true
    }
    
    private func checkNodeIsGround(_ node: SKNode?) {
        guard let ball = node as? Ball else { return }
        
        // NOTE: 小球 & 发射出去
        if (ball.physicsBody?.categoryBitMask == BitMask.Ball && ball.isShot) {
            ball.removeFromParent();
            
            // NOTE: 定位小球不存在 || 当前 Scene 中不包含定位小球
            if (firstDownBall == nil || !children.contains(firstDownBall!)) {
                firstDownBall = Ball(circleOfRadius: 10)
                firstDownBall!.position = CGPoint(x: ball.position.x, y: ground.frame.size.height + ball.frame.size.height / 2 - 2)
                addChild(firstDownBall!)
                // NOTE: 静止
                firstDownBall!.physicsBody?.isDynamic = false
            }
        
            // NOTE: 统一重设后续触底小球位置。二次发射时，直接读取各个小球的初始位置进行发射
            ball.position = CGPoint(x: firstDownBall!.position.x, y: ground.frame.size.height + ball.frame.size.height / 2)
        }
    }
}

