//
//  Common.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2021/04/21.
//  Copyright © 2021 Aimi Itagaki. All rights reserved.
//

import UIKit

func topViewController(controller: UIViewController? = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
    if let tabController = controller as? UITabBarController {
        if let selected = tabController.selectedViewController {
            return topViewController(controller: selected)
        }
    }

    if let navigationController = controller as? UINavigationController {
        return topViewController(controller: navigationController.visibleViewController)
    }

    if let presented = controller?.presentedViewController {
        return topViewController(controller: presented)
    }

    return controller
}
