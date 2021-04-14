//
//  PageIconCollectionView.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2021/03/31.
//  Copyright © 2021 Aimi Itagaki. All rights reserved.
//

import UIKit
import RxSwift

class PageIconCollectionView: UICollectionView {
    
    private var viewModel = PageIconCollectionViewModel()
    private let disposeBag = DisposeBag()
    private weak var topViewControllerDelegate: TopViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        register(UINib(nibName: "PageIconCell", bundle: nil), forCellWithReuseIdentifier: "PageIconCell")
        initCollectionViewData()
        initSelectCollectionView()
    }
    
    func set(topViewControllerDelegate: TopViewControllerDelegate?) {
        self.topViewControllerDelegate = topViewControllerDelegate
    }
    
    func update(image: UIImage?, title: String?, index: Int) {
        viewModel.update(image: image, title: title, index: index)
    }
    
    func remove(index: Int) {
        viewModel.remove(index: index)
    }
    
    func addLastCell() {
        viewModel.addLast()
    }
    
    private func initCollectionViewData() {
        self.viewModel.displayList.asDriver(onErrorJustReturn: [])
            .drive(rx.items(cellIdentifier: "PageIconCell", cellType: PageIconCell.self)) { (_, element, cell) in
                cell.setup(data: element)
            }.disposed(by: self.disposeBag)
    }
    
    private func initSelectCollectionView() {
        rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.actionCell(index: indexPath.row)
            }).disposed(by: self.disposeBag)
    }
    
    private func actionCell(index: Int) {
        if index == viewModel.displayList.value.count - 1 {
            addCell()
        } else {
            topViewControllerDelegate?.select(index: index)
        }
    }
    
    private func addCell() {
        topViewControllerDelegate?.add()
        viewModel.addIconData()
    }
}
