//
//  UIImage+Extension.swift
//  liGame
//
//  Created by 翁培钧 on 2019/9/6.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit

extension UIImage {
    /// 通过原图获取 rect 大小的图片
    func image(with rect: CGRect) -> UIImage {
        let scale: CGFloat = 2
        let x = rect.origin.x * scale
        let y = rect.origin.y * scale
        let w = rect.size.width * scale
        let h = rect.size.height * scale
        let finalRect = CGRect(x: x, y: y, width: w, height: h)
        
        let originImageRef = self.cgImage
        let finanImageRef = originImageRef!.cropping(to: finalRect)
        let finanImage = UIImage(cgImage: finanImageRef!, scale: scale, orientation: .up)
        
        return finanImage
    }
}
