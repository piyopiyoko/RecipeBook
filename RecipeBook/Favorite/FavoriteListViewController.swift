//
//  FavoriteListViewController.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/07/02.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteListViewController: UIViewController {
    
    weak var operationPageViewController: OperationPageViewController?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = FavoriteViewModel()
    private let disposeBag = DisposeBag()
    
    static func initFavoriteListViewController(operationPageViewController: OperationPageViewController?) -> UINavigationController? {
        guard let nc = R.storyboard.main.favoriteNavigationController(),
            let vc = nc.topViewController as? FavoriteListViewController else { return nil }
        vc.operationPageViewController = operationPageViewController
        return nc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        viewModel.load()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        
        let nib = UINib(nibName: "FavoriteListCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        viewModel.listDriver.drive(collectionView.rx.items(cellIdentifier: "cell", cellType: FavoriteListCell.self)) { (row, element, cell) in
            cell.setup(data: element, favoriteListViewControllerDelegate: self)
        }.disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
        .subscribe(onNext: { [weak self] indexPath in
            self?.load(index: indexPath.row)
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    private func load(index: Int) {
        operationPageViewController?.loadFavorite(url: viewModel.urlList[index])
    }
    
    @IBAction func tapClose(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension FavoriteListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - 10 * 4) / 3
        let height = width * 1.5
        return CGSize(width: width, height: height)
    }
}

extension FavoriteListViewController: FavoriteListViewControllerDelegate {
    func reload() {
        viewModel.load()
        collectionView.reloadData()
    }
}
