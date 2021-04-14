//
//  PageIconCollectionViewModel.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2021/03/31.
//  Copyright © 2021 Aimi Itagaki. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PageIconCollectionViewModel {
    
    var dataList = BehaviorRelay<[IconData]>(value: [IconData(cellType: .page, image: nil)])
    let displayList = BehaviorRelay<[IconData]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    
    init() {
        initDisplayList()
    }
    
    func addIconData() {
        dataList.accept(dataList.value + [IconData(cellType: .page, image: nil)])
    }
    
    func update(image: UIImage?, title: String?, index: Int) {
        var data = dataList.value
        data[index].image = image
        data[index].title = title
        dataList.accept(data)
    }
    
    func remove(index: Int) {
        if index >= dataList.value.count { return }
        var data = dataList.value
        data.remove(at: index)
        dataList.accept(data)
    }
    
    func addLast() {
        var data = dataList.value
        data.append(IconData(cellType: .page))
        dataList.accept(data)
    }
    
    private func initDisplayList() {
        dataList.subscribe(onNext: { [weak self] list in
            self?.displayList.accept(list + [IconData(cellType: .plus)])
        }).disposed(by: disposeBag)
    }
    
    struct IconData {
        let cellType: CellType
        var image: UIImage?
        var title: String?
    }
    
    enum CellType {
        case page
        case plus
    }
}
