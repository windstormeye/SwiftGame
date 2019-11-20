//
//  GameManager.swift
//  light-game
//
//  Created by pjhubs on 2019/8/30.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import SwiftUI
import Combine


enum playType {
    case random // 随机玩法
    case level  // 关卡玩法
}

class GameManager: ObservableObject {
    
    /// 对外发布的格式化计时器字符串
    @Published var timeString = "00:00"
    
    /// 点击次数
    @Published var clickTimes = 0
    
    /// 灯状态
    @Published var lights = [[Light]]()
    
    @Published var lightsNums = [[String]]()
    
    /// 是否获胜
    @Published var isWin = false
    
    /// 是否开始
    @Published var isStart = false
    
    /// 是否显示答案
    @Published var showAnswer = false
    
    /// 记录本次的结果
    @Published var recordCurrentLights: [Int] = []
    
    /// 提示的答案
    var answerString: String {
        get {
            
            var answerArray: [String] = []
            
            recordCurrentLights.forEach { (num) in
                answerArray.append("\(num)")
            }
            
            answerArray = Array(answerArray.reversed())
            return "关灯顺序为: \(answerArray.joined(separator: " -> "))"
        }
    }
    
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
    
    /// 游戏玩法
    private let gameType: playType
    
    init(gameType: playType) {
        self.gameType = gameType
        switch gameType {
        case .random:
            loadRandomData()
        case .level:
            break
        }
    }
    
    func loadRandomData() {
        size = randomSize().size
        lights = randomSize().lights
        lightsNums = randomSize().lightsNums
    }
    
    func startRandomPlay() {
        isStart = true
        showAnswer = false
        
        timerRestart()
        guard let size = self.size else {
            print("size is nil")
            return
        }
        start(randomLights(size: size))

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
        durations = 0
        timeString = "00:00"
        timer?.invalidate()
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
            var index = lightIndex
            if index >= size * size {
                index = size * size - 1
            }
            let row = lightIndex / size
            let column = lightIndex % size
            // column 不为 0，说明非最后一个
            // row 为 0，说明为第一行
            updateLightStatus(column: column, row: row)
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
            timerStop()
            currentStatus = .lose
            return
        }
        
        if lightingCount == 0 {
            timerStop()
            currentStatus = .win
            return
        }
    }
    
    /// 返回随机玩法的地图大小
    /// size: 行数
    /// lights: 灯泡数
    func randomSize() -> (size: Int, lights: Array<[Light]>, lightsNums: [[String]]) {
        let size = 6
          
        let lights = Array(repeating: Array(repeating: Light(), count: size), count: size)
        
        var index = -1
        var lightsNums:  [[String]] = []
        
        lights.forEach { (light) in
            var groupNums: [String] = []
            light.forEach { (_) in
                index = index + 1
                groupNums.append("\(index)")
            }
            lightsNums.append(groupNums)
        }
        return (size: size, lights: lights, lightsNums: lightsNums)
    }
    
    
    /// 返回随机数的点亮个数和灯泡点亮位置
    /// - Parameter size: 行数
    func randomLights(size: Int) -> Array<Int> {
        let minSize = size - 2
        let maxSize = size + 4
        let randomCount = Int.random(in: minSize...maxSize)
        
        print(randomCount)
        
        let allLightCount = Int(pow(Double(size), 2)) - 1
        
        var lights: [Int] = []
        
        while randomCount != lights.count {
            let randomNumber = Int.random(in: 0...allLightCount)
            if !lights.contains(randomNumber) {
                lights.append(randomNumber)
            }
        }
        print(lights)
        recordCurrentLights = lights
        return lights
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
