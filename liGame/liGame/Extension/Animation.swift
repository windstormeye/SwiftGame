//
//  Animation.swift
//  WWDC19
//
//  Created by PJHubs on 2019/3/20.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

protocol PJParticleAnimationable {}

extension PJParticleAnimationable where Self: UIViewController {
    func startParticleAnimation(_ point : CGPoint) {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = point
        emitter.preservesDepth = true
        
        var cells = [CAEmitterCell]()
        for i in 0..<20 {
            let cell = CAEmitterCell()
            cell.velocity = 150
            cell.velocityRange = 100
            cell.scale = 0.7
            cell.scaleRange = 0.3
            cell.emissionLongitude = CGFloat(-Double.pi / 2)
            cell.emissionRange = CGFloat(Double.pi / 2)
            cell.lifetime = 3
            cell.lifetimeRange = 1.5
            cell.spin = CGFloat(Double.pi / 2)
            cell.spinRange = CGFloat(Double.pi / 2 / 2)
            cell.birthRate = 2
            cell.contents = UIImage(named: "Line\(i)")?.cgImage
            
            cells.append(cell)
        }
        emitter.emitterCells = cells
        view.layer.addSublayer(emitter)
    }

    func stopParticleAnimation() {
        view.layer.sublayers?.filter({ $0.isKind(of: CAEmitterLayer.self)}).first?.removeFromSuperlayer()
    }
}

