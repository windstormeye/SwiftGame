//
//  SetpViewModel.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import Foundation

class SetpViewModel {
    private let randomRedponder: NavigateToRandom
    private let missonResponder: NavigateToMission
    private let ruleResponder: NavigateToRule
    private let fireResponder: NavigateToFire
    init(toRandom: NavigateToRandom, missonResponder: NavigateToMission, ruleResponder: NavigateToRule, fireResponder: NavigateToFire) {
        self.randomRedponder = toRandom
        self.missonResponder = missonResponder
        self.ruleResponder = ruleResponder
        self.fireResponder = fireResponder
    }
    
    func toRandomPage() {
        self.randomRedponder.toRandom()
    }
    
    func toMissionPage() {
        self.missonResponder.toMission()
    }
    
    func toRulePage() {
        self.ruleResponder.toRule()
    }
    
    func toFirePage() {
        self.fireResponder.toFire()
    }
}
