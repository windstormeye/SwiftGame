//
//  AppdependenceContainer.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import UIKit

class AppdependencyContainer {
    
    let shareNavViewModel: MainNavViewModel
    init() {
        self.shareNavViewModel = MainNavViewModel.init()
    }
    
    func makeMainNavController() -> UIViewController {
        return MainNaviagtaonController.init(viewModel: shareNavViewModel,
                                             randomViewControllerFactory: self.makeRandomGroupViewController,
                                             firstViewControllerFactory: self.makeFirstViewController,
                                             missionViewModelFactory: self.makeMissionViewController,
                                             ruleViewControllerFactory: self.makeRuleViewController,
                                             fireViewControllerFactory: self.makeFireViewController)
    }
    
    func makeFirstViewController() -> UIViewController {
        let viewController = SetpViewController.init(viewModelFactory: self)
        return viewController
    }
    
    func makeRandomGroupViewController() -> UIViewController {
        let viewController  = RandomViewController.init(viewModelFactory: self)
        return viewController
    }
    
    func makeMissionViewController() -> UIViewController {
        let viewController = MissionViewController.init(viewModelFactory: self)
        return viewController
    }

    
    func makeFireViewController() -> UIViewController {
        let viewController = FireViewController.init(viewModelFactory: self)
        return viewController
    }
    
    func makeRuleViewController() -> UIViewController {
        let viewController = RuleViewController.init(viewModelFactory: self)
        return viewController
    }
}

extension AppdependencyContainer: RandomViewModelFactory {
    func makeRandomViewModel() -> RandomViewModel {
        return RandomViewModel.init(pop: shareNavViewModel)
    }
}

extension AppdependencyContainer: SetpViewModelFactory {
    func makeSetpViewModel() -> SetpViewModel {
        return SetpViewModel.init(toRandom: shareNavViewModel, missonResponder: shareNavViewModel, ruleResponder: shareNavViewModel, fireResponder: shareNavViewModel)
    }
}

extension AppdependencyContainer: MissionViewModelFactory {
    func makeMissionViewModel() -> MissionViewModel {
        return MissionViewModel.init(pop: shareNavViewModel)
    }
}


extension AppdependencyContainer: FireViewModelFactory {
    func makeFireViewModel() -> FireViewModel {
        return FireViewModel.init(pop: shareNavViewModel)
    }
}
    
extension AppdependencyContainer: RuleViewModelFactory {
    func makeRuleViewModel() -> RuleViewModel {
        return RuleViewModel.init(pop: shareNavViewModel)
    }
}
