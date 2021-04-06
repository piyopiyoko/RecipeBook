//
//  WebViewController.swift
//  RecipeBook
//
//  Created by Aimi Itagaki on 2020/02/27.
//  Copyright © 2020 Aimi Itagaki. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift
import RxWebKit

class WebViewController: UIViewController, SavePictureProtocol, OperationFavoriteProtocol {
    
    var loadUrl: String?
    var closeObserve: Observable<Bool> { return closeRelay.asObservable() }
    weak var loadFavoriteProtocol: LoadFavoriteProtocol?

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    private let disposeBag = DisposeBag()
    private let closeRelay = PublishRelay<Bool>()
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: URL(string: loadUrl ?? "https://www.google.com/")!))
        setupProgressView()
        setupBackButton()
        setupForwardButton()
        setupReload()
        becomeActive()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTimer()
    }
    
    @IBAction func tapClose(_ sender: Any) {
        closeRelay.accept(true)
    }

    @IBAction func tapFavorite(_ sender: Any) {
        takeScreenShot()
    }
    
    private func takeScreenShot() {
        webView.takeSnapshot(with: nil, completionHandler: { [weak self] (image, error) in
            guard let image = image,
                let path = self?.save(image: image, updatePath: nil)
                else { return }
            self?.insertDB(path: path)
        })
    }
    
    private func insertDB(path: String) {
        guard let url = webView.url?.absoluteString,
            let title = webView.title else { return }
        if insertFavorite(url: url, title: title, imgPath: path) {
            favoriteButton.tintColor = R.color.favoriteColor()
        }
    }
    
    @IBAction func tapFavoriteList(_ sender: Any) {
        guard let vc = FavoriteListViewController.initFavoriteListViewController(
            loadFavoriteProtocol: loadFavoriteProtocol) else { return }
        present(vc, animated: true, completion: nil)
    }
    
    private func setupProgressView() {
        webView.rx.estimatedProgress.asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] value in
                self?.progressView.progress = Float(value)
            }).disposed(by: disposeBag)
        
        webView.rx.loading.asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isLoading in
                self?.progressView.isHidden = !isLoading
                self?.initFavoriteButton()
            }).disposed(by: disposeBag)
    }
    
    private func setupBackButton() {
        webView.rx.canGoBack.asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] canGoBack in
                self?.leftButton.isEnabled = canGoBack
            }).disposed(by: disposeBag)
        
        leftButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.webView.goBack()
            }).disposed(by: disposeBag)
    }
    
    private func setupForwardButton() {
        
        webView.rx.canGoForward.asDriver(onErrorJustReturn: false)
        .drive(onNext: { [weak self] canGoForward in
            self?.rightButton.isEnabled = canGoForward
        }).disposed(by: disposeBag)
        
        rightButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.webView.goForward()
            }).disposed(by: disposeBag)
    }
    
    private func setupReload() {
        reloadButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.webView.reload()
            }).disposed(by: disposeBag)
    }
    
    private func setupTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: false, block: {_ in
            UIApplication.shared.isIdleTimerDisabled = false
        })
    }
    
    private func becomeActive() {
        NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification).subscribe(onNext: {[weak self] _ in
            self?.setupTimer()
            }).disposed(by: disposeBag)
    }
    
    private func initFavoriteButton() {
        favoriteButton.tintColor = checkFavorite() ? R.color.favoriteColor() : UIColor.gray
    }
    
    private func checkFavorite() -> Bool {
        guard let url = webView.url?.absoluteString else { return false }
        return loadFavorite().contains { $0.url == url }
    }
}

