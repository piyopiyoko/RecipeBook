//
//  FavoriteListNavigationController.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/11/11.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import UIKit

class FavoriteListNavigationController: UINavigationController {
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else { return }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
