//
//  ContentView.swift
//  light-game
//
//  Created by pjhubs on 2019/8/29.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import SwiftUI

struct ContentView: View {    
    @ObservedObject var gameManager = GameManager()
    
    init() {
        gameManager = GameManager(size: 5, lightSequence: [1, 2, 3])
    }
    
    var body: some View {
        ForEach(0..<gameManager.lights.count) { row in
            HStack(spacing: 20) {
                ForEach(0..<self.gameManager.lights[row].count) { column in
                    Circle()
                        .foregroundColor(self.gameManager.lights[row][column].status ? .yellow : .gray)
                        .opacity(self.gameManager.lights[row][column].status ? 0.8 : 0.5)
                        .frame(width: self.gameManager.circleWidth(),
                               height: self.gameManager.circleWidth())
                        .shadow(color: .yellow, radius: self.gameManager.lights[row][column].status ? 10 : 0)
                        .onTapGesture {
                            self.gameManager.updateLightStatus(column: column, row: row)
                    }
                }
            }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
        }
    }
}
