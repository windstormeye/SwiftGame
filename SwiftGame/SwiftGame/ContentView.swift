//
//  ContentView.swift
//  SwiftGame
//
//  Created by pjhubs on 2022/12/18.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationStack {
            List(allGames(), id: \.id) { game in
                HStack {
                    Image(game.iconName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(12)
                    NavigationLink(game.name, value: game)
                }
            }
            .navigationDestination(for: Game.self) { game in
                switch game.gameType {
                case .puzzle:
                    PuzzleGame()
                case .pinBall:
                    PinBallGame()
                case .turnOffLight:
                    TurnOffLightGame()
                }
            }
            .navigationTitle("选择一个游戏开始吧！")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
        
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "My Mac"))
    }
}
