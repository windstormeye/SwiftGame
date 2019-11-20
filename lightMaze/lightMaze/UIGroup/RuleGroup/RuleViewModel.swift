//
//  RuleViewModel.swift
//  lightMaze
//
//  Created by 豆沙馅丶 on 2019/11/16.
//  Copyright © 2019 aby. All rights reserved.
//

import UIKit
import Combine

class RuleViewModel: ObservableObject {
    let popResponder: NavigatePop
        
    let randomRule: String = "玩家手动点击开始后，系统会随机亮起 4 - 10 个灯， 需要玩家将亮起的灯逐一点灭，全部点灭即可过关。"
    let missionRule: String = "基本玩法：点击某个灯，其上下左右的灯会也随之起反应，当前状态灭则亮，亮则灭。玩家进入后，每次灭完所有的灯，进入下一关，随着关卡的不断的深入，棋盘会越来越大，亮灯的规律也会越来越难以寻找"
    
    init(pop: NavigatePop) {
        self.popResponder = pop
    }
    
    /// MARK: - Function
    func exit() {
        popResponder.pop()
    }

}
