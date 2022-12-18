//
//  Game.swift
//  SwiftGame
//
//  Created by pjhubs on 2022/12/18.
//

import Foundation

enum GameType: Int {
    case turnOffLight
    case puzzle
    case pinBall
}

struct Game: Identifiable, Hashable {
    let id = UUID()
    var gameType: GameType
    var name: String
    var iconName: String
}

struct GameItems: Identifiable {
    var id = UUID()
    var name: String
    var games: [Game]
}

func allGames() -> [Game] {
    return [
        Game(gameType: .turnOffLight, name: "能否关个灯", iconName: "TurnOffLight"),
        Game(gameType: .pinBall, name: "星球罐子", iconName: "PinBall"),
        Game(gameType: .puzzle, name: "黎锦拼图", iconName: "Puzzle"),
    ]
}
