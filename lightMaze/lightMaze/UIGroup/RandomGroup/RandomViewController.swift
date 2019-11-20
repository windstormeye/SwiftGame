//
//  RandomViewController.swift
//  lightMaze
//
//  Created by aby on 2019/11/15.
//  Copyright © 2019 aby. All rights reserved.
//

import UIKit
import SwiftUI

protocol RandomViewModelFactory {
    func makeRandomViewModel() -> RandomViewModel
}

class RandomViewController: UIViewController {
    let viewModel: RandomViewModel
    let hostVC: UIHostingController<RandomContentView>
    init(viewModelFactory: RandomViewModelFactory) {
        self.viewModel = viewModelFactory.makeRandomViewModel()
        self.hostVC = UIHostingController.init(rootView: RandomContentView(viewModel: self.viewModel))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("cannot init from coder")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        self.view = UIView.init()
        addFullScreen(childViewController: self.hostVC)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
