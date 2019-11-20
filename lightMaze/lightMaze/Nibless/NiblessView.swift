//
//  NiblessView.swift
//  BoxueUIKit
//
//  Created by Mars on 2018/10/14.
//  Copyright © 2018 Mars. All rights reserved.
//

import UIKit

open class NiblessView: UIView {
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  @available(*, unavailable, message: "Loading this view from a nib is unsupported")
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading this view from a nib is unsupported")
  }
}
