//
//  FavoriteViewModel.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/08/05.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import RxCocoa
import RxSwift

class FavoriteViewModel: OperationFavoriteProtocol {
    
    var listDriver: Driver<[FavoriteModel]> { return listRelay.asDriver() }
    var urlList: [String] { return listRelay.value.map { $0.url } }
    private let listRelay = BehaviorRelay<[FavoriteModel]>(value: [])
    
    func load() {
        listRelay.accept(loadFavorite())
    }
}
