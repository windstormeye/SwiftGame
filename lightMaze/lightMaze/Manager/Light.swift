//
//  Light.swift
//  light-game
//
//  Created by pjhubs on 2019/8/29.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation
import SwiftUI

struct Light: Identifiable {
    var id: Int {
        return number
    }
    /// 开关状态
    var status = false
    
    var countStatus: Bool {
        return count != 0
    }
    
    var number = 0 //灯的序号
    
    var count = 0 {
        didSet {
            if count == 0 {
                currentSelectColor = .gray
            }
        }
    }
    
    mutating func canUpCase(redOrBlue: Bool) -> Bool {
        if currentSelectColor != .gray {
            if currentSelectColor == .red && redOrBlue {
                return false
            }
            if currentSelectColor == .blue && !redOrBlue {
                return false
            }
        }
        return true
    }
    
    mutating func upCount(_ isRed: Bool? = nil) {
        guard let redOrBlue = isRed else {
            return
        }
        currentSelectColor = redOrBlue ? .red : .blue
        count += 1
        if count >= 4 {
            count = 0
        }
    }
    
    var currentSelectColor: Color = Color.gray
}
