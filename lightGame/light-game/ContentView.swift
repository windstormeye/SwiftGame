//
//  ContentView.swift
//  light-game
//
//  Created by pjhubs on 2019/8/29.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var lights = [
        [Light(), Light(), Light()],
        [Light(), Light(), Light()],
        [Light(), Light(), Light()],
    ]
    
    /// 圆形图案之间的间距
    private let innerSpacing = 30
    
    var body: some View {
        ForEach(0..<lights.count) { row in
            HStack(spacing: 20) {
                ForEach(0..<self.lights[row].count) { column in
                    Circle()
                        .foregroundColor(self.lights[row][column].status ? .yellow : .gray)
                        .opacity(self.lights[row][column].status ? 0.8 : 0.5)
                        .frame(width: UIScreen.main.bounds.width / 5,
                               height: UIScreen.main.bounds.width / 5)
                        .shadow(color: .yellow, radius: self.lights[row][column].status ? 10 : 0)
                        .onTapGesture {
                            self.updateLightStatus(column: column, row: row)
                    }
                }
            }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
        }
    }
    
    /// 修改灯状态
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
    }
}
