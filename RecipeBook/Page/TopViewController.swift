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
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
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
    
    func remove(index: Int) {
        pageIconCollectionView.remove(index: index)
    }
    
    func update(image: UIImage?, title: String?, index: Int) {
        pageIconCollectionView.update(image: image, title: title, index: index)
    }
    
    func addLast() {
        pageIconCollectionView.addLastCell()
    }
    
    func setPageIconCollectionView(isHidden: Bool) {
        pageIconCollectionView.isHidden = isHidden
        
        collectionViewHeight.constant = isHidden ? 0 : 100
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
}

protocol TopViewControllerDelegate: AnyObject {
    func select(index: Int)
    func add()
    func remove(index: Int)
    func update(image: UIImage?, title: String?, index: Int)
    func addLast()
    func setPageIconCollectionView(isHidden: Bool)
}
