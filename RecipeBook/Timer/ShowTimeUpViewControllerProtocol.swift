//
//  ShowTimeUpViewControllerProtocol.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2021/04/28.
//  Copyright © 2021 Aimi Itagaki. All rights reserved.
//

import UIKit

protocol ShowTimeUpViewControllerProtocol {
    func showTimeUpViewController(time: String?)
}

extension ShowTimeUpViewControllerProtocol where Self: UIViewController & UIViewControllerTransitioningDelegate {
    
    func showTimeUpViewController(time: String?) {
        guard let modalViewController = TimeUpViewController.initTimeUpViewController(transitioningDelegate: self, countDownTime: time) else { return }
        present(modalViewController, animated: true, completion: nil)
    }
}
