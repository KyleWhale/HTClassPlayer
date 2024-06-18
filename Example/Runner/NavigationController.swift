//
//  NavigationController.swift
//  Runner
//
//  Created by 李雪健 on 2024/6/18.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    
    // 是否支持自动转屏
    open override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }

    // 支持哪些屏幕方向
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
}
