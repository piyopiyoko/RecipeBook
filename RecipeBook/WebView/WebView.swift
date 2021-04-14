//
//  WebView.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2021/04/12.
//  Copyright © 2021 Aimi Itagaki. All rights reserved.
//

import WebKit
import RxSwift

final class WebView: WKWebView {
    
    private var scrollBeginPosY: CGFloat?
    private let disposeBag = DisposeBag()
    private var operationPageViewController: OperationPageViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSelf()
    }
    
    func set(operationPageViewController: OperationPageViewController?) {
        self.operationPageViewController = operationPageViewController
    }
    
    private func initSelf() {
        initScroll()
    }
    
    private func initScroll() {
        
        scrollView.rx.willBeginDragging
            .subscribe(onNext: { [weak self] in
                self?.scrollBeginPosY = self?.scrollView.contentOffset.y
            })
            .disposed(by: disposeBag)
        
        scrollView.rx.didScroll
            .subscribe(onNext: { [weak self] in
                self?.checkScroll()
            })
            .disposed(by: disposeBag)
    }
    
    private func checkScroll() {
        operationPageViewController?.setPageIconCollectionView(isHidden: scrollView.contentOffset.y - (scrollBeginPosY ?? 0) > 0)
    }
}
