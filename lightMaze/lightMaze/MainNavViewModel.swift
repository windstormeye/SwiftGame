//
//  MainNavViewModel.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import Foundation
import Combine

enum ViewAction<ViewStatus> {
    case push(status: ViewStatus)
    case endPush(status: ViewStatus)
    case pop
}

enum ViewStatus {
    case first
    case random
    case mission
    case rule
    case fire
}

protocol NavigateToRandom {
    func toRandom()
}

protocol NavigateToMission {
    func toMission()
}

protocol NavigateToRule {
    func toRule()
}

protocol NavigatePop {
    func pop()
}

protocol NavigateToFire {
    func toFire()
}

class MainNavViewModel {
    // 当前路由状态
    @Published var currentViewStatus: ViewAction<ViewStatus> = .push(status: .first)
    var viewStatus: AnyPublisher<ViewAction<ViewStatus>, Never> {
        return AnyPublisher.init($currentViewStatus)
    }
    init() {}
}

extension MainNavViewModel: NavigateToRandom, NavigatePop, NavigateToMission, NavigateToRule, NavigateToFire {
    func toRandom() {
        currentViewStatus = .push(status: .random)
    }
    
    func pop() {
        currentViewStatus = .pop
    }
    
    func toMission() {
        currentViewStatus = .push(status: .mission)
    }
    
    func toRule() {
        currentViewStatus = .push(status: .rule)
    }
    
    func toFire() {
        currentViewStatus = .push(status: .fire)
    }
}
