//
//  PageViewController.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/07/09.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import UIKit
import RxSwift

class PageViewController: UIPageViewController {
    private var pages = [UIViewController]()
    private let disposeBag = DisposeBag()
    private weak var topViewControllerDelegate: TopViewControllerDelegate?
    
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPage()
        dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func set(topViewControllerDelegate: TopViewControllerDelegate?) {
        self.topViewControllerDelegate = topViewControllerDelegate
    }
    
    private func setDispPage(vc: UIViewController, direction: UIPageViewController.NavigationDirection = .forward) {
        
        setViewControllers([vc], direction: direction, animated: true, completion: nil)
    }
    
    private func getPage(url: String?) -> UIViewController? {
        guard let nc = WebViewController.initWebViewController(tag: pages.count, url: url, operationPageViewController: self) else { return nil }
        return nc
    }
    
    private func deletePage(index: Int) {
        if pages.count <= 1 { return }
        movePage(index: index)
        pages.remove(at: index)
        resetAllTag()
    }
    
    private func movePage(index: Int) {
        if index < pages.count - 1 {
            setDispPage(vc: pages[index + 1])
        }
        else if index > 0 {
            setDispPage(vc: pages[index - 1])
        }
        else {
            addPage()
            setDispPage(vc: pages[1])
        }
    }
    
    private func addPage(url: String? = nil) {
        guard let vc = getPage(url: url) else { return }
        pages += [vc]
        setDispPage(vc: pages[pages.count - 1])
    }
    
    private func resetAllTag() {
        for (i, vc) in pages.enumerated() {
            vc.view.tag = i
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        let index = viewController.view.tag
//        guard let nc = pages[index] as? UINavigationController,
//              let vc = nc.topViewController as? WebViewController else { return nil}
//        vc.goBack()
        return nil
//        let index = viewController.view.tag
//        if index > 0 {
//            return pages[index - 1]
//        } else {
//            return nil
//        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag
        guard let nc = pages[index] as? UINavigationController,
              let vc = nc.topViewController as? WebViewController else { return nil}
        vc.goForword()
        return nil
//        let index = viewController.view.tag
//        if index >= pages.count - 1 {
//            addPage()
//        }
//        return pages[index + 1]
    }
}

extension PageViewController: OperationPageViewController {
    func loadFavorite(url: String) {
        topViewControllerDelegate?.addLast()
        addPage(url: url)
    }
    
    func closePage(index: Int) {
        self.deletePage(index: index)
        topViewControllerDelegate?.remove(index: index)
    }
    
    func update(image: UIImage?, title: String?, index: Int) {
        topViewControllerDelegate?.update(image: image, title: title, index: index)
    }
    
    func setPageIconCollectionView(isHidden: Bool) {
        topViewControllerDelegate?.setPageIconCollectionView(isHidden: isHidden)
    }
}

extension PageViewController: PageViewControllerDelegate {
    
    func addLastPage() {
        addPage()
    }
    
    func selectPage(index: Int) {
        if index == currentIndex { return }
        setDispPage(vc: pages[index], direction: index > currentIndex ? .forward : .reverse)
    }
    
    func goBack() {
        guard let nc = viewControllers?.first as? UINavigationController,
              let vc = nc.topViewController as? WebViewController else { return }
        vc.goBack()
    }
}

protocol PageViewControllerDelegate {
    func addLastPage()
    func selectPage(index: Int)
    func goBack()
}
