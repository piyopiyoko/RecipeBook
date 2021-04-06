//
//  OperationPageViewController.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/09/09.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import Foundation

protocol OperationFavoriteProtocol {
    func loadFavorite() -> [FavoriteModel]
    func insertFavorite(url: String, title: String, imgPath: String) -> Bool
    func deleteFavorite(url: String) -> Bool
}

extension OperationFavoriteProtocol {
    func loadFavorite() -> [FavoriteModel] {
        let coreData = CoreDataRepository()
        let list: [FavoriteModel] = coreData.load(entityName: "Favorite")
        return list
    }
    
    func insertFavorite(url: String, title: String, imgPath: String) -> Bool {
        let coreData = CoreDataRepository()
        return coreData.insert(entityName: "Favorite",
                                params: (key: "url", value: url),
                                (key: "title", value: title),
                                (key: "imgPath", value: imgPath))
    }
    
    func deleteFavorite(url: String) -> Bool {
        let coreData = CoreDataRepository()
        return coreData.delete(entityName: "Favorite", queryValue: ["url == %@": url])
    }
}
