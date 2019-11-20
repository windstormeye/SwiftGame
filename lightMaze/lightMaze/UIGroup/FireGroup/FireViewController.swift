//
//  FireViewController.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import UIKit
import SwiftUI

protocol FireViewModelFactory {
    func makeFireViewModel() -> FireViewModel
}

class FireViewController: NiblessViewController {
    
    let hostVC: UIHostingController<FireContentView>
    init(viewModelFactory: FireViewModelFactory) {
        let viewModel = viewModelFactory.makeFireViewModel()
        self.hostVC = UIHostingController.init(rootView: FireContentView.init(viewModel: viewModel))
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
