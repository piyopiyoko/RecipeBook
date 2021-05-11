//
//  FavoriteListCell.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/07/02.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import UIKit
import RxSwift

class FavoriteListCell: UICollectionViewCell, LoadPictureProtocol {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIImageView!
    
    private weak var favoriteListViewControllerDelegate: FavoriteListViewControllerDelegate?
    
    private let viewModel = FavoriteListCellViewModel()
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initDeleteButton()
        initImageView()
    }
    
    func setup(data: FavoriteModel, favoriteListViewControllerDelegate: FavoriteListViewControllerDelegate) {
        titleLabel.text = data.title
        setupImageView(path: data.imgPath)
        viewModel.url = data.url
        self.favoriteListViewControllerDelegate = favoriteListViewControllerDelegate
    }
    
    private func setupImageView(path: String) {
        guard let data = load(path: path) else { return }
        imageView.image = UIImage(data: data)
    }
    
    private func initDeleteButton() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.bind(onNext: { [weak self] _ in
            self?.deleteFavorite()
            })
            .disposed(by: disposeBag)
        deleteButton.isUserInteractionEnabled = true
        deleteButton.addGestureRecognizer(tapGesture)
    }
    
    private func initImageView() {
        let cellSize = (UIScreen.main.bounds.width - 10 * 4) / 3
        imageView.layer.cornerRadius = cellSize / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = R.color.lightGray()?.cgColor
    }
    
    private func deleteFavorite() {
        self.viewModel.deleteFavorite()
        self.favoriteListViewControllerDelegate?.reload()
    }
}
