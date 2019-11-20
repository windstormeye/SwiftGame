//
//  NiblessViewController.swift
//  BoxueUIKit
//
//  Created by Mars on 2018/10/4.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

open class NiblessViewController: UIViewController {
  /// - Methods
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable, message: "Loading this view controller from a nib is unsupported")
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  @available(*, unavailable, message: "Loading this view controller from a nib is unsupported")
  public required init(coder aDecoder: NSCoder) {
    fatalError("Loading this view controller from a nib is unsupported")
  }
}
