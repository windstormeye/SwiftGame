//
//  ViewController.swift
//  liGame
//
//  Created by 翁培钧 on 2019/9/4.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var lineImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgColor
        
        let imgView = UIImageView(frame: CGRect(x: view.width / 2, y: topSafeAreaHeight, width: 5, height: view.height - topSafeAreaHeight - bottomSafeAreaHeight))
        view.addSubview(imgView)
        UIGraphicsBeginImageContext(imgView.frame.size) // 位图上下文绘制区域
        imgView.image?.draw(in: imgView.bounds)
        lineImageView = imgView
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setLineCap(CGLineCap.square)
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(3)
        context.setLineDash(phase: 0, lengths: [10,20])
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: 0, y: view.height))
        context.strokePath()
        
        imgView.image = UIGraphicsGetImageFromCurrentImageContext()
    }


}

