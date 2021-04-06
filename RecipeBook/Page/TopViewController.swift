//
//  TopViewController.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2021/03/31.
//  Copyright © 2021 Aimi Itagaki. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    @IBOutlet weak var pageIconListView: UIView!
    @IBOutlet weak var pageIconCollectionView: PageIconCollectionView!
    
    @IBOutlet var screenEdgePanGesture: UIScreenEdgePanGestureRecognizer!
    
    private var pageViewControllerDelegate: PageViewControllerDelegate? {
        children.first(where: { $0 is PageViewControllerDelegate }) as? PageViewControllerDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPageIconCollectionView()
        initPageViewController()
        initScreenEdgePanGesture()
    }
    
    @IBAction func panGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .ended {
            pageViewControllerDelegate?.goBack()
        }
    }
    
    private func initPageIconCollectionView() {
        
        pageIconCollectionView.set(topViewControllerDelegate: self)
    }
    
    private func initPageViewController() {
        let vc = children.first(where: { $0 is PageViewControllerDelegate }) as? PageViewController
        vc?.set(topViewControllerDelegate: self)
    }
    
    private func initScreenEdgePanGesture() {
        screenEdgePanGesture.edges = .left
    }
}

extension TopViewController: TopViewControllerDelegate {
    func select(index: Int) {
        pageViewControllerDelegate?.selectPage(index: index)
    }
    
    func add() {
        pageViewControllerDelegate?.addLastPage()
    }
    
    func updateThumbnail(image: UIImage?, index: Int) {
        pageIconCollectionView.updateThumbnail(image: image, index: index)
    }
    
    func update(title: String, index: Int) {
        pageIconCollectionView.update(title: title, index: index)
    }
}

protocol TopViewControllerDelegate: AnyObject {
    func select(index: Int)
    func add()
    func updateThumbnail(image: UIImage?, index: Int)
    func update(title: String, index: Int)
}
