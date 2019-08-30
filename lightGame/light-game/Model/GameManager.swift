//
//  GameManager.swift
//  light-game
//
//  Created by pjhubs on 2019/8/30.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import SwiftUI
import Combine

class GameManager: ObservableObject {
    /// 灯状态
    @Published var lights = [[Light]]()
    @Published var isWin = false
    /// 当前游戏状态
    private var currentStatus: GameStatus = .during {
        didSet {
            switch currentStatus {
            case .win: isWin = true
            case .lose: isWin = false
            case .during: break
            }
        }
    }
    
    /// 游戏尺寸大小
    private(set) var size: Int?
    
    // MARK: - Init
    
    /// 便捷构造方法
    /// - Parameters:
    ///   - size: 游戏布局尺寸，默认值 5x5
    ///   - lightSequence: 亮灯序列，默认全灭
    convenience init(size: Int = 5,
                     lightSequence: [Int] = [Int]()) {
        
        self.init()
        
        var size = size
        // 太大了不好玩
        if size > 8 {
            size = 7
        }
        // 太小了没意思
        if size < 2 {
            size = 2
        }
        self.size = size
        lights = Array(repeating: Array(repeating: Light(), count: size), count: size)
        
        start(lightSequence)
    }
    
    // MARK: Public
    
    /// 游戏配置
    /// - Parameter lightSequence： 亮灯序列
    func start(_ lightSequence: [Int]) {
        currentStatus = .during
        updateLightStatus(lightSequence)
    }
    
    /// 获取灯的尺寸
    func circleWidth() -> CGFloat {
        guard let size = size else { return 0 }
        
        /// 距离屏幕左右两边的间距
        let padding: CGFloat = 20
        /// 左右两灯之间的间距
        let innerSpacing: CGFloat = 20
        
        var circleWidth = (UIScreen.main.bounds.width - padding - (CGFloat(size) * innerSpacing)) / CGFloat(size)
        
        // 太大了会很丑，过滤下
        if circleWidth > UIScreen.main.bounds.width / 5 {
            circleWidth = UIScreen.main.bounds.width / 5
        }
    
        return circleWidth
    }
    
    /// 通过坐标索引修改灯状态
    /// - Parameters:
    ///   - column: 灯-列索引
    ///   - size: 灯-行索引
    func updateLightStatus(column: Int, row: Int) {
        lights[row][column].status.toggle()
        
        // 上
        let top = row - 1
        if !(top < 0) {
            lights[top][column].status.toggle()
        }
        // 下
        let bottom = row + 1
        if !(bottom > lights.count - 1) {
            lights[bottom][column].status.toggle()
        }
        // 左
        let left = column - 1
        if !(left < 0) {
            lights[row][left].status.toggle()
        }
        // 右
        let right = column + 1
        if !(right > lights.count - 1) {
            lights[row][right].status.toggle()
        }
        
        updateGameStatus()
    }
    
    // MARK: Private
    
    /// 通过亮灯序列修改灯状态
    /// - Parameter lightSequence: 亮灯序列
    private func updateLightStatus(_ lightSequence: [Int]) {
        guard let size = size else { return }
        
        for lightIndex in lightSequence {
            var row = lightIndex / size
            let column = lightIndex % size
            
            // column 不为 0，说明非最后一个
            // row 为 0，说明为第一行
            if column > 0 && row >= 0 {
                row += 1
            }
            updateLightStatus(column: column - 1, row: row - 1)
        }
    }
    
    /// 判赢
    private func updateGameStatus() {
        guard let size = size else { return }
        
        var lightingCount = 0
        
        
        for lightArr in lights {
            for light in lightArr {
                if light.status { lightingCount += 1 }
            }
        }
        
        if lightingCount == size * size {
            currentStatus = .lose
            return
        }
        
        if lightingCount == 0 {
            currentStatus = .win
            return
        }
    }
}

extension GameManager {
    enum GameStatus {
        /// 赢
        case win
        /// 输
        case lose
        /// 进行中
        case during
    }
}
