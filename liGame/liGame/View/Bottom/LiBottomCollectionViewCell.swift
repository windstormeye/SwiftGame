//
//  LiBottomCollectionViewCell.swift
//  liGame
//
//  Created by pjhubs on 2019/9/8.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit

class LiBottomCollectionViewCell: UICollectionViewCell {
    var viewModel: UIImage? {
        didSet { setViewModel() }
    }
    var index: Int?
    
    private func setViewModel() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 1
        
        let img = UIImageView(image: viewModel)
        img.contentMode = .scaleAspectFit
        img.frame = CGRect(x: 0, y: 0, width: width, height: height)
        addSubview(img)
        
        if index != nil {
            let indexLabel = UILabel(frame: CGRect(x: width - 10, y: -5, width: 22.5, height: 22.5))
            addSubview(indexLabel)
            indexLabel.text = "\(index!)"
            indexLabel.textAlignment = .center
            indexLabel.textColor = .white
            indexLabel.font = UIFont.systemFont(ofSize: 15)
            indexLabel.backgroundColor = .darkGray
            indexLabel.layer.cornerRadius = indexLabel.width / 2
            indexLabel.layer.masksToBounds = true
        }
    }
    
    func clearSubView() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}
