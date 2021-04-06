//
//  WebViewListCell.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2021/03/30.
//  Copyright © 2021 Aimi Itagaki. All rights reserved.
//

import UIKit

class WebViewListCell: UICollectionViewCell, LoadPictureProtocol {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(data: WebViewModel) {
        setupImageView(path: data.imgPath)
        titleLabel.text = data.title
    }
    
    private func setupImageView(path: String) {
        guard let data = load(path: path) else { return }
        imageView.image = UIImage(data: data)
    }
}
