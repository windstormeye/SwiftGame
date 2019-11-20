//
//  RandomViewModel.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import Foundation

class RandomViewModel {
    let popResponder: NavigatePop
    init(pop: NavigatePop) {
       self.popResponder = pop
    }

    func exit() {
       popResponder.pop()
    }
}
