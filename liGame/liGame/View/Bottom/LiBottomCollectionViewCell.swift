//
//  LiBottomCollectionViewCell.swift
//  liGame
//
//  Created by pjhubs on 2019/9/8.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit

class LiBottomCollectionViewCell: UICollectionViewCell {
    var img = UIImageView()
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViewModel() {
        img.contentMode = .scaleAspectFit
        img.image = viewModel?.image
        img.frame = CGRect(x: 0, y: 0, width: width, height: height)
        if !subviews.contains(img) {
            addSubview(img)
        }
    }
}
