//
//  MissionViewModel.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import Foundation
import UIKit
import Combine

struct RowModels: Identifiable {
    var id: Int
    init(identifier: Int) {
        id = identifier
    }
    var rows: [Light] = []
}

class MissionViewModel: ObservableObject {
    
    struct MissionRecord {
        init() {
            currentLightSequence = randomLights()
            reloadLights()
        }
        var currentMissionNumber: Int = 1
        var currentMissionSize: Int = 4
        private var currenLevel: Int = 0
        var currentLightSequence: [Int] = [1, 2, 3, 4, 5]
        var missiionLevel: Int {
            return currentMissionSize + currenLevel
        }
        
        var lights: [RowModels] = [RowModels]()
        
        mutating func nextMission() {
            currentMissionNumber += 1
            print("missiionLevel\(missiionLevel),currentMissionSize:\(currentMissionSize)")
            if missiionLevel - currentMissionSize > 2 {
                currenLevel = 0
                if currentMissionSize <= 9 {
                    currentMissionSize += 1
                }
            } else {
                currenLevel += 1
            }
            print("missiionLevel\(missiionLevel),currentMissionSize:\(currentMissionSize)")
            currentLightSequence = randomLights()
            reloadLights()
        }
        
        mutating func refreshMission() {
            reloadLights()
        }
        
        /// 返回随机数的点亮个数和灯泡点亮位置
        /// - Parameter size: 行数
        func randomLights() -> Array<Int> {
            let randomCount = missiionLevel
            print(randomCount)
            let allLightCount = Int(pow(Double(currentMissionSize), 2)) - 1
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
            for cloumn in 0..<currentMissionSize {
                var rowLights: RowModels = RowModels.init(identifier: cloumn)
                for row in 0..<currentMissionSize {
                    var light = Light.init()
                    light.number = cloumn * currentMissionSize + row
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
    
    @Published var missionRecord: MissionRecord = MissionRecord.init()
    @Published var timeString = "00:00"
    @Published var clickTimes = 0
    
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
                isWin = false
            default:
                break
            }
        }
    }
    
    
    
    var screenWith: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var size: Int {
        return missionRecord.currentMissionSize
    } // 游戏尺寸的大小，默认值为4
    private(set) var timer: Timer? // 计时器
    private var durations = 1 // 游戏持续的时间
    
    /// MARK: - Function
    func exit() {
        popResponder.pop()
    }
    
    func nextMission() {
        showAnswer = false
        missionRecord.nextMission()
        start(missionRecord.currentLightSequence)
        timerRestart()
    }
    
    func resetMission() {
        if showAnswer {
            showAnswer = false
        }
        missionRecord.reloadLights()
        start(missionRecord.currentLightSequence)
        timerRestart()
    }
    
    func tipsMission() {
        resetMission()
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
    
    /// 通过坐标索引修改灯状态
    /// - Parameters:
    ///   - column: 灯-列索引
    ///   - size: 灯-行索引
    func updateLightStatus(column: Int, row: Int) {
        missionRecord.lights[row].rows[column].status.toggle()
        
        // 上
        let top = row - 1
        if !(top < 0) {
            missionRecord.lights[top].rows[column].status.toggle()
        }
        // 下
        let bottom = row + 1
        if !(bottom > missionRecord.lights.count - 1) {
            missionRecord.lights[bottom].rows[column].status.toggle()
        }
        // 左
        let left = column - 1
        if !(left < 0) {
            missionRecord.lights[row].rows[left].status.toggle()
        }
        // 右
        let right = column + 1
        if !(right > missionRecord.lights.count - 1) {
            missionRecord.lights[row].rows[right].status.toggle()
        }
        updateGameStatus()
    }
    
    private func updateGameStatus(){
        var lightingCount = 0
        for lightArr in missionRecord.lights {
            for light in lightArr.rows {
                if light.status { lightingCount += 1 }
            }
        }
        
        if lightingCount == size * size - 1 {
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

extension MissionViewModel {
    enum GameStatus {
        case win
        case lose
        case during
    }
}
