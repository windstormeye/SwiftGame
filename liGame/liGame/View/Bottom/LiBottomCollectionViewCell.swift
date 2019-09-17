//
//  LiBottomCollectionViewCell.swift
//  liGame
//
//  Created by pjhubs on 2019/9/8.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit

class LiBottomCollectionViewCell: UICollectionViewCell {
    var longTapBegan: ((Int) -> ())?
    var longTapChange: ((CGPoint) -> ())?
    var longTapEnded: ((Int) -> ())?
    
    var cellIndex: Int?
    var gameIndex: Int?
    
    private var img = UIImageView()
    private var tipLabel = UILabel()
    
    
    var viewModel: Puzzle? {
        didSet { setViewModel() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 1
        
        img.contentMode = .scaleAspectFit
        img.frame = CGRect(x: 0, y: 0, width: width, height: height)
        addSubview(img)

        
        tipLabel = UILabel(frame: CGRect(x: width - 10, y: top - 10, width: 17, height: 17))
        tipLabel.font = UIFont.systemFont(ofSize: 11)
        tipLabel.backgroundColor = UIColor.rgb(80, 80, 80)
        tipLabel.textColor = .white
        tipLabel.textAlignment = .center
        tipLabel.layer.cornerRadius = tipLabel.width / 2
        tipLabel.layer.masksToBounds = true
        addSubview(tipLabel)

        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: .longTap)
        addGestureRecognizer(longTapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViewModel() {
        img.image = viewModel?.image
        tipLabel.text = "\(gameIndex!)"
    }
}

extension LiBottomCollectionViewCell {
    @objc
    fileprivate func longTap(_ longTapGesture: UILongPressGestureRecognizer) {
        guard let cellIndex = cellIndex else { return }
        
        switch longTapGesture.state {
        case .began:
            longTapBegan?(cellIndex)
        case .changed:
            var translation = longTapGesture.location(in: superview)
            
            let itemCount = 5
            if cellIndex > itemCount {
                translation.x = translation.x - CGFloat(cellIndex / itemCount * Int(screenWidth))
            }
            
            let point = CGPoint(x: translation.x, y: translation.y)
            longTapChange?(point)
        case .ended:
            longTapEnded?(cellIndex)
        default: break
        }
    }
}

private extension Selector {
    static let longTap = #selector(LiBottomCollectionViewCell.longTap(_:))
}
