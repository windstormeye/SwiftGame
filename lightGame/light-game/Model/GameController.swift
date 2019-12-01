//
//  GameController.swift
//  light-game
//
//  Created by 翁培钧 on 2019/11/30.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import GameController

class GameController {
    
    var movingX = false
    var movingY = false
    
    var isSelectX: ((Bool) -> ())?
    var isSelectY: ((Bool) -> ())?
    var isTapButtonA: (() -> ())?
    var isTapButtonB: (() -> ())?
    
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
        // 不能 return，因为单次出发会带入多个按键的值
        
        if (gamePad.leftThumbstick == element) {
            if (gamePad.leftThumbstick.yAxis.value != 0 && !movingY && !movingX) {
                movingY = true
                isSelectY?(gamePad.leftThumbstick.yAxis.value > 0)
            } else if (gamePad.leftThumbstick.yAxis.value == 0) {
                movingY = false
            }
            
            if (gamePad.leftThumbstick.xAxis.value != 0 && !movingX && !movingY) {
                isSelectX?(gamePad.leftThumbstick.xAxis.value > 0)
                movingX = true
            } else if (gamePad.leftThumbstick.xAxis.value == 0) {
                movingX = false
            }
        } else if (gamePad.rightThumbstick == element) {
            if (gamePad.rightThumbstick.xAxis.value != 0) {
                print("rightThumbstickXAxis: \(gamePad.rightThumbstick.xAxis)")
            }
        } else if (gamePad.dpad == element) {
            if (gamePad.dpad.xAxis.value != 0) {
                isSelectX?(gamePad.dpad.xAxis.value > 0)
            } else if (gamePad.dpad.xAxis.value == 0) {
                // YOU CAN PUT CODE HERE TO STOP YOUR PLAYER FROM MOVING
            }
            
            if (gamePad.dpad.yAxis.value != 0) {
                isSelectY?(gamePad.dpad.yAxis.value > 0)
            } else if (gamePad.dpad.yAxis.value == 0) {
                // YOU CAN PUT CODE HERE TO STOP YOUR PLAYER FROM MOVING
            }
        } else if (gamePad.buttonA == element) {
            if (gamePad.buttonA.value != 0) {
                isTapButtonA?()
            }
        } else if (gamePad.buttonB == element) {
            if (gamePad.buttonB.value != 0) {
                isTapButtonB?()
            }
        } else if (gamePad.buttonY == element) {
            if (gamePad.buttonY.value != 0) {
//                print("Y-Button Pressed!")
//                buttonYTap = true
            }
        } else if (gamePad.buttonX == element) {
            if (gamePad.buttonX.value != 0) {
//                print("X-Button Pressed!")
//                buttonXTap = true
            }
        }
    }
}

private extension Selector {
    static let didConnect = #selector(GameController.gameControllerDidConnect)
    static let didDisConnect = #selector(GameController.gameControllerDidDisconnect)
}
