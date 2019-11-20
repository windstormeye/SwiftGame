//
//  FireViewModel.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import Foundation
import UIKit
import Combine

class FireViewModel: ObservableObject {
    
    struct FireRecord {
        init() {
//            currentLightSequence = randomLights()
            reloadLights()
        }
        var currentFireNumber: Int = 1
        var currentFireSize: Int = 4
        private var currenLevel: Int = 0
        var currentLightSequence: [Int] = []
        var missiionLevel: Int {
            return currentFireSize + currenLevel
        }
        
        var lights: [RowModels] = [RowModels]()
        
        mutating func nextFire() {
            currentFireNumber += 1
            print("missiionLevel\(missiionLevel),currentFireSize:\(currentFireSize)")
            if missiionLevel - currentFireSize > 2 {
                currenLevel = 0
                if currentFireSize <= 9 {
                    currentFireSize += 1
                }
            } else {
                currenLevel += 1
            }
            print("missiionLevel\(missiionLevel),currentFireSize:\(currentFireSize)")
            currentLightSequence = randomLights()
            reloadLights()
        }
        
        mutating func refreshFire() {
            reloadLights()
        }
        
        /// 返回随机数的点亮个数和灯泡点亮位置
        /// - Parameter size: 行数
        func randomLights() -> Array<Int> {
            let randomCount = missiionLevel
            print(randomCount)
            let allLightCount = Int(pow(Double(currentFireSize), 2)) - 1
            var lights: [Int] = []
            while randomCount != lights.count {
                let randomNumber = Int.random(in: 0...allLightCount)
                if !lights.contains(randomNumber) {
                    lights.append(randomNumber)
                }
            }
            print(lights)
            return lights
        }
        
        mutating func reloadLights() {
            lights.removeAll()
            for cloumn in 0..<currentFireSize {
                var rowLights: RowModels = RowModels.init(identifier: cloumn)
                for row in 0..<currentFireSize {
                    var light = Light.init()
                    light.number = cloumn * currentFireSize + row
                    rowLights.rows.append(light)
                }
                lights.append(rowLights)
            }
        }
    }
    
    
    let popResponder: NavigatePop
    init(pop: NavigatePop) {
        self.popResponder = pop
        start(missionRecord.currentLightSequence)
    }
    
    @Published var missionRecord: FireRecord = FireRecord.init()
    @Published var timeString = "00:00"
    @Published var clickTimes = 0 // 记录该谁先行
    var redOrBlue: Bool {
        return clickTimes % 2 == 0
    }
    
    @Published var isWin = false
    /// 是否显示答案
    @Published var showAnswer = false
    /// 提示的答案
    var answerString: String {
        get {
            
            var answerArray: [String] = []
            
            missionRecord.currentLightSequence.forEach { (num) in
                answerArray.append("\(num)")
            }
            
            answerArray = Array(answerArray.reversed())
            return "关灯顺序为: \(answerArray.joined(separator: " -> "))"
        }
    }
    private var currentStatus: GameStatus = .during {
        didSet {
            switch currentStatus {
            case .win:
                isWin = true
            case .lose:
                isWin = true
            default:
                break
            }
        }
    }
    
    var winString: String {
        var string = ""
        switch currentStatus {
        case .win:
            string = "蓝方胜"
        case .lose:
            string = "红方胜"
        default:
            break
        }
        return string
    }
    
    var screenWith: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var size: Int {
        return missionRecord.currentFireSize
    } // 游戏尺寸的大小，默认值为4
    private(set) var timer: Timer? // 计时器
    private var durations = 1 // 游戏持续的时间
    
    /// MARK: - Function
    func exit() {
        popResponder.pop()
    }
    
    func nextFire() {
        showAnswer = false
        missionRecord.nextFire()
        start(missionRecord.currentLightSequence)
        timerRestart()
    }
    // 迥异个
    func resetFire() {
        if showAnswer {
            showAnswer = false
        }
        clickTimes = 0
        missionRecord.reloadLights()
        timerRestart()
    }
    
    func tipsFire() {
        resetFire()
        showAnswer = true
    }
    
    func start(_ lightSqueue: [Int]) {
        currentStatus = .during
        clickTimes = 0
        updateLightStatus(lightSequence: lightSqueue)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            guard let `self` = self else { return }
            let min = self.durations >= 60 ? self.durations / 60 : 0
            let seconds = self.durations - min * 60
            let minString = min >= 10 ? "\(min)" : "0\(min)"
            let secondString = self.durations - min * 60 >= 10 ? "\(seconds)" : "0\(seconds)"
            self.timeString = minString + ":" + secondString
            self.durations += 1
        })
    }
    
    // 停止定时器
    func timerStop() {
        timer?.fireDate = Date.distantFuture
    }
    
    // 启动定时器
    func timerRestart() {
        durations = 0
        timeString = "00:00"
        timer?.invalidate()
    }
    
    func circleWidth() -> CGFloat {
        let padding: CGFloat = 20
        let innerSpacing: CGFloat = 20
        var circleWidth = (screenWith - padding - (CGFloat(size) * innerSpacing)) / CGFloat(size)
        if circleWidth > screenWith / 5 {
            circleWidth = screenWith / 5.0
        }
        return circleWidth
    }
    
    func nextSetp(column: Int, row: Int) {
        let canJiaJia = missionRecord.lights[row].rows[column].canUpCase(redOrBlue: redOrBlue)
        if canJiaJia {
            clickTimes += 1
            updateLightStatus(column: column, row: row)
        }
    }
    
    
    /// 通过坐标索引修改灯状态
    /// - Parameters:
    ///   - column: 灯-列索引
    ///   - size: 灯-行索引
    func updateLightStatus(column: Int, row: Int) {
        missionRecord.lights[row].rows[column].upCount(redOrBlue)
        guard !missionRecord.lights[row].rows[column].countStatus else {
            updateGameStatus()
            return
        }
        // 上
        let top = row - 1
        if !(top < 0) {
//            missionRecord.lights[top].rows[column].upCount()
            updateLightStatus(column: column, row: top)
        }
        // 下
        let bottom = row + 1
        if !(bottom > missionRecord.lights.count - 1) {
//            missionRecord.lights[bottom].rows[column].upCount()
            updateLightStatus(column: column, row: bottom)
        }
        // 左
        let left = column - 1
        if !(left < 0) {
//            missionRecord.lights[row].rows[left].upCount()
            updateLightStatus(column: left, row: row)
        }
        // 右
        let right = column + 1
        if !(right > missionRecord.lights.count - 1) {
//            missionRecord.lights[row].rows[right].upCount()
            updateLightStatus(column: right, row: row)
        }
    }
    
    private func updateGameStatus(){
        var redLightingCount = 0
        var blueLightingCount = 0
        for lightArr in missionRecord.lights {
            for light in lightArr.rows {
                if light.currentSelectColor == .red { redLightingCount += 1; continue; }
                if light.currentSelectColor == .blue { blueLightingCount += 1 }
            }
        }
        if clickTimes < 2 {
            currentStatus = .during
            return
        }
        
        if redLightingCount == 0 {
            currentStatus = .win
        }
        
        if blueLightingCount == 0 {
            currentStatus = .lose
        }
    }
    
    private func updateLightStatus(lightSequence: [Int]) {
        for lightIndex in lightSequence {
            var index = lightIndex
            if index >= size * size {
                index = size * size - 1
            }
            let row = lightIndex / size
            let column = lightIndex % size
            updateLightStatus(column: column, row: row)
        }
    }
}

extension FireViewModel {
    enum GameStatus {
        case win
        case lose
        case during
    }
}
