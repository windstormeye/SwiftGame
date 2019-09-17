//
//  LiBottomCollectionView.swift
//  liGame
//
//  Created by pjhubs on 2019/9/8.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit

class LiBottomCollectionView: UICollectionView {

    var longTapBegan: ((Puzzle, CGPoint) -> ())?
    var longTapChange: ((CGPoint) -> ())?
    var longTapEnded: ((Puzzle) -> ())?
    

    let cellIdentifier = "PJLineCollectionViewCell"
    var viewModels = [Puzzle]()

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
//        isUserInteractionEnabled = true
        dataSource = self
        
        register(LiBottomCollectionViewCell.self, forCellWithReuseIdentifier: "LiBottomCollectionViewCell")
    }
}

extension LiBottomCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiBottomCollectionViewCell", for: indexPath) as! LiBottomCollectionViewCell
        cell.cellIndex = indexPath.row
        cell.gameIndex = viewModels[indexPath.row].tag
        cell.viewModel = viewModels[indexPath.row]
        cell.longTapBegan = { [weak self] index in
            guard let self = self else { return }
            guard self.viewModels.count != 0 else { return }
            self.longTapBegan?(self.viewModels[index], cell.center)
        }
        cell.longTapChange = {
            self.longTapChange?($0)
        }
        cell.longTapEnded = {
            self.longTapEnded?(self.viewModels[$0])
            self.viewModels.remove(at: $0)
            self.reloadData()
        }
        
        return cell
    }
}
