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
    private var puzzles = [Puzzle]()
    private var bottomView = LiBottomView()
    
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
        
        
        // 底图适配
        let contentImage = UIImage(named: "01")!
        let contentImageScale = view.width / contentImage.size.width
        let contentImageViewHeight = contentImage.size.height * contentImageScale
        
        let contentImageView = UIImageView(frame: CGRect(x: 0, y: topSafeAreaHeight, width: view.width, height: contentImageViewHeight))
        contentImageView.image = contentImage
        
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
                print(puzzle.tag)
                
                puzzles.append(puzzle)
                view.addSubview(puzzle)
            }
        }
        
        
        
        let bottomView = LiBottomView(height: 64, longPressView: view)
        view.addSubview(bottomView)
        self.bottomView = bottomView
        bottomView.isHidden = true
        bottomView.layer.opacity = 0
        
        UIView.animate(withDuration: 2) {
            bottomView.isHidden = false
            bottomView.layer.opacity = 1
        }
        
        bottomView.collectionView?.viewModelIndexs = imgIndexs
        bottomView.viewModel = puzzles
        bottomView.moveCell = { cellIndex, centerPoint in
            guard let tempItem = contentView.tempItem else { return }
            tempItem.center = CGPoint(x: centerPoint.x,
                                      y: centerPoint.y + bottomView.top)
        }
        bottomView.moveBegin = { cellIndex in
            guard contentView.itemXCount != nil else { return }
            
            let itemW = contentView.itemW
            // 刚开始的初始化先让其消失
            let moveItem = PJShowItem(frame: CGRect(x: -1000, y: -1000,
                                                    width: itemW!, height: itemW!))
            moveItem.gameType = self.gameType
            moveItem.endTop = contentView.endTop
            moveItem.endBottom = contentView.endBottom
            if self.gameType == .guide {
                moveItem.endBottom = screenHeight - 40
            }
            moveItem.endLeft = contentView.endLeft
            moveItem.endRight = contentView.endRight
            moveItem.bgImage = bottomView.viewModel![cellIndex]
            moveItem.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            moveItem.tag = bottomView.collectionView!.viewModelIndexs![cellIndex] + 1
            
            
            if [28, 29, 30].contains(moveItem.tag) {
                moveItem.isBottomItem = true
            }
            
            contentView.addSubview(moveItem)
            contentView.tempItem = moveItem
        }
        
        bottomView.moveEnd = {
            guard let tempItem = contentView.tempItem else { return }
            tempItem.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}

