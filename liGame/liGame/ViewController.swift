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
    private var bottomView = LiBottomView()
    
    private var puzzles = [Puzzle]()
    private var copyPuzzles = [Puzzle]()
    
    private var tempCopyPuzzle: Puzzle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgColor
        
        
        // 底图适配
        let contentImage = UIImage(named: "01")!
        let contentImageScale = view.width / contentImage.size.width
        let contentImageViewHeight = contentImage.size.height * contentImageScale
        
        let contentImageView = UIImageView(frame: CGRect(x: 0, y: topSafeAreaHeight, width: view.width, height: contentImageViewHeight))
        contentImageView.image = contentImage
        
        let imgView = UIImageView(frame: CGRect(x: view.width / 2, y: topSafeAreaHeight, width: 5, height: view.height - bottomSafeAreaHeight))
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
        
        // 一行六个
        let itemHCount = 6
        let itemW = Int(view.width / CGFloat(itemHCount))
        let itemVCount = Int(contentImageView.height / CGFloat(itemW))
        
        for itemY in 0..<itemVCount {
            for itemX in 0..<itemHCount {
                let x = itemW * itemX
                let y = itemW * itemY
                
                let img = contentImageView.image!.image(with: CGRect(x: x, y: y, width: itemW, height: itemW))
                let puzzle = Puzzle(size: CGSize(width: itemW, height: itemW), isCopy: false)
                puzzle.image = img
                puzzle.tag = (itemY * itemHCount) + itemX
                puzzles.append(puzzle)
            }
        }
        
        for i in 1..<puzzles.count {
            let index = Int(arc4random()) % i
            if index != i {
                puzzles.swapAt(i, index)
            }
        }
        
        
        let bottomView = LiBottomView(frame: CGRect(x: 0, y: view.height, width: view.width, height: 64 + bottomSafeAreaHeight), longPressView: view)
        view.addSubview(bottomView)
        bottomView.viewModels = puzzles
        self.bottomView = bottomView
        
        bottomView.moveBegin = {
            self.tempCopyPuzzle = Puzzle(size: $0.frame.size, isCopy: true)
            self.tempCopyPuzzle?.image = $0.image
            self.tempCopyPuzzle?.tag = $0.tag
            self.view.addSubview(self.tempCopyPuzzle!)
        }
        
        bottomView.moveChanged = {
            guard let tempPuzzle = self.tempCopyPuzzle else { return }
            
            // 超出底部功能栏位置后才显示
            if $0.y < self.bottomView.top {
                tempPuzzle.center = CGPoint(x: self.view.width - $0.x, y: $0.y)
            }
            
        }
        
        bottomView.moveEnd = {
            guard let tempPuzzle = self.tempCopyPuzzle else { return }
            tempPuzzle.removeFromSuperview()
            
            let copyPuzzle = Puzzle(size: $0.frame.size, isCopy: true)
            copyPuzzle.center = tempPuzzle.center
            copyPuzzle.image = tempPuzzle.image
            self.view.addSubview(copyPuzzle)
            self.copyPuzzles.append(copyPuzzle)
        }
        
        
        UIView.animate(withDuration: 0.25, delay: 0.5, options: .curveEaseIn, animations: {
            bottomView.bottom = self.view.height
        })
        
    }
}

