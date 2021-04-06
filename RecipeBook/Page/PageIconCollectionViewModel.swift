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
    
    func updateThumbnail(image: UIImage?, index: Int) {
        var data = dataList.value
        data[index].image = image
        dataList.accept(data)
    }
    
    func update(title: String, index: Int) {
        var data = dataList.value
        data[index].title = title
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
