//
//  MainNaviagtaonController.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

typealias ViewControllerFactory = () -> UIViewController

class MainNaviagtaonController: NiblessNavigationController {
    
    let viewModel: MainNavViewModel
    let randomViewControllerFactory: ViewControllerFactory
    let firstViewControllerFactory: ViewControllerFactory
    let missionViewModelFactory: ViewControllerFactory
    let ruleViewControllerFactory: ViewControllerFactory
    let fireViewControllerFactory: ViewControllerFactory
    var disposables = Set<AnyCancellable>()
    
    init(viewModel:MainNavViewModel,
         randomViewControllerFactory:@escaping ViewControllerFactory,
         firstViewControllerFactory:@escaping ViewControllerFactory,
         missionViewModelFactory: @escaping ViewControllerFactory,
         ruleViewControllerFactory: @escaping ViewControllerFactory,
         fireViewControllerFactory: @escaping ViewControllerFactory) {
        self.viewModel = viewModel
        self.randomViewControllerFactory = randomViewControllerFactory
        self.firstViewControllerFactory = firstViewControllerFactory
        self.missionViewModelFactory = missionViewModelFactory
        self.ruleViewControllerFactory = ruleViewControllerFactory
        self.fireViewControllerFactory = fireViewControllerFactory
        super.init()
        self.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeViewStatus()
        // Do any additional setup after loading the view.
    }
    
    func subscribeViewStatus() {
        viewModel.viewStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (status) in
                guard let `self` = self else { return }
                self.respond(action: status)
        }.store(in: &disposables)
    }

    func respond(action: ViewAction<ViewStatus>) {
        switch action {
        case .push(status: let status):
            responsds(status: status)
        case .pop:
            popToPrevious()
        default:
            break
        }
    }
    
    func responsds(status: ViewStatus) {
        switch status {
        case .first:
            pushFirstViewController()
        case .random:
            pushRandomViewController()
        case .mission:
            pushMissionViewController()
        case .rule:
            pushRuleViewController()
        case .fire:
            pushFireViewController()
//        default:
//            break
        }
    }
    
    func pushFirstViewController() {
        let viewControllelr = self.firstViewControllerFactory()
        pushViewController(viewControllelr, animated: true)
    }
    
    func pushRandomViewController() {
        let viewcontroller = self.randomViewControllerFactory()
        pushViewController(viewcontroller, animated: true)
    }
    
    func pushMissionViewController() {
        let missionViewController = self.missionViewModelFactory()
        pushViewController(missionViewController, animated: true)
    }
    
    func pushRuleViewController() {
        let ruleViewController = self.ruleViewControllerFactory()
        pushViewController(ruleViewController, animated: true)
    }
    
    func pushFireViewController() {
        let fireViewController = self.fireViewControllerFactory()
        pushViewController(fireViewController, animated: true)
    }
    
    func popToPrevious() {
        popViewController(animated: true)
    }
    
    

}

/// UINavigationControllerDelegate
extension MainNaviagtaonController: UINavigationControllerDelegate {
  /// Animate the navigation bar display with view controller transition.
  public func navigationController(
    _ navigationController: UINavigationController,
    willShow viewController: UIViewController,
    animated: Bool) {
    self.setNavigationBarHidden(true, animated: false)
  }
  
  /// Trigger a `GuideNavigateAction` event according to the destination view type.
  public func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool) {
    print("路由结束")
  }
}
