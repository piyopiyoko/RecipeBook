//
//  FavoriteListCellViewModel.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/10/21.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import Foundation

class FavoriteListCellViewModel: OperationFavoriteProtocol {
    
    var url: String? = nil
    
    func deleteFavorite() {
        guard let url = url else { return }
        _ = deleteFavorite(url: url)
    }
}
