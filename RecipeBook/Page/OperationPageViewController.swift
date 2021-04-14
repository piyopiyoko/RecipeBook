//
//  OperationPageViewController.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/10/05.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import UIKit

protocol OperationPageViewController: AnyObject {
    func loadFavorite(url: String)
    func closePage(index: Int)
    func update(image: UIImage?, title: String?, index: Int)
    func setPageIconCollectionView(isHidden: Bool)
}
