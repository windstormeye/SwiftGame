//
//  RuleViewController.swift
//  lightMaze
//
//  Created by 豆沙馅丶 on 2019/11/16.
//  Copyright © 2019 aby. All rights reserved.
//

import UIKit
import SwiftUI

protocol RuleViewModelFactory {
    func makeRuleViewModel() -> RuleViewModel
}

class RuleViewController: NiblessViewController {
    
    let hostVC: UIHostingController<RuleContentView>
    init(viewModelFactory: RuleViewModelFactory) {
        let viewModel = viewModelFactory.makeRuleViewModel()
        self.hostVC = UIHostingController.init(rootView: RuleContentView.init(viewModel: viewModel))
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func loadView() {
        self.view = UIView()
        addFullScreen(childViewController: hostVC)
    }
}
