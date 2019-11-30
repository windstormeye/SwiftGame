//
//  GameController.swift
//  light-game
//
//  Created by 翁培钧 on 2019/11/30.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import GameController
import Combine

class GameController {
    
    var movingX = false
    var movingY = false
    
    var isSelectX: ((Bool) -> ())?
    var isSelectY: ((Bool) -> ())?
    var isTapButtonA: (() -> ())?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: .didConnect, name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: .didConnect, name: .GCControllerDidDisconnect, object: nil)
    }
}


extension GameController {
    @objc fileprivate func gameControllerDidConnect() {
        for controller in GCController.controllers() {
            if controller.extendedGamepad != nil {
                setupControllerControls(controller: controller)
            }
        }
    }
    
    @objc fileprivate func gameControllerDidDisconnect() {
        
    }
    
    func setupControllerControls(controller: GCController) {
        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element: GCControllerElement) in
            self.controllerInput(gamePad: gamepad, element: element)
        }
    }
    
    private func controllerInput(gamePad: GCExtendedGamepad, element: GCControllerElement) {
        if (gamePad.leftThumbstick == element) {
            if (gamePad.leftThumbstick.yAxis.value != 0 && !movingY && !movingX) {
                movingY = true
                isSelectY?(gamePad.leftThumbstick.yAxis.value > 0)
                return
            } else if (gamePad.leftThumbstick.yAxis.value == 0) {
                movingY = false
            }
            
            if (gamePad.leftThumbstick.xAxis.value != 0 && !movingX && !movingY) {
                isSelectX?(gamePad.leftThumbstick.xAxis.value > 0)
                movingX = true
                return
            } else if (gamePad.leftThumbstick.xAxis.value == 0) {
                movingX = false
            }
        }
    }
}

private extension Selector {
    static let didConnect = #selector(GameController.gameControllerDidConnect)
    static let didDisConnect = #selector(GameController.gameControllerDidDisconnect)
}
