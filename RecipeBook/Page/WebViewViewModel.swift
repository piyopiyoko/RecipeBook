//
//  WebViewViewModel.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/11/04.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WebViewViewModel: SavePictureProtocol, OperationFavoriteProtocol {
    
    var isFavoriteObserver: Observable<Bool> { isFavoriteRelay.asObservable() }
    var isFavorite: Bool { isFavoriteRelay.value }
    private let isFavoriteRelay = BehaviorRelay<Bool>(value: false)
    
    func checkFavorite(url: URL?) {
        guard let urlString = url?.absoluteString else { return }
        isFavoriteRelay.accept(loadFavorite().contains { $0.url == urlString })
    }
    
    func savePicture(image: UIImage?, url: String?, title: String?) {
        guard let image = image,
            let path = save(image: image, updatePath: nil)
            else { return }
        insertDB(path: path, url: url, title: title)
    }
    
    func deleteFavorite(url: URL?) {
        guard let url = url?.absoluteString else { return }
        if deleteFavorite(url: url) {
            isFavoriteRelay.accept(false)
        }
    }
    
    private func insertDB(path: String, url: String?, title: String?) {
        guard let url = url,
            let title = title else { return }
        if insertFavorite(url: url, title: title, imgPath: path) {
            isFavoriteRelay.accept(true)
        }
    }
}
