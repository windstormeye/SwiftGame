//
//  Define.swift
//  liGame
//
//  Created by 翁培钧 on 2019/9/4.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screentHeight = UIScreen.main.bounds.size.height
// 底部安全距离
let bottomSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
//顶部的安全距离
let topSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0
//状态栏高度
let statusBarHeight = UIApplication.shared.statusBarFrame.height;
//导航栏高度
let navigationBarHeight = CGFloat(44 + topSafeAreaHeight)
