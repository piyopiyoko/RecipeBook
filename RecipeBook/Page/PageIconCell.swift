//
//  PageIconCell.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2021/03/31.
//  Copyright © 2021 Aimi Itagaki. All rights reserved.
//

import UIKit

class PageIconCell: UICollectionViewCell, LoadPictureProtocol {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initImageView()
    }
    
    func setup(data: PageIconCollectionViewModel.IconData) {
        switch data.cellType {
        case .page:
            imageView.image = crop(image: data.image)
            imageView.layer.borderWidth = 1
        case .plus:
            imageView.image = R.image.plus()
            imageView.layer.borderWidth = 0
        }
        titleLabel.text = data.title
    }
    
    private func initImageView() {
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = R.color.lightGray()?.cgColor
    }
    
    private func setupImageView(path: String) {
        guard let data = load(path: path) else { return }
        imageView.image = UIImage(data: data)
    }
    
    private func crop(image: UIImage?) -> UIImage? {
        guard let img = image?.cgImage,
        let cropImage = img.cropping(to: CGRect(x: 0, y: img.width / 4, width: img.width, height: img.width))
            else { return nil }
        
        return UIImage(cgImage: cropImage)
    }
}
