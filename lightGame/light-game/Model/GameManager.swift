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
    /// 对外发布的格式化计时器字符串
    @Published var timeString = "00:00"
    /// 点击次数
    @Published var clickTimes = 0
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
    /// 游戏计时器
    private var timer: Timer?
    /// 游戏持续时间
    private var durations = 1
    private var gameController = GameController()
    private var row = 0
    private var column = 0
    private var pRow = 0
    private var pColumn = 0
    
    /// 游戏控制器暂停
    private var isPause = false
    
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
        
        initGameController()
        start(lightSequence)
    }
    
    // MARK: Public
    
    /// 游戏配置
    /// - Parameter lightSequence： 亮灯序列
    func start(_ lightSequence: [Int]) {
        currentStatus = .during
        clickTimes = 0
        updateLightStatus(lightSequence)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            let min = self.durations >= 60 ? self.durations / 60 : 0
            let seconds = self.durations - min * 60
            
            
            let minString = min >= 10 ? "\(min)" : "0\(min)"
            let secondString = self.durations - min * 60 >= 10 ? "\(seconds)" : "0\(seconds)"
            self.timeString = minString + ":" + secondString
            
            self.durations += 1
        })
    }
    
    /// 停止
    func timerStop() {
        timer?.fireDate = Date.distantFuture
    }
    
    /// 重新创建
    func timerRestart() {
        isPause = false
        durations = 0
        timeString = "00:00"
        timer?.fireDate = Date()
    }
    
    /// 获取灯的尺寸
    func circleWidth() -> CGFloat {
        guard let size = size else { return 0 }
        
        /// 距离屏幕左右两边的间距
        let padding: CGFloat = 20
        /// 左右两灯之间的间距
        let innerSpacing: CGFloat = 20
        
        var circleWidth: CGFloat = 50
        #if os(iOS)
        circleWidth = (UIScreen.main.bounds.width - padding - (CGFloat(size) * innerSpacing)) / CGFloat(size)
        // 太大了会很丑，过滤下
        if circleWidth > UIScreen.main.bounds.width / 5 {
            circleWidth = UIScreen.main.bounds.width / 5
        }
        #endif
    
        return circleWidth
    }
    
    /// 通过坐标索引修改灯状态
    /// - Parameters:
    ///   - column: 灯-列索引
    ///   - size: 灯-行索引
    func updateLightStatus(column: Int, row: Int, userTouch: Bool) {
        lights[row][column].status.toggle()
        self.column = row
        self.row = column
        
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
        
        if (userTouch) {
            disSelectedGameControllerStatus()
        }
    }
    
    // MARK: Private
    
    /// 通过亮灯序列修改灯状态
    /// - Parameter lightSequence: 亮灯序列
    private func updateLightStatus(_ lightSequence: [Int]) {
        guard let size = size else { return }
        for lightIndex in lightSequence {
            var index = lightIndex
            // 防止数组越出最大边界处
            if index >= size * size {
                index = size * size - 1
            }
            let row = lightIndex / size
            let column = lightIndex % size
            // column 不为 0，说明非最后一个
            // row 为 0，说明为第一行
            updateLightStatus(column: column, row: row, userTouch: true)
        }
    }
    
    private func updateLightSelected() {
        lights[pColumn][pRow].selected = false
        lights[column][row].selected = true
        
        pRow = row
        pColumn = column
    }
    
    private func disSelectedGameControllerStatus() {
        lights[pColumn][pRow].selected = false
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
            timerStop()
            currentStatus = .lose
            return
        }
        
        if lightingCount == 0 {
            timerStop()
            currentStatus = .win
            isPause = true
            return
        }
    }
    
    private func initGameController() {
        gameController.isSelectX = {
            guard !self.isPause else { return }
            
            if $0 {
                if (self.row < self.lights.count - 1) {
                    self.row += 1
                }
            } else {
                if self.row > 0 {
                    self.row -= 1
                }
            }
            
            self.updateLightSelected()
        }
        
        gameController.isSelectY = {
            guard !self.isPause else { return }
            
            if $0 {
                if (self.column > 0) {
                    self.column -= 1
                }
            } else {
                if (self.column < self.lights.count - 1) {
                    self.column += 1
                }
            }
            
            self.updateLightSelected()
        }
        
        gameController.isTapButtonA = {
            self.clickTimes += 1
            self.updateLightStatus(column: self.row, row: self.column, userTouch: false)
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
